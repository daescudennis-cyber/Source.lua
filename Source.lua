-- Denis by lajx

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local speed = 16 -- Velocidad normal
local minSpeed = 8
local maxSpeed = 100
local speedStep = 4

local function setSpeed()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end

player.CharacterAdded:Connect(function()
	wait(1)
	setSpeed()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.E then
		speed = math.clamp(speed + speedStep, minSpeed, maxSpeed)
		setSpeed()
		print("Denis by lajx - Velocidad aumentada a: "..speed)
	end
	
	if input.KeyCode == Enum.KeyCode.Q then
		speed = math.clamp(speed - speedStep, minSpeed, maxSpeed)
		setSpeed()
		print("Denis by lajx - Velocidad reducida a: "..speed)
	end
end)
