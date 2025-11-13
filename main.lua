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
    Title = "Dragon Adventure | 3.5.0",
    SubTitle = "By Vichian",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    TeleportMap = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Attack = Window:AddTab({ Title = "Attack", Icon = "swords" }),
    Fishing = Window:AddTab({ Title = "Fishing", Icon = "waves" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Alert",
    Content = "Script Loaded.",
    Duration = 8
})

do
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

    local dragonNumber = getDragonNumber()
    local localPlayer = game.Players.LocalPlayer
    local dragonWalkSpeed = localPlayer.Character.Dragons[dragonNumber].Data.MovementStats.WalkSpeed
    local WalkSpeedSlideBar = Tabs.Main:AddSlider("Walkspeed", {
        Title = "Dragon Walk Speed",
        Description = "Speed",
        Default = dragonWalkSpeed.Value,
        Min = dragonWalkSpeed.Value,
        Max = 1000,
        Rounding = 1,
        Callback = function(walkspeed)
            dragonWalkSpeed.Value = walkspeed
        end
    })

    WalkSpeedSlideBar:SetValue(dragonWalkSpeed.Value)

    local dragonFlySpeed = localPlayer.Character.Dragons[dragonNumber].Data.MovementStats.FlySpeed
    local FlySpeedSlideBar = Tabs.Main:AddSlider("FlySpeed", {
        Title = "Dragon Fly Speed",
        Description = "Speed",
        Default = dragonFlySpeed.Value,
        Min = dragonFlySpeed.Value,
        Max = 1000,
        Rounding = 1,
        Callback = function(FlySpeed)
            dragonFlySpeed.Value = FlySpeed
        end
    })

    FlySpeedSlideBar:SetValue(dragonFlySpeed.Value)
    --------------------------------------------------------------------------------------------------------------
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
        local breathArgs = {
            "Breath",
            "Destructibles",
            billboardPart
        }

        if dragonNumber then
            local playSoundRemote = game:GetService("Players").LocalPlayer.Character:WaitForChild("Dragons"):WaitForChild(dragonNumber):WaitForChild("Remotes"):WaitForChild("PlaySoundRemote")

            if playSoundRemote then
                playSoundRemote:FireServer(unpack(breathArgs))
            end
        end
    end

    local function attackTreeBite(billboardPart)
        local dragonNumber = getDragonNumber()

        local biteArgs = {
            "Bite",
            "Destructibles",
            billboardPart
        }
        local biteRemote = game:GetService("Players").LocalPlayer.Character:WaitForChild("Dragons"):WaitForChild(dragonNumber):WaitForChild("Remotes"):WaitForChild("PlaySoundRemote")
        
        if biteRemote then
            biteRemote:FireServer(unpack(biteArgs))
        end
    end

    local savedPositions = {}

    local function AutoHarvest()
        while Options.HarvestToggle.Value do
            local foodNodes = workspace.Interactions.Nodes.Food:GetChildren()
            local foundNode = false
            for _, foodNode in ipairs(foodNodes) do
                if foodNode.Name == "LargeFoodNode" then
                    local billboardPart = foodNode:FindFirstChild("BillboardPart")
                    
                    if billboardPart then
                        local Health = billboardPart:FindFirstChild("Health")
                        if Health and Health.Value > 0 then
                            local nodePosition = nil
                            if foodNode.PrimaryPart then
                                nodePosition = foodNode.PrimaryPart.Position
                            elseif foodNode:IsA("Model") then
                                local basePart = foodNode:FindFirstChildOfClass("BasePart")
                                if basePart then
                                    nodePosition = basePart.Position
                                end
                            end

                            if nodePosition then
                                local isPositionSaved = false
                                for _, savedPosition in ipairs(savedPositions) do
                                    if (savedPosition - nodePosition).Magnitude < 1 then 
                                        isPositionSaved = true
                                        break
                                    end
                                end
                                if not isPositionSaved then
                                    table.insert(savedPositions, nodePosition)
                                end
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(nodePosition)
                                task.wait(0.01)
                                while true do
                                    if Health and Health.Value > 0 then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(billboardPart.Position + Vector3.new(0, 0.5, 0))
                                        task.wait(0.15)
                                        attackTree(billboardPart)
                                        task.wait(0.15)
                                        attackTreeBite(billboardPart)
                                    else
                                        break
                                    end
                                end
                                foundNode = true
                            end
                        end
                    end
                end
            end
            if not foundNode then
                for _, position in ipairs(savedPositions) do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                    task.wait(0.01)
                end
            end
            task.wait(0.01)
        end
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
    ----------------------------------------------------------------------------------------
    local function MagnetEffect()
        local character = game.Players.LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end

        local HumanoidRootPart = character.HumanoidRootPart
        local targetPosition = HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) 
        local cameraFolder = game.Workspace.Camera 
        for _, item in ipairs(cameraFolder:GetChildren()) do
            if string.lower(item.Name):find("model") then
                if item:IsA("Model") then
                    local primaryPart = item.PrimaryPart
                    if primaryPart then
                        item:SetPrimaryPartCFrame(targetPosition)
                    end
                elseif item:IsA("BasePart") then
                    item.CFrame = targetPosition
                end
            end
        end
    end


    local MagnetCollectToggle = Tabs.Main:AddToggle("MagnetToggle", {Title = "Magnet Effect", Default = false })
    local isMagnetEffect = false

    MagnetCollectToggle:OnChanged(function()
        if Options.MagnetToggle.Value then
            isMagnetEffect = true
            while isMagnetEffect do
                task.wait(0.001)
                MagnetEffect()
            end
        else
            isMagnetEffect = false
            print("Harvesting stopped.")
        end
        print("Toggle changed:", Options.MagnetToggle.Value)
    end)

    Options.MagnetToggle:SetValue(false)
----------------------------------------------------------------------------------------------------

--     local function autoWarpToCurrencyNodes()
--         local player = game.Players.LocalPlayer
--         local character = player.Character or player.CharacterAdded:Wait()
--         local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--         local function findCurrencyNode(nodeName)
--             local currencyNodesFolder = workspace.Interactions.Nodes.CurrencyNodes.Spawned
--             local foundNodes = {}
--             for _, node in ipairs(currencyNodesFolder:GetChildren()) do
--                 if node.Name == nodeName then
--                     table.insert(foundNodes, node)
--                 end
--             end
            
--             return foundNodes
--         end
--         while true do
--             local experienceNodes = findCurrencyNode("Experience")
--             local megaExperienceNodes = findCurrencyNode("MegaExperience")
--             local allNodes = {}
--             for _, node in ipairs(experienceNodes) do
--                 table.insert(allNodes, node)
--             end
--             for _, node in ipairs(megaExperienceNodes) do
--                 table.insert(allNodes, node)
--             end
--             if #allNodes > 0 then
--                 for _, node in ipairs(allNodes) do
--                     local nodePosition = node.Position
--                     humanoidRootPart.CFrame = CFrame.new(nodePosition)
--                     task.wait(0.001)
--                 end
--             else
--                 task.wait(0.001)
--             end
--         end
--     end

--     local ExpCollgToggle = Tabs.Main:AddToggle("ExpToggle", {Title = "Auto Exp", Default = false })
--     local IsExpWarp = false

--     ExpCollgToggle:OnChanged(function()
--         if Options.ExpToggle.Value then
--             IsExpWarp = true
--             while IsExpWarp do
--                 task.wait(0.001)
--                 autoWarpToCurrencyNodes()
--             end
--         else
--             IsExpWarp = false
--             print("Harvesting stopped.")
--         end
--         print("Toggle changed:", Options.ExpToggle.Value)
--     end)

--     Options.ExpToggle:SetValue(false)

-- ----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------

--     local function autoWarpToCurrencyNodes()
--         local player = game.Players.LocalPlayer
--         local character = player.Character or player.CharacterAdded:Wait()
--         local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--         local function findCurrencyNode(nodeName)
--             local currencyNodesFolder = workspace.Interactions.Nodes.CurrencyNodes.Spawned
--             local foundNodes = {}
--             for _, node in ipairs(currencyNodesFolder:GetChildren()) do
--                 if node.Name == nodeName then
--                     table.insert(foundNodes, node)
--                 end
--             end
            
--             return foundNodes
--         end
--         while true do
--             local CoinNodes = findCurrencyNode("Coins")
--             local megaCoinNodes = findCurrencyNode("MegaCoins")
--             local allNodes = {}
--             for _, node in ipairs(CoinNodes) do
--                 table.insert(allNodes, node)
--             end
--             for _, node in ipairs(megaCoinNodes) do
--                 table.insert(allNodes, node)
--             end
--             if #allNodes > 0 then
--                 for _, node in ipairs(allNodes) do
--                     local nodePosition = node.Position
--                     humanoidRootPart.CFrame = CFrame.new(nodePosition)
--                     task.wait(0.001)
--                 end
--             else
--                 task.wait(0.001)
--             end
--         end
--     end

--     local CoinCollgToggle = Tabs.Main:AddToggle("CoinToggle", {Title = "Auto Coin", Default = false })
--     local IsCoinWarp = false

--     CoinCollgToggle:OnChanged(function()
--         if Options.CoinToggle.Value then
--             IsCoinWarp = true
--             while IsCoinWarp do
--                 task.wait(0.001)
--                 autoWarpToCurrencyNodes()
--             end
--         else
--             IsCoinWarp = false
--             print("Harvesting stopped.")
--         end
--         print("Toggle changed:", Options.CoinToggle.Value)
--     end)

--     Options.CoinToggle:SetValue(false)

----------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------

    local function MobAura()
        local mobFolder = workspace:FindFirstChild("MobFolder")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local dragonNumber = getDragonNumber()
        local attackRange = 100

        if not mobFolder or not dragonNumber then 
            print("MobFolder or dragonNumber not found.")
            return 
        end

        -- หามอนสเตอร์ใน mobFolder
        for _, mob in ipairs(mobFolder:GetChildren()) do
            local target = mob:FindFirstChild(mob.Name)
            if target and target:IsA("BasePart") then
                local targetPos = target.Position
                local distance = (humanoidRootPart.Position - targetPos).Magnitude

                if distance <= attackRange then

                    local healthValue = mob:FindFirstChild("Health") or target:FindFirstChild("Health")
                    if not healthValue then
                        for _, desc in ipairs(mob:GetDescendants()) do
                            if desc.Name == "Health" and desc:IsA("NumberValue") then
                                healthValue = desc
                                break
                            end
                        end
                    end
                    if healthValue and healthValue.Value > 0 then
                    
                        while healthValue and healthValue.Value > 0 do
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
                            task.wait(0.3)
                            healthValue = mob:FindFirstChild("Health") or target:FindFirstChild("Health")
                        end
                    end
                end
            end
        end
    end


    local AuraToggle = Tabs.Main:AddToggle("AuraToggle", {Title = "Attack Aura", Default = false })
    local IsAuraMob = false

    AuraToggle:OnChanged(function()
        if Options.AuraToggle.Value then
            IsAuraMob = true
            while IsAuraMob do
                task.wait(0.1)
                MobAura()
            end
        else
            IsAuraMob = false
        end
    end)

    Options.AuraToggle:SetValue(false)

    ----------------------------------------------------------------------------------------------------
    local function checkTreasureNodes()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local treasureNodes = workspace.Interactions.Nodes.Treasure:GetChildren()
        for _, node in ipairs(treasureNodes) do
            if node:FindFirstChild("BronzeChest") then
                local bronzeChest = node.BronzeChest
                if bronzeChest then
                    local cheatHealt = bronzeChest.HumanoidRootPart.Health
                    if cheatHealt and cheatHealt.Value > 0 then
                        local nodePosition = bronzeChest.WorldPivot.Position
                        humanoidRootPart.CFrame = CFrame.new(nodePosition + Vector3.new(0, 5, 0))
                    end
                end
            elseif node:FindFirstChild("SilverChest") then
                local silverChest = node.SilverChest
                if silverChest then
                    local cheatHealt = silverChest.HumanoidRootPart.Health
                    if cheatHealt and cheatHealt.Value > 0 then
                        local nodePosition = silverChest.WorldPivot.Position
                        humanoidRootPart.CFrame = CFrame.new(nodePosition + Vector3.new(0, 5, 0))
                    end
                end
            end
        end
    end

    local TreasureCollectToggle = Tabs.Main:AddToggle("TreasureToggle", {Title = "AUTO - Treasure", Default = false })
    local isCollectingTreasure = false

    TreasureCollectToggle:OnChanged(function()
        if Options.TreasureToggle.Value then
            isCollectingTreasure = true
            while isCollectingTreasure do
                checkTreasureNodes()
                task.wait(0.01)
            end
        else
            isCollectingTreasure = false
            print("Treasureing stopped.")
        end
        print("Toggle changed:", Options.TreasureToggle.Value)
    end)

    Options.TreasureToggle:SetValue(false)
    ----------------------------------------------------------------------------------------

    Tabs.Main:AddButton({
        Title = "Anti AFK",
        Description = "Click To Anti afk kick",
        Callback = function()
            local VirtualUser = game:GetService('VirtualUser')
 
            game:GetService('Players').LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    })

----------------------------------------------------------------------------------------------------
    local function ImmortalDragon()
        local dragonNumber = getDragonNumber()
        if not dragonNumber then
            warn("No dragon found for the player!")
            return
        end

        local playerDragonsFolder = game.Players.LocalPlayer.Character:WaitForChild("Dragons")
        local dragon = playerDragonsFolder:FindFirstChild(dragonNumber)

        if dragon then
            local deadStatus = dragon:FindFirstChild("Data"):FindFirstChild("Dead")
            if deadStatus then
                deadStatus.Value = false
            end
        end
    end

    Tabs.Main:AddButton({
        Title = "Revive To God Mode",
        Description = "Click When Your Dragon Is Dead",
        Callback = function()
            ImmortalDragon()
        end
    })

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
                if not healthValue or healthValue.Value == 0 then
                    if lastPosition and (lastPosition - targetPos).Magnitude < 1 then
                        lastPosition = nil
                        attackCount = 0
                    end
                    continue
                end

                humanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 0))
                lastPosition = targetPos
                attackCount += 1

                while healthValue and healthValue.Value > 0 do
                    local args = {
                        "Breath",
                        "Mobs",
                        target
                    }
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 0.5, 0))
                    local dragon = character:WaitForChild("Dragons"):FindFirstChild(dragonNumber)
                    if dragon then
                        local remote = dragon:FindFirstChild("Remotes"):FindFirstChild("PlaySoundRemote")
                        if remote then
                            remote:FireServer(unpack(args))
                        end
                    end
                    task.wait(0.3)
                    healthValue = mob:FindFirstChild("Health") or target:FindFirstChild("Health")
                end
                if healthValue and healthValue.Value == 0 then
                    lastPosition = nil
                    attackCount = 0
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
    Tabs.Fishing:AddButton({
        Title = "Teleport To Fishing Zone",
        Description = "Click To Teleport",
        Callback = function()
            for _, v in pairs(workspace.Interactions.Nodes.Fishing:GetDescendants()) do
                if v.Name == "Zone" then
                    local targetPosition
                    if v:IsA("Model") then
                        if v.WorldPivot then
                            targetPosition = v.WorldPivot.Position
                        else
                            targetPosition = v:FindFirstChildOfClass("WorldPivot").Position
                        end
                    elseif v:IsA("WorldPivot") then
                        targetPosition = v.Position
                    end
                    
                    if targetPosition then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 60, 0))
                    end
                    break
                end
            end
        end
    })

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
    local isFishingComplete = false
    local isMinigameComplete = false

    -------------- กดเริ่มตกปลา
    function StartFishing()
        if not isStartingFishing then
            isMinigame = false
            isFishingComplete = false
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

                            task.wait(3)
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
                                isFishingComplete = false

                                ProcessMinigame()
                            end
                        end
                    end
                end
            end
        end
    end
    ----------------------- มินิเกมส์

    local tolerance = 20
    local lastProcessed = 0

    function ProcessMinigame()
        while isMinigame do
            wait(0.1)

            if tick() - lastProcessed > 1 then 
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

                                if math.abs(spinRingRotation - spinReelLabelRotation) <= tolerance then
                                    print("Success")

                                    lastProcessed = tick()

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

            local ReelingFrame = game:GetService("Players").LocalPlayer.PlayerGui.FishingGui:FindFirstChild("ContainerFrame")
            and game:GetService("Players").LocalPlayer.PlayerGui.FishingGui.ContainerFrame:FindFirstChild("ReelingFrame")

            if ReelingFrame and not ReelingFrame.Visible then
                print("Minigame Finished!")
                isMinigame = false
                isStartingFishing = false
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
                        local SpinRingFrame = FishingGui:FindFirstChild("ContainerFrame")
                            and FishingGui.ContainerFrame:FindFirstChild("ReelingFrame")
                            and FishingGui.ContainerFrame.ReelingFrame:FindFirstChild("SpinRingFrame")
                        
                        if SpinRingFrame and not SpinRingFrame.Value then
                            print("Minigame Finished!")
                            isMinigame = false
                            isStartingFishing = false
                        else
                            ProcessMinigame()
                        end
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

    --------------------------------------------------------------------------------------------
    local Dropdown = Tabs.TeleportMap:AddDropdown("SelectMap", {
        Title = "SelectMap",
        Values = {"None", "First", "Glassland", "Jungle", "Volcano", "Tundra", "Ocean", "Desert", "Fantasy", "Wasteland", "Prehistoric", "Shinrin"},
        Multi = false,
        Default = 1,
    })

    local mapArgs = nil

    Dropdown:SetValue("None")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
        if Value == "None" then
            mapArgs = nil
        elseif Value == "First" then
            mapArgs = 3475397644
        elseif Value == "Glassland" then
            mapArgs = 3475419198
        elseif Value == "Jungle" then
            mapArgs = 3475422608
        elseif Value == "Volcano" then
            mapArgs = 3487210751
        elseif Value == "Tundra" then
            mapArgs = 3623549100
        elseif Value == "Ocean" then
            mapArgs = 3737848045
        elseif Value == "Desert" then
            mapArgs = 3752680052
        elseif Value == "Fantasy" then
            mapArgs = 4174118306
        elseif Value == "Wasteland" then
            mapArgs = 4728805070
        elseif Value == "Prehistoric" then
            mapArgs = 4869039553
        elseif Value == "Shinrin" then
            mapArgs = 125804922932357
        end
    end)

    Tabs.TeleportMap:AddButton({
        Title = "Teleport To Map",
        Description = "Click To Teleport Selected Map",
        Callback = function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(mapArgs)
        end
    })

    Tabs.TeleportMap:AddButton({
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
                Server = Servers.data[math.random(1, (#Servers.data / 3))]
                Next = Servers.nextPageCursor
            until Server

            if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
            end
        end
    })

    ---------------------------------------------------------------------------------------------------------
    local ClearFogToggle = Tabs.Settings:AddToggle("ClearFog", {Title = "Clear Fog", Default = false })
    ClearFogToggle:OnChanged(function()
        local fog = game:GetService("Lighting").Atmosphere
        if Options.ClearFog.Value then
            fog.Density = 0
        else
            fog.Density = 0.2
        end
    end)

    Options.ClearFog:SetValue(false)

    ---------------------------------------------------------------------------------------------------------

end

Window:SelectTab(1)
