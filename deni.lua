local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

local player = game.Players.LocalPlayer
local lighting = game:GetService("Lighting")

local boostEnabled = false

ScreenGui.Parent = player.PlayerGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,140,0,60)
Frame.Position = UDim2.new(0,10,0,10)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

UICorner.Parent = Frame

UIStroke.Parent = Frame
UIStroke.Color = Color3.fromRGB(0,170,255) -- borde azul
UIStroke.Thickness = 2

Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,20)
Title.Text = "DenisBoost"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,170,255)

ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0,120,0,25)
ToggleButton.Position = UDim2.new(0,10,0,28)
ToggleButton.Text = "Boost OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleButton.TextColor3 = Color3.new(1,1,1)

local function enableBoost()

	lighting.GlobalShadows = false
	lighting.FogEnd = 100000

	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("ParticleEmitter") or
		   v:IsA("Trail") or
		   v:IsA("Explosion") then
			v.Enabled = false
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 0.2
		end
	end
end

local function disableBoost()
	lighting.GlobalShadows = true
end

ToggleButton.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	
	if boostEnabled then
		ToggleButton.Text = "Boost ON"
		enableBoost()
	else
		ToggleButton.Text = "Boost OFF"
		disableBoost()
	end
end)
