local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local ALLOWED_GAME_ID = 1235188606
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
end

local Window = Fluent:CreateWindow({
    Title = "Dragon Adventure | 2.0.2",
    SubTitle = "By Vichian",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    Attack = Window:AddTab({ Title = "Attack", Icon = "swords" }),
    Fishing = Window:AddTab({ Title = "Fishing", Icon = "fish" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Alert",
    Content = "Script Loaded.",
    Duration = 8
})

do
    local EggCollectToggle = Tabs.Main:AddToggle("EggCollect", {Title = "AUTO - Collect(EGG)", Default = false })
    local isCollectingEgg = false

    local function collectEggs()
        for _, v in pairs(workspace.Interactions.Nodes.Eggs.ActiveNodes:GetDescendants()) do
            if v.Name == "Egg" then
                local eggPosition = v.Position
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(eggPosition + Vector3.new(0, 5, 0))
                
                wait(1)
                
                for i = 1, 20 do
                    local args = { tostring(i) }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CollectEggRemote"):InvokeServer(unpack(args))
                end
                
                break
            end
        end
    end
    
    EggCollectToggle:OnChanged(function()
        if Options.EggCollect.Value then
            isCollectingEggs = true
            while isCollectingEggs do
                collectEggs()
                wait(0.5)
            end
        else
            isCollectingEggs = false
        end
        print("Toggle changed:", Options.EggCollect.Value)
    end)

    Options.EggCollect:SetValue(false)

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function getDragonNumber()
        local dragonsFolder = game.Players.LocalPlayer.Character:WaitForChild("Dragons")
        local dragonNumbers = {}

        for _, child in pairs(dragonsFolder:GetChildren()) do
            if tonumber(child.Name) then 
                table.insert(dragonNumbers, child.Name) 
            end
        end
        return dragonNumbers[1]
    end

    local function attackTree(billboardPart)
        local dragonNumber = getDragonNumber()
        local args = {
            "Breath",
            "Destructibles",
            billboardPart
        }

        if dragonNumber then
            local playSoundRemote = game:GetService("Players").LocalPlayer.Character:WaitForChild("Dragons"):WaitForChild(dragonNumber):WaitForChild("Remotes"):WaitForChild("PlaySoundRemote")

            if playSoundRemote then
                playSoundRemote:FireServer(unpack(args))
                print("Attack sent to tree at position: " .. tostring(billboardPart.Position))
            else
                print("PlaySoundRemote not found.")
            end
        else
            print("No valid dragon number found.")
        end
    end

    local function AutoHarvest()
        while Options.HarvestToggle.Value do
            local trees = {}
            
            for _, v in pairs(workspace.Interactions.Nodes.Resources:GetDescendants()) do
                if v.Name == "LargeResourceNode" then
                    table.insert(trees, v)
                end
            end

            for _, v in pairs(workspace.Interactions.Nodes.Food:GetDescendants()) do
                if v.Name == "LargeFoodNode" then
                    table.insert(trees, v)
                end
            end

            for _, tree in ipairs(trees) do
                local part = tree:FindFirstChildWhichIsA("BasePart")
                
                if part then
                    local treePosition = part.Position
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition)
                    wait(1)

                    local billboardPart = tree:FindFirstChild("BillboardPart")
                    
                    if billboardPart then
                        for _ = 1, 30 do
                            attackTree(billboardPart)
                            task.wait(0.25)
                        end
                    else
                        print("BillboardPart not found, moving to next tree.")
                    end
                end
                print("Finished attacking, moving to next tree.")
            end

            print("All trees have been processed. Restarting...")
            wait(1)
        end
        print("Harvesting stopped.")
    end

    local HarvestCollectToggle = Tabs.Main:AddToggle("HarvestToggle", {Title = "AUTO - Harvest", Default = false })
    local isCollectingHarvest = false

    HarvestCollectToggle:OnChanged(function()
        if Options.HarvestToggle.Value then
            isCollectingHarvest = true
            AutoHarvest()
        else
            isCollectingHarvest = false
            print("Harvesting stopped.")
        end
        print("Toggle changed:", Options.HarvestToggle.Value)
    end)

    Options.HarvestToggle:SetValue(false)

    -----------------------------------------------------------------------------------------------------------------

    local Aspd = 1

    local AttackSpeedSlider = Tabs.Attack:AddSlider("AttackSpeed", {
        Title = "AttackSpeed",
        Description = "0 is faster",
        Default = 1,
        Min = 0,
        Max = 2,
        Rounding = 2,
        Callback = function(ASPD)
            Aspd = ASPD
        end
    })

    AttackSpeedSlider:SetValue(1)

    local AttackMobToggle = Tabs.Attack:AddToggle("AttackMob", {Title = "AUTO - AttackMob", Default = false })
    local isAutoAttackingMob = false
    local firstStart = false

    local lastPosition = nil
    local attackCount = 0

    local function autoAttackMob()
        local mobFolder = workspace:FindFirstChild("MobFolder")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local dragonNumber = getDragonNumber()

        if not mobFolder or not dragonNumber then return end

        for _, mob in ipairs(mobFolder:GetChildren()) do
            local target = mob:FindFirstChild(mob.Name)
            if target and target:IsA("BasePart") then
                local targetPos = target.Position

                -- ถ้าเคยวาร์ปตำแหน่งนี้แล้ว ให้ข้าม
                if lastPosition and (lastPosition - targetPos).Magnitude < 1 then
                    continue
                end

                local healthValue = mob:FindFirstChild("Health") or target:FindFirstChild("Health")
                if not healthValue then
                    for _, desc in ipairs(mob:GetDescendants()) do
                        if desc.Name == "Health" and desc:IsA("NumberValue") then
                            healthValue = desc
                            break
                        end
                    end
                end

                if healthValue and healthValue.Value == 0 then
                    if lastPosition and (lastPosition - targetPos).Magnitude < 1 then
                        print("มอนตัวที่สองตาย รีเซ็ตตำแหน่ง")
                        lastPosition = nil
                        attackCount = 0
                    end
                    continue
                end

                humanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 0))
                lastPosition = targetPos
                attackCount += 1

                local args = {
                    "Breath",
                    "Mobs",
                    target
                }

                local dragon = character:WaitForChild("Dragons"):FindFirstChild(dragonNumber)
                if dragon then
                    local remote = dragon:FindFirstChild("Remotes"):FindFirstChild("PlaySoundRemote")
                    if remote then
                        remote:FireServer(unpack(args))
                    end
                end

                break 
            end
        end
    end

    AttackMobToggle:OnChanged(function()
        if Options.AttackMob.Value then
            isAutoAttackingMob = true
            task.spawn(function()
                while isAutoAttackingMob do
                    autoAttackMob()
                    task.wait(Aspd)
                end
            end)
        else
            isAutoAttackingMob = false
            firstStart = false
        end
    end)

    Options.AttackMob:SetValue(false)

    --------------------------------------------------------------------------------------------

    local AutoFishingToggle = Tabs.Fishing:AddToggle("AutoFishing", {Title = "AUTO - Fishing[Test]", Default = false })
    local isAutoFishing = false
    local isStartingFishing = false
    local isMinigame = false
    local Player = game:GetService("Players")
    local LocalPlayer = Player.LocalPlayer
    local GUI = LocalPlayer.PlayerGui
    local GuiService = game:GetService("GuiService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local FishingGui = GUI:FindFirstChild("FishingGui")
    local isFishingComplete = false  -- ตัวแปรใหม่ เพื่อเก็บสถานะการตกปลาว่าจบหรือยัง
    local isMinigameComplete = false  -- ตัวแปรใหม่ เพื่อเก็บสถานะมินิเกมส์ว่าเสร็จหรือยัง

    -------------- กดเริ่มตกปลา
    function StartFishing()
        if not isStartingFishing then
            isMinigame = false
            isFishingComplete = false  -- เริ่มตกปลาใหม่
            if FishingGui and FishingGui.Enabled then
                local ContainerFrame = FishingGui:FindFirstChild("ContainerFrame")
                if ContainerFrame then
                    local ButtonsFrame = ContainerFrame:FindFirstChild("ButtonsFrame")
                    if ButtonsFrame then
                        local FishButton = ButtonsFrame:FindFirstChild("FishButton") 
                        if FishButton then
                            task.wait(0.001)
                            GuiService.SelectedCoreObject = FishButton
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            isStartingFishing = true
                            
                            -- รอให้การตกปลาสำเร็จ (จะรอเวลา 3 วินาทีเพื่อให้มินิเกมส์พร้อม)
                            task.wait(3)  -- ปรับเวลาตามที่ต้องการ
                            isFishingComplete = true
                        end
                    end
                end
            end
        end
    end

    -------------------- กดหมุนเบ็ด
    function ProcessFishing()
        if isFishingComplete and not isMinigame then
            if FishingGui and FishingGui.Enabled then
                local ContainerFrame = FishingGui:FindFirstChild("ContainerFrame")
                if ContainerFrame then
                    local ButtonsFrame = ContainerFrame:FindFirstChild("ButtonsFrame")
                    if ButtonsFrame then
                        local ReelButton = ButtonsFrame:FindFirstChild("ReelButton") 
                        if ReelButton then
                            local CatchLabel = ReelButton:FindFirstChild("CatchLabel") 
                            if CatchLabel and CatchLabel.Visible then
                                task.wait(0.001)
                                GuiService.SelectedCoreObject = ReelButton
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                isMinigame = true
                                isFishingComplete = false  -- ปิดสถานะตกปลาแล้ว

                                -- เริ่มมินิเกมส์
                                ProcessMinigame()
                            end
                        end
                    end
                end
            end
        end
    end
    ----------------------- มินิเกมส์

    local tolerance = 50
    local lastProcessed = 0  -- ตัวแปรเก็บเวลาในการกดครั้งล่าสุด

    function ProcessMinigame()
        while isMinigame do
            wait(0.5)  -- หน่วงเวลาในการตรวจสอบ

            -- ตรวจสอบว่าเวลาผ่านไปแล้วหรือยัง
            if tick() - lastProcessed > 1 then  -- กดได้ใหม่เมื่อผ่านไป 1 วินาที
                if FishingGui and FishingGui.Enabled then
                    local ContainerFrame = FishingGui:FindFirstChild("ContainerFrame")
                    if ContainerFrame then
                        local ButtonsFrame = ContainerFrame:FindFirstChild("ButtonsFrame")
                        local ReelingFrame = ContainerFrame:FindFirstChild("ReelingFrame")
                        if ReelingFrame and ButtonsFrame then
                            local ReelButton = ButtonsFrame:FindFirstChild("ReelButton") 
                            local SpinRingFrame = ReelingFrame:FindFirstChild("SpinRingFrame") 
                            local SpinReelLabel = ReelingFrame:FindFirstChild("SpinReelLabel")
                            if SpinRingFrame and SpinReelLabel then
                                local spinRingRotation = math.floor(SpinRingFrame.Rotation)
                                local spinReelLabelRotation = math.floor(SpinReelLabel.Rotation)

                                -- เช็คว่าการหมุนเสร็จแล้วหรือยัง
                                if math.abs(spinRingRotation - spinReelLabelRotation) <= tolerance then
                                    print("Success")

                                    -- อัพเดทเวลาของการกดครั้งล่าสุด
                                    lastProcessed = tick()

                                    -- กดปุ่ม ReelButton ใหม่
                                    task.wait(0.001)
                                    GuiService.SelectedCoreObject = ReelButton
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                end
                            end
                        end
                    end
                end
            end

            -- ตรวจสอบว่า SpinRingFrame.Value == false หรือยัง (มินิเกมส์จบแล้ว)
            local SpinRingFrame = FishingGui:FindFirstChild("ContainerFrame")
                and FishingGui.ContainerFrame:FindFirstChild("ReelingFrame")
                and FishingGui.ContainerFrame.ReelingFrame:FindFirstChild("SpinRingFrame")

            if SpinRingFrame and not SpinRingFrame.Value then
                print("Minigame Finished!")
                isMinigame = false  -- เปลี่ยนสถานะมินิเกมส์เป็นจบ
            end
        end
    end


    AutoFishingToggle:OnChanged(function()
        if Options.AutoFishing.Value then
            isAutoFishing = true
            task.spawn(function()
                while isAutoFishing do
                    if not isStartingFishing then
                        StartFishing()
                    elseif isStartingFishing and not isMinigame then
                        ProcessFishing()
                    elseif isMinigame then
                        ProcessMinigame()
                    end
                    task.wait(0.1)
                end
            end)
        else
            isAutoFishing = false
            isStartingFishing = false
            isMinigame = false
        end
    end)

    Options.AutoFishing:SetValue(false)

end

Window:SelectTab(1)
