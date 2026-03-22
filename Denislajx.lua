-- DENIS HELPER V2 + KEY SYSTEM PRO

local CoreGui = game:GetService("CoreGui")
local camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local FILE_NAME = "DenisConfig.json"

-- =========================
-- KEY SYSTEM PRO
-- =========================
local correctKey = "KEY-786013"
local attempts = 0
local maxAttempts = 3
local unlocked = false
local realText = ""

local keyGui = Instance.new("ScreenGui", game.CoreGui)
keyGui.Name = "DenisKeySystem"

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0.5, -130, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", frame)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(170,0,255)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "DENIS KEY SYSTEM"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200,100,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8,0,0,35)
box.Position = UDim2.new(0.1,0,0.4,0)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.ClearTextOnFocus = false
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box)

-- Oculta la escritura y guarda texto real
box:GetPropertyChangedSignal("Text"):Connect(function()
    local new = box.Text
    if #new > #realText then
        realText = realText .. new:sub(-1)
    else
        realText = realText:sub(1, #new)
    end
    box.Text = string.rep("*", #realText)
end)

local check = Instance.new("TextButton", frame)
check.Size = UDim2.new(0.6,0,0,35)
check.Position = UDim2.new(0.2,0,0.7,0)
check.Text = "UNLOCK"
check.BackgroundColor3 = Color3.fromRGB(80,0,120)
check.TextColor3 = Color3.new(1,1,1)
check.Font = Enum.Font.GothamBold
Instance.new("UICorner", check)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0.88,0)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255,80,80)
status.Font = Enum.Font.Gotham

-- Animación shake
local function shake()
    for i = 1,5 do
        frame.Position += UDim2.new(0,5,0,0)
        task.wait(0.02)
        frame.Position -= UDim2.new(0,10,0,0)
        task.wait(0.02)
        frame.Position += UDim2.new(0,5,0,0)
    end
end

check.MouseButton1Click:Connect(function()
    local entered = realText:upper():gsub("%s","")
    local correctKeyClean = correctKey:upper():gsub("%s","")

    if entered == correctKeyClean then
        status.TextColor3 = Color3.fromRGB(100,255,100)
        status.Text = "ACCESS GRANTED"
        task.wait(0.5)
        unlocked = true
        keyGui:Destroy()
    else
        attempts += 1
        status.Text = "WRONG KEY ("..attempts.."/"..maxAttempts..")"
        shake()
        if attempts >= maxAttempts then
            status.Text = "LOCKED"
            task.wait(1)
            player:Kick("Too many wrong attempts")
        end
    end
end)

repeat task.wait() until unlocked

-- =========================
-- DENIS HELPER V2 GUI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "DenisHelperV2"
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 260)
main.Position = UDim2.new(0.5, -100, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main)
local stroke2 = Instance.new("UIStroke", main)
stroke2.Color = Color3.fromRGB(170,0,255)
stroke2.Thickness = 2

-- Title
local title2 = Instance.new("TextLabel")
title2.Size = UDim2.new(1,0,0,40)
title2.BackgroundTransparency = 1
title2.Text = "DENIS HELPER V2"
title2.Font = Enum.Font.GothamBold
title2.TextSize = 16
title2.TextColor3 = Color3.fromRGB(200,100,255)
title2.Parent = main

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = main
Instance.new("UICorner", minimize)

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(main:GetChildren()) do
        if v:IsA("TextButton") and v ~= minimize then
            v.Visible = not minimized
        end
    end
    main.Size = minimized and UDim2.new(0,200,0,45) or UDim2.new(0,200,0,260)
end)

-- Button creator
local function button(txt,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.85,0,0,30)
    b.Position = UDim2.new(0.075,0,y,0)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50,0,80)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local fovBtn = button("FOV: OFF",0.2)
local galaxyBtn = button("GALAXY: OFF",0.35)
local antiBatBtn = button("ANTI BAT: OFF",0.5)
local antiFlingBtn = button("ANTI FLING: OFF",0.65)
local saveBtn = button("SAVE CONFIG",0.82)

-- States
local fov, galaxy, antiBat, antiFling = false,false,false,false
local detectDistance = 15

local function toggle(btn,state,name)
    btn.Text = name..": "..(state and "ON" or "OFF")
    btn.BackgroundColor3 = state and Color3.fromRGB(170,0,255) or Color3.fromRGB(50,0,80)
end

-- FOV
fovBtn.MouseButton1Click:Connect(function()
    fov = not fov
    camera.FieldOfView = fov and 100 or 70
    toggle(fovBtn,fov,"FOV")
end)

-- Galaxy
galaxyBtn.MouseButton1Click:Connect(function()
    galaxy = not galaxy
    toggle(galaxyBtn,galaxy,"GALAXY")
    if galaxy then
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    end
end)

-- Anti Bat
antiBatBtn.MouseButton1Click:Connect(function()
    antiBat = not antiBat
    toggle(antiBatBtn,antiBat,"ANTI BAT")
end)

-- Anti Fling
antiFlingBtn.MouseButton1Click:Connect(function()
    antiFling = not antiFling
    toggle(antiFlingBtn,antiFling,"ANTI FLING")
end)

-- Anti Fling loop
RunService.Stepped:Connect(function()
    if antiFling and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Anti Bat loop
RunService.Heartbeat:Connect(function()
    if not antiBat then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < detectDistance then
                root.Velocity = Vector3.new(0,50,0)
            end
        end
    end
end)

-- Save
saveBtn.MouseButton1Click:Connect(function()
    if writefile then
        writefile(FILE_NAME, HttpService:JSONEncode({
            fov=fov,
            galaxy=galaxy,
            antiBat=antiBat,
            antiFling=antiFling
        }))
        saveBtn.Text = "SAVED!"
        task.wait(1)
        saveBtn.Text = "SAVE CONFIG"
    end
end)
