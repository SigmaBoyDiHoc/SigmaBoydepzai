-- // [ NamSigma Panel Full - Final Version ] --
-- Author: Nam Sói
-- WARNING: Only use in private/local games for educational purposes

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SigmaBoyUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0, 10, 0.5, -180)
frame.Size = UDim2.new(0, 260, 0, 1200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "🗿 NamSigma Panel 🗿"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

local logo = Instance.new("ImageLabel")
logo.Image = "rbxassetid://13712929753"
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(1, -70, 0, 5)
logo.BackgroundTransparency = 1
logo.Parent = frame

local spin = TweenService:Create(logo, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
spin:Play()

-- Simple Notice System
function showNotice(text)
	StarterGui:SetCore("SendNotification", {
		Title = "NamSigma",
		Text = text,
		Duration = 2
	})
	local sound = Instance.new("Sound", SoundService)
	sound.SoundId = "rbxassetid://9118823101"
	sound:Play()
	game.Debris:AddItem(sound, 3)
end

-- Sliders
local wsjpFrame = Instance.new("Frame", frame)
wsjpFrame.Position = UDim2.new(0, 10, 0, 310)
wsjpFrame.Size = UDim2.new(1, -20, 0, 100)
wsjpFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
wsjpFrame.BorderSizePixel = 0

local function createSlider(labelText, min, max, default, yPos, onChange)
	local label = Instance.new("TextLabel", wsjpFrame)
	label.Text = labelText
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, yPos)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local slider = Instance.new("TextButton", wsjpFrame)
	slider.Size = UDim2.new(1, 0, 0, 20)
	slider.Position = UDim2.new(0, 0, 0, yPos + 20)
	slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	slider.TextColor3 = Color3.new(1, 1, 1)
	slider.Font = Enum.Font.Gotham
	slider.TextSize = 14
	slider.Text = tostring(default)

	local value = default
	slider.MouseButton1Click:Connect(function()
		value += 5
		if value > max then value = min end
		slider.Text = tostring(value)
		onChange(value)
	end)
end

createSlider("🚶 WalkSpeed", 16, 100, humanoid.WalkSpeed, 0, function(val)
	humanoid.WalkSpeed = val
	showNotice("🚶 Tốc độ: " .. val)
end)

createSlider("🦘 JumpPower", 50, 200, humanoid.JumpPower, 50, function(val)
	humanoid.JumpPower = val
	showNotice("🦘 Nhảy: " .. val)
end)

-- Extra Functional Toggles
local function createToggle(name, yPos, callback)
	local toggle = Instance.new("TextButton", frame)
	toggle.Size = UDim2.new(0, 240, 0, 30)
	toggle.Position = UDim2.new(0, 10, 0, yPos)
	toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.Text = name .. " [OFF]"

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = name .. (state and " [ON]" or " [OFF]")
		callback(state)
	end)
end

-- Core Features Restored
createToggle("🚀 Fly", 430, function(on)
	local body = Instance.new("BodyVelocity")
	body.Velocity = Vector3.new(0, 0, 0)
	body.MaxForce = Vector3.new(0, 0, 0)
	body.Parent = character:WaitForChild("HumanoidRootPart")
	if on then
		RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
			body.Velocity = camera.CFrame.LookVector * 50
			body.MaxForce = Vector3.new(400000, 400000, 400000)
		end)
	else
		RunService:UnbindFromRenderStep("Fly")
		body:Destroy()
	end
end)

createToggle("🔍 ESP", 470, function(on)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local ch = p.Character and p.Character:FindFirstChild("Head")
			if ch and not ch:FindFirstChild("Esp") then
				local tag = Instance.new("BillboardGui", ch)
				tag.Name = "Esp"
				tag.Size = UDim2.new(0, 100, 0, 40)
				tag.AlwaysOnTop = true
				local txt = Instance.new("TextLabel", tag)
				txt.Text = p.Name
				txt.TextColor3 = Color3.new(1, 0, 0)
				txt.BackgroundTransparency = 1
				txt.Size = UDim2.new(1, 0, 1, 0)
			end
		end
	end
end)

createToggle("💡 Fullbright", 510, function(on)
	Lighting.Brightness = on and 5 or 1
	Lighting.Ambient = on and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
end)

createToggle("🌫️ No Fog", 550, function(on)
	Lighting.FogEnd = on and 1e10 or 1000
end)

createToggle("🕳️ Anti Void", 590, function(on)
	if on then
		local part = Instance.new("Part", Workspace)
		part.Anchored = true
		part.Size = Vector3.new(1000, 10, 1000)
		part.Position = Vector3.new(0, -20, 0)
		part.BrickColor = BrickColor.new("Really red")
		part.Name = "AntiVoid"
	else
		local p = Workspace:FindFirstChild("AntiVoid")
		if p then p:Destroy() end
	end
end)

createToggle("🔄 Spin", 630, function(on)
	if on then
		RunService:BindToRenderStep("Spin", Enum.RenderPriority.Camera.Value, function()
			character:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame() * CFrame.Angles(0, 0.1, 0))
		end)
	else
		RunService:UnbindFromRenderStep("Spin")
	end
end)

createToggle("🖱️ Ctrl+Click Teleport", 670, function(on)
	mouse.Button1Down:Connect(function()
		if on and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			if mouse.Hit then
				character:MoveTo(mouse.Hit.p)
				showNotice("📍 Ctrl+Click dịch chuyển")
			end
		end
	end)
end)

createToggle("🤣 Jerk Off FX", 710, function(on)
	if on then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://148840371" -- random funny anim
		humanoid:LoadAnimation(anim):Play()
		showNotice("💦 Sigma Vibe!")
	end
end)

createToggle("😎 View Toggle (Ctrl)", 750, function(on)
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftControl and on then
			camera.CameraType = (camera.CameraType == Enum.CameraType.Custom) and Enum.CameraType.Scriptable or Enum.CameraType.Custom
			showNotice("📷 Đã đổi góc nhìn")
		end
	end)
end)

-- Teleport GUI
local tpGui = Instance.new("Frame", screenGui)
tpGui.Size = UDim2.new(0, 180, 0, 180)
tpGui.Position = UDim2.new(1, -190, 0.5, -90)
tpGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpGui.Visible = false

local tpLabel = Instance.new("TextLabel", tpGui)
tpLabel.Size = UDim2.new(1, 0, 0, 30)
tpLabel.Text = "🚀 Teleport To:"
tpLabel.TextColor3 = Color3.new(1, 1, 1)
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 16
tpLabel.BackgroundTransparency = 1

local function createTPButton(name, pos, y)
	local btn = Instance.new("TextButton", tpGui)
	btn.Text = name
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(function()
		character:MoveTo(pos)
		showNotice("⚡ Dịch chuyển tới: " .. name)
	end)
end

createTPButton("🏠 Spawn", Vector3.new(0, 10, 0), 40)
createTPButton("🗼 High Point", Vector3.new(0, 500, 0), 80)
createTPButton("🕳️ Void Test", Vector3.new(0, -40, 0), 120)

createToggle("Teleport GUI", 800, function(state)
	tpGui.Visible = state
	showNotice(state and "📍 Mở Teleport" or "📍 Tắt Teleport")
end)

-- Auto Respawn
local autoRespawn = false
createToggle("Auto Respawn", 840, function(state)
	autoRespawn = state
	showNotice(state and "♻️ Tự hồi sinh bật" or "🛑 Tự hồi sinh tắt")
end)

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	if autoRespawn then
		showNotice("⚡ Tự động hồi sinh!")
	end
end)

-- Reset Character
createToggle("Reset Nhân Vật", 880, function()
	character:BreakJoints()
	showNotice("♻️ Reset nhân vật!")
end)

showNotice("✅ NamSigma Panel Đã Cập Nhật Đầy Đủ!")
