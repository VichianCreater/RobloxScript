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
        Content = "\nThis is a beta test script.\nFull auto its work at all gate\n\n warning: if not work at first time you can exit gate with left top screen and try again"
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

                            task.wait(15)
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

    local function HandleChestAndExit()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp or not humanoid or humanoid.Health <= 0 then return false end

        local function getAllMyChests()
            local myChests = {}
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("chest") then
                    local root = v:FindFirstChild("Root")
                    if root then
                        -- วนลูปหาในบรรดาลูกๆ ทั้งหมดของ Root (เผื่อมี Attachment หลายอัน)
                        for _, child in pairs(root:GetChildren()) do
                            local billboard = child:FindFirstChild("BillboardGui")
                            if billboard and billboard.Enabled then
                                local ownerLabel = billboard:FindFirstChild("OwnersName")
                                if ownerLabel then
                                    -- เช็คชื่อเราบนป้าย
                                    if ownerLabel.Text:find(LocalPlayer.Name) or ownerLabel.Text:find(LocalPlayer.DisplayName) then
                                        table.insert(myChests, v)
                                        break -- เจอป้ายเราในกล่องนี้แล้ว ไปกล่องถัดไปได้เลย
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return myChests
        end

        -- เริ่มการตรวจสอบ 3 รอบตามโค้ดต้นฉบับ
        for i = 1, 1 do
            local chestsToOpen = getAllMyChests()
            
            if #chestsToOpen > 0 then
                print(string.format("Attempt %d: Found %d chest(s). Opening...", i, #chestsToOpen))
                
                for _, currentChest in ipairs(chestsToOpen) do
                    local prompt = currentChest:FindFirstChildOfClass("ProximityPrompt") or currentChest:FindFirstChildWhichIsA("ProximityPrompt", true)
                    
                    -- สแกนหา Billboard อีกครั้งเพื่อใช้เป็นเงื่อนไขในการลูปเปิด
                    local billboard = nil
                    for _, descendant in pairs(currentChest:GetDescendants()) do
                        if descendant:IsA("BillboardGui") and descendant.Enabled then
                            billboard = descendant
                            break
                        end
                    end

                    if prompt and billboard then
                        local targetCFrame = currentChest:GetPivot() * CFrame.new(0, 3, 0)
                        prompt.HoldDuration = 0
                        
                        local chestTimeout = tick()
                        -- ลูปจนกว่า Billboard จะหายไป (กล่องถูกเปิดสำเร็จ)
                        while billboard.Parent and billboard.Enabled and (tick() - chestTimeout < 5) do
                            if not humanoid or humanoid.Health <= 0 then break end
                            
                            hrp.Velocity = Vector3.zero
                            hrp.CFrame = targetCFrame
                            
                            -- เลือกใช้วิธีเปิดที่รองรับกับ Exploit ส่วนใหญ่
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                prompt:InputHoldBegin()
                                task.wait()
                                prompt:InputHoldEnd()
                            end
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0) 
            else
                print(string.format("Attempt %d: No chests found yet.", i))
                task.wait(1.5)
            end
        end

        print("All your chests have been opened.")

        -- ตรวจสอบจำนวนกล่องล่าสุดก่อนเข้า Portal
        local finalCheck = getAllMyChests()
        if Options.AutoExitToggle.Value and #finalCheck == 0 then
            local portal = nil
            local shortestDist = maxPortalDist or 5000

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
                print("All chests cleared. Proceeding to Exit Portal.")
                local prompt = portal:FindFirstChildOfClass("ProximityPrompt") or portal:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    task.wait(5)
                    local targetCFrame = portal:GetPivot() * CFrame.new(0, 10, 3)
                    local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    tween:Play()
                    task.wait(0.35)
                    prompt.HoldDuration = 0 
                    prompt:InputHoldBegin()
                    task.wait(0.2)
                    prompt:InputHoldEnd()
                end
            end
        end

        return true
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
        end)
    end)

    local BossTable = {"roke", "centipedeboss", "spiderking", "serpent"}

    local function isBoss(name)
        if not name then return false end
        local lowerName = name:lower()
        for _, bossName in ipairs(BossTable) do
            if lowerName:find(bossName) then return true end
        end
        return false
    end

    local function getTarget()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local mobsFolder = workspace:FindFirstChild("Mobs")
        if not mobsFolder then return nil end

        local closestNormal = nil
        local shortestDistNormal = maxTargetDist
        local closestBoss = nil
        local shortestDistBoss = maxTargetDist

        for _, v in pairs(mobsFolder:GetChildren()) do
            local humanoid = v:FindFirstChildOfClass("Humanoid")
            local rootPart = v:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart and humanoid.Health > 0 then
                local dist = (hrp.Position - rootPart.Position).Magnitude
                if isBoss(v.Name) then
                    if dist < shortestDistBoss then
                        shortestDistBoss = dist
                        closestBoss = v
                    end
                else
                    if dist < shortestDistNormal then
                        shortestDistNormal = dist
                        closestNormal = v
                    end
                end
            end
        end
        return closestNormal or closestBoss
    end

    local function findMyMapObject()
        if not isInDungeon() then return nil end
        local mapFolder = workspace:FindFirstChild("Map")
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not mapFolder or not hrp then return nil end
        for _, folder in ipairs(mapFolder:GetChildren()) do
            for _, actualMap in ipairs(folder:GetChildren()) do
                local mapPart = actualMap:FindFirstChildWhichIsA("BasePart", true)
                if mapPart and (hrp.Position - mapPart.Position).Magnitude < 2000 then return actualMap end
            end
        end
        return nil
    end

    AutoFarmToggle:OnChanged(function()
        task.spawn(function()
            local currentRoomIndex = 0
            local FirstTimeBreakWall = false
            local lastGateCheck = tick()
            while Options.AutoFarmToggle.Value do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChild("Humanoid")

                if isInDungeon() then
                    if hrp and humanoid and humanoid.Health > 0 then
                        pcall(function()
                            local target = getTarget()
                            local mapObj = findMyMapObject()
                            
                            if target then
                                local targetHum = target:FindFirstChildOfClass("Humanoid")
                                local isTargetBoss = isBoss(target.Name)
                                if isTargetBoss then
                                    FirstTimeBreakWall = true
                                end

                                while Options.AutoFarmToggle.Value and targetHum and targetHum.Health > 0 and target.Parent and humanoid.Health > 0 do
                                    if isTargetBoss then
                                        local interruptCheck = getTarget()
                                        if interruptCheck and not isBoss(interruptCheck.Name) then
                                            break 
                                        end
                                    end

                                    local pivot = target:FindFirstChild("HumanoidRootPart")
                                    if pivot then
                                        if target.Name == "Serpent" then
                                            local serpent = workspace.Mobs.Serpent:FindFirstChild("HitboxesForSnake")
                                            if serpent then
                                                local targetCFrame = (pivot.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                                                TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = serpent:GetPivot()}):Play()
                                                hrp.Velocity = Vector3.zero
                                            end
                                        else
                                            local targetCFrame = (pivot.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                                            TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                                            hrp.Velocity = Vector3.zero
                                        end
                                    end

                                    if isTargetBoss and tick() - lastGateCheck > 5.5 then
                                        if FirstTimeBreakWall then
                                            local nearestGate = nil
                                            local minDistance = 5000

                                            for _, v in pairs(workspace:GetDescendants()) do
                                                if v.Name == "Gate" or v.Name == "BossDoor" then
                                                    local targetPart = v:FindFirstChild("Hitbox") or v:FindFirstChild("icewall") or v:FindFirstChild("Breakable") or v:FindFirstChild("LeftDoor") or v:FindFirstChild("GateProximityPart") or (v:IsA("BasePart") and v)
                                                    
                                                    if targetPart then
                                                        local distance = (hrp.Position - targetPart.Position).Magnitude
                                                        if distance < minDistance then
                                                            minDistance = distance
                                                            nearestGate = targetPart
                                                        end
                                                    end
                                                end
                                            end

                                            if nearestGate then
                                                print("Found Nearest Gate/Door: " .. nearestGate:GetFullName() .. " | Distance: " .. math.floor(minDistance))
                                                local gateCFrame = (nearestGate.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(math.rad(-90), 0, 0)

                                                TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = gateCFrame}):Play()
                                                hrp.Velocity = Vector3.zero
                                                task.wait(0.1)
                                                virtualClick(LocalPlayer.PlayerGui.Hud.NewBottomRight.Frame.DashSlot)
                                                task.wait(0.1)
                                            end
                                        end
                                        lastGateCheck = tick()
                                    end
                                    task.wait()
                                end
                            else
                                local isLooting = HandleDrops()
                                if not isLooting then
                                    if mapObj then
                                        if not getTarget() then
                                            task.wait(5)
                                            HandleChestAndExit()
                                        end
                                    end
                                end
                            end
                        end)
                    else
                        task.wait(1)
                    end
                else
                    currentRoomIndex = 0
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
