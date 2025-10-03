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

    -- ฟังก์ชันการโจมตี
    local function attackTarget(billboardPart)
        local args = {
            "Breath",  -- ประเภทการโจมตี
            "Destructibles",  -- ชนิดของเป้าหมายการโจมตี
            billboardPart  -- จุดที่โจมตี (BillboardPart)
        }

        local playSoundRemote = game:GetService("Players").LocalPlayer.Character:WaitForChild("Dragons"):WaitForChild("12"):WaitForChild("Remotes"):WaitForChild("PlaySoundRemote")
        
        if playSoundRemote then
            playSoundRemote:FireServer(unpack(args))
            print("Attack sent to position: " .. tostring(billboardPart.Position))
        else
            print("PlaySoundRemote not found.")
        end
    end

    -- ฟังก์ชันการโจมตีตลอดเวลา
    local function continuousAttack()
        while true do
            -- ค้นหาต้นไม้ใน Resources
            for _, v in pairs(workspace.Interactions.Nodes.Resources:GetDescendants()) do
                if v.Name == "LargeResourceNode" then
                    local billboardPart = v:FindFirstChild("BillboardPart")
                    
                    if billboardPart then
                        -- เรียกใช้ฟังก์ชันโจมตี
                        attackTarget(billboardPart)
                        print("Attacking tree at position: " .. tostring(billboardPart.Position))
                    end
                end
            end
        end
    end

    -- ฟังก์ชันการวาร์ปไปที่ต้นไม้ทุก 10 วินาที
    local function AutoHarvest()
        local trees = {}
        
        -- เก็บข้อมูลต้นไม้ที่มีชื่อว่า LargeResourceNode
        for _, v in pairs(workspace.Interactions.Nodes.Resources:GetDescendants()) do
            if v.Name == "LargeResourceNode" then
                table.insert(trees, v)
            end
        end
        
        -- วาร์ปไปที่ต้นไม้ทีละต้นทุก 10 วินาที
        for _, tree in ipairs(trees) do
            local part = tree:FindFirstChildWhichIsA("BasePart")
            
            if part then
                local treePosition = part.Position
                -- วาร์ปไปที่ตำแหน่งของต้นไม้
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition)
                print("Teleported to tree at position: " .. tostring(treePosition))
            end
            wait(10)  -- รอ 10 วินาทีแล้วไปต้นถัดไป
        end
    end

    -- ส่วนที่เกี่ยวกับ Toggle ควบคุมการทำงาน
    local HarvestCollectToggle = Tabs.Main:AddToggle("HarvestToggle", {Title = "AUTO - Harvest", Default = false })
    local isCollectingHarvest = false

    -- การเปลี่ยนแปลงค่าของ Toggle
    HarvestCollectToggle:OnChanged(function()
        if Options.HarvestToggle.Value then
            isCollectingHarvest = true
            -- เริ่มการเก็บเกี่ยวและโจมตี
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

    -- เริ่มต้นค่า Toggle เป็น False
    Options.HarvestToggle:SetValue(false)


end
