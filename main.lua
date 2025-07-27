-- Speed Legends Script (por ChatGPT) 🌀
-- GitHub: https://github.com/Apedroapedeo/SpeedOfLegendscript

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 4)

function createToggle(text, callback)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 5, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.Text = text
	local state = false
	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    game.VirtualInputManager:SendKeyEvent(true, "W", false, game)
end)

-- Auto Farm Orbs
local orbsFarm = false
createToggle("Auto Orbs", function(state)
	orbsFarm = state
end)

-- Auto Farm Rings
local ringsFarm = false
createToggle("Auto Rings", function(state)
	ringsFarm = state
end)

-- Infinite Jump
local infJump = false
createToggle("Infinite Jump", function(state)
	infJump = state
end)

-- Jump Power
local jumpPowerActive = false
createToggle("Jump Power (150)", function(state)
	jumpPowerActive = state
	if state then
		Character:FindFirstChildOfClass("Humanoid").JumpPower = 150
	else
		Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
	end
end)

-- Lock Posição
local lockPosition = false
createToggle("Lock Posição", function(state)
	lockPosition = state
end)

-- NoClip
local noclip = false
createToggle("NoClip", function(state)
	noclip = state
end)

-- Minimizar
local minimizeButton = Instance.new("TextButton", Frame)
minimizeButton.Size = UDim2.new(1, -10, 0, 30)
minimizeButton.Text = "Minimizar"
minimizeButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

-- Botão cinza fixo para reabrir GUI
local reopenButton = Instance.new("TextButton", ScreenGui)
reopenButton.Size = UDim2.new(0, 80, 0, 30)
reopenButton.Position = UDim2.new(0, 10, 0.5, 0)
reopenButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
reopenButton.Text = "Abrir"
reopenButton.TextColor3 = Color3.new(1, 1, 1)
reopenButton.TextSize = 16
reopenButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
end)

-- Loop Principal
RunService.RenderStepped:Connect(function()
	if orbsFarm then
		for _, orb in pairs(workspace:GetDescendants()) do
			if orb.Name == "Orb" and orb:IsA("Part") then
				orb.CFrame = HumanoidRootPart.CFrame
			end
		end
	end
	if ringsFarm then
		for _, ring in pairs(workspace:GetDescendants()) do
			if ring.Name == "Ring" and ring:IsA("Part") then
				ring.CFrame = HumanoidRootPart.CFrame
			end
		end
	end
	if lockPosition then
		Character:MoveTo(HumanoidRootPart.Position)
	end
	if noclip then
		for _, v in pairs(Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Infinite Jump Loop
UIS.JumpRequest:Connect(function()
	if infJump then
		Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)
