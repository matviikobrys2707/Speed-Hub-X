--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTOR: GEMINI AI
]]

-- Инициализация сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Локальные переменные
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Конфигурация
local Config = {
    SpeedEnabled = false,
    Speed = 16,
    FlyEnabled = false,
    FlySpeed = 50,
    JumpEnabled = false,
    JumpPower = 50,
    InfJump = false,
    Noclip = false,
    AntiVoid = false,
    BunnyHop = false,
    SpinBot = false,
    Hitbox = false,
    HitboxSize = 2,
    HitboxTransp = 0.5,
    TriggerBot = false,
    AutoClicker = false,
    ClickDelay = 0.1,
    ESP_Enabled = false,
    Boxes = false,
    Tracers = false,
    Names = false,
    Chams = false,
    FullBright = false,
    NoFog = false,
    Crosshair = false,
    DestroyLava = false,
    Gravity = 196.2,
    XRay = false,
    AntiAFK = true,
    ChatSpy = false
}

-- Цвета интерфейса
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    CardBG = Color3.fromRGB(30, 30, 38)
}

-- Создание основного GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixTitanV12"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 800, 0, 550)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
MainFrame.BackgroundColor3 = Colors.Main
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Colors.Accent
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0
Header.Parent = MainFrame

-- Название
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX TITAN v12"
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Colors.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = Header

-- Скругление для кнопки закрытия
local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

-- Боковая панель
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Контейнер вкладок
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.Parent = Sidebar

-- Layout для вкладок
local TabList = Instance.new("UIListLayout")
TabList.Name = "TabList"
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabContainer

-- Основной контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -190, 1, -70)
ContentFrame.Position = UDim2.new(0, 190, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Контейнер для модулей
local ModulesContainer = Instance.new("ScrollingFrame")
ModulesContainer.Name = "ModulesContainer"
ModulesContainer.Size = UDim2.new(1, 0, 1, 0)
ModulesContainer.BackgroundTransparency = 1
ModulesContainer.ScrollBarThickness = 4
ModulesContainer.Parent = ContentFrame

-- Сетка для модулей
local ModulesGrid = Instance.new("UIGridLayout")
ModulesGrid.Name = "ModulesGrid"
ModulesGrid.CellSize = UDim2.new(0.48, 0, 0, 100)
ModulesGrid.CellPadding = UDim2.new(0, 10, 0, 10)
ModulesGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
ModulesGrid.Parent = ModulesContainer

-- Словарь страниц
local Pages = {}

-- Функция создания вкладки
local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0.9, 0, 0, 45)
    TabButton.BackgroundColor3 = Colors.Main
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 30, 1, 0)
    IconLabel.Position = UDim2.new(0, 10, 0, 0)
    IconLabel.Text = icon
    IconLabel.TextColor3 = Colors.TextDark
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 20
    IconLabel.BackgroundTransparency = 1
    IconLabel.Parent = TabButton
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "Name"
    NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    NameLabel.Position = UDim2.new(0, 45, 0, 0)
    NameLabel.Text = name
    NameLabel.TextColor3 = Colors.TextDark
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextSize = 16
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.Parent = TabButton
    
    Pages[name] = {
        Button = TabButton,
        Icon = IconLabel,
        Label = NameLabel,
        Active = false
    }
    
    return TabButton
end

-- Функция активации вкладки
local function ActivateTab(tabName)
    for name, data in pairs(Pages) do
        if name == tabName then
            data.Button.BackgroundColor3 = Colors.ItemBG
            data.Icon.TextColor3 = Colors.Accent
            data.Label.TextColor3 = Colors.Text
            data.Active = true
        else
            data.Button.BackgroundColor3 = Colors.Main
            data.Icon.TextColor3 = Colors.TextDark
            data.Label.TextColor3 = Colors.TextDark
            data.Active = false
        end
    end
end

-- Функция создания карточки модуля
local function CreateModuleCard(name, configKey, hasSettings)
    local Card = Instance.new("Frame")
    Card.Name = name .. "Card"
    Card.Size = UDim2.new(1, 0, 0, 100)
    Card.BackgroundColor3 = Colors.CardBG
    Card.Parent = ModulesContainer
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Colors.ItemBG
    CardStroke.Thickness = 1
    CardStroke.Parent = Card
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.7, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 15, 0, 15)
    TitleLabel.Text = name
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Card
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(0, 50, 0, 24)
    ToggleFrame.Position = UDim2.new(1, -70, 0, 15)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleFrame.Parent = Card
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "ToggleCircle"
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleFrame
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Description"
    DescLabel.Size = UDim2.new(0.8, 0, 0, 40)
    DescLabel.Position = UDim2.new(0, 15, 0, 45)
    DescLabel.Text = "ЛКМ: Включить | ПКМ: Настройки"
    DescLabel.TextColor3 = Colors.TextDark
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.BackgroundTransparency = 1
    DescLabel.Parent = Card
    
    -- Обработка кликов
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Config[configKey] = not Config[configKey]
            
            local targetPosition = Config[configKey] and UDim2.new(1, -28, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local targetColor = Config[configKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
            
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = targetPosition
            }):Play()
            
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = targetColor
            }):Play()
            
            if Config[configKey] then
                CardStroke.Color = Colors.Accent
                CardStroke.Thickness = 2
            else
                CardStroke.Color = Colors.ItemBG
                CardStroke.Thickness = 1
            end
        end
    end)
    
    return Card
end

-- Создание вкладок
local tabs = {
    {Name = "Combat", Icon = "⚔️"},
    {Name = "Movement", Icon = "🏃"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "World", Icon = "🌍"},
    {Name = "Misc", Icon = "⚙️"}
}

for _, tab in ipairs(tabs) do
    local tabButton = CreateTab(tab.Name, tab.Icon)
    
    tabButton.MouseButton1Click:Connect(function()
        ActivateTab(tab.Name)
    end)
end

-- Создание модулей
local modules = {
    {"Speed Hack", "SpeedEnabled", true},
    {"Fly Mode", "FlyEnabled", true},
    {"High Jump", "JumpEnabled", true},
    {"Infinite Jump", "InfJump", false},
    {"Noclip", "Noclip", false},
    {"Anti-Void", "AntiVoid", false},
    {"Aimbot", "Aimbot", true},
    {"Hitbox Expander", "Hitbox", true},
    {"Trigger Bot", "TriggerBot", false},
    {"ESP", "ESP_Enabled", false},
    {"Chams", "Chams", false},
    {"FullBright", "FullBright", false}
}

for _, module in ipairs(modules) do
    CreateModuleCard(module[1], module[2], module[3])
end

-- Обработчики событий

-- Закрытие GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Перетаскивание окна
local dragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = UDim2.new(0, 0, 0, 0)

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale, 
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, 
            frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Показать/скрыть по RightControl
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Логика функций

-- Движение
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Speed Hack
    if Config.SpeedEnabled and humanoid.MoveDirection.Magnitude > 0 then
        character:TranslateBy(humanoid.MoveDirection * Config.Speed / 100)
    end
    
    -- Fly Mode
    if Config.FlyEnabled then
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            rootPart.Velocity = direction.Unit * Config.FlySpeed
        else
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
        
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
    end
    
    -- High Jump
    if Config.JumpEnabled then
        humanoid.JumpPower = Config.JumpPower
    end
    
    -- Noclip
    if Config.Noclip then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Anti-Void
    if Config.AntiVoid and rootPart.Position.Y < -50 then
        rootPart.CFrame = CFrame.new(rootPart.Position.X, 100, rootPart.Position.Z)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Hitbox Expander
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if Config.Hitbox then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        root.Transparency = Config.HitboxTransp
                        root.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- FullBright
task.spawn(function()
    while true do
        task.wait(1)
        
        if Config.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        end
    end
end)

-- Gravity
task.spawn(function()
    while true do
        task.wait(0.5)
        workspace.Gravity = Config.Gravity
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end)

-- Инициализация
ActivateTab("Combat")
MainFrame.Visible = true

print("BLAZIX TITAN v12 успешно загружен!")
print("Управление:")
print("RightControl - Показать/скрыть меню")
print("ЛКМ на модуле - Включить/выключить")
