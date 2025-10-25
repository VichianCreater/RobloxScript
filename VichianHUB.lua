-- Gui to Lua
-- Version: 3.2

-- Instances:

local VichianHUB = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local Header = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local TextHeader = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local LogoHeader = Instance.new("ImageLabel")
local CloseButton = Instance.new("TextButton")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Body = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local List = Instance.new("Frame")
local NameBox = Instance.new("Frame")
local ExeButton = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local NameText = Instance.new("TextLabel")
local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
local GameLogo = Instance.new("ImageLabel")
local UIGradient_2 = Instance.new("UIGradient")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local List_2 = Instance.new("Frame")
local NameBox_2 = Instance.new("Frame")
local NameText_2 = Instance.new("TextLabel")
local UITextSizeConstraint_5 = Instance.new("UITextSizeConstraint")
local ExeButton_2 = Instance.new("TextButton")
local UITextSizeConstraint_6 = Instance.new("UITextSizeConstraint")
local GameLogo_2 = Instance.new("ImageLabel")
local UIGradient_3 = Instance.new("UIGradient")

--Properties:

VichianHUB.Name = "VichianHUB"
VichianHUB.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
VichianHUB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Container.Name = "Container"
Container.Parent = VichianHUB
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.new(0.162071839, 0, 0.412528723, 0)

Header.Name = "Header"
Header.Parent = Container
Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0.074742265, 0)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 236, 96)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(152, 109, 59))}
UIGradient.Rotation = 90
UIGradient.Parent = Header

TextHeader.Name = "TextHeader"
TextHeader.Parent = Header
TextHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextHeader.BackgroundTransparency = 1.000
TextHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextHeader.BorderSizePixel = 0
TextHeader.Position = UDim2.new(0.0980392173, 0, 0, 0)
TextHeader.Size = UDim2.new(0.343137264, 0, 1.00000012, 0)
TextHeader.Font = Enum.Font.Michroma
TextHeader.Text = "Vichian HUB"
TextHeader.TextColor3 = Color3.fromRGB(0, 0, 0)
TextHeader.TextScaled = true
TextHeader.TextSize = 14.000
TextHeader.TextWrapped = true
TextHeader.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint.Parent = TextHeader
UITextSizeConstraint.MaxTextSize = 14

LogoHeader.Name = "LogoHeader"
LogoHeader.Parent = Header
LogoHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoHeader.BackgroundTransparency = 1.000
LogoHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
LogoHeader.BorderSizePixel = 0
LogoHeader.Size = UDim2.new(0.0980392173, 0, 1.00000012, 0)
LogoHeader.Image = "rbxassetid://74835950536249"

CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 82, 85)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.908496737, 0, 0.137931049, 0)
CloseButton.Size = UDim2.new(0.0653594807, 0, 0.689655244, 0)
CloseButton.Font = Enum.Font.Unknown
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.TextScaled = true
CloseButton.TextSize = 10.000
CloseButton.TextWrapped = true

UITextSizeConstraint_2.Parent = CloseButton
UITextSizeConstraint_2.MaxTextSize = 10

Body.Name = "Body"
Body.Parent = Container
Body.AnchorPoint = Vector2.new(0.5, 0.5)
Body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Body.BackgroundTransparency = 1.000
Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
Body.BorderSizePixel = 0
Body.Position = UDim2.new(0.5, 0, 0.536597967, 0)
Body.Size = UDim2.new(0.947712421, 0, 0.889175236, 0)

ScrollingFrame.Parent = Body
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(-0.0241379309, 0, -0.0173913036, 0)
ScrollingFrame.Size = UDim2.new(1.0517242, 0, 1.01739132, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
ScrollingFrame.ScrollBarThickness = 5

List.Name = "List"
List.Parent = ScrollingFrame
List.AnchorPoint = Vector2.new(0.5, 0.5)
List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
List.BorderColor3 = Color3.fromRGB(0, 0, 0)
List.BorderSizePixel = 0
List.Position = UDim2.new(0, 0, 0.0341880359, 0)
List.Size = UDim2.new(0, 280, 0, 68)

NameBox.Name = "NameBox"
NameBox.Parent = List
NameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox.BackgroundTransparency = 1.000
NameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameBox.BorderSizePixel = 0
NameBox.Position = UDim2.new(0.328571439, 0, -0.0147058824, 0)
NameBox.Size = UDim2.new(0.657142878, 0, 1, 0)

ExeButton.Name = "ExeButton"
ExeButton.Parent = NameBox
ExeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ExeButton.BorderSizePixel = 0
ExeButton.Position = UDim2.new(0.179347828, 0, 0.514705896, 0)
ExeButton.Size = UDim2.new(0.635869563, 0, 0.397058815, 0)
ExeButton.Font = Enum.Font.Michroma
ExeButton.Text = "Execute"
ExeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ExeButton.TextScaled = true
ExeButton.TextSize = 14.000
ExeButton.TextWrapped = true

UITextSizeConstraint_3.Parent = ExeButton
UITextSizeConstraint_3.MaxTextSize = 14

NameText.Name = "NameText"
NameText.Parent = NameBox
NameText.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NameText.BackgroundTransparency = 0.500
NameText.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameText.BorderSizePixel = 0
NameText.Position = UDim2.new(0.0163043477, 0, 0.102941178, 0)
NameText.Size = UDim2.new(0.961956501, 0, 0.323529422, 0)
NameText.Font = Enum.Font.Michroma
NameText.Text = "DragonAdventure"
NameText.TextColor3 = Color3.fromRGB(255, 255, 255)
NameText.TextScaled = true
NameText.TextSize = 14.000
NameText.TextWrapped = true

UITextSizeConstraint_4.Parent = NameText
UITextSizeConstraint_4.MaxTextSize = 14

GameLogo.Name = "GameLogo"
GameLogo.Parent = List
GameLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GameLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
GameLogo.BorderSizePixel = 0
GameLogo.Position = UDim2.new(0.042857144, 0, 0.0882352963, 0)
GameLogo.Size = UDim2.new(0.196428567, 0, 0.808823526, 0)
GameLogo.Image = "rbxasset://82524249662954"

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 43, 43)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 197, 197))}
UIGradient_2.Parent = List

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0.00499999989, 0)

UIPadding.Parent = ScrollingFrame
UIPadding.PaddingLeft = UDim.new(0.0399999991, 0)
UIPadding.PaddingTop = UDim.new(0.00999999978, 0)

List_2.Name = "List"
List_2.Parent = ScrollingFrame
List_2.AnchorPoint = Vector2.new(0.5, 0.5)
List_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
List_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
List_2.BorderSizePixel = 0
List_2.Position = UDim2.new(0, 0, 0.0341880359, 0)
List_2.Size = UDim2.new(0, 280, 0, 68)
List_2.Visible = false

NameBox_2.Name = "NameBox"
NameBox_2.Parent = List_2
NameBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox_2.BackgroundTransparency = 1.000
NameBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameBox_2.BorderSizePixel = 0
NameBox_2.Position = UDim2.new(0.328571439, 0, -0.0147058824, 0)
NameBox_2.Size = UDim2.new(0.657142878, 0, 1, 0)

NameText_2.Name = "NameText"
NameText_2.Parent = NameBox_2
NameText_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NameText_2.BackgroundTransparency = 0.500
NameText_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameText_2.BorderSizePixel = 0
NameText_2.Position = UDim2.new(0.0163043477, 0, 0.102941178, 0)
NameText_2.Size = UDim2.new(0.961956501, 0, 0.323529422, 0)
NameText_2.Font = Enum.Font.Michroma
NameText_2.Text = "DragonAdventure Auto"
NameText_2.TextColor3 = Color3.fromRGB(255, 255, 255)
NameText_2.TextScaled = true
NameText_2.TextSize = 14.000
NameText_2.TextWrapped = true

UITextSizeConstraint_5.Parent = NameText_2
UITextSizeConstraint_5.MaxTextSize = 14

ExeButton_2.Name = "ExeButton"
ExeButton_2.Parent = NameBox_2
ExeButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ExeButton_2.BorderSizePixel = 0
ExeButton_2.Position = UDim2.new(0.179347828, 0, 0.514705896, 0)
ExeButton_2.Size = UDim2.new(0.635869563, 0, 0.397058815, 0)
ExeButton_2.Font = Enum.Font.Michroma
ExeButton_2.Text = "Execute"
ExeButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
ExeButton_2.TextScaled = true
ExeButton_2.TextSize = 14.000
ExeButton_2.TextWrapped = true

UITextSizeConstraint_6.Parent = ExeButton_2
UITextSizeConstraint_6.MaxTextSize = 14

GameLogo_2.Name = "GameLogo"
GameLogo_2.Parent = List_2
GameLogo_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GameLogo_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
GameLogo_2.BorderSizePixel = 0
GameLogo_2.Position = UDim2.new(0.042857144, 0, 0.0882352963, 0)
GameLogo_2.Size = UDim2.new(0.196428567, 0, 0.808823526, 0)
GameLogo_2.Image = "rbxasset://82524249662954"

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 43, 43)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 197, 197))}
UIGradient_3.Parent = List_2

CloseButton.MouseButton1Click:Connect(function()
	VichianHUB:Destroy()
end)

ExeButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/VichianCreater/RobloxScript/main/main.lua'))()
    VichianHUB:Destroy()
end)

ExeButton_2.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/VichianCreater/RobloxScript/main/autocoin.lua'))()
    VichianHUB:Destroy()
end)
