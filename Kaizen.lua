local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")

local ALLOWED_GAME_ID = 6048923315
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
end

local Window = Fluent:CreateWindow({
    Title = "Kaizen | BETA",
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
    ESPC = Window:AddTab({ Title = "ESP Collectibles", Icon = "eye" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do

--------------------------------------------------------------------------------------------
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- ### [1] Variables & UI Setup ###
    local selectedToolName = ""
    local isAutoClickToolEnabled = false

    local ToolDropdown = Tabs.Main:AddDropdown("ToolSelector", {
        Title = "เลือกไอเทมที่จะใช้งาน",
        Values = {},
        Multi = false,
        Default = "",
    })

    local autoClickToggle = Tabs.Main:AddToggle("AutoClickTool", {
        Title = "Auto Use Item (เช็ค Transparency)",
        Default = false
    })

    -- ### [2] ฟังก์ชันช่วยเหลือ (Utility) ###

    -- ฟังก์ชันดึงรายชื่อไอเทมจาก Backpack และ Character
    local function updateBackpackItems()
        local toolNames = {}
        local added = {}

        local function checkFolder(folder)
            for _, tool in ipairs(folder:GetChildren()) do
                if tool:IsA("Tool") and not added[tool.Name] then
                    table.insert(toolNames, tool.Name)
                    added[tool.Name] = true
                end
            end
        end

        checkFolder(LocalPlayer.Backpack)
        if LocalPlayer.Character then checkFolder(LocalPlayer.Character) end

        table.sort(toolNames)
        ToolDropdown:SetValues(toolNames)
    end

    -- ฟังก์ชันจำลองการกดปุ่ม (Virtual Click)
    local function virtualClick(button)
        if button and button:IsA("GuiButton") then
            button.Selectable = true
            button.Active = true
            
            GuiService.SelectedCoreObject = button
            task.wait(0.01)
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            
            task.wait(0.05)
            GuiService.SelectedCoreObject = nil
        end
    end

    -- ### [3] เชื่อมต่อ UI Events ###

    ToolDropdown:OnChanged(function(Value)
        selectedToolName = Value
    end)

    autoClickToggle:OnChanged(function()
        isAutoClickToolEnabled = autoClickToggle.Value
    end)

    -- ### [4] Main Loop (เพิ่มระบบ Print สถานะการกด) ###

    task.spawn(function()
        while true do
            if isAutoClickToolEnabled and selectedToolName ~= "" then
                local neoHotbar = LocalPlayer.PlayerGui:FindFirstChild("NeoHotbar")
                local toolSlotsFolder = neoHotbar and neoHotbar.Hotbar.Buttons:FindFirstChild("ToolSlots")
                
                if toolSlotsFolder then
                    -- วนลูปเช็คทุกช่องใน Hotbar
                    for _, slot in ipairs(toolSlotsFolder:GetChildren()) do
                        
                        -- 1. หา Object ที่ชื่อว่า "Tool" (ตัวเก็บค่า Value)
                        local toolObject = slot:FindFirstChild("Tool")
                        
                        -- 2. หาปุ่ม ToolButton
                        local toolButton = slot:FindFirstChild("ToolButton")
                        
                        -- เช็คว่าใน Slot นี้มีทั้ง Object Tool และ ปุ่มกด หรือไม่
                        if toolObject and toolButton then
                            
                            -- 3. อ่านค่า Value ข้างใน Object Tool (เช็คว่าชื่อตรงกับที่เลือกไหม)
                            -- ใช้ tostring() กันเหนียวเผื่อ Value เป็น Instance
                            if tostring(toolObject.Value) == selectedToolName then
                                
                                -- 4. เข้าไปหา Outline เพื่อเช็ค Transparency
                                -- ใช้ :FindFirstChild(..., true) เพื่อค้นหาแบบ Recursive (หาทุกชั้นข้างใน)
                                local outline = toolButton:FindFirstChild("Outline", true)
                                
                                if outline then
                                    -- เงื่อนไข: ถ้า ImageTransparency เป็น 0 แปลว่า "ใส่แล้ว/ทำงานอยู่" จะไม่กด
                                    -- ถ้า ImageTransparency > 0 แปลว่า "ยังไม่ได้กด/หมดเวลา" จะทำการกด
                                    if outline.ImageTransparency > 0 then
                                        print("🚀 Action: กดปุ่ม " .. selectedToolName .. " | Slot: " .. slot.Name)
                                        
                                        virtualClick(toolButton)
                                        
                                        -- หน่วงเวลาเล็กน้อยเพื่อให้ Transparency อัปเดตเป็น 0
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.1) -- รอบการสแกน
        end
    end)

    -- Loop อัปเดตรายชื่อไอเทมใน Dropdown อัตโนมัติทุก 5 วินาที
    task.spawn(function()
        while true do
            updateBackpackItems()
            task.wait(5)
        end
    end)
--------------------------------------------------------------------------------------------
    -- ### [1] Variables เพิ่มเติม ###
    local isAutoSkillEnabled = false

    -- เพิ่ม Toggle ใน UI (Tab: Main)
    local autoSkillToggle = Tabs.Main:AddToggle("AutoSkillToggle", {
        Title = "Auto Skill (เมื่อปลดล็อค)",
        Default = false
    })

    -- ### [2] เชื่อมต่อ UI Event ###
    autoSkillToggle:OnChanged(function()
        isAutoSkillEnabled = autoSkillToggle.Value
    end)

    -- ### [3] Auto Skill Loop (เพิ่มระบบเช็คสี Stroke) ###

    task.spawn(function()
        while true do
            if isAutoSkillEnabled then
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local skillsFolder = playerGui and playerGui:FindFirstChild("HUD") 
                    and playerGui.HUD:FindFirstChild("HUDContainer")
                    and playerGui.HUD.HUDContainer.Right.ActiveMovesetDisplay.SkillsContainer.Container

                if skillsFolder then
                    -- วนลูปเช็คทุก SkillSlot
                    for _, skillSlot in ipairs(skillsFolder:GetChildren()) do
                        -- ตรวจสอบโครงสร้าง UI
                        local container = skillSlot:FindFirstChild("Container")
                        local interact = container and container:FindFirstChild("Interact")
                        
                        if interact then
                            local lock = interact:FindFirstChild("Lock")
                            local button = interact:FindFirstChild("Button")
                            local stroke = interact:FindFirstChild("Stroke") -- ตัวเช็คสถานะการเลือก
                            
                            if lock and button and stroke then
                                -- 1. เช็คสีของ Stroke (14, 211, 255)
                                local targetColor = Color3.fromRGB(14, 211, 255)
                                local currentColor = stroke.ImageColor3
                                
                                -- เช็คว่าสีปัจจุบัน "ไม่ใช่" สีฟ้า (ถ้าเป็นสีฟ้าคือเลือกอยู่ ให้ข้าม)
                                local isAlreadySelected = (math.abs(currentColor.R - targetColor.R) < 0.02 and 
                                                        math.abs(currentColor.G - targetColor.G) < 0.02 and 
                                                        math.abs(currentColor.B - targetColor.B) < 0.02)

                                if not isAlreadySelected then
                                    -- 2. เช็คว่าปลดล็อคหรือยัง (Lock.Visible == false)
                                    if lock.Visible == false then
                                        print("⚡ Auto Skill: ใช้สกิลช่อง " .. skillSlot.Name)
                                        virtualClick(button)
                                        
                                        task.wait(0.2) -- หน่วงเวลาป้องกันการกดซ้ำรัวๆ
                                    end
                                else
                                    -- print("Skipping: " .. skillSlot.Name .. " (Already Active)")
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)

--------------------------------------------------------------------------------------------

    local mobsFolder = game.Workspace:WaitForChild("Enemies")
    local bossesFolder = mobsFolder:WaitForChild("Bosses")
    local runService = game:GetService("RunService")
    local localPlayer = game.Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local replicatedStorage = game:GetService("ReplicatedStorage")

    -- ### [1] Variables ###
    local ESPParent = CoreGui:FindFirstChild("RobloxGui") or localPlayer:WaitForChild("PlayerGui")
    local mobEspObjects = {} 
    local currentSelectedMobNames = {} 
    local isAutoWarping = false
    local isESPEnabled = false
    local warpDistance = 3 

    local requestSkillRemote = replicatedStorage:WaitForChild("@rbxts/wcs:source/networking@GlobalEvents"):WaitForChild("requestSkill")
    local attackArgs = {{ buffer = buffer.fromstring("\029\000\000\000Movesets/FightingStyles/Fists\001\000\000\000\000"), blobs = {} }}

    -- ### [2] Utility Functions ###

    local function getRealMobName(mob)
        local val = mob:GetAttribute("EnemyName")
        if val then
            return mob:IsDescendantOf(bossesFolder) and "[BOSS] " .. val or val
        end
        return nil
    end

    local function getActiveMobs()
        local all = mobsFolder:GetChildren()
        for _, b in ipairs(bossesFolder:GetChildren()) do table.insert(all, b) end
        return all
    end

    -- ### [3] ESP System ###

    local function createMobESP(object)
        if mobEspObjects[object] then return end
        
        local realName = getRealMobName(object)
        if not realName then return end

        local adornPart = object:FindFirstChild("HumanoidRootPart") or object:FindFirstChild("Head")
        if not adornPart then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "ESP_Mob"
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 100, 0, 30)
        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
        bbg.Adornee = adornPart
        bbg.Enabled = false 
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = realName
        nameLabel.TextColor3 = string.find(realName, "BOSS") and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        bbg.Parent = ESPParent
        
        mobEspObjects[object] = bbg
    end

    local function updateESPVisibility()
        for mob, gui in pairs(mobEspObjects) do
            local name = getRealMobName(mob)
            if isESPEnabled and table.find(currentSelectedMobNames, name) then
                gui.Enabled = true
            else
                gui.Enabled = false
            end
        end
    end

    -- ### [4] UI Components (Tabs.ESPM) ###

    local MobListDropdown = Tabs.ESPM:AddDropdown("SelectMob", {
        Title = "เลือกมอนสเตอร์/บอส (Multi)",
        Values = {},
        Multi = true,
        Default = {},
    })

    local mobESPtoggle = Tabs.ESPM:AddToggle("MobESPToggle", {Title = "เปิดใช้งาน ESP มอนสเตอร์", Default = false })

    local WarpDistanceSlider = Tabs.ESPM:AddSlider("WarpDistance", {
        Title = "ระยะห่างขณะวาร์ป (Studs)",
        Description = "ปรับระยะห่างจากเป้าหมาย",
        Default = 3,
        Min = 1,
        Max = 15,
        Rounding = 1,
        Callback = function(Value)
            warpDistance = Value
        end
    })

    local warpToggle = Tabs.ESPM:AddToggle("WarpToggle", {Title = "Auto Warp + Attack", Default = false })

    -- ### [5] UI Logic & Events ###

    local function updateDropdown()
        local names = {}
        for _, mob in pairs(getActiveMobs()) do
            local n = getRealMobName(mob)
            if n and not table.find(names, n) then table.insert(names, n) end
        end
        table.sort(names)
        MobListDropdown:SetValues(names)
    end

    MobListDropdown:OnChanged(function(value)
        currentSelectedMobNames = {}
        for name, isSelected in pairs(value) do
            if isSelected then table.insert(currentSelectedMobNames, name) end
        end
        updateESPVisibility()
    end)

    mobESPtoggle:OnChanged(function()
        isESPEnabled = mobESPtoggle.Value
        updateESPVisibility()
    end)

    warpToggle:OnChanged(function()
        isAutoWarping = warpToggle.Value
        local char = localPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then 
            hum.PlatformStand = isAutoWarping -- กันตัวละครดีด
        end
    end)

    -- ตรวจจับมอนสเตอร์เกิด/ตาย (Event-Based เพื่อลด Lag)
    local function monitorFolder(folder)
        folder.ChildAdded:Connect(function(child)
            task.wait(0.5) 
            createMobESP(child)
            updateESPVisibility()
        end)
        folder.ChildRemoved:Connect(function(child)
            if mobEspObjects[child] then
                mobEspObjects[child]:Destroy()
                mobEspObjects[child] = nil
            end
        end)
    end

    monitorFolder(mobsFolder)
    monitorFolder(bossesFolder)

    -- Setup เริ่มต้น
    for _, m in pairs(getActiveMobs()) do createMobESP(m) end
    updateDropdown()

    -- ### [6] Main Loop (Auto Warp, LookAt & Attack) ###

    task.spawn(function()
        while true do
            if isAutoWarping then
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root then
                    -- หาเป้าหมายที่ใกล้ที่สุดในลิสต์ที่เลือก
                    local target, dist = nil, math.huge
                    for mob, _ in pairs(mobEspObjects) do
                        local rName = getRealMobName(mob)
                        local mRoot = mob:FindFirstChild("HumanoidRootPart")
                        local mHum = mob:FindFirstChild("Humanoid")
                        
                        if table.find(currentSelectedMobNames, rName) and mHum and mHum.Health > 0 and mRoot then
                            local d = (root.Position - mRoot.Position).Magnitude
                            if d < dist then
                                dist = d
                                target = mob
                            end
                        end
                    end

                    if target then
                        local tRoot = target:FindFirstChild("HumanoidRootPart")
                        local tHum = target:FindFirstChild("Humanoid")
                        
                        -- เกาะเป้าหมายจนกว่าจะตายหรือเลิกเปิดบอท
                        while isAutoWarping and target.Parent and tHum.Health > 0 and tRoot do
                            -- วาร์ปไปตำแหน่ง offset และใช้ lookAt เพื่อหันหน้าหาเป้าหมาย
                            local targetPos = tRoot.CFrame * Vector3.new(0, 0, warpDistance)
                            root.CFrame = CFrame.lookAt(targetPos, tRoot.Position)
                            
                            -- ส่ง Remote โจมตี
                            requestSkillRemote:FireServer(unpack(attackArgs))
                            
                            runService.Heartbeat:Wait()
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)

    -- อัปเดตรายชื่อมอนสเตอร์ใน Dropdown ทุก 10 วินาที
    task.spawn(function()
        while true do
            updateDropdown()
            task.wait(10)
        end
    end)

----------------------------------------------------------------------------------------------------
    local itemFolder = game.Workspace:WaitForChild("Collectibles")
    local runService = game:GetService("RunService")
    local localPlayer = game.Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")

    -- ### [1] Variables ###
    local success, targetParent = pcall(function() return CoreGui end)
    local ESPParent = success and targetParent or localPlayer:WaitForChild("PlayerGui")

    local itemEspObjects = {} 
    local currentSelectedItems = {} 
    local isItemESPEnabled = false
    local isItemWarping = false
    local isAutoCollectEnabled = false 

    -- ### [2] ระบบ UI (Tab: ESPC) ###

    local ItemListDropdown = Tabs.ESPC:AddDropdown("SelectItem", {
        Title = "เลือกไอเทมที่ต้องการ",
        Values = {},
        Multi = true,
        Default = {},
    })

    local itemESPtoggle = Tabs.ESPC:AddToggle("ItemESPToggle", {Title = "เปิดใช้งาน Item ESP", Default = false })
    local itemWarpToggle = Tabs.ESPC:AddToggle("ItemWarpToggle", {Title = "Auto Warp Items", Default = false })
    local autoCollectToggle = Tabs.ESPC:AddToggle("AutoCollectToggle", {Title = "Auto Collect (Auto E)", Default = false })

    -- ### [3] ฟังก์ชันช่วยเหลือ (Utility) ###

    -- ฟังก์ชันดึง CFrame ที่แน่นอน (รองรับทั้ง Part และ Model)
    local function getItemCFrame(item)
        if not item then return nil end
        if item:IsA("BasePart") then
            return item.CFrame
        elseif item:IsA("Model") then
            if item.PrimaryPart then
                return item.PrimaryPart.CFrame
            end
            local part = item:FindFirstChildWhichIsA("BasePart", true)
            if part then return part.CFrame end
        end
        return nil
    end

    -- ค้นหาไอเทมที่ใกล้ที่สุด
    local function getNextItemTarget()
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local target, dist = nil, math.huge
        local allItems = itemFolder:GetChildren()

        for _, item in ipairs(allItems) do
            -- เช็คว่าชื่อตรงกับที่เลือกหรือไม่
            local isMatch = false
            for _, name in pairs(currentSelectedItems) do
                if item.Name == name then
                    isMatch = true
                    break
                end
            end

            if isMatch and item.Parent == itemFolder then
                local cf = getItemCFrame(item)
                if cf then
                    local d = (root.Position - cf.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = item -- เก็บตัว Instance ไว้
                    end
                end
            end
        end
        return target
    end

    -- อัปเดตรายชื่อ Dropdown
    local function updateItemList()
        local nameMap = {}
        for _, item in pairs(itemFolder:GetChildren()) do
            if item.Name ~= "" then nameMap[item.Name] = true end
        end
        local nameList = {}
        for name, _ in pairs(nameMap) do table.insert(nameList, name) end
        table.sort(nameList)
        ItemListDropdown:SetValues(nameList)
    end

    -- ### [4] ฟังก์ชัน Auto Collect (ปรับปรุงใหม่) ###

    local function AutoCollectItems(targetItem) -- รับค่า targetItem มาด้วยเพื่อความแม่นยำ
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = character.HumanoidRootPart

        -- ถ้ามีการส่ง targetItem มา ให้เน้นกดที่ตัวนั้นตัวเดียว
        local targets = targetItem and {targetItem} or itemFolder:GetChildren()

        for _, item in ipairs(targets) do
            -- 1. เช็คว่าชื่อไอเทมตรงกับที่เลือกใน Dropdown หรือไม่
            if table.find(currentSelectedItems, item.Name) then
                local prompt = item:FindFirstChildOfClass("ProximityPrompt") or item:FindFirstChildWhichIsA("ProximityPrompt", true)
                
                if prompt and prompt.Enabled then
                    local cf = getItemCFrame(item)
                    if cf then
                        -- 2. เช็คระยะห่าง (ต้องอยู่ใกล้ไม่เกิน 10 studs ถึงจะกด)
                        local distance = (rootPart.Position - cf.Position).Magnitude
                        if distance <= 10 then 
                            -- ตั้งค่าให้กดทันที
                            prompt.HoldDuration = 0
                            
                            task.spawn(function()
                                -- ใช้ fireproximityprompt ถ้า Executor รองรับ (จะเสถียรกว่า)
                                if fireproximityprompt then
                                    fireproximityprompt(prompt)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait(0.1)
                                    prompt:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    -- ### [5] การทำงานของ ESP ###

    local function createItemESP(item)
        if itemEspObjects[item] then return end
        local adornPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
        if not adornPart then return end

        local bbg = Instance.new("BillboardGui")
        bbg.Name = "ItemESP"
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.new(0, 100, 0, 40)
        bbg.ExtentsOffset = Vector3.new(0, 2, 0)
        bbg.Adornee = adornPart
        bbg.Parent = ESPParent

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bbg
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = item.Name
        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

        itemEspObjects[item] = bbg
    end

    local function refreshItemESP()
        if not isItemESPEnabled then 
            for obj, gui in pairs(itemEspObjects) do if gui then gui:Destroy() end end
            itemEspObjects = {}
            return
        end
        for obj, gui in pairs(itemEspObjects) do
            if not obj.Parent or not table.find(currentSelectedItems, obj.Name) then
                if gui then gui:Destroy() end
                itemEspObjects[obj] = nil
            end
        end
        for _, item in pairs(itemFolder:GetChildren()) do
            if table.find(currentSelectedItems, item.Name) then
                createItemESP(item)
            end
        end
    end

    -- ### [6] เชื่อมต่อ Events ###

    ItemListDropdown:OnChanged(function(value)
        currentSelectedItems = {}
        for name, isSelected in pairs(value) do
            if isSelected then table.insert(currentSelectedItems, name) end
        end
        refreshItemESP()
    end)

    itemESPtoggle:OnChanged(function()
        isItemESPEnabled = itemESPtoggle.Value
        if isItemESPEnabled then updateItemList() end
        refreshItemESP()
    end)

    itemWarpToggle:OnChanged(function()
        isItemWarping = itemWarpToggle.Value
    end)

    autoCollectToggle:OnChanged(function()
        isAutoCollectEnabled = autoCollectToggle.Value
    end)

    -- ### [7] Loops การทำงาน (ฉบับแก้การค้าง) ###

    task.spawn(function()
        while true do
            if isItemWarping then
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root then
                    -- 1. ค้นหาเป้าหมายที่ใกล้ที่สุด
                    local target = getNextItemTarget()

                    if target then
                        local targetCF = getItemCFrame(target)
                        if targetCF then
                            -- 2. วาร์ปไปที่ไอเทม
                            root.CFrame = targetCF
                            
                            -- 3. สั่งเก็บเฉพาะเป้าหมายนั้น
                            if isAutoCollectEnabled then
                                AutoCollectItems(target)
                            end

                            -- 4. รอจนกว่าไอเทมจะถูกเก็บ (หายไปจาก Workspace) หรือ Time out
                            local timeout = 0
                            while target.Parent == itemFolder and timeout < 20 do -- รอสูงสุด 2 วินาที (20 * 0.1)
                                task.wait(0.1)
                                timeout = timeout + 1
                                -- ย้ำการกดเผื่อพลาด
                                if isAutoCollectEnabled and timeout % 5 == 0 then
                                    AutoCollectItems(target)
                                end
                            end
                        end
                    else
                        -- ถ้าไม่พบไอเทมที่เลือกเลย ให้รอ 1 วินาที
                        task.wait(1)
                    end
                end
            elseif isAutoCollectEnabled then
                -- กรณีเปิดแค่ Auto Collect อย่างเดียว (เดินไปเก็บเอง)
                AutoCollectItems()
                task.wait(0.3)
            end
            
            task.wait(0.1)
        end
    end)

    -- Loop อัปเดต ESP และ รายชื่อ (ทำงานเบื้องหลัง)
    task.spawn(function()
        while true do
            if isItemESPEnabled then
                updateItemList()
                refreshItemESP()
            end
            task.wait(3)
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

-- local args = {
-- 	{
-- 		buffer = buffer.fromstring("\029\000\000\000Movesets/FightingStyles/Fists\000\000\000\000\000"),
-- 		blobs = {}
-- 	}
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("@rbxts/wcs:source/networking@GlobalEvents"):WaitForChild("requestSkill"):FireServer(unpack(args))


-- local args = {
-- 	{
-- 		buffer = buffer.fromstring("\029\000\000\000Movesets/FightingStyles/Fists\001\000\000\000\000"),
-- 		blobs = {}
-- 	}
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("@rbxts/wcs:source/networking@GlobalEvents"):WaitForChild("requestSkill"):FireServer(unpack(args))

-- local args = {
-- 	{
-- 		buffer = buffer.fromstring("\029\000\000\000Movesets/FightingStyles/Fists\001\000\000\000\000"),
-- 		blobs = {}
-- 	}
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("@rbxts/wcs:source/networking@GlobalEvents"):WaitForChild("requestSkill"):FireServer(unpack(args))
