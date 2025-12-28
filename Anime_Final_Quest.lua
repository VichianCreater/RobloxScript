local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")
local firstTimeUsingDeath = false

local ALLOWED_GAME_ID = 7798947148
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
else
    firstTimeUsingDeath = true
end

local Window = Fluent:CreateWindow({
    Title = "Anime Final Quest | BETA",
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

-- https://lucide.dev/icons/play
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    AttackSetting = Window:AddTab({ Title = "Attack", Icon = "swords" }),
    AutoStart = Window:AddTab({ Title = "Room", Icon = "play" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nUse at your own risk!\n\nWhat game the VichianHUB is Support\n- Dragon Adventure\n- Immortal Cultivation\n- Anime Evolution\n- Anime Final Quest"
    })

    Tabs.Main:AddParagraph({
        Title = "AFK Tutorial",
        Content = [[

Englist.
1. Setting function of script
2. Go to setting tab
3. Type config name whatever you want [Ex. AutoFarm]
4. Click create config
5. Select config in config list
6. For sure click overwrite config
7. Click set as autoload
8. Take script to autoexec in whatever executor you want
9. Done

ไทย.
1. เซ็ทฟังชั่นให้เรียบร้อย
2. ไปหน้า setting
3. ตั่งชื่อตรง config name [ตัวอย่าง AutoFarm]
4. กด create config
5. เลือก config จาก config list
6. เพื่อให้ข้อมูลเซฟกด overwrite config
7. กด set as autoload
8. นำสคริปไปใส่ใน โฟเดอร์ autoexec ของตัวรันที่ใช้
9. เสร็จแล้ว
]]
    })

------------------------------------------------------------------------------------------------------------------------

    -- ประกาศตัวแปร Global สำหรับการตั้งค่า
    local DistanceOffset = 8 -- ค่าเริ่มต้นคือใต้เท้า
    local IsFarm = false
    local AnchorRadius = 80

    -- 1. เพิ่ม Slider สำหรับปรับความสูง/ต่ำ
    local DistanceSlider = Tabs.AttackSetting:AddSlider("DistanceSlider", {
        Title = "Adjust Height Offset",
        -- Description = "ปรับระยะสูง-ต่ำจากมอนสเตอร์ (ค่าลบคืออยู่ใต้ดิน/ใต้เท้า)",
        Default = 8,
        Min = 0,
        Max = 20,
        Rounding = 1,
        Callback = function(Value)
            DistanceOffset = Value
        end
    })

        -- 2. ฟังก์ชันจัดการ Anchor มอนสเตอร์รอบตัว
    local function ManageAoEAnchor()
        local playerChar = game.Players.LocalPlayer.Character
        if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then return end
        
        local npcs = workspace:FindFirstChild("NPCs")
        if npcs then
            for _, v in pairs(npcs:GetChildren()) do
                local rootPart = v:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    -- คำนวณระยะห่างระหว่างเรากับมอนสเตอร์ตัวนั้นๆ
                    local mag = (playerChar.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    if IsFarm and mag <= AnchorRadius then
                        -- ถ้าอยู่ในระยะ 30 และเปิดฟาร์ม ให้ Anchor
                        rootPart.Anchored = false
                    else
                        -- ถ้าอยู่นอกระยะ หรือปิดฟาร์ม ให้ปลด Anchor
                        rootPart.Anchored = false
                    end
                end
            end
        end
    end

    -- 3. ฟังก์ชันโจมตี
    local function attack()
        local args = {{{state = Enum.HumanoidStateType.Running, hitcount = 3}, "\f"}}
        game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    end

    -- 4. ฟังก์ชันหาเป้าหมาย (ตัวที่ใกล้ที่สุดที่เลือด > 0)
    local function getTarget()
        local target = nil
        local shortestDistance = math.huge
        local playerChar = game.Players.LocalPlayer.Character
        if not playerChar then return nil end

        local npcs = workspace:FindFirstChild("NPCs")
        if npcs then
            for _, v in pairs(npcs:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                local rootPart = v:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local dist = (playerChar.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        target = v
                    end
                end
            end
        end
        return target
    end

    -- 5. ฟังก์ชันหลัก
    local function startFarming()
        task.spawn(function()
            while IsFarm do
                ManageAoEAnchor()
                task.wait(0.1)
            end
            -- ปลด Anchor เมื่อปิดฟาร์ม
            local npcs = workspace:FindFirstChild("NPCs")
            if npcs then
                for _, v in pairs(npcs:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Anchored = false
                    end
                end
            end
        end)

        while IsFarm do
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local target = getTarget()
            
            if char and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local healPart = workspace.Visuals:FindFirstChild("Heal")
                
                -- [เงื่อนไขใหม่: เช็คว่าต้องไปฮีลไหม]
                -- ถ้าเปิด AutoHeal และ (เลือดไม่เต็ม) และ (มีจุดฮีลอยู่)
                if Options.AutoHeal.Value and (humanoid.Health < humanoid.MaxHealth) and healPart then
                    -- วาร์ปไปที่จุด Heal (ปรับตำแหน่งได้ตามต้องการ)
                    char.HumanoidRootPart.CFrame = healPart.CFrame * CFrame.new(0, 2, 0)
                
                -- [เงื่อนไขปกติ: ถ้าไม่ต้องฮีล ให้ไปหามอนสเตอร์]
                elseif target and target:FindFirstChild("HumanoidRootPart") then
                    local rootPart = target.HumanoidRootPart
                    local targetHumanoid = target:FindFirstChildOfClass("Humanoid")
                    
                    if targetHumanoid.Health > 0 then
                        local bossSkillCheck = game.workspace.Visuals:FindFirstChild("indicator")
                        if not bossSkillCheck then
                            char.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -DistanceOffset, 5)
                        else
                            char.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -DistanceOffset, 50)
                        end
                        -- โจมตีปกติ
                        task.spawn(attack)
                    end
                end
            end
            task.wait() -- ความเร็วในการวาร์ป/เช็ค
        end
    end

    -- 6. Toggle เปิด/ปิด
    local FarmToggle = Tabs.AttackSetting:AddToggle("FarmToggle", {Title = "Start Attack", Default = false })

    FarmToggle:OnChanged(function()
        IsFarm = Options.FarmToggle.Value
        if IsFarm then
            task.spawn(startFarming)
        end
    end)

----------------------------------------------------------------------------------------------------
    Tabs.AttackSetting:AddToggle("AutoHeal", {Title = "Auto Heal (Priority)", Default = false})
----------------------------------------------------------------------------------------------------
    local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

    -- ฟังก์ชันกลางสำหรับส่ง Remote สกิล
    local function fireSkill(keyCode)
        local args = {
            {
                keyCode,
                "\026"
            }
        }
        RemoteEvent:FireServer(unpack(args))
    end

    -- --- การสร้าง UI Toggle ทั้ง 5 อัน ---

    Tabs.AttackSetting:AddToggle("Skill1", {Title = "Auto Skill [1]", Default = false})
    Tabs.AttackSetting:AddToggle("Skill2", {Title = "Auto Skill [2]", Default = false})
    Tabs.AttackSetting:AddToggle("Skill3", {Title = "Auto Skill [3]", Default = false})
    Tabs.AttackSetting:AddToggle("SkillF", {Title = "Auto Skill [F]", Default = false})
    Tabs.AttackSetting:AddToggle("SkillX", {Title = "Auto Skill [X]", Default = false})

    task.spawn(function()
        while true do
            if IsFarm then
                local target = getTarget()
                local bossSkillCheck = game.workspace.Visuals:FindFirstChild("indicator")

                if target and target:FindFirstChild("HumanoidRootPart") and not bossSkillCheck then
                    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local targetPos = target.HumanoidRootPart.Position
                    local distanceY = targetPos.Y - playerPos.Y
                    local totalDist = (playerPos - targetPos).Magnitude

                    if distanceY >= (DistanceOffset - 2) and totalDist < (DistanceOffset + 10) then
                        if Options.Skill1.Value then fireSkill(Enum.KeyCode.One) end
                        if Options.Skill2.Value then fireSkill(Enum.KeyCode.Two) end
                        if Options.Skill3.Value then fireSkill(Enum.KeyCode.Three) end
                        if Options.SkillF.Value then fireSkill(Enum.KeyCode.F) end
                        if Options.SkillX.Value then fireSkill(Enum.KeyCode.X) end
                    end
                end
            end
            task.wait(0.2)
        end
    end)

----------------------------------------------------------------------------------------------------
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer.PlayerGui

    -- [ ตัวแปรสถานะและการทำงาน ] --
    local AutoStartEnabled = false
    local IsProcessing = false

    -- [ ตัวแปรเก็บค่าจาก Dropdown ] --
    local Config = {
        Map = "Summon Gate",
        Count = "1",
        Difficulty = "DIFF: NORMAL"
    }

    -- [ ส่วนของ UI Dropdowns ] --
    local MapDropdown = Tabs.AutoStart:AddDropdown("MapSelect", {
        Title = "Select Map",
        Values = {"Summon Gate", "Summon Station - 1", "Summon Station - 2", "Statue's Cave"},
        Default = 1,
    })
    MapDropdown:OnChanged(function(Value) Config.Map = Value end)

    local CountDropdown = Tabs.AutoStart:AddDropdown("CountSelect", {
        Title = "Select Player Count",
        Values = {"1", "2", "3", "4"},
        Default = 1,
    })
    CountDropdown:OnChanged(function(Value) Config.Count = Value end)

    local DiffDropdown = Tabs.AutoStart:AddDropdown("DiffSelect", {
        Title = "Select Difficulty",
        Values = {"DIFF: NORMAL", "DIFF: HARD", "DIFF: NIGHTMARE"},
        Default = 1,
    })
    DiffDropdown:OnChanged(function(Value) Config.Difficulty = Value end)

    --- [ LOGIC การกดแบบ Fishing ] ---

    local function virtualClick(button)
        if button and button:IsA("GuiButton") then
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

    local function startProcess()
        if IsProcessing or not AutoStartEnabled then return end
        IsProcessing = true

        -- 1. ค้นหาประตู
        local teleportsFolder = workspace:FindFirstChild("Teleports")
        local targetPortal = nil
        if teleportsFolder then
            for _, portal in pairs(teleportsFolder:GetChildren()) do
                local info = portal:FindFirstChild("Info")
                if info and info:FindFirstChild("BillboardGui") and info.BillboardGui.Enabled == false then
                    targetPortal = portal
                    break
                end
            end
        end

        if targetPortal and LocalPlayer.Character then
            LocalPlayer.Character:PivotTo(targetPortal:GetPivot())
            
            -- 3. เริ่มขั้นตอนเช็ค UI
            local HUD = PlayerGui:FindFirstChild("HUD")
            local Frames = HUD and HUD:FindFirstChild("Frames")
            
            if Frames then
                -- STEP 1: กดเลือกหมวดหมู่ Default
                local TeleportFrame = Frames:FindFirstChild("Teleport")
                if TeleportFrame then
                    local t = 0
                    while AutoStartEnabled and not TeleportFrame.Visible and t < 50 do task.wait(0.1); t = t + 1 end

                    if TeleportFrame.Visible then
                        task.wait(0.5)
                        local Worlds = TeleportFrame:FindFirstChild("WORLDS")
                        local ScrollingFrame = Worlds and Worlds:FindFirstChild("ScrollingFrame")
                        
                        if ScrollingFrame then
                            local DefaultObj = ScrollingFrame:FindFirstChild("Default")
                            local DefaultBtn = DefaultObj and DefaultObj:FindFirstChild("TextButton")
                            if DefaultBtn then
                                virtualClick(DefaultBtn)
                                task.wait(0.1)
                            end

                            -- STEP 2: ค้นหาด่านตาม Config
                            local MapSelect = Frames:FindFirstChild("MapSelect")
                            local ScrollMaps = MapSelect and MapSelect:FindFirstChild("Scroll") and MapSelect.Scroll:FindFirstChild("Maps")
                            
                            if ScrollMaps then
                                local foundMapBtn = nil
                                for _, folder in pairs(ScrollMaps:GetChildren()) do
                                    local imgLabel = folder:FindFirstChild("ImageLabel")
                                    local textLabel2 = imgLabel and imgLabel:FindFirstChild("TextLabel2")
                                    if textLabel2 and textLabel2.Text == Config.Map then
                                        foundMapBtn = folder:FindFirstChild("TextButton")
                                        break
                                    end
                                end

                                if foundMapBtn then
                                    virtualClick(foundMapBtn)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end

                -- STEP 3: ตั้งค่าห้อง (จำนวนคน & ความยาก)
                local MapSelectFrame = Frames:FindFirstChild("MapSelect")
                if MapSelectFrame then
                    local t = 0
                    while AutoStartEnabled and not MapSelectFrame.Visible and t < 50 do task.wait(0.1); t = t + 1 end

                    local Info = MapSelectFrame:FindFirstChild("Info")
                    if Info and MapSelectFrame.Visible then
                        -- เช็คจำนวนคน
                        local CountLabel = Info.Count and Info.Count:FindFirstChild("TextLabel")
                        local NoBtn = Info:FindFirstChild("No")
                        local RealNoBtn = NoBtn and NoBtn:FindFirstChild("TextButton")
                        
                        if CountLabel and RealNoBtn then
                            local retryC = 0
                            while AutoStartEnabled and CountLabel.Text ~= Config.Count and retryC < 10 do
                                virtualClick(RealNoBtn)
                                task.wait(0.1)
                                retryC = retryC + 1
                            end
                        end

                        -- เช็คความยาก
                        local DiffLabel = Info.Difficulty and Info.Difficulty:FindFirstChild("TextLabel")
                        local RealDiffButton = Info.Difficulty and Info.Difficulty:FindFirstChild("TextButton")
                        
                        if DiffLabel and RealDiffButton then
                            local retryD = 0
                            while AutoStartEnabled and DiffLabel.Text ~= Config.Difficulty and retryD < 15 do
                                virtualClick(RealDiffButton)
                                task.wait(0.1)
                                retryD = retryD + 1
                            end
                        end

                        -- STEP 4: กด Play
                        local PlayBtn = Info:FindFirstChild("Play")
                        local RealPlayBtn = PlayBtn and PlayBtn:FindFirstChild("TextButton")
                        if RealPlayBtn then
                            task.wait(0.1)
                            virtualClick(RealPlayBtn)
                            Fluent:Notify({ Title = "Success", Content = "Creating Room...", Duration = 3 })
                            task.wait(10) -- รอเข้าด่าน
                        end
                    end
                end
            end
        end
        
        IsProcessing = false
    end

    -- [ ส่วนของ Toggle ] --
    local StartToggle = Tabs.AutoStart:AddToggle("AutoStartToggle", {
        Title = "Auto Create Room",
        Default = false
    })

    StartToggle:OnChanged(function()
        AutoStartEnabled = StartToggle.Value
        if game:GetService("Lighting").DepthOfField then
            game:GetService("Lighting").DepthOfField.Enabled = false
        end
        if AutoStartEnabled then
            task.spawn(function()
                while AutoStartEnabled do
                    if not IsProcessing then
                        startProcess()
                    end
                    task.wait(2) -- วนลูปเช็คทุก 2 วินาที
                end
            end)
        end
    end)
-----------------------------------------------------------------------------------------------------

-- [ Rematch Toggle ] --
    local RefreshToggle = Tabs.AutoStart:AddToggle("AutoRefresh", {
        Title = "Auto Rejoin",
        Default = false
    })

    RefreshToggle:OnChanged(function()
        AutoStartEnabled = RefreshToggle.Value
        
        if AutoStartEnabled then
            task.spawn(function()
                while AutoStartEnabled do
                    local EndMatchGUI = PlayerGui:FindFirstChild("EndScreen")
                    if EndMatchGUI then
                        local screen = EndMatchGUI:FindFirstChild("Screen")
                        if screen then
                            local frame = screen:FindFirstChild("Frame")
                            if frame then
                                local button = frame:FindFirstChild("Button")
                                if button then
                                    local textbutton = button:FindFirstChild("TextButton")
                                    if textbutton then
                                        virtualClick(textbutton)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
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
                -- Fluent:Notify({
                --     Title = "No servers available in list",
                --     Content = "fetching new data...",
                --     Duration = 3
                -- })
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

-- Torrmorw

-- workspace.Visuals.Heal >> Auto Heal

-- workspace.Visuals.indicator >> Auto Dodging
