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
Container.Position = UDim2.new(0.5, 141, 0.5, -21)
Container.Size = UDim2.new(0, 306, 0, 388)

Header.Name = "Header"
Header.Parent = Container
Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(0, 306, 0, 29)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 236, 96)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(152, 109, 59))}
UIGradient.Rotation = 90
UIGradient.Parent = Header

TextHeader.Name = "TextHeader"
TextHeader.Parent = Header
TextHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextHeader.BackgroundTransparency = 1.000
TextHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextHeader.BorderSizePixel = 0
TextHeader.Position = UDim2.new(0, 30, 0, 0)
TextHeader.Size = UDim2.new(0, 105, 0, 29)
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
LogoHeader.Size = UDim2.new(0, 30, 0, 29)
LogoHeader.Image = "rbxassetid://74835950536249"

CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 82, 85)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0, 278, 0, 4)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
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
Body.Position = UDim2.new(0, 153, 0, 210)
Body.Size = UDim2.new(0, 290, 0, 336)

ScrollingFrame.Parent = Body
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, -7, 0, -12)
ScrollingFrame.Size = UDim2.new(0, 305, 0, 357)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
ScrollingFrame.ScrollBarThickness = 5

List.Name = "List"
List.Parent = ScrollingFrame
List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
List.BorderColor3 = Color3.fromRGB(0, 0, 0)
List.BorderSizePixel = 0
List.Position = UDim2.new(0, 0, 0, 12)
List.Size = UDim2.new(0, 280, 0, 68)

NameBox.Name = "NameBox"
NameBox.Parent = List
NameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox.BackgroundTransparency = 1.000
NameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameBox.BorderSizePixel = 0
NameBox.Position = UDim2.new(0, 92, 0, -1)
NameBox.Size = UDim2.new(0.657142878, 0, 1, 0)

ExeButton.Name = "ExeButton"
ExeButton.Parent = NameBox
ExeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ExeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ExeButton.BorderSizePixel = 0
ExeButton.Position = UDim2.new(0, 33, 0, 35)
ExeButton.Size = UDim2.new(0, 117, 0, 27)
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
NameText.Position = UDim2.new(0, 3, 0, 7)
NameText.Size = UDim2.new(0, 177, 0, 22)
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
GameLogo.Position = UDim2.new(0, 12, 0, 6)
GameLogo.Size = UDim2.new(0, 55, 0, 55)
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
List_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
List_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
List_2.BorderSizePixel = 0
List_2.Position = UDim2.new(0, 0, 0, 12)
List_2.Size = UDim2.new(0, 280, 0, 68)

NameBox_2.Name = "NameBox"
NameBox_2.Parent = List_2
NameBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NameBox_2.BackgroundTransparency = 1.000
NameBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameBox_2.BorderSizePixel = 0
NameBox_2.Position = UDim2.new(0, 92, 0, -1)
NameBox_2.Size = UDim2.new(0.657142878, 0, 1, 0)

NameText_2.Name = "NameText"
NameText_2.Parent = NameBox_2
NameText_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
NameText_2.BackgroundTransparency = 0.500
NameText_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
NameText_2.BorderSizePixel = 0
NameText_2.Position = UDim2.new(0, 3, 0, 7)
NameText_2.Size = UDim2.new(0, 177, 0, 22)
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
ExeButton_2.Position = UDim2.new(0, 33, 0, 35)
ExeButton_2.Size = UDim2.new(0, 117, 0, 27)
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
GameLogo_2.Position = UDim2.new(0, 12, 0, 6)
GameLogo_2.Size = UDim2.new(0, 55, 0, 55)
GameLogo_2.Image = "rbxasset://82524249662954"

UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 43, 43)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(197, 197, 197))}
UIGradient_3.Parent = List_2

CloseButton.MouseButton1Click:Connect(function()
	VichianHUB:Destroy()
end)

ExeButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/VichianCreater/RobloxScript/main/main.lua'))()
end)

ExeButton_2.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/VichianCreater/RobloxScript/main/autocoin.lua'))()
end)
