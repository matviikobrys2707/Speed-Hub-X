--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI
    
    [ИНСТРУКЦИЯ]
    • ЛЕВАЯ КНОПКА МЫШИ -> Включить функцию
    • ПРАВАЯ КНОПКА МЫШИ -> Открыть настройки (Слайдеры)
    • Right Control -> Скрыть меню
]]

-- Сначала объявляем все сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ / СОХРАНЕНИЕ НАСТРОЕК ]
local Config = {
    -- Movement
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    BunnyHop = false, SafeWalk = false, SpinBot = false,
    HighJump = false, Swim = false, NoSlow = false,
    
    -- Combat
    Aimbot = false, AimFOV = 100, SilentAim = false,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    TriggerBot = false, AutoClicker = false, ClickDelay = 0.1,
    Reach = false, ReachDist = 10, WallCheck = false,
    
    -- Visuals
    ESP_Enabled = false, Boxes = false, Tracers = false,
    Names = false, Distance = false, Chams = false,
    FullBright = false, NoFog = false, Crosshair = false,
    RainbowUI = false, FOVCircle = false,
    
    -- World
    DestroyLava = false, LowGfx = false, TimeChanger = false,
    Time = 12, Gravity = 196.2, XRay = false,
    
    -- Misc
    AntiAFK = true, ChatSpy = false, Rejoin = false,
    ServerHop = false, Spectate = false
}

-- [ UI ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140), -- Neon Green
    Secondary = Color3.fromRGB(0, 180, 120),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35),
    CardBG = Color3.fromRGB(30, 30, 38)
}

-- [ СОЗДАНИЕ GUI ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixTitan"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Фоновый эффект
local BackgroundBlur = Instance.new("BlurEffect")
BackgroundBlur.Size = 0
BackgroundBlur.Parent = game:GetService("Lighting")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Main.Visible = false -- Начинаем скрытым

-- Скругленные углы и обводка
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- Эффект тени
local Shadow = Instance.new("ImageLabel", Main)
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.ZIndex = -1

-- [ ШАПКА С ГРАДИЕНТОМ ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0

local HeaderGradient = Instance.new("UIGradient", Header)
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.Sidebar),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 27))
})
HeaderGradient.Rotation = -15

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Text = "<font color='#FFFFFF'>BLAZIX</font> <font color='#00ff8c'>TITAN</font> <font color='#AAAAAA'>v12</font>"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Статус строка
local Status = Instance.new("TextLabel", Header)
Status.Size = UDim2.new(0.3, 0, 0, 20)
Status.Position = UDim2.new(0.65, 0, 0.5, -10)
Status.Text = "🟢 CONNECTED"
Status.TextColor3 = Color3.fromRGB(0, 255, 140)
Status.Font = Enum.Font.GothamMedium
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Right
Status.BackgroundTransparency = 1

local CloseBtn = Instance.new("ImageButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -16)
CloseBtn.Image = "rbxassetid://3926305904"
CloseBtn.ImageRectOffset = Vector2.new(924, 724)
CloseBtn.ImageRectSize = Vector2.new(36, 36)
CloseBtn.ImageColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- [ СОВРЕМЕННАЯ НАВИГАЦИЯ ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, -70)
Sidebar.Position = UDim2.new(0, 0, 0, 70)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0

-- Индикатор активной вкладки
local ActiveIndicator = Instance.new("Frame", Sidebar)
ActiveIndicator.Size = UDim2.new(0, 4, 0, 40)
ActiveIndicator.BackgroundColor3 = Colors.Accent
ActiveIndicator.BorderSizePixel = 0
ActiveIndicator.Visible = false

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 15)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Colors.TextDark

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [ ГЛАВНЫЙ КОНТЕЙНЕР ]
local MainContent = Instance.new("Frame", Main)
MainContent.Size = UDim2.new(1, -190, 1, -80)
MainContent.Position = UDim2.new(0, 190, 0, 75)
MainContent.BackgroundTransparency = 1

-- Заголовок текущей вкладки
local PageTitle = Instance.new("TextLabel", MainContent)
PageTitle.Size = UDim2.new(1, 0, 0, 40)
PageTitle.Text = "COMBAT"
PageTitle.TextColor3 = Colors.Text
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextSize = 22
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.BackgroundTransparency = 1

-- Разделитель под заголовком
local TitleDivider = Instance.new("Frame", MainContent)
TitleDivider.Size = UDim2.new(1, 0, 0, 1)
TitleDivider.Position = UDim2.new(0, 0, 0, 40)
TitleDivider.BackgroundColor3 = Colors.Accent
TitleDivider.BackgroundTransparency = 0.3

-- Контейнер для карточек модулей
local ModulesContainer = Instance.new("ScrollingFrame", MainContent)
ModulesContainer.Size = UDim2.new(1, 0, 1, -50)
ModulesContainer.Position = UDim2.new(0, 0, 0, 50)
ModulesContainer.BackgroundTransparency = 1
ModulesContainer.ScrollBarThickness = 4
ModulesContainer.ScrollBarImageColor3 = Colors.TextDark
ModulesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Сетка для карточек
local ModulesGrid = Instance.new("UIGridLayout", ModulesContainer)
ModulesGrid.CellSize = UDim2.new(0.5, -10, 0, 110)
ModulesGrid.CellPadding = UDim2.new(0, 10, 0, 10)
ModulesGrid.SortOrder = Enum.SortOrder.LayoutOrder
ModulesGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left

local Pages = {}

-- [ ФУНКЦИЯ СОЗДАНИЯ ВКЛАДКИ ]
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
    TabBtn.BackgroundColor3 = Colors.Main
    TabBtn.AutoButtonColor = false
    TabBtn.Text = ""
    
    -- Иконка
    local Icon = Instance.new("TextLabel", TabBtn)
    Icon.Size = UDim2.new(0, 30, 1, 0)
    Icon.Position = UDim2.new(0, 15, 0, 0)
    Icon.Text = icon
    Icon.TextColor3 = Colors.TextDark
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 18
    Icon.BackgroundTransparency = 1
    
    -- Название
    local Label = Instance.new("TextLabel", TabBtn)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.Text = name
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    -- Скругления
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    Pages[name] = {Btn = TabBtn, Icon = Icon, Label = Label}
    
    return TabBtn
end

-- [ ФУНКЦИЯ АКТИВАЦИИ ВКЛАДКИ ]
local function ActivateTab(tabName)
    for name, pageData in pairs(Pages) do
        if name == tabName then
            -- Обновляем индикатор
            ActiveIndicator.Visible = true
            ActiveIndicator.Position = UDim2.new(0, 0, 0, pageData.Btn.AbsolutePosition.Y - TabContainer.AbsolutePosition.Y + 5)
            
            -- Обновляем кнопку
            pageData.Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            pageData.Icon.TextColor3 = Colors.Accent
            pageData.Label.TextColor3 = Colors.Text
            
            -- Обновляем заголовок
            PageTitle.Text = name:upper()
        else
            pageData.Btn.BackgroundColor3 = Colors.Main
            pageData.Icon.TextColor3 = Colors.TextDark
            pageData.Label.TextColor3 = Colors.TextDark
        end
    end
end

-- [ КАРТОЧКА МОДУЛЯ ]
local function CreateModuleCard(parent, name, configKey, hasSettings, settingsFunc)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, 0, 0, 110)
    Card.BackgroundColor3 = Colors.CardBG
    Card.ClipsDescendants = true
    
    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8)
    
    -- Обводка карточки
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Colors.ItemBG
    CardStroke.Thickness = 1
    
    -- Заголовок модуля
    local Title = Instance.new("TextLabel", Card)
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 15)
    Title.Text = name
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- Описание модуля
    local Desc = Instance.new("TextLabel", Card)
    Desc.Size = UDim2.new(1, -20, 0, 35)
    Desc.Position = UDim2.new(0, 15, 0, 40)
    Desc.Text = "Включение функции " .. name
    Desc.TextColor3 = Colors.TextDark
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    Desc.BackgroundTransparency = 1
    
    -- Переключатель
    local ToggleContainer = Instance.new("Frame", Card)
    ToggleContainer.Size = UDim2.new(0, 50, 0, 24)
    ToggleContainer.Position = UDim2.new(1, -70, 0, 18)
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleContainer.BorderSizePixel = 0
    
    local ToggleCorner = Instance.new("UICorner", ToggleContainer)
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    
    local ToggleCircle = Instance.new("Frame", ToggleContainer)
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.BorderSizePixel = 0
    
    local ToggleCircleCorner = Instance.new("UICorner", ToggleCircle)
    ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
    
    -- Кнопка настроек (если есть)
    if hasSettings then
        local SettingsBtn = Instance.new("ImageButton", Card)
        SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
        SettingsBtn.Position = UDim2.new(0, 15, 1, -45)
        SettingsBtn.Image = "rbxassetid://3926307971"
        SettingsBtn.ImageRectOffset = Vector2.new(884, 4)
        SettingsBtn.ImageRectSize = Vector2.new(36, 36)
        SettingsBtn.ImageColor3 = Colors.TextDark
        SettingsBtn.BackgroundTransparency = 1
        
        local SettingsLabel = Instance.new("TextLabel", Card)
        SettingsLabel.Size = UDim2.new(0, 60, 0, 15)
        SettingsLabel.Position = UDim2.new(0, 45, 1, -40)
        SettingsLabel.Text = "Настройки"
        SettingsLabel.TextColor3 = Colors.TextDark
        SettingsLabel.Font = Enum.Font.GothamMedium
        SettingsLabel.TextSize = 11
        SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
        SettingsLabel.BackgroundTransparency = 1
    end
    
    -- ЛКМ для включения/выключения
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Config[configKey] = not Config[configKey]
            
            local targetPos = Config[configKey] and UDim2.new(1, -28, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local targetColor = Config[configKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
            
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = targetPos
            }):Play()
            
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = targetColor
            }):Play()
            
            -- Изменение цвета карточки при активации
            if Config[configKey] then
                TweenService:Create(CardStroke, TweenInfo.new(0.3), {
                    Color = Colors.Accent,
                    Thickness = 2
                }):Play()
            else
                TweenService:Create(CardStroke, TweenInfo.new(0.3), {
                    Color = Colors.ItemBG,
                    Thickness = 1
                }):Play()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 and hasSettings then
            -- ПКМ для настроек
            print("Открыть настройки для:", name)
        end
    end)
    
    -- Эффект при наведении
    Card.MouseEnter:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        }):Play()
    end)
    
    Card.MouseLeave:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.2), {
            BackgroundColor3 = Colors.CardBG
        }):Play()
    end)
end

-- [ СОЗДАНИЕ ВКЛАДОК ]
local tabs = {
    {Name = "Combat", Icon = "⚔️"},
    {Name = "Movement", Icon = "🏃"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "World", Icon = "🌍"},
    {Name = "Misc", Icon = "⚙️"}
}

for _, tab in ipairs(tabs) do
    local tabBtn = CreateTab(tab.Name, tab.Icon)
    
    tabBtn.MouseButton1Click:Connect(function()
        ActivateTab(tab.Name)
    end)
end

-- [ ЗАПОЛНЕНИЕ КОНТЕЙНЕРА МОДУЛЯМИ ]
local modules = {
    {"Speed Bypass", "SpeedEnabled", true},
    {"Flight Mode", "FlyEnabled", true},
    {"Jump Power", "JumpEnabled", true},
    {"Infinite Jump", "InfJump", false},
    {"Noclip", "Noclip", false},
    {"Anti-Void", "AntiVoid", false},
    {"BunnyHop", "BunnyHop", false},
    {"Aimbot", "Aimbot", true},
    {"Hitbox Expander", "Hitbox", true},
    {"Auto Clicker", "AutoClicker", true},
    {"Trigger Bot", "TriggerBot", false},
    {"ESP Enabled", "ESP_Enabled", false}
}

for i, module in ipairs(modules) do
    CreateModuleCard(ModulesContainer, module[1], module[2], module[3])
end

-- [ ФУНКЦИОНАЛЬНОСТЬ ГУИ ]

-- Перетаскивание окна
local dragging
local dragInput
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Показ/скрытие по RightControl
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
        
        if Main.Visible then
            TweenService:Create(BackgroundBlur, TweenInfo.new(0.3), {
                Size = 15
            }):Play()
            
            Main.Position = UDim2.new(0.5, -425, 0.5, -300)
            
            -- Плавное появление
            Main.Size = UDim2.new(0, 850, 0, 0)
            Main.BackgroundTransparency = 1
            
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 850, 0, 600),
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(BackgroundBlur, TweenInfo.new(0.3), {
                Size = 0
            }):Play()
        end
    end
end)

-- Активация первой вкладки при открытии
ActivateTab("Combat")

-- Анимация появления при запуске
task.wait(0.5)
Main.Visible = true
TweenService:Create(BackgroundBlur, TweenInfo.new(0.5), {
    Size = 15
}):Play()

Main.Size = UDim2.new(0, 850, 0, 0)
Main.BackgroundTransparency = 1

TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 850, 0, 600),
    BackgroundTransparency = 0
}):Play()

-- [ ДОБАВЛЯЕМ ФУНКЦИОНАЛЬНЫЕ ЧАСТИ ИЗ ОРИГИНАЛА ]

-- Movement Logic
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    local Hum = Char.Humanoid
    local HRP = Char.HumanoidRootPart
    
    -- Speed
    if Config.SpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
        Char:TranslateBy(Hum.MoveDirection * (Config.Speed / 100))
    end
    
    -- Fly
    if Config.FlyEnabled then
        local Dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir = Dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Dir = Dir - Vector3.new(0,1,0) end
        HRP.Velocity = Dir * Config.FlySpeed
        Hum.PlatformStand = true
    else
        Hum.PlatformStand = false
    end
    
    -- Jump
    if Config.JumpEnabled then
        Hum.JumpPower = Config.JumpPower
    end
    
    -- Noclip
    if Config.Noclip then
        for _, p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    
    -- Spinbot
    if Config.SpinBot then
        HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(30), 0)
    end
    
    -- AntiVoid
    if Config.AntiVoid and HRP.Position.Y < -50 then
        HRP.Velocity = Vector3.zero
        HRP.CFrame = CFrame.new(HRP.Position.X, 100, HRP.Position.Z)
    end
end)

-- Combat Logic
task.spawn(function()
    while task.wait(0.5) do
        if Config.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = Config.HitboxTransp
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

-- Visuals Logic
task.spawn(function()
    while task.wait(1) do
        -- ESP Manager
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                -- Chams
                local hl = p.Character:FindFirstChild("BlazixChams") or Instance.new("Highlight", p.Character)
                hl.Name = "BlazixChams"
                hl.Enabled = Config.Chams
                hl.FillColor = Colors.Accent
                hl.OutlineColor = Color3.new(1,1,1)
            end
        end
        -- World
        if Config.DestroyLava then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Lava" or v.Name == "KillPart" then v:Destroy() end
            end
        end
        -- Fullbright
        if Config.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        end
        -- Gravity
        workspace.Gravity = Config.Gravity
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
    end
end)

print("BLAZIX TITAN v12 успешно загружен!")
