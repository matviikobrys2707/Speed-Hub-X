-- BLAZIX HUB: TOWER OF HELL ULTIMATE (BY GEMINI)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Конфигурация
local Config = {
    Speed = false,
    SpeedValue = 16,
    JumpPower = 50,
    InfJump = false,
    Gravity = 196.2,
    NoLava = false,
    InstantProx = false,
    Visuals = false
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixTower"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Маленькая кнопка открытия (B)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "B"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Основное окно
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Header (Таскалка)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "BLAZIX HUB | ToH REBORN"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Кнопки Закрыть/Свернуть
local function CreateHeadBtn(text, pos, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = Header
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

CreateHeadBtn("X", UDim2.new(1, -35, 0, 5), Color3.fromRGB(180, 50, 50), function() ScreenGui:Destroy() end)
CreateHeadBtn("-", UDim2.new(1, -70, 0, 5), Color3.fromRGB(60, 60, 70), function() Main.Visible = false; OpenBtn.Visible = true end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- Вкладки
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 120, 1, -50)
Tabs.Position = UDim2.new(0, 10, 0, 45)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main
Instance.new("UIListLayout", Tabs).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -55)
Container.Position = UDim2.new(0, 135, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Pages = {}
local function NewPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    p.Parent = Container
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.Gotham
    b.Parent = Tabs
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
    end)
    Pages[name] = p
    return p
end

local MainPg = NewPage("Player")
local TelePg = NewPage("Teleport")
local MiscPg = NewPage("Misc")
local VisPg = NewPage("Visuals")
MainPg.Visible = true

-- Кастомные элементы управления
local function AddToggle(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = parent
    Instance.new("UICorner", b)
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = text .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 55)
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 50)
    f.BackgroundTransparency = 1
    f.Parent = parent
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 20)
    t.Text = text .. ": " .. default
    t.TextColor3 = Color3.new(1, 1, 1)
    t.BackgroundTransparency = 1
    t.Parent = f
    
    local s = Instance.new("TextButton")
    s.Size = UDim2.new(1, 0, 0, 20)
    s.Position = UDim2.new(0, 0, 0, 25)
    s.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    s.Text = ""
    s.Parent = f
    Instance.new("UICorner", s)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = s
    Instance.new("UICorner", fill)
    
    local function Update(input)
        local per = math.clamp((input.Position.X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(per, 0, 1, 0)
        local val = math.floor(min + (max - min) * per)
        t.Text = text .. ": " .. val
        callback(val)
    end
    
    s.MouseButton1Down:Connect(function()
        local move = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
        end)
    end)
end

-- ЛОГИКА ОБХОДА
-- 1. Исправленный Inf Jump (Через Impulse)
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end
end)

-- 2. Безопасный Speed
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if Config.Speed and hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(hum.MoveDirection * (Config.SpeedValue / 50))
        end
    end
end)

-- НАПОЛНЕНИЕ
AddToggle(MainPg, "⚡ Enable Speed", function(v) Config.Speed = v end)
AddSlider(MainPg, "Speed Value", 16, 150, 16, function(v) Config.SpeedValue = v end)
AddToggle(MainPg, "🔄 Fixed Inf Jump", function(v) Config.InfJump = v end)
AddSlider(MainPg, "Gravity", 0, 196, 196, function(v) workspace.Gravity = v end)

-- Телепорт
local function TeleportTo(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

local btnWin = Instance.new("TextButton", TelePg)
btnWin.Size = UDim2.new(1, -10, 0, 40)
btnWin.Text = "🏆 TELEPORT TO WIN (SMART)"
btnWin.BackgroundColor3 = Color3.fromRGB(150, 120, 0)
btnWin.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnWin)

btnWin.MouseButton1Click:Connect(function()
    local target = workspace:FindFirstChild("tower") and workspace.tower:FindFirstChild("sections") and workspace.tower.sections:FindFirstChild("finish")
    if target then
        TeleportTo(target.FinishGLow.CFrame + Vector3.new(0, 5, 0))
    else
        -- Запасной вариант если структура другая
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "FinishingLine" or v.Name == "WinPart" then
                TeleportTo(v.CFrame + Vector3.new(0, 5, 0))
                break
            end
        end
    end
end)

-- Visuals
AddToggle(VisPg, "🎯 Player Highlights", function(v)
    Config.Visuals = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("BHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "BHighlight"
            h.Enabled = v
        end
    end
end)

-- Misc
AddToggle(MiscPg, "🛡️ Anti-Lava", function(v)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name == "kill" or part.Name == "Lava") then
            part.CanTouch = not v
        end
    end
end)

AddToggle(MiscPg, "💨 No Fog", function(v)
    game:GetService("Lighting").FogEnd = v and 100000 or 500
end)

-- Drag System
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
