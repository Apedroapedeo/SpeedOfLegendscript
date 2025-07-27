--[[
Script para Speed Legends Roblox
Desenvolvido com ajuda do ChatGPT
github.com/Apedroapedeo/SpeedOfLegendscript
]]

-- Serviços
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- UI Principal
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedScriptUI"
ScreenGui.ResetOnSpawn = false

-- Botão Minimizar
local reopenBtn = Instance.new("TextButton", ScreenGui)
reopenBtn.Size = UDim2.new(0, 100, 0, 30)
reopenBtn.Position = UDim2.new(0, 10, 0, 10)
reopenBtn.Text = "Abrir Menu"
reopenBtn.Visible = false
reopenBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
reopenBtn.TextColor3 = Color3.new(1, 1, 1)

-- Menu Principal
local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local uiList = Instance.new("UIListLayout", frame)
uiList.Padding = UDim.new(0, 6)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder = Enum.SortOrder.LayoutOrder

-- Função de botão
local function createButton(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 280, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
end

-- Minimizar
createButton("Minimizar", function()
	frame.Visible = false
	reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	reopenBtn.Visible = false
end)

-- Auto Farm
local farming = false
createButton("Ativar Auto Farm", function()
	farming = not farming
	if farming then
		createButton("Auto Farm Ativado", function() end).TextColor3 = Color3.fromRGB(0, 255, 0)
		task.spawn(function()
			while farming do
				task.wait(0.2)
				char = player.Character or player.CharacterAdded:Wait()
				hrp = char:WaitForChild("HumanoidRootPart")
				-- Orbs
				for _, orb in pairs(workspace:WaitForChild("Orbs"):GetChildren()) do
					if orb:IsA("Model") and orb:FindFirstChild("TouchInterest") then
						firetouchinterest(hrp, orb, 0)
						firetouchinterest(hrp, orb, 1)
					end
				end
				-- Argolas
				for _, ring in pairs(workspace:WaitForChild("Hoops"):GetChildren()) do
					if ring:IsA("Part") and ring:FindFirstChild("TouchInterest") then
						firetouchinterest(hrp, ring, 0)
						firetouchinterest(hrp, ring, 1)
					end
				end
			end
		end)
	end
end)

-- Auto Race
local raceEnabled = false
createButton("Auto Race", function()
	raceEnabled = not raceEnabled
	task.spawn(function()
		while raceEnabled do
			task.wait(2)
			local racePad = workspace:FindFirstChild("RacePads")
			if racePad then
				for _, pad in pairs(racePad:GetChildren()) do
					if pad:IsA("Part") then
						firetouchinterest(hrp, pad, 0)
						firetouchinterest(hrp, pad, 1)
					end
				end
			end
		end
	end)
end)

-- Infinite Jump
local infJumpEnabled = false
createButton("Ativar Infinite Jump", function()
	infJumpEnabled = not infJumpEnabled
end)

UIS.JumpRequest:Connect(function()
	if infJumpEnabled then
		char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

-- Jump Power
createButton("Setar Jump Power 150", function()
	char:FindFirstChildOfClass("Humanoid").JumpPower = 150
end)

-- NoClip
local noclip = false
createButton("Ativar NoClip", function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Lock Posição
local lock = false
local savedPos = nil
createButton("Travar Posição", function()
	lock = not lock
	if lock then
		savedPos = hrp.Position
	end
end)

RunService.Heartbeat:Connect(function()
	if lock and savedPos then
		hrp.Velocity = Vector3.new(0, 0, 0)
		hrp.CFrame = CFrame.new(savedPos)
	end
end)

-- Anti-AFK
player.Idled:Connect(function()
	VirtualUser = game:GetService("VirtualUser")
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
