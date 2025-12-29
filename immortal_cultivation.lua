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
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- ตรวจสอบสิทธิ์การเข้าถึง CoreGui สำหรับ ESP
    local success, targetParent = pcall(function() return CoreGui end)
    local ESPParent = success and targetParent or PlayerGui

    local espObjects = {} 
    local currentSelectedNames = {}
    local HerbsFolder = workspace:WaitForChild("Herbs") -- ค้นหาใน workspace.Herbs

    --- ### 1. ฟังก์ชันดึงชื่อสมุนไพรจาก ProximityPrompt
    local function getHerbName(herbObject)
        local prompt = herbObject:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            -- ใช้ ObjectText (เช่น 1-Year Ginseng) หรือถ้าไม่มีให้ใช้ ActionText
            return (prompt.ObjectText ~= "" and prompt.ObjectText) or prompt.ActionText or herbObject.Name
        end
        return herbObject.Name
    end

    --- ### 2. ฟังก์ชันดึงรายชื่อสมุนไพรที่ไม่ซ้ำกันจาก workspace.Herbs
    local function getUniqueHerbNames()
        local namesInMap = {}
        local hash = {} 

        for _, herb in pairs(HerbsFolder:GetChildren()) do
            local realName = getHerbName(herb)
            if not hash[realName] then
                table.insert(namesInMap, realName)
                hash[realName] = true
            end
        end

        table.sort(namesInMap)
        
        if #namesInMap == 0 then
            return {"Waiting for herbs..."}
        end
        
        return namesInMap
    end

    --- ### 3. ฟังก์ชันสร้าง ESP
    local function createESP(object, realName)
        if espObjects[object] then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "HerbESP_" .. realName
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 150, 0, 50)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = object
        bbg.Parent = ESPParent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextSize = 15
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        
        -- ใช้สีขาวเป็นค่าเริ่มต้น
        local displayColor = Color3.fromRGB(255, 255, 255)
        
        -- เช็คคำในชื่อ (หาแบบ Case-insensitive และปิด pattern matching ด้วย true ตัวท้าย)
        local n = string.lower(realName)
        
        if string.find(n, "1000-year", 1, true) then
            displayColor = Color3.fromRGB(255, 0, 0)      -- 1000 ปี = แดง
        elseif string.find(n, "100-year", 1, true) then
            displayColor = Color3.fromRGB(255, 170, 0)    -- 100 ปี = ส้ม/ทอง
        elseif string.find(n, "10-year", 1, true) then
            displayColor = Color3.fromRGB(85, 255, 127)    -- 10 ปี = เขียว
        end

        nameLabel.TextColor3 = displayColor
        nameLabel.Text = "🌿 " .. realName

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

    --- ### 4. UI Setup & Logic
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

        -- สแกนสมุนไพรใน workspace.Herbs
        for _, herb in pairs(HerbsFolder:GetChildren()) do
            local realName = getHerbName(herb)
            -- ตรวจสอบว่าชื่อนี้ถูกเลือกใน Dropdown หรือไม่
            if table.find(currentSelectedNames, realName) then
                createESP(herb, realName)
            end
        end

        -- ลบ ESP ที่ไม่อยู่ในรายการเลือก หรือถูกเก็บไปแล้ว
        for obj, data in pairs(espObjects) do
            local stillExists = obj and obj.Parent == HerbsFolder
            local isSelected = table.find(currentSelectedNames, data.RealName)
            
            if not stillExists or not isSelected then
                if data.Container then data.Container:Destroy() end
                espObjects[obj] = nil
            end
        end
    end

    -- Events เมื่อมีการเปลี่ยนค่าใน UI
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
            refreshESP()
        end
    end)

    -- Loop สำหรับอัปเดตรายชื่อใน Dropdown และตำแหน่ง ESP
    task.spawn(function()
        while true do
            -- อัปเดต Dropdown อัตโนมัติเมื่อมีสมุนไพรชนิดใหม่เกิด
            local currentVisible = getUniqueHerbNames()
            -- ตรวจสอบความยาวเพื่อประหยัดการอัปเดต UI
            if #currentVisible ~= #HerbListDropdown.Values then
                HerbListDropdown:SetValues(currentVisible)
            end

            if herbESPtoggle.Value then
                refreshESP()
            end
            task.wait(2) -- ตรวจสอบทุก 2 วินาที
        end
    end)

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
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    -- Variables
    local herbNames = {}
    local selectedHerbNameFast = {}
    local savedSelection = {}
    local isWarping = false
    local currentWarpThread = nil
    local firstTimeUsingDeath = true
    local warpSpeed = 50
    local IsAutoPressE = false

    -- เพิ่มตัวแปรสำหรับระบบ Mesh Mapping
    local meshToHerbName = {}

    -----------------------------------------------------------------------------------------------------------------
    -- ### [SYSTEM] MESH ID MAPPING (แก้ปัญหาของไม่โชว์ โดยเช็คทั้ง Root และลูกๆ)
    -----------------------------------------------------------------------------------------------------------------

    local function buildMeshDictionary()
        meshToHerbName = {}
        local herbFolder = ReplicatedStorage:FindFirstChild("Herbs")
        if not herbFolder then return end

        local function getId(obj)
            if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
                return obj.MeshId
            end
            return nil
        end

        for _, herbEntry in pairs(herbFolder:GetChildren()) do
            local herbName = herbEntry.Name
            
            -- 1. เช็คที่ตัว Root ของมันเองเลย (กรณี Soothing Soul Root ฯลฯ)
            local rootId = getId(herbEntry)
            if rootId and rootId ~= "" then
                meshToHerbName[rootId] = herbName
            end

            -- 2. เช็คในลูกๆ ทั้งหมด (กรณีเป็น Model สุ่มรหัส)
            for _, child in pairs(herbEntry:GetDescendants()) do
                local childId = getId(child)
                if childId and childId ~= "" then
                    meshToHerbName[childId] = herbName
                end
            end
        end
    end

    local function getRealNameFromObject(obj)
        if not obj then return nil end
        
        -- เช็คตัวมันเองก่อนเพื่อความเร็ว
        if obj:IsA("MeshPart") and meshToHerbName[obj.MeshId] then
            return meshToHerbName[obj.MeshId]
        end

        -- เช็คลูกๆ เผื่อกรณี Model สุ่มรหัส
        for _, descendant in pairs(obj:GetDescendants()) do
            local mId = (descendant:IsA("MeshPart") or descendant:IsA("SpecialMesh")) and descendant.MeshId
            if mId and meshToHerbName[mId] then
                return meshToHerbName[mId]
            end
        end
        return nil
    end

    -- ฟังก์ชันดึงรายชื่อสมุนไพร "จาก ProximityPrompt ในโฟลเดอร์ Herbs"
    local function getVisibleHerbNamesFast()
        local namesInMap = {}
        local hash = {} 

        local herbFolderInWorkspace = workspace:FindFirstChild("Herbs")
        if not herbFolderInWorkspace then return {"Waiting for Herbs..."} end

        -- สแกนหาจาก ProximityPrompt เพื่อเอาชื่อและปี (เช่น 100-year)
        for _, obj in pairs(herbFolderInWorkspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local displayName = obj.ObjectText ~= "" and obj.ObjectText or obj.ActionText
                if displayName and displayName ~= "" and not hash[displayName] then
                    table.insert(namesInMap, displayName)
                    hash[displayName] = true
                end
            end
        end

        table.sort(namesInMap)
        return #namesInMap > 0 and namesInMap or {"Waiting for Herbs..."}
    end

    buildMeshDictionary()

    -----------------------------------------------------------------------------------------------------------------
    -- ### [FUNCTION] AUTO PRESS E (เหมือนเดิม)
    -----------------------------------------------------------------------------------------------------------------

    local function AutoPressE()
        local character = player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude
        overlapParams.FilterDescendantsInstances = {character}
        
        local nearbyParts = workspace:GetPartBoundsInRadius(rootPart.Position, 15, overlapParams)

        for _, part in ipairs(nearbyParts) do
            local prompt = part:FindFirstChildOfClass("ProximityPrompt") or part.Parent:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                local distance = (part.Position - rootPart.Position).Magnitude
                if distance <= prompt.MaxActivationDistance then
                    prompt.HoldDuration = 0
                    prompt:InputHoldBegin()
                    task.wait()
                    prompt:InputHoldEnd()
                    break
                end
            end
        end
    end

    local AutoPressEBut = Tabs.AutoHerb:AddToggle("AutoPressEToggle", {Title = "Auto Press E", Default = false })

    AutoPressEBut:OnChanged(function()
        if Options.AutoPressEToggle.Value then
            IsAutoPressE = true
            for _,v in ipairs(workspace:GetDescendants())do if v:IsA("ProximityPrompt")then v.HoldDuration=0 end end workspace.DescendantAdded:Connect(function(v)if v:IsA("ProximityPrompt")then v.HoldDuration=0 end end)
            task.spawn(function()
                while IsAutoPressE do
                    AutoPressE()
                    task.wait(0.2)
                end
            end)
        else
            IsAutoPressE = false
        end
    end)

    Options.AutoPressEToggle:SetValue(false)

    -----------------------------------------------------------------------------------------------------------------
    -- ### [UI & DROPDOWN] (Dynamic List)
    -----------------------------------------------------------------------------------------------------------------

    local HerbListDropdownWarpFast = Tabs.AutoHerb:AddDropdown("SelectHerbWarp", {
        Title = "Select Herb to Warp [Faster]",
        Description = "Select the type of herb for warping.",
        Values = getVisibleHerbNamesFast(),
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
        for name, isSelected in pairs(savedSelection) do
            if isSelected then table.insert(list, "• " .. name) end
        end
        local content = #list > 0 and table.concat(list, "\n") or "No herbs selected."

        HerbParagraph = Tabs.AutoHerb:AddParagraph({
            Title = "Selected Herbs list (" .. #list .. ")",
            Content = content
        })
    end

    updateParagraph()

    -- ลูปอัปเดต Dropdown อัตโนมัติ
    task.spawn(function()
        while true do
            local newUniqueHerbs = getVisibleHerbNamesFast()
            if #newUniqueHerbs ~= #HerbListDropdownWarpFast.Values then
                HerbListDropdownWarpFast:SetValues(newUniqueHerbs)
                HerbListDropdownWarpFast:SetValue(savedSelection)
            end
            task.wait(10)
        end
    end)

    -----------------------------------------------------------------------------------------------------------------
    -- ### [FUNCTION] WARP SYSTEM
    -----------------------------------------------------------------------------------------------------------------

    local function findNearestHerbFast(herbList)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local nearestHerb = nil
        local minDistance = math.huge

        local herbFolderInWorkspace = workspace:FindFirstChild("Herbs")
        if not herbFolderInWorkspace then return nil end

        -- ค้นหาโดยเทียบชื่อจาก ProximityPrompt
        for _, obj in pairs(herbFolderInWorkspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local displayName = obj.ObjectText ~= "" and obj.ObjectText or obj.ActionText
                if displayName and herbList[displayName] == true then
                    local herbPos = obj.Parent:GetPivot().Position
                    local distance = (herbPos - root.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestHerb = obj.Parent -- ส่งคืน Parent (ตัวสมุนไพร) เพื่อให้ Warp ไปหา
                    end
                end
            end
        end
        return nearestHerb
    end

    local function warpFast(targetPosition)
        local Character = LocalPlayer.Character
        if not Character then return end
        local root = Character:FindFirstChild("HumanoidRootPart")
        local hum = Character:FindFirstChild("Humanoid")
        if not root or not hum then return end 

        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
        end

        local distance = (targetPosition - root.Position).Magnitude
        local speed = tonumber(warpSpeed) or 50
        local duration = distance / speed
        if duration <= 0 then duration = 0.1 end

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root

        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})

        hum.PlatformStand = true
        tween:Play()
        tween.Completed:Connect(function()
            if bv then bv:Destroy() end
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
            root.Velocity = Vector3.new(0,0,0)
        end)
        tween.Completed:Wait()
        task.wait(0.1)
    end

    local function autoWarpLoopFast()
        while isWarping do
            if next(savedSelection) ~= nil then
                local nearest = findNearestHerbFast(savedSelection)
                if nearest then
                    warpFast(nearest:GetPivot().Position + Vector3.new(0, 5, 0))
                    task.wait(0.1)
                else
                    task.wait(2)
                end
            else
                task.wait(1) 
            end
        end
    end

    -----------------------------------------------------------------------------------------------------------------
    -- ### [UTILITY]
    -----------------------------------------------------------------------------------------------------------------

    Tabs.AutoHerb:AddButton({
        Title = "Clear Herb List",
        Callback = function()
            Window:Dialog({
                Title = "Clear All",
                Content = "Confirm to clear all selected herbs.",
                Buttons = {
                    { Title = "Confirm", Callback = function()
                        savedSelection = {} 
                        HerbListDropdownWarpFast:SetValue({}) 
                        updateParagraph()
                    end },
                    { Title = "Cancel" }
                }
            })
        end
    })

    HerbListDropdownWarpFast:OnChanged(function(value)
        savedSelection = value
        updateParagraph()
    end)

    local NoclipConnection = nil
    local function noclipFast()
        if NoclipConnection then NoclipConnection:Disconnect() end
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA('BasePart') then v.CanCollide = false end
                end
            end
        end)
    end

    local function clipFast()
        if NoclipConnection then NoclipConnection:Disconnect() ; NoclipConnection = nil end
    end

    local function DeathFirstFunctionFast()
        if firstTimeUsingDeath then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.Health = 0 end
            player.CharacterAdded:Wait()
            task.wait(2)
            firstTimeUsingDeath = false
        end
    end

    -----------------------------------------------------------------------------------------------------------------
    -- ### [TOGGLE & SLIDER]
    -----------------------------------------------------------------------------------------------------------------

    Tabs.AutoHerb:AddSlider("warpspeed", {
        Title = "Warp Speed (Studs/s)",
        Default = 50, Min = 1, Max = 100, Rounding = 1,
        Callback = function(v) warpSpeed = v end
    })

    local WarpFastToggle = Tabs.AutoHerb:AddToggle("AutoWarpFastToggle", { 
        Title = "Start Auto Herb Warp [Faster]", 
        Default = false 
    })

    WarpFastToggle:OnChanged(function(enabled)
        isWarping = enabled
        if enabled then
            DeathFirstFunctionFast()
            task.wait(0.5)
            noclipFast()
            if next(savedSelection) ~= nil then
                currentWarpThread = task.spawn(autoWarpLoopFast)
            else
                WarpFastToggle:SetValue(false)
            end
        else
            clipFast()
            isWarping = false
            if currentWarpThread then task.cancel(currentWarpThread) ; currentWarpThread = nil end
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
