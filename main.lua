local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dragon Adventure | Test ",
    SubTitle = ".by Vichian",
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
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(eggPosition)
                
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


    local function attackTree(billboardPart)
        local args = {
            "Breath",
            "Destructibles",
            billboardPart
        }

        local playSoundRemote = game:GetService("Players").LocalPlayer.Character:WaitForChild("Dragons"):WaitForChild("12"):WaitForChild("Remotes"):WaitForChild("PlaySoundRemote")
        
        if playSoundRemote then
            playSoundRemote:FireServer(unpack(args))
            print("Attack sent to tree at position: " .. tostring(billboardPart.Position))
        else
            print("PlaySoundRemote not found.")
        end
    end

    local function AutoHarvest()
        local trees = {}
        
        for _, v in pairs(workspace.Interactions.Nodes.Resources:GetDescendants()) do
            if v.Name == "LargeResourceNode" then
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
                    for _ = 1, 20 do
                        attackTree(billboardPart)
                        wait(1)
                    end
                else
                    print("BillboardPart not found in LargeResourceNode.")
                end
            end

            print("Waiting for 10 seconds before attacking the next tree.")
            wait(10)
        end
        print("All trees have been attacked.")
    end

    local HarvestCollectToggle = Tabs.Main:AddToggle("HarvestToggle", {Title = "AUTO - Harvest", Default = false })
    local isCollectingHarvest = false

    HarvestCollectToggle:OnChanged(function()
        if Options.HarvestToggle.Value then
            isCollectingHarvest = true
            while isCollectingHarvest do
                AutoHarvest()      -- เรียกฟังก์ชันการวาร์ป
                continuousAttack() -- เรียกฟังก์ชันการโจมตี
                wait(0.5)          -- รอ 0.5 วินาทีระหว่างการทำงาน
            end
        else
            isCollectingHarvest = false
        end
        print("Toggle changed:", Options.HarvestToggle.Value)
    end)

    Options.HarvestToggle:SetValue(false)


end
