local OnlyFirst = false

-------------------------------- Notify -------------------------------------------------
local TweenService = game:GetService("TweenService")

local Notify = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local NotificationTemplate = Instance.new("Frame")
local MainText = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local ProgressBar = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local UIListLayout_2 = Instance.new("UIListLayout")

--Properties:

Notify.Name = "Notify"
Notify.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Notify.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Container.Name = "Container"
Container.Parent = Notify
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.BackgroundTransparency = 1.000
Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0.5, 0, 0.330000013, 0)
Container.Size = UDim2.new(0.323943675, 0, 0.756313145, 0)

NotificationTemplate.Name = "NotificationTemplate"
NotificationTemplate.Parent = Container
NotificationTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationTemplate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NotificationTemplate.BackgroundTransparency = 0.500
NotificationTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTemplate.BorderSizePixel = 0
NotificationTemplate.Position = UDim2.new(0.0580520816, 0, 0.0144356955, 0)
NotificationTemplate.Size = UDim2.new(0.882352948, 0, 0.0651085153, 0)
NotificationTemplate.Visible = false

MainText.Name = "MainText"
MainText.Parent = NotificationTemplate
MainText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainText.BackgroundTransparency = 1.000
MainText.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainText.BorderSizePixel = 0
MainText.Size = UDim2.new(1, 0, 1, 0)
MainText.Font = Enum.Font.Michroma
MainText.Text = "Notification"
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextScaled = true
MainText.TextSize = 18.000
MainText.TextWrapped = true

UITextSizeConstraint.Parent = MainText
UITextSizeConstraint.MaxTextSize = 39

ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = NotificationTemplate
ProgressBar.AnchorPoint = Vector2.new(0.5, 0.5)
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
ProgressBar.BorderSizePixel = 0
ProgressBar.Position = UDim2.new(0, 0, 1, 0)
ProgressBar.Size = UDim2.new(1, 0, 0.100000001, 0)

UIListLayout.Parent = NotificationTemplate
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIListLayout_2.Parent = Container
UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

local function createNotification(message, type, time)
	local newNotification = NotificationTemplate:Clone()
	newNotification.Visible = true
	newNotification.Parent = Container
	newNotification.MainText.Text = message

	if type == 'error' then
		newNotification.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	elseif type == 'success' then
		newNotification.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		newNotification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	end

	local progressBar = newNotification:FindFirstChild("ProgressBar")
	progressBar.Size = UDim2.new(1, 0, 0.1, 0)

	local fadeInTweenBackground = TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 0.5
	})
	local fadeInTweenText = TweenService:Create(newNotification.MainText, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		TextTransparency = 0
	})

	fadeInTweenBackground:Play()
	fadeInTweenText:Play()
	
	if time == nil then
		time = 1
	end

	local progressTween = TweenService:Create(progressBar, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0.1, 0)
	})
	progressTween:Play()

	wait(time)

	local fadeOutTweenBackground = TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 1
	})
	local fadeOutTweenText = TweenService:Create(newNotification.MainText, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		TextTransparency = 1
	})
	local fadeOutTweenProgressBar = TweenService:Create(progressBar, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0.1, 0)
	})

	fadeOutTweenBackground:Play()
	fadeOutTweenText:Play()
	fadeOutTweenProgressBar:Play()

	fadeOutTweenBackground.Completed:Connect(function()
		newNotification:Destroy()
	end)
end

-------------------------------------------------------------------------------------------
-- Gui to Lua
-- Version: 3.2

-- Instances:

local ALLOWED_GAME_ID = 1235188606
if game.GameId ~= ALLOWED_GAME_ID then
    createNotification("The script not support this game", "error", 5)
    return 
else
    createNotification("Script Loading in 10 sec", "success", 10)
    OnlyFirst = true
end

-- Gui to Lua
-- Version: 3.2

-- Instances:

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
local HideButtonShadown = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local UITextSizeConstraint_7 = Instance.new("UITextSizeConstraint")
local UIGradient = Instance.new("UIGradient")
local TextLabel = Instance.new("TextLabel")
local DropShadowHolder = Instance.new("Frame")
local DropShadow = Instance.new("ImageLabel")
local Top = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local Time = Instance.new("TextLabel")
local UICorner_7 = Instance.new("UICorner")
local UITextSizeConstraint_8 = Instance.new("UITextSizeConstraint")
local StopButtonShadow = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")
local UITextSizeConstraint_9 = Instance.new("UITextSizeConstraint")
local TextLabel_2 = Instance.new("TextLabel")
local DropShadowHolder_2 = Instance.new("Frame")
local DropShadow_2 = Instance.new("ImageLabel")
local UserInfo = Instance.new("TextLabel")
local UITextSizeConstraint_10 = Instance.new("UITextSizeConstraint")
local HopServerButtonShadow = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local UITextSizeConstraint_11 = Instance.new("UITextSizeConstraint")
local DropShadowHolder_3 = Instance.new("Frame")
local DropShadow_3 = Instance.new("ImageLabel")
local StatusText = Instance.new("TextLabel")
local UITextSizeConstraint_12 = Instance.new("UITextSizeConstraint")
local StopButton = Instance.new("TextButton")
local UICorner_10 = Instance.new("UICorner")
local UITextSizeConstraint_13 = Instance.new("UITextSizeConstraint")
local GreenGradient = Instance.new("UIGradient")
local RedGradient = Instance.new("UIGradient")
local TextLabel_3 = Instance.new("TextLabel")
local HopServerButton = Instance.new("TextButton")
local UICorner_11 = Instance.new("UICorner")
local UITextSizeConstraint_14 = Instance.new("UITextSizeConstraint")
local UIGradient_2 = Instance.new("UIGradient")
local TextLabel_4 = Instance.new("TextLabel")
local UIGradient_3 = Instance.new("UIGradient")
local BGLogoShadow = Instance.new("ImageLabel")
local DropShadowHolder_4 = Instance.new("Frame")
local DropShadow_4 = Instance.new("ImageLabel")
local BGLogo = Instance.new("ImageLabel")
local Bottom = Instance.new("Frame")
local UICorner_12 = Instance.new("UICorner")
local UIGradient_4 = Instance.new("UIGradient")
local money = Instance.new("TextLabel")
local UICorner_13 = Instance.new("UICorner")
local UITextSizeConstraint_15 = Instance.new("UITextSizeConstraint")
local CurrentCoin = Instance.new("TextLabel")
local UITextSizeConstraint_16 = Instance.new("UITextSizeConstraint")
local CloseButtonShadow = Instance.new("TextButton")
local UICorner_14 = Instance.new("UICorner")
local UITextSizeConstraint_17 = Instance.new("UITextSizeConstraint")
local DropShadowHolder_5 = Instance.new("Frame")
local DropShadow_5 = Instance.new("ImageLabel")
local CloseButton = Instance.new("TextButton")
local UICorner_15 = Instance.new("UICorner")
local UITextSizeConstraint_18 = Instance.new("UITextSizeConstraint")
local UIGradient_5 = Instance.new("UIGradient")
local TextLabel_5 = Instance.new("TextLabel")
local HideButton = Instance.new("TextButton")
local UICorner_16 = Instance.new("UICorner")
local UITextSizeConstraint_19 = Instance.new("UITextSizeConstraint")
local UIGradient_6 = Instance.new("UIGradient")
local TextLabel_6 = Instance.new("TextLabel")

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
Main.Position = UDim2.new(0.499585688, 0, 0.382773161, 0)
Main.Size = UDim2.new(0.262119472, 0, 0.303516388, 0)

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

HideButtonShadown.Name = "HideButtonShadown"
HideButtonShadown.Parent = AutoCoinMain
HideButtonShadown.AnchorPoint = Vector2.new(0.5, 0.5)
HideButtonShadown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HideButtonShadown.BorderColor3 = Color3.fromRGB(0, 0, 0)
HideButtonShadown.Position = UDim2.new(0.432209045, 0, 0.664811552, 0)
HideButtonShadown.Size = UDim2.new(0.12736614, 0, 0.0379395299, 0)
HideButtonShadown.Font = Enum.Font.SourceSansBold
HideButtonShadown.Text = ""
HideButtonShadown.TextColor3 = Color3.fromRGB(0, 0, 0)
HideButtonShadown.TextScaled = true
HideButtonShadown.TextSize = 20.000
HideButtonShadown.TextWrapped = true

UICorner_5.CornerRadius = UDim.new(0, 5)
UICorner_5.Parent = HideButtonShadown

UITextSizeConstraint_7.Parent = HideButtonShadown
UITextSizeConstraint_7.MaxTextSize = 20

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 199, 2)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(62, 203, 33)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(156, 255, 129)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(61, 195, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(42, 193, 0))}
UIGradient.Rotation = 75
UIGradient.Parent = HideButtonShadown

TextLabel.Parent = HideButtonShadown
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0, 211, 0, 31)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = ""
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextStrokeTransparency = 0.500
TextLabel.TextWrapped = true

DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = HideButtonShadown
DropShadowHolder.BackgroundTransparency = 1.000
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0

DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DropShadow.BackgroundTransparency = 1.000
DropShadow.BorderColor3 = Color3.fromRGB(255, 255, 255)
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 35, 1, 35)
DropShadow.ZIndex = -1
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(62, 186, 0)
DropShadow.ImageTransparency = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

Top.Name = "Top"
Top.Parent = AutoCoinMain
Top.AnchorPoint = Vector2.new(0.5, 0.5)
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BackgroundTransparency = 0.500
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0.499585778, 0, 0.410551697, 0)
Top.Size = UDim2.new(0.283219397, 0, 0.588325441, 0)
Top.ZIndex = 0

UICorner_6.CornerRadius = UDim.new(0, 10)
UICorner_6.Parent = Top

Time.Name = "Time"
Time.Parent = Top
Time.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Time.BackgroundTransparency = 0.500
Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
Time.BorderSizePixel = 0
Time.Position = UDim2.new(0.0372501761, 0, 0.0444073826, 0)
Time.Size = UDim2.new(0.314356923, 0, 0.124336705, 0)
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

StopButtonShadow.Name = "StopButtonShadow"
StopButtonShadow.Parent = Top
StopButtonShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StopButtonShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopButtonShadow.BorderSizePixel = 0
StopButtonShadow.Position = UDim2.new(0.639045715, 0, 0.0936281383, 0)
StopButtonShadow.Size = UDim2.new(0.320997566, 0, 0.0710495338, 0)
StopButtonShadow.Font = Enum.Font.SourceSansBold
StopButtonShadow.Text = ""
StopButtonShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
StopButtonShadow.TextScaled = true
StopButtonShadow.TextSize = 14.000
StopButtonShadow.TextWrapped = true

UICorner_8.Parent = StopButtonShadow

UITextSizeConstraint_9.Parent = StopButtonShadow
UITextSizeConstraint_9.MaxTextSize = 14

TextLabel_2.Parent = StopButtonShadow
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(-1.2839281e-06, 0, 0, 0)
TextLabel_2.Size = UDim2.new(0, 142, 0, 35)
TextLabel_2.Font = Enum.Font.SourceSansBold
TextLabel_2.Text = ""
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 20.000
TextLabel_2.TextStrokeTransparency = 0.500
TextLabel_2.TextWrapped = true

DropShadowHolder_2.Name = "DropShadowHolder"
DropShadowHolder_2.Parent = StopButtonShadow
DropShadowHolder_2.BackgroundTransparency = 1.000
DropShadowHolder_2.BorderSizePixel = 0
DropShadowHolder_2.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder_2.ZIndex = 0

DropShadow_2.Name = "DropShadow"
DropShadow_2.Parent = DropShadowHolder_2
DropShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_2.BackgroundTransparency = 1.000
DropShadow_2.BorderSizePixel = 0
DropShadow_2.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_2.Size = UDim2.new(1, 35, 1, 35)
DropShadow_2.ZIndex = 0
DropShadow_2.Image = "rbxassetid://6014261993"
DropShadow_2.ImageColor3 = Color3.fromRGB(255, 38, 0)
DropShadow_2.ImageTransparency = 0.500
DropShadow_2.ScaleType = Enum.ScaleType.Slice
DropShadow_2.SliceCenter = Rect.new(49, 49, 450, 450)

UserInfo.Name = "UserInfo"
UserInfo.Parent = Top
UserInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UserInfo.BackgroundTransparency = 1.000
UserInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
UserInfo.BorderSizePixel = 0
UserInfo.Position = UDim2.new(0.372075111, 0, 0.0444073826, 0)
UserInfo.Size = UDim2.new(0.251073509, 0, 0.0532870926, 0)
UserInfo.Font = Enum.Font.SourceSansBold
UserInfo.Text = "User : "
UserInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
UserInfo.TextScaled = true
UserInfo.TextSize = 20.000
UserInfo.TextWrapped = true
UserInfo.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint_10.Parent = UserInfo
UITextSizeConstraint_10.MaxTextSize = 20

HopServerButtonShadow.Name = "HopServerButtonShadow"
HopServerButtonShadow.Parent = Top
HopServerButtonShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HopServerButtonShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
HopServerButtonShadow.BorderSizePixel = 0
HopServerButtonShadow.Position = UDim2.new(0.372600913, 0, 0.0957209319, 0)
HopServerButtonShadow.Size = UDim2.new(0.250547618, 0, 0.0690759271, 0)
HopServerButtonShadow.Font = Enum.Font.SourceSansBold
HopServerButtonShadow.Text = ""
HopServerButtonShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
HopServerButtonShadow.TextScaled = true
HopServerButtonShadow.TextSize = 14.000
HopServerButtonShadow.TextWrapped = true

UICorner_9.Parent = HopServerButtonShadow

UITextSizeConstraint_11.Parent = HopServerButtonShadow
UITextSizeConstraint_11.MaxTextSize = 14

DropShadowHolder_3.Name = "DropShadowHolder"
DropShadowHolder_3.Parent = HopServerButtonShadow
DropShadowHolder_3.BackgroundTransparency = 1.000
DropShadowHolder_3.BorderSizePixel = 0
DropShadowHolder_3.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder_3.ZIndex = 0

DropShadow_3.Name = "DropShadow"
DropShadow_3.Parent = DropShadowHolder_3
DropShadow_3.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_3.BackgroundTransparency = 1.000
DropShadow_3.BorderSizePixel = 0
DropShadow_3.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_3.Size = UDim2.new(1, 35, 1, 35)
DropShadow_3.ZIndex = 0
DropShadow_3.Image = "rbxassetid://6014261993"
DropShadow_3.ImageColor3 = Color3.fromRGB(5, 126, 255)
DropShadow_3.ImageTransparency = 0.500
DropShadow_3.ScaleType = Enum.ScaleType.Slice
DropShadow_3.SliceCenter = Rect.new(49, 49, 450, 450)

StatusText.Name = "StatusText"
StatusText.Parent = Top
StatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusText.BackgroundTransparency = 1.000
StatusText.BorderColor3 = Color3.fromRGB(0, 0, 0)
StatusText.BorderSizePixel = 0
StatusText.Position = UDim2.new(0.646869123, 0, 0.0444073826, 0)
StatusText.Size = UDim2.new(0.254955202, 0, 0.0532870926, 0)
StatusText.Font = Enum.Font.SourceSansBold
StatusText.Text = "Status : Start"
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextScaled = true
StatusText.TextSize = 20.000
StatusText.TextWrapped = true
StatusText.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint_12.Parent = StatusText
UITextSizeConstraint_12.MaxTextSize = 20

StopButton.Name = "StopButton"
StopButton.Parent = Top
StopButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0.639045715, 0, 0.0936281383, 0)
StopButton.Size = UDim2.new(0.320997566, 0, 0.0710495338, 0)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Text = ""
StopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
StopButton.TextScaled = true
StopButton.TextSize = 14.000
StopButton.TextWrapped = true

UICorner_10.Parent = StopButton

UITextSizeConstraint_13.Parent = StopButton
UITextSizeConstraint_13.MaxTextSize = 14

GreenGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 199, 2)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(62, 203, 33)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(156, 255, 129)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(61, 195, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(42, 193, 0))}
GreenGradient.Rotation = 75
GreenGradient.Name = "GreenGradient"
GreenGradient.Parent = StopButton
GreenGradient.Enabled = false

RedGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 43, 47)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 125, 127)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(255, 38, 42)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
RedGradient.Rotation = 75
RedGradient.Name = "RedGradient"
RedGradient.Parent = StopButton
RedGradient.Enabled = true

TextLabel_3.Parent = StopButton
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(-8.09464609e-07, 0, 0, 0)
TextLabel_3.Size = UDim2.new(1.00000083, 0, 1.0015831, 0)
TextLabel_3.Font = Enum.Font.SourceSansBold
TextLabel_3.Text = "Pause"
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextSize = 20.000
TextLabel_3.TextStrokeTransparency = 0.500
TextLabel_3.TextWrapped = true

HopServerButton.Name = "HopServerButton"
HopServerButton.Parent = Top
HopServerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HopServerButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
HopServerButton.BorderSizePixel = 0
HopServerButton.Position = UDim2.new(0.372600913, 0, 0.0957209319, 0)
HopServerButton.Size = UDim2.new(0.250547618, 0, 0.0690759271, 0)
HopServerButton.Font = Enum.Font.SourceSansBold
HopServerButton.Text = ""
HopServerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HopServerButton.TextScaled = true
HopServerButton.TextSize = 14.000
HopServerButton.TextWrapped = true

UICorner_11.Parent = HopServerButton

UITextSizeConstraint_14.Parent = HopServerButton
UITextSizeConstraint_14.MaxTextSize = 14

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 102, 255)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(79, 135, 255)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(174, 200, 255)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(71, 142, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 145, 255))}
UIGradient_2.Rotation = 75
UIGradient_2.Parent = HopServerButton

TextLabel_4.Parent = HopServerButton
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Position = UDim2.new(-1.03707293e-06, 0, 0, 0)
TextLabel_4.Size = UDim2.new(0.993997097, 0, 1.03019977, 0)
TextLabel_4.Font = Enum.Font.SourceSansBold
TextLabel_4.Text = "Hop Server"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextSize = 20.000
TextLabel_4.TextStrokeTransparency = 0.500
TextLabel_4.TextWrapped = true

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(0, 0, 50)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
UIGradient_3.Rotation = -60
UIGradient_3.Parent = Top

BGLogoShadow.Name = "BGLogoShadow"
BGLogoShadow.Parent = Top
BGLogoShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BGLogoShadow.BackgroundTransparency = 1.000
BGLogoShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
BGLogoShadow.BorderSizePixel = 0
BGLogoShadow.Size = UDim2.new(0.998302996, 0, 0.998301387, 0)
BGLogoShadow.ZIndex = 0
BGLogoShadow.Image = "rbxassetid://74835950536249"
BGLogoShadow.ImageTransparency = 1.000

DropShadowHolder_4.Name = "DropShadowHolder"
DropShadowHolder_4.Parent = BGLogoShadow
DropShadowHolder_4.BackgroundTransparency = 1.000
DropShadowHolder_4.BorderSizePixel = 0
DropShadowHolder_4.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder_4.ZIndex = 0

DropShadow_4.Name = "DropShadow"
DropShadow_4.Parent = DropShadowHolder_4
DropShadow_4.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_4.BackgroundTransparency = 1.000
DropShadow_4.BorderSizePixel = 0
DropShadow_4.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_4.Size = UDim2.new(1, 47, 1, 47)
DropShadow_4.ZIndex = 0
DropShadow_4.Image = "rbxassetid://6014261993"
DropShadow_4.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow_4.ImageTransparency = 0.500
DropShadow_4.ScaleType = Enum.ScaleType.Slice
DropShadow_4.SliceCenter = Rect.new(49, 49, 450, 450)

BGLogo.Name = "BGLogo"
BGLogo.Parent = Top
BGLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BGLogo.BackgroundTransparency = 1.000
BGLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
BGLogo.BorderSizePixel = 0
BGLogo.Size = UDim2.new(0.995603323, 0, 0.998301387, 0)
BGLogo.ZIndex = 0
BGLogo.Image = "rbxassetid://74835950536249"
BGLogo.ImageTransparency = 0.800

Bottom.Name = "Bottom"
Bottom.Parent = AutoCoinMain
Bottom.AnchorPoint = Vector2.new(0.5, 0.5)
Bottom.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bottom.BackgroundTransparency = 0.500
Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
Bottom.BorderSizePixel = 0
Bottom.Position = UDim2.new(0.499585688, 0, 0.589260221, 0)
Bottom.Size = UDim2.new(0.262119472, 0, 0.0936632305, 0)

UICorner_12.Parent = Bottom

UIGradient_4.Parent = Bottom

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

UICorner_13.Parent = money

UITextSizeConstraint_15.Parent = money
UITextSizeConstraint_15.MaxTextSize = 34

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

UITextSizeConstraint_16.Parent = CurrentCoin
UITextSizeConstraint_16.MaxTextSize = 23

CloseButtonShadow.Name = "CloseButtonShadow"
CloseButtonShadow.Parent = AutoCoinMain
CloseButtonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButtonShadow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButtonShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButtonShadow.Position = UDim2.new(0.566962421, 0, 0.664811552, 0)
CloseButtonShadow.Size = UDim2.new(0.127366081, 0, 0.0379395299, 0)
CloseButtonShadow.Font = Enum.Font.SourceSansBold
CloseButtonShadow.Text = "Close"
CloseButtonShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseButtonShadow.TextScaled = true
CloseButtonShadow.TextSize = 20.000
CloseButtonShadow.TextWrapped = true

UICorner_14.CornerRadius = UDim.new(0, 5)
UICorner_14.Parent = CloseButtonShadow

UITextSizeConstraint_17.Parent = CloseButtonShadow
UITextSizeConstraint_17.MaxTextSize = 20

DropShadowHolder_5.Name = "DropShadowHolder"
DropShadowHolder_5.Parent = CloseButtonShadow
DropShadowHolder_5.BackgroundTransparency = 1.000
DropShadowHolder_5.BorderSizePixel = 0
DropShadowHolder_5.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder_5.ZIndex = 0

DropShadow_5.Name = "DropShadow"
DropShadow_5.Parent = DropShadowHolder_5
DropShadow_5.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DropShadow_5.BackgroundTransparency = 1.000
DropShadow_5.BorderColor3 = Color3.fromRGB(255, 255, 255)
DropShadow_5.BorderSizePixel = 0
DropShadow_5.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_5.Size = UDim2.new(1, 35, 1, 35)
DropShadow_5.ZIndex = -1
DropShadow_5.Image = "rbxassetid://6014261993"
DropShadow_5.ImageColor3 = Color3.fromRGB(255, 0, 4)
DropShadow_5.ImageTransparency = 0.500
DropShadow_5.ScaleType = Enum.ScaleType.Slice
DropShadow_5.SliceCenter = Rect.new(49, 49, 450, 450)

CloseButton.Name = "CloseButton"
CloseButton.Parent = AutoCoinMain
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.Position = UDim2.new(0.566962421, 0, 0.664811552, 0)
CloseButton.Size = UDim2.new(0.127366081, 0, 0.0379395299, 0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = ""
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.TextSize = 20.000
CloseButton.TextStrokeTransparency = 0.000
CloseButton.TextWrapped = true

UICorner_15.CornerRadius = UDim.new(0, 5)
UICorner_15.Parent = CloseButton

UITextSizeConstraint_18.Parent = CloseButton
UITextSizeConstraint_18.MaxTextSize = 20

UIGradient_5.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 43, 47)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 125, 127)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(255, 38, 42)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
UIGradient_5.Rotation = 75
UIGradient_5.Parent = CloseButton

TextLabel_5.Parent = CloseButton
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.BackgroundTransparency = 1.000
TextLabel_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Size = UDim2.new(0.998713672, 0, 0.977388501, 0)
TextLabel_5.Font = Enum.Font.SourceSansBold
TextLabel_5.Text = "Close"
TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.TextScaled = true
TextLabel_5.TextSize = 14.000
TextLabel_5.TextStrokeTransparency = 0.500
TextLabel_5.TextWrapped = true

HideButton.Name = "HideButton"
HideButton.Parent = AutoCoinMain
HideButton.AnchorPoint = Vector2.new(0.5, 0.5)
HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
HideButton.Position = UDim2.new(0.432209045, 0, 0.664811552, 0)
HideButton.Size = UDim2.new(0.12736614, 0, 0.0379395299, 0)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.Text = ""
HideButton.TextColor3 = Color3.fromRGB(0, 0, 0)
HideButton.TextScaled = true
HideButton.TextSize = 20.000
HideButton.TextWrapped = true

UICorner_16.CornerRadius = UDim.new(0, 5)
UICorner_16.Parent = HideButton

UITextSizeConstraint_19.Parent = HideButton
UITextSizeConstraint_19.MaxTextSize = 20

UIGradient_6.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 199, 2)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(62, 203, 33)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(156, 255, 129)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(61, 195, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(42, 193, 0))}
UIGradient_6.Rotation = 75
UIGradient_6.Parent = HideButton

TextLabel_6.Parent = HideButton
TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.BackgroundTransparency = 1.000
TextLabel_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_6.BorderSizePixel = 0
TextLabel_6.Size = UDim2.new(0.998713672, 0, 0.977388501, 0)
TextLabel_6.Font = Enum.Font.SourceSansBold
TextLabel_6.Text = "Hide"
TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.TextScaled = true
TextLabel_6.TextSize = 14.000
TextLabel_6.TextStrokeTransparency = 0.500
TextLabel_6.TextWrapped = true

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Gui to Lua
-- Version: 3.2

-- Instances:

local AutoCoinHide = Instance.new("ScreenGui")
local ShowUiButtonShadow = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local DropShadowHolder = Instance.new("Frame")
local DropShadow = Instance.new("ImageLabel")
local ShowUiButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local TextLabel = Instance.new("TextLabel")
local UIGradient = Instance.new("UIGradient")

--Properties:

AutoCoinHide.Name = "AutoCoinHide"
AutoCoinHide.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AutoCoinHide.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AutoCoinHide.Enabled = false

ShowUiButtonShadow.Name = "ShowUiButtonShadow"
ShowUiButtonShadow.Parent = AutoCoinHide
ShowUiButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ShowUiButtonShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButtonShadow.BorderSizePixel = 0
ShowUiButtonShadow.Position = UDim2.new(0.012427506, 0, 0.912878811, 0)
ShowUiButtonShadow.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
ShowUiButtonShadow.Font = Enum.Font.SourceSansBold
ShowUiButtonShadow.Text = ""
ShowUiButtonShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButtonShadow.TextScaled = true
ShowUiButtonShadow.TextSize = 29.000
ShowUiButtonShadow.TextWrapped = true

UICorner.Parent = ShowUiButtonShadow

UITextSizeConstraint.Parent = ShowUiButtonShadow
UITextSizeConstraint.MaxTextSize = 29

DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = ShowUiButtonShadow
DropShadowHolder.BackgroundTransparency = 1.000
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0

DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1.000
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 35, 1, 35)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(3, 209, 0)
DropShadow.ImageTransparency = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

ShowUiButton.Name = "ShowUiButton"
ShowUiButton.Parent = AutoCoinHide
ShowUiButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShowUiButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButton.BorderSizePixel = 0
ShowUiButton.Position = UDim2.new(0.012427506, 0, 0.912878811, 0)
ShowUiButton.Size = UDim2.new(0.100000001, 0, 0.0500000007, 0)
ShowUiButton.Font = Enum.Font.SourceSansBold
ShowUiButton.Text = ""
ShowUiButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ShowUiButton.TextScaled = true
ShowUiButton.TextSize = 29.000
ShowUiButton.TextWrapped = true

UICorner_2.Parent = ShowUiButton

UITextSizeConstraint_2.Parent = ShowUiButton
UITextSizeConstraint_2.MaxTextSize = 29

TextLabel.Parent = ShowUiButton
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0.999254227, 0, 0.993630588, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Show UI"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 22.000
TextLabel.TextStrokeTransparency = 0.500
TextLabel.TextWrapped = true

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 199, 2)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(62, 203, 33)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(156, 255, 129)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(61, 195, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(42, 193, 0))}
UIGradient.Rotation = 75
UIGradient.Parent = ShowUiButton

local VirtualUser = game:GetService('VirtualUser')
 
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

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

function imortalDragon()
    local dragonNumber = getDragonNumber()
    local player = game.Players.LocalPlayer
    if dragonNumber and workspace.Characters:FindFirstChild(player.Name) then
        local character = workspace.Characters[player.Name]
        local dragon = character.Dragons[dragonNumber]
        if dragon and dragon:FindFirstChild("HumanoidRootPart") and dragon:FindFirstChild("RealHitbox") then
            local rootPart = dragon.HumanoidRootPart
            local rHitBox = dragon.RealHitbox
            rootPart.Size = Vector3.new(0.0011, 0.0011, 0.0011)
            rHitBox.Size = Vector3.new(0.0011, 0.0011, 0.0011)
        end
    end
end

function MobAura()
    local mobFolder = workspace:FindFirstChild("MobFolder")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local dragonNumber = getDragonNumber()
    local attackRange = 50

    if not mobFolder or not dragonNumber then 
        print("MobFolder or dragonNumber not found.")
        return 
    end

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

local isPause = false
local StartHavest = false 

local predefinedPositions = {
    -- Vector3.new(-1430.736572265625, 246.74830627441406, -1600.833251953125),
    -- Vector3.new(-864.0951538085938, 504.478759765625, -2033.88330078125),
    -- Vector3.new(-1813.89111328125, 233.04527282714844, -2354.91455078125),
    -- Vector3.new(-981.064453125, 392.6428527832031, -868.3142700195312),
    -- Vector3.new(-1048.2591552734375, 300.7080383300781, -2508.5439453125),
    -- Vector3.new(1475.412109375, 92.3567886352539, 100.74723052978516),
    -- Vector3.new(2185.489501953125, 172.75579833984375, -331.2497253417969),
    -- Vector3.new(2439.17529296875, 556.029052734375, -1367.130859375),
    -- Vector3.new(1508.160888671875, 372.6679382324219, -1789.7198486328125),
    -- Vector3.new(1798.6187744140625, 97.26102447509766, -2671.435302734375),

    Vector3.new(26.3707275, 86.2353973, -736.170044),
    Vector3.new(-423.318726, 487.90799, 361.035248),
    Vector3.new(-984.083252, 378.659302, -857.646606),
    Vector3.new(-1550.43774, 501.497833, 730.824036),
    Vector3.new(-2000.75635, 474.769012, -67.0544281),
    Vector3.new(-1430.73657, 246.748306, -1600.83325),
    Vector3.new(-853.757751, 481.095123, -2040.08521),
    Vector3.new(1474.97913, 68.9663849, 98.4963837),
    Vector3.new(1116.71594, 203.576874, 881.111328),
    Vector3.new(1508.16089, 372.667938, -1789.71985),
    Vector3.new(-1053.78931, 277.859497, -2514.93433),
    Vector3.new(2185.4895, 172.755798, -331.249725),
    Vector3.new(-1808.46545, 210.787933, -2346.9939),
    Vector3.new(364.394501, 161.599808, -2970.93213),
    Vector3.new(2439.17529, 556.029053, -1367.13086),
    Vector3.new(1805.83655, 74.7540054, -2677.03882),
    Vector3.new(2244.14844, 539.420471, -2370.38062),
    Vector3.new(2123.69336, 552.998413, -3770.9314),
    Vector3.new(-1077.52563, 721.864502, -4249.08447),
    Vector3.new(1234.38977, 769.469543, -4356.78516),
    Vector3.new(-2377.84985, 407.692108, -4492.34082),
    Vector3.new(-732.7455444335938, 864.955322265625, -5321.73046875),
}

local TARGET_ITEM_NAMES = {
    "EdamameFoodModel",
    "MistSudachiFoodModel",
    "KajiFruitFoodModel"
}


local function teleportDropItemsToPlayer()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local HumanoidRootPart = character.HumanoidRootPart
    local targetPosition = HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) 
    local cameraFolder = game.Workspace.Camera 


    for _, itemName in ipairs(TARGET_ITEM_NAMES) do

        local item = cameraFolder:FindFirstChild(itemName)
        if item then
            local primaryPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")

            if primaryPart then
                item:SetPrimaryPartCFrame(targetPosition)
            end
        end
    end
end

local function mainProgress()
    while not isPause do
        local EdamameCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Edamame")
        local MistSudachiCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("MistSudachi")
        local KajiFruitCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("KajiFruit")
        local MeatCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Meat")
        local BaconCount = game:GetService("Players").LocalPlayer.Data.Resources:FindFirstChild("Bacon")

        if game.PlaceId == 3475397644 then
            if EdamameCount.Value >= 1 then
                local args1 = {
                    {
                        ItemName = "Edamame",
                        Amount = EdamameCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args1))
                wait(1)
            end

            if MistSudachiCount.Value >= 1 then
                local args2 = {
                    {
                        ItemName = "MistSudachi",
                        Amount = MistSudachiCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args2))
                wait(1)
            end

            if KajiFruitCount.Value >= 1 then
                local args3 = {
                    {
                        ItemName = "KajiFruit",
                        Amount = KajiFruitCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args3))
                wait(1)
            end

            if MeatCount.Value >= 1 then
                local args4 = {
                    {
                        ItemName = "Meat",
                        Amount = MeatCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args4))
                wait(1)
            end

            if BaconCount.Value >= 1 then
                local args5 = {
                    {
                        ItemName = "Bacon",
                        Amount = BaconCount.Value
                    },
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SellItemRemote"):FireServer(unpack(args5))
                wait(1)
            end

            if EdamameCount.Value < 9000 and MistSudachiCount.Value < 9000 and KajiFruitCount.Value < 9000 then
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
                if OnlyFirst then
                    for _, friend in pairs(result) do
                        for _, player in pairs(playerList) do
                            if player.Name == friend.UserName then
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
                                else
                                    print("ไม่มีข้อมูล playing หรือเกิดข้อผิดพลาดในการดึงข้อมูล")
                                end
                            end
                        end
                    end
                    OnlyFirst = false
                end
            end

            if EdamameCount.Value >= 9000 or MistSudachiCount.Value >= 9000 or KajiFruitCount.Value >= 9000 then
                StartHavest = false
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WorldTeleportRemote"):InvokeServer(3475397644)
            else
                StartHavest = true
                task.wait(0.01)
                while StartHavest do
                    teleportDropItemsToPlayer()
                    for _, position in ipairs(predefinedPositions) do
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 10, 0))
                        task.wait(0.01)
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
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(treePosition + Vector3.new(0, 10, 0))
                                    task.wait(0)
                                    local billboardPart = tree:FindFirstChild("BillboardPart")
                                    if billboardPart then
                                        while true do
                                            teleportDropItemsToPlayer()
                                            local Health = billboardPart:FindFirstChild("Health")
                                            if Health and Health.Value > 0 then
                                                teleportDropItemsToPlayer()
                                                attackTree(billboardPart)
                                                teleportDropItemsToPlayer()
                                                MobAura()
                                                task.wait(0.15)
                                                teleportDropItemsToPlayer()
                                                attackTreeBite(billboardPart)
                                                teleportDropItemsToPlayer()
                                            else
                                                wait(0.25)
                                                teleportDropItemsToPlayer()
                                                wait(0.25)
                                                teleportDropItemsToPlayer()
                                                wait(0.25)
                                                teleportDropItemsToPlayer()
                                                wait(0.25)
                                                teleportDropItemsToPlayer()
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.01)
                    mainProgress()
                end
            end
        end
        task.wait(0.01)
    end
end

StopButton.MouseButton1Click:Connect(function()
    if TextLabel_3.Text == "Pause" then
        TextLabel_3.Text = "Start"
        -- StopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        DropShadow_2.ImageColor3 = Color3.fromRGB(38, 255, 0)
        GreenGradient.Enabled = true
        RedGradient.Enabled = false
        StatusText.Text = "Status : Pause"
        isPause = true
        StartHavest = false
    elseif TextLabel_3.Text == "Start" then
        TextLabel_3.Text = "Pause"
        -- StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        DropShadow_2.ImageColor3 = Color3.fromRGB(255, 38, 0)
        GreenGradient.Enabled = false
        RedGradient.Enabled = true
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
end)

CloseButton.MouseButton1Click:Connect(function()
    isPause = true
    StartHavest = false
	AutoCoinMain:Destroy()
    createNotification("The script is now closed", "error", 3)
end)

local isHind = false

HideButton.MouseButton1Click:Connect(function()
    AutoCoinMain.Enabled = false
    AutoCoinHide.Enabled = true
    isHind = true
    createNotification("The script is hiding", "", 3)
end)

ShowUiButton.MouseButton1Click:Connect(function()
    AutoCoinMain.Enabled = true
    AutoCoinHide.Enabled = false
    isHind = false
    createNotification("The script is showing", "", 3)
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

imortalDragon()

mainProgress()
