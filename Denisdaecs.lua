local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local gui = Instance.new("ScreenGui")
gui.Name = "DenisBoost"
gui.Parent = game.CoreGui

-- FRAME PRINCIPAL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.ZIndex = 5

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Parent = frame
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(0, 200, 255)
frameStroke.Transparency = 0

-- TÍTULO
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DenisBoost"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 5

-- BOTÓN FPS BOOST
local boost = Instance.new("TextButton")
boost.Parent = frame
boost.Size = UDim2.new(0.8, 0, 0, 35)
boost.Position = UDim2.new(0.1, 0, 0.35, 0)
boost.Text = "FPS BOOSTER"
boost.TextScaled = true
boost.Font = Enum.Font.GothamBold
boost.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
boost.TextColor3 = Color3.fromRGB(255, 255, 255)
boost.ZIndex = 5
boost.BorderSizePixel = 0

local boostCorner = Instance.new("UICorner")
boostCorner.CornerRadius = UDim.new(0, 10)
boostCorner.Parent = boost

local boostStroke = Instance.new("UIStroke")
boostStroke.Parent = boost
boostStroke.Thickness = 1.5
boostStroke.Color = Color3.fromRGB(0, 200, 255)
boostStroke.Transparency = 0.3

-- TweenInfo para animaciones suaves
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Hover animado
boost.MouseEnter:Connect(function()
    TweenService:Create(boost, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
    TweenService:Create(boostStroke, tweenInfo, {Transparency = 0}):Play()
end)
boost.MouseLeave:Connect(function()
    TweenService:Create(boost, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
    TweenService:Create(boostStroke, tweenInfo, {Transparency = 0.3}):Play()
end)

-- FPS BOOST CLARO Y FLUIDO
local fpsActivated = false
local originalSettings = {}

boost.MouseButton1Click:Connect(function()
    local lighting = game:GetService("Lighting")
    if not fpsActivated then
        -- Guardar settings originales
        originalSettings.QualityLevel = settings().Rendering.QualityLevel
        originalSettings.Ambient = lighting.Ambient
        originalSettings.OutdoorAmbient = lighting.OutdoorAmbient
        originalSettings.Brightness = lighting.Brightness
        originalSettings.GlobalShadows = lighting.GlobalShadows

        -- Recorrer objetos para simplificar
        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end

        -- Configuración FPS Boost: más claro y fluido
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(200, 200, 200)
        lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        lighting.GlobalShadows = false

        boost.Text = "DESACTIVAR ⚡"
        fpsActivated = true
    else
        -- Restaurar settings originales
        settings().Rendering.QualityLevel = originalSettings.QualityLevel
        lighting.Ambient = originalSettings.Ambient
        lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        lighting.Brightness = originalSettings.Brightness
        lighting.GlobalShadows = originalSettings.GlobalShadows

        boost.Text = "FPS BOOSTER"
        fpsActivated = false
    end
end)

-- LINK DE DISCORD CLICABLE
local discordLabel = Instance.new("TextButton")
discordLabel.Parent = frame
discordLabel.Size = UDim2.new(1, 0, 0, 22)
discordLabel.Position = UDim2.new(0, 0, 1, -22)
discordLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
discordLabel.BackgroundTransparency = 0.2
discordLabel.Text = "https://discord.gg/dtVXZkUWJ"
discordLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.GothamBold
discordLabel.ZIndex = 5

discordLabel.MouseEnter:Connect(function()
    TweenService:Create(discordLabel, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
discordLabel.MouseLeave:Connect(function()
    TweenService:Create(discordLabel, tweenInfo, {TextColor3 = Color3.fromRGB(0, 200, 255)}):Play()
end)

-- Al hacer click, abrir link en navegador
discordLabel.MouseButton1Click:Connect(function()
    if syn and syn.request then
        -- Para exploits tipo Synapse
        syn.request({Url = "https://discord.gg/dtVXZkUWJ", Method = "GET"})
    else
        -- Para abrir link normalmente
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("Abre este link en tu navegador: https://discord.gg/dtVXZkUWJ")
        end)
    end
end)

-- ARRASTRE DEL HUB CON LIMITES
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
        frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)
