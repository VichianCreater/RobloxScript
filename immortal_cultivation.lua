local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")
local firstTimeUsingDeath = false

local ALLOWED_GAME_ID = 7862121304
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
    Title = "Immortal Cultivation | BETA",
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
    ESPM = Window:AddTab({ Title = "ESP & Attack Mob", Icon = "eye" }),
    ESPH = Window:AddTab({ Title = "ESP Herb", Icon = "eye" }),
    ESPManual = Window:AddTab({ Title = "ESP Manual", Icon = "book" }),
    ESPFlame = Window:AddTab({ Title = "ESP Flame", Icon = "flame" }),
    AutoHerb = Window:AddTab({ Title = "Auto Herb", Icon = "leaf" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nUse at your own risk!\n\nWhat game the VichianHUB is Support\n- Dragon Adventure\n- Immortal Cultivation"
    })

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    ------------------------------------------------------------------------------------------------------------------------
    -- local desiredWalkSpeed = humanoid.WalkSpeed

    -- local WalkSpeedSlideBar = Tabs.Main:AddSlider("Walkspeed", {
    --     Title = "Walk Speed",
    --     Description = "Speed",
    --     Default = desiredWalkSpeed,
    --     Min = humanoid.WalkSpeed,
    --     Max = 100,
    --     Rounding = 1,
    --     Callback = function(newSpeed)
    --         desiredWalkSpeed = newSpeed
    --         if Options.WalkSpeedToggle.Value then
    --             humanoid.WalkSpeed = desiredWalkSpeed
    --         end
    --     end
    -- })

    -- local ChangeWalkSpeed = Tabs.Main:AddToggle("WalkSpeedToggle", {Title = "Change - Walkspeed", Default = false })
    -- local IsWalkSpeedChange = false

    -- local function WalkSpeedChange()
    --     local character = player.Character or player.CharacterAdded:Wait()
    --     local humanoid = character:WaitForChild("Humanoid")
    --     humanoid.WalkSpeed = desiredWalkSpeed
    -- end

    -- ChangeWalkSpeed:OnChanged(function()
    --     if Options.WalkSpeedToggle.Value then
    --         IsWalkSpeedChange = true
    --         WalkSpeedChange()
    --         while IsWalkSpeedChange do
    --             WalkSpeedChange()
    --             task.wait(0.01)
    --         end
    --     else
    --         IsWalkSpeedChange = false
    --     end
    --     print("Toggle changed:", Options.WalkSpeedToggle.Value)
    -- end)

    -- Options.WalkSpeedToggle:SetValue(false)

    ------------------------------------------------------------------------------------------------------------------------
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- ตรวจสอบสิทธิ์การเข้าถึง CoreGui
    local success, targetParent = pcall(function() return CoreGui end)
    local ESPParent = success and targetParent or PlayerGui

    local espObjects = {} 
    local currentSelectedNames = {}

    -- ฟังก์ชันดึง "ชื่อจริง" จาก ObjectText ของ ProximityPrompt
    local function getHerbRealName(object)
        local prompt = object:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.ObjectText and prompt.ObjectText ~= "" then
            return prompt.ObjectText
        end
        return nil
    end

    -- ฟังก์ชันดึงรายชื่อสมุนไพรทั้งหมดที่มีอยู่ใน Workspace ตอนนี้
    local function getUniqueHerbNames()
        local names = {}
        local hash = {}
        -- หาใน workspace แทน herbfolder
        for _, obj in pairs(workspace:GetChildren()) do
            local realName = getHerbRealName(obj)
            if realName and not hash[realName] then
                table.insert(names, realName)
                hash[realName] = true
            end
        end
        table.sort(names) 
        return names
    end

    -- ฟังก์ชันสร้าง ESP
    local function createESP(object, realName)
        if espObjects[object] then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "HerbESP_" .. realName
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 150, 0, 50)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = object
        bbg.Parent = ESPParent

        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = bbg

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = container
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5

        -- ตั้งค่าสีตาม ObjectText (เช่น ระดับความหายาก)
        if string.find(realName, "1000") then 
            nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            nameLabel.Text = "🌿" .. realName
        elseif string.find(realName, "100") then 
            nameLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
            nameLabel.Text = "🌿" .. realName
        elseif string.find(realName, "10") then 
            nameLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
            nameLabel.Text = "🌿" .. realName
        else 
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Text = "🌿 " .. realName
        end

        espObjects[object] = {
            Container = bbg,
            Target = object,
            RealName = realName
        }
    end

    local function removeAllESP()
        for obj, data in pairs(espObjects) do
            if data.Container then data.Container:Destroy() end
        end
        espObjects = {}
    end

    -- UI Setup
    local herbESPtoggle = Tabs.ESPH:AddToggle("HerbESPToggle", {Title = "Show Herb ESP", Default = false })
    local HerbListDropdown = Tabs.ESPH:AddDropdown("SelectHerb", {
        Title = "Select Herb Types",
        Values = getUniqueHerbNames(),
        Multi = true,
        Default = {},
    })

    local function refreshESP()
        if not herbESPtoggle.Value then
            for _, data in pairs(espObjects) do 
                if data.Container then data.Container.Enabled = false end 
            end
            return
        end

        -- ตรวจสอบ Object ใน Workspace
        for _, obj in pairs(workspace:GetChildren()) do
            local realName = getHerbRealName(obj)
            if realName and table.find(currentSelectedNames, realName) then
                createESP(obj, realName)
            end
        end

        -- ลบ ESP ของ Object ที่หายไปหรือไม่ได้เลือก
        for obj, data in pairs(espObjects) do
            local stillExists = obj and obj.Parent == workspace
            local isSelected = table.find(currentSelectedNames, data.RealName)
            
            if not stillExists or not isSelected then
                if data.Container then data.Container:Destroy() end
                espObjects[obj] = nil
            end
        end
    end

    -- RenderStepped เพื่ออัปเดตสถานะการแสดงผล
    RunService.RenderStepped:Connect(function()
        local isEnabled = herbESPtoggle.Value
        for obj, data in pairs(espObjects) do
            if obj and obj.Parent and isEnabled then
                data.Container.Enabled = true
            else
                if data.Container then data.Container.Enabled = false end
                if not obj or not obj.Parent then
                    if data.Container then data.Container:Destroy() end
                    espObjects[obj] = nil
                end
            end
        end
    end)

    -- Events
    HerbListDropdown:OnChanged(function(value)
        currentSelectedNames = {}
        for herbName, isSelected in pairs(value) do
            if isSelected then table.insert(currentSelectedNames, herbName) end
        end
        refreshESP()
    end)

    herbESPtoggle:OnChanged(function()
        if not herbESPtoggle.Value then
            removeAllESP()
        else
            HerbListDropdown:SetValues(getUniqueHerbNames())
            refreshESP()
        end
    end)

    -- Loop Refresh (เช็คของใหม่ทุก 5 วินาที)
    task.spawn(function()
        while true do
            if herbESPtoggle.Value then
                local newNames = getUniqueHerbNames()
                -- อัปเดต Dropdown เฉพาะเมื่อมีของใหม่
                HerbListDropdown:SetValues(newNames)
                refreshESP()
            end
            task.wait(5)
        end
    end)

    -- เริ่มต้น
    refreshESP()

    -----------------------------------------------------------------------------------------------------------------
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")

    -- ตรวจสอบสิทธิ์การเข้าถึง CoreGui
    local success, targetParent = pcall(function()
        return CoreGui
    end)
    local ESPParent = success and targetParent or Players.LocalPlayer:WaitForChild("PlayerGui")

    local specialESPtoggle = Tabs.ESPManual:AddToggle("ScriptureESP", {Title = "Show Manual ESP", Default = false })
    local specialESPObjects = {} -- เก็บ { [Object] = {BillboardGui, Tier} }

    local TierColors = {
        T1 = Color3.fromRGB(255, 255, 255), -- สีขาว
        T2 = Color3.fromRGB(85, 255, 127),   -- สีเขียว
        T3 = Color3.fromRGB(0, 170, 255),   -- สีฟ้า
        T4 = Color3.fromRGB(170, 85, 255),  -- สีม่วง
        T5 = Color3.fromRGB(255, 0, 0)       -- สีแดง
    }

    local scriptureList = {
        ["Qi Condensation Sutra"] = "T1",
        ["Maniac's Cultivation Tips"] = "T2",
        ["Nine Yang Scripture"] = "T2",
        ["Verdant Wind Scripture"] = "T2",
        ["Copper Body Formula"] = "T2",
        ["Six Yin Scripture"] = "T2",
        ["Tenebrous Canon"] = "T3",
        ["Sword Sutra"] = "T3",
        ["Shadowless Canon"] = "T3",
        ["Pure Heart Skill"] = "T3",
        ["Principle of Motion"] = "T3",
        ["Heavenly Demon Scripture"] = "T3",
        ["Extreme Sword Sutra"] = "T3",
        ["Lotus Sutra"] = "T3",
        ["Principle Of Motion"] = "T3",
        ["Mother Earth Technique"] = "T3",
        ["Steel Body"] = "T4",
        ["Soul Shedding"] = "T4",
        ["Dragon Rising"] = "T4",
        ["Rising Dragon Art"] = "T4",
        ["Earth Flame Method"] = "T4",
        ["Steel Body Formula"] = "T4",
        ["Soul Shedding Scripture"] = "T4",
        ["Star Reaving Scripture"] = "T4",
        ["Return to Basic"] = "T5",
        ["Taotie's Blood"] = "T5",
        ["Tower Forging Techique"] = "T5",
        ["Tower Forging"] = "T5",
        ["Evergreen Manual"] = "T5",
        ["Beast Soul Manual"] = "T5",
        ["Beast Soul Possession"] = "T5",
        ["Journey To The West"] = "T5"
    }

    -- ฟังก์ชันสร้าง BillboardGui
    local function createScriptureESP(object, tier)
        if specialESPObjects[object] then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "ScriptureESP_" .. object.Name
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 200, 0, 50)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = object
        bbg.Parent = ESPParent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "📕 " .. string.format("[%s] %s", tier, object.Name)
        nameLabel.TextColor3 = TierColors[tier] or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold -- ใช้ฟอนต์ที่ดูทันสมัยขึ้น
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

        specialESPObjects[object] = {
            Instance = bbg,
            Tier = tier
        }
    end

    local function clearScriptureESP()
        for obj, data in pairs(specialESPObjects) do
            if data.Instance then data.Instance:Destroy() end
        end
        specialESPObjects = {}
    end

    -- อัปเดตสถานะการแสดงผล
    RunService.RenderStepped:Connect(function()
        local isEnabled = specialESPtoggle.Value
        
        for object, data in pairs(specialESPObjects) do
            if object and object.Parent and isEnabled then
                data.Instance.Enabled = true
            else
                if not isEnabled then
                    data.Instance.Enabled = false
                else
                    -- ถ้าไอเทมหายไปให้ลบออกจากหน่วยความจำ
                    if data.Instance then data.Instance:Destroy() end
                    specialESPObjects[object] = nil
                end
            end
        end
    end)

    -- Loop ตรวจสอบไอเทมใน Workspace ทุกๆ 5 วินาที
    task.spawn(function()
        while true do
            if specialESPtoggle.Value then
                local currentItems = game.Workspace:GetChildren()
                for _, child in pairs(currentItems) do
                    local tier = scriptureList[child.Name]
                    if tier then
                        createScriptureESP(child, tier)
                    end
                end
            end
            task.wait(2)
        end
    end)

    specialESPtoggle:OnChanged(function()
        if not specialESPtoggle.Value then 
            clearScriptureESP() 
        end
    end)

    -----------------------------------------------------------------------------------------------------------------

    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")

    local success, targetParent = pcall(function()
        return CoreGui
    end)
    local ESPParent = success and targetParent or Players.LocalPlayer:WaitForChild("PlayerGui")

    local MysteriusFlameESPToggle = Tabs.ESPFlame:AddToggle("MysteriusFlameESP", {Title = "Show Flame ESP", Default = false })
    local FlameESPObject = {}

    local TierColors = {
        T1 = Color3.fromRGB(255, 255, 255), -- สีขาว
        T2 = Color3.fromRGB(85, 255, 127),   -- สีเขียว
        T3 = Color3.fromRGB(0, 170, 255),   -- สีฟ้า
        T4 = Color3.fromRGB(170, 85, 255),  -- สีม่วง
        T5 = Color3.fromRGB(255, 0, 0)       -- สีแดง
    }

    local MysteriusFlameList = {
        ["Disaster Rose"] = "T5",
        ["Great River"] = "T5",
        ["Poison Death"] = "T5",
        ["Azure Moon"] = "T5",
        ["Ice Devil"] = "T5",
        ["Karmic Dao"] = "T5",
        ["Ruinous"] = "T5",
    }

    local function createMysteriusFlameESP(object, tier)
        if FlameESPObject[object] then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "MysteriusFlameESP_" .. object.Name
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 200, 0, 50)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = object
        bbg.Parent = ESPParent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "🔥 " .. string.format("[Flame] %s", object.Name).. " 🔥"
        nameLabel.TextColor3 = TierColors[tier] or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

        FlameESPObject[object] = {
            Instance = bbg,
            Tier = tier
        }
    end

    local function clearMysteriusFlameESP()
        for obj, data in pairs(FlameESPObject) do
            if data.Instance then data.Instance:Destroy() end
        end
        FlameESPObject = {}
    end

    RunService.RenderStepped:Connect(function()
        local isEnabled = MysteriusFlameESPToggle.Value
        
        for object, data in pairs(FlameESPObject) do
            if object and object.Parent and isEnabled then
                data.Instance.Enabled = true
            else
                if not isEnabled then
                    data.Instance.Enabled = false
                else
                    if data.Instance then data.Instance:Destroy() end
                    FlameESPObject[object] = nil
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            if MysteriusFlameESPToggle.Value then
                local currentItems = game.Workspace:GetChildren()
                for _, child in pairs(currentItems) do
                    local tier = MysteriusFlameList[child.Name]
                    if tier then
                        createMysteriusFlameESP(child, tier)
                    end
                end
            end
            task.wait(2)
        end
    end)

    MysteriusFlameESPToggle:OnChanged(function()
        if not MysteriusFlameESPToggle.Value then 
            clearMysteriusFlameESP() 
        end
    end)

    -----------------------------------------------------------------------------------------------------------------
    
    local mobsFolder = game.Workspace:WaitForChild("Enemies")
    local TweenService = game:GetService("TweenService")
    local runService = game:GetService("RunService")
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local CoreGui = game:GetService("CoreGui")

    -- ### [1] การตั้งค่า ESP Parent (CoreGui) ###
    local success, targetParent = pcall(function()
        return CoreGui
    end)
    local ESPParent = success and targetParent or localPlayer:WaitForChild("PlayerGui")

    local mobEspObjects = {} -- เก็บข้อมูล {Instance, Target}
    local currentSelectedMobNames = {}
    local isWarpingToMob = false
    local currentMobWarpTween = nil
    local warpSpeedMob = 50 
    local desiredAttackOffset = 5
    local firstTimeUsingDeath = true

    -- ### [2] ฟังก์ชันช่วยเหลือ (Freeze & Search) ###
    local function FreezMobs()
        for _, name in ipairs({"Saint Nick", "Little Monkey King"}) do
            local special = workspace:FindFirstChild(name)
            if special and special:FindFirstChild("HumanoidRootPart") then
                special.HumanoidRootPart.Anchored = true
            end
        end
        for _, mob in ipairs(mobsFolder:GetChildren()) do
            local root = mob:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = true end
        end
    end

    -- ### [3] ฟังก์ชัน ESP (BillboardGui ใน CoreGui) ###
    local function createMobESP(object)
        if mobEspObjects[object] then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "MobESP_" .. object.Name
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 150, 0, 50)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = object:FindFirstChild("HumanoidRootPart") or object
        bbg.Parent = ESPParent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "☠️ " .. object.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

        mobEspObjects[object] = {
            Instance = bbg,
            Target = object
        }
    end

    local function removeAllMobESP()
        for obj, data in pairs(mobEspObjects) do
            if data.Instance then data.Instance:Destroy() end
        end
        mobEspObjects = {}
    end

    -- ### [4] ระบบจัดการ UI & Dropdown ###
    local mobESPtoggle = Tabs.ESPM:AddToggle("MobESPToggle", {Title = "Show Mob ESP", Default = false })
    local MobListDropdown = Tabs.ESPM:AddDropdown("SelectMob", {
        Title = "Select Mob",
        Values = {},
        Multi = true,
        Default = {},
    })

    local function updateMobList()
        local names = {}
        local hash = {}
        for _, mob in pairs(mobsFolder:GetChildren()) do
            if not hash[mob.Name] then table.insert(names, mob.Name) hash[mob.Name] = true end
        end
        for _, name in ipairs({"Saint Nick", "Little Monkey King"}) do
            if workspace:FindFirstChild(name) and not hash[name] then table.insert(names, name) end
        end
        MobListDropdown:SetValues(names)
    end

    local function refreshMobESP()
        if not mobESPtoggle.Value then
            for _, data in pairs(mobEspObjects) do data.Instance.Enabled = false end
            return
        end

        for obj, data in pairs(mobEspObjects) do
            if not table.find(currentSelectedMobNames, obj.Name) then
                data.Instance:Destroy()
                mobEspObjects[obj] = nil
            end
        end

        for _, mob in pairs(mobsFolder:GetChildren()) do
            if table.find(currentSelectedMobNames, mob.Name) then createMobESP(mob) end
        end
        for _, name in ipairs({"Saint Nick", "Little Monkey King"}) do
            local sm = workspace:FindFirstChild(name)
            if sm and table.find(currentSelectedMobNames, name) then createMobESP(sm) end
        end
    end

    -- RenderStepped อัปเดตสถานะ Billboard
    runService.RenderStepped:Connect(function()
        local isEnabled = mobESPtoggle.Value
        for obj, data in pairs(mobEspObjects) do
            if obj and obj.Parent and isEnabled then
                local hum = obj:FindFirstChild("Humanoid")
                data.Instance.Enabled = (hum and hum.Health > 0) or true
            else
                if not isEnabled then
                    data.Instance.Enabled = false
                else
                    if data.Instance then data.Instance:Destroy() end
                    mobEspObjects[obj] = nil
                end
            end
        end
    end)

    -- Events สำหรับ Dropdown
    MobListDropdown:OnChanged(function(value)
        currentSelectedMobNames = {}
        for name, isSelected in pairs(value) do
            if isSelected then table.insert(currentSelectedMobNames, name) end
        end
        refreshMobESP()
    end)

    mobESPtoggle:OnChanged(function()
        if mobESPtoggle.Value then updateMobList() else removeAllMobESP() end
        refreshMobESP()
    end)

    -- Loop อัปเดตรายชื่อม็อบเกิดใหม่
    task.spawn(function()
        while true do
            if mobESPtoggle.Value then 
                updateMobList() 
                refreshMobESP() 
            end
            task.wait(5)
        end
    end)

    -- ### [5] ระบบโจมตีและวาร์ป (ฟังก์ชันเดิมทั้งหมด) ###
    Tabs.ESPM:AddSlider("AttackOffset", { Title = "Attack Offset", Default = 5, Min = 0, Max = 20, Rounding = 1, Callback = function(v) desiredAttackOffset = v end })
    Tabs.ESPM:AddSlider("MobWarpSpeed", { Title = "Warp Speed (Studs/s)", Default = 50, Min = 10, Max = 100, Rounding = 1, Callback = function(v) warpSpeedMob = v end })

    local function getNearestTargetRoot(selectedMobNames, rootPart)
        local nearestTarget, shortestDistance = nil, math.huge
        local targets = {}
        for _, mob in pairs(mobsFolder:GetChildren()) do if table.find(selectedMobNames, mob.Name) then table.insert(targets, mob) end end
        for _, name in ipairs({"Saint Nick", "Little Monkey King"}) do
            local sm = workspace:FindFirstChild(name)
            if sm and table.find(selectedMobNames, name) then table.insert(targets, sm) end
        end
        for _, mob in ipairs(targets) do
            local mRoot = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")
            if mRoot and hum and hum.Health > 0 then
                local dist = (rootPart.Position - mRoot.Position).Magnitude
                if dist < shortestDistance then shortestDistance = dist nearestTarget = mRoot end
            end
        end
        return nearestTarget, shortestDistance
    end

    local function mobWarpTween(targetCFrame)
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local distance = (targetCFrame.Position - root.Position).Magnitude
        if distance < 2 then return end
        local duration = distance / math.max(warpSpeedMob, 1)
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        currentMobWarpTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
        char.Humanoid.PlatformStand = true
        currentMobWarpTween:Play()
        currentMobWarpTween.Completed:Wait()
        bv:Destroy()
        char.Humanoid.PlatformStand = false
    end

    local function attackMobLoop()
        while isWarpingToMob do
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(1) continue end
            local targetRoot, dist = getNearestTargetRoot(currentSelectedMobNames, root)
            if targetRoot then
                local targetCFrame = targetRoot.CFrame * CFrame.new(0, 0, desiredAttackOffset)
                if dist > (desiredAttackOffset + 2) then
                    mobWarpTween(targetCFrame)
                else
                    root.CFrame = CFrame.lookAt(root.Position, targetRoot.Position)
                    game:GetService("ReplicatedStorage").Remotes.Punch:FireServer(0)
                    task.wait(0.1)
                end
            end
            task.wait(0.1)
        end
    end

    local function DeathFirstFunctionMob()
        if firstTimeUsingDeath then
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
                localPlayer.CharacterAdded:Wait()
                task.wait(2)
            end
            firstTimeUsingDeath = false
        end
    end

    local autoAttackMoblist = Tabs.ESPM:AddToggle("AttackMobESPToggle", {Title = "Auto Warp & Attack Mob", Default = false })
    autoAttackMoblist:OnChanged(function()
        isWarpingToMob = autoAttackMoblist.Value
        if isWarpingToMob then
            DeathFirstFunctionMob()
            task.wait(1)
            FreezMobs()
            task.spawn(attackMobLoop)
        elseif currentMobWarpTween then
            currentMobWarpTween:Cancel()
        end
    end)

    ---------------------------------------------------------------------------------------------------------------

    Tabs.ESPM:AddButton({
        Title = "Freeze All Mob",
        Description = "Click to freeze mob when automatic freeze not work",
        Callback = function()
            FreezMobs()

            Fluent:Notify({
                Title = "Notify",
                Content = "Now the mob is freeze",
                Duration = 3
            })
        end
    })
    -----------------------------------------------------------------------------------------------------------------

    HowToUseAutoFast = Tabs.AutoHerb:AddParagraph({
        Title = "How to do it work",
        Content = "\n1 . On the auto press E function\n2 . Select herbs in dropdown\n3 . On auto herb warp function\n\nThe dropdown will only show herbs that are spawned in the server, but the script will add the herb you select to the list and still auto-warp when the herb respawns."
    })

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local workspace = game:GetService("Workspace")

    local function AutoPressE()
        local character = player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        -- สร้างขอบเขตการเช็ครอบตัว (รัศมี 10-15 studs ตามความเหมาะสม)
        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude
        overlapParams.FilterDescendantsInstances = {character}
        
        -- สแกนเฉพาะ Part ที่อยู่รอบตัวเราในระยะ 15 studs
        local nearbyParts = workspace:GetPartBoundsInRadius(rootPart.Position, 15, overlapParams)

        for _, part in ipairs(nearbyParts) do
            -- หา ProximityPrompt ใน Part นั้นๆ หรือใน Model ของมัน
            local prompt = part:FindFirstChildOfClass("ProximityPrompt") or part.Parent:FindFirstChildOfClass("ProximityPrompt")
            
            if prompt then
                -- เช็คระยะห่างอีกครั้งตามค่าที่ปุ่มกำหนดไว้
                local distance = (part.Position - rootPart.Position).Magnitude
                if distance <= prompt.MaxActivationDistance then
                    prompt.HoldDuration = 0 -- ทำให้กดไวขึ้น
                    prompt:InputHoldBegin()
                    task.wait() -- รอช่วงเวลาสั้นๆ
                    prompt:InputHoldEnd()
                    break -- กดแล้วหยุดลูปนี้ทันทีเพื่อป้องกันการกดซ้ำในเฟรมเดียว
                end
            end
        end
    end

    local AutoPressEBut = Tabs.AutoHerb:AddToggle("AutoPressEToggle", {Title = "Auto Press E", Default = false })
    local IsAutoPressE = false

    AutoPressEBut:OnChanged(function()
        if Options.AutoPressEToggle.Value then
            IsAutoPressE = true
            for _,v in ipairs(workspace:GetDescendants())do if v:IsA("ProximityPrompt")then v.HoldDuration=0 end end workspace.DescendantAdded:Connect(function(v)if v:IsA("ProximityPrompt")then v.HoldDuration=0 end end)
            -- เริ่มต้นการทำงานของ AutoPressE ในฟังก์ชันแยกเธรด (ไม่บล็อก UI)
            task.spawn(function()
                while IsAutoPressE do
                    AutoPressE()
                    task.wait(0.2)  -- ตั้งระยะเวลาระหว่างการกด
                end
            end)
        else
            IsAutoPressE = false  -- เมื่อปิด toggle ให้หยุดการทำงาน
        end
        print("Toggle changed:", Options.AutoPressEToggle.Value)
    end)

    Options.AutoPressEToggle:SetValue(false)

    -----------------------------------------------------------------------------------------------------------------

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    local herbsFolder = game.Workspace:WaitForChild("Herbs")
    local herbNames = {}
    local selectedHerbNameFast = {}
    local savedSelection = {}
    local isWarping = false
    local currentWarpThread = nil

    if not Tabs then
        warn("Tabs is not defined. Please ensure the framework/library is loaded correctly.")
        return
    end

    local function loadHerbNamesFast()
        local uniqueHerbNames = {}
        local hash = {}

        -- สแกนหาชื่อสมุนไพรจาก ObjectText ใน Workspace
        for _, obj in pairs(workspace:GetChildren()) do
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
            if prompt and prompt.ObjectText ~= "" then
                local realName = prompt.ObjectText
                if not hash[realName] then
                    table.insert(uniqueHerbNames, realName)
                    hash[realName] = true
                end
            end
        end

        table.sort(uniqueHerbNames) 
        return uniqueHerbNames
    end

    local uniqueHerbNames = loadHerbNamesFast()

    local HerbListDropdownWarpFast = Tabs.AutoHerb:AddDropdown("SelectHerbWarp", {
        Title = "Select Herb to Warp [Faster]",
        Description = "Select the type of herb for warping.",
        Values = uniqueHerbNames,
        Multi = true, 
        Default = {},
    })

    local HerbParagraph = nil

    local function updateParagraph()
        if HerbParagraph then
            HerbParagraph:Destroy() 
            HerbParagraph = nil
        end

        local list = {}
        for name, _ in pairs(savedSelection) do
            table.insert(list, "• " .. name)
        end
        local content = #list > 0 and table.concat(list, "\n") or "No herbs selected."

        HerbParagraph = Tabs.AutoHerb:AddParagraph({
            Title = "Selected Herbs list (" .. #list .. ")",
            Content = content
        })
    end

    updateParagraph()

    local updateThreadFast = nil

    local function updateHerbListFast()
        while true do
            local newUniqueHerbNamesFast = loadHerbNamesFast()

            if #newUniqueHerbNamesFast ~= #HerbListDropdownWarpFast.Values or 
            newUniqueHerbNamesFast[1] ~= HerbListDropdownWarpFast.Values[1] then

                HerbListDropdownWarpFast:SetValues(newUniqueHerbNamesFast)
                
                -- ตรวจสอบว่าถ้าเปิด Warp อยู่ ให้เอาค่าที่เซฟไว้กลับมาใส่ใน Dropdown
                if isWarping and savedSelection then
                    HerbListDropdownWarpFast:SetValue(savedSelection)
                end
            end
            task.wait(10) 
        end
    end

    if not updateThreadFast then
        updateThreadFast = task.spawn(updateHerbListFast)
    end

    local warpSpeed = 50

    local WarpSpeedSlide = Tabs.AutoHerb:AddSlider("warpspeed", {
        Title = "Warp Speed (Studs/s)",
        Description = "The constant speed of the warp (Higher = Faster).",
        Default = 50,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(newSpeed)
            warpSpeed = newSpeed 
        end
    })

    local WarpFastToggle = Tabs.AutoHerb:AddToggle("AutoWarpFastToggle", {
        Title = "Start Auto Herb Warp [Faster]", 
        Default = false 
    })

    local function findNearestHerbFast(herbList)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        if not HumanoidRootPart then return nil end

        local nearestHerb = nil
        local minDistance = math.huge

        -- สแกนหาใน Workspace
        for _, herb in pairs(workspace:GetChildren()) do
            local prompt = herb:FindFirstChildOfClass("ProximityPrompt")
            local realName = prompt and prompt.ObjectText or ""

            -- เช็คว่าชื่อใน ObjectText ตรงกับที่เราเลือกไว้ใน herbList (savedSelection)
            if realName ~= "" and herbList[realName] == true then
                local herbPos
                if herb:IsA("BasePart") then
                    herbPos = herb.Position
                elseif herb:IsA("Model") and herb.PrimaryPart then
                    herbPos = herb.PrimaryPart.Position
                else
                    herbPos = herb:GetPivot().Position
                end

                if herbPos then
                    local distance = (herbPos - HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestHerb = herb
                    end
                end
            end
        end
        return nearestHerb
    end

    local function warpFast(targetPosition)
        local Character = LocalPlayer.Character
        if not Character then return end
        
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        local Debris = game:GetService("Debris")
        if not HumanoidRootPart or not Humanoid then return end 

        for _, v in pairs(HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end

        local targetCFrame = CFrame.new(targetPosition)
        local distance = (targetPosition - HumanoidRootPart.Position).Magnitude
        local speed = tonumber(warpSpeed) or 50
        local duration = distance / speed
        if duration <= 0 then duration = 0.1 end

        local bv = Instance.new("BodyVelocity")
        bv.Name = "WarpBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = HumanoidRootPart

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local warpTween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})

        Humanoid.PlatformStand = true
        warpTween:Play()
        warpTween.Completed:Connect(function()
            if bv then bv:Destroy() end
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) 
            
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
        end)
        warpTween.Completed:Wait()
        task.wait(0.1)
    end

    local function autoWarpLoopFast()
        while isWarping do
            if next(savedSelection) ~= nil then
                
                local nearestHerb = findNearestHerbFast(savedSelection)
                
                if nearestHerb then
                    local herbPosition = nil
                    if nearestHerb:IsA("BasePart") then
                        herbPosition = nearestHerb.Position
                    elseif nearestHerb:IsA("Model") and nearestHerb.PrimaryPart then
                        herbPosition = nearestHerb.PrimaryPart.Position
                    else
                        herbPosition = nearestHerb:GetPivot().Position
                    end

                    if herbPosition then
                        local targetPosition = herbPosition + Vector3.new(0, 5, 0)
                        warpFast(targetPosition)
                        task.wait(0.1)
                    end
                else
                    print("All selected herbs are gone. Waiting for respawn...")
                    task.wait(2)
                end
            else
                task.wait(1) 
            end
        end
    end

    Tabs.AutoHerb:AddButton({
        Title = "Clear Herb List",
        Description = "Click to clear all the herb in selected list",
        Callback = function()
            Window:Dialog({
                Title = "Clear All Selected Herbs",
                Content = "Confirm to clear all selected herbs.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Clear all selections.")
                            savedSelection = {} 
                            selectedHerbNameFast = {}
                            HerbListDropdownWarpFast:SetValue({}) 
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

    HerbListDropdownWarpFast:OnChanged(function(value)
        selectedHerbNameFast = value
        for _, herbName in pairs(HerbListDropdownWarpFast.Values) do
            
            if value[herbName] == true then
                savedSelection[herbName] = true
            else
                savedSelection[herbName] = nil
            end
        end
        updateParagraph()
        print("Master List Updated: " .. game:GetService("HttpService"):JSONEncode(savedSelection))
    end)

    local NoclipConnection = nil
    local function noclipFast()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
                v.CanCollide = false
            end
        end
        if NoclipConnection then NoclipConnection:Disconnect() end
        NoclipConnection = game:GetService('RunService').Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA('BasePart') then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end

    local function clipFast()
        if NoclipConnection then 
            NoclipConnection:Disconnect() 
            NoclipConnection = nil 
        end
    end

    local function DeathFirstFunctionFast()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")
        if firstTimeUsingDeath then
            local character = game.Players.LocalPlayer.Character
            local humanoid = character:FindFirstChild("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end

            while player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil do
                wait(0.1)
            end

            local newCharacter = player.Character
            local humanoid = newCharacter:FindFirstChild("Humanoid")

            if humanoid then
                print("ตัวละครใหม่เกิดขึ้นแล้ว!")
                wait(2)
            end

            firstTimeUsingDeath = false
        end
    end

    WarpFastToggle:OnChanged(function(enabled)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")
        isWarping = enabled

        if enabled then

            DeathFirstFunctionFast()
            task.wait(0.5)

            local antiNoclip = Character:FindFirstChild("AntiNoclip")
            if antiNoclip then
                antiNoclip.Disabled = true
            end

            local pScripts = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts")
            if pScripts then
                local af1 = pScripts:FindFirstChild("antifling")
                local af2 = pScripts:FindFirstChild("AntiFling")
                if af1 then af1.Disabled = true end
                if af2 then af2.Disabled = true end
            end

            local sCharScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts")
            if sCharScripts then
                local sn = sCharScripts:FindFirstChild("AntiNoclip")
                if sn then sn.Disabled = true end
            end

            noclipFast()

            if next(savedSelection) ~= nil then
                currentWarpThread = task.spawn(autoWarpLoopFast)
            else
                warn("Please select herb first!")
                WarpFastToggle:SetValue(false)
            end
        else
            clipFast()
            isWarping = false
            if currentWarpThread then
                task.cancel(currentWarpThread)
                currentWarpThread = nil
            end
            print("Auto Warp Stopped.")
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
