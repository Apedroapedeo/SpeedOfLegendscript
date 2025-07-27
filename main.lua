-- Carregar Bracket GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Bracket-V2/main/src.lua"))()

-- Criar Janela
local Window, MainGUI = Library:CreateWindow("Speed Legends Hub")

-- Tabs
local AutoTab = Window:CreateTab("Auto")
local PlayerTab = Window:CreateTab("Player")
local MiscTab = Window:CreateTab("Misc")

-- Auto Farm Variables
local orbTypes = {
    { action = "collectOrb", orbType = "Red Orb", place = "City" },
    { action = "collectOrb", orbType = "Gem", place = "City" }
}

local orbEvent = game:GetService("ReplicatedStorage").rEvents.orbEvent
local rebirthEvent = game:GetService("ReplicatedStorage").rEvents.rebirthEvent

-- Função para obter dados do orb
function getOrb(orbType)
    for _, v in pairs(orbTypes) do
        if v.orbType == orbType then
            return v.action, v.orbType, v.place
        end
    end
end

-- Auto Farm
local farming = false
AutoTab:CreateToggle("Ativar Auto Farm", function(state)
    farming = state
    while farming do
        for _ = 1, 10 do
            orbEvent:FireServer(getOrb("Red Orb"))
        end
        orbEvent:FireServer(getOrb("Gem"))
        wait()
    end
end)

-- Auto Rebirth
local autoRebirth = false
AutoTab:CreateToggle("Ativar Auto Rebirth", function(state)
    autoRebirth = state
    while autoRebirth do
        rebirthEvent:FireServer("rebirthRequest")
        wait(2)
    end
end)

-- Auto Hoop (teleporta os hoops para o jogador)
local autoHoop = false
AutoTab:CreateToggle("Auto Coleta de Argolas", function(state)
    autoHoop = state
    while autoHoop do
        for _, v in pairs(game:GetService("Workspace").Hoops:GetChildren()) do
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
        wait(1)
    end
end)

-- Infinite Jump
local infJump = false
PlayerTab:CreateToggle("Infinite Jump", function(state)
    infJump = state
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Jump Power Customizável
local jumpEnabled = false
local customJump = 50
PlayerTab:CreateToggle("Ativar Jump Power", function(state)
    jumpEnabled = state
end)
PlayerTab:CreateSlider("Força do Pulo", 50, 300, 50, function(value)
    customJump = value
    if jumpEnabled then
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = customJump
    end
end)

-- NoClip
local noclip = false
MiscTab:CreateToggle("Ativar NoClip", function(state)
    noclip = state
end)
game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Trava de Posição
local trava = false
local pos = nil
MiscTab:CreateToggle("Travar Posição", function(state)
    trava = state
    if state then
        pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    if trava and pos then
        game.Players.LocalPlayer.Character:MoveTo(pos)
    end
end)

-- Auto Race
local autoRace = false
MiscTab:CreateToggle("Auto Entrar em Corrida", function(state)
    autoRace = state
    while autoRace do
        local Event = game:GetService("ReplicatedStorage").rEvents.joinRace
        Event:FireServer()
        wait(1)
    end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Minimizar GUI
local isMinimized = false
local toggleBtn = MainGUI:CreateButton("⏬ Minimizar", function()
    isMinimized = not isMinimized
    for _, v in pairs(Window.Tabs) do
        if v.Frame then
            v.Frame.Visible = not isMinimized
        end
    end
    toggleBtn:SetText(isMinimized and "⏫ Abrir" or "⏬ Minimizar")
end)
