local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")
local firstTimeUsingDeath = false

local ALLOWED_GAME_ID = 7471000866
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
else
    -- firstTimeUsingDeath = true
end

local Window = Fluent:CreateWindow({
    Title = "Anime Evolution | BETA",
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
    AutoFarm = Window:AddTab({ Title = "Auto - Monster", Icon = "swords" }),
    EGGS = Window:AddTab({ Title = "Eggs", Icon = "egg" }),
    AutoUp = Window:AddTab({ Title = "Auto Upgrade", Icon = "plus" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nUse at your own risk!\n\nWhat game the VichianHUB is Support\n- Dragon Adventure\n- Immortal Cultivation\n- Anime Evolution"
    })

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    ------------------------------------------------------------------------------------------------------------------------
    local desiredWalkSpeed = humanoid.WalkSpeed

    local WalkSpeedSlideBar = Tabs.Main:AddSlider("Walkspeed", {
        Title = "Walk Speed",
        Description = "Speed",
        Default = desiredWalkSpeed,
        Min = humanoid.WalkSpeed,
        Max = 100,
        Rounding = 1,
        Callback = function(newSpeed)
            desiredWalkSpeed = newSpeed
            if Options.WalkSpeedToggle.Value then
                humanoid.WalkSpeed = desiredWalkSpeed
            end
        end
    })

    local ChangeWalkSpeed = Tabs.Main:AddToggle("WalkSpeedToggle", {Title = "Change - Walkspeed", Default = false })
    local IsWalkSpeedChange = false

    local function WalkSpeedChange()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = desiredWalkSpeed
    end

    ChangeWalkSpeed:OnChanged(function()
        if Options.WalkSpeedToggle.Value then
            IsWalkSpeedChange = true
            WalkSpeedChange()
            while IsWalkSpeedChange do
                WalkSpeedChange()
                task.wait(0.01)
            end
        else
            IsWalkSpeedChange = false
        end
        -- print("Toggle changed:", Options.WalkSpeedToggle.Value)
    end)

    Options.WalkSpeedToggle:SetValue(false)

    ------------------------------------------------------------------------------------------------------------------------

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Bridge = ReplicatedStorage:WaitForChild("Bridge")
    local EnemiesFolder = workspace.Client.Enemies.World

    local Player = Players.LocalPlayer
    local IsFarm = false

    -- ฟังก์ชันดึงรายชื่อมอนสเตอร์ปัจจุบัน
    local function getEnemyList()
        local list = {}
        local added = {} -- ใช้ table ช่วยเช็คชื่อที่ซ้ำกัน
        for _, enemy in pairs(EnemiesFolder:GetChildren()) do
            local nameLabel = enemy:FindFirstChild("EnemyName", true)
            if nameLabel and nameLabel:IsA("TextLabel") and not added[nameLabel.Text] then
                table.insert(list, nameLabel.Text)
                added[nameLabel.Text] = true
            end
        end
        table.sort(list) -- เรียงชื่อตามตัวอักษรให้อ่านง่าย
        return list
    end

    -- สร้าง Dropdown
    local MonsterDropdown = Tabs.AutoFarm:AddDropdown("MonsterSelect", {
        Title = "Select Monsters to Farm",
        Values = getEnemyList(),
        Multi = true,
        Default = {},
    })

    -- [[ ฟังก์ชันอัปเดต Dropdown อัตโนมัติ ]]
    task.spawn(function()
        while true do
            -- อัปเดตรายชื่อเฉพาะตอนที่ไม่ได้เปิดหน้าต่าง Dropdown ค้างไว้อยู่ (หรืออัปเดตตลอดเวลาได้เลย)
            local currentList = getEnemyList()
            
            -- ใช้คำสั่ง SetValues เพื่อเปลี่ยนรายการข้างใน
            MonsterDropdown:SetValues(currentList)
            
            task.wait(2) -- รอ 2 วินาทีตามที่คุณต้องการ
        end
    end)

    -- ฟังก์ชันเช็คว่ามอนสเตอร์ตายหรือยังจาก Text (เช่น "0/500k")
    local function isDead(enemy)
        local healthAmount = enemy:FindFirstChild("Amount", true)
        if healthAmount and healthAmount:IsA("TextLabel") then
            return string.match(healthAmount.Text, "^0/") ~= nil
        end
        return true -- ถ้าหา UI เลือดไม่เจอ ให้ถือว่าตายเพื่อข้ามไปตัวอื่น
    end

    -- ฟังก์ชันหลักของ Farm & Kill Aura
    local function startFarming()
        while IsFarm do
            local character = Player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not rootPart then task.wait(1) continue end

            local selectedMonsters = Options.MonsterSelect.Value
            local foundTarget = false

            for _, enemy in pairs(EnemiesFolder:GetChildren()) do
                if not IsFarm then break end

                local nameLabel = enemy:FindFirstChild("EnemyName", true)
                
                -- ตรวจสอบเงื่อนไขมอนสเตอร์
                if nameLabel and selectedMonsters[nameLabel.Text] and not isDead(enemy) then
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    
                    if enemyRoot then
                        foundTarget = true
                        
                        -- [ STEP 1: วาร์ปแค่รอบเดียว ] --
                        rootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 5, 0)
                        -- print("📍 Warped to: " .. nameLabel.Text)
                        
                        -- [ STEP 2: ยืนตีอยู่กับที่จนกว่าจะตาย ] --
                        while IsFarm and not isDead(enemy) and enemy.Parent == EnemiesFolder do
                            -- ส่งคำสั่งโจมตีรัวๆ (แต่ตัวละครไม่วาร์ปแล้ว)
                            local args = {
                                "Attack",
                                "UnitAttack",
                                {
                                    { Type = "World", Enemy = enemy },
                                    enemy.Name
                                }
                            }
                            Bridge:FireServer(unpack(args))
                            
                            task.wait(0.2) -- ความเร็วการตี (ปรับได้)
                        end
                        
                        -- print("✅ Target Dead, finding next...")
                    end
                end
            end
            
            if not foundTarget then
                task.wait(0.5)
            end
            task.wait()
        end
    end

    -- UI Toggle สำหรับเปิด/ปิด Farm
    local FarmToggle = Tabs.AutoFarm:AddToggle("FarmToggle", {Title = "Auto Farm & Warp", Default = false })

    FarmToggle:OnChanged(function()
        IsFarm = Options.FarmToggle.Value
        if IsFarm then
            task.spawn(startFarming)
        end
    end)

    ------------------------------------------------------------------------------------------------

    local Debris = workspace:WaitForChild("Debris")

    -- ฟังก์ชันเช็คว่าเป็น GUID หรือไม่ (รหัสยาวๆ ที่อ่านไม่ออก)
    local function isGUID(name)
        -- ตรวจสอบรูปแบบ xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
        return string.match(name, "%w+-%w+-%w+-%w+-%w+") ~= nil
    end

    local function startMagnet()
        while IsMagnet do
            local character = Player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                for _, item in pairs(Debris:GetChildren()) do
                    -- เช็คว่าเป็นชื่อรหัสอ่านไม่ออก และมีคุณสมบัติ Transform หรือเป็น Part
                    if isGUID(item.Name) then
                        pcall(function()
                            -- ถ้าเป็น MeshPart/Part ทั่วไปใช้ CFrame
                            if item:IsA("BasePart") then
                                item.CFrame = rootPart.CFrame
                            -- ถ้าเป็นระบบใหม่ที่ใช้โครงสร้าง Transform (ตามที่คุณระบุ)
                            elseif item:FindFirstChild("Transform") then
                                item.Transform.CFrame = rootPart.CFrame
                            end
                        end)
                    end
                end
            end
            task.wait(0.1) -- เช็คทุกๆ 0.1 วินาที
        end
    end

    -- เพิ่ม UI Toggle ใหม่สำหรับ Magnet
    local MagnetToggle = Tabs.AutoFarm:AddToggle("MagnetToggle", {Title = "Magnet Items (Debris)", Default = false })

    MagnetToggle:OnChanged(function()
        IsMagnet = Options.MagnetToggle.Value
        if IsMagnet then
            task.spawn(startMagnet)
        end
    end)
    
----------------------------------------------------------------------------------------------------

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Bridge = ReplicatedStorage:WaitForChild("Bridge")
    local MapsFolder = workspace.Client.Maps

    local IsAutoHatch = false

    -- ฟังก์ชันสำหรับหาชื่อ Map ปัจจุบัน
    local function getCurrentMap()
        local firstMap = MapsFolder:GetChildren()[1] -- ดึงตัวแรกที่เจอในโฟลเดอร์ Maps
        if firstMap then
            return firstMap.Name
        end
        return nil
    end

    local function startHatching()
        while IsAutoHatch do
            local currentMapName = getCurrentMap()
            
            if currentMapName then
                local args = {
                    "Stars",
                    "Roll",
                    {
                        Map = currentMapName,
                        Type = "Multi"
                    }
                }
                
                -- ส่งคำสั่งสุ่มกาชา
                Bridge:FireServer(unpack(args))
                -- print("🎰 Rolling Stars at: " .. currentMapName)
            else
                -- print("⚠️ No Map found in workspace.Client.Maps")
            end
            
            task.wait(0.5) -- ปรับความเร็วในการสุ่ม (ถ้าเร็วไปอาจจะโดนเตะ)
        end
    end

    -- สร้าง UI Toggle สำหรับ Auto Hatch
    local HatchToggle = Tabs.EGGS:AddToggle("HatchToggle", {Title = "Auto Hatch Eggs", Default = false })

    HatchToggle:OnChanged(function()
        IsAutoHatch = Options.HatchToggle.Value
        if IsAutoHatch then
            task.spawn(startHatching)
        end
    end)

    Options.HatchToggle:SetValue(false)

----------------------------------------------------------------------------------------------------

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Bridge = ReplicatedStorage:WaitForChild("Bridge")
    local LocalPlayer = Players.LocalPlayer

    -- ตัวแปรสถานะ
    local IsAutoRankUp = false
    local IsAutoAuras = false

    -- [[ 1. ฟังก์ชัน Auto RankUp (รันเมื่อมีการแจ้งเตือนขึ้น) ]]
    local function startAutoRankUp()
        -- ดึง Path ของ NotificationMarker
        local RankUpMarker = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UI"):WaitForChild("HUD"):WaitForChild("LeftContainer"):WaitForChild("Buttons"):WaitForChild("RankUp"):WaitForChild("NotificationMarker")
        
        while IsAutoRankUp do
            -- เช็คเงื่อนไข: ต้อง Visible เป็น true เท่านั้น
            if RankUpMarker and RankUpMarker.Visible == true then
                local args = {
                    "RankUp",
                    "Evolve"
                }
                Bridge:FireServer(unpack(args))
                -- print("🔝 Notification Found! Auto RankUp Executed.")
                
                -- รอ 3 วินาทีเพื่อให้ระบบประมวลผลและปิดจุดแจ้งเตือน
                task.wait(3)
            end
            task.wait(1) -- ตรวจสอบความถี่ทุก 1 วินาที
        end
    end

    -- [[ 2. ฟังก์ชัน Auto Auras (รันเมื่อมีการแจ้งเตือนขึ้น) ]]
    local function startAutoAuras()
        local AurasMarker = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UI"):WaitForChild("HUD"):WaitForChild("LeftContainer"):WaitForChild("Buttons"):WaitForChild("Auras"):WaitForChild("NotificationMarker")
        
        while IsAutoAuras do
            -- เช็คเงื่อนไข: ต้อง Visible เป็น true เท่านั้น
            if AurasMarker and AurasMarker.Visible == true then
                local args = {
                    "Auras",
                    "Evolve"
                }
                Bridge:FireServer(unpack(args))
                -- print("✨ Notification Found! Auto Auras Executed.")
                
                task.wait(3)
            end
            task.wait(1)
        end
    end

    --- ส่วนของ UI Toggle ---

    local RankUpToggle = Tabs.AutoUp:AddToggle("RankUpToggle", {Title = "Auto RankUp", Default = false })
    RankUpToggle:OnChanged(function()
        IsAutoRankUp = Options.RankUpToggle.Value
        if IsAutoRankUp then 
            task.spawn(startAutoRankUp) 
        end
    end)

    local AurasToggle = Tabs.AutoUp:AddToggle("AurasToggle", {Title = "Auto Auras", Default = false })
    AurasToggle:OnChanged(function()
        IsAutoAuras = Options.AurasToggle.Value
        if IsAutoAuras then 
            task.spawn(startAutoAuras) 
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
                                -- print("Cleared server logs!")
                                UpdateServerDropdown()
                            end
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            -- print("Cancelled")
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
            -- print("Saving to log and teleporting to:", targetServerId)
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


-- local args = {
-- 	"Attack",
-- 	"InBattle",
-- 	true
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))


-- local args = {
-- 	"Attack",
-- 	"UnitAttack",
-- 	{
-- 		{
-- 			Type = "World",
-- 			Enemy = workspace:WaitForChild("Server"):WaitForChild("Enemies"):WaitForChild("World"):WaitForChild("Sands"):WaitForChild("Awakened")
-- 		},
-- 		"69ed4c11-ab7a-4029-bb86-c6ab47910cd1"
-- 	}
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))


-- local args = {
-- 	"Drops",
-- 	"Collect",
-- 	"cc3340c1-f0dd-4f02-ab65-146e307aa80a"
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))


-- local args = {
-- 	"Teleport",
-- 	"Spawn",
-- 	"Grand Sea"
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))

-- local args = {

--     "RankUp",

--     "Evolve"

-- }

-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))

-- local args = {

--     "Auras",

--     "Evolve"

-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))


-- local args = {

--     {

--         event = "ClaimAll",

--         type = "Time"

--     }

-- }

-- game:GetService("ReplicatedStorage"):WaitForChild("_EngagementRewards"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

-- local args = {

--     {

--         event = "ClaimAll",

--         type = "Daily"

--     }

-- }

-- game:GetService("ReplicatedStorage"):WaitForChild("_EngagementRewards"):WaitForChild("RemoteEvent"):FireServer(unpack(args))


-- local args = {

--     "Achievements",

--     "Claim",

--     {

--         "Time I",

--         "Time II",

--         "Lost Temple",

--         "Goblins Caves",

--         "Evolve I",

--         "Evolve II"

--     }

-- }

-- game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))




