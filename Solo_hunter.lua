local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")

local ALLOWED_GAME_ID = 7394964165
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
end

local Window = Fluent:CreateWindow({
    Title = "Solo Hunters | BETA",
    SubTitle = "By VichianHUB",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

local VirtualUser = game:GetService('VirtualUser')
 
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    Setup = Window:AddTab({ Title = "Setup", Icon = "eye" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do

    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nFull auto its work at the cave and jungle map\nIn other map u can walk manually to next stage"
    })

    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function virtualClick(button)
        if button and button:IsA("GuiButton") and button.Visible then
            button.Selectable = true
            button.Active = true
            task.wait(0.01)
            GuiService.SelectedCoreObject = button
            if GuiService.SelectedCoreObject == button then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            else
                GuiService:AddSelectionParent("TempSelection", button.Parent)
                GuiService.SelectedCoreObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
            task.wait(0.1)
            GuiService.SelectedCoreObject = nil
        end
    end

    local function isInDungeon()
        local success, result = pcall(function()
            local pGui = LocalPlayer:WaitForChild("PlayerGui")
            
            -- จุดเช็คที่ 1 & 2: Hud และ DungeonName
            local hud = pGui:FindFirstChild("Hud")
            local dungeonUI = hud and hud:FindFirstChild("Dungeon")
            local dungeonName = dungeonUI and dungeonUI:FindFirstChild("DungeonName")
            
            -- จุดเช็คที่ 3: TimeLeft ใน MiniMapGui
            local miniMap = pGui:FindFirstChild("MiniMapGui")
            local timeLeft = miniMap and miniMap:FindFirstChild("ScreenFrame") 
                and miniMap.ScreenFrame:FindFirstChild("ButtonsTopRight") 
                and miniMap.ScreenFrame.ButtonsTopRight:FindFirstChild("TimeLeft")

            -- ถ้าจุดใดจุดหนึ่ง Visible ถือว่าอยู่ในดันเจี้ยน
            local isHudVisible = dungeonUI and dungeonUI.Visible and dungeonName and dungeonName.Visible
            local isTimeLeftVisible = timeLeft and timeLeft.Visible
            
            return isHudVisible or isTimeLeftVisible
        end)
        return success and result
    end

    local gateOptions = {}
    local gateMapping = {}

    local function refreshGateList()
        local rawGates = {}
        gateMapping = {}
        for _, v in pairs(workspace:GetChildren()) do
            pcall(function()
                if v:FindFirstChild("Gate") and v.Gate:FindFirstChild("PortalData") then
                    local portalData = v.Gate.PortalData
                    local title = portalData.DungeonTitle.Label.Text
                    local diff = portalData.Difficulty.Text
                    local powerText = portalData.LevelReq.Text
                    local cleanPower = powerText:gsub(",", "")
                    local powerNum = tonumber(cleanPower:match("%d+")) or 0
                    local fullName = string.format("%s (%s) [%s]", title, diff, powerText:match("[%d,%.]+"))
                    table.insert(rawGates, {
                        FullName = fullName,
                        Title = title,
                        Power = powerNum,
                        Object = v.Gate
                    })
                    gateMapping[fullName] = v.Gate
                end
            end)
        end
        table.sort(rawGates, function(a, b)
            if a.Title == b.Title then
                return a.Power < b.Power
            else
                return a.Title < b.Title
            end
        end)
        gateOptions = {}
        for _, item in ipairs(rawGates) do
            table.insert(gateOptions, item.FullName)
        end
        if #gateOptions == 0 then
            table.insert(gateOptions, "No Gates Found")
        end
        return gateOptions
    end

    refreshGateList()

    task.spawn(function()
        while true do
            refreshGateList()
            task.wait(10)
        end
    end)

    local GateSelect = Tabs.Setup:AddDropdown("GateSelect", {
        Title = "Select Gate (Sorted by Power)",
        Values = gateOptions,
        Multi = false,
        Default = "",
    })

    local AutoGateToggle = Tabs.Setup:AddToggle("AutoGateToggle", {
        Title = "Auto Teleport & Start Gate", 
        Default = false 
    })

    AutoGateToggle:OnChanged(function()
        if Options.AutoGateToggle.Value then
            task.spawn(function()
                while Options.AutoGateToggle.Value do
                    if isInDungeon() then
                        while isInDungeon() and Options.AutoGateToggle.Value do
                            task.wait(2)
                        end
                    end

                    local selectedName = Options.GateSelect.Value
                    local targetGate = gateMapping[selectedName]
                    
                    if targetGate and not isInDungeon() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetGate.CFrame * CFrame.new(0, 5, 0)
                        local gateGui = LocalPlayer.PlayerGui:FindFirstChild("Gate")
                        local gateButtons = gateGui and gateGui:FindFirstChild("Buttons")

                        task.wait(1)

                        if gateButtons then
                            if gateButtons:FindFirstChild("GateEnterBtn") and gateButtons.GateEnterBtn.Visible then
                                virtualClick(gateButtons.GateEnterBtn)
                                task.wait(1)
                            end

                            if gateButtons:FindFirstChild("StartGateBtn") and gateButtons.StartGateBtn.Visible then
                                virtualClick(gateButtons.StartGateBtn)
                                task.wait(1)
                            end

                            task.wait(5)
                        end

                        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                        if mainGui and mainGui:FindFirstChild("StartBtn") and mainGui.StartBtn.Visible then
                            virtualClick(mainGui.StartBtn)
                            task.wait(0.5)
                        end

                    end
                    task.wait(1)
                end
            end)
        end
    end)

---------------------------------------------------------------------------------------------------

    -- 1. สร้างตาราง Hotbar 1-8
    local hotbarOptions = {"1", "2", "3", "4", "5", "6", "7", "8"}

    -- 2. สร้าง UI Components
    local HotbarSelect = Tabs.Setup:AddDropdown("HotbarSelect", {
        Title = "Select Hotbar Slot",
        Values = hotbarOptions,
        Multi = false,
        Default = "1",
    })

    local AutoEquipToggle = Tabs.Setup:AddToggle("AutoEquipToggle", {
        Title = "Auto Equip Weapon",
        Default = false 
    })

    -- 3. ฟังก์ชันหลักสำหรับ Auto Equip
    local function startAutoEquip()
        while Options.AutoEquipToggle.Value do
            local slotIndex = Options.HotbarSelect.Value
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            
            pcall(function()
                -- อ้างอิง Path ตามที่คุณระบุ
                local hotbarPath = playerGui.BackpackGui.Backpack.Hotbar
                local targetSlot = hotbarPath:FindFirstChild(slotIndex)
                
                if targetSlot then
                    -- เช็คว่ามี UIStroke หรือไม่
                    local isEquipped = targetSlot:FindFirstChild("UIStroke")
                    
                    if not isEquipped then
                        -- ถ้าไม่มี UIStroke แสดงว่ายังไม่ได้ถือ ให้กดคลิก
                        virtualClick(targetSlot)
                    end
                end
            end)
            
            task.wait(0.5) -- เช็คทุกๆ 0.5 วินาที (ปรับได้ตามความเหมาะสม)
        end
    end

    -- 4. เชื่อมต่อ Toggle กับฟังก์ชัน
    AutoEquipToggle:OnChanged(function()
        if Options.AutoEquipToggle.Value then
            task.spawn(startAutoEquip)
        end
    end)

----------------------------------------------------------------------------------------------------
    local TweenService = game:GetService("TweenService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = game.Players.LocalPlayer

    -- [[ ตั้งค่าระยะการทำงาน ]]
    local maxTargetDist = 2000  
    local maxLootDist = 200    
    local maxPortalDist = 3000  

    -- [ ฟังก์ชันเช็คสถานะดันเจี้ยน ]
    local function isInDungeon()
        local success, result = pcall(function()
            local pGui = LocalPlayer:WaitForChild("PlayerGui")
            local hud = pGui:FindFirstChild("Hud")
            local dungeonUI = hud and hud:FindFirstChild("Dungeon")
            local dungeonName = dungeonUI and dungeonUI:FindFirstChild("DungeonName")
            local miniMap = pGui:FindFirstChild("MiniMapGui")
            local timeLeft = miniMap and miniMap:FindFirstChild("ScreenFrame") 
                and miniMap.ScreenFrame:FindFirstChild("ButtonsTopRight") 
                and miniMap.ScreenFrame.ButtonsTopRight:FindFirstChild("TimeLeft")

            return (dungeonUI and dungeonUI.Visible and dungeonName and dungeonName.Visible) or (timeLeft and timeLeft.Visible)
        end)
        return success and result
    end

    local function HandleChests()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp or not humanoid or humanoid.Health <= 0 then return false end

        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:find("Chest") then
                -- เช็ค Billboard และความเป็นเจ้าของ
                local root = v:FindFirstChild("Root")
                local attachment = root and root:FindFirstChild("Attachment")
                local billboard = attachment and attachment:FindFirstChild("BillboardGui")
                local ownerLabel = billboard and billboard:FindFirstChild("OwnersName")

                if billboard and billboard.Enabled and ownerLabel then
                    if ownerLabel.Text:find(LocalPlayer.Name) or ownerLabel.Text:find(LocalPlayer.DisplayName) then
                        
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt") or v:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            -- [1] เตรียมตัวละคร: ปิดแรงโน้มถ่วงกันเด้ง
                            hrp.Velocity = Vector3.new(0, 0, 0)
                            local targetCFrame = v:GetPivot() * CFrame.new(0, 3, 0) -- อยู่เหนือกองสมบัติเล็กน้อย

                            -- [2] วาร์ปไปที่กล่องและล็อคตำแหน่งทันที
                            hrp.CFrame = targetCFrame
                            
                            -- [3] ปรับ Prompt ให้กดติดทันที (Instant)
                            prompt.HoldDuration = 0
                            
                            -- [4] วนลูปกดจนกว่ากล่องจะหายไป
                            local tTimeout = tick()
                            while billboard.Enabled and (tick() - tTimeout < 5) do -- Timeout กันค้าง
                                if not humanoid or humanoid.Health <= 0 then break end
                                
                                -- ล็อคตัวให้นิ่งสนิท ไม่ให้เด้งไปมา
                                hrp.CFrame = targetCFrame
                                hrp.Velocity = Vector3.new(0, 0, 0)

                                -- สั่งกดรัวๆ
                                if fireproximityprompt then
                                    fireproximityprompt(prompt)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait()
                                    prompt:InputHoldEnd()
                                end
                                
                                task.wait(0.05) -- หน่วงเวลานิดเดียวเพื่อให้ระบบเกมรับรู้การกด
                            end
                            
                            return true 
                        end
                    end
                end
            end
        end
        return false
    end

    -- [ ฟังก์ชันวาร์ปไปประตูทางออก ]
    local function HandleExitPortal()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end

        local portal = nil
        local shortestDist = maxPortalDist

        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "OverworldPortal" then
                local pos = v:GetPivot().Position
                local dist = (hrp.Position - pos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    portal = v
                end
            end
        end

        if portal then
            local prompt = portal:FindFirstChildOfClass("ProximityPrompt") or portal:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                local targetCFrame = portal:GetPivot() * CFrame.new(0, 10, 3)
                TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                task.wait(0.35)
                prompt.HoldDuration = 0 
                prompt:InputHoldBegin()
                task.wait(0.2)
                prompt:InputHoldEnd()
                return true
            end
        end
        return false
    end

    -- [[ UI Toggles ]]
    local AutoAttackToggle = Tabs.Setup:AddToggle("AutoAttackToggle", { Title = "Auto Attack (Spamming Click)", Default = false })
    local AutoFarmToggle = Tabs.Setup:AddToggle("AutoFarmToggle", { Title = "Auto Farm (Teleport)", Default = false })
    local AutoChestToggle = Tabs.Setup:AddToggle("AutoChestToggle", { Title = "Auto Open Chest", Default = false })
    local AutoExitToggle = Tabs.Setup:AddToggle("AutoExitToggle", { Title = "Auto Exit Portal", Default = false }) 

    -- [ ฟังก์ชันจัดการการเก็บของ ]
    local function HandleDrops()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local camera = workspace:FindFirstChild("Camera")
        local dropsFolder = camera and camera:FindFirstChild("Drops")
        
        if hrp and dropsFolder and #dropsFolder:GetChildren() > 0 then
            for _, item in ipairs(dropsFolder:GetChildren()) do
                local itemPos = item:GetPivot().Position
                local dist = (hrp.Position - itemPos).Magnitude

                if dist <= maxLootDist then
                    local prompt = item:FindFirstChildOfClass("ProximityPrompt") or item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        local targetCFrame = item:GetPivot()
                        local tween = TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                        tween:Play()
                        tween.Completed:Wait()
                        
                        prompt.HoldDuration = 0 
                        prompt:InputHoldBegin()
                        task.wait(0.05)
                        prompt:InputHoldEnd()
                        task.wait(0.1)
                        return true 
                    end
                end
            end
        end
        return false
    end

    -- [ ฟังก์ชันค้นหามอนสเตอร์ ]
    local function getTarget()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local shortestDist = maxTargetDist 
        local closestNPC = nil
        local mobsFolder = workspace:FindFirstChild("Mobs")
        if mobsFolder then
            for _, v in pairs(mobsFolder:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                local rootPart = v:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart and humanoid.Health > 0 then
                    local dist = (hrp.Position - rootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestNPC = v
                    end
                end
            end
        end
        return closestNPC
    end

    -- [[ Auto Attack ]]
    AutoAttackToggle:OnChanged(function()
        task.spawn(function()
            while Options.AutoAttackToggle.Value do
                if isInDungeon() then
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        end
                    end)
                    task.wait(0.1)
                else
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(1) 
                end
                task.wait()
            end
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end)

    -- [[ ลูปการทำงานหลัก - แก้ไขเงื่อนไขการออกประตูตาม Toggle กล่อง ]]
    AutoFarmToggle:OnChanged(function()
        task.spawn(function()
            while Options.AutoFarmToggle.Value do
                if isInDungeon() then
                    local char = LocalPlayer.Character
                    local humanoid = char and char:FindFirstChild("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if not char or not humanoid or not hrp or humanoid.Health <= 0 then
                        task.wait(1)
                    else
                        pcall(function()
                            local target = getTarget()
                            
                            if target then
                                -- 1. จัดการมอนสเตอร์ก่อนเสมอ
                                local targetHum = target:FindFirstChildOfClass("Humanoid")
                                while Options.AutoFarmToggle.Value and targetHum and targetHum.Health > 0 and target.Parent and isInDungeon() and humanoid.Health > 0 do
                                    local pivot = target:FindFirstChild("Serpent") and target.Serpent:FindFirstChild("HitboxesForSnake") 
                                        and target.Serpent.HitboxesForSnake:FindFirstChildOfClass("BasePart") 
                                        or target:FindFirstChild("HumanoidRootPart")

                                    if pivot then
                                        local targetCFrame = (pivot.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                                        TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                                        hrp.Velocity = Vector3.zero
                                    end
                                    task.wait()
                                end
                            else
                                -- 2. เก็บไอเท็มที่ตก
                                local isLooting = HandleDrops()
                                
                                if not isLooting then 
                                    -- 3. เช็คกล่องสมบัติ
                                    local anyChestLeft = false
                                    if Options.AutoChestToggle.Value then
                                        anyChestLeft = HandleChests()
                                    end

                                    -- 4. การออกจากดันเจี้ยน
                                    if Options.AutoExitToggle.Value then
                                        local canExit = true
                                        if Options.AutoChestToggle.Value and anyChestLeft then
                                            canExit = false -- ยังมีกล่องค้างอยู่ ห้ามออก!
                                        end

                                        if canExit then
                                            -- ตรวจสอบซ้ำอีกรอบเพื่อความชัวร์ (Double Check)
                                            task.wait(0.5) 
                                            local finalCheck = Options.AutoChestToggle.Value and HandleChests()
                                            
                                            if not finalCheck then
                                                -- ถ้าทุกอย่างเคลียร์แล้ว รอ 5 วิแล้วออก
                                                task.wait(5) 
                                                HandleExitPortal()
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                else
                    task.wait(1)
                end
                task.wait(0.1)
            end
        end)
    end)
    
----------------------------------------------------------------------------------------------------
    local Success, Info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)

    local GameName = Success and Info.Name or "Unknown Game"

    Tabs.HSV:AddParagraph({
        Title = "Server Information.",
        Content = "\nGame Name : " .. GameName .. "\nGame ID : " .. game.PlaceId .. "\nServer ID : " .. game.JobId
    })

    Tabs.HSV:AddButton({
        Title = "HOP Server [Faster]",
        Description = "Click To Teleport Random Server",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")

            local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local Server, Next = nil, nil
            local function ListServers(cursor)
                local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
                return HttpService:JSONDecode(Raw)
            end
            repeat
                local Servers = ListServers(Next)
                if Servers.data and #Servers.data > 0 then
                    Server = Servers.data[math.random(1, math.min(#Servers.data, math.floor(#Servers.data / 3)))]
                else
                    local success, err = pcall(function()
                        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
                    end)
                    break
                end
                Next = Servers.nextPageCursor
            until Server

            if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
            end
        end
    })

    if not isfolder("VichianHUB") then
        makefolder("VichianHUB")
    end

    local FILE_PART = "VichianHUB/log_server_list.txt"
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")

    local function GetLoggedServers()
        if isfile(FILE_PART) then
            local content = readfile(FILE_PART)
            return HttpService:JSONDecode(content) or {}
        end
        return {}
    end

    local function SaveServerToLog(serverId)
        local logged = GetLoggedServers()
        logged[serverId] = true
        writefile(FILE_PART, HttpService:JSONEncode(logged))
    end

    local ServerList = Tabs.HSV:AddDropdown("SelectServer", {
        Title = "HOP Selected (Players/Max)",
        Description = "Select To HOP Server",
        Values = {},
        Multi = false,
        Default = "None",
    })

    local CurrentServers = {}

    local function UpdateServerDropdown()
        local ServerTable = {}
        local ServerDataMap = {}
        local loggedServers = GetLoggedServers()
        
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        
        local success, result = pcall(function()
            local raw = game:HttpGet(url)
            return HttpService:JSONDecode(raw)
        end)

        if success and result.data then
            for _, s in pairs(result.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers and not loggedServers[s.id] then
                    local label = "Players: " .. s.playing .. "/" .. s.maxPlayers .. " [" .. s.id:sub(1,8) .. "]"
                    table.insert(ServerTable, label)
                    ServerDataMap[label] = s.id
                end
            end
        end

        ServerList:SetValues(ServerTable)
        CurrentServers = ServerDataMap
    end

    Tabs.HSV:AddButton({
        Title = "Clear Server Log",
        Description = "Clear the server log to appere in dropdown again.",
        Callback = function()
            Window:Dialog({
                Title = "Clear All Server Log",
                Content = "Confirm to clear all server logs.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            if isfile(FILE_PART) then
                                delfile(FILE_PART)
                                print("Cleared server logs!")
                                UpdateServerDropdown()
                            end
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled")
                        end
                    }
                }
            })
        end
    })

    ServerList:OnChanged(function(Value)
        local targetServerId = CurrentServers[Value]
        if targetServerId then
            Fluent:Notify({
                Title = "Teleporting to ",
                Content = targetServerId,
                Duration = 3
            })
            print("Saving to log and teleporting to:", targetServerId)
            SaveServerToLog(targetServerId)
            wait(3)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, game.Players.LocalPlayer)
        end
    end)

    task.spawn(function()
        while true do
            local count = 0
            for _ in pairs(CurrentServers) do count = count + 1 end
            if count == 0 then
                Fluent:Notify({
                    Title = "No servers available in list",
                    Content = "fetching new data...",
                    Duration = 3
                })
                UpdateServerDropdown()
            end
            
            task.wait(5)
        end
    end)

end


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})


InterfaceManager:SetFolder("VichianHUB")
SaveManager:SetFolder("VichianHUB/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
