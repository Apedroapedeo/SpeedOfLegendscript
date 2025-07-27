
--// Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedOfLegendHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "Speed Of Legend Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Minimize button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 24
MinimizeBtn.Parent = Title

local function toggleGui()
    if MainFrame.Visible then
        MainFrame.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame.Visible = true
        MinimizeBtn.Text = "-"
    end
end
MinimizeBtn.MouseButton1Click:Connect(toggleGui)

--// Toggles setup
local function createToggle(text, parent, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 80, 0, 30)
    toggle.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.Text = "Off"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 18
    toggle.Parent = frame

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggle.Text = "On"
            toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            toggle.Text = "Off"
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)

    return {
        Enabled = function() return enabled end,
        Set = function(value)
            enabled = value
            if value then
                toggle.Text = "On"
                toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            else
                toggle.Text = "Off"
                toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
    }
end

local autoFarmToggle = createToggle("Auto Farm", MainFrame, UDim2.new(0, 10, 0, 60))
local autoRaceToggle = createToggle("Auto Race", MainFrame, UDim2.new(0, 10, 0, 110))
local infiniteJumpToggle = createToggle("Infinite Jump", MainFrame, UDim2.new(0, 10, 0, 160))

-- Jump velocity slider
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -20, 0, 30)
sliderLabel.Position = UDim2.new(0, 10, 0, 210)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Jump Power: 50"
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 18
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = MainFrame

local slider = Instance.new("TextBox")
slider.Size = UDim2.new(0, 100, 0, 30)
slider.Position = UDim2.new(0, 10, 0, 240)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.TextColor3 = Color3.fromRGB(255, 255, 255)
slider.Font = Enum.Font.SourceSans
slider.TextSize = 18
slider.Text = "50"
slider.ClearTextOnFocus = false
slider.Parent = MainFrame

local jumpPower = 50
slider.FocusLost:Connect(function(enterPressed)
    local val = tonumber(slider.Text)
    if val and val >= 10 and val <= 200 then
        jumpPower = val
        sliderLabel.Text = "Jump Power: "..val
    else
        slider.Text = tostring(jumpPower)
    end
end)

--// Auto Farm Logic
local function autoFarm()
    while autoFarmToggle.Enabled() do
        -- Buscar objetos tipo "Orbe" ou "Circle" (substitua o nome pelo correto do jogo)
        for _, orb in pairs(workspace:GetChildren()) do
            if orb.Name == "Orbe" or orb.Name == "Circle" then
                if orb:IsA("BasePart") then
                    -- Teleporta o player para o orbe
                    RootPart.CFrame = orb.CFrame + Vector3.new(0, 3, 0)
                    wait(0.3)
                end
            end
        end
        wait(0.5)
    end
end

--// Auto Race Logic
local function autoRace()
    while autoRaceToggle.Enabled() do
        -- Supondo que existe um objeto "RaceStart" que inicia a corrida
        local raceStart = workspace:FindFirstChild("RaceStart")
        if raceStart then
            RootPart.CFrame = raceStart.CFrame + Vector3.new(0, 5, 0)
            wait(0.2)
            -- Aqui você pode adicionar um comando para iniciar a corrida,
            -- por exemplo: firing um evento remoto ou interagindo com o objeto
        end
        wait(5)
    end
end

--// Infinite Jump Logic
local canJump = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpToggle.Enabled() then
        Humanoid.JumpPower = jumpPower
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    else
        Humanoid.JumpPower = 50 -- Valor padrão (pode ajustar)
    end
end)


spawn(function()
    while true do
        if autoFarmToggle.Enabled() then
            autoFarm()
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if autoRaceToggle.Enabled() then
            autoRace()
        end
        wait(0.1)
    end
end)

