
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- Flags
local flags = {
  autoOrbs = false,
  autoHoops = false,
  autoRace = false,
  infiniteJump = false,
  noClip = false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpeedLegendHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 360)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,30)
top.Position = UDim2.new(0,0,0,0)
top.BackgroundColor3 = Color3.fromRGB(20,20,20)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0.8,0,1,0)
title.BackgroundTransparency = 1
title.Text = "SpeedLegend Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0,10,0,0)

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,30,1,0)
minimize.Position = UDim2.new(1,-35,0,0)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(150,0,0)
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 20

local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.new(0,30,0,30)
reopen.Position = UDim2.new(0.3,0,0.3,0)
reopen.BackgroundColor3 = Color3.fromRGB(80,80,80)
reopen.Text = "+"
reopen.TextColor3 = Color3.new(1,1,1)
reopen.Visible = false

minimize.MouseButton1Click:Connect(function()
  main.Visible = false
  reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
  main.Visible = true
  reopen.Visible = false
end)

-- Create toggle
local function createToggle(name, y, flagKey)
  local label = Instance.new("TextLabel", main)
  label.Size = UDim2.new(0.6,0,0,30)
  label.Position = UDim2.new(0,10,0,y)
  label.Text = name
  label.TextColor3 = Color3.new(1,1,1)
  label.BackgroundTransparency = 1
  label.Font = Enum.Font.SourceSans
  label.TextSize = 16

  local btn = Instance.new("TextButton", main)
  btn.Size = UDim2.new(0,60,0,30)
  btn.Position = UDim2.new(1,-70,0,y)
  btn.Text = "OFF"
  btn.TextColor3 = Color3.new(1,1,1)
  btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
  btn.Font = Enum.Font.SourceSansBold
  btn.TextSize = 16
  btn.MouseButton1Click:Connect(function()
    flags[flagKey] = not flags[flagKey]
    btn.Text = flags[flagKey] and "ON" or "OFF"
    btn.BackgroundColor3 = flags[flagKey] and Color3.fromRGB(0,150,0) or Color3.fromRGB(50,50,50)
  end)
end

createToggle("Auto Orbs", 50, "autoOrbs")
createToggle("Auto Hoops", 90, "autoHoops")
createToggle("Auto Race", 130, "autoRace")
createToggle("Infinite Jump", 170, "infiniteJump")
createToggle("NoClip (N)", 210, "noClip")

-- Slider JumpPower
local lblJP = Instance.new("TextLabel", main)
lblJP.Size = UDim2.new(0.6,0,0,30)
lblJP.Position = UDim2.new(0,10,0,260)
lblJP.Text = "Jump Power: 50"
lblJP.TextColor3 = Color3.new(1,1,1)
lblJP.BackgroundTransparency = 1
lblJP.Font = Enum.Font.SourceSans
lblJP.TextSize = 16

local tbJP = Instance.new("TextBox", main)
tbJP.Size = UDim2.new(0,60,0,30)
tbJP.Position = UDim2.new(1,-70,0,260)
tbJP.Text = "50"
tbJP.ClearTextOnFocus = false
tbJP.Font = Enum.Font.SourceSans
tbJP.TextSize = 16
tbJP.TextColor3 = Color3.new(1,1,1)
tbJP.BackgroundColor3 = Color3.fromRGB(50,50,50)

tbJP.FocusLost:Connect(function()
  local v = tonumber(tbJP.Text)
  if v and v >= 10 and v <= 200 then
    lblJP.Text = "Jump Power: "..v
    tbJP.Text = tostring(v)
  else
    tbJP.Text = lblJP.Text:match("%d+")
  end
end)

-- Functionality

-- Anti-AFK
for _,c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
LocalPlayer.Idled:Connect(function()
  local vu = game:GetService("VirtualUser")
  vu:Button2Down(Vector2.new())
  wait(1)
  vu:Button2Up(Vector2.new())
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
  if flags.infiniteJump then
    humanoid.JumpPower = tonumber(tbJP.Text) or 50
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end)

-- NoClip toggle via key N
UIS.InputBegan:Connect(function(inp)
  if inp.KeyCode == Enum.KeyCode.N then
    flags.noClip = not flags.noClip
  end
end)

RunService.Stepped:Connect(function()
  if flags.noClip then
    for _,p in pairs(Character:GetDescendants()) do
      if p:IsA("BasePart") then p.CanCollide = false end
    end
  end
end)

-- Auto Orbs
spawn(function()
  while true do
    if flags.autoOrbs then
      for _,o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name:lower():find("orb") then
          pcall(function()
            Root.CFrame = o.CFrame + Vector3.new(0,2,0)
          end)
          wait(0.3)
        end
      end
    end
    wait(0.5)
  end
end)

-- Auto Hoops
spawn(function()
  while true do
    if flags.autoHoops then
      for _,h in pairs(workspace:GetDescendants()) do
        if h.Name:lower():find("hoop") and h:IsA("TouchTransmitter") then
          firetouchinterest(Root, h.Parent, 0)
          wait(0.1)
          firetouchinterest(Root, h.Parent, 1)
        end
      end
    end
    wait(0.8)
  end
end)

-- Auto Race (se existir bandeira ou trigger RaceStart)
spawn(function()
  while true do
    if flags.autoRace then
      local start = workspace:FindFirstChild("RaceStart") or workspace:FindFirstChild("RaceFlag")
      if start and start:IsA("BasePart") then
        Root.CFrame = start.CFrame + Vector3.new(0,3,0)
      end
    end
    wait(2)
  end
end)

print("SpeedLegend Hub loaded.")
