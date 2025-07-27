-- Script completo para Speed Legends - por ChatGPT + Pedro Oliveira
-- GitHub: https://github.com/Apedroapedeo/SpeedOfLegendscript

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Bracket-V2/main/src.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Estado global
local options = {
    autoFarm = false,
    autoRace = false,
    rebirth = false,
    infiniteJump = false,
    lockPosition = false,
    jumpPower = 50
}

-- Janela principal
local Window, MainGUI = Library:CreateWindow("Speed Legends Hub")
local FarmTab = Window:CreateTab("Auto")
local PlayerTab = Window:CreateTab("Player")
local MiscTab = Window:CreateTab("Misc")

-- Grupo: Auto Farm
local FarmBox = FarmTab:CreateGroupbox("Auto Farm", "Left")
FarmBox:CreateToggle("Ativar Auto Farm", function(bool)
    options.autoFarm = bool
end)
FarmBox:CreateToggle("Auto Rebirth", function(bool)
    options.rebirth = bool
end)
FarmBox:CreateToggle("Auto Race", function(bool)
    options.autoRace = bool
end)

-- Grupo: Jogador
local PlayerBox = PlayerTab:CreateGroupbox("Movimento", "Left")
PlayerBox:CreateToggle("Infinite Jump", function(bool)
    options.infiniteJump = bool
end)
PlayerBox:CreateSlider("Jump Power", 50, 300, function(value)
    options.jumpPower = value
    LocalPlayer.Character.Humanoid.JumpPower = value
end)
PlayerBox:CreateToggle("Travar Posição", function(bool)
    options.lockPosition = bool
end)

-- NoClip
local noclip = false
MiscTab:CreateGroupbox("Utilitários", "Left"):CreateToggle("NoClip", function(bool)
    noclip = bool
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Minimizar GUI
local function createMinimizeButton()
    local button = Instance.new("TextButton")
    button.Text = "⏷"
    button.Size = UDim2.new(0, 25, 0, 25)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1,1,1)
    button.Parent = MainGUI

    button.MouseButton1Click:Connect(function()
        MainGUI.Enabled = not MainGUI.Enabled
    end)
end
createMinimizeButton()

-- Loop principal
spawn(function()
    while wait(0.2) do
        -- Auto Farm
        if options.autoFarm then
            local orbEvent = ReplicatedStorage.rEvents.orbEvent
            orbEvent:FireServer("collectOrb", "Red Orb", "City")
            orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
            orbEvent:FireServer("collectOrb", "Blue Orb", "City")

            for _, hoop in pairs(Workspace.Hoops:GetChildren()) do
                hoop.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end

        -- Auto Rebirth
        if options.rebirth then
            ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
        end

        -- Auto Race
        if options.autoRace then
            ReplicatedStorage.rEvents.raceEvent:FireServer("joinRace")
        end

        -- Trava Posição
        if options.lockPosition and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = true
            end
        elseif LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if options.infiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- NoClip loop
game:GetService("RunService").Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

print("Speed Legends Script carregado com sucesso!")

