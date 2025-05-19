-- // [ NamSigma ] \
-- Author: Nam Sói
-- WARNING: Only use in private/local games for educational purposes

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = Workspace.CurrentCamera

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SigmaBoyUI"
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0, 10, 0.5, -150)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Visible = false  -- hidden by default

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

-- Toggle UI with END key
-- Tween và hiệu ứng rung UI khi bật
local TweenService = game:GetService("TweenService")

local originalColor = frame.BackgroundColor3

local function playUIEffects()
    frame.BackgroundTransparency = 1
    frame.Visible = true
    
    -- Fade in
    local fadeTween = TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2})
    fadeTween:Play()
    
    -- Rung nhẹ (dich chuyển frame)
    local shakeTimes = 6
    local shakeMagnitude = 5
    for i = 1, shakeTimes do
        local offsetX = (math.random() - 0.5) * 2 * shakeMagnitude
        local offsetY = (math.random() - 0.5) * 2 * shakeMagnitude
        local targetPos = UDim2.new(0, 10 + offsetX, 0.5, -150 + offsetY)
        local shakeTween = TweenService:Create(frame, TweenInfo.new(0.05), {Position = targetPos})
        shakeTween:Play()
        shakeTween.Completed:Wait()
    end
    -- Trả vị trí về ban đầu
    local resetTween = TweenService:Create(frame, TweenInfo.new(0.1), {Position = UDim2.new(0, 10, 0.5, -150)})
    resetTween:Play()
    
    -- Hiệu ứng đổi màu nền nhè nhẹ
    local colorTween1 = TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(80, 30, 150)})
    local colorTween2 = TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundColor3 = originalColor})
    colorTween1:Play()
    colorTween1.Completed:Wait()
    colorTween2:Play()
end

-- Toggle UI with END key, kèm hiệu ứng
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.End and not gameProcessed then
        if not frame.Visible then
            playUIEffects()
            print("✅ Thời Đại Của Sigma Đã Đến!")
        else
            frame.Visible = false
            print("❌ Sigma Sẽ Quay Lại Trả Thù!")
        end
    end
end)


-- // Ánh Sáng Của Đảng
local function enableFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    print("✅ Đảng Đã Chiếu Sáng!")
end

-- // Soi Bướm
local function enableXray()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
            obj.LocalTransparencyModifier = 0.7
        end
    end
    print("✅ Mắt Thần Đã Mở!")
end

-- // Đi Xuyên Si Lít
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

-- // Nhảy Mãi
local infiniteJump = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- // Siêu Nhân
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
    print("✅ Bay Lên Nào Siêu Nhân!")
end

local function stopFlying()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    print("❌ Đã Hạ Cánh An Toàn!")
end

-- // Anh em Ở Đâu
local function enableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui", plr.Character.Head)
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
    print("✅ Đã Kết Nối Với Anh Em Đồng Chí!")
end

-- // Tốc Độ Bắn Tinh
local loopSpeed = false
local targetSpeed = 100

RunService.Heartbeat:Connect(function()
    if loopSpeed and humanoid then
        humanoid.WalkSpeed = targetSpeed
    end
end)

-- // Ma
local freecamEnabled = false
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.F and not gp then
        freecamEnabled = not freecamEnabled
        camera.CameraType = freecamEnabled and Enum.CameraType.Scriptable or Enum.CameraType.Custom
        print(freecamEnabled and "✅ Mắt Ma Đã Mở" or "❌ Mắt Ma Đã Tắt")
    end
end)

-- Chat commands for tuning
TextChatService.OnIncomingMessage = function(message)
    local text = message.Text:lower()
    if text:sub(1, 10) == "/loopspeed " then
        local value = tonumber(text:sub(11))
        if value then
            targetSpeed = value
            print("✅ Có Nguồn Điện Đã Chạy Qua Chân Của Bạn:", value)
        end
    elseif text:sub(1, 5) == "/fly " then
        local value = tonumber(text:sub(6))
        if value then
            flySpeed = value
            print("✅ Bay Nhanh Như Gió:", value)
        end
    end
end

-- UI Buttons
createButton("👻 NoClip", 40, function()
    noclip = not noclip
    print(noclip and "✅ Bạn Đã Trở Thành Bóng Ma" or "❌ Bạn Đã Trở Lại Trần Gian")
end)

createButton("🪂 Infinite Jump", 80, function()
    infiniteJump = not infiniteJump
    print(infiniteJump and "✅ Nhảy Mãi Không Thôi" or "❌ Hết Năng Lượng Nhảy")
end)

createButton("🚀 Fly", 120, function()
    if flying then stopFlying() else startFlying() end
end)

createButton("⚡ LoopSpeed", 160, function()
    loopSpeed = not loopSpeed
    print(loopSpeed and ("✅ Tốc Độ Ánh Sáng Được Kích Hoạt (" .. targetSpeed .. ")") or "❌ Đã Trở Lại Vận Tốc Người Phàm")
end)

createButton("🌞 Fullbright", 200, enableFullbright)
createButton("🧿 Xray", 240, enableXray)
createButton("🎮 ESP", 280, enableESP)

print("✅ Script loaded. Nhấn phím END để bật/tắt menu hoặc sử dụng các phím khác để điều khiển chức năng!")
