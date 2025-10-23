local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local OnlyFirst = false
-- Gui to Lua
-- Version: 3.2

-- Instances:

local ALLOWED_GAME_ID = 1235188606
if game.GameId ~= ALLOWED_GAME_ID then
    Fluent:Notify({
        Title = "Alert",
        Content = "The script not support this game",
        Duration = 8
    })
    return 
else
    Fluent:Notify({
        Title = "Alert",
        Content = "The script load in 5 sec",
        Duration = 8
    })
    wait(5)
    OnlyFirst = true
end

local AutoCoinMain = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local FEdamame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local UICorner_2 = Instance.new("UICorner")
local FKajiFruit = Instance.new("Frame")
local ImageLabel_2 = Instance.new("ImageLabel")
local UICorner_3 = Instance.new("UICorner")
local FMistSudachi = Instance.new("Frame")
local ImageLabel_3 = Instance.new("ImageLabel")
local UICorner_4 = Instance.new("UICorner")
local Edamame = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local KajiFruit = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local MistSudachi = Instance.new("TextLabel")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local CEdamame = Instance.new("TextLabel")
local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
local CKajiFruit = Instance.new("TextLabel")
local UITextSizeConstraint_5 = Instance.new("UITextSizeConstraint")
local CMistSudachi = Instance.new("TextLabel")
local UITextSizeConstraint_6 = Instance.new("UITextSizeConstraint")
local HideButton = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local UITextSizeConstraint_7 = Instance.new("UITextSizeConstraint")
local Top = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local Time = Instance.new("TextLabel")
local UICorner_7 = Instance.new("UICorner")
local UITextSizeConstraint_8 = Instance.new("UITextSizeConstraint")
local StopButton = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")
local UITextSizeConstraint_9 = Instance.new("UITextSizeConstraint")
local UserInfo = Instance.new("TextLabel")
local UITextSizeConstraint_10 = Instance.new("UITextSizeConstraint")
local HopServerButton = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local UITextSizeConstraint_11 = Instance.new("UITextSizeConstraint")
local StatusText = Instance.new("TextLabel")
local UITextSizeConstraint_12 = Instance.new("UITextSizeConstraint")
local Bottom = Instance.new("Frame")
local UICorner_10 = Instance.new("UICorner")
local money = Instance.new("TextLabel")
local UICorner_11 = Instance.new("UICorner")
local UITextSizeConstraint_13 = Instance.new("UITextSizeConstraint")
local CurrentCoin = Instance.new("TextLabel")
local UITextSizeConstraint_14 = Instance.new("UITextSizeConstraint")
local CloseButton = Instance.new("TextButton")
local UICorner_12 = Instance.new("UICorner")
local UITextSizeConstraint_15 = Instance.new("UITextSizeConstraint")

--Properties:

AutoCoinMain.Name = "AutoCoinMain"
AutoCoinMain.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AutoCoinMain.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = AutoCoinMain
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.500
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.499585748, 0, 0.447210789, 0)
Main.Size = UDim2.new(0.324233562, 0, 0.323232323, 0)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

FEdamame.Name = "FEdamame"
FEdamame.Parent = Main
FEdamame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FEdamame.BackgroundTransparency = 0.500
FEdamame.BorderColor3 = Color3.fromRGB(0, 0, 0)
FEdamame.BorderSizePixel = 0
FEdamame.Position = UDim2.new(0.0579999983, 0, 0.3046875, 0)
FEdamame.Size = UDim2.new(0.200000003, 0, 0.390625, 0)

ImageLabel.Parent = FEdamame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.150000006, 0, 0.150000006, 0)
ImageLabel.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
ImageLabel.Image = "rbxthumb://type=Asset&id=131694513217317&w=150&h=150"

UICorner_2.Parent = FEdamame

FKajiFruit.Name = "FKajiFruit"
FKajiFruit.Parent = Main
FKajiFruit.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FKajiFruit.BackgroundTransparency = 0.500
FKajiFruit.BorderColor3 = Color3.fromRGB(0, 0, 0)
FKajiFruit.BorderSizePixel = 0
FKajiFruit.Position = UDim2.new(0.400000006, 0, 0.3046875, 0)
FKajiFruit.Size = UDim2.new(0.200000003, 0, 0.390625, 0)

ImageLabel_2.Parent = FKajiFruit
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BackgroundTransparency = 1.000
ImageLabel_2.BorderSizePixel = 0
ImageLabel_2.Position = UDim2.new(0.150000006, 0, 0.150000006, 0)
ImageLabel_2.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
ImageLabel_2.Image = "rbxthumb://type=Asset&id=71995107858467&w=150&h=150"

UICorner_3.Parent = FKajiFruit

FMistSudachi.Name = "FMistSudachi"
FMistSudachi.Parent = Main
FMistSudachi.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FMistSudachi.BackgroundTransparency = 0.500
FMistSudachi.BorderColor3 = Color3.fromRGB(0, 0, 0)
FMistSudachi.BorderSizePixel = 0
FMistSudachi.Position = UDim2.new(0.741999984, 0, 0.3046875, 0)
FMistSudachi.Size = UDim2.new(0.200000003, 0, 0.390625, 0)

ImageLabel_3.Parent = FMistSudachi
ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_3.BackgroundTransparency = 1.000
ImageLabel_3.BorderSizePixel = 0
ImageLabel_3.Position = UDim2.new(0.150000006, 0, 0.150000006, 0)
ImageLabel_3.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
ImageLabel_3.Image = "rbxthumb://type=Asset&id=110184426558554&w=150&h=150"

UICorner_4.Parent = FMistSudachi

Edamame.Name = "Edamame"
Edamame.Parent = Main
Edamame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Edamame.BackgroundTransparency = 1.000
Edamame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Edamame.BorderSizePixel = 0
Edamame.Position = UDim2.new(0.0579999983, 0, 0.140625, 0)
Edamame.Size = UDim2.new(0.200000003, 0, 0.12109375, 0)
Edamame.Font = Enum.Font.Unknown
Edamame.Text = "Edamame"
Edamame.TextColor3 = Color3.fromRGB(255, 255, 255)
Edamame.TextScaled = true
Edamame.TextSize = 20.000
Edamame.TextStrokeTransparency = 0.400
Edamame.TextWrapped = true

UITextSizeConstraint.Parent = Edamame
UITextSizeConstraint.MaxTextSize = 20

KajiFruit.Name = "KajiFruit"
KajiFruit.Parent = Main
KajiFruit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KajiFruit.BackgroundTransparency = 1.000
KajiFruit.BorderColor3 = Color3.fromRGB(0, 0, 0)
KajiFruit.BorderSizePixel = 0
KajiFruit.Position = UDim2.new(0.400000006, 0, 0.140625, 0)
KajiFruit.Size = UDim2.new(0.200000003, 0, 0.12109375, 0)
KajiFruit.Font = Enum.Font.Unknown
KajiFruit.Text = "KajiFruit"
KajiFruit.TextColor3 = Color3.fromRGB(255, 255, 255)
KajiFruit.TextScaled = true
KajiFruit.TextSize = 20.000
KajiFruit.TextStrokeTransparency = 0.400
KajiFruit.TextWrapped = true

UITextSizeConstraint_2.Parent = KajiFruit
UITextSizeConstraint_2.MaxTextSize = 20

MistSudachi.Name = "MistSudachi"
MistSudachi.Parent = Main
MistSudachi.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MistSudachi.BackgroundTransparency = 1.000
MistSudachi.BorderColor3 = Color3.fromRGB(0, 0, 0)
MistSudachi.BorderSizePixel = 0
MistSudachi.Position = UDim2.new(0.712000012, 0, 0.140625, 0)
MistSudachi.Size = UDim2.new(0.25999999, 0, 0.12109375, 0)
MistSudachi.Font = Enum.Font.Unknown
MistSudachi.Text = "MistSudachi"
MistSudachi.TextColor3 = Color3.fromRGB(255, 255, 255)
MistSudachi.TextScaled = true
MistSudachi.TextSize = 20.000
MistSudachi.TextStrokeTransparency = 0.400
MistSudachi.TextWrapped = true

UITextSizeConstraint_3.Parent = MistSudachi
UITextSizeConstraint_3.MaxTextSize = 20

CEdamame.Name = "CEdamame"
CEdamame.Parent = Main
CEdamame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CEdamame.BackgroundTransparency = 1.000
CEdamame.BorderColor3 = Color3.fromRGB(0, 0, 0)
CEdamame.BorderSizePixel = 0
CEdamame.Position = UDim2.new(0.0579999983, 0, 0.73828125, 0)
CEdamame.Size = UDim2.new(0.200000003, 0, 0.1953125, 0)
CEdamame.Font = Enum.Font.SourceSans
CEdamame.Text = "0"
CEdamame.TextColor3 = Color3.fromRGB(255, 255, 255)
CEdamame.TextScaled = true
CEdamame.TextSize = 50.000
CEdamame.TextWrapped = true

UITextSizeConstraint_4.Parent = CEdamame
UITextSizeConstraint_4.MaxTextSize = 50

CKajiFruit.Name = "CKajiFruit"
CKajiFruit.Parent = Main
CKajiFruit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CKajiFruit.BackgroundTransparency = 1.000
CKajiFruit.BorderColor3 = Color3.fromRGB(0, 0, 0)
CKajiFruit.BorderSizePixel = 0
CKajiFruit.Position = UDim2.new(0.400000006, 0, 0.73828125, 0)
CKajiFruit.Size = UDim2.new(0.200000003, 0, 0.1953125, 0)
CKajiFruit.Font = Enum.Font.SourceSans
CKajiFruit.Text = "0"
CKajiFruit.TextColor3 = Color3.fromRGB(255, 255, 255)
CKajiFruit.TextScaled = true
CKajiFruit.TextSize = 50.000
CKajiFruit.TextWrapped = true

UITextSizeConstraint_5.Parent = CKajiFruit
UITextSizeConstraint_5.MaxTextSize = 50

CMistSudachi.Name = "CMistSudachi"
CMistSudachi.Parent = Main
CMistSudachi.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CMistSudachi.BackgroundTransparency = 1.000
CMistSudachi.BorderColor3 = Color3.fromRGB(0, 0, 0)
CMistSudachi.BorderSizePixel = 0
CMistSudachi.Position = UDim2.new(0.741999984, 0, 0.73828125, 0)
CMistSudachi.Size = UDim2.new(0.200000003, 0, 0.1953125, 0)
CMistSudachi.Font = Enum.Font.SourceSans
CMistSudachi.Text = "0"
CMistSudachi.TextColor3 = Color3.fromRGB(255, 255, 255)
CMistSudachi.TextScaled = true
CMistSudachi.TextSize = 50.000
CMistSudachi.TextWrapped = true

UITextSizeConstraint_6.Parent = CMistSudachi
UITextSizeConstraint_6.MaxTextSize = 50

HideButton.Name = "HideButton"
HideButton.Parent = AutoCoinMain
HideButton.AnchorPoint = Vector2.new(0.5, 0.5)
HideButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
HideButton.Position = UDim2.new(0.416242927, 0, 0.747569919, 0)
HideButton.Size = UDim2.new(0.157547921, 0, 0.0404040404, 0)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HideButton.TextScaled = true
HideButton.TextSize = 20.000
HideButton.TextWrapped = true

UICorner_5.CornerRadius = UDim.new(0, 5)
UICorner_5.Parent = HideButton

UITextSizeConstraint_7.Parent = HideButton
UITextSizeConstraint_7.MaxTextSize = 20

Top.Name = "Top"
Top.Parent = AutoCoinMain
Top.AnchorPoint = Vector2.new(0.5, 0.5)
Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Top.BackgroundTransparency = 0.500
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0.499585748, 0, 0.219709665, 0)
Top.Size = UDim2.new(0.324233562, 0, 0.112373739, 0)

UICorner_6.CornerRadius = UDim.new(0, 10)
UICorner_6.Parent = Top

Time.Name = "Time"
Time.Parent = Top
Time.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Time.BackgroundTransparency = 0.500
Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
Time.BorderSizePixel = 0
Time.Position = UDim2.new(0.0269014686, 0, 0.146067411, 0)
Time.Size = UDim2.new(0.321214616, 0, 0.707865179, 0)
Time.Font = Enum.Font.SourceSans
Time.Text = "00:00:00"
Time.TextColor3 = Color3.fromRGB(255, 255, 255)
Time.TextScaled = true
Time.TextSize = 40.000
Time.TextStrokeTransparency = 0.500
Time.TextWrapped = true

UICorner_7.Parent = Time

UITextSizeConstraint_8.Parent = Time
UITextSizeConstraint_8.MaxTextSize = 40

StopButton.Name = "StopButton"
StopButton.Parent = Top
StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0.643999994, 0, 0.449438035, 0)
StopButton.Size = UDim2.new(0.328000009, 0, 0.404494375, 0)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Text = "Pause"
StopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
StopButton.TextScaled = true
StopButton.TextSize = 14.000
StopButton.TextWrapped = true

UICorner_8.Parent = StopButton

UITextSizeConstraint_9.Parent = StopButton
UITextSizeConstraint_9.MaxTextSize = 14

UserInfo.Name = "UserInfo"
UserInfo.Parent = Top
UserInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UserInfo.BackgroundTransparency = 1.000
UserInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
UserInfo.BorderSizePixel = 0
UserInfo.Position = UDim2.new(0.369030505, 0, 0.146067411, 0)
UserInfo.Size = UDim2.new(0.257, 0, 0.303370446, 0)
UserInfo.Font = Enum.Font.SourceSansBold
UserInfo.Text = "User : "
UserInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
UserInfo.TextScaled = true
UserInfo.TextSize = 20.000
UserInfo.TextWrapped = true
UserInfo.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint_10.Parent = UserInfo
UITextSizeConstraint_10.MaxTextSize = 20

HopServerButton.Parent = Top
HopServerButton.BackgroundColor3 = Color3.fromRGB(0, 145, 255)
HopServerButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
HopServerButton.BorderSizePixel = 0
HopServerButton.Position = UDim2.new(0.369567841, 0, 0.438202083, 0)
HopServerButton.Size = UDim2.new(0.256013274, 0, 0.393258423, 0)
HopServerButton.Font = Enum.Font.SourceSansBold
HopServerButton.Text = "HOP Server"
HopServerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HopServerButton.TextScaled = true
HopServerButton.TextSize = 14.000
HopServerButton.TextWrapped = true

UICorner_9.Parent = HopServerButton

UITextSizeConstraint_11.Parent = HopServerButton
UITextSizeConstraint_11.MaxTextSize = 14

StatusText.Name = "StatusText"
StatusText.Parent = Top
StatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusText.BackgroundTransparency = 1.000
StatusText.BorderColor3 = Color3.fromRGB(0, 0, 0)
StatusText.BorderSizePixel = 0
StatusText.Position = UDim2.new(0.649819374, 0, 0.146067411, 0)
StatusText.Size = UDim2.new(0.260517031, 0, 0.303370446, 0)
StatusText.Font = Enum.Font.SourceSansBold
StatusText.Text = "Status : Start"
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextScaled = true
StatusText.TextSize = 20.000
StatusText.TextWrapped = true
StatusText.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint_12.Parent = StatusText
UITextSizeConstraint_12.MaxTextSize = 20

Bottom.Name = "Bottom"
Bottom.Parent = AutoCoinMain
Bottom.AnchorPoint = Vector2.new(0.5, 0.5)
Bottom.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bottom.BackgroundTransparency = 0.500
Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
Bottom.BorderSizePixel = 0
Bottom.Position = UDim2.new(0.499585748, 0, 0.667110801, 0)
Bottom.Size = UDim2.new(0.324233562, 0, 0.0997474715, 0)

UICorner_10.Parent = Bottom

money.Name = "money"
money.Parent = Bottom
money.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
money.BackgroundTransparency = 0.500
money.BorderColor3 = Color3.fromRGB(0, 0, 0)
money.BorderSizePixel = 0
money.Position = UDim2.new(0.0280000009, 0, 0.490368813, 0)
money.Size = UDim2.new(0.944000006, 0, 0.430379748, 0)
money.Font = Enum.Font.Roboto
money.Text = "0,000,000"
money.TextColor3 = Color3.fromRGB(255, 255, 255)
money.TextScaled = true
money.TextSize = 14.000
money.TextWrapped = true

UICorner_11.Parent = money

UITextSizeConstraint_13.Parent = money
UITextSizeConstraint_13.MaxTextSize = 34

CurrentCoin.Name = "CurrentCoin"
CurrentCoin.Parent = Bottom
CurrentCoin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CurrentCoin.BackgroundTransparency = 1.000
CurrentCoin.BorderColor3 = Color3.fromRGB(0, 0, 0)
CurrentCoin.BorderSizePixel = 0
CurrentCoin.Position = UDim2.new(0.300000012, 0, 0.0759493634, 0)
CurrentCoin.Size = UDim2.new(0.400000006, 0, 0.303797454, 0)
CurrentCoin.Font = Enum.Font.Unknown
CurrentCoin.Text = "Current Coin"
CurrentCoin.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentCoin.TextScaled = true
CurrentCoin.TextSize = 14.000
CurrentCoin.TextWrapped = true

UITextSizeConstraint_14.Parent = CurrentCoin
UITextSizeConstraint_14.MaxTextSize = 23

CloseButton.Name = "CloseButton"
CloseButton.Parent = AutoCoinMain
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.Position = UDim2.new(0.582928598, 0, 0.747569919, 0)
CloseButton.Size = UDim2.new(0.157547921, 0, 0.0404040404, 0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.TextScaled = true
CloseButton.TextSize = 20.000
CloseButton.TextWrapped = true

UICorner_12.CornerRadius = UDim.new(0, 5)
UICorner_12.Parent = CloseButton

UITextSizeConstraint_15.Parent = CloseButton
UITextSizeConstraint_15.MaxTextSize = 20

-------------------------------------------------------------------------------------------------------------------------------------------------

local AutoCoinHide = Instance.new("ScreenGui")
local ShowUiButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

AutoCoinHide.Name = "AutoCoinHide"
AutoCoinHide.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AutoCoinHide.Enabled = false
AutoCoinHide.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ShowUiButton.Name = "ShowUiButton"
ShowUiButton.Parent = AutoCoinHide
ShowUiButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ShowUiButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButton.BorderSizePixel = 0
ShowUiButton.Position = UDim2.new(0.012427506, 0, 0.912878811, 0)
ShowUiButton.Size = UDim2.new(0.1, 0, 0.05, 0)
ShowUiButton.Font = Enum.Font.SourceSansBold
ShowUiButton.Text = "Show Ui"
ShowUiButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButton.TextScaled = true
ShowUiButton.TextSize = 29.000
ShowUiButton.TextWrapped = true

UICorner.Parent = ShowUiButton

UITextSizeConstraint.Parent = ShowUiButton
UITextSizeConstraint.MaxTextSize = 29

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
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(billboardPart.Position + Vector3.new(0, 0.5, 0))
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

local isPause = false
local StartHavest = false 

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

local function mainProgress()
    while not isPause do
        local EdamameCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Edamame")
        local MistSudachiCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("MistSudachi")
        local KajiFruitCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("KajiFruit")

        if game.PlaceId == 3475397644 then
            if EdamameCount.Value >= 10000 then
                local args1 = {
                    {
                        ItemName = "Edamame",
                        Amount = EdamameCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args1))
                wait(1)
            end

            if MistSudachiCount.Value >= 10000 then
                local args2 = {
                    {
                        ItemName = "MistSudachi",
                        Amount = MistSudachiCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args2))
                wait(1)
            end

            if KajiFruitCount.Value >= 10000 then
                local args3 = {
                    {
                        ItemName = "KajiFruit",
                        Amount = KajiFruitCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args3))
                wait(1)
            end

            if EdamameCount.Value < 10000 and MistSudachiCount.Value < 10000 and KajiFruitCount.Value < 10000 then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(125804922932357)
            end
        end

        if game.PlaceId == 125804922932357 then
            local Players = game:GetService("Players")

            local playerList = Players:GetPlayers()
            local playerCount = #playerList
            local player = Players.LocalPlayer
            local success, result = pcall(player.GetFriendsOnline, player, 10)

            if success then
                for _, friend in pairs(result) do
                    for _, player in pairs(playerList) do
                        if player.Name == friend.UserName then
                            if OnlyFirst then
                                wait(10)
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
                                    
                                    if Servers and Servers.data and #Servers.data > 0 then
                                        Server = Servers.data[math.random(1, (#Servers.data / 3))]
                                        Next = Servers.nextPageCursor
                                    else
                                        print("ไม่มีข้อมูล server หรือเกิดข้อผิดพลาดในการดึงข้อมูล")
                                        break
                                    end
                                until Server
                                if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
                                    OnlyFirst = false
                                else
                                    print("ไม่มีข้อมูล playing หรือเกิดข้อผิดพลาดในการดึงข้อมูล")
                                end
                            end
                        end
                    end
                end
            end

            if EdamameCount.Value >= 10000 and MistSudachiCount.Value >= 10000 and KajiFruitCount.Value >= 10000 then
                StartHavest = false
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(3475397644)
            else
                StartHavest = true
                task.wait(0)
                while StartHavest do
                    for _, position in ipairs(predefinedPositions) do
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                        task.wait(0)
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
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition + Vector3.new(0, 0.5, 0))
                                    task.wait(0)
                                    local billboardPart = tree:FindFirstChild("BillboardPart")
                                    if billboardPart then
                                        while true do
                                            local Health = billboardPart:FindFirstChild("Health")
                                            if Health and Health.Value > 0 then
                                                attackTree(billboardPart)
                                                task.wait(0.3)
                                                attackTreeBite(billboardPart)
                                            else
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0)
                    mainProgress()
                end
            end
        end
        task.wait(0)
    end
end

StopButton.MouseButton1Click:Connect(function()
    if StopButton.Text == "Pause" then
        StopButton.Text = "Start"
        StopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        StatusText.Text = "Status : Pause"
        isPause = true
        StartHavest = false
    elseif StopButton.Text == "Start" then
        StopButton.Text = "Pause"
        StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        StatusText.Text = "Status : Start"
        isPause = false
        mainProgress()
    end
end)

HopServerButton.MouseButton1Click:Connect(function()
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
end)

CloseButton.MouseButton1Click:Connect(function()
    isPause = true
    StartHavest = false
	AutoCoinMain:Destroy()
end)

local isHind = false

HideButton.MouseButton1Click:Connect(function()
    AutoCoinMain.Enabled = false
    AutoCoinHide.Enabled = true
    isHind = true
end)

ShowUiButton.MouseButton1Click:Connect(function()
    AutoCoinMain.Enabled = true
    AutoCoinHide.Enabled = false
    isHind = false
end)

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

spawn(function()
    local i = 0
    while true do
        wait(1)
        if isPause == false then
            i += 1
            local h = math.floor(i / 3600)
            local m = math.floor((i % 3600) / 60)
            local s = i % 60
            Time.Text = string.format("%02d:%02d:%02d", h, m, s)

            UserInfo.Text = "User : "..game:GetService("Players").LocalPlayer.DisplayName
            -------------------------------------------------------------

            local EdamameCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Edamame")
            local MistSudachiCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("MistSudachi")
            local KajiFruitCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("KajiFruit")
            
            CEdamame.Text = EdamameCount.Value
            CMistSudachi.Text = MistSudachiCount.Value
            CKajiFruit.Text = KajiFruitCount.Value
            -------------------------------------------------------------

            local currency = game:GetService("Players").LocalPlayer:WaitForChild("Data"):WaitForChild("Currency"):FindFirstChild("Coins")
            if currency then
                money.Text = comma_value(currency.Value)
            else
                money.Text = 'ERROR'
            end
        end
    end
end)

mainProgress()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)
