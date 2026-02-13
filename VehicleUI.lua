--[[
    EV-inspired Vehicle UI (Model 3/Y V12 style)
    Luau script for Roblox executors (Codex Executor compatible).
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("Model3InspiredVehicleUI")
if existing then
    existing:Destroy()
end

local theme = {
    bg = Color3.fromRGB(14, 16, 20),
    panel = Color3.fromRGB(24, 28, 34),
    panelSoft = Color3.fromRGB(33, 38, 46),
    accent = Color3.fromRGB(64, 145, 255),
    success = Color3.fromRGB(68, 199, 109),
    warning = Color3.fromRGB(245, 193, 69),
    text = Color3.fromRGB(234, 237, 242),
    subText = Color3.fromRGB(150, 158, 171),
}

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function makeLabel(parent, text, size, pos, color, transparency, align)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = pos
    label.Text = text
    label.TextColor3 = color or theme.text
    label.TextTransparency = transparency or 0
    label.Font = Enum.Font.Gotham
    label.TextScaled = false
    label.TextSize = 16
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function makeButton(parent, text)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = theme.panelSoft
    button.TextColor3 = theme.text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.Text = text
    button.Size = UDim2.fromOffset(124, 38)
    addCorner(button, 12)
    button.Parent = parent
    return button
end

local ui = Instance.new("ScreenGui")
ui.Name = "Model3InspiredVehicleUI"
ui.ResetOnSpawn = false
ui.IgnoreGuiInset = true
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.Parent = playerGui

local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = theme.bg
root.BorderSizePixel = 0
root.Parent = ui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(1120, 640)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = theme.panel
main.BorderSizePixel = 0
main.Parent = root
addCorner(main, 22)

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.55
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.ZIndex = 0
shadow.Parent = main

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -28, 0, 88)
topBar.Position = UDim2.fromOffset(14, 12)
topBar.BackgroundColor3 = theme.panelSoft
topBar.BorderSizePixel = 0
topBar.Parent = main
addCorner(topBar, 16)

local speedTitle = makeLabel(topBar, "SPEED", UDim2.fromOffset(80, 20), UDim2.fromOffset(20, 12), theme.subText)
speedTitle.TextSize = 13
local speedValue = makeLabel(topBar, "0 mph", UDim2.fromOffset(160, 48), UDim2.fromOffset(18, 32), theme.text)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 36

local gearContainer = Instance.new("Frame")
gearContainer.BackgroundTransparency = 1
gearContainer.Size = UDim2.fromOffset(250, 60)
gearContainer.Position = UDim2.new(0.5, -125, 0.5, -30)
gearContainer.Parent = topBar

local gearLayout = Instance.new("UIListLayout")
gearLayout.FillDirection = Enum.FillDirection.Horizontal
gearLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gearLayout.VerticalAlignment = Enum.VerticalAlignment.Center
gearLayout.Padding = UDim.new(0, 8)
gearLayout.Parent = gearContainer

local currentGear = "P"
local gearButtons = {}
for _, gear in ipairs({"P", "R", "N", "D"}) do
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Size = UDim2.fromOffset(50, 38)
    b.Text = gear
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.TextColor3 = theme.text
    b.BackgroundColor3 = theme.panel
    b.BorderSizePixel = 0
    addCorner(b, 12)
    b.Parent = gearContainer
    gearButtons[gear] = b

    b.MouseButton1Click:Connect(function()
        currentGear = gear
    end)
end

local batteryPct = 82
local batteryLabel = makeLabel(topBar, "Battery 82%", UDim2.fromOffset(180, 20), UDim2.new(1, -208, 0, 14), theme.subText)
batteryLabel.TextXAlignment = Enum.TextXAlignment.Right
batteryLabel.TextSize = 13

local batteryBg = Instance.new("Frame")
batteryBg.Size = UDim2.fromOffset(172, 18)
batteryBg.Position = UDim2.new(1, -192, 0, 45)
batteryBg.BackgroundColor3 = theme.panel
batteryBg.BorderSizePixel = 0
batteryBg.Parent = topBar
addCorner(batteryBg, 8)

local batteryFill = Instance.new("Frame")
batteryFill.Size = UDim2.new(0.82, 0, 1, 0)
batteryFill.BackgroundColor3 = theme.success
batteryFill.BorderSizePixel = 0
batteryFill.Parent = batteryBg
addCorner(batteryFill, 8)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -28, 1, -194)
body.Position = UDim2.fromOffset(14, 108)
body.BackgroundTransparency = 1
body.Parent = main

local viewportCard = Instance.new("Frame")
viewportCard.Size = UDim2.new(0.54, -6, 1, -8)
viewportCard.Position = UDim2.fromOffset(0, 0)
viewportCard.BackgroundColor3 = theme.panelSoft
viewportCard.BorderSizePixel = 0
viewportCard.Parent = body
addCorner(viewportCard, 16)

local viewport = Instance.new("ViewportFrame")
viewport.Size = UDim2.new(1, -16, 1, -16)
viewport.Position = UDim2.fromOffset(8, 8)
viewport.BackgroundColor3 = Color3.fromRGB(16, 19, 24)
viewport.BorderSizePixel = 0
viewport.LightColor = Color3.fromRGB(255, 255, 255)
viewport.Ambient = Color3.fromRGB(120, 120, 135)
viewport.Parent = viewportCard
addCorner(viewport, 14)

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.46, -6, 1, -8)
rightPanel.Position = UDim2.new(0.54, 12, 0, 0)
rightPanel.BackgroundColor3 = theme.panelSoft
rightPanel.BorderSizePixel = 0
rightPanel.Parent = body
addCorner(rightPanel, 16)

local featureTitle = makeLabel(rightPanel, "Interactive Features", UDim2.fromOffset(260, 30), UDim2.fromOffset(18, 16), theme.text)
featureTitle.Font = Enum.Font.GothamSemibold
featureTitle.TextSize = 22

local statusLabel = makeLabel(rightPanel, "Autopilot: OFF\nJoe Mode: OFF", UDim2.new(1, -36, 0, 50), UDim2.fromOffset(18, 52), theme.subText)
statusLabel.TextSize = 15
statusLabel.TextWrapped = true

local buttonHolder = Instance.new("Frame")
buttonHolder.BackgroundTransparency = 1
buttonHolder.Size = UDim2.new(1, -36, 0, 46)
buttonHolder.Position = UDim2.fromOffset(18, 112)
buttonHolder.Parent = rightPanel

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 12)
buttonLayout.Parent = buttonHolder

local autopilotButton = makeButton(buttonHolder, "Autopilot")
local joeModeButton = makeButton(buttonHolder, "Joe Mode")

local carControlsTitle = makeLabel(rightPanel, "Vehicle Rendering Controls", UDim2.fromOffset(280, 26), UDim2.fromOffset(18, 190), theme.text)
carControlsTitle.Font = Enum.Font.GothamSemibold
carControlsTitle.TextSize = 18

local carControlHolder = Instance.new("Frame")
carControlHolder.BackgroundTransparency = 1
carControlHolder.Size = UDim2.new(1, -36, 0, 112)
carControlHolder.Position = UDim2.fromOffset(18, 224)
carControlHolder.Parent = rightPanel

local carGrid = Instance.new("UIGridLayout")
carGrid.CellSize = UDim2.fromOffset(128, 42)
carGrid.CellPadding = UDim2.fromOffset(10, 10)
carGrid.FillDirectionMaxCells = 2
carGrid.Parent = carControlHolder

local frontLeftButton = makeButton(carControlHolder, "Front Left")
local frontRightButton = makeButton(carControlHolder, "Front Right")
local rearLeftButton = makeButton(carControlHolder, "Rear Left")
local rearRightButton = makeButton(carControlHolder, "Rear Right")
local trunkButton = makeButton(carControlHolder, "Trunk")

local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, -28, 0, 68)
bottomBar.Position = UDim2.new(0, 14, 1, -80)
bottomBar.BackgroundColor3 = theme.panelSoft
bottomBar.BorderSizePixel = 0
bottomBar.Parent = main
addCorner(bottomBar, 16)

local controlLayout = Instance.new("UIListLayout")
controlLayout.FillDirection = Enum.FillDirection.Horizontal
controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
controlLayout.Padding = UDim.new(0, 12)
controlLayout.Parent = bottomBar

for _, item in ipairs({
    "❄ Climate",
    "♫ Music",
    "⚙ Controls",
    "☰ Settings",
}) do
    local navButton = Instance.new("TextButton")
    navButton.AutoButtonColor = false
    navButton.BackgroundColor3 = theme.panel
    navButton.Size = UDim2.fromOffset(170, 44)
    navButton.Text = item
    navButton.Font = Enum.Font.GothamMedium
    navButton.TextSize = 15
    navButton.TextColor3 = theme.text
    navButton.Parent = bottomBar
    addCorner(navButton, 12)
end

-- 3D car model for viewport
local worldModel = Instance.new("WorldModel")
worldModel.Parent = viewport

local carModel = Instance.new("Model")
carModel.Name = "Vehicle"
carModel.Parent = worldModel

local function makePart(name, size, cframe, color)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cframe
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.Parent = carModel
    return p
end

makePart("Body", Vector3.new(7.6, 1.2, 14), CFrame.new(0, 0, 0), Color3.fromRGB(40, 45, 54))
makePart("Roof", Vector3.new(6.4, 1, 8), CFrame.new(0, 1, -0.4), Color3.fromRGB(30, 34, 42))
makePart("Hood", Vector3.new(6.8, 0.7, 3.2), CFrame.new(0, 0.8, -5.2), Color3.fromRGB(35, 40, 48))
local trunk = makePart("Trunk", Vector3.new(6.8, 0.7, 3.2), CFrame.new(0, 0.8, 5.2), Color3.fromRGB(35, 40, 48))

local frontLeftDoor = makePart("FrontLeftDoor", Vector3.new(0.5, 1.1, 3.2), CFrame.new(-4.05, 0.55, -2.6), Color3.fromRGB(55, 60, 70))
local frontRightDoor = makePart("FrontRightDoor", Vector3.new(0.5, 1.1, 3.2), CFrame.new(4.05, 0.55, -2.6), Color3.fromRGB(55, 60, 70))
local rearLeftDoor = makePart("RearLeftDoor", Vector3.new(0.5, 1.1, 3.2), CFrame.new(-4.05, 0.55, 1.3), Color3.fromRGB(55, 60, 70))
local rearRightDoor = makePart("RearRightDoor", Vector3.new(0.5, 1.1, 3.2), CFrame.new(4.05, 0.55, 1.3), Color3.fromRGB(55, 60, 70))

local wheelPositions = {
    Vector3.new(-3, -0.9, -4.5),
    Vector3.new(3, -0.9, -4.5),
    Vector3.new(-3, -0.9, 4.5),
    Vector3.new(3, -0.9, 4.5),
}

for i, pos in ipairs(wheelPositions) do
    local wheel = makePart("Wheel" .. i, Vector3.new(1.2, 1.2, 1.2), CFrame.new(pos), Color3.fromRGB(15, 16, 18))
    wheel.Shape = Enum.PartType.Ball
end

local camera = Instance.new("Camera")
camera.CFrame = CFrame.new(16, 9, 16) * CFrame.Angles(math.rad(-15), math.rad(35), 0)
viewport.CurrentCamera = camera
camera.Parent = viewport

local states = {
    frontLeft = false,
    frontRight = false,
    rearLeft = false,
    rearRight = false,
    trunk = false,
    autopilot = false,
    joeMode = false,
}

local originalCFrames = {
    frontLeftDoor = frontLeftDoor.CFrame,
    frontRightDoor = frontRightDoor.CFrame,
    rearLeftDoor = rearLeftDoor.CFrame,
    rearRightDoor = rearRightDoor.CFrame,
    trunk = trunk.CFrame,
}

local function setButtonState(button, enabled)
    TweenService:Create(button, TweenInfo.new(0.18), {
        BackgroundColor3 = enabled and theme.accent or theme.panelSoft,
    }):Play()
end

local function updateFeatureStatus()
    statusLabel.Text = string.format(
        "Autopilot: %s\nJoe Mode: %s",
        states.autopilot and "ON" or "OFF",
        states.joeMode and "ON" or "OFF"
    )
end

local function updateBatteryDisplay()
    local ratio = math.clamp(batteryPct / 100, 0, 1)
    batteryLabel.Text = string.format("Battery %d%%", math.floor(batteryPct + 0.5))
    batteryFill.Size = UDim2.new(ratio, 0, 1, 0)

    if batteryPct > 40 then
        batteryFill.BackgroundColor3 = theme.success
    elseif batteryPct > 20 then
        batteryFill.BackgroundColor3 = theme.warning
    else
        batteryFill.BackgroundColor3 = Color3.fromRGB(226, 84, 84)
    end
end

local function tweenDoor(part, targetCFrame)
    TweenService:Create(part, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        CFrame = targetCFrame,
    }):Play()
end

local function toggleDoor(doorPart, key, openTransform)
    states[key] = not states[key]
    local base = originalCFrames[doorPart.Name]
    local target = states[key] and (base * openTransform) or base
    tweenDoor(doorPart, target)
end

frontLeftButton.MouseButton1Click:Connect(function()
    toggleDoor(frontLeftDoor, "frontLeft", CFrame.new(-0.5, 0, 0) * CFrame.Angles(0, 0, math.rad(60)) * CFrame.new(0.5, 0, 0))
    setButtonState(frontLeftButton, states.frontLeft)
end)
frontRightButton.MouseButton1Click:Connect(function()
    toggleDoor(frontRightDoor, "frontRight", CFrame.new(0.5, 0, 0) * CFrame.Angles(0, 0, math.rad(-60)) * CFrame.new(-0.5, 0, 0))
    setButtonState(frontRightButton, states.frontRight)
end)
rearLeftButton.MouseButton1Click:Connect(function()
    toggleDoor(rearLeftDoor, "rearLeft", CFrame.new(-0.5, 0, 0) * CFrame.Angles(0, 0, math.rad(55)) * CFrame.new(0.5, 0, 0))
    setButtonState(rearLeftButton, states.rearLeft)
end)
rearRightButton.MouseButton1Click:Connect(function()
    toggleDoor(rearRightDoor, "rearRight", CFrame.new(0.5, 0, 0) * CFrame.Angles(0, 0, math.rad(-55)) * CFrame.new(-0.5, 0, 0))
    setButtonState(rearRightButton, states.rearRight)
end)
trunkButton.MouseButton1Click:Connect(function()
    states.trunk = not states.trunk
    local target = states.trunk
        and (originalCFrames.trunk * CFrame.new(0, 0.2, 1.4) * CFrame.Angles(math.rad(-50), 0, 0))
        or originalCFrames.trunk
    tweenDoor(trunk, target)
    setButtonState(trunkButton, states.trunk)
end)

autopilotButton.MouseButton1Click:Connect(function()
    states.autopilot = not states.autopilot
    setButtonState(autopilotButton, states.autopilot)
    updateFeatureStatus()
end)
joeModeButton.MouseButton1Click:Connect(function()
    states.joeMode = not states.joeMode
    setButtonState(joeModeButton, states.joeMode)
    updateFeatureStatus()
end)

-- Demo drive + battery simulation
local speed = 0
RunService.RenderStepped:Connect(function(dt)
    if states.autopilot then
        speed = math.clamp(speed + (dt * 18), 0, 82)
        batteryPct = math.clamp(batteryPct - dt * 0.06, 0, 100)
    else
        speed = math.clamp(speed - (dt * 14), 0, 82)
        batteryPct = math.clamp(batteryPct - dt * 0.015, 0, 100)
    end

    speedValue.Text = string.format("%d mph", math.floor(speed + 0.5))
    updateBatteryDisplay()

    for gear, button in pairs(gearButtons) do
        button.BackgroundColor3 = (gear == currentGear) and theme.accent or theme.panel
    end
end)

updateFeatureStatus()
updateBatteryDisplay()
