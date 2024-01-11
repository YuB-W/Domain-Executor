local CoreGui = game:GetService("CoreGui")
local Humanoid = game.Players.LocalPlayer.Character.Humanoid

HPScreen = Instance.new("ScreenGui")
Background = Instance.new("Frame")
Text = Instance.new("TextLabel")
UICorner = Instance.new("UICorner")
Dragg = Instance.new("TextLabel")
ICorner_2 = Instance.new("UICorner")

HPScreen.Name = "HP"
HPScreen.Parent = CoreGui

Background.Name = "Background"
Background.Parent = HPScreen
Background.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
Background.BackgroundTransparency = 1.000
Background.Position = UDim2.new(0.0220729373, 0, 0.0688000023, 0)
Background.Size = UDim2.new(0, 100, 0, 40)
Background.Draggable = true
Background.Active = true

Text.Name = "Text"
Text.Parent = Background
Text.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Text.BackgroundTransparency = 0.500
Text.BorderSizePixel = 0
Text.Position = UDim2.new(0.400000006, 0, 0, 0)
Text.Size = UDim2.new(0, 60, 0, 40)
Text.Font = Enum.Font.Gotham

Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextSize = 20.000

UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = Text

Dragg.Name = "Dragg"
Dragg.Parent = Background
Dragg.BackgroundColor3 = Color3.fromRGB(141, 255, 121)
Dragg.BackgroundTransparency = 0.500
Dragg.BorderSizePixel = 0
Dragg.Position = UDim2.new(0.0599999987, 0, 0, 0)
Dragg.Size = UDim2.new(0, 35, 0, 40)
Dragg.Font = Enum.Font.SourceSans
Dragg.Text = ""
Dragg.TextColor3 = Color3.fromRGB(0, 0, 0)
Dragg.TextSize = 14.000

while wait (0.01) do
   Text.Text = Humanoid.Health
end
