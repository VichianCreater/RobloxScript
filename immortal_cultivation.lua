-- 10-Year Ginseng
-- 1-Year Ginseng

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local ALLOWED_GAME_ID = 7862121304
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
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
    ESPH = Window:AddTab({ Title = "ESP Herb", Icon = "eye" }),
    ESPM = Window:AddTab({ Title = "ESP Mob", Icon = "eye" }),
    AutoHerb = Window:AddTab({ Title = "Auto Herb", Icon = "leaf" }),
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Alert",
    Content = "Script Loaded.",
    Duration = 8
})

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
    local herbESPtoggle = Tabs.ESPH:AddToggle("HerbESPToggle", {Title = "Show Herb ESP", Default = false })
    local espObjects = {}
    local herbNames = {}
    local selectedHerbName = nil
    local HerbListDropdown = Tabs.ESPH:AddDropdown("SelectHerb", {
        Title = "SelectHerb",
        Description = "You can select multiple Herb.",
        Values = {},
        Multi = true,
        Default = {"None", "Null"},
    })

    local function createESP(object)

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Adornee = object
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 200, 0, 70) -- เพิ่มขนาดในแนวตั้ง
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true

        -- 1. TextLabel สำหรับชื่อสมุนไพร (บรรทัดที่ 1)
        local nameTextLabel = Instance.new("TextLabel")
        nameTextLabel.Parent = billboardGui
        nameTextLabel.Text = object.Name
        nameTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameTextLabel.Position = UDim2.new(0, 0, 0, 0)
        nameTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTextLabel.TextStrokeTransparency = 0.8
        nameTextLabel.TextSize = 10
        nameTextLabel.BackgroundTransparency = 1

        -- 2. TextLabel สำหรับ ObjectText (บรรทัดที่ 2)
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
        end

        objectTextLabel.Text = objectText
        
        table.insert(espObjects, billboardGui)
    end

    local function removeESP()
        for _, billboardGui in pairs(espObjects) do
            if billboardGui and billboardGui.Parent then
                billboardGui:Destroy()
            end
        end
        espObjects = {}
    end

    local function loadHerbNames()
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
        HerbListDropdown:SetValues(uniqueHerbNames)
    end

    HerbListDropdown:OnChanged(function(value)
        removeESP()
        local selectedHerbNames = {}
        for herbName, isSelected in pairs(value) do
            if isSelected then
                table.insert(selectedHerbNames, herbName)
            end
        end

        if herbESPtoggle.Value and #selectedHerbNames > 0 then
            for _, herb in pairs(herbsFolder:GetChildren()) do
                if table.find(selectedHerbNames, herb.Name) then
                    createESP(herb)
                end
            end
        end
    end)

    herbESPtoggle:OnChanged(function()
        if herbESPtoggle.Value then
            loadHerbNames()
        else
            removeESP()
            HerbListDropdown:SetValues({})
        end
    end)
    -- HerbListDropdown:SetValue("None") 

    -----------------------------------------------------------------------------------------------------------------
    local mobsFolder = game.Workspace:WaitForChild("Enemies")
    local mobESPtoggle = Tabs.ESPM:AddToggle("MobESPToggle", {Title = "Show Mob ESP", Default = false })
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
        billboardGui.Size = UDim2.new(0, 200, 0, 70) -- เพิ่มขนาดในแนวตั้ง
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true

        -- 1. TextLabel สำหรับชื่อสมุนไพร (บรรทัดที่ 1)
        local nameTextLabel = Instance.new("TextLabel")
        nameTextLabel.Parent = billboardGui
        nameTextLabel.Text = object.Name
        nameTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameTextLabel.Position = UDim2.new(0, 0, 0, 0)
        nameTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTextLabel.TextStrokeTransparency = 0.8
        nameTextLabel.TextSize = 10
        nameTextLabel.BackgroundTransparency = 1

        -- -- 2. TextLabel สำหรับ ObjectText (บรรทัดที่ 2)
        -- local objectTextLabel = Instance.new("TextLabel")
        -- objectTextLabel.Parent = billboardGui
        -- objectTextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        -- objectTextLabel.Position = UDim2.new(0, 0, 0.2, 0)
        -- objectTextLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        -- objectTextLabel.TextStrokeTransparency = 0.8
        -- objectTextLabel.TextSize = 8
        -- objectTextLabel.BackgroundTransparency = 1

        -- local objectText = "No Data (Attribute Missing)"
        
        -- local proximityPrompt = object:FindFirstChildOfClass("ProximityPrompt")

        -- if proximityPrompt then
        --     objectText = proximityPrompt.ObjectText

        --     if string.find(objectText, "1") then
        --         objectTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        --     end
        --     if string.find(objectText, "10") then
        --         objectTextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        --     end
        --     if string.find(objectText, "100") then
        --         objectTextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        --     end
        -- end

        -- objectTextLabel.Text = objectText
        
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
        for _, mob in pairs(mobsFolder:GetChildren()) do
            table.insert(mobNames, mob.Name)
        end
        local uniqueMobNames = {}
        for _, mobName in pairs(mobNames) do
            if not table.find(uniqueMobNames, mobName) then
                table.insert(uniqueMobNames, mobName)
            end
        end
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
            for _, mob in pairs(mobsFolder:GetChildren()) do
                if table.find(selectedMobNames, mob.Name) then
                    createESP(mob)
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
    -- HerbListDropdown:SetValue("None") 

    -----------------------------------------------------------------------------------------------------------------
    local function FreezMobs()
        for _, mob in ipairs(mobsFolder:GetChildren()) do
            if mob:IsA("Model") then
                local rootPart = mob:FindFirstChild("HumanoidRootPart")
                if rootPart and rootPart:IsA("BasePart") then
                    rootPart.Anchored = true
                end
            end
        end
    end

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
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    local herbsFolder = game.Workspace:WaitForChild("Herbs")
    local herbNames = {}
    local selectedHerbName = nil
    local isWarping = false
    local currentWarpThread = nil

    if not Tabs then
        warn("Tabs is not defined. Please ensure the framework/library is loaded correctly.")
        return
    end

    local function loadHerbNames()
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

    local uniqueHerbNames = loadHerbNames()

    local HerbListDropdownWarp = Tabs.AutoHerb:AddDropdown("SelectHerbWarp", {
        Title = "Select Herb to Auto Warp",
        Description = "Select the type of herb for continuous warping.",
        Values = uniqueHerbNames,
        Multi = false, 
        Default = uniqueHerbNames[1] or "None",
    })

    local warpSpeed = 2

    local WarpSpeedSlide = Tabs.AutoHerb:AddSlider("warpspeed", {
        Title = "Warp Time (Seconds)",
        Description = "Time taken to slide to the herb (Lower = Faster).",
        Default = 2,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(newTime)
            warpSpeed = newTime 
        end
    })

    local WarpToggle = Tabs.AutoHerb:AddToggle("AutoWarpToggle", {
        Title = "Start Auto Herb Warp", 
        Default = false 
    })

    local function findNearestHerb(herbName)
        if not HumanoidRootPart then return nil end

        local nearestHerb = nil
        local minDistance = math.huge

        for _, herb in pairs(herbsFolder:GetChildren()) do
            if herb.Name == herbName then
                if herb:IsA("BasePart") then
                    local distance = (HumanoidRootPart.Position - herb.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestHerb = herb
                    end
                elseif herb:IsA("Model") and herb.PrimaryPart then
                    local distance = (herb.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestHerb = herb
                    end
                else
                    local distance = (herb.WorldPivot.Position - HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestHerb = herb
                    end
                end
            end
        end
        
        return nearestHerb
    end

    -- ลบตัวแปร LIFT_HEIGHT, LIFT_DURATION, liftTweenInfo, landingTweenInfo

    local function warp(targetPosition)
        if not HumanoidRootPart then return end 
        
        local targetCFrame = CFrame.new(targetPosition)
    
        -- ตรวจสอบให้แน่ใจว่า warpSpeed เป็นตัวเลข (เพิ่มความทนทาน)
        local duration = tonumber(warpSpeed)
        if not duration or duration <= 0 then
            duration = 2 -- ใช้ค่าเริ่มต้นถ้ามีปัญหา
        end

        local tweenInfo = TweenInfo.new(
            duration, -- ใช้ duration ที่ได้รับการตรวจสอบแล้ว
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut
        )

        Humanoid.PlatformStand = true
        
        local warpTween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        warpTween:Play()
        warpTween.Completed:Wait()
        
        Humanoid.PlatformStand = false
    end

    local function autoWarpLoop()
        while isWarping do
            if selectedHerbName and selectedHerbName ~= "None" then
                local nearestHerb = findNearestHerb(selectedHerbName)
                
                if nearestHerb then
                    local targetPosition = nearestHerb.Position + Vector3.new(0, 5, 0)
                    
                    warp(targetPosition)
                    
                    print("Warped to: " .. nearestHerb.Name)
                    
                    task.wait(0.1) 
                else
                    print("No herb found. Waiting for respawn...")
                    task.wait(2) 
                end
            else
                task.wait(1) 
            end
        end
    end

    HerbListDropdownWarp:OnChanged(function(value)
        selectedHerbName = value
        print("Selected Herb: " .. selectedHerbName)
    end)

    local Noclip = nil
    local Clip = nil
    local floatName = "Head" -- ต้องกำหนดชื่อส่วนที่ไม่ต้องการให้ noclip ปิด (ถ้ามี)

    local function noclip()
        Clip = false
        local function Nocl()
            if Clip == false and game.Players.LocalPlayer.Character ~= nil then
                for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                        v.CanCollide = false
                    end
                end
            end
            task.wait(0.21)
        end
        Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
    end

    function clip()
        if Noclip then Noclip:Disconnect() end
        Clip = true
    end

    WarpToggle:OnChanged(function(enabled)
        isWarping = enabled
        
        if enabled then
            -- ใช้ noclip() ที่มีอยู่แล้ว
            game.Players.LocalPlayer.Character.AntiNoclip.Disabled = true -- หากเกมมี AntiNoclip
            noclip()
            
            if selectedHerbName and selectedHerbName ~= "None" then
                print("Auto Warp Started.")
                currentWarpThread = task.spawn(autoWarpLoop)
            else
                warn("Please select a herb from the dropdown first.")
                WarpToggle:SetValue(false)
            end
        else
            -- ใช้ clip() ที่มีอยู่แล้ว
            clip()
            
            print("Auto Warp Stopped.")
            if currentWarpThread then
                -- Note: การหยุด loop ทำได้โดย isWarping = false แต่การยกเลิก thread โดยตรงทำไม่ได้ง่ายๆ
                -- การตั้งค่าเป็น nil และการรอให้ loop จบ เป็นวิธีการที่ถูกต้องแล้ว
                currentWarpThread = nil
            end
        end
    end)

    -----------------------------------------------------------------------------------------------------------------

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

end

Window:SelectTab(1)

