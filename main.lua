local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dragon Adventure | 1.8.6",
    SubTitle = "By Vichian",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

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
    local AttackMobToggle = Tabs.Main:AddToggle("AttactMob", {Title = "AUTO - AttactMob", Default = false })
    local isAutoAttackingMob = false
    local firstStart = false

    local currentTarget = nil
    local healthChangedConnection = nil

    local function setTarget(mob)
        -- ยกเลิกการฟังเดิม
        if healthChangedConnection then
            healthChangedConnection:Disconnect()
            healthChangedConnection = nil
        end

        currentTarget = mob
        if not mob then return end

        local healthValue = mob:FindFirstChild("Health")
        if not healthValue then
            for _, desc in ipairs(mob:GetDescendants()) do
                if desc.Name == "Health" and desc:IsA("NumberValue") then
                    healthValue = desc
                    break
                end
            end
        end

        if healthValue then
            healthChangedConnection = healthValue.Changed:Connect(function(newVal)
                if newVal == 0 then
                    -- ตัวนี้ตาย → หา target ใหม่เลย
                    currentTarget = nil
                end
            end)
        end
    end

    local function autoAttackMob()
        local mobFolder = workspace:FindFirstChild("MobFolder")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local dragonNumber = getDragonNumber()

        if not mobFolder or not dragonNumber then return end

        -- ถ้าไม่มี target หรือ target ตายแล้ว ให้หาใหม่
        if not currentTarget or (currentTarget and currentTarget:FindFirstChild("Health") and currentTarget.Health.Value == 0) then
            currentTarget = nil
            for _, mob in ipairs(mobFolder:GetChildren()) do
                local target = mob:FindFirstChild(mob.Name)
                if target and target:IsA("BasePart") then
                    local healthValue = mob:FindFirstChild("Health")
                    if not healthValue then
                        for _, desc in ipairs(mob:GetDescendants()) do
                            if desc.Name == "Health" and desc:IsA("NumberValue") then
                                healthValue = desc
                                break
                            end
                        end
                    end

                    if healthValue and healthValue.Value > 0 then
                        setTarget(mob)
                        break
                    end
                end
            end
        end

        if currentTarget then
            humanoidRootPart.CFrame = CFrame.new(currentTarget[mob.Name].Position + Vector3.new(0, 0, 0))

            local args = {
                "Breath",
                "Mobs",
                currentTarget[mob.Name]
            }

            local dragon = character:WaitForChild("Dragons"):FindFirstChild(dragonNumber)
            if dragon then
                local remote = dragon:FindFirstChild("Remotes"):FindFirstChild("PlaySoundRemote")
                if remote then
                    remote:FireServer(unpack(args))
                end
            end
        end
    end


    AttackMobToggle:OnChanged(function()
        if Options.AttactMob.Value then
            isAutoAttackingMob = true
            task.spawn(function()
                while isAutoAttackingMob do
                    autoAttackMob()
                    task.wait()
                end
            end)
        else
            isAutoAttackingMob = false
            firstStart = false
            -- print("Auto Attack Mob หยุดทำงาน")
        end
        -- print("Toggle changed:", Options.AttactMob.Value)
    end)

    Options.AttactMob:SetValue(false)

end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
