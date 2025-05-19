-- // [ NamSigma Panel Full ] --
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
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SigmaBoyUI"
local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0, 10, 0.5, -180)
frame.Size = UDim2.new(0, 260, 0, 750)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Text = "🗿 NamSigma Panel 🗿"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local logo = Instance.new("ImageLabel", frame)
logo.Image = "rbxassetid://13712929753" -- sigma boy
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(1, -70, 0, 5)
logo.BackgroundTransparency = 1

-- Sounds
local function playMemeSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://9118823101"
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function playSigmaSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://1837635129"
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function spawnSigmaFace()
    local face = Instance.new("ImageLabel", screenGui)
    face.Image = "rbxassetid://13712929753"
    face.Size = UDim2.new(0, 100, 0, 100)
    face.Position = UDim2.new(0.5, -50, 0.5, -50)
    face.BackgroundTransparency = 1
    face.ImageTransparency = 0.2
    local goal = {Position = UDim2.new(0.5, -50, 0.2, -50), ImageTransparency = 1}
    local tween = TweenService:Create(face, TweenInfo.new(2, Enum.EasingStyle.Sine), goal)
    tween:Play()
    tween.Completed:Connect(function()
        face:Destroy()
    end)
end

local function spawnSigmaOrb()
    local img = Instance.new("ImageLabel", screenGui)
    img.Image = "rbxassetid://13712929753"
    img.Size = UDim2.new(0, 80, 0, 80)
    img.Position = UDim2.new(math.random(), -40, math.random(), -40)
    img.BackgroundTransparency = 1
    img.Rotation = math.random(0, 360)

    local rotate = TweenService:Create(img, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = img.Rotation + 360})
    rotate:Play()

    local fade = TweenService:Create(img, TweenInfo.new(2), {ImageTransparency = 1})
    fade:Play()

    task.delay(2, function()
        img:Destroy()
    end)
end

local function shakeScreen()
    for i = 1, 5 do
        camera.CFrame *= CFrame.new(math.random(-1,1), math.random(-1,1), 0)
        task.wait(0.05)
    end
end

local function spawnMemeEffect()
    local img = Instance.new("ImageLabel", screenGui)
    img.Image = "rbxassetid://12528823364"
    img.Size = UDim2.new(0, 150, 0, 150)
    img.Position = UDim2.new(math.random(), -75, math.random(), -75)
    img.BackgroundTransparency = 1
    img.ImageTransparency = 0.1
    local tween = TweenService:Create(img, TweenInfo.new(1.5), {ImageTransparency = 1, Position = img.Position + UDim2.new(0, 0, -0.2, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        img:Destroy()
    end)
end

local function showNotice(msg)
    local emojiList = {"🗿", "📿", "🔥", "😈", "🤙", "💀", "🚀", "📸", "👁️", "💥", "🥶"}
    local emoji = emojiList[math.random(1, #emojiList)]
    local notice = Instance.new("TextLabel", screenGui)
    notice.Size = UDim2.new(0, 320, 0, 40)
    notice.Position = UDim2.new(0.5, -160, 0.05, 0)
    notice.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    notice.TextColor3 = Color3.new(0, 0, 0)
    notice.Font = Enum.Font.GothamBold
    notice.TextSize = 20
    notice.Text = emoji .. " " .. msg
    notice.BackgroundTransparency = 0
    notice.BorderSizePixel = 0
    notice.AnchorPoint = Vector2.new(0.5, 0)
    local tweenIn = TweenService:Create(notice, TweenInfo.new(0.5), {BackgroundTransparency = 0.25})
    tweenIn:Play()
    spawnSigmaFace()
    spawnMemeEffect()
    spawnSigmaOrb()
    playMemeSound()
    task.delay(3, function()
        local tweenOut = TweenService:Create(notice, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notice:Destroy()
    end)
end

-- [Phần còn lại giữ nguyên như cũ]

showNotice("NamSigma Panel: Đã Cập Nhật!")
