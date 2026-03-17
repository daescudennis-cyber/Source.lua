-- DenisBoost V2 con botón de minimizar
local player = game.Players.LocalPlayer
local lighting = game:GetService("Lighting")

local boostEnabled = false
local originalStates = {}
local isMinimized = false

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player.PlayerGui
ScreenGui.Name = "DenisBoostV2"

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,180,0,70)
Frame.Position = UDim2.new(0,10,0,10)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,8)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0,170,255)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, -25, 0, 20) -- Dejamos espacio para botón minimizar
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "DenisBoost V2"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,170,255)

-- Botón Toggle
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0,150,0,25)
ToggleButton.Position = UDim2.new(0,15,0,30)
ToggleButton.Text = "Boost OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleButton.TextColor3 = Color3.new(1,1,1)

-- Botón Minimizar/Expandir
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0,20,0,20)
MinimizeButton.Position = UDim2.new(1,-25,0,0)
MinimizeButton.Text = "_"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextScaled = true
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinimizeButton.TextColor3 = Color3.fromRGB(0,170,255)
MinimizeButton.AutoButtonColor = true

-- Guardar estados originales
local function saveOriginalStates()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
            originalStates[v] = v.Enabled
        elseif v:IsA("BasePart") then
            originalStates[v] = {v.Material, v.Reflectance}
        elseif v:IsA("Decal") or v:IsA("Texture") then
            originalStates[v] = v.Transparency
        end
    end
    originalStates.GlobalShadows = lighting.GlobalShadows
    originalStates.FogEnd = lighting.FogEnd
end

local function enableBoost()
    lighting.GlobalShadows = false
    lighting.FogEnd = 100000
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
            v.Enabled = false
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.2
        end
    end
end

local function disableBoost()
    for v, state in pairs(originalStates) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") then
            v.Enabled = state
        elseif v:IsA("BasePart") then
            v.Material = state[1]
            v.Reflectance = state[2]
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = state
        end
    end
    lighting.GlobalShadows = originalStates.GlobalShadows
    lighting.FogEnd = originalStates.FogEnd
end

saveOriginalStates()

-- Toggle Boost
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

-- Minimizar / Expandir
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ToggleButton.Visible = false
        Frame.Size = UDim2.new(0,180,0,25) -- Solo título visible
        MinimizeButton.Text = "◢"
    else
        ToggleButton.Visible = true
        Frame.Size = UDim2.new(0,180,0,70)
        MinimizeButton.Text = "_"
    end
end)

-- Drag & Drop
local dragging = false
local dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        Frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)
