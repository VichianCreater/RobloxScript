local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dragon Adventure | Test Script 1.0.5",
    SubTitle = "By Vichian",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
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

    local function autoHarvest()
        while Options.HarvestToggle.Value do
            for _, v in pairs(workspace.Interactions.Nodes.Food:GetDescendants()) do
                if v.Name == "LargeFoodNode" then
                    local targetPosition = v.WorldPivot.Position
                    local BillboardPart = v:FindFirstChild("BillboardPart")
                    
                    if BillboardPart then
                        local Health = BillboardPart:FindFirstChild("Health")
                        if Health then
                            -- ตีไปเรื่อยๆ จนกว่าจะเลือดเหลือ 0
                            while Health.Value > 0 do
                                attackTree(BillboardPart)  -- เรียกฟังก์ชันที่ใช้ในการโจมตี
                                wait(1)  -- หน่วงเวลาเล็กน้อยเพื่อไม่ให้ตีเร็วเกินไป
                            end
                            
                            -- หลังจาก Health = 0 แล้ว ให้วาร์ปไปยังตำแหน่งใหม่
                            if Health.Value <= 0 then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 60, 0))
                                print("Tree destroyed, moving to next target!")
                                break  -- ออกจากลูปหลังจากที่วาร์ปไปต้นไม้ต้นใหม่
                            end
                        end
                    end
                end
            end
            wait(0.1)  -- หน่วงเวลาระหว่างการวนลูป
        end
    end



    local HarvestCollectToggle = Tabs.Main:AddToggle("HarvestToggle", {Title = "AUTO - Harvest", Default = false })
    local isCollectingHarvest = false

    HarvestCollectToggle:OnChanged(function()
        if Options.HarvestToggle.Value then
            isCollectingHarvest = true
            autoHarvest()
        else
            isCollectingHarvest = false
            print("Harvesting stopped.")
        end
        print("Toggle changed:", Options.HarvestToggle.Value)
    end)

    Options.HarvestToggle:SetValue(false)
end
