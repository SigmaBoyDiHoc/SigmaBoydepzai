-- // [ NamSigma ] --
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

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SigmaBoyUI"
local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0, 10, 0.5, -180)
frame.Size = UDim2.new(0, 260, 0, 430)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Text = "🗿 NamSigma Panel"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local function createToggle(name, position, initialState, callback)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 150, 0, 30)
    label.Position = UDim2.new(0, 10, 0, position)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0, 80, 0, 30)
    toggle.Position = UDim2.new(0, 170, 0, position)
    toggle.BackgroundColor3 = initialState and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 18
    toggle.Text = initialState and "Bật" or "Tắt"

    local state = initialState
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        toggle.Text = state and "Bật" or "Tắt"
        callback(state)
    end)
    return toggle
end

-- Hiệu ứng thông báo
local function showNotice(msg)
    local notice = Instance.new("TextLabel", screenGui)
    notice.Size = UDim2.new(0, 320, 0, 40)
    notice.Position = UDim2.new(0.5, -160, 0.05, 0)
    notice.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    notice.TextColor3 = Color3.new(0, 0, 0)
    notice.Font = Enum.Font.GothamBold
    notice.TextSize = 20
    notice.Text = "🗿 " .. msg
    notice.BackgroundTransparency = 0
    notice.BorderSizePixel = 0
    notice.AnchorPoint = Vector2.new(0.5, 0)

    local tweenIn = TweenService:Create(notice, TweenInfo.new(0.5), {BackgroundTransparency = 0.25})
    tweenIn:Play()
    task.delay(3, function()
        local tweenOut = TweenService:Create(notice, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notice:Destroy()
    end)
end

-- Toggle UI bằng phím END
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.End and not gp then
        uiVisible = not uiVisible
        screenGui.Enabled = uiVisible
        showNotice(uiVisible and "✅ UI Đã Bật" or "❌ UI Đã Tắt")
    end
end)

-- Anti-Ban
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Kick" or method == "Kick" then
        return nil
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").BreakJointsOnDeath = false
end)

showNotice("🛡️ Anti-Ban Đã Kích Hoạt!")

-- Fullbright
local fullbrightEnabled = false
local oldBrightness = Lighting.Brightness
local oldAmbient = Lighting.Ambient
local oldClockTime = Lighting.ClockTime

local function SetFullBright(state)
    fullbrightEnabled = state
    if state then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ClockTime = 14
        showNotice("Ánh Sáng Của Đảng: Ánh Sáng Tự Hào")
    else
        Lighting.Brightness = oldBrightness
        Lighting.Ambient = oldAmbient
        Lighting.ClockTime = oldClockTime
        showNotice("Ánh Sáng Của Đảng: Ánh Sáng Đã Bị Dập Tắt")
    end
end

-- XRay
local xrayEnabled = false
local xrayOriginals = {}

local function SetXRay(state)
    xrayEnabled = state
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if state then
                xrayOriginals[part] = {Transparency = part.Transparency, Material = part.Material}
                part.Transparency = 0.6
                part.Material = Enum.Material.Neon
            else
                if xrayOriginals[part] then
                    part.Transparency = xrayOriginals[part].Transparency
                    part.Material = xrayOriginals[part].Material
                    xrayOriginals[part] = nil
                else
                    part.Transparency = 0
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
    showNotice(state and "Soi Bướm" or "Bị Phát Hiện")
end

-- ESP
local espEnabled = false
local espTags = {}

local function CreateESPTag(plr)
    if plr == player then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = plr.Character.HumanoidRootPart
    box.Size = Vector3.new(4, 5, 1)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.AlwaysOnTop = true
    box.Parent = player.PlayerGui
    espTags[plr.Name] = box
end

local function SetESP(state)
    espEnabled = state
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            CreateESPTag(plr)
        end
        Players.PlayerAdded:Connect(function(plr)
            if espEnabled then
                task.wait(1)
                CreateESPTag(plr)
            end
        end)
    else
        for _, box in pairs(espTags) do
            box:Destroy()
        end
        espTags = {}
    end
    showNotice(state and "Anh Em Đâu Rồi: Đã Xác Định Vị Trí" or "Radar Hết Pin")
end

-- LoopSpeed
local loopspeedEnabled = false
local loopspeedValue = 16
local loopSpeedConnection

local loopSpeedTable = {
    [Enum.KeyCode.One] = 8,
    [Enum.KeyCode.Two] = 12,
    [Enum.KeyCode.Three] = 16,
    [Enum.KeyCode.Four] = 20,
    [Enum.KeyCode.Five] = 24,
    [Enum.KeyCode.Six] = 28,
    [Enum.KeyCode.Seven] = 32,
    [Enum.KeyCode.Eight] = 36,
    [Enum.KeyCode.Nine] = 40,
}

local function ToggleLoopSpeed(state)
    loopspeedEnabled = state
    if state then
        humanoid.WalkSpeed = loopspeedValue
        loopSpeedConnection = RunService.Heartbeat:Connect(function()
            if humanoid then
                humanoid.WalkSpeed = loopspeedValue
            end
        end)
        showNotice("Tốc Độ Bàn Thờ: Chạy Theo Lý Tưởng Của Bác Hồ Vĩ Đại")
    else
        if loopSpeedConnection then loopSpeedConnection:Disconnect() end
        humanoid.WalkSpeed = 16
        showNotice("Tốc Độ Bàn Thờ: Bạn Đã Cạn Sức Lực")
    end
end

-- Fly
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local flySpeeds = {
    [Enum.KeyCode.One] = 10,
    [Enum.KeyCode.Two] = 20,
    [Enum.KeyCode.Three] = 30,
    [Enum.KeyCode.Four] = 40,
    [Enum.KeyCode.Five] = 50,
    [Enum.KeyCode.Six] = 60,
    [Enum.KeyCode.Seven] = 70,
    [Enum.KeyCode.Eight] = 80,
    [Enum.KeyCode.Nine] = 90,
}

local function Fly(state)
    if state then
        if flying then return end
        flying = true
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        bodyVelocity = Instance.new("BodyVelocity", root)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)

        bodyGyro = Instance.new("BodyGyro", root)
        bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bodyGyro.CFrame = root.CFrame

        RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                move = move - Vector3.new(0,1,0)
            end

            bodyVelocity.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.new(0,0,0)
            bodyGyro.CFrame = camera.CFrame
        end)
        showNotice("Siêu Nhân: Cất Cánh")
    else
        if not flying then return end
        flying = false
        RunService:UnbindFromRenderStep("Fly")
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        showNotice("Siêu Nhân: Hạ Cánh An Toàn")
    end
end

-- Phím 1-9 để chỉnh tốc độ Fly & LoopSpeed
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if flySpeeds[input.KeyCode] then
        if flying then
            flySpeed = flySpeeds[input.KeyCode]
            showNotice("Siêu Nhân: Tốc Độ Bay = " .. flySpeed)
        end
        if loopspeedEnabled then
            loopspeedValue = loopSpeedTable[input.KeyCode]
            humanoid.WalkSpeed = loopspeedValue
            showNotice("Tốc Độ Bàn Thờ: Speed = " .. loopspeedValue)
        end
    end
end)

-- Giao diện nút bật/tắt
createToggle("Ánh Sáng Của Đảng", 50, false, SetFullBright)
createToggle("Soi Bướm", 90, false, SetXRay)
createToggle("Anh Em Đâu Rồi", 130, false, SetESP)
createToggle("Tốc Độ Bàn Thờ", 170, false, ToggleLoopSpeed)
createToggle("Siêu Nhân", 210, false, Fly)

-- Hướng dẫn sử dụng
local helpLabel = Instance.new("TextLabel", frame)
helpLabel.Size = UDim2.new(1, -20, 0, 140)
helpLabel.Position = UDim2.new(0, 10, 0, 260)
helpLabel.BackgroundTransparency = 1
helpLabel.TextColor3 = Color3.new(1, 1, 1)
helpLabel.TextSize = 14
helpLabel.TextXAlignment = Enum.TextXAlignment.Left
helpLabel.Font = Enum.Font.Gotham
helpLabel.Text = [[
🔥 Phím END: Ẩn/Hiện UI
🔥 Phím 1-9: Chỉnh Tốc Độ Fly & LoopSpeed
🔥 W,A,S,D, Space, Ctrl để bay khi bật Fly
]]

-- Kết thúc
showNotice("NamSigma: Panel Đã Sẵn Sàng!")
