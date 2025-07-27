-- Carregar OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Criar Janela
local Window = OrionLib:MakeWindow({
    Name = "Speed Legends Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SpeedOfLegendConfig"
})

-- Variáveis
local AutoFarmEnabled = false
local AutoRebirth = false
local InfiniteJump = false
local JumpPowerEnabled = false
local JumpPowerValue = 100
local LockPosition = false
local SavedPosition
local NoclipEnabled = false
local AutoRace = false

-- Funções
local function StartAutoFarm()
    local orbEvent = game:GetService("ReplicatedStorage").rEvents.orbEvent
    local function getOrb(orbType)
        return "collectOrb", orbType, "City"
    end

    while AutoFarmEnabled do
        for i = 1, 15 do
            orbEvent:FireServer(getOrb("Red Orb"))
        end
        orbEvent:FireServer(getOrb("Gem"))
        -- Teleportar hoops
        for _, hoop in pairs(workspace.Hoops:GetChildren()) do
            if hoop:IsA("BasePart") then
                hoop.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
        task.wait(0.5)
    end
end

local function StartRebirth()
    local rebirthEvent = game:GetService("ReplicatedStorage").rEvents.rebirthEvent
    while AutoRebirth do
        rebirthEvent:FireServer("rebirthRequest")
        task.wait(1)
    end
end

local function ToggleNoclip()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide ~= not NoclipEnabled then
            part.CanCollide = not NoclipEnabled
        end
    end
end

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        ToggleNoclip()
    end
end)

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Trava de posição
game:GetService("RunService").RenderStepped:Connect(function()
    if LockPosition and SavedPosition then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = SavedPosition
        end
    end
end)

-- Auto Race simples
local function StartAutoRace()
    while AutoRace do
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:match("Race") and v:IsA("Model") then
                local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
        task.wait(10)
    end
end

-- Aba: Auto
local AutoTab = Window:MakeTab({
    Name = "Auto",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AutoTab:AddToggle({
    Name = "Auto Farm (Orbs + Hoops)",
    Default = false,
    Callback = function(v)
        AutoFarmEnabled = v
        if v then
            task.spawn(StartAutoFarm)
        end
    end
})

AutoTab:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(v)
        AutoRebirth = v
        if v then
            task.spawn(StartRebirth)
        end
    end
})

AutoTab:AddToggle({
    Name = "Auto Race",
    Default = false,
    Callback = function(v)
        AutoRace = v
        if v then
            task.spawn(StartAutoRace)
        end
    end
})

-- Aba: Player
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(v)
        InfiniteJump = v
    end
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 100,
    Increment = 1,
    ValueName = "Power",
    Callback = function(v)
        JumpPowerValue = v
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

PlayerTab:AddToggle({
    Name = "Ativar Jump Power",
    Default = false,
    Callback = function(v)
        JumpPowerEnabled = v
        if v then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
})

PlayerTab:AddButton({
    Name = "Salvar Posição",
    Callback = function()
        SavedPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
})

PlayerTab:AddToggle({
    Name = "Travar na Posição",
    Default = false,
    Callback = function(v)
        LockPosition = v
    end
})

-- Aba: Misc
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        NoclipEnabled = v
    end
})

MiscTab:AddButton({
    Name = "Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
})

OrionLib:Init()
