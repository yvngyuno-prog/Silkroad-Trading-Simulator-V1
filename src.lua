local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local TweenSpeed = 60

local Presets = {
	Palmyra = Vector3.new(4572, -55, 6114),
	Damascus = Vector3.new(796, -55, 2409),
	Antioch = Vector3.new(4430, 59, -560),
	Ctesiphon = Vector3.new(1978, -55, 9697),
	Ecbatana = Vector3.new(4272, 89, 11443),
	Tyre = Vector3.new(108, -43, -1796)
}
local Couriers = {
	Ecbatana = Vector3.new(4078, 89, 11548),
	Palmyra = Vector3.new(4531, -55, 6312),
	Damascus = Vector3.new(851, -54, 2396),
	Tyre = Vector3.new(-127, -42, -1438)
}

local Connections = {}
local Destroyed = false
local CurrentTween = nil

local ScreenGui
local Main
local TopBar

local Minimized = false
local UIVisible = true

local FullSize = UDim2.fromOffset(360, 430)
local MinimizedSize = UDim2.fromOffset(360, 48)

local function Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Connections, connection)
	return connection
end

local function Cleanup()
	if Destroyed then
		return
	end

	Destroyed = true

	if CurrentTween then
		CurrentTween:Cancel()
		CurrentTween = nil
	end

	for _, connection in ipairs(Connections) do
		if connection then
			connection:Disconnect()
		end
	end

	table.clear(Connections)

	if ScreenGui then
		ScreenGui:Destroy()
	end
end

local function GetRootPart()
	local Character = Player.Character

	if not Character then
		return nil
	end

	return Character:FindFirstChild("HumanoidRootPart")
end

local function TweenToPosition(Position)
	if Destroyed then
		return
	end

	local RootPart = GetRootPart()

	if not RootPart then
		return
	end

	if CurrentTween then
		CurrentTween:Cancel()
		CurrentTween = nil
	end

	local TweenInfoObject = TweenInfo.new(
		TweenSpeed,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	CurrentTween = TweenService:Create(
		RootPart,
		TweenInfoObject,
		{
			CFrame = CFrame.new(Position)
		}
	)

	local ThisTween = CurrentTween

	CurrentTween:Play()

	Connect(ThisTween.Completed, function()
		if CurrentTween == ThisTween then
			CurrentTween = nil
		end
	end)
end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TweenController"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = FullSize
Main.Position = UDim2.new(0.5, -180, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 65, 80)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(16, 0)
Title.BackgroundTransparency = 1
Title.Text = "Track Hub"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.Position = UDim2.new(1, -82, 0, 7)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(220, 220, 225)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 9)
MinimizeCorner.Parent = Minimize

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -42, 0, 7)
Close.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 220, 225)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = Close

Connect(Minimize.MouseEnter, function()
	Minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
end)

Connect(Minimize.MouseLeave, function()
	Minimize.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
end)

Connect(Close.MouseEnter, function()
	Close.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
end)

Connect(Close.MouseLeave, function()
	Close.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
end)

Connect(Close.MouseButton1Click, Cleanup)

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -48)
Content.Position = UDim2.fromOffset(0, 48)
Content.BackgroundTransparency = 1
Content.Parent = Main

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.fromOffset(120, 25)
SpeedLabel.Position = UDim2.fromOffset(18, 9)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Content

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.fromOffset(100, 32)
SpeedBox.Position = UDim2.fromOffset(240, 6)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(TweenSpeed)
SpeedBox.PlaceholderText = "55"
SpeedBox.TextColor3 = Color3.fromRGB(235, 235, 240)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
SpeedBox.TextSize = 14
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Content

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedBox

Connect(SpeedBox.FocusLost, function()
	local Value = tonumber(SpeedBox.Text)

	if Value and Value > 0 then
		TweenSpeed = Value
		SpeedBox.Text = tostring(Value)
	else
		SpeedBox.Text = tostring(TweenSpeed)
	end
end)

local PresetLabel = Instance.new("TextLabel")
PresetLabel.Name = "PresetLabel"
PresetLabel.Size = UDim2.fromOffset(100, 25)
PresetLabel.Position = UDim2.fromOffset(18, 52)
PresetLabel.BackgroundTransparency = 1
PresetLabel.Text = "City"
PresetLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
PresetLabel.TextSize = 13
PresetLabel.Font = Enum.Font.GothamMedium
PresetLabel.TextXAlignment = Enum.TextXAlignment.Left
PresetLabel.Parent = Content

local PresetButton = Instance.new("TextButton")
PresetButton.Name = "PresetButton"
PresetButton.Size = UDim2.fromOffset(220, 34)
PresetButton.Position = UDim2.fromOffset(122, 48)
PresetButton.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
PresetButton.BorderSizePixel = 0
PresetButton.Text = "Select preset  ▼"
PresetButton.TextColor3 = Color3.fromRGB(235, 235, 240)
PresetButton.TextSize = 13
PresetButton.Font = Enum.Font.Gotham
PresetButton.AutoButtonColor = false
PresetButton.TextXAlignment = Enum.TextXAlignment.Left
PresetButton.Parent = Content

local PresetPadding = Instance.new("UIPadding")
PresetPadding.PaddingLeft = UDim.new(0, 12)
PresetPadding.Parent = PresetButton

local PresetCorner = Instance.new("UICorner")
PresetCorner.CornerRadius = UDim.new(0, 8)
PresetCorner.Parent = PresetButton

local Dropdown = Instance.new("ScrollingFrame")
Dropdown.Name = "PresetDropdown"
Dropdown.Size = UDim2.fromOffset(220, 0)
Dropdown.Position = UDim2.fromOffset(122, 84)
Dropdown.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
Dropdown.BorderSizePixel = 0
Dropdown.Visible = false
Dropdown.ClipsDescendants = true
Dropdown.ZIndex = 20
Dropdown.CanvasSize = UDim2.fromOffset(0, 0)
Dropdown.ScrollBarThickness = 4
Dropdown.ScrollBarImageTransparency = 0.25
Dropdown.ScrollingDirection = Enum.ScrollingDirection.Y
Dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
Dropdown.Parent = Content

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 8)
DropdownCorner.Parent = Dropdown

local DropdownStroke = Instance.new("UIStroke")
DropdownStroke.Color = Color3.fromRGB(65, 65, 80)
DropdownStroke.Transparency = 0.25
DropdownStroke.Parent = Dropdown

local DropdownPadding = Instance.new("UIPadding")
DropdownPadding.PaddingTop = UDim.new(0, 2)
DropdownPadding.PaddingBottom = UDim.new(0, 2)
DropdownPadding.Parent = Dropdown

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.SortOrder = Enum.SortOrder.Name
DropdownLayout.Padding = UDim.new(0, 2)
DropdownLayout.Parent = Dropdown

local DropdownOpen = false

local function ClosePresetDropdown()
	DropdownOpen = false
	Dropdown.Visible = false
	Dropdown.Size = UDim2.fromOffset(220, 0)
	Dropdown.CanvasPosition = Vector2.new(0, 0)
end

local function OpenPresetDropdown()
	DropdownOpen = true
	Dropdown.Visible = true
	Dropdown.Size = UDim2.fromOffset(220, 150)
end

local CourierLabel = Instance.new("TextLabel")
CourierLabel.Name = "CourierLabel"
CourierLabel.Size = UDim2.fromOffset(100, 25)
CourierLabel.Position = UDim2.fromOffset(18, 94)
CourierLabel.BackgroundTransparency = 1
CourierLabel.Text = "Courier"
CourierLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
CourierLabel.TextSize = 13
CourierLabel.Font = Enum.Font.GothamMedium
CourierLabel.TextXAlignment = Enum.TextXAlignment.Left
CourierLabel.Parent = Content

local CourierButton = Instance.new("TextButton")
CourierButton.Name = "CourierButton"
CourierButton.Size = UDim2.fromOffset(220, 34)
CourierButton.Position = UDim2.fromOffset(122, 90)
CourierButton.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
CourierButton.BorderSizePixel = 0
CourierButton.Text = "Select courier  ▼"
CourierButton.TextColor3 = Color3.fromRGB(235, 235, 240)
CourierButton.TextSize = 13
CourierButton.Font = Enum.Font.Gotham
CourierButton.AutoButtonColor = false
CourierButton.TextXAlignment = Enum.TextXAlignment.Left
CourierButton.Parent = Content

local CourierPadding = Instance.new("UIPadding")
CourierPadding.PaddingLeft = UDim.new(0, 12)
CourierPadding.Parent = CourierButton

local CourierCorner = Instance.new("UICorner")
CourierCorner.CornerRadius = UDim.new(0, 8)
CourierCorner.Parent = CourierButton

local CourierDropdown = Instance.new("ScrollingFrame")
CourierDropdown.Name = "CourierDropdown"
CourierDropdown.Size = UDim2.fromOffset(220, 0)
CourierDropdown.Position = UDim2.fromOffset(122, 126)
CourierDropdown.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
CourierDropdown.BorderSizePixel = 0
CourierDropdown.Visible = false
CourierDropdown.ClipsDescendants = true
CourierDropdown.ZIndex = 20
CourierDropdown.CanvasSize = UDim2.fromOffset(0, 0)
CourierDropdown.ScrollBarThickness = 4
CourierDropdown.ScrollBarImageTransparency = 0.25
CourierDropdown.ScrollingDirection = Enum.ScrollingDirection.Y
CourierDropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
CourierDropdown.Parent = Content

local CourierDropdownCorner = Instance.new("UICorner")
CourierDropdownCorner.CornerRadius = UDim.new(0, 8)
CourierDropdownCorner.Parent = CourierDropdown

local CourierDropdownStroke = Instance.new("UIStroke")
CourierDropdownStroke.Color = Color3.fromRGB(65, 65, 80)
CourierDropdownStroke.Transparency = 0.25
CourierDropdownStroke.Parent = CourierDropdown

local CourierDropdownPadding = Instance.new("UIPadding")
CourierDropdownPadding.PaddingTop = UDim.new(0, 2)
CourierDropdownPadding.PaddingBottom = UDim.new(0, 2)
CourierDropdownPadding.Parent = CourierDropdown

local CourierDropdownLayout = Instance.new("UIListLayout")
CourierDropdownLayout.SortOrder = Enum.SortOrder.Name
CourierDropdownLayout.Padding = UDim.new(0, 2)
CourierDropdownLayout.Parent = CourierDropdown

local CourierDropdownOpen = false

local function CloseCourierDropdown()
	CourierDropdownOpen = false
	CourierDropdown.Visible = false
	CourierDropdown.Size = UDim2.fromOffset(220, 0)
	CourierDropdown.CanvasPosition = Vector2.new(0, 0)
end

local function OpenCourierDropdown()
	CourierDropdownOpen = true
	CourierDropdown.Visible = true
	CourierDropdown.Size = UDim2.fromOffset(220, 150)
end

local function CreateCoordinateBox(Name, Y, Default)
	local Box = Instance.new("TextBox")

	Box.Name = Name
	Box.Size = UDim2.fromOffset(100, 34)
	Box.Position = UDim2.fromOffset(240, Y)
	Box.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
	Box.BorderSizePixel = 0
	Box.Text = tostring(Default)
	Box.TextColor3 = Color3.fromRGB(235, 235, 240)
	Box.TextSize = 14
	Box.Font = Enum.Font.Gotham
	Box.ClearTextOnFocus = false
	Box.Parent = Content

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Box

	return Box
end

local XLabel = Instance.new("TextLabel")
XLabel.Name = "XLabel"
XLabel.Size = UDim2.fromOffset(120, 25)
XLabel.Position = UDim2.fromOffset(18, 139)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X Position"
XLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
XLabel.TextSize = 13
XLabel.Font = Enum.Font.GothamMedium
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.Parent = Content

local XBox = CreateCoordinateBox("X", 135, 0)

local YLabel = XLabel:Clone()
YLabel.Name = "YLabel"
YLabel.Position = UDim2.fromOffset(18, 181)
YLabel.Text = "Y Position"
YLabel.Parent = Content

local YBox = CreateCoordinateBox("Y", 177, 0)

local ZLabel = XLabel:Clone()
ZLabel.Name = "ZLabel"
ZLabel.Position = UDim2.fromOffset(18, 223)
ZLabel.Text = "Z Position"
ZLabel.Parent = Content

local ZBox = CreateCoordinateBox("Z", 219, 0)

local function RefreshPresets()
	for _, Child in ipairs(Dropdown:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	for Name, Position in pairs(Presets) do
		local Button = Instance.new("TextButton")

		Button.Name = Name
		Button.Size = UDim2.new(1, -8, 0, 34)
		Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
		Button.BorderSizePixel = 0
		Button.Text = Name
		Button.TextColor3 = Color3.fromRGB(230, 230, 235)
		Button.TextSize = 13
		Button.Font = Enum.Font.Gotham
		Button.AutoButtonColor = false
		Button.TextXAlignment = Enum.TextXAlignment.Left
		Button.ZIndex = 21
		Button.Parent = Dropdown

		local Padding = Instance.new("UIPadding")
		Padding.PaddingLeft = UDim.new(0, 12)
		Padding.Parent = Button

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Button

		Connect(Button.MouseEnter, function()
			Button.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
		end)

		Connect(Button.MouseLeave, function()
			Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
		end)

		Connect(Button.MouseButton1Click, function()
			local PositionValue = Presets[Name]

			if PositionValue then
				XBox.Text = tostring(PositionValue.X)
				YBox.Text = tostring(PositionValue.Y)
				ZBox.Text = tostring(PositionValue.Z)

				PresetButton.Text = Name .. "  ▼"

				ClosePresetDropdown()
				CloseCourierDropdown()
			end
		end)
	end
end

local function RefreshCouriers()
	for _, Child in ipairs(CourierDropdown:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	local HasCouriers = false

	for Name, Position in pairs(Couriers) do
		HasCouriers = true

		local Button = Instance.new("TextButton")

		Button.Name = Name
		Button.Size = UDim2.new(1, -8, 0, 34)
		Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
		Button.BorderSizePixel = 0
		Button.Text = Name
		Button.TextColor3 = Color3.fromRGB(230, 230, 235)
		Button.TextSize = 13
		Button.Font = Enum.Font.Gotham
		Button.AutoButtonColor = false
		Button.TextXAlignment = Enum.TextXAlignment.Left
		Button.ZIndex = 21
		Button.Parent = CourierDropdown

		local Padding = Instance.new("UIPadding")
		Padding.PaddingLeft = UDim.new(0, 12)
		Padding.Parent = Button

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Button

		Connect(Button.MouseEnter, function()
			Button.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
		end)

		Connect(Button.MouseLeave, function()
			Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
		end)

		Connect(Button.MouseButton1Click, function()
			local PositionValue = Couriers[Name]

			if PositionValue then
				XBox.Text = tostring(PositionValue.X)
				YBox.Text = tostring(PositionValue.Y)
				ZBox.Text = tostring(PositionValue.Z)

				CourierButton.Text = Name .. "  ▼"

				CloseCourierDropdown()
				ClosePresetDropdown()
			end
		end)
	end

	if not HasCouriers then
		local EmptyButton = Instance.new("TextButton")

		EmptyButton.Name = "NoCouriers"
		EmptyButton.Size = UDim2.new(1, -8, 0, 34)
		EmptyButton.BackgroundTransparency = 1
		EmptyButton.Text = "No couriers added"
		EmptyButton.TextColor3 = Color3.fromRGB(120, 120, 130)
		EmptyButton.TextSize = 12
		EmptyButton.Font = Enum.Font.Gotham
		EmptyButton.ZIndex = 21
		EmptyButton.Parent = CourierDropdown
	end
end

Connect(PresetButton.MouseButton1Click, function()
	CloseCourierDropdown()

	if DropdownOpen then
		ClosePresetDropdown()
	else
		OpenPresetDropdown()
	end
end)

Connect(CourierButton.MouseButton1Click, function()
	ClosePresetDropdown()

	if CourierDropdownOpen then
		CloseCourierDropdown()
	else
		OpenCourierDropdown()
	end
end)

RefreshPresets()
RefreshCouriers()

local TweenButton = Instance.new("TextButton")
TweenButton.Name = "TweenButton"
TweenButton.Size = UDim2.new(1, -36, 0, 42)
TweenButton.Position = UDim2.fromOffset(18, 268)
TweenButton.BackgroundColor3 = Color3.fromRGB(65, 105, 210)
TweenButton.BorderSizePixel = 0
TweenButton.Text = "Travel"
TweenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TweenButton.TextSize = 14
TweenButton.Font = Enum.Font.GothamBold
TweenButton.AutoButtonColor = false
TweenButton.Parent = Content

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 9)
ButtonCorner.Parent = TweenButton

Connect(TweenButton.MouseEnter, function()
	TweenButton.BackgroundColor3 = Color3.fromRGB(80, 120, 225)
end)

Connect(TweenButton.MouseLeave, function()
	TweenButton.BackgroundColor3 = Color3.fromRGB(65, 105, 210)
end)

Connect(TweenButton.MouseButton1Click, function()
	local X = tonumber(XBox.Text)
	local Y = tonumber(YBox.Text)
	local Z = tonumber(ZBox.Text)

	if not X or not Y or not Z then
		return
	end

	TweenToPosition(Vector3.new(X, Y, Z))
end)

local function SetMinimized(State)
	Minimized = State

	if Minimized then
		Main.Size = MinimizedSize
		Minimize.Text = "+"
		ClosePresetDropdown()
		CloseCourierDropdown()
	else
		Main.Size = FullSize
		Minimize.Text = "—"
	end
end

Connect(Minimize.MouseButton1Click, function()
	SetMinimized(not Minimized)
end)

Connect(UserInputService.InputBegan, function(Input, GameProcessed)
	if GameProcessed then
		return
	end

	if Input.KeyCode == Enum.KeyCode.K then
		UIVisible = not UIVisible
		ScreenGui.Enabled = UIVisible
	end
end)

--==================================================
-- DRAGGING
--==================================================

local Dragging = false
local DragStart
local StartPosition

Connect(TopBar.InputBegan, function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position

		local Connection

		Connection = Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false

				if Connection then
					Connection:Disconnect()
				end
			end
		end)

		table.insert(Connections, Connection)
	end
end)

Connect(UserInputService.InputChanged, function(Input)
	if not Dragging then
		return
	end

	if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	local Delta = Input.Position - DragStart

	Main.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,
		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)
end)

SetMinimized(false)
