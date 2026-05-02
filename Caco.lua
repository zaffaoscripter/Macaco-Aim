
-- MACACOS DE AIM - Interface Melhorada
-- by Felcando

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--  CONFIGS 
local Config = {
    AimbotEnabled = true,
    ESPEnabled = true,
    TeamCheck = true,
    AimbotFOV = 60,
    MaxAimbotDistance = 200,
    AimPartName = "Head",
    AimSpeed = 1,
    AimbotKey = Enum.KeyCode.E,
    PanelVisible = true
}

--  PLAYERS IGNORADOS 
local IgnoredPlayers = {
    ["LuvDaikii"] = true,
    ["SaikiiDev"] = true
}

--  FOV CIRCLE 
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Radius = Config.AimbotFOV
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end)

-- GUI 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MacacosDeAim"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 580)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 32)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Visible = Config.PanelVisible
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(80, 220, 255)
stroke.Thickness = 1.8

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🐒 MACACOS DE AIM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 26

local monkeyBtn = Instance.new("TextButton")
monkeyBtn.Size = UDim2.new(0, 70, 0, 70)
monkeyBtn.Position = UDim2.new(1, -90, 0.5, -35)
monkeyBtn.BackgroundTransparency = 0.3
monkeyBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
monkeyBtn.Text = "🐒"
monkeyBtn.TextSize = 45
monkeyBtn.Font = Enum.Font.GothamBold
monkeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
monkeyBtn.Parent = screenGui

Instance.new("UICorner", monkeyBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", monkeyBtn)
btnStroke.Color = Color3.fromRGB(0, 255, 200)
btnStroke.Thickness = 2.5

local function togglePanel()
    Config.PanelVisible = not Config.PanelVisible
    mainFrame.Visible = Config.PanelVisible
    FOVCircle.Visible = Config.AimbotEnabled and Config.PanelVisible
end

monkeyBtn.MouseButton1Click:Connect(togglePanel)

-- Switches
local yOffset = 80
local function CreateSwitch(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 45)
    frame.Position = UDim2.new(0, 20, 0, yOffset)
    frame.BackgroundTransparency = 1
    frame.Parent = mainFrame

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", frame)
    switch.Size = UDim2.new(0, 62, 0, 32)
    switch.Position = UDim2.new(1, -80, 0.5, -16)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 28, 0, 28)
    knob.Position = UDim2.new(default and 1 or 0, default and -30 or 2, 0.5, -14)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = default

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            if enabled then
                switch.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
                knob:TweenPosition(UDim2.new(1, -30, 0.5, -14), "Out", "Quad", 0.25, true)
            else
                switch.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                knob:TweenPosition(UDim2.new(0, 2, 0.5, -14), "Out", "Quad", 0.25, true)
            end
            callback(enabled)
        end
    end)

    yOffset += 55
end

CreateSwitch("Aimbot", Config.AimbotEnabled, function(v) Config.AimbotEnabled = v; FOVCircle.Visible = v and Config.PanelVisible end)
CreateSwitch("ESP (Nome)", Config.ESPEnabled, function(v) Config.ESPEnabled = v end)
CreateSwitch("Team Check", Config.TeamCheck, function(v) Config.TeamCheck = v end)

-- Inputs
local function CreateInput(y, text, defaultValue, isFOV)
    local label = Instance.new("TextLabel", mainFrame)
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.Position = UDim2.new(0, 25, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", mainFrame)
    box.Size = UDim2.new(0, 90, 0, 32)
    box.Position = UDim2.new(1, -120, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 15
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            if isFOV then
                Config.AimbotFOV = math.clamp(num, 20, 800)
                FOVCircle.Radius = Config.AimbotFOV
            else
                Config.MaxAimbotDistance = math.clamp(num, 50, 5000)
            end
            box.Text = tostring(isFOV and Config.AimbotFOV or Config.MaxAimbotDistance)
        end
    end)
end

CreateInput(280, "FOV", Config.AimbotFOV, true)
CreateInput(325, "Distância Máx", Config.MaxAimbotDistance, false)

-- Parte do Corpo
local partLabel = Instance.new("TextLabel", mainFrame)
partLabel.Size = UDim2.new(0.5, 0, 0, 30)
partLabel.Position = UDim2.new(0, 25, 0, 370)
partLabel.BackgroundTransparency = 1
partLabel.Text = "Parte do Corpo:"
partLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
partLabel.Font = Enum.Font.Gotham
partLabel.TextSize = 15
partLabel.TextXAlignment = Enum.TextXAlignment.Left

local partBox = Instance.new("TextBox", mainFrame)
partBox.Size = UDim2.new(0, 120, 0, 32)
partBox.Position = UDim2.new(1, -150, 0, 370)
partBox.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
partBox.Text = Config.AimPartName
partBox.TextColor3 = Color3.fromRGB(255, 255, 255)
partBox.Font = Enum.Font.Gotham
partBox.TextSize = 15
Instance.new("UICorner", partBox).CornerRadius = UDim.new(0, 8)

partBox.FocusLost:Connect(function()
    local valid = {Head = true, Torso = true, HumanoidRootPart = true, UpperTorso = true}
    if valid[partBox.Text] then
        Config.AimPartName = partBox.Text
    else
        partBox.Text = Config.AimPartName
    end
end)

--  ESP (Apenas Nome) 
local NameTags = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0,0,0)
    nameTag.Font = 2
    nameTag.Color = Color3.fromRGB(0, 255, 100)
    nameTag.Visible = false
    NameTags[player] = nameTag
end

for _, plr in pairs(Players:GetPlayers()) do createESP(plr) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(plr)
    if NameTags[plr] then
        NameTags[plr]:Remove()
        NameTags[plr] = nil
    end
end)

--  FUNÇÕES 
local function isEnemy(player)
    if not Config.TeamCheck then return true end
    if not player.Team or not LocalPlayer.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

local function getClosestTarget()
    local closestDist = math.huge
    local closestPlayer = nil
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IgnoredPlayers[player.Name] then
            local char = player.Character
            local part = char and char:FindFirstChild(Config.AimPartName)
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if part and hum and hum.Health > 0 and (not Config.TeamCheck or isEnemy(player)) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local pos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (pos2D - mousePos).Magnitude
                    local distance3D = (Camera.CFrame.Position - part.Position).Magnitude

                    if dist < Config.AimbotFOV and dist < closestDist and distance3D <= Config.MaxAimbotDistance then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

--  AIMBOT 
RunService.RenderStepped:Connect(function()
    if not Config.AimbotEnabled then return end
    if not UserInputService:IsKeyDown(Config.AimbotKey) then return end

    local target = getClosestTarget()
    if target and target.Character then
        local part = target.Character:FindFirstChild(Config.AimPartName)
        if part then
            local camPos = Camera.CFrame.Position
            local direction = (part.Position - camPos).Unit
            local targetCF = CFrame.new(camPos, camPos + direction)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Config.AimSpeed)
        end
    end
end)

-- ====================== ESP LOOP (Só Nome) ======================
RunService.RenderStepped:Connect(function()
    for player, nameTag in pairs(NameTags) do
        local char = player.Character
        if Config.ESPEnabled and char and char:FindFirstChild("Head") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and (not Config.TeamCheck or isEnemy(player)) then
                local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                
                nameTag.Text = player.Name
                nameTag.Position = Vector2.new(headPos.X, headPos.Y - 20)
                nameTag.Visible = true
                continue
            end
        end
        nameTag.Visible = false
    end
end)

print("🐒 MACACOS DE AIM 
