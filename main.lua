local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dragon Adventure | 1.8.0 [Debuger]",
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

    local function autoAttackMob()
        local mobFolder = workspace:FindFirstChild("MobFolder")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local dragonNumber = getDragonNumber()

        if not mobFolder then
            warn("❌ ไม่พบ MobFolder")
            return
        end
        if not dragonNumber then
            warn("❌ ไม่พบ dragonNumber")
            return
        end

        for _, mob in ipairs(mobFolder:GetChildren()) do
            local target = mob:FindFirstChild(mob.Name)
            print("🔍 เจอ mob:", mob.Name, "| target:", target and target.Name or "nil")

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

                if healthValue then
                    print("❤️ HP ของ", mob.Name, "=", healthValue.Value)
                    if healthValue.Value == 0 then
                        print("⚠️", mob.Name, "ตายแล้ว → ข้าม")
                        continue
                    end
                else
                    warn("❗ ไม่พบ Health ของ mob:", mob.Name)
                end

                if not firstStart then
                    print("🚀 วาร์ปครั้งแรกไปที่:", target.Position)
                    humanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 0))
                    firstStart = true
                else
                    print("🗡️ กำลังโจมตี:", mob.Name)
                    humanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 0))
                end

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
                        print("✅ โจมตีสำเร็จ:", target.Name)
                    else
                        warn("❌ ไม่พบ PlaySoundRemote")
                    end
                else
                    warn("❌ ไม่พบ dragon:", dragonNumber)
                end

                break -- ออกจาก loop ทันทีหลังตีตัวแรก
            else
                warn("❌ target ไม่ใช่ BasePart หรือไม่พบ target")
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
        end
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
