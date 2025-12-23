--[[
    BLAZIX OMNI V11 - GIGANT & SMART SETTINGS
    ПРАВАЯ КНОПКА МЫШИ (ПКМ) ПО ФУНКЦИИ = ОТКРЫТЬ НАСТРОЙКИ
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ТЕМА (МАССИВНАЯ И ТЕМНАЯ)
local Theme = {
    Main = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(0, 255, 150),
    Element = Color3.fromRGB(25, 25, 35),
    Text = Color3.fromRGB(255, 255, 255),
    SettingsBG = Color3.fromRGB(20, 20, 25)
}

-- ГЛОБАЛЬНЫЙ КОНФИГ (ИЗ ТВОЕГО ФАЙЛА)
local CFG = {
    Speed = 100, Jump = 150, FlySpd = 100,
    HSize = 2, ESP_Enabled = false,
    Fly = false, Noclip = false, AntiVoid = false,
    InfiniteJump = false, HighJump = false, FullBright = false
}

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Blazix_V11_Gigant"

-- ГЛАВНОЕ ОКНО (БОЛЬШОЕ)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 850, 0, 600) -- Увеличенный размер
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Theme.Main
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Theme.Accent
Stroke.Thickness = 3

-- ХЕДЕР
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 30, 0, 0)
Title.Text = "BLAZIX <font color='#00ff96'>OMNI</font> V11: GIGANT"
Title.RichText = true
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28 -- Жирный шрифт
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- КОНТЕЙНЕР (СКРОЛЛИНГ)
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -40, 1, -100)
Container.Position = UDim2.new(0, 20, 0, 80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 6
Container.CanvasSize = UDim2.new(0, 0, 2, 0)
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 15)

-- УМНЫЙ МОДУЛЬ С ПКМ-МЕНЮ
local function AddModule(name, flag, settings_content)
    local ModuleFrame = Instance.new("Frame", Container)
    ModuleFrame.Size = UDim2.new(1, -15, 0, 70) -- Большая база
    ModuleFrame.BackgroundColor3 = Theme.Element
    ModuleFrame.ClipsDescendants = true
    Instance.new("UICorner", ModuleFrame).CornerRadius = UDim.new(0, 10)
    
    local MainBtn = Instance.new("TextButton", ModuleFrame)
    MainBtn.Size = UDim2.new(1, 0, 0, 70)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = ""

    local Label = Instance.new("TextLabel", MainBtn)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 20
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    -- Тоггл (Визуальный переключатель)
    local ToggleBG = Instance.new("Frame", MainBtn)
    ToggleBG.Size = UDim2.new(0, 60, 0, 30)
    ToggleBG.Position = UDim2.new(1, -80, 0.5, -15)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", ToggleBG)
    Dot.Size = UDim2.new(0, 24, 0, 24)
    Dot.Position = UDim2.new(0, 3, 0.5, -12)
    Dot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    -- Настройки (Скрытая панель)
    local SettingsArea = Instance.new("Frame", ModuleFrame)
    SettingsArea.Size = UDim2.new(1, -40, 0, 100)
    SettingsArea.Position = UDim2.new(0, 20, 0, 75)
    SettingsArea.BackgroundColor3 = Theme.SettingsBG
    Instance.new("UICorner", SettingsArea)
    
    -- Логика ЛКМ (Включить)
    MainBtn.MouseButton1Click:Connect(function()
        CFG[flag] = not CFG[flag]
        local targetX = CFG[flag] and 33 or 3
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, targetX, 0.5, -12)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = CFG[flag] and Theme.Accent or Color3.fromRGB(150, 150, 150)}):Play()
    end)

    -- Логика ПКМ (Развернуть настройки)
    local expanded = false
    MainBtn.MouseButton2Click:Connect(function()
        expanded = not expanded
        local targetHeight = expanded and 190 or 70
        TweenService:Create(ModuleFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -15, 0, targetHeight)}):Play()
    end)

    if settings_content then settings_content(SettingsArea) end
end

-- СЛАЙДЕР ДЛЯ НАСТРОЕК
local function AddSlider(parent, text, min, max, key)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.Size = UDim2.new(1, 0, 0, 30)
    Lbl.Text = text .. ": " .. CFG[key]
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 16
    Lbl.BackgroundTransparency = 1

    local Bar = Instance.new("TextButton", parent)
    Bar.Size = UDim2.new(0.9, 0, 0, 10)
    Bar.Position = UDim2.new(0.05, 0, 0.6, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Bar.Text = ""
    Instance.new("UICorner", Bar)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((CFG[key]-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", Fill)

    Bar.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local per = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(per, 0, 1, 0)
            local val = math.floor(min + (max - min) * per)
            CFG[key] = val
            Lbl.Text = text .. ": " .. val
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
    end)
end

-- [ НАПОЛНЕНИЕ ]
AddModule("⚡ Speed (Bypass)", "SpeedEnabled", function(area)
    AddSlider(area, "WalkSpeed Value", 16, 500, "Speed")
end)

AddModule("🚀 Flight Mode", "Fly", function(area)
    AddSlider(area, "Fly Velocity", 10, 500, "FlySpd")
end)

AddModule("🦘 High Jump Power", "HighJump", function(area)
    AddSlider(area, "Jump Power", 50, 500, "Jump")
end)

AddModule("🎯 Hitbox Expander", "Hitbox", function(area)
    AddSlider(area, "Hitbox Size", 2, 60, "HSize")
end)

AddModule("👁️ ESP Master", "ESP_Enabled")
AddModule("👻 Noclip (Walls)", "Noclip")
AddModule("🛡️ Anti-Void Protection", "AntiVoid")

-- [ ЛОГИКА (ИЗ ТВОЕГО ФАЙЛА) ]
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Speed
    if CFG.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        char:TranslateBy(hum.MoveDirection * (CFG.Speed / 100))
    end
    
    -- Fly
    if CFG.Fly then
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        hrp.Velocity = dir * CFG.FlySpd
    end

    -- Anti-Void
    if CFG.AntiVoid and hrp.Position.Y < -100 then
        hrp.Velocity = Vector3.zero
        hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
    end
end)

-- СВОРАЧИВАНИЕ
local Minimized = false
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Minimized = not Minimized
        Main.Visible = not Minimized
    end
end)

-- ЗАКРЫТЬ
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -60, 0, 15)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Theme.Text
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

-- ПЕРЕТАСКИВАНИЕ
local dragStart, startPos, dragging
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
    local d = i.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
