-- Speed Legends Script (com GUI e funções completas)
-- Desenvolvido por Pedro com ajuda do ChatGPT

-- Carrega a Bracket V2 GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Bracket-V2/main/src.lua"))()

-- Janela Principal
local Window, MainGUI = Library:CreateWindow("Speed Legends | Hub")

-- Tabs
local FarmTab = Window:CreateTab("Auto Farm")
local UtilityTab = Window:CreateTab("Utilitários")

-- Grupos
local FarmGroup = FarmTab:CreateGroupbox("Farm", "Left")
local UtilityGroup = UtilityTab:CreateGroupbox("Player", "Left")

-- Variáveis de Controle
local farming = false
local rebirthing = false
local infJump = false
local noclipEnabled = false

-- Auto Farm XP (Orbs e Argolas)
FarmGroup:CreateToggle("Auto Farm XP", function(state)
    farming = state
    while farming do
        task.wait(0.2)

        -- Coleta orb via evento remoto
        local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
        Event:FireServer("collectOrb", "Red Orb", "City")
        Event:FireServer("collectOrb", "Yellow Orb", "City")
        Event:FireServer("collectOrb", "Blue Orb", "City")

        -- Move as argolas até o jogador
        for _, ring in pairs(workspace:WaitForChild("Hoops"):GetChildren()) do
            if ring:IsA("Part") then
                ring.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Auto Rebirth
FarmGroup:CreateToggle("Auto Rebirth", function(state)
    rebirthing = state
    while rebirthing do
        task.wait(2)
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
    end
end)

-- Infinite Jump
UtilityGroup:CreateToggle("Salto Infinito", function(state)
    infJump = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Ajustar poder de pulo
UtilityGroup:CreateSlider("Poder do Pulo", {
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(value)
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = value
        end
    end
})

-- NoClip (ativo enquanto pressionar tecla N)
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UtilityGroup:CreateToggle("NoClip (ativar colisão OFF)", function(state)
    noclipEnabled = state
end)

-- Anti-AFK
UtilityGroup:CreateButton("Ativar Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
