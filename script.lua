

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

--// Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FutureClient_UI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "FutureClient | Roblox Edition"
Title.TextColor3 = Color3.fromRGB(150, 150, 255)
Title.TextSize = 20

--// Tabs
local TabFolder = Instance.new("Folder")
TabFolder.Parent = MainFrame
TabFolder.Name = "Tabs"

local Tabs = {"ESP", "Movement", "Combat"}
local Buttons = {}
local CurrentTab = nil

for i, v in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = v.."Tab"
    TabButton.Parent = MainFrame
    TabButton.Position = UDim2.new(0, (i-1)*150, 0, 40)
    TabButton.Size = UDim2.new(0, 150, 0, 30)
    TabButton.Text = v
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    Buttons[v] = TabButton
end

--// Pages
local Pages = {}

for i, v in pairs(Tabs) do
    local Page = Instance.new("Frame")
    Page.Name = v.."Page"
    Page.Parent = MainFrame
    Page.Position = UDim2.new(0, 0, 0, 70)
    Page.Size = UDim2.new(1, 0, 1, -70)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Pages[v] = Page
end

local function OpenTab(tab)
    for i, v in pairs(Pages) do
        v.Visible = false
    end
    Pages[tab].Visible = true
end

for i, v in pairs(Buttons) do
    v.MouseButton1Click:Connect(function()
        OpenTab(i)
    end)
end

OpenTab("ESP")

--// ESP Code
local ESPEnabled = false

local function CreateESP(plr)
    if plr == player then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3, 6, 1)
    box.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Color3.fromRGB(255, 255, 255)
    box.Transparency = 0.5
    box.Parent = plr.Character
end

local function EnableESP()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            CreateESP(v)
        end
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if ESPEnabled then
            wait(1)
            CreateESP(plr)
        end
    end)
end)

local ESPButton = Instance.new("TextButton")
ESPButton.Parent = Pages["ESP"]
ESPButton.Size = UDim2.new(0, 200, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 10)
ESPButton.Text = "Toggle ESP [OFF]"
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Gotham
ESPButton.TextSize = 14

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        EnableESP()
        ESPButton.Text = "Toggle ESP [ON]"
        ESPButton.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    else
        ESPButton.Text = "Toggle ESP [OFF]"
        ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    end
end)

--// Movement Features
local FlyEnabled = false
local FlySpeed = 50

local function Fly()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bg = Instance.new("BodyGyro", hrp)
    local bv = Instance.new("BodyVelocity", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    while FlyEnabled do
        wait()
        bg.CFrame = workspace.CurrentCamera.CFrame
        local vel = Vector3.new()
        if mouse.W then vel = vel + (workspace.CurrentCamera.CFrame.LookVector * FlySpeed) end
        if mouse.S then vel = vel - (workspace.CurrentCamera.CFrame.LookVector * FlySpeed) end
        if mouse.A then vel = vel - (workspace.CurrentCamera.CFrame.RightVector * FlySpeed) end
        if mouse.D then vel = vel + (workspace.CurrentCamera.CFrame.RightVector * FlySpeed) end
        if mouse.Space then vel = vel + (workspace.CurrentCamera.CFrame.UpVector * FlySpeed) end
        if mouse.LeftControl then vel = vel - (workspace.CurrentCamera.CFrame.UpVector * FlySpeed) end
        bv.Velocity = vel
    end
    bg:Destroy()
    bv:Destroy()
end

local FlyButton = Instance.new("TextButton")
FlyButton.Parent = Pages["Movement"]
FlyButton.Size = UDim2.new(0, 200, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 10)
FlyButton.Text = "Toggle Fly [OFF]"
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.Gotham
FlyButton.TextSize = 14

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        Fly()
        FlyButton.Text = "Toggle Fly [ON]"
        FlyButton.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    else
        FlyButton.Text = "Toggle Fly [OFF]"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    end
end)

--// TO BE CONTINUED BELOW
--// Movement - WalkSpeed & JumpPower Changers

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = Pages["Movement"]
SpeedLabel.Position = UDim2.new(0, 10, 0, 60)
SpeedLabel.Size = UDim2.new(0, 150, 0, 30)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed:"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = Pages["Movement"]
SpeedBox.Position = UDim2.new(0, 10, 0, 90)
SpeedBox.Size = UDim2.new(0, 150, 0, 30)
SpeedBox.PlaceholderText = "Default: 16"
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14

SpeedBox.FocusLost:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = tonumber(SpeedBox.Text) or 16
    end
end)

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Parent = Pages["Movement"]
JumpLabel.Position = UDim2.new(0, 10, 0, 130)
JumpLabel.Size = UDim2.new(0, 150, 0, 30)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "JumpPower:"
JumpLabel.TextColor3 = Color3.fromRGB(255,255,255)
JumpLabel.Font = Enum.Font.Gotham
JumpLabel.TextSize = 14

local JumpBox = Instance.new("TextBox")
JumpBox.Parent = Pages["Movement"]
JumpBox.Position = UDim2.new(0, 10, 0, 160)
JumpBox.Size = UDim2.new(0, 150, 0, 30)
JumpBox.PlaceholderText = "Default: 50"
JumpBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
JumpBox.TextColor3 = Color3.fromRGB(255,255,255)
JumpBox.Font = Enum.Font.Gotham
JumpBox.TextSize = 14

JumpBox.FocusLost:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.JumpPower = tonumber(JumpBox.Text) or 50
    end
end)

--// Aimbot Feature

local AimbotEnabled = false
local AimbotFOV = 100

local AimbotCircle = Drawing.new("Circle")
AimbotCircle.Color = Color3.fromRGB(255,255,255)
AimbotCircle.Thickness = 1
AimbotCircle.NumSides = 100
AimbotCircle.Radius = AimbotFOV
AimbotCircle.Filled = false
AimbotCircle.Transparency = 1
AimbotCircle.Visible = false

game:GetService("RunService").RenderStepped:Connect(function()
    AimbotCircle.Position = Vector2.new(mouse.X, mouse.Y)
end)

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = AimbotFOV

    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local pos = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude

            if mag < shortestDistance then
                shortestDistance = mag
                closestPlayer = v
            end
        end
    end

    return closestPlayer
end

mouse.Button2Down:Connect(function()
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

local AimbotButton = Instance.new("TextButton")
AimbotButton.Parent = Pages["Combat"]
AimbotButton.Size = UDim2.new(0, 200, 0, 40)
AimbotButton.Position = UDim2.new(0, 10, 0, 10)
AimbotButton.Text = "Toggle Aimbot [OFF]"
AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
AimbotButton.TextColor3 = Color3.fromRGB(255,255,255)
AimbotButton.Font = Enum.Font.Gotham
AimbotButton.TextSize = 14

AimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotCircle.Visible = AimbotEnabled
    if AimbotEnabled then
        AimbotButton.Text = "Toggle Aimbot [ON]"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    else
        AimbotButton.Text = "Toggle Aimbot [OFF]"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    end
end)

--// ESP Color Customization

local ESPColorLabel = Instance.new("TextLabel")
ESPColorLabel.Parent = Pages["ESP"]
ESPColorLabel.Position = UDim2.new(0, 10, 0, 170)
ESPColorLabel.Size = UDim2.new(0, 150, 0, 30)
ESPColorLabel.BackgroundTransparency = 1
ESPColorLabel.Text = "ESP Color (RGB):"
ESPColorLabel.TextColor3 = Color3.fromRGB(255,255,255)
ESPColorLabel.Font = Enum.Font.Gotham
ESPColorLabel.TextSize = 14

local ESPColorBox = Instance.new("TextBox")
ESPColorBox.Parent = Pages["ESP"]
ESPColorBox.Position = UDim2.new(0, 10, 0, 200)
ESPColorBox.Size = UDim2.new(0, 150, 0, 30)
ESPColorBox.PlaceholderText = "Example: 255,0,0"
ESPColorBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
ESPColorBox.TextColor3 = Color3.fromRGB(255,255,255)
ESPColorBox.Font = Enum.Font.Gotham
ESPColorBox.TextSize = 14

ESPColorBox.FocusLost:Connect(function()
    local input = string.split(ESPColorBox.Text, ",")
    if #input == 3 then
        local r, g, b = tonumber(input[1]), tonumber(input[2]), tonumber(input[3])
        if r and g and b then
            for i,esp in pairs(DrawingESP) do
                esp.Color = Color3.fromRGB(r,g,b)
            end
        end
    end
end)

--// Aimbot FOV Changer

local AimbotFOVLabel = Instance.new("TextLabel")
AimbotFOVLabel.Parent = Pages["Combat"]
AimbotFOVLabel.Position = UDim2.new(0, 10, 0, 60)
AimbotFOVLabel.Size = UDim2.new(0, 150, 0, 30)
AimbotFOVLabel.BackgroundTransparency = 1
AimbotFOVLabel.Text = "Aimbot FOV:"
AimbotFOVLabel.TextColor3 = Color3.fromRGB(255,255,255)
AimbotFOVLabel.Font = Enum.Font.Gotham
AimbotFOVLabel.TextSize = 14

local AimbotFOVBox = Instance.new("TextBox")
AimbotFOVBox.Parent = Pages["Combat"]
AimbotFOVBox.Position = UDim2.new(0, 10, 0, 90)
AimbotFOVBox.Size = UDim2.new(0, 150, 0, 30)
AimbotFOVBox.PlaceholderText = "Default: 100"
AimbotFOVBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
AimbotFOVBox.TextColor3 = Color3.fromRGB(255,255,255)
AimbotFOVBox.Font = Enum.Font.Gotham
AimbotFOVBox.TextSize = 14

AimbotFOVBox.FocusLost:Connect(function()
    local newFOV = tonumber(AimbotFOVBox.Text)
    if newFOV then
        AimbotFOV = newFOV
        AimbotCircle.Radius = newFOV
    end
end)
