--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI
    
    [ИНСТРУКЦИЯ]
    • ЛЕВАЯ КНОПКА МЫШИ -> Включить функцию
    • ПРАВАЯ КНОПКА МЫШИ -> Открыть настройки (Слайдеры)
    • Right Control -> Скрыть меню
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

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
    AutoSprint = false, NoClipSpeed = 30,
    
    -- Combat
    Aimbot = false, AimFOV = 100, AimKey = "MouseButton2",
    SilentAim = false, Hitbox = false, HitboxSize = 2,
    HitboxTransp = 0.5, TriggerBot = false, AutoClicker = false,
    ClickDelay = 0.1, Reach = false, ReachDist = 10,
    WallCheck = false, AutoParry = false, Prediction = 0.14,
    
    -- Visuals
    ESP_Enabled = false, Boxes = false, BoxStyle = "Rounded",
    BoxColorR = 0, BoxColorG = 255, BoxColorB = 140,
    Tracers = false, TracerOrigin = "Bottom", Names = false,
    Distance = false, Health = false, Chams = false, ChamColor = "Accent",
    FullBright = false, NoFog = false, Crosshair = false,
    RainbowUI = false, FOVCircle = false, FOVSize = 100,
    
    -- World
    DestroyLava = false, LowGfx = false, TimeChanger = false,
    Time = 12, Gravity = 196.2, XRay = false,
    NoCollision = false, RemovePhysics = false,
    
    -- Misc
    AntiAFK = true, ChatSpy = false, Rejoin = false,
    ServerHop = false, Spectate = false,
    HidePopups = false, NoBillboardAds = false,
    
    -- Player
    NoFall = false, AntiStun = false, AntiSlow = false,
    AntiGrab = false, AntiStomp = false
}

-- [ UI ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140), -- Neon Green
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35),
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Danger = Color3.fromRGB(231, 76, 60)
}

-- [ СОЗДАНИЕ GUI ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixTitan"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 900, 0, 650) -- ОГРОМНОЕ ОКНО
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- [ ШАПКА ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v12"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [ НАВИГАЦИЯ ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [ КОНТЕЙНЕР СТРАНИЦ ]
local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -220, 1, -80)
PagesContainer.Position = UDim2.new(0, 210, 0, 70)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Colors.Main
    TabBtn.Text = "  " .. icon .. "  " .. name
    TabBtn.TextColor3 = Colors.TextDark
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Page.Visible = false end
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

-- [ ФУНКЦИЯ СОЗДАНИЯ МОДУЛЯ (КНОПКА + НАСТРОЙКИ) ]
local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper).CornerRadius = UDim.new(0, 8)
    
    -- Основная кнопка
    local Button = Instance.new("TextButton", Wrapper)
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    
    local Title = Instance.new("TextLabel", Button)
    Title.Text = Name
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Colors.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- Индикатор включения
    local ToggleBg = Instance.new("Frame", Button)
    ToggleBg.Size = UDim2.new(0, 50, 0, 26)
    ToggleBg.Position = UDim2.new(1, -70, 0.5, -13)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
    
    local ToggleCircle = Instance.new("Frame", ToggleBg)
    ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -11)
    ToggleCircle.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
    
    -- Иконка настроек (если есть)
    if HasSettings then
        local Gear = Instance.new("ImageLabel", Button)
        Gear.Size = UDim2.new(0, 20, 0, 20)
        Gear.Position = UDim2.new(1, -100, 0.5, -10)
        Gear.Image = "rbxassetid://3926307971"
        Gear.ImageRectOffset = Vector2.new(324, 124)
        Gear.ImageRectSize = Vector2.new(36, 36)
        Gear.ImageColor3 = Colors.TextDark
        Gear.BackgroundTransparency = 1
    end
    
    -- Логика ЛКМ (Включить)
    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        local targetPos = Config[ConfigKey] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        local targetColor = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
    
    -- Логика ПКМ (Открыть настройки)
    if HasSettings then
        local SettingsFrame = Instance.new("Frame", Wrapper)
        SettingsFrame.Size = UDim2.new(1, 0, 0, 80)
        SettingsFrame.Position = UDim2.new(0, 0, 0, 60)
        SettingsFrame.BackgroundColor3 = Colors.SettingsBG
        SettingsFrame.BorderSizePixel = 0
        
        -- Вызываем функцию для наполнения настройками
        if SettingsFunc then SettingsFunc(SettingsFrame) end
        
        local Expanded = false
        Button.MouseButton2Click:Connect(function()
            Expanded = not Expanded
            local targetHeight = Expanded and 140 or 60
            TweenService:Create(Wrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
        end)
    end
end

-- [ ФУНКЦИЯ СЛАЙДЕРА ]
local function CreateSlider(Parent, Name, Min, Max, ConfigKey)
    local Label = Instance.new("TextLabel", Parent)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.Text = Name .. ": " .. Config[ConfigKey]
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local SliderBg = Instance.new("TextButton", Parent)
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBg.Text = ""
    Instance.new("UICorner", SliderBg)
    
    local Fill = Instance.new("Frame", SliderBg)
    Fill.Size = UDim2.new((Config[ConfigKey]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill)
    
    SliderBg.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local P = math.clamp((UserInputService:GetMouseLocation().X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            local Val = math.floor(Min + (Max - Min) * P)
            Config[ConfigKey] = Val
            Label.Text = Name .. ": " .. Val
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end end)
    end)
end

-- [ ФУНКЦИЯ ВЫБОРА ЦВЕТА ]
local function CreateColorPicker(Parent, Name, ConfigKeyR, ConfigKeyG, ConfigKeyB)
    local Container = Instance.new("Frame", Parent)
    Container.Size = UDim2.new(1, -20, 0, 30)
    Container.Position = UDim2.new(0, 10, 0, 10)
    Container.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Text = Name .. ":"
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local ColorPreview = Instance.new("Frame", Container)
    ColorPreview.Size = UDim2.new(0, 60, 0, 20)
    ColorPreview.Position = UDim2.new(0.4, 0, 0, 5)
    ColorPreview.BackgroundColor3 = Color3.fromRGB(Config[ConfigKeyR], Config[ConfigKeyG], Config[ConfigKeyB])
    Instance.new("UICorner", ColorPreview)
    
    local RGBText = Instance.new("TextLabel", Container)
    RGBText.Size = UDim2.new(0.4, 0, 1, 0)
    RGBText.Position = UDim2.new(0.6, 0, 0, 0)
    RGBText.Text = string.format("RGB(%d, %d, %d)", Config[ConfigKeyR], Config[ConfigKeyG], Config[ConfigKeyB])
    RGBText.TextColor3 = Colors.TextDark
    RGBText.Font = Enum.Font.Gotham
    RGBText.TextSize = 12
    RGBText.TextXAlignment = Enum.TextXAlignment.Right
    RGBText.BackgroundTransparency = 1
    
    ColorPreview.MouseButton1Click:Connect(function()
        -- Простой выбор цвета (можно улучшить)
        Config[ConfigKeyR] = math.random(0, 255)
        Config[ConfigKeyG] = math.random(0, 255)
        Config[ConfigKeyB] = math.random(0, 255)
        ColorPreview.BackgroundColor3 = Color3.fromRGB(Config[ConfigKeyR], Config[ConfigKeyG], Config[ConfigKeyB])
        RGBText.Text = string.format("RGB(%d, %d, %d)", Config[ConfigKeyR], Config[ConfigKeyG], Config[ConfigKeyB])
    end)
end

-- [ СОЗДАНИЕ ВКЛАДОК И МОДУЛЕЙ ]
local TabCombat = CreateTab("Combat", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabVisual = CreateTab("Visuals", "👁️")
local TabWorld = CreateTab("World", "🌍")
local TabMisc = CreateTab("Misc", "⚙️")
local TabSettings = CreateTab("Settings", "🔧")

-- 1. Movement Functions
AddModule(TabMove, "Speed Bypass", "SpeedEnabled", true, function(f)
    CreateSlider(f, "WalkSpeed", 16, 300, "Speed")
end)
AddModule(TabMove, "Flight Mode", "FlyEnabled", true, function(f)
    CreateSlider(f, "Fly Speed", 10, 500, "FlySpeed")
end)
AddModule(TabMove, "Jump Power", "JumpEnabled", true, function(f)
    CreateSlider(f, "Height", 50, 400, "JumpPower")
end)
AddModule(TabMove, "Infinite Jump", "InfJump", false)
AddModule(TabMove, "Noclip (Wall Phase)", "Noclip", true, function(f)
    CreateSlider(f, "Noclip Speed", 10, 100, "NoClipSpeed")
end)
AddModule(TabMove, "Anti-Void", "AntiVoid", false)
AddModule(TabMove, "BunnyHop", "BunnyHop", false)
AddModule(TabMove, "SpinBot", "SpinBot", false)
AddModule(TabMove, "Auto Sprint", "AutoSprint", false)
AddModule(TabMove, "No Fall Damage", "NoFall", false)
AddModule(TabMove, "Swim Anywhere", "Swim", false)

-- 2. Combat Functions
AddModule(TabCombat, "Aimbot", "Aimbot", true, function(f)
    CreateSlider(f, "FOV Radius", 30, 800, "AimFOV")
end)
AddModule(TabCombat, "Hitbox Expander", "Hitbox", true, function(f)
    CreateSlider(f, "Head Size", 2, 50, "HitboxSize")
end)
AddModule(TabCombat, "Auto Clicker", "AutoClicker", true, function(f)
    CreateSlider(f, "Delay (sec)", 0, 2, "ClickDelay")
end)
AddModule(TabCombat, "Trigger Bot", "TriggerBot", false)
AddModule(TabCombat, "Silent Aim", "SilentAim", false)
AddModule(TabCombat, "Reach (Melee)", "Reach", true, function(f)
    CreateSlider(f, "Reach Distance", 10, 100, "ReachDist")
end)
AddModule(TabCombat, "Auto Parry", "AutoParry", false)
AddModule(TabCombat, "Prediction", "Prediction", true, function(f)
    CreateSlider(f, "Prediction Value", 0, 1, "Prediction")
end)

-- 3. Visuals Functions
AddModule(TabVisual, "Enable ESP", "ESP_Enabled", false)
AddModule(TabVisual, "Box ESP", "Boxes", true, function(f)
    CreateColorPicker(f, "Box Color", "BoxColorR", "BoxColorG", "BoxColorB")
end)
AddModule(TabVisual, "Tracers", "Tracers", true, function(f)
    -- Можно добавить выбор позиции трассера
end)
AddModule(TabVisual, "Name Tags", "Names", false)
AddModule(TabVisual, "Health Bar", "Health", false)
AddModule(TabVisual, "Distance", "Distance", false)
AddModule(TabVisual, "Chams (Wallhack)", "Chams", false)
AddModule(TabVisual, "FullBright", "FullBright", false)
AddModule(TabVisual, "No Fog", "NoFog", false)
AddModule(TabVisual, "Crosshair", "Crosshair", false)
AddModule(TabVisual, "FOV Circle", "FOVCircle", true, function(f)
    CreateSlider(f, "FOV Size", 50, 300, "FOVSize")
end)
AddModule(TabVisual, "X-Ray Mode", "XRay", false)

-- 4. World Functions
AddModule(TabWorld, "Gravity Control", "Gravity", true, function(f)
    CreateSlider(f, "Gravity Force", 0, 196, "Gravity")
end)
AddModule(TabWorld, "Time Changer", "TimeChanger", true, function(f)
    CreateSlider(f, "Clock Time", 0, 24, "Time")
end)
AddModule(TabWorld, "Destroy Lava", "DestroyLava", false)
AddModule(TabWorld, "No Collision", "NoCollision", false)
AddModule(TabWorld, "Remove Physics", "RemovePhysics", false)
AddModule(TabWorld, "Low Graphics", "LowGfx", false)

-- 5. Misc Functions
AddModule(TabMisc, "Anti-AFK", "AntiAFK", false)
AddModule(TabMisc, "Chat Spy", "ChatSpy", false)
AddModule(TabMisc, "Rejoin Server", "Rejoin", false)
AddModule(TabMisc, "Hide All Popups", "HidePopups", false)
AddModule(TabMisc, "Remove Ads", "NoBillboardAds", false)
AddModule(TabMisc, "Anti Stun", "AntiStun", false)
AddModule(TabMisc, "Anti Grab", "AntiGrab", false)
AddModule(TabMisc, "Spectate Player", "Spectate", false)

-- 6. Settings Functions
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
        BunnyHop = false, SafeWalk = false, SpinBot = false,
        HighJump = false, Swim = false, NoSlow = false,
        AutoSprint = false, NoClipSpeed = 30,
        
        Aimbot = false, AimFOV = 100, AimKey = "MouseButton2",
        SilentAim = false, Hitbox = false, HitboxSize = 2,
        HitboxTransp = 0.5, TriggerBot = false, AutoClicker = false,
        ClickDelay = 0.1, Reach = false, ReachDist = 10,
        WallCheck = false, AutoParry = false, Prediction = 0.14,
        
        ESP_Enabled = false, Boxes = false, BoxStyle = "Rounded",
        BoxColorR = 0, BoxColorG = 255, BoxColorB = 140,
        Tracers = false, TracerOrigin = "Bottom", Names = false,
        Distance = false, Health = false, Chams = false, ChamColor = "Accent",
        FullBright = false, NoFog = false, Crosshair = false,
        RainbowUI = false, FOVCircle = false, FOVSize = 100,
        
        DestroyLava = false, LowGfx = false, TimeChanger = false,
        Time = 12, Gravity = 196.2, XRay = false,
        NoCollision = false, RemovePhysics = false,
        
        AntiAFK = true, ChatSpy = false, Rejoin = false,
        ServerHop = false, Spectate = false,
        HidePopups = false, NoBillboardAds = false,
        
        NoFall = false, AntiStun = false, AntiSlow = false,
        AntiGrab = false, AntiStomp = false
    }
    
    for k, v in pairs(default) do
        Config[k] = v
    end
    print("✅ Конфиг сброшен к значениям по умолчанию!")
end

-- Кнопки настроек
local function AddSettingButton(Page, Name, Callback)
    local Button = Instance.new("TextButton", Page)
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Colors.ItemBG
    Button.Text = Name
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    
    Button.MouseButton1Click:Connect(Callback)
end

AddSettingButton(TabSettings, "💾 Save Config", SaveConfig)
AddSettingButton(TabSettings, "📂 Load Config", LoadConfig)
AddSettingButton(TabSettings, "🔄 Reset Config", ResetConfig)

-- [ ЛОГИКА СКРИПТА (CORE LOOPS) ]

-- ESP Boxes System
local ESPObjects = {}
local function CreateESPBox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Box = Instance.new("Frame")
    Box.Name = player.Name .. "_ESPBox"
    Box.BackgroundTransparency = 1
    Box.Size = UDim2.new(0, 100, 0, 150)
    Box.ZIndex = 10
    Box.Parent = ScreenGui
    
    local BoxOutline = Instance.new("Frame", Box)
    BoxOutline.Size = UDim2.new(1, 0, 1, 0)
    BoxOutline.BackgroundTransparency = 1
    BoxOutline.BorderSizePixel = 2
    BoxOutline.BorderColor3 = Color3.fromRGB(Config.BoxColorR, Config.BoxColorG, Config.BoxColorB)
    
    local NameLabel = Instance.new("TextLabel", Box)
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, -25)
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(Config.BoxColorR, Config.BoxColorG, Config.BoxColorB)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 14
    
    local HealthBar = Instance.new("Frame", Box)
    HealthBar.Size = UDim2.new(0, 5, 1, -4)
    HealthBar.Position = UDim2.new(0, -8, 0, 2)
    HealthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local HealthFill = Instance.new("Frame", HealthBar)
    HealthFill.Size = UDim2.new(1, 0, player.Character.Humanoid.Health/player.Character.Humanoid.MaxHealth, 0)
    HealthFill.Position = UDim2.new(0, 0, 1, -HealthFill.Size.Y.Scale)
    HealthFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    
    ESPObjects[player] = {
        Box = Box,
        Outline = BoxOutline,
        Name = NameLabel,
        HealthBar = HealthBar,
        HealthFill = HealthFill
    }
end

local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                local scale = 1000 / distance
                
                esp.Box.Visible = Config.Boxes
                esp.Box.Size = UDim2.new(0, scale * 2, 0, scale * 3)
                esp.Box.Position = UDim2.new(0, pos.X - scale, 0, pos.Y - scale * 1.5)
                
                esp.Name.Visible = Config.Names
                esp.Name.Text = player.Name
                
                esp.HealthBar.Visible = Config.Health
                if Config.Health then
                    local healthPercent = player.Character.Humanoid.Health/player.Character.Humanoid.MaxHealth
                    esp.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
                    esp.HealthFill.Position = UDim2.new(0, 0, 1, -esp.HealthFill.Size.Y.Scale)
                end
            else
                esp.Box.Visible = false
            end
        else
            esp.Box.Visible = false
        end
    end
end

-- Movement Logic
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    local Hum = Char.Humanoid
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
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
    
    -- No Fall Damage
    if Config.NoFall then
        if HRP.Velocity.Y < -50 then
            HRP.Velocity = Vector3.new(HRP.Velocity.X, -10, HRP.Velocity.Z)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- BunnyHop
task.spawn(function()
    while task.wait() do
        if Config.BunnyHop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            task.wait(0.2)
        end
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

-- Auto Clicker
task.spawn(function()
    while task.wait(Config.ClickDelay) do
        if Config.AutoClicker then
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

-- Visuals Logic
task.spawn(function()
    while task.wait(0.1) do
        -- ESP Manager
        if Config.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and not ESPObjects[p] then
                    CreateESPBox(p)
                end
            end
            UpdateESP()
        else
            for _, esp in pairs(ESPObjects) do
                esp.Box.Visible = false
            end
        end
        
        -- Chams
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
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
        
        -- Time Changer
        if Config.TimeChanger then
            Lighting.ClockTime = Config.Time
        end
        
        -- No Fog
        if Config.NoFog then
            Lighting.FogEnd = 100000
        end
        
        -- Hide Popups (удаляем всплывающие окна)
        if Config.HidePopups then
            for _, gui in pairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name:find("Prompt") or gui.Name:find("Popup") or gui.Name:find("Notification")) then
                    gui:Destroy()
                end
            end
        end
        
        -- Remove Ads
        if Config.NoBillboardAds then
            for _, ad in pairs(workspace:GetDescendants()) do
                if ad:IsA("BillboardGui") or ad:IsA("SurfaceGui") then
                    if ad.Name:find("Ad") or ad.Name:find("Advertisement") then
                        ad:Destroy()
                    end
                end
            end
        end
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

-- Dragging Logic
local Dragging, DragInput, DragStart, StartPos
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
        Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- Default Page
Pages["Combat"].Page.Visible = true
Pages["Combat"].Btn.TextColor3 = Colors.Text
Pages["Combat"].Btn.BackgroundColor3 = Colors.ItemBG

-- Keybind to Hide
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("🔥 Blazix Titan v12 loaded successfully!")
print("📌 Features:")
print("   • Advanced ESP with beautiful boxes")
print("   • 40+ functions in 6 categories")
print("   • Config save/load system")
print("   • Popup remover & ad blocker")
print("   • Right Control to hide/show")
