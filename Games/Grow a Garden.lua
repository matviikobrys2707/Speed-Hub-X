--[[
    BLAZIX OMNI V9 - TITANIC EDITION
    UI/UX REVOLUTION 2025
    STRICTLY FOR HIGH-END EXECUTORS
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ЦВЕТОВАЯ ПАЛИТРА (NEON NIGHT)
local Theme = {
    Main = Color3.fromRGB(10, 10, 15),
    Accent = Color3.fromRGB(0, 255, 150),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(150, 150, 150),
    Element = Color3.fromRGB(20, 20, 25)
}

-- CONFIG
local Config = {
    Speed = 16, Jump = 50, FlySpeed = 50,
    HitboxSize = 2, ESP_Enabled = false,
    Fly = false, Noclip = false, AntiVoid = false
}

-- ИНИЦИАЛИЗАЦИЯ GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Blazix_V9_Lux"

-- КНОПКА СВЕРНУТЬ (SIDEBAR ICON)
local MinButton = Instance.new("TextButton", ScreenGui)
MinButton.Size = UDim2.new(0, 45, 0, 45)
MinButton.Position = UDim2.new(0, 10, 0.4, 0)
MinButton.BackgroundColor3 = Theme.Main
MinButton.Text = "⚡"
MinButton.TextColor3 = Theme.Accent
MinButton.TextSize = 25
MinButton.Visible = false
Instance.new("UICorner", MinButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinButton).Color = Theme.Accent

-- ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 750, 0, 500)
Main.Position = UDim2.new(0.5, -375, 0.5, -250)
Main.BackgroundColor3 = Theme.Main
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ВЕРХНЯЯ ПАНЕЛЬ (HEADER)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Text = "BLAZIX <font color='#00ff96'>OMNI</font> V9"
Title.RichText = true
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -50, 0, 12)
Close.Text = "×"
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.TextColor3 = Theme.Text
Close.TextSize = 25
Instance.new("UICorner", Close)

local Hide = Instance.new("TextButton", Header)
Hide.Size = UDim2.new(0, 35, 0, 35)
Hide.Position = UDim2.new(1, -95, 0, 12)
Hide.Text = "—"
Hide.BackgroundColor3 = Theme.Element
Hide.TextColor3 = Theme.Text
Instance.new("UICorner", Hide)

-- ЛЕВАЯ ПАНЕЛЬ (NAV)
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(0, 180, 1, -80)
Nav.Position = UDim2.new(0, 15, 0, 70)
Nav.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", Nav)
NavList.Padding = UDim.new(0, 10)

-- КОНТЕЙНЕР ДЛЯ ФУНКЦИЙ
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -220, 1, -80)
Container.Position = UDim2.new(0, 205, 0, 70)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0,0,2,0)
local ContentList = Instance.new("UIListLayout", Container)
ContentList.Padding = UDim.new(0, 12)

-- ФУНКЦИЯ СОЗДАНИЯ СЛОЖНОЙ КНОПКИ (С НАСТРОЙКАМИ ВНУТРИ)
local function AddSmartModule(parent, name, flag, settings_func)
    local ModuleFrame = Instance.new("Frame", parent)
    ModuleFrame.Size = UDim2.new(1, -10, 0, 50) -- Начальная высота
    ModuleFrame.BackgroundColor3 = Theme.Element
    ModuleFrame.ClipsDescendants = true
    Instance.new("UICorner", ModuleFrame)
    
    local MainBtn = Instance.new("TextButton", ModuleFrame)
    MainBtn.Size = UDim2.new(1, 0, 0, 50)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = ""
    
    local Label = Instance.new("TextLabel", MainBtn)
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Status = Instance.new("Frame", MainBtn)
    Status.Size = UDim2.new(0, 40, 0, 20)
    Status.Position = UDim2.new(1, -110, 0.5, -10)
    Status.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", Status)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local SettingsBtn = Instance.new("TextButton", MainBtn)
    SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
    SettingsBtn.Position = UDim2.new(1, -50, 0.5, -15)
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = Theme.DarkText
    SettingsBtn.BackgroundTransparency = 1
    SettingsBtn.TextSize = 20

    -- Логика включения
    MainBtn.MouseButton1Click:Connect(function()
        Config[flag] = not Config[flag]
        local targetPos = Config[flag] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetCol = Config[flag] and Theme.Accent or Color3.fromRGB(100, 100, 100)
        TweenService:Create(Dot, TweenInfo.new(0.3), {Position = targetPos, BackgroundColor3 = targetCol}):Play()
    end)

    -- Разворот настроек
    local expanded = false
    SettingsBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        local targetSize = expanded and UDim2.new(1, -10, 0, 150) or UDim2.new(1, -10, 0, 50)
        TweenService:Create(ModuleFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    end)

    -- Контейнер для слайдеров внутри
    local SettingsArea = Instance.new("Frame", ModuleFrame)
    SettingsArea.Size = UDim2.new(1, -20, 0, 90)
    SettingsArea.Position = UDim2.new(0, 10, 0, 55)
    SettingsArea.BackgroundTransparency = 1
    
    if settings_func then settings_func(SettingsArea) end
end

-- ВСПОМОГАТЕЛЬНЫЙ СЛАЙДЕР ДЛЯ НАСТРОЕК
local function AddInternalSlider(parent, text, min, max, key)
    local Label = Instance.new("TextLabel", parent)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. ": " .. Config[key]
    Label.TextColor3 = Theme.DarkText
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14

    local Bar = Instance.new("TextButton", parent)
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Bar.Text = ""
    Instance.new("UICorner", Bar)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((Config[key]-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", Fill)

    Bar.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local per = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(per, 0, 1, 0)
            local val = math.floor(min + (max - min) * per)
            Config[key] = val
            Label.Text = text .. ": " .. val
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
    end)
end

-- [ НАПОЛНЕНИЕ МОДУЛЯМИ ]

-- 1. SPEED
AddSmartModule(Container, "Super Speed (Bypass)", "SpeedEnabled", function(area)
    AddInternalSlider(area, "Velocity Value", 16, 300, "Speed")
end)

-- 2. JUMP
AddSmartModule(Container, "Mega Jump Power", "JumpEnabled", function(area)
    AddInternalSlider(area, "Jump Height", 50, 500, "Jump")
end)

-- 3. FLY
AddSmartModule(Container, "God Flight", "Fly", function(area)
    AddInternalSlider(area, "Flight Speed", 10, 500, "FlySpeed")
end)

-- 4. COMBAT
AddSmartModule(Container, "Hitbox Expander", "HitboxEnabled", function(area)
    AddInternalSlider(area, "Radius Size", 2, 50, "HitboxSize")
end)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Speed logic
    if Config.SpeedEnabled and char.Humanoid.MoveDirection.Magnitude > 0 then
        char:TranslateBy(char.Humanoid.MoveDirection * (Config.Speed / 100))
    end
    
    -- Hitboxes
    if Config.HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end
end)

-- DRAG & HIDE
Hide.MouseButton1Click:Connect(function() Main.Visible = false MinButton.Visible = true end)
MinButton.MouseButton1Click:Connect(function() Main.Visible = true MinButton.Visible = false end)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Перетаскивание
local dragging, dStart, sPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dStart = i.Position sPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
