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
    Title = "DA | Auto Coin",
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
            end
        end
    end

    -- ฟังก์ชันเก็บเกี่ยวต้นไม้
    local predefinedPositions = {
        Vector3.new(-1430.736572265625, 246.74830627441406, -1600.833251953125),
        Vector3.new(-864.0951538085938, 504.478759765625, -2033.88330078125),
        Vector3.new(-1813.89111328125, 233.04527282714844, -2354.91455078125),
        Vector3.new(-981.064453125, 392.6428527832031, -868.3142700195312),
        Vector3.new(-1048.2591552734375, 300.7080383300781, -2508.5439453125),
        Vector3.new(1475.412109375, 92.3567886352539, 100.74723052978516),
        Vector3.new(2185.489501953125, 172.75579833984375, -331.2497253417969),
        Vector3.new(2439.17529296875, 556.029052734375, -1367.130859375),
        Vector3.new(1508.160888671875, 372.6679382324219, -1789.7198486328125),
        Vector3.new(1798.6187744140625, 97.26102447509766, -2671.435302734375)
    }

    local StartHavest = false 

    -- local function AutoHarvest()
    --     while StartHavest do
    --         for _, position in ipairs(predefinedPositions) do
    --             game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    --             wait(0.1)
    --             local regionSize = Vector3.new(10, 10, 10)
    --             local region = Region3.new(position - regionSize/2, position + regionSize/2)

    --             local partsInRegion = workspace:FindPartsInRegion3(region, nil, math.huge)
    --             local trees = {}

    --             for _, part in pairs(partsInRegion) do
    --                 if part.Parent and part.Parent.Name == "LargeFoodNode" then
    --                     local billboardPart = part.Parent:FindFirstChild("BillboardPart")
    --                     if billboardPart then
    --                         local Health = billboardPart:FindFirstChild("Health")
    --                         if Health and Health.Value > 0 then
    --                             table.insert(trees, part.Parent)
    --                         end
    --                     end
    --                 end
    --             end

    --             -- เมื่อเจอต้นไม้ให้ทำการเก็บเกี่ยว
    --             if #trees > 0 then
    --                 for _, tree in ipairs(trees) do
    --                     local part = tree:FindFirstChildWhichIsA("BasePart")
    --                     if part then
    --                         local treePosition = part.Position
    --                         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition)
    --                         wait(1)

    --                         local billboardPart = tree:FindFirstChild("BillboardPart")
    --                         if billboardPart then
    --                             while true do
    --                                 local Health = billboardPart:FindFirstChild("Health")
    --                                 if Health and Health.Value > 0 then
    --                                     attackTree(billboardPart)
    --                                     task.wait(0.3)
    --                                 else
    --                                     break
    --                                 end
    --                             end
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --         wait(0.1)
    --     end
    -- end

    local function mainProgress()
        while Options.HarvestToggle.Value do
            print("Main Progress Loop")
            local EdamameCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Edamame")
            local MistSudachiCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("MistSudachi")
            local KajiFruitCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("KajiFruit")

            if game.PlaceId == 3475397644 then
                if EdamameCount.Value >= 500 then
                    local args1 = {
                        {
                            ItemName = "Edamame",
                            Amount = EdamameCount.Value
                        },
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args1))
                    wait(1)
                end

                if MistSudachiCount.Value >= 500 then
                    local args2 = {
                        {
                            ItemName = "MistSudachi",
                            Amount = MistSudachiCount.Value
                        },
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args2))
                    wait(1)
                end

                if KajiFruitCount.Value >= 500 then
                    local args3 = {
                        {
                            ItemName = "KajiFruit",
                            Amount = KajiFruitCount.Value
                        },
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args3))
                    wait(1)
                end

                if EdamameCount.Value < 500 and MistSudachiCount.Value < 500 and KajiFruitCount.Value < 500 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(125804922932357)
                end
            end

            if game.PlaceId == 125804922932357 then
                local Players = game:GetService("Players")

                local playerList = Players:GetPlayers()
                local playerCount = #playerList

                print("มีผู้เล่นทั้งหมด " .. playerCount .. " คน")
                if playerCount <= 5 then
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

                for _, player in pairs(playerList) do
                    print(player.Name)
                    if player.Name == 'Setto2001' or player.Name == 'ZVCK' then
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
                end

                if EdamameCount.Value >= 500 and MistSudachiCount.Value >= 500 and KajiFruitCount.Value >= 500 then
                    print("Full")
                    StartHavest = false
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(3475397644)
                else
                    print("Not Full")
                    StartHavest = true
                    wait(1)
                    while StartHavest do
                        print("Havest Loop")
                        
                        for _, position in ipairs(predefinedPositions) do
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                            wait(0.1)
                            local regionSize = Vector3.new(10, 10, 10)
                            local region = Region3.new(position - regionSize/2, position + regionSize/2)

                            local partsInRegion = workspace:FindPartsInRegion3(region, nil, math.huge)
                            local trees = {}

                            for _, part in pairs(partsInRegion) do
                                if part.Parent and part.Parent.Name == "LargeFoodNode" then
                                    local billboardPart = part.Parent:FindFirstChild("BillboardPart")
                                    if billboardPart then
                                        local Health = billboardPart:FindFirstChild("Health")
                                        if Health and Health.Value > 0 then
                                            table.insert(trees, part.Parent)
                                        end
                                    end
                                end
                            end

                            if #trees > 0 then
                                for _, tree in ipairs(trees) do
                                    local part = tree:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        local treePosition = part.Position
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition + Vector3.new(0, -20, 0))
                                        wait(1)

                                        local billboardPart = tree:FindFirstChild("BillboardPart")
                                        if billboardPart then
                                            while true do
                                                local Health = billboardPart:FindFirstChild("Health")
                                                if Health and Health.Value > 0 then
                                                    attackTree(billboardPart)
                                                    task.wait(0.3)
                                                else
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        wait(0.05)
                        mainProgress()
                    end
                end
            end
            wait(0.05)
        end
    end


    -- ปุ่มให้ teleport ไปยัง server อื่น
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
                Server = Servers.data[math.random(1, (#Servers.data / 3))]
                Next = Servers.nextPageCursor
            until Server

            if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
            end
        end
    })

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

    -- ปุ่ม Toggle ให้เปิด/ปิด Auto Harvest
    local Havest = Tabs.Main:AddToggle("HarvestToggle", {Title = "Auto Mode", Default = true })

    Havest:OnChanged(function()
        if Options.HarvestToggle.Value then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            mainProgress() -- เริ่ม process ขายและตรวจสอบ
        else
            print("Harvesting stopped.")
            StartHavest = false
        end
    end)

    Options.HarvestToggle:SetValue(false)
    
end
