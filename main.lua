-- Speed of Legend AutoFarm + AutoRace + Configuração

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações
local config = {
    autoFarmEnabled = false,
    autoRaceEnabled = false,
    infiniteJumpEnabled = false,
    noclipEnabled = false,
    antiAFKEnabled = false,
    jumpPower = 50,
    clipSpeed = 1,
}

-- Funções

local function noclip()
    if config.noclipEnabled then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function infiniteJump()
    if config.infiniteJumpEnabled then
        UserInputService.JumpRequest:Connect(function()
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

local function antiAFK()
    if config.antiAFKEnabled then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
end

local function autoFarm()
    while config.autoFarmEnabled do
        -- Exemplo de farm simples: movimentar-se e coletar itens
        -- A lógica exata depende do jogo e precisa ser adaptada
        wait(0.1)
        -- Coloque sua lógica específica de farm aqui
    end
end

local function autoRace()
    while config.autoRaceEnabled do
        -- Exemplo simplificado de corrida automática
        -- Precisa ser adaptado para o jogo real
        wait(0.1)
        -- Coloque sua lógica específica de corrida aqui
    end
end

-- Loop principal para ativar/desativar noclip
RunService.Stepped:Connect(function()
    noclip()
end)

-- Inicializa o antiAFK e infinite jump se habilitados
antiAFK()
infiniteJump()

-- GUI Simples para controle

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SpeedOfLegendGUI"

local function createToggle(text, initialValue, position, callback)
    local button = Instance.new("TextButton", ScreenGui)
    button.Size = UDim2.new(0, 200, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    button.BorderColor3 = Color3.new(1,1,1)
    button.TextColor3 = Color3.new(1,1,1)
    button.Text = text .. ": " .. (initialValue and "ON" or "OFF")
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18

    button.MouseButton1Click:Connect(function()
        initialValue = not initialValue
        button.Text = text .. ": " .. (initialValue and "ON" or "OFF")
        callback(initialValue)
    end)
end

createToggle("Auto Farm", config.autoFarmEnabled, UDim2.new(0,10,0,10), function(val)
    config.autoFarmEnabled = val
    if val then
        spawn(autoFarm)
    end
end)

createToggle("Auto Race", config.autoRaceEnabled, UDim2.new(0,10,0,50), function(val)
    config.autoRaceEnabled = val
    if val then
        spawn(autoRace)
    end
end)

createToggle("Infinite Jump", config.infiniteJumpEnabled, UDim2.new(0,10,0,90), function(val)
    config.infiniteJumpEnabled = val
end)

createToggle("NoClip", config.noclipEnabled, UDim2.new(0,10,0,130), function(val)
    config.noclipEnabled = val
end)

createToggle("Anti AFK", config.antiAFKEnabled, UDim2.new(0,10,0,170), function(val)
    config.antiAFKEnabled = val
    if val then
        antiAFK()
    end
end)

-- Você pode ajustar os valores de jump power e velocidade do clip aqui

Humanoid.JumpPower = config.jumpPower

print("Speed of Legend script carregado com sucesso.")
