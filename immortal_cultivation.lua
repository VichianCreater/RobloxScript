-- 10-Year Ginseng
-- 1-Year Ginseng

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
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

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    ESPM = Window:AddTab({ Title = "ESP & Attack Mob", Icon = "eye" }),
    ESPH = Window:AddTab({ Title = "ESP Herb", Icon = "eye" }),
    ESPManual = Window:AddTab({ Title = "ESP Manual", Icon = "book" }),
    AutoHerb = Window:AddTab({ Title = "Auto Herb", Icon = "leaf" }),
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Alert",
    Content = "Script Loaded.",
    Duration = 8
})

local VirtualUser = game:GetService('VirtualUser')
 
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

do
    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nUse at your own risk!\n\nWhat game the VichianHUB is Support\n- Dragon Adventure\n- Immortal Cultivation"
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
        print("Toggle changed:", Options.WalkSpeedToggle.Value)
    end)

    Options.WalkSpeedToggle:SetValue(false)

    ------------------------------------------------------------------------------------------------------------------------
    local herbsFolder = game.Workspace:WaitForChild("Herbs")
    local herbESPtoggle = Tabs.ESPH:AddToggle("HerbESPToggle", {Title = "Show Herb ESP [Click first the Herblist will show]", Default = false })
    local espObjects = {}
    local HerbListDropdown = Tabs.ESPH:AddDropdown("SelectHerb", {
        Title = "SelectHerb",
        Description = "You can select multiple Herb.",
        Values = {},
        Multi = true,
        Default = {"None", "Null"},
    })

    local herbToESP = {}
    local currentSelectedNames = {}

    local function createESP(object)
        if herbToESP[object] then return end 

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Adornee = object
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 200, 0, 70) 
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true

        local nameTextLabel = Instance.new("TextLabel")
        nameTextLabel.Parent = billboardGui
        nameTextLabel.Text = "🌿 "..object.Name
        nameTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameTextLabel.Position = UDim2.new(0, 0, 0, 0)
        nameTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTextLabel.TextStrokeTransparency = 0.8
        nameTextLabel.TextSize = 10
        nameTextLabel.BackgroundTransparency = 1

        local objectTextLabel = Instance.new("TextLabel")
        objectTextLabel.Parent = billboardGui
        objectTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        objectTextLabel.Position = UDim2.new(0, 0, 0.2, 0)
        objectTextLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        objectTextLabel.TextStrokeTransparency = 0.8
        objectTextLabel.TextSize = 8
        objectTextLabel.BackgroundTransparency = 1

        local objectText = "No Data (Attribute Missing)"
        local proximityPrompt = object:FindFirstChildOfClass("ProximityPrompt")

        if proximityPrompt then
            objectText = proximityPrompt.ObjectText

            if string.find(objectText, "1") then
                objectTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            if string.find(objectText, "10") then
                objectTextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
            if string.find(objectText, "100") then
                objectTextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
            if string.find(objectText, "1000") then
                objectTextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            end
        end

        objectTextLabel.Text = objectText
        
        table.insert(espObjects, billboardGui)
        herbToESP[object] = billboardGui
    end

    local function removeESPForHerb(object)
        local billboardGui = herbToESP[object]
        if billboardGui and billboardGui.Parent then
            billboardGui:Destroy()
        end
        herbToESP[object] = nil

        for i, esp in ipairs(espObjects) do
            if esp == billboardGui then
                table.remove(espObjects, i)
                break
            end
        end
    end

    local function removeAllESP()
        for _, billboardGui in pairs(espObjects) do
            if billboardGui and billboardGui.Parent then
                billboardGui:Destroy()
            end
        end
        espObjects = {}
        herbToESP = {}
    end

    local function loadAndSetHerbNames()
        local allHerbNames = {}
        for _, herb in pairs(herbsFolder:GetChildren()) do
            table.insert(allHerbNames, herb.Name)
        end

        local uniqueHerbNames = {}
        for _, herbName in pairs(allHerbNames) do
            if not table.find(uniqueHerbNames, herbName) then
                table.insert(uniqueHerbNames, herbName)
            end
        end

        HerbListDropdown:SetValues(uniqueHerbNames)
    end

    -- ฟังก์ชันหลักในการสแกนและอัปเดตทั้งหมด
    local function scanAndApplyESP()
        
        -- ลบ ESP ทั้งหมดก่อนเพื่อเตรียมสร้างใหม่ (ป้องกันปัญหา Herb ถูกลบ)
        removeAllESP() 
        
        -- 1. อัปเดต Dropdown ด้วยชื่อ Herb ปัจจุบันทั้งหมด
        loadAndSetHerbNames()

        -- ตรวจสอบว่า Toggle เปิดและมีการเลือก
        if herbESPtoggle.Value and #currentSelectedNames > 0 then
            -- 2. วนลูปสร้าง ESP ใหม่เฉพาะสำหรับ Herb ที่มีอยู่ในปัจจุบันและถูกเลือก
            for _, herb in pairs(herbsFolder:GetChildren()) do
                if table.find(currentSelectedNames, herb.Name) then
                    createESP(herb)
                end
            end
        end
    end

    -- ลูปหลักสำหรับอัปเดตทุก 5 วินาที
    task.spawn(function()
        while true do
            scanAndApplyESP()
            task.wait(5) -- หน่วงเวลา 5 วินาที
        end
    end)


    -- Event Handlers (จัดการเฉพาะการเปลี่ยนค่า UI)

    HerbListDropdown:OnChanged(function(value)
        -- อัปเดตตาราง currentSelectedNames เมื่อ Dropdown เปลี่ยน
        currentSelectedNames = {}
        for herbName, isSelected in pairs(value) do
            if isSelected then
                table.insert(currentSelectedNames, herbName)
            end
        end
        
        -- เรียกใช้การสแกนทันทีเพื่อตอบสนองต่อการเปลี่ยนแปลงการเลือก
        scanAndApplyESP()
    end)

    herbESPtoggle:OnChanged(function()
        if not herbESPtoggle.Value then
            removeAllESP()
            HerbListDropdown:SetValues({})
        end
        
        -- เรียกใช้การสแกนทันทีเพื่อตอบสนองต่อการเปลี่ยน Toggle
        scanAndApplyESP()
    end)

    -- โหลดชื่อเริ่มต้นเมื่อเริ่มสคริปต์
    loadAndSetHerbNames()

    -- ดึงค่าเริ่มต้นจากการตั้งค่า Dropdown
    currentSelectedNames = {}
    for herbName, isSelected in pairs(HerbListDropdown.Value) do
        if isSelected then
            table.insert(currentSelectedNames, herbName)
        end
    end
    -- HerbListDropdown:SetValue("None") 
    -----------------------------------------------------------------------------------------------------------------
    local specialESPtoggle = Tabs.ESPManual:AddToggle("ScriptureESP", {Title = "Show Manual ESP", Default = false })
    local specialESPObjects = {}

    -- กำหนดสีตาม Tier
    local TierColors = {
        T1 = Color3.fromRGB(255, 255, 255), -- สีขาว (ธรรมดา)
        T2 = Color3.fromRGB(85, 255, 127),   -- สีเขียว
        T3 = Color3.fromRGB(0, 170, 255),   -- สีฟ้า
        T4 = Color3.fromRGB(170, 85, 255),  -- สีม่วง
        T5 = Color3.fromRGB(255, 0, 0)      -- สีแดง (หายากสุด)
    }

    -- รายชื่อไอเทมและ Tier
    local scriptureList = {
        -- T1
        ["Qi Condensation Sutra"] = "T1",
        -- T2
        ["Maniac's Cultivation Tips"] = "T2",
        ["Nine Yang Scripture"] = "T2",
        ["Verdant Wind Scripture"] = "T2",
        ["Copper Body Formula"] = "T2",
        ["Six Yin Scripture"] = "T2",
        -- T3
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
        -- T4
        ["Steel Body"] = "T4",
        ["Soul Shedding"] = "T4",
        ["Dragon Rising"] = "T4",
        ["Rising Dragon Art"] = "T4",
        ["Earth Flame Method"] = "T4",
        ["Steel Body Formula"] = "T4",
        ["Soul Shedding Scripture"] = "T4",
        ["Star Reaving Scripture"] = "T4",
        -- T5
        ["Taoist Blood"] = "T5",
        ["Tower Forging Techique"] = "T5",
        ["Evergreen Manual"] = "T5",
        ["jttw"] = "T5"
    }

    -- ฟังก์ชันสร้าง ESP
    local function createScriptureESP(object, tier)
        if object:FindFirstChild("Scripture_ESP") then return end
        
        local tierColor = TierColors[tier] or Color3.fromRGB(255, 255, 255)
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "Scripture_ESP"
        billboardGui.Adornee = object
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 200, 0, 70)
        billboardGui.StudsOffset = Vector3.new(0, 4, 0)
        billboardGui.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = billboardGui
        nameLabel.Text = "📕 "..string.format("[%s] %s", tier, object.Name)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.TextColor3 = tierColor
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.BackgroundTransparency = 1
        
        table.insert(specialESPObjects, billboardGui)
    end

    local function clearScriptureESP()
        for _, gui in pairs(specialESPObjects) do
            if gui and gui.Parent then gui:Destroy() end
        end
        specialESPObjects = {}
    end

    -- Loop ตรวจสอบทุก 5 วินาที
    task.spawn(function()
        while true do
            if specialESPtoggle.Value then
                local currentItems = game.Workspace:GetChildren()
                
                for _, child in pairs(currentItems) do
                    -- ตรวจสอบชื่อใน List (แบบ Case Sensitive เพื่อความแม่นยำ)
                    local tier = scriptureList[child.Name]
                    if tier then
                        createScriptureESP(child, tier)
                    end
                end
            else
                clearScriptureESP()
            end
            task.wait(5)
        end
    end)

    specialESPtoggle:OnChanged(function()
        if not specialESPtoggle.Value then clearScriptureESP() end
    end)

    -----------------------------------------------------------------------------------------------------------------
    

    -- Auto Equip Sword

    local autoEquipSword = Tabs.ESPM:AddToggle("autoEquipSwordToggle", {Title = "Equip Sword[Training Jian]", Default = false })
    local swordEquip = false
    autoEquipSword:OnChanged(function()
        local player = game:GetService("Players").LocalPlayer
        local vim = game:GetService("VirtualInputManager")

        if autoEquipSword.Value then 
            swordEquip = true
            while swordEquip do
                local character = player.Character or player.CharacterAdded:Wait()
                local swordInChar = character:FindFirstChild("Training Jian")
                if not swordInChar then
                    local inventoryFrame = player.PlayerGui.Main.Inventory.ScrollingFrame
                    local itemInInv = inventoryFrame:FindFirstChild("Training Jian")
                    
                    if itemInInv then
                        vim:SendKeyEvent(true, Enum.KeyCode.G, false, game)
                        vim:SendKeyEvent(false, Enum.KeyCode.G, false, game)
                    end
                end
                task.wait(1)
            end
        else
            swordEquip = false
        end
    end)
    
    local mobsFolder = game.Workspace:WaitForChild("Enemies")
    local mobESPtoggle = Tabs.ESPM:AddToggle("MobESPToggle", {Title = "Show Mob ESP [Click first the Moblist will show]", Default = false })
    local mobespObjects = {}
    local mobNames = {}
    local selectedMobName = nil
    local MobListDropdown = Tabs.ESPM:AddDropdown("SelectMob", {
        Title = "SelectMob",
        Description = "You can select multiple Mob.",
        Values = {},
        Multi = true,
        Default = {"None", "Null"},
    })

    local function createESP(object)
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Adornee = object
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 200, 0, 70)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true

        local nameTextLabel = Instance.new("TextLabel")
        nameTextLabel.Parent = billboardGui
        nameTextLabel.Text = "☠️ "..object.Name
        nameTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameTextLabel.Position = UDim2.new(0, 0, 0, 0)
        nameTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTextLabel.TextStrokeTransparency = 0.8
        nameTextLabel.TextSize = 10
        nameTextLabel.BackgroundTransparency = 1
        
        table.insert(mobespObjects, billboardGui)
    end

    local function removeMobESP()
        for _, billboardGui in pairs(mobespObjects) do
            if billboardGui and billboardGui.Parent then
                billboardGui:Destroy()
            end
        end
        mobespObjects = {}
    end

    local function loadMobNames()
        mobNames = {}
        
        -- 1. เพิ่มชื่อ Mob จากโฟลเดอร์ "Enemies"
        for _, mob in pairs(mobsFolder:GetChildren()) do
            table.insert(mobNames, mob.Name)
        end
        
        -- 2. ตรวจสอบและเพิ่ม "Saint Nick" (ถ้ามี)
        local saintNick = game.workspace:FindFirstChild("Saint Nick")
        if saintNick and saintNick:IsA("Model") then -- ตรวจสอบว่ามีอยู่จริงและเป็น Model
            table.insert(mobNames, saintNick.Name)
        end

        -- 3. ตรวจสอบและเพิ่ม "Little Monkey King" (ถ้ามี)
        local littleMonkeyKing = game.workspace:FindFirstChild("Little Monkey King")
        if littleMonkeyKing and littleMonkeyKing:IsA("Model") then -- ตรวจสอบว่ามีอยู่จริงและเป็น Model
            table.insert(mobNames, littleMonkeyKing.Name)
        end

        -- 4. กรองชื่อซ้ำ (ตามโค้ดเดิม)
        local uniqueMobNames = {}
        for _, mobName in pairs(mobNames) do
            if not table.find(uniqueMobNames, mobName) then
                table.insert(uniqueMobNames, mobName)
            end
        end
        
        -- 5. อัปเดต Dropdown
        MobListDropdown:SetValues(uniqueMobNames)
    end

    MobListDropdown:OnChanged(function(value)
        removeMobESP()
        local selectedMobNames = {}
        for mobName, isSelected in pairs(value) do
            if isSelected then
                table.insert(selectedMobNames, mobName)
            end
        end

        if mobESPtoggle.Value and #selectedMobNames > 0 then
            -- ลูปเพื่อสร้าง ESP สำหรับมอนสเตอร์ในโฟลเดอร์
            for _, mob in pairs(mobsFolder:GetChildren()) do
                if table.find(selectedMobNames, mob.Name) then
                    createESP(mob)
                end
            end
            
            -- ตรวจสอบและสร้าง ESP สำหรับมอนสเตอร์พิเศษ (Saint Nick, Little Monkey King)
            local specialMobs = {"Saint Nick", "Little Monkey King"}
            for _, specialName in ipairs(specialMobs) do
                if table.find(selectedMobNames, specialName) then
                    local specialMob = game.workspace:FindFirstChild(specialName)
                    if specialMob and specialMob:IsA("Model") then
                        createESP(specialMob)
                    end
                end
            end
        end
    end)

    mobESPtoggle:OnChanged(function()
        if mobESPtoggle.Value then
            loadMobNames()
        else
            removeMobESP()
            MobListDropdown:SetValues({})
        end
    end)

    local heartbeatConnection = nil

    local function getNearestTargetRoot(selectedMobNames, rootPart)
        local nearestTarget = nil
        local shortestDistance = math.huge
        
        -- รวบรวมรายการมอนสเตอร์ทั้งหมดที่ถูกเลือก
        local mobsToCheck = {}
        
        -- 1. เพิ่ม Mob จากโฟลเดอร์ "Enemies"
        for _, mob in pairs(mobsFolder:GetChildren()) do
            -- ต้องมั่นใจว่า mob.Name เป็นสตริงเดียวกับใน selectedMobNames
            if table.find(selectedMobNames, mob.Name) then
                table.insert(mobsToCheck, mob)
            end
        end
        
        -- 2. เพิ่มมอนสเตอร์พิเศษที่ถูกเลือก (ถ้ามี)
        local specialNames = {"Saint Nick", "Little Monkey King"}
        for _, name in ipairs(specialNames) do
            if table.find(selectedMobNames, name) then
                local specialMob = game.workspace:FindFirstChild(name)
                if specialMob and specialMob:IsA("Model") then
                    table.insert(mobsToCheck, specialMob)
                end
            end
        end

        -- 3. วนลูปตรวจสอบเป้าหมายที่ใกล้ที่สุดจากรายการรวมทั้งหมด
        local nearestTarget = nil
        local shortestDistance = math.huge

        for _, mobInstance in ipairs(mobsToCheck) do
            local mobRoot = mobInstance:FindFirstChild("HumanoidRootPart")
            
            -- ตรวจสอบสุขภาพและส่วนประกอบที่จำเป็น
            if mobRoot and mobInstance:FindFirstChild("Humanoid") then
                local humanoid = mobInstance.Humanoid
                if humanoid.Health > 0 then
                    local distance = (rootPart.Position - mobRoot.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestTarget = mobRoot
                    end
                end
            end
        end
        
        return nearestTarget, shortestDistance
    end

    local function FreezMobs()
        if game.workspace:FindFirstChild("Saint Nick") then
            workspace["Saint Nick"].HumanoidRootPart.Anchored = true
        end

        if game.workspace:FindFirstChild("Little Monkey King") then
            workspace["Little Monkey King"].HumanoidRootPart.Anchored = true
        end

        for _, mob in ipairs(mobsFolder:GetChildren()) do
            if mob:IsA("Model") then
                local rootPart = mob:FindFirstChild("HumanoidRootPart")
                if rootPart and rootPart:IsA("BasePart") then
                    rootPart.Anchored = true
                end
            end
        end
    end

    local desiredAttackOffset = 5
    local OffsetSlider = Tabs.ESPM:AddSlider("AttackOffset", {
        Title = "Attack Offset",
        Description = "Distance behind the Mob to stand.",
        Default = desiredAttackOffset, -- ใช้ค่าเริ่มต้นที่เรากำหนดไว้
        Min = 0, -- ระยะใกล้สุด (อาจจะยืนด้านหน้ามอนสเตอร์)
        Max = 20,  -- ระยะไกลสุด (ยืนด้านหลังมอนสเตอร์)
        Rounding = 1, -- ปัดเศษเป็นทศนิยม 1 ตำแหน่ง
        Callback = function(newOffset)
            desiredAttackOffset = newOffset -- อัปเดตตัวแปร global เมื่อผู้ใช้เลื่อน
        end
    })

    local function startAttackMobList()
        -- ********** แก้ไขส่วนนี้ **********
        local selectedMobNames = {}
        for mobName, isSelected in pairs(MobListDropdown.Value) do
            if isSelected then
                table.insert(selectedMobNames, mobName)
            end
        end
        -- ***********************************

        local offset = desiredAttackOffset
        local attackRange = 20 
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        local punchRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Punch")
        local args = { 0 } 

        if not rootPart or not humanoid or humanoid.Health <= 0 then
            return
        end

        local nearestTargetRoot, distance = getNearestTargetRoot(selectedMobNames, rootPart)

        if not nearestTargetRoot then
            return
        end

        local targetPosition = nearestTargetRoot.Position
        local targetCFrame = nearestTargetRoot.CFrame
        
        -- คำนวณตำแหน่งด้านหลังม็อบที่ต้องการยืน (Desired Position)
        local desiredPositionCFrame = targetCFrame * CFrame.new(0, 0, offset) 

        if distance <= attackRange then
            -- ********** โจมตี **********
            local rotationCFrame = CFrame.lookAt(rootPart.Position, targetPosition)
            local finalCFrame = CFrame.new(desiredPositionCFrame.Position) * rotationCFrame.Rotation

            rootPart.CFrame = finalCFrame
            punchRemote:FireServer(unpack(args))
            humanoid:MoveTo(rootPart.Position) 

            FreezMobs()
        else
            -- ********** เคลื่อนที่เข้าหา **********
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
            end
            humanoid:MoveTo(desiredPositionCFrame.Position)
        end
    end

    local autoAttackMoblist = Tabs.ESPM:AddToggle("AttackMobESPToggle", {Title = "Attack Mob ESP", Default = false })

    autoAttackMoblist:OnChanged(function()
        if autoAttackMoblist.Value then 
            if not heartbeatConnection then
                heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(startAttackMobList)
            end
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
        end
    end)

    -----------------------------------------------------------------------------------------------------------------

    Tabs.Main:AddButton({
        Title = "Freeze All Mob",
        Description = "Just Freeze The Mob",
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
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local herbsFolder = workspace:WaitForChild("Herbs")
        for _, instance in ipairs(herbsFolder:GetDescendants()) do
            if instance:IsA("ProximityPrompt") then
                local prompt = instance
                local targetPart = prompt.Parent
                if targetPart:IsA("BasePart") then
                    local distance = (targetPart.Position - rootPart.Position).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration)
                        prompt:InputHoldEnd()
                    end
                elseif targetPart:IsA("Model") and targetPart.PrimaryPart then
                    local distance = (targetPart.PrimaryPart.Position - rootPart.Position).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration)
                        prompt:InputHoldEnd()
                    end
                else
                    local distance = (targetPart.WorldPivot.Position - rootPart.Position).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration)
                        prompt:InputHoldEnd()
                    end
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

    -----------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------
    -- local Players = game:GetService("Players")
    -- local RunService = game:GetService("RunService")
    -- local LocalPlayer = Players.LocalPlayer

    -- local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    -- local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    -- local Humanoid = Character:WaitForChild("Humanoid")

    -- local herbsFolder = game.Workspace:WaitForChild("Herbs")
    -- local herbNames = {}
    -- local selectedHerbName = nil
    -- local isWarping = false
    -- local currentWarpThread = nil
    -- local warpRange = 10 -- กำหนดระยะที่อนุญาตให้ใช้ CFrame วาร์ป

    -- if not Tabs then
    --     warn("Tabs is not defined. Please ensure the framework/library is loaded correctly.")
    --     return
    -- end

    -- local function loadHerbNames()
    --     herbNames = {}
    --     for _, herb in pairs(herbsFolder:GetChildren()) do
    --         table.insert(herbNames, herb.Name)
    --     end
    --     local uniqueHerbNames = {}
    --     for _, herbName in pairs(herbNames) do
    --         if not table.find(uniqueHerbNames, herbName) then
    --             table.insert(uniqueHerbNames, herbName)
    --         end
    --     end
        
    --     table.sort(uniqueHerbNames) 
        
    --     return uniqueHerbNames
    -- end

    -- local uniqueHerbNames = loadHerbNames()

    -- local HerbListDropdownWarp = Tabs.AutoHerb:AddDropdown("SelectHerbWarp", {
    --     Title = "Select Herb to Auto Collect",
    --     Description = "Select the type of herb for collection.",
    --     Values = uniqueHerbNames,
    --     Multi = false, 
    --     Default = uniqueHerbNames[1] or "None",
    -- })

    -- local updateThread = nil

    -- local function updateHerbList()
    --     -- รันในลูปเพื่ออัปเดต
    --     while true do
    --         local newUniqueHerbNames = loadHerbNames()
            
    --         -- ตรวจสอบว่ารายการมีการเปลี่ยนแปลงหรือไม่ก่อนอัปเดต GUI
    --         if #newUniqueHerbNames ~= #HerbListDropdownWarp.Values or 
    --         newUniqueHerbNames[1] ~= HerbListDropdownWarp.Values[1] then
                
    --             -- อัปเดต Dropdown ด้วยรายการใหม่
    --             HerbListDropdownWarp:SetValues(newUniqueHerbNames)
    --         end
            
    --         -- รอ 10 วินาทีก่อนอัปเดตอีกครั้ง
    --         task.wait(10) 
    --     end
    -- end

    -- -- เริ่มการทำงานของ Updater ทันทีที่โหลดโค้ด
    -- if not updateThread then
    --     updateThread = task.spawn(updateHerbList)
    -- end

    -- -- ลบ WarpSpeedSlide ที่ใช้ Tween ออกไป

    -- local WarpToggle = Tabs.AutoHerb:AddToggle("AutoWarpToggle", {
    --     Title = "Start Auto Herb Collect", 
    --     Default = false 
    -- })

    -- local function findNearestHerb(herbName)
    --     local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    --     local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    --     local Humanoid = Character:WaitForChild("Humanoid")
    --     if not HumanoidRootPart then return nil, math.huge end

    --     local nearestHerb = nil
    --     local minDistance = math.huge

    --     for _, herb in pairs(herbsFolder:GetChildren()) do
    --         if herb.Name == herbName then
    --             local herbPosition = nil
    --             local distance = math.huge

    --             if herb:IsA("BasePart") then
    --                 herbPosition = herb.Position
    --             elseif herb:IsA("Model") and herb.PrimaryPart then
    --                 herbPosition = herb.PrimaryPart.Position
    --             elseif herb.WorldPivot then
    --                 herbPosition = herb.WorldPivot.Position
    --             end

    --             if herbPosition then
    --                 distance = (HumanoidRootPart.Position - herbPosition).Magnitude
    --                 if distance < minDistance then
    --                     minDistance = distance
    --                     nearestHerb = herb
    --                 end
    --             end
    --         end
    --     end
        
    --     return nearestHerb, minDistance
    -- end

    -- -- ลบฟังก์ชัน warp() ที่ใช้ Tween ออกไป

    -- local function autoCollectLoop()
    --     local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    --     local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    --     local Humanoid = Character:WaitForChild("Humanoid")
    --     local lastHerbWarped = nil 
        
    --     local MOVE_TO_OFFSET_Y = 3   -- สำหรับ MoveTo: ให้ลอยเหนือพื้น 3 หน่วยขณะเดิน
    --     local WARP_OFFSET_Y = 1      -- สำหรับ CFrame Warp: ให้ยืนอยู่เหนือ Herb 1 หน่วย

    --     while isWarping do
    --         if selectedHerbName and selectedHerbName ~= "None" then
    --             local nearestHerb, distance = findNearestHerb(selectedHerbName)

    --             if nearestHerb then
    --                 local herbPosition = nil
    --                 if nearestHerb:IsA("BasePart") then
    --                     herbPosition = nearestHerb.Position
    --                 elseif nearestHerb:IsA("Model") and nearestHerb.PrimaryPart then
    --                     herbPosition = nearestHerb.PrimaryPart.Position
    --                 elseif nearestHerb.WorldPivot then
    --                     herbPosition = nearestHerb.WorldPivot.Position
    --                 end

    --                 if herbPosition then
                        
    --                     if distance <= warpRange then
    --                         -- **[เงื่อนไขการวาร์ป]: เข้าสู่ระยะวาร์ป (<= 7)**
                            
    --                         local targetPosition = herbPosition + Vector3.new(0, WARP_OFFSET_Y, 0)
                            
    --                         HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                            
    --                         Humanoid.PlatformStand = true
    --                         task.wait(0.2) 
                            
    --                         Humanoid.PlatformStand = false
    --                         task.wait(0.5) 
                            
    --                     else
    --                         -- **[เงื่อนไขการเดิน]: อยู่นอกระยะวาร์ป (> 7)**

    --                         local targetPosition = herbPosition + Vector3.new(0, MOVE_TO_OFFSET_Y, 0)

    --                         -- **การแก้ไขปัญหาการลอย: สั่งกระโดดเฉพาะเมื่ออยู่บนพื้น**
    --                         if Humanoid.FloorMaterial ~= Enum.Material.Air then
    --                             Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
    --                         end
                            
    --                         -- สั่งให้เดินไปหาตำแหน่งนั้นด้วย MoveTo
    --                         Humanoid:MoveTo(targetPosition)
    --                         task.wait(0.1) 
    --                     end
    --                 else
    --                     task.wait(1)
    --                 end
    --             else
    --                 -- ไม่พบ Herb ที่เลือก
    --                 task.wait(1) 
    --             end
    --         else
    --             task.wait(1) 
    --         end
    --     end
    -- end

    -- HerbListDropdownWarp:OnChanged(function(value)
    --     selectedHerbName = value
    -- end)

    -- local Noclip = nil
    -- local Clip = nil

    -- function noclip()
    --     Clip = false
    --     local function Nocl()
    --         if Clip == false and game.Players.LocalPlayer.Character ~= nil then
    --             for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    --                 if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
    --                     v.CanCollide = false
    --                 end
    --             end
    --         end
    --         wait(0.21) -- basic optimization
    --     end
    --     Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
    -- end

    -- function clip()
    --     if Noclip then Noclip:Disconnect() end
    --     Clip = true
    -- end

    -- -- ตัวแปรนี้ถูกใช้ใน DeathFirstFunction ซึ่งไม่มีการประกาศในโค้ดเดิม
    -- local firstTimeUsingDeath = true

    -- local function DeathFirstFunction()
    --     local player = game.Players.LocalPlayer
    --     local Character = player.Character or player.CharacterAdded:Wait()
        
    --     if firstTimeUsingDeath then
    --         local humanoid = Character:FindFirstChild("Humanoid")
            
    --         if humanoid then
    --             humanoid.Health = 0
    --         end

    --         -- รอจนกระทั่งตัวละครใหม่ถูกโหลด
    --         while player.Character == nil or player.Character:FindFirstChild("Humanoid") == nil do
    --             task.wait(0.1)
    --         end

    --         local newCharacter = player.Character
    --         local humanoid = newCharacter:FindFirstChild("Humanoid")

    --         if humanoid then
    --             print("ตัวละครใหม่เกิดขึ้นแล้ว!")
    --             task.wait(2)
    --         end

    --         firstTimeUsingDeath = false
    --     end
    -- end

    -- WarpToggle:OnChanged(function(enabled)
    --     local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    --     local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    --     local Humanoid = Character:WaitForChild("Humanoid")
    --     isWarping = enabled
        
    --     if enabled then
    --         DeathFirstFunction()
    --         task.wait(0.5)
            
    --         -- ปิด Anti-Cheat Scripts (ควรตั้งค่า Scripts เหล่านี้ตามชื่อจริงในเกม)
    --         local StarterPlayer = game:GetService("StarterPlayer")
    --         if game.Players.LocalPlayer.Character:FindFirstChild("AntiNoclip") then
    --             game.Players.LocalPlayer.Character.AntiNoclip.Disabled = true
    --         end
    --         if StarterPlayer.StarterCharacterScripts:FindFirstChild("AntiNoclip") then
    --             StarterPlayer.StarterCharacterScripts.AntiNoclip.Disabled = true
    --         end
            
    --         -- noclip()
            
    --         if selectedHerbName and selectedHerbName ~= "None" then
    --             currentWarpThread = task.spawn(autoCollectLoop)
    --         else
    --             warn("Please select a herb from the dropdown first.")
    --             WarpToggle:SetValue(false)
    --         end
    --     else
    --         -- clip()
            
    --         print("Auto Collect Stopped.")
    --         if currentWarpThread then
    --             -- ยกเลิก Thread ถ้าจำเป็น (แต่การตั้งค่า isWarping = false ก็เพียงพอ)
    --             currentWarpThread = nil
    --         end
    --     end
    -- end)

    -- Tabs.AutoHerb:AddParagraph({
    --     Title = "------------------------  This below is faster version  ------------------------",
    -- })

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
        herbNames = {}
        for _, herb in pairs(herbsFolder:GetChildren()) do
            table.insert(herbNames, herb.Name)
        end
        local uniqueHerbNames = {}
        for _, herbName in pairs(herbNames) do
            if not table.find(uniqueHerbNames, herbName) then
                table.insert(uniqueHerbNames, herbName)
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

        for _, herb in pairs(herbsFolder:GetChildren()) do
            if type(herbList) == "table" and herbList[herb.Name] == true then
                
                local herbPos = nil
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
            print("Clear all selections.")
            savedSelection = {} 
            selectedHerbNameFast = {}
            HerbListDropdownWarpFast:SetValue({}) 
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

    local AutoAttack = Tabs.Main:AddToggle("AutoAttackToggle", {Title = "Auto Attack", Default = false })
    local IsAutoAttack = false

    AutoAttack:OnChanged(function()
        if Options.AutoAttackToggle.Value then
            IsAutoAttack = true
            while IsAutoAttack do
                local args = {
                    0
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Punch"):FireServer(unpack(args))
                task.wait(0.2)
            end

        else
            IsAutoAttack = false 
        end
        print("Toggle changed:", Options.AutoAttackToggle.Value)
    end)

    Options.AutoAttackToggle:SetValue(false)

    Tabs.Main:AddButton({
        Title = "HOP Server",
        Description = "Click To Teleport HOP Server",
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

end

Window:SelectTab(1)


--------------- auto breaktrou

-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Breakthrough"):FireServer()


-- ------------------------------------- auto craft potion

-- local args = {
-- 	"Qi Gathering"
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CraftPill"):FireServer(unpack(args))
