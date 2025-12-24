--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI
    OPTIMIZED VERSION
]]

-- Защищённое получение сервисов
local success, services = pcall(function()
    return {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        CoreGui = game:GetService("CoreGui"),
        TweenService = game:GetService("TweenService"),
        Lighting = game:GetService("Lighting"),
        VirtualInputManager = game:GetService("VirtualInputManager"),
        HttpService = game:GetService("HttpService"),
        TeleportService = game:GetService("TeleportService"),
        TextChatService = game:GetService("TextChatService"),
        StarterGui = game:GetService("StarterGui")
    }
end)

if not success then
    warn("❌ Не удалось получить сервисы:", services)
    return
end

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local CoreGui = services.CoreGui
local TweenService = services.TweenService
local Lighting = services.Lighting
local VirtualInputManager = services.VirtualInputManager
local HttpService = services.HttpService
local TeleportService = services.TeleportService

-- Получаем LocalPlayer с защитой
local LocalPlayer
local function GetLocalPlayer()
    local maxAttempts = 10
    for i = 1, maxAttempts do
        local player = Players.LocalPlayer
        if player then
            return player
        end
        task.wait(0.5)
    end
    return nil
end

LocalPlayer = GetLocalPlayer()
if not LocalPlayer then
    warn("❌ LocalPlayer не найден!")
    return
end

-- Получаем Camera с защитой
local Camera
local function GetCamera()
    local maxAttempts = 10
    for i = 1, maxAttempts do
        local cam = workspace.CurrentCamera
        if cam then
            return cam
        end
        task.wait(0.5)
    end
    return workspace.CurrentCamera
end

Camera = GetCamera()

print("🚀 Загрузка Blazix Titan v12...")

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    BunnyHop = false, SpinBot = false,
    AutoSprint = false, NoClipSpeed = 30,
    
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2,
    HitboxTransp = 0.5, AutoClicker = false,
    ClickDelay = 0.1, Reach = false, ReachDist = 10,
    AutoParry = false, Prediction = 0.14,
    
    ESP_Enabled = false, Boxes = false,
    BoxColorR = 0, BoxColorG = 255, BoxColorB = 140,
    Tracers = false, Names = false,
    Health = false, Chams = false,
    FullBright = false, NoFog = false, Crosshair = false,
    FOVCircle = false, FOVSize = 100,
    
    DestroyLava = false, LowGfx = false, TimeChanger = false,
    Time = 12, Gravity = 196.2, XRay = false,
    NoCollision = false,
    
    AntiAFK = true, ChatSpy = false, Rejoin = false,
    ServerHop = false, Spectate = false, AutoRejoin = false,
    HidePopups = false, NoBillboardAds = false,
    
    NoFall = false, AntiStun = false,
    AntiGrab = false
}

-- [ СОЗДАНИЕ GUI С ЗАЩИТОЙ ]
local ScreenGui, Main
local function CreateGUI()
    local success, result = pcall(function()
        -- Создаём ScreenGui в правильном месте
        local targetParent = CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not targetParent then
            targetParent = Instance.new("ScreenGui")
            targetParent.Parent = game:GetService("StarterGui")
        end
        
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BlazixTitanV12"
        ScreenGui.Parent = targetParent
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 999999 -- Максимальный приоритет
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        
        -- Основной фрейм
        Main = Instance.new("Frame")
        Main.Name = "MainFrame"
        Main.Size = UDim2.new(0, 900, 0, 650)
        Main.Position = UDim2.new(0.5, -450, 0.5, -325)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Main.BorderSizePixel = 0
        Main.ClipsDescendants = true
        Main.Visible = true -- Явно включаем видимость
        Main.Active = true
        Main.Selectable = true
        Main.Parent = ScreenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = Main
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 140)
        stroke.Thickness = 2
        stroke.Parent = Main
        
        return true
    end)
    
    if not success then
        warn("❌ Ошибка создания GUI:", result)
        return false
    end
    return true
end

-- Запускаем создание GUI
if not CreateGUI() then
    warn("❌ Не удалось создать графический интерфейс")
    return
end

print("✅ GUI создан успешно!")

-- [ СОЗДАНИЕ КОМПОНЕНТОВ GUI ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35)
}

-- Шапка
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v12"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Кнопка скрытия
local HideBtn = Instance.new("TextButton")
HideBtn.Name = "HideButton"
HideBtn.Size = UDim2.new(0, 40, 0, 40)
HideBtn.Position = UDim2.new(1, -100, 0.5, -20)
HideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
HideBtn.Text = "━"
HideBtn.TextColor3 = Colors.Text
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 18
HideBtn.AutoButtonColor = true
HideBtn.Parent = Header

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 6)
hideCorner.Parent = HideBtn

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseButton"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = true
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- Боковая панель
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Colors.Accent
TabContainer.Parent = Sidebar

local TabList = Instance.new("UIListLayout")
TabList.Name = "TabList"
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Parent = TabContainer

-- Контейнер страниц
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, -220, 1, -80)
PagesContainer.Position = UDim2.new(0, 210, 0, 70)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = Main

-- Панель пользователя
local UserPanel = Instance.new("Frame")
UserPanel.Name = "UserPanel"
UserPanel.Size = UDim2.new(0, 200, 0, 80)
UserPanel.Position = UDim2.new(0, 0, 1, -80)
UserPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UserPanel.BorderSizePixel = 0
UserPanel.Parent = Main

-- [ ФУНКЦИИ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ ]
local Pages = {}

local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Colors.Accent
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = PagesContainer
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Colors.Main
    TabBtn.Text = "  " .. icon .. "  " .. name
    TabBtn.TextColor3 = Colors.TextDark
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = true
    TabBtn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do 
            p.Page.Visible = false 
        end
        
        for _, t in pairs(TabContainer:GetChildren()) do 
            if t:IsA("TextButton") then 
                t.TextColor3 = Colors.TextDark 
                t.BackgroundColor3 = Colors.Main
            end 
        end
        
        Page.Visible = true
        TabBtn.TextColor3 = Colors.Text
        TabBtn.BackgroundColor3 = Colors.ItemBG
    end)
    
    Pages[name] = {Page = Page, Btn = TabBtn}
    return Page
end

local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame")
    Wrapper.Name = Name .. "Wrapper"
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Wrapper.Parent = Page
    
    local wrapperCorner = Instance.new("UICorner")
    wrapperCorner.CornerRadius = UDim.new(0, 8)
    wrapperCorner.Parent = Wrapper
    
    local Button = Instance.new("TextButton")
    Button.Name = Name .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Wrapper
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = Name
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Button
    
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Name = "ToggleBg"
    ToggleBg.Size = UDim2.new(0, 50, 0, 26)
    ToggleBg.Position = UDim2.new(1, -70, 0.5, -13)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBg.Parent = Button
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = ToggleBg
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "ToggleCircle"
    ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -11)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = ToggleCircle
    
    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        local targetPos = Config[ConfigKey] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        local targetColor = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- Создаём вкладки
local TabCombat = CreateTab("Combat", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabVisual = CreateTab("Visuals", "👁️")
local TabWorld = CreateTab("World", "🌍")
local TabMisc = CreateTab("Misc", "⚙️")
local TabSettings = CreateTab("Settings", "🔧")

-- Добавляем модули
AddModule(TabMove, "Speed Bypass", "SpeedEnabled", false)
AddModule(TabMove, "Flight Mode", "FlyEnabled", false)
AddModule(TabMove, "Jump Power", "JumpEnabled", false)
AddModule(TabMove, "Infinite Jump", "InfJump", false)
AddModule(TabMove, "Noclip", "Noclip", false)
AddModule(TabCombat, "Aimbot", "Aimbot", false)
AddModule(TabCombat, "Hitbox Expander", "Hitbox", false)
AddModule(TabVisual, "Enable ESP", "ESP_Enabled", false)
AddModule(TabVisual, "Box ESP", "Boxes", false)
AddModule(TabWorld, "Gravity Control", "Gravity", false)
AddModule(TabWorld, "Time Changer", "TimeChanger", false)
AddModule(TabMisc, "Anti-AFK", "AntiAFK", false)
AddModule(TabMisc, "Server Hop", "ServerHop", false)

-- Устанавливаем активную вкладку
if Pages["Combat"] and Pages["Combat"].Page then
    Pages["Combat"].Page.Visible = true
    Pages["Combat"].Btn.TextColor3 = Colors.Text
    Pages["Combat"].Btn.BackgroundColor3 = Colors.ItemBG
end

-- [ ОБРАБОТЧИКИ СОБЫТИЙ ]
HideBtn.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
    print("📌 Меню: " .. (Main.Visible and "Показано" or "Скрыто"))
end)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
    print("❌ Меню закрыто")
end)

-- Перетаскивание окна
local Dragging = false
local DragStart = Vector2.new(0, 0)
local StartPos = UDim2.new(0, 0, 0, 0)

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        local Delta = input.Position - DragStart
        Main.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- Горячая клавиша для скрытия (Left Alt)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        Main.Visible = not Main.Visible
        print("🔑 Left Alt: Меню " .. (Main.Visible and "показано" or "скрыто"))
    end
end)

-- [ ОСНОВНАЯ ЛОГИКА СКРИПТА ]
local ESPObjects = {}
local MovementConnections = {}

-- Движение
local function SetupMovement()
    local connection = RunService.Heartbeat:Connect(function()
        local Char = LocalPlayer.Character
        if not Char then return end
        
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        local HRP = Char:FindFirstChild("HumanoidRootPart")
        if not Hum or not HRP then return end
        
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
        
        -- Noclip
        if Config.Noclip then
            for _, p in pairs(Char:GetDescendants()) do
                if p:IsA("BasePart") then 
                    p.CanCollide = false 
                end
            end
        end
    end)
    
    table.insert(MovementConnections, connection)
end

-- ESP
local function SetupESP()
    local espConnection = RunService.RenderStepped:Connect(function()
        if not Config.ESP_Enabled then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        if not ESPObjects[player] then
                            local espFrame = Instance.new("Frame")
                            espFrame.BackgroundTransparency = 1
                            espFrame.Size = UDim2.new(0, 100, 0, 150)
                            espFrame.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 75)
                            espFrame.Parent = ScreenGui
                            
                            ESPObjects[player] = espFrame
                        else
                            ESPObjects[player].Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 75)
                            ESPObjects[player].Visible = Config.Boxes
                        end
                    elseif ESPObjects[player] then
                        ESPObjects[player].Visible = false
                    end
                end
            end
        end
    end)
    
    table.insert(MovementConnections, espConnection)
end

-- World
local function SetupWorld()
    local worldConnection = RunService.Heartbeat:Connect(function()
        -- Gravity
        workspace.Gravity = Config.Gravity
        
        -- Time
        if Config.TimeChanger then
            Lighting.ClockTime = Config.Time
        end
        
        -- Fullbright
        if Config.FullBright then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end
        
        -- Destroy Lava
        if Config.DestroyLava then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Lava" or v.Name == "KillPart" then 
                    v:Destroy() 
                end
            end
        end
    end)
    
    table.insert(MovementConnections, worldConnection)
end

-- Запускаем системы
task.spawn(function()
    SetupMovement()
    SetupESP()
    SetupWorld()
end)

-- [ ФУНКЦИИ НАСТРОЕК ]
local function SaveConfig()
    local success, result = pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile("blazix_config.json", json)
        print("✅ Конфиг сохранен!")
    end)
    if not success then
        print("❌ Ошибка сохранения:", result)
    end
end

local function LoadConfig()
    local success, result = pcall(function()
        if isfile("blazix_config.json") then
            local json = readfile("blazix_config.json")
            local loaded = HttpService:JSONDecode(json)
            for k, v in pairs(loaded) do
                Config[k] = v
            end
            print("✅ Конфиг загружен!")
        else
            print("⚠️ Файл конфига не найден!")
        end
    end)
    if not success then
        print("❌ Ошибка загрузки:", result)
    end
end

local function ResetConfig()
    local default = {
        SpeedEnabled = false, Speed = 16,
        FlyEnabled = false, FlySpeed = 50,
        JumpEnabled = false, JumpPower = 50,
        InfJump = false, Noclip = false, AntiVoid = false,
        BunnyHop = false, SpinBot = false,
        AutoSprint = false, NoClipSpeed = 30,
        
        Aimbot = false, AimFOV = 100,
        Hitbox = false, HitboxSize = 2,
        HitboxTransp = 0.5, AutoClicker = false,
        ClickDelay = 0.1, Reach = false, ReachDist = 10,
        AutoParry = false, Prediction = 0.14,
        
        ESP_Enabled = false, Boxes = false,
        BoxColorR = 0, BoxColorG = 255, BoxColorB = 140,
        Tracers = false, Names = false,
        Health = false, Chams = false,
        FullBright = false, NoFog = false, Crosshair = false,
        FOVCircle = false, FOVSize = 100,
        
        DestroyLava = false, LowGfx = false, TimeChanger = false,
        Time = 12, Gravity = 196.2, XRay = false,
        NoCollision = false,
        
        AntiAFK = true, ChatSpy = false, Rejoin = false,
        ServerHop = false, Spectate = false, AutoRejoin = false,
        HidePopups = false, NoBillboardAds = false,
        
        NoFall = false, AntiStun = false,
        AntiGrab = false
    }
    
    for k, v in pairs(default) do
        Config[k] = v
    end
    print("✅ Конфиг сброшен!")
end

-- [ УВЕДОМЛЕНИЕ О ЗАПУСКЕ ]
task.spawn(function()
    task.wait(0.5)
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "StartNotification"
    NotificationGui.Parent = ScreenGui.Parent
    NotificationGui.DisplayOrder = 1000000
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 80)
    MainFrame.Position = UDim2.new(1, -320, 1, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = NotificationGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 5, 1, 0)
    AccentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = MainFrame
    
    Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 10)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.Text = "BLAZIX TITAN v12"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = MainFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(1, -20, 0, 40)
    MessageLabel.Position = UDim2.new(0, 15, 0, 35)
    MessageLabel.Text = "Blazix Hub successfully loaded!\nPress Left Alt to hide/show menu."
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 14
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Parent = MainFrame
    
    -- Анимация появления
    MainFrame.Position = UDim2.new(1, 350, 1, -100)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -100)
    }):Play()
    
    -- Закрытие
    task.wait(5)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 350, 1, -100)
    }):Play()
    task.wait(0.5)
    NotificationGui:Destroy()
end)

-- [ УБЕРАЕМ МЕНЮ ПРИ ВЫХОДЕ ИЗ ИГРЫ ]
LocalPlayer.CharacterRemoving:Connect(function()
    for _, conn in pairs(MovementConnections) do
        conn:Disconnect()
    end
    
    for _, obj in pairs(ESPObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end)

-- [ ФИНАЛЬНОЕ СООБЩЕНИЕ ]
print("✅ Blazix Titan v12 успешно загружен!")
print("📌 Меню должно быть видно на экране")
print("📌 Используйте Left Alt для скрытия/показа")
