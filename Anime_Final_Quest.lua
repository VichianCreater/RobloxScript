local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local HttpService = game:GetService("HttpService")
local firstTimeUsingDeath = false

local ALLOWED_GAME_ID = 7798947148
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
else
    firstTimeUsingDeath = true
end

local Window = Fluent:CreateWindow({
    Title = "Anime Final Quest | BETA",
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

-- https://lucide.dev/icons/play
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crown" }),
    AttackSetting = Window:AddTab({ Title = "Attack", Icon = "swords" }),
    AutoStart = Window:AddTab({ Title = "Room", Icon = "play" }),
    WeaponSpin = Window:AddTab({ Title = "Weapon Spin", Icon = "rotate-ccw" }),
    HSV = Window:AddTab({ Title = "Hop Server", Icon = "wifi" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Welcome to vichianHUB",
        Content = "\nThis is a beta test script.\nUse at your own risk!\n\nWhat game the VichianHUB is Support\n- Dragon Adventure\n- Immortal Cultivation\n- Anime Evolution\n- Anime Final Quest"
    })

    Tabs.Main:AddParagraph({
        Title = "AFK Tutorial",
        Content = [[

Englist.
1. Setting function of script
2. Go to setting tab
3. Type config name whatever you want [Ex. AutoFarm]
4. Click create config
5. Select config in config list
6. For sure click overwrite config
7. Click set as autoload
8. Take script to autoexec in whatever executor you want
9. Done

ไทย.
1. เซ็ทฟังชั่นให้เรียบร้อย
2. ไปหน้า setting
3. ตั่งชื่อตรง config name [ตัวอย่าง AutoFarm]
4. กด create config
5. เลือก config จาก config list
6. เพื่อให้ข้อมูลเซฟกด overwrite config
7. กด set as autoload
8. นำสคริปไปใส่ใน โฟเดอร์ autoexec ของตัวรันที่ใช้
9. เสร็จแล้ว
]]
    })

------------------------------------------------------------------------------------------------------------------------

   -- [[ ฟังก์ชันเช็คสีแดงอันตราย ]]
    local function IsDangerColor(part)
        if not part:IsA("BasePart") then return false end
        local dangerBrickColors = {"Really red", "Bright red", "Scarlet", "Crimson"}
        for _, colorName in pairs(dangerBrickColors) do
            if part.BrickColor.Name == colorName then return true end
        end
        local color = part.Color
        if color.R > 0.7 and color.G < 0.4 and color.B < 0.4 then return true end
        return false
    end

    -- [[ ฟังก์ชันหาขอบวงแดงที่ใกล้ที่สุด ]]
    local function getDangerBorder(bossPart)
        local visuals = workspace:FindFirstChild("Visuals")
        if not visuals then return nil end
        
        local nearestDanger = nil
        local maxRadius = 0
        
        for _, obj in pairs(visuals:GetChildren()) do
            if IsDangerColor(obj) then
                -- คำนวณรัศมีของวง (สมมติว่าเป็นวงกลม/ทรงกระบอก ใช้ Size.X หรือ Size.Z)
                local radius = math.max(obj.Size.X, obj.Size.Z) / 2
                if radius > maxRadius then
                    maxRadius = radius
                    nearestDanger = obj
                end
            end
        end
        return maxRadius
    end

    -- ประกาศตัวแปร Global
    local DistanceOffset = 8
    local IsFarm = false
    local AnchorRadius = 80

    -- 1. Slider ปรับระยะ
    local DistanceSlider = Tabs.AttackSetting:AddSlider("DistanceSlider", {
        Title = "Adjust Height Offset",
        Default = 8,
        Min = 0,
        Max = 20,
        Rounding = 1,
        Callback = function(Value)
            DistanceOffset = Value
        end
    })

    -- 2. ฟังก์ชันจัดการ Anchor
    local function ManageAoEAnchor()
        local playerChar = game.Players.LocalPlayer.Character
        if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then return end
        
        local npcs = workspace:FindFirstChild("NPCs")
        if npcs then
            for _, v in pairs(npcs:GetChildren()) do
                local rootPart = v:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.Anchored = false
                end
            end
        end
    end

    -- 3. ฟังก์ชันโจมตี
    local function attack()
        local args = {{{state = Enum.HumanoidStateType.Running, hitcount = 3}, "\f"}}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2", 5):WaitForChild("dataRemoteEvent", 5)
        if remote then
            remote:FireServer(unpack(args))
        end
    end

    -- 4. ฟังก์ชันหาเป้าหมาย (NPC > Boss)
    local function getTarget()
        local playerChar = game.Players.LocalPlayer.Character
        if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then return nil end

        local npcsFolder = workspace:FindFirstChild("NPCs")
        local bossFolder = workspace:FindFirstChild("Boss")
        
        local closestNPC = nil
        local shortestNPCDist = math.huge
        
        if npcsFolder then
            for _, v in pairs(npcsFolder:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                local rootPart = v:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart and humanoid.Health > 0 then
                    local dist = (playerChar.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if dist < shortestNPCDist then
                        shortestNPCDist = dist
                        closestNPC = v
                    end
                end
            end
        end

        if closestNPC then return closestNPC end

        if bossFolder then
            for _, v in pairs(bossFolder:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Humanoid.Health > 0 then return v end
                end
            end
        end
        return nil
    end

    -- 5. ฟังก์ชันหลัก (ระบบ Flow ตามขอบวง)
    local function startFarming()
        task.spawn(function()
            while IsFarm do
                ManageAoEAnchor()
                task.wait(0.5)
            end
        end)

        while IsFarm do
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local target = getTarget()
            
            if char and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local visuals = workspace:FindFirstChild("Visuals")
                
                -- [ลำดับการทำงาน]
                if Options.AutoHeal.Value and (humanoid.Health < humanoid.MaxHealth) and visuals and visuals:FindFirstChild("Heal") then
                    char.HumanoidRootPart.CFrame = visuals.Heal.CFrame * CFrame.new(0, 2, 0)
                
                elseif target and target:FindFirstChild("HumanoidRootPart") then
                    local rootPart = target.HumanoidRootPart
                    local targetHumanoid = target:FindFirstChildOfClass("Humanoid")
                    
                    if targetHumanoid and targetHumanoid.Health > 0 then
                        -- แก้ไขบรรทัดเจ้าปัญหา: เช็คการมีอยู่ของโฟลเดอร์ Boss ก่อนใช้ IsDescendantOf
                        local bossFolder = workspace:FindFirstChild("Boss")
                        local isBoss = (bossFolder and target:IsDescendantOf(bossFolder)) or (target.Name == "Boss")
                        
                        local dangerRadius = getDangerBorder(rootPart)
                        
                        if isBoss and dangerRadius and dangerRadius > 0 then
                            local safeDistance = dangerRadius + 3
                            char.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 5, safeDistance)
                            -- ไม่โจมตีตอนกำลังหลบ (เพื่อความปลอดภัย)
                        else
                            -- เข้าตีปกติ
                            char.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -DistanceOffset, 5)
                            task.spawn(attack)
                        end
                    end
                end
            end
            task.wait(0) -- เร็วที่สุดเพื่อความเนียนในการไหลตามขอบ
        end
    end

    -- 6. Toggle เปิด/ปิด
    local FarmToggle = Tabs.AttackSetting:AddToggle("FarmToggle", {Title = "Start Attack", Default = false })

    FarmToggle:OnChanged(function()
        IsFarm = Options.FarmToggle.Value
        if IsFarm then
            task.spawn(startFarming)
        end
    end)

----------------------------------------------------------------------------------------------------
    Tabs.AttackSetting:AddToggle("AutoHeal", {Title = "Auto Collects Heal", Default = false})
----------------------------------------------------------------------------------------------------
    local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

    -- ฟังก์ชันกลางสำหรับส่ง Remote สกิล
    local function fireSkill(keyCode)
        local args = {
            {
                keyCode,
                "\026"
            }
        }
        RemoteEvent:FireServer(unpack(args))
    end

    -- --- การสร้าง UI Toggle ทั้ง 5 อัน ---

    Tabs.AttackSetting:AddToggle("Skill1", {Title = "Auto Skill [1]", Default = false})
    Tabs.AttackSetting:AddToggle("Skill2", {Title = "Auto Skill [2]", Default = false})
    Tabs.AttackSetting:AddToggle("Skill3", {Title = "Auto Skill [3]", Default = false})
    Tabs.AttackSetting:AddToggle("SkillF", {Title = "Auto Skill [F]", Default = false})
    Tabs.AttackSetting:AddToggle("SkillX", {Title = "Auto Skill [X]", Default = false})

    task.spawn(function()
        while true do
            if IsFarm then
                local target = getTarget()
                local bossSkillCheck = game.workspace.Visuals:FindFirstChild("indicator")

                if target and target:FindFirstChild("HumanoidRootPart") and not bossSkillCheck then
                    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local targetPos = target.HumanoidRootPart.Position
                    local distanceY = targetPos.Y - playerPos.Y
                    local totalDist = (playerPos - targetPos).Magnitude

                    if distanceY >= (DistanceOffset - 2) and totalDist < (DistanceOffset + 10) then
                        if Options.Skill1.Value then fireSkill(Enum.KeyCode.One) end
                        if Options.Skill2.Value then fireSkill(Enum.KeyCode.Two) end
                        if Options.Skill3.Value then fireSkill(Enum.KeyCode.Three) end
                        if Options.SkillF.Value then fireSkill(Enum.KeyCode.F) end
                        if Options.SkillX.Value then fireSkill(Enum.KeyCode.X) end
                    end
                end
            end
            task.wait(0.2)
        end
    end)

----------------------------------------------------------------------------------------------------
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer.PlayerGui

    -- [ ตัวแปรสถานะและการทำงาน ] --
    local AutoStartEnabled = false
    local IsProcessing = false

    -- [ ตัวแปรเก็บค่าจาก Dropdown ] --
    local Config = {
        Mode = "Shadow Realm",
        Map = "Summon Gate",
        Infinit_Map = "Summon Gate",
        Count = "1",
        Difficulty = "DIFF: NORMAL"
    }

    -- [ ส่วนของ UI Dropdowns ] --

    -- 1. Mode Dropdown
    local ModeDropdown = Tabs.AutoStart:AddDropdown("ModeSelect", {
        Title = "Select Mode",
        Values = {"Shadow Realm", "Raid", "Infinit"},
        Default = 1,
    })

    -- 2. Map Dropdown
    local MapDropdown = Tabs.AutoStart:AddDropdown("MapSelect", {
        Title = "Select Map",
        Values = {"Summon Gate", "Summon Station - 1", "Summon Station - 2", "Statue's Cave"},
        Default = 1,
    })

    MapDropdown:OnChanged(function(Value)
        Config.Map = Value
        Config.Infinit_Map = Value
        print("Selected Map:", Value) -- ไว้เช็คใน F9 ว่าค่าเปลี่ยนจริงไหม
    end)

    -- จัดการค่าเมื่อมีการเปลี่ยนแปลง และสั่งซ่อน Map Selection
    ModeDropdown:OnChanged(function(Value)
        Config.Mode = Value
        
        -- ค้นหาและซ่อน UI "Select Map" ใน CoreGui
        local coreGui = game:GetService("CoreGui")
        for _, gui in pairs(coreGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, descendant in pairs(gui:GetDescendants()) do
                    if descendant:IsA("TextLabel") and descendant.Text == "Select Map" then
                        -- เข้าถึง Parent เพื่อปิดการมองเห็น
                        local dropdownFrame = descendant.Parent 
                        if dropdownFrame and dropdownFrame.Parent then
                            if Value == "Raid" then
                                dropdownFrame.Parent.Visible = false
                            elseif Value == "Infinit" then
                                dropdownFrame.Parent.Visible = true
                                MapDropdown:SetValues({"Summon Gate", "Summon Station - 1"})
                            else
                                dropdownFrame.Parent.Visible = true
                                MapDropdown:SetValues({"Summon Gate", "Summon Station - 1", "Summon Station - 2", "Statue's Cave"})
                            end
                        end
                    end
                end
            end
        end
    end)

    local CountDropdown = Tabs.AutoStart:AddDropdown("CountSelect", {
        Title = "Select Player Count",
        Values = {"1", "2", "3", "4"},
        Default = 1,
    })
    CountDropdown:OnChanged(function(Value) Config.Count = Value end)

    local DiffDropdown = Tabs.AutoStart:AddDropdown("DiffSelect", {
        Title = "Select Difficulty",
        Values = {"DIFF: NORMAL", "DIFF: HARD", "DIFF: NIGHTMARE"},
        Default = 1,
    })
    DiffDropdown:OnChanged(function(Value) Config.Difficulty = Value end)

    --- [ LOGIC การกด ] ---

    local function virtualClick(button)
        if button and button:IsA("GuiButton") then
            button.Selectable = true
            button.Active = true
            task.wait(0.01)
            
            GuiService.SelectedCoreObject = button
            
            if GuiService.SelectedCoreObject == button then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            else
                GuiService:AddSelectionParent("TempSelection", button.Parent)
                GuiService.SelectedCoreObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
            
            task.wait(0.1)
            GuiService.SelectedCoreObject = nil
        end
    end

    local function startProcess()
        if IsProcessing or not AutoStartEnabled then return end
        IsProcessing = true

        -- 1. วาร์ปไปประตู
        local teleportsFolder = workspace:FindFirstChild("Teleports")
        local targetPortal = nil
        if teleportsFolder then
            for _, portal in pairs(teleportsFolder:GetChildren()) do
                local info = portal:FindFirstChild("Info")
                if info and info:FindFirstChild("BillboardGui") and info.BillboardGui.Enabled == false then
                    targetPortal = portal
                    break
                end
            end
        end

        if targetPortal and LocalPlayer.Character then
            LocalPlayer.Character:PivotTo(targetPortal:GetPivot())
            
            local HUD = PlayerGui:FindFirstChild("HUD")
            local Frames = HUD and HUD:FindFirstChild("Frames")
            if not Frames then IsProcessing = false return end

            ---------------------------------------------------------
            -- STEP 1: Teleport Frame
            ---------------------------------------------------------
            local TeleportFrame = Frames:FindFirstChild("Teleport")
            if TeleportFrame then
                local t = 0
                while AutoStartEnabled and not TeleportFrame.Visible and t < 50 do task.wait(0.1); t = t + 1 end

                if TeleportFrame.Visible then
                    task.wait(0.5)
                    if Config.Mode == "Raid" or Config.Mode == "Infinit" then
                        local RaidBtnFrame = TeleportFrame:FindFirstChild("Frame") 
                        local RaidBtnFrame2 = RaidBtnFrame:FindFirstChild("Frame") 
                        local RaidBtnFrame3 = RaidBtnFrame2:FindFirstChild("TextButton")
                        if RaidBtnFrame3 then virtualClick(RaidBtnFrame3) end
                    else
                        local Worlds = TeleportFrame:FindFirstChild("WORLDS")
                        local ScrollingFrame = Worlds and Worlds:FindFirstChild("ScrollingFrame")
                        local DefaultBtn = ScrollingFrame and ScrollingFrame:FindFirstChild("Default") and ScrollingFrame.Default:FindFirstChild("TextButton")
                        if DefaultBtn then virtualClick(DefaultBtn) end
                    end
                    task.wait(0.5)
                end
            end

            ---------------------------------------------------------
            -- STEP 2: MapSelect Frame
            ---------------------------------------------------------
            local MapSelectFrame = Frames:FindFirstChild("MapSelect")
            if MapSelectFrame then
                local t = 0
                while AutoStartEnabled and not MapSelectFrame.Visible and t < 50 do task.wait(0.1); t = t + 1 end

                if MapSelectFrame.Visible then
                    if Config.Mode == "Raid" then
                        -- โหมด Raid กดด่านเลข 1 เพื่อไปต่อ
                        local RaidMapBtn = MapSelectFrame:FindFirstChild("Scroll") and MapSelectFrame.Scroll:FindFirstChild("Maps") and MapSelectFrame.Scroll.Maps:FindFirstChild("1") and MapSelectFrame.Scroll.Maps["1"]:FindFirstChild("TextButton")
                        if RaidMapBtn then virtualClick(RaidMapBtn) end
                    elseif Config.Mode == "Infinit" then
                        local RaidMapBtn = MapSelectFrame:FindFirstChild("Scroll") and MapSelectFrame.Scroll:FindFirstChild("Maps") and MapSelectFrame.Scroll.Maps:FindFirstChild("2") and MapSelectFrame.Scroll.Maps["2"]:FindFirstChild("TextButton")
                        if RaidMapBtn then 
                            virtualClick(RaidMapBtn) 
                            wait(0.5)
                            local ScrollMaps = MapSelectFrame:FindFirstChild("Scroll") and MapSelectFrame.Scroll:FindFirstChild("Maps")
                            if ScrollMaps then
                                for _, folder in pairs(ScrollMaps:GetChildren()) do
                                    local imgLabel = folder:FindFirstChild("ImageLabel")
                                    local textLabel2 = imgLabel and imgLabel:FindFirstChild("TextLabel2")
                                    if textLabel2 and textLabel2.Text == Config.Infinit_Map then
                                        local btn = folder:FindFirstChild("TextButton")
                                        if btn then virtualClick(btn) break end
                                    end
                                end
                            end
                        end
                    else
                        -- โหมดปกติ เลือกตามชื่อด่าน
                        local ScrollMaps = MapSelectFrame:FindFirstChild("Scroll") and MapSelectFrame.Scroll:FindFirstChild("Maps")
                        if ScrollMaps then
                            for _, folder in pairs(ScrollMaps:GetChildren()) do
                                local imgLabel = folder:FindFirstChild("ImageLabel")
                                local textLabel2 = imgLabel and imgLabel:FindFirstChild("TextLabel2")
                                if textLabel2 and textLabel2.Text == Config.Map then
                                    local btn = folder:FindFirstChild("TextButton")
                                    if btn then virtualClick(btn) break end
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end

            ---------------------------------------------------------
            -- STEP 3: หน้าตั้งค่าห้อง (แยกตามโหมด)
            ---------------------------------------------------------
            if Config.Mode == "Raid" then
                local RaidSelect = Frames:FindFirstChild("RaidSelect")
                if RaidSelect then
                    local t = 0
                    while AutoStartEnabled and not RaidSelect.Visible and t < 50 do task.wait(0.1); t = t + 1 end
                    
                    if RaidSelect.Visible then
                        -- กดเลือก Raid อันแรก
                        local RaidItemBtn = RaidSelect:FindFirstChild("Scroll") and RaidSelect.Scroll:FindFirstChild("Maps") and RaidSelect.Scroll.Maps:FindFirstChild("1") and RaidSelect.Scroll.Maps["1"]:FindFirstChild("TextButton")
                        if RaidItemBtn then virtualClick(RaidItemBtn) task.wait(0.3) end

                        local Info = RaidSelect:FindFirstChild("Info")
                        if Info then
                            -- เช็ค Count
                            local CountLabel = Info:FindFirstChild("Count") and Info.Count:FindFirstChild("TextLabel")
                            local CountBtn = Info:FindFirstChild("No") and Info.No:FindFirstChild("TextButton")
                            if CountLabel and CountBtn then
                                local r = 0
                                while AutoStartEnabled and CountLabel.Text ~= Config.Count and r < 10 do
                                    virtualClick(CountBtn)
                                    task.wait(0.2)
                                    r = r + 1
                                end
                            end
                            -- เช็ค Difficulty
                            local DiffLabel = Info:FindFirstChild("Difficulty") and Info.Difficulty:FindFirstChild("TextLabel")
                            local DiffBtn = Info:FindFirstChild("Difficulty") and Info.Difficulty:FindFirstChild("TextButton")
                            if DiffLabel and DiffBtn then
                                local r = 0
                                while AutoStartEnabled and DiffLabel.Text ~= Config.Difficulty and r < 15 do
                                    virtualClick(DiffBtn)
                                    task.wait(0.2)
                                    r = r + 1
                                end
                            end
                            -- กด Play
                            local PlayBtn = Info:FindFirstChild("Play") and Info.Play:FindFirstChild("TextButton")
                            if PlayBtn then virtualClick(PlayBtn) end
                        end
                    end
                end
            else
                -- โหมด Shadow Realm ปกติ
                local Info = MapSelectFrame:FindFirstChild("Info")
                if Info and MapSelectFrame.Visible then
                    local CountLabel = Info:FindFirstChild("Count") and Info.Count:FindFirstChild("TextLabel")
                    local CountBtn = Info:FindFirstChild("No") and Info.No:FindFirstChild("TextButton")
                    if CountLabel and CountBtn then
                        local r = 0
                        while AutoStartEnabled and CountLabel.Text ~= Config.Count and r < 10 do
                            virtualClick(CountBtn)
                            task.wait(0.2)
                            r = r + 1
                        end
                    end
                    local DiffLabel = Info:FindFirstChild("Difficulty") and Info.Difficulty:FindFirstChild("TextLabel")
                    local DiffBtn = Info:FindFirstChild("Difficulty") and Info.Difficulty:FindFirstChild("TextButton")
                    if DiffLabel and DiffBtn then
                        local r = 0
                        while AutoStartEnabled and DiffLabel.Text ~= Config.Difficulty and r < 15 do
                            virtualClick(DiffBtn)
                            task.wait(0.2)
                            r = r + 1
                        end
                    end
                    local PlayBtn = Info:FindFirstChild("Play") and Info.Play:FindFirstChild("TextButton")
                    if PlayBtn then virtualClick(PlayBtn) end
                end
            end
        end
        
        task.wait(5)
        IsProcessing = false
    end

    -- [ ส่วนของ Toggle ] --
    local StartToggle = Tabs.AutoStart:AddToggle("AutoStartToggle", {
        Title = "Auto Create Room",
        Default = false
    })

    StartToggle:OnChanged(function()
        AutoStartEnabled = StartToggle.Value
        if game:GetService("Lighting"):FindFirstChild("DepthOfField") then
            game:GetService("Lighting").DepthOfField.Enabled = false
        end
        if AutoStartEnabled then
            task.spawn(function()
                while AutoStartEnabled do
                    if not IsProcessing then startProcess() end
                    task.wait(2)
                end
            end)
        end
    end)

    task.spawn(function()
        while true do
            local StartGui = LocalPlayer.PlayerGui:FindFirstChild("Start")
            if StartGui and StartGui.Enabled then 
                local readyBtn = StartGui:FindFirstChild("Frame") and StartGui.Frame:FindFirstChild("Ready")
                if readyBtn and readyBtn.Visible then
                    virtualClick(readyBtn)
                    task.wait(1) 
                    break
                end
            end
            task.wait(1)
        end
    end)
-----------------------------------------------------------------------------------------------------

-- [ Rematch Toggle ] --
    local RefreshToggle = Tabs.AutoStart:AddToggle("AutoRefresh", {
        Title = "Auto Rejoin",
        Default = false
    })

    RefreshToggle:OnChanged(function()
        AutoStartEnabled = RefreshToggle.Value
        
        if AutoStartEnabled then
            task.spawn(function()
                while AutoStartEnabled do
                    local EndMatchGUI = PlayerGui:FindFirstChild("EndScreen")
                    if EndMatchGUI then
                        local screen = EndMatchGUI:FindFirstChild("Screen")
                        if screen then
                            local frame = screen:FindFirstChild("Frame")
                            if frame then
                                local button = frame:FindFirstChild("Button")
                                if button then
                                    local textbutton = button:FindFirstChild("TextButton")
                                    if textbutton then
                                        virtualClick(textbutton)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end)

------------------------------ Auto Reroll ---------------------------------------------------------
    -- ==========================================
    -- 1. ข้อมูลอาวุธและระดับ (Config)
    -- ==========================================
    local TierList = {
        [1] = 'Rare',
        [2] = 'Epic',
        [3] = 'Legendary',
        [4] = 'Mythic',
    }

    local WeaponData = {
        ["Rare"] = {"King Ripper"},
        ["Epic"] = {"Hawk Eye"},
        ["Legendary"] = {"One-Eyed Reaper", "Umbrella"},
        ["Mythic"] = {"Chainsaw", "Child Of Sun", "King Of Curses"}
    }

    -- ==========================================
    -- 2. สร้าง UI Components
    -- ==========================================

    -- ดรอปดาวน์เลือก Tier แบบ Multi (เลือกได้หลายระดับพร้อมกัน)
    local TierSelect = Tabs.WeaponSpin:AddDropdown("TierSelect", {
        Title = "1. Select Desired Tiers",
        Values = {"Rare", "Epic", "Legendary", "Mythic"},
        Default = {}, 
        Multi = true,
    })

    -- ดรอปดาวน์เลือกอาวุธ (จะรวมอาวุธจากทุก Tier ที่เลือกด้านบน)
    local WeaponFocus = Tabs.WeaponSpin:AddDropdown("WeaponFocus", {
        Title = "2. Select Specific Weapons",
        Values = {}, 
        Default = {},
        Multi = true,
    })

    -- === ระบบเชื่อมโยง Multi-Tier กับ Multi-Weapon ===
    TierSelect:OnChanged(function(SelectedTiers)
        local combinedWeapons = {}
        
        -- วนลูปเช็คว่า Tier ไหนถูกเลือกบ้าง (SelectedTiers เป็น Table)
        for tierName, isSelected in pairs(SelectedTiers) do
            if isSelected and WeaponData[tierName] then
                -- ดึงอาวุธใน Tier นั้นมาใส่ในรายการรวม
                for _, weapon in ipairs(WeaponData[tierName]) do
                    table.insert(combinedWeapons, weapon)
                end
            end
        end
        
        -- อัปเดตรายการอาวุธในหน้าเลือก
        WeaponFocus:SetValues(combinedWeapons)
        WeaponFocus:SetValue({}) -- รีเซ็ตค่าที่เลือกไว้เพื่อความปลอดภัย
    end)

    -- ตั้งค่า Slot และ Mode
    local WeaponSlot = Tabs.WeaponSpin:AddDropdown("WeaponSlot", {
        Title = "Select Weapon Slot",
        Values = {"Slot1", "Slot2"},
        Default = 1,
    })

    local WeaponSpinMode = Tabs.WeaponSpin:AddDropdown("WeaponSpinMode", {
        Title = "Select Spin Mode",
        Values = {"Normal Spin", "Lucky Spin"},
        Default = 1,
    })

    local WeaponSpinToggle = Tabs.WeaponSpin:AddToggle("WeaponSpinToggle", {
        Title = "Auto Spin Weapon",
        Default = false
    })

    -- ==========================================
    -- 3. ระบบการทำงาน (Main Logic)
    -- ==========================================
    local AutoSpinWeaponEnabled = false

    WeaponSpinToggle:OnChanged(function()
        AutoSpinWeaponEnabled = WeaponSpinToggle.Value
        
        if AutoSpinWeaponEnabled then
            task.spawn(function()
                while AutoSpinWeaponEnabled do
                    local Player = game:GetService("Players").LocalPlayer
                    local PlayerGui = Player:FindFirstChild("PlayerGui")
                    local SpinGui = PlayerGui and PlayerGui:FindFirstChild("Spin")

                    if SpinGui and SpinGui.Enabled then
                        
                        -- [1] ตรวจสอบอาวุธ (Auto Stop)
                        local infoLabel = SpinGui.Info:FindFirstChild("TextLabel")
                        if infoLabel then
                            local currentInGame = infoLabel.Text:lower()
                            local selectedTargets = WeaponFocus.Value
                            
                            for name, isSelected in pairs(selectedTargets) do
                                if isSelected and currentInGame == tostring(name):lower() then
                                    WeaponSpinToggle:SetValue(false)
                                    AutoSpinWeaponEnabled = false
                                    print("Found Target: " .. name)
                                    return 
                                end
                            end
                        end

                        -- [2] กด Warning YES
                        local Warning = SpinGui:FindFirstChild("Warning")
                        if Warning and Warning.Visible then
                            local Yes = Warning:FindFirstChild("YES") and Warning.YES:FindFirstChild("TextButton")
                            if Yes then virtualClick(Yes) task.wait(0.5) end
                        end

                        -- [3] เลือก Slot
                        local selectedSlot = WeaponSlot.Value
                        local slotObj = SpinGui.Slots:FindFirstChild(selectedSlot)
                        if slotObj and slotObj.SelectedFrame.Visible == false then
                            virtualClick(slotObj.TextButton)
                            task.wait(0.5)
                        end

                        -- [4] กด Spin
                        local mode = WeaponSpinMode.Value
                        local spinBtnContainer = (mode == "Lucky Spin") and SpinGui.SpinButtons.LuckySpin or SpinGui.SpinButtons.NormalSpin
                        
                        if spinBtnContainer then
                            local btn = spinBtnContainer:FindFirstChild("TextButton")
                            local txt = spinBtnContainer:FindFirstChild("SpinText")
                            -- เช็คให้แน่ใจว่าไม่ได้กำลังหมุนอยู่ (Text ต้องมีคำว่า SPIN)
                            if btn and txt and (txt.Text:upper():find("SPIN")) then
                                virtualClick(btn)
                            end
                        end
                    else
                        -- เปิดหน้าต่าง Spin
                        local HUD = PlayerGui and PlayerGui:FindFirstChild("HUD")
                        if HUD then
                            local btn = HUD.Left.Buttons1.Weapon:FindFirstChild("TextButton")
                            if btn then virtualClick(btn) end
                        end
                    end
                    
                    task.wait(1.2)
                end
            end)
        end
    end)

----------------------------------------------------------------------------------------------------

    -- ฟังก์ชันสำหรับจัดการ Property ของ Object ทั้งหมดใน Container
    local function SetMapProperties(container, canCollideValue, anchoredValue)
        if container then
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("BasePart") then -- ตรวจสอบว่าเป็น Part, MeshPart หรืออื่นๆ ที่มี property นี้
                    obj.CanCollide = canCollideValue
                    obj.Anchored = anchoredValue
                end
            end
        end
    end

    -- เพิ่มปุ่มใน UI ของคุณ
    Tabs.Main:AddButton({
        Title = "Modify Map Physicals",
        Description = "It Make The Map Visible For Xmas Boss.",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Action",
                Content = "This will change physical properties of the map. Do you want to proceed?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local actualMap = workspace:FindFirstChild("ActualMap") and workspace.ActualMap:FindFirstChild("213123321")
                            if actualMap then
                                SetMapProperties(actualMap, true, false)
                            else
                                warn("ActualMap ['213123321'] not found!")
                            end

                            local mainMap = workspace:FindFirstChild("Map")
                            if mainMap then
                                SetMapProperties(mainMap, false, false)
                            else
                                warn("workspace.Map not found!")
                            end

                            print("Map properties updated successfully!")
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

    -- task.spawn(function()
    --     while true do 
    --         task.wait(20)
    --         local bosscheck = LocalPlayer.PlayerGui:FindFirstChild("BossHealth")
    --         local BossName = bosscheck:FindFirstChild("MobHealth")
    --         local BossNameText = BossName:FindFirstChild("Tt")
    --         if BossNameText.Text == "CRACKER" then
    --             local actualMap = workspace:FindFirstChild("ActualMap") and workspace.ActualMap:FindFirstChild("213123321")
    --             if actualMap then
    --                 SetMapProperties(actualMap, true, false)
    --             else
    --                 warn("ActualMap ['213123321'] not found!")
    --             end

    --             local mainMap = workspace:FindFirstChild("Map")
    --             if mainMap then
    --                 SetMapProperties(mainMap, false, false)
    --             else
    --                 warn("workspace.Map not found!")
    --             end

    --             print("Map properties updated successfully!")
    --             break
    --         end
    --     end
    -- end)
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
                -- Fluent:Notify({
                --     Title = "No servers available in list",
                --     Content = "fetching new data...",
                --     Duration = 3
                -- })
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

-- Torrmorw

-- workspace.Visuals.Heal >> Auto Heal

-- workspace.Visuals.indicator >> Auto Dodging
