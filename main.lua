-Serviços do Roblox

local Players = game: GetService("Players")

local RunService = game: GetService("RunService")

local Workspace = game:GetService("Workspace")

local UserInput Service = game:GetService("UserInputService")

local Local Player = Players.LocalPlayer

local Character = LocalPlayer. Character or LocalPlayer. CharacterAdded:Wait()

local Humanoid RootPart = Character:WaitForChild("Humanoid RootPart")

local Humanoid = Character: WaitForChild("Humanoid")

--Variáveis de controle

local autoFarmOrbs=false

local autoFarmRings = false

local infiniteJump = false

local jump Power Enabled = false

Local jump PowerValue = 100

local lock Position = false

-Posição travada

local lockedCFrame = nil

-GUI

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

ScreenGui.Name = "Speed LegendHub"

local MainFrame = Instance.new("Frame", Screen Gui)

MainFrame.Size = UDim2.new(0, 300, 0, 400)

MainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)

MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

MainFrame.BorderSizePixel = 0

MainFrame.Visible = true

MainFrame.Active = true

MainFrame.Draggable=true

local UICorner = Instance.new("UICorner", MainFrame)

UICorner.Corner Radius = UDim.new(0, 8)

local UlList Layout = Instance.new("UlList Layout", MainFrame)

UlListLayout.Padding = UDim.new(0,5)

UlListLayout.FillDirection = Enum. FillDirection.Vertical

UlListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

UlListLayout.SortOrder = Enum.SortOrder.LayoutOrder

function createToggleButton(text, callback)

local button = Instance.new("TextButton")
    
button.Size = UDim2.new(0.9, 0, 0, 40)

button.Text = text

button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

button.TextColor3 = Color3.from RGB(255, 255, 255)

button.Font = Enum.Font.SourceSans Bold

button.TextSize = 16

button.Parent = MainFrame

local toggled = false

button. MouseButton1Click: Connect(function()

toggled = not toggled

callback(toggled)

button.BackgroundColor3 = toggled and Color 3.fromRGB(100, 200, 100) or Color 3.fromR end)

end

--Botões do menu

createToggleButton("Auto Farm-Orbs", function (state)

autoFarmOrbs = state end)

createToggleButton("Auto Farm - Argolas", function(state)

autoFarmRings = state end)

createToggleButton("Infinite Jump", function(state)

infinite Jump = state end)

createToggleButton("Jump Power+", function(state)

jumpPowerEnabled = state

if state then

Humanoid. Use
