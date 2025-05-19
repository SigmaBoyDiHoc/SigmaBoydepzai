-- // [ NamSigma ] \
-- Author: Nam Sói
-- WARNING: Only use in private/local games for educational purposes

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = Workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- Thông báo hiệu ứng vui nhộn chuẩn Sigma Boy
local function showNotification(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 50)
    frame.Position = UDim2.new(0.5, -160, 1, -70) -- Bắt đầu dưới cùng màn hình
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Parent = playerGui

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.4
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Center

    local colors = {
        Color3.fromRGB(255, 85, 85),
        Color3.fromRGB(255, 255, 85),
        Color3.fromRGB(85, 255, 255),
        Color3.fromRGB(85, 255, 170)
    }
    local colorIndex = 1

    local colorTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local function tweenColor()
        colorIndex = colorIndex % #colors + 1
        local tween = TweenService:Create(label, colorTweenInfo, {TextColor3 = colors[colorIndex]})
        tween:Play()
        tween.Completed:Wait()
        tweenColor()
    end
    coroutine.wrap(tweenColor)()

    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenPos = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -160, 0.1, 0)})
    local tweenFade = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
    local tweenLabelFade = TweenService:Create(label, tweenInfo, {TextTransparency = 1})
    local tweenScale = TweenService:Create(frame, tweenInfo, {Size = UDim2.new(0, 320, 0, 20)})

    tweenPos:Play()
    tweenFade:Play()
    tweenLabelFade:Play()
    tweenScale:Play()

    tweenPos.Completed:Connect(function()
        frame:Destroy()
    end)
end

-- UI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SigmaBoyUI"

local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0, 10, 0.5, -150)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Text = "😎 NamSigma Panel"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local function createButton(name, position, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, position)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
end

-- Features

local function enableFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    showNotification("✅ Fullbright bật! Đảng sáng rực rỡ!")
end

local function enableXray()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
            obj.LocalTransparencyModifier = 0.7
        end
    end
    showNotification("✅ Xray bật! Mắt thần nhìn thấu vật thể!")
end

local noclip = false
RunService.Stepped:Connect(function()
    if noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local infiniteJump = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

local function startFlying()
    flying = true
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
    bodyGyro.Parent = character.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = character.HumanoidRootPart

    RunService.RenderStepped:Connect(function()
        if flying then
            local moveDirection = humanoid.MoveDirection
            bodyVelocity.Velocity = moveDirection * flySpeed
            bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
        end
    end)
    showNotification("✅ Bay lên nào, siêu nhân!")
end

local function stopFlying()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    showNotification("❌ Đã hạ cánh an toàn!")
end

local function enableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            if not plr.Character.Head:FindFirstChild("SigmaESP") then
                local billboard = Instance.new("BillboardGui", plr.Character.Head)
                billboard.Name = "SigmaESP"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = plr.Name
                label.TextColor3 = Color3.new(1, 0, 0)
                label.BackgroundTransparency = 1
            end
        end
    end
    showNotification("✅ ESP bật! Anh em nhìn thấy nhau!")
end

local loopSpeed = false
local targetSpeed = 100

RunService.Heartbeat:Connect(function()
    if loopSpeed and humanoid then
        humanoid.WalkSpeed = targetSpeed
    end
end)

local freecamEnabled = false
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.F and not gp then
        freecamEnabled = not freecamEnabled
        camera.CameraType = freecamEnabled and Enum.CameraType.Scriptable or Enum.CameraType.Custom
        showNotification(freecamEnabled and "✅ Mắt ma bật!" or "❌ Mắt ma tắt!")
    end
end)

-- UI Buttons
createButton("👻 NoClip", 40, function()
    noclip = not noclip
    showNotification(noclip and "✅ Bạn là bóng ma rồi!" or "❌ Trở lại làm người rồi!")
end)

createButton("🪂 Infinite Jump", 80, function()
    infiniteJump = not infiniteJump
    showNotification(infiniteJump and "✅ Nhảy vô tận!" or "❌ Tạm biệt nhảy vô tận!")
end)

createButton("🚀 Fly", 120, function()
    if flying then stopFlying() else startFlying() end
end)

createButton("⚡ LoopSpeed", 160, function()
    loopSpeed = not loopSpeed
    showNotification(loopSpeed and ("✅ Tốc độ siêu nhân: " .. targetSpeed) or "❌ Tốc độ về mặc định")
end)

createButton("🌞 Fullbright", 200, enableFullbright)
createButton("🧿 Xray", 240, enableXray)
createButton("🎮 ESP", 280, enableESP)

showNotification("✅ Script đã sẵn sàng! Dùng GUI hoặc phím tắt!")

-- Hotkey END để hiện/ẩn UI
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.End and not gp then
        screenGui.Enabled = not screenGui.Enabled
        showNotification(screenGui.Enabled and "✅ GUI hiển thị" or "❌ GUI ẩn rồi")
    end
end)
