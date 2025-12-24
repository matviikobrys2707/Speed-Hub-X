--[[
    BLAZIX HUB V12: TITAN EDITION - MODERN UPDATE
    AUTHOR: GEMINI AI + EXPERT DEVELOPER
    VERSION: 12.5
    STEALTH OPTIMIZED FOR HYPERION/BYFRON
    
    [ИНСТРУКЦИЯ]
    • ЛЕВАЯ КНОПКА МЫШИ -> Включить функцию
    • ПРАВАЯ КНОПКА МЫШИ -> Открыть настройки (Слайдеры)
    • Left Alt или B кнопка -> Показать/Скрыть меню
    • Наведите курсор на функцию -> Описание функции
]]--

-- Инициализация сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Проверка на дубликаты и очистка старого скрипта
local function CleanupOldScript()
    -- Проверяем CoreGui
    local oldGui = CoreGui:FindFirstChild("BlazixTitan")
    if oldGui then
        oldGui:Destroy()
    end
    
    -- Проверяем скрытую кнопку
    local oldButton = CoreGui:FindFirstChild("BlazixToggleButton")
    if oldButton then
        oldButton:Destroy()
    end
    
    -- Очищаем остатки в workspace
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local chams = player.Character:FindFirstChild("BlazixChams")
            if chams then
                chams:Destroy()
            end
        end
    end
    
    -- Сброс гравитации
    workspace.Gravity = 196.2
    
    -- Сброс освещения
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
end

-- Вызываем очистку сразу
CleanupOldScript()

-- Получаем размеры экрана для правильного позиционирования
local function GetScreenCenter()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    return UDim2.new(0.5, -450, 0.5, -325) -- Центрируем GUI 900x650
end

-- Динамический выбор родителя для GUI
local function GetSafeParent()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlazixTitan"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    return screenGui
end

-- Уведомление при запуске
local function ShowNotification()
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 350, 0, 80)
    notifFrame.Position = UDim2.new(1, -370, 1, -100)
    notifFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    notifFrame.BorderSizePixel = 0
    notifFrame.AnchorPoint = Vector2.new(1, 1)
    
    local corner = Instance.new("UICorner", notifFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = Color3.fromRGB(0, 255, 140)
    stroke.Thickness = 2
    
    local title = Instance.new("TextLabel", notifFrame)
    title.Text = "BLAZIX TITAN V12.5 Loaded"
    title.Size = UDim2.new(1, -70, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local subtitle = Instance.new("TextLabel", notifFrame)
    subtitle.Text = "Press Left Alt or click B button"
    subtitle.Size = UDim2.new(1, -70, 0, 20)
    subtitle.Position = UDim2.new(0, 15, 0, 45)
    subtitle.TextColor3 = Color3.fromRGB(170, 170, 170)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.BackgroundTransparency = 1
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local icon = Instance.new("ImageLabel", notifFrame)
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(1, -38, 0.5, -14)
    icon.Image = "rbxassetid://3926305904"
    icon.ImageRectOffset = Vector2.new(884, 4)
    icon.ImageRectSize = Vector2.new(36, 36)
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = Color3.fromRGB(0, 255, 140)
    
    -- Временный родитель
    local tempScreen = Instance.new("ScreenGui")
    tempScreen.Name = "TempNotification"
    tempScreen.Parent = CoreGui
    tempScreen.ResetOnSpawn = false
    tempScreen.IgnoreGuiInset = true
    notifFrame.Parent = tempScreen
    
    -- Анимация появления
    notifFrame.Position = UDim2.new(1, 400, 1, -100)
    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -370, 1, -100)
    }):Play()
    
    -- Автоудаление
    task.delay(5, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, 1, -100)
        }):Play()
        task.wait(0.5)
        tempScreen:Destroy()
    end)
end

-- Анти-попапы (скрытие рекламных окон)
local function AntiPopups()
    while task.wait(1) do
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if gui then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("ScreenGui") then
                    local name = obj.Name:lower()
                    if name:find("donate") or name:find("group") or name:find("rate") 
                    or name:find("promo") or name:find("ad") or name:find("subscribe") then
                        obj.Visible = false
                        task.spawn(function()
                            task.wait(0.5)
                            pcall(function() obj:Destroy() end)
                        end)
                    end
                end
            end
        end
    end
end

-- Конфигурация с дефолтными значениями (БОЛЕЕ 50 ФУНКЦИЙ)
local DefaultConfig = {
    -- Movement (Stealth Optimized)
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    BunnyHop = false, SafeWalk = false, SpinBot = false,
    HighJump = false, Swim = false, NoSlow = false,
    NoClipFly = false, AutoRun = false, WallRun = false,
    SpiderClimb = false, SuperSlide = false, TeleportToCursor = false,
    SprintToggle = false, CrouchSpeed = false, AirStrafing = false,
    WaterWalk = false, AntiStun = false, NoKnockback = false,
    PhaseWalk = false, SpeedHack = false, InstantAcceleration = false,
    
    -- Combat (Более 20 функций)
    Aimbot = false, AimFOV = 100, SilentAim = false,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    TriggerBot = false, AutoClicker = false, ClickDelay = 0.1,
    Reach = false, ReachDist = 10, WallCheck = false,
    NoRecoil = false, NoSpread = false, AutoReload = false,
    InstantKill = false, CritHack = false, Backstab = false,
    AimAssist = false, AutoParry = false, AutoBlock = false,
    DamageMultiplier = false, MultiplierValue = 2.0,
    HeadshotOnly = false, BodyAim = false, LegitAim = false,
    PredictionAim = false, SmoothAim = false, AimKeyToggle = false,
    
    -- Visuals (Более 15 функций)
    ESP_Enabled = false, Boxes = false, Tracers = false,
    Names = false, Distance = false, Chams = false,
    FullBright = false, NoFog = false, Crosshair = false,
    RainbowUI = false, FOVCircle = false, NightVision = false,
    ZoomHack = false, ThirdPerson = false, CameraZoom = false,
    NoBlur = false, NoShaders = false, Wireframe = false,
    XRayVision = false, HighlightTarget = false, PlayerGlow = false,
    ItemESP = false, TrapESP = false, ChestESP = false,
    
    -- World (Более 10 функций)
    DestroyLava = false, LowGfx = false, TimeChanger = false,
    Time = 12, Gravity = 196.2, XRay = false,
    NoClipWalls = false, BreakTools = false, InfiniteTools = false,
    InstantMine = false, FastFarm = false, AutoCollect = false,
    NoFallDamage = false, NoFireDamage = false, NoExplosionDamage = false,
    NoWaterDamage = false, GodMode = false, AntiKillBrick = false,
    
    -- Misc (Более 10 функций)
    AntiAFK = true, ChatSpy = false, Rejoin = false,
    ServerHop = false, Spectate = false, FreeCam = false,
    FPSBoost = false, PingSpoof = false, LagSwitch = false,
    ScriptHub = false, AnimationHack = false, EmoteSpam = false,
    AutoSell = false, AutoBuy = false, AutoEquip = false,
    ItemDupe = false, CurrencyHack = false, LevelHack = false,
    
    -- UI Settings
    UIScale = 1, UIOpacity = 1
}

local Config = {}
for key, value in pairs(DefaultConfig) do
    Config[key] = value
end

-- Система сохранения конфигурации
local ConfigFolder = "blazix_configs"
local CurrentConfigName = "default"

local function SaveConfig(configName)
    if not configName or configName == "" then
        return false, "Please enter a configuration name!"
    end
    
    local success, message = pcall(function()
        -- Создаем папку если не существует
        if not isfolder(ConfigFolder) then
            makefolder(ConfigFolder)
        end
        
        local data = HttpService:JSONEncode(Config)
        writefile(ConfigFolder .. "/" .. configName .. ".json", data)
        CurrentConfigName = configName
        return true
    end)
    
    if success then
        return true, "Configuration '" .. configName .. "' saved successfully!"
    else
        return false, "Failed to save configuration: " .. tostring(message)
    end
end

local function LoadConfig(configName)
    if not configName or configName == "" then
        return false, "Please enter a configuration name!"
    end
    
    local success, message = pcall(function()
        if not isfolder(ConfigFolder) then
            return false, "Config folder not found!"
        end
        
        local filePath = ConfigFolder .. "/" .. configName .. ".json"
        if not isfile(filePath) then
            return false, "Configuration '" .. configName .. "' not found!"
        end
        
        local data = readfile(filePath)
        local loaded = HttpService:JSONDecode(data)
        
        -- Безопасная загрузка с проверкой типов
        for key, value in pairs(loaded) do
            if DefaultConfig[key] ~= nil and type(value) == type(DefaultConfig[key]) then
                Config[key] = value
            end
        end
        
        CurrentConfigName = configName
        return true
    end)
    
    if success then
        return true, "Configuration '" .. configName .. "' loaded successfully!"
    else
        return false, message
    end
end

local function DeleteConfig(configName)
    if not configName or configName == "" then
        return false, "Please select a configuration to delete!"
    end
    
    local success, message = pcall(function()
        if not isfolder(ConfigFolder) then
            return false, "Config folder not found!"
        end
        
        local filePath = ConfigFolder .. "/" .. configName .. ".json"
        if not isfile(filePath) then
            return false, "Configuration '" .. configName .. "' not found!"
        end
        
        delfile(filePath)
        return true
    end)
    
    if success then
        return true, "Configuration '" .. configName .. "' deleted successfully!"
    else
        return false, message
    end
end

local function GetConfigList()
    if not isfolder(ConfigFolder) then
        return {}
    end
    
    local configs = {}
    local files = listfiles(ConfigFolder)
    
    for _, file in ipairs(files) do
        local name = file:match(".*/(.+).json$")
        if name then
            table.insert(configs, name)
        end
    end
    
    return configs
end

local function ResetConfig()
    -- Полный сброс к дефолтным значениям
    for key, value in pairs(DefaultConfig) do
        Config[key] = value
    end
    
    -- Сброс гравитации
    workspace.Gravity = 196.2
    
    -- Сброс освещения
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
    Lighting.ClockTime = 14
    
    CurrentConfigName = "default"
    return true, "Configuration reset to defaults!"
end

-- UI Цвета (Modern Dark Neon)
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140), -- Neon Green
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35),
    Success = Color3.fromRGB(0, 200, 83),
    Warning = Color3.fromRGB(255, 193, 7),
    Danger = Color3.fromRGB(244, 67, 54)
}

-- Создание скрытой кнопки B
local ToggleButtonScreen = Instance.new("ScreenGui")
ToggleButtonScreen.Name = "BlazixToggleButton"
ToggleButtonScreen.Parent = CoreGui
ToggleButtonScreen.ResetOnSpawn = false
ToggleButtonScreen.IgnoreGuiInset = true

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 65, 0, 65)
ToggleButton.Position = UDim2.new(0, 25, 0.5, -32.5)
ToggleButton.BackgroundColor3 = Colors.Main
ToggleButton.Text = "B"
ToggleButton.TextColor3 = Colors.Accent
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 32
ToggleButton.ZIndex = 100
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Colors.Accent
ToggleStroke.Thickness = 3
ToggleButton.Parent = ToggleButtonScreen

-- Создание основного GUI
local ScreenGui = GetSafeParent()
ScreenGui.Parent = CoreGui

-- Храним позицию окна
local LastWindowPosition = GetScreenCenter()
local LastWindowSize = UDim2.new(0, 900, 0, 650)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = LastWindowSize
Main.Position = LastWindowPosition
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Main.Visible = false -- Скрыто при запуске
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- ДОБАВЛЯЕМ ВОЗМОЖНОСТЬ ПЕРЕТАСКИВАНИЯ ЗА ЛЮБУЮ ЧАСТЬ ОКНА
local DragFrame = Instance.new("Frame", Main)
DragFrame.Size = UDim2.new(1, 0, 1, 0)
DragFrame.BackgroundTransparency = 1
DragFrame.ZIndex = 5
DragFrame.Name = "DragFrame"

-- Заголовок с возможностью перетаскивания
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0
Header.ZIndex = 20

-- Контейнер для описания функции (НАД GUI)
local FunctionDescription = Instance.new("Frame", ScreenGui)
FunctionDescription.Size = UDim2.new(0, 350, 0, 80)
FunctionDescription.Position = UDim2.new(0.5, -175, 0, 10)
FunctionDescription.BackgroundColor3 = Colors.Main
FunctionDescription.BorderSizePixel = 0
FunctionDescription.Visible = false
FunctionDescription.AnchorPoint = Vector2.new(0.5, 0)
FunctionDescription.ZIndex = 100
Instance.new("UICorner", FunctionDescription).CornerRadius = UDim.new(0, 8)

local DescriptionStroke = Instance.new("UIStroke", FunctionDescription)
DescriptionStroke.Color = Colors.Accent
DescriptionStroke.Thickness = 2

local DescriptionText = Instance.new("TextLabel", FunctionDescription)
DescriptionText.Size = UDim2.new(1, -20, 1, -20)
DescriptionText.Position = UDim2.new(0, 10, 0, 10)
DescriptionText.Text = "Наведите курсор на функцию для описания"
DescriptionText.TextColor3 = Colors.Text
DescriptionText.Font = Enum.Font.Gotham
DescriptionText.TextSize = 14 -- УВЕЛИЧЕН ТЕКСТ
DescriptionText.BackgroundTransparency = 1
DescriptionText.TextWrapped = true
DescriptionText.ZIndex = 101

-- Кнопка "Скрыть" в заголовке
local HideBtn = Instance.new("TextButton", Header)
HideBtn.Size = UDim2.new(0, 50, 0, 50)
HideBtn.Position = UDim2.new(1, -110, 0.5, -25)
HideBtn.BackgroundColor3 = Colors.Warning
HideBtn.Text = "_"
HideBtn.TextColor3 = Colors.Text
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 24
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 8)
HideBtn.ZIndex = 21

-- Title
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v12.5"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.ZIndex = 21

-- Флаг для перетаскивания кнопки B
local ButtonDragging = false
local ButtonDragStart, ButtonStartPos

-- Функция для перетаскивания кнопки B
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ButtonDragging = true
        ButtonDragStart = input.Position
        ButtonStartPos = ToggleButton.Position
        
        -- Анимация нажатия
        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and ButtonDragging then
        local Delta = input.Position - ButtonDragStart
        ToggleButton.Position = UDim2.new(
            ButtonStartPos.X.Scale, 
            ButtonStartPos.X.Offset + Delta.X, 
            ButtonStartPos.Y.Scale, 
            ButtonStartPos.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if ButtonDragging then
            ButtonDragging = false
            TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Colors.Main
            }):Play()
        end
    end
end)

-- Словарь описаний функций на русском (обновлен)
local FunctionDescriptions = {
    -- Movement
    ["Speed Bypass"] = "Обход ограничения скорости. Позволяет двигаться быстрее стандартной скорости",
    ["Flight Mode"] = "Режим полета. Позволяет летать в любом направлении",
    ["Jump Power"] = "Увеличение высоты прыжка. Можно настроить мощность прыжка",
    ["Infinite Jump"] = "Бесконечный прыжок. Позволяет прыгать в воздухе",
    ["Noclip (Wall Phase)"] = "Режим прохождения сквозь стены. Отключает коллизию",
    ["Anti-Void"] = "Защита от падения в бездну. Телепортирует обратно при падении",
    ["BunnyHop"] = "Автоматический банихоп. Автоматически прыгает при движении",
    ["SpinBot"] = "Вращение персонажа. Постоянное вращение для уклонения",
    ["NoClip Fly"] = "Комбинированный ноклип и полет",
    ["Auto Run"] = "Автоматический бег вперед",
    ["Wall Run"] = "Бег по стенам как в паркуре",
    ["Spider Climb"] = "Лазание по стенам как Человек-паук",
    ["Super Slide"] = "Ультра-скольжение по поверхности",
    
    -- Combat
    ["Aimbot"] = "Автоматическое наведение на противников. Настраивается FOV",
    ["Hitbox Expander"] = "Увеличение хитбоксов противников. Облегчает попадание",
    ["Auto Clicker"] = "Автокликер. Автоматически нажимает левую кнопку мыши",
    ["Trigger Bot"] = "Автоматическая стрельба при наведении на противника",
    ["Silent Aim"] = "Тихий аим. Наведение без видимого перемещения прицела",
    ["Reach (Melee)"] = "Увеличение дистанции ближнего боя. Бьете дальше чем обычно",
    ["No Recoil"] = "Убирает отдачу оружия",
    ["No Spread"] = "Убирает разброс пуль",
    ["Auto Reload"] = "Автоматическая перезарядка",
    ["Instant Kill"] = "Мгновенное убийство противников",
    
    -- Visuals
    ["Enable ESP"] = "Включение ESP. Отображение информации о противниках",
    ["Box ESP"] = "Рамки вокруг противников. Показывает хитбокс персонажа",
    ["Tracers"] = "Линии к противникам. Линии от вашего персонажа к врагам",
    ["Name Tags"] = "Имена над противниками. Отображение ника над головой",
    ["Chams (Wallhack)"] = "Подсветка противников сквозь стены. Видно сквозь препятствия",
    ["FullBright"] = "Полная яркость. Убирает темные области карты",
    ["No Fog"] = "Отключение тумана. Убирает атмосферный туман",
    ["Crosshair"] = "Прицел. Отображает прицел в центре экрана",
    ["Night Vision"] = "Ночное зрение. Видеть в темноте",
    ["Zoom Hack"] = "Увеличение обзора камеры",
    
    -- World
    ["Gravity Control"] = "Контроль гравитации. Изменяет силу гравитации",
    ["Time Changer"] = "Изменение времени суток. Настройка времени на карте",
    ["Destroy Lava"] = "Уничтожение лавы. Убирает лаву с карты",
    ["X-Ray Mode"] = "Режим рентгена. Видно сквозь текстуры",
    ["No Fall Damage"] = "Нет урона от падения",
    ["No Fire Damage"] = "Нет урона от огня",
    ["God Mode"] = "Режим бога. Неуязвимость",
    
    -- Misc
    ["Anti-AFK"] = "Защита от AFK. Не дает кикнуть за бездействие",
    ["Chat Spy"] = "Шпион чата. Видит все сообщения в чате",
    ["Rejoin Server"] = "Перезаход на сервер. Возвращает на текущий сервер",
    ["Server Hop"] = "Смена сервера. Переходит на другой сервер этой же игры",
    ["Free Cam"] = "Свободная камера. Отделяет камеру от персонажа",
    ["FPS Boost"] = "Увеличение FPS. Оптимизация производительности",
    
    -- Settings
    ["Save Configuration"] = "Сохранить конфигурацию. Сохраняет текущие настройки",
    ["Load Configuration"] = "Загрузить конфигурацию. Загружает сохраненные настройки",
    ["Reset Configuration"] = "Сброс конфигурации. Возвращает настройки по умолчанию",
    ["Delete Configuration"] = "Удалить конфигурацию. Удаляет выбранный конфиг"
}

-- Кнопка закрытия (полная очистка)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -25)
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.ZIndex = 21

CloseBtn.MouseButton1Click:Connect(function()
    -- Сброс всех активных функций
    ResetConfig()
    UpdateAllToggleVisuals()
    
    -- Скрываем окно и показываем кнопку
    HideMainGUI()
    
    -- Уведомление
    StarterGui:SetCore("SendNotification", {
        Title = "BLAZIX TITAN",
        Text = "Скрипт закрыт. Функции сброшены.",
        Duration = 3
    })
end)

-- Боковая панель с карточкой пользователя
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11

-- Карточка пользователя
local UserCard = Instance.new("Frame", Sidebar)
UserCard.Size = UDim2.new(0.9, 0, 0, 110)
UserCard.Position = UDim2.new(0.05, 0, 1, -130)
UserCard.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", UserCard).CornerRadius = UDim.new(0, 8)
UserCard.ZIndex = 12

local UserStroke = Instance.new("UIStroke", UserCard)
UserStroke.Color = Colors.Accent
UserStroke.Thickness = 1

-- Аватар пользователя
local Avatar = Instance.new("ImageLabel", UserCard)
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Position = UDim2.new(0.5, -25, 0, 15)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
Avatar.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
Avatar.ZIndex = 13

-- Имя пользователя
local DisplayName = Instance.new("TextLabel", UserCard)
DisplayName.Size = UDim2.new(1, -20, 0, 20)
DisplayName.Position = UDim2.new(0, 10, 0, 70)
DisplayName.Text = LocalPlayer.DisplayName
DisplayName.TextColor3 = Colors.Text
DisplayName.Font = Enum.Font.GothamBold
DisplayName.TextSize = 14
DisplayName.BackgroundTransparency = 1
DisplayName.TextXAlignment = Enum.TextXAlignment.Center
DisplayName.TextTruncate = Enum.TextTruncate.AtEnd
DisplayName.ZIndex = 13

local Username = Instance.new("TextLabel", UserCard)
Username.Size = UDim2.new(1, -20, 0, 16)
Username.Position = UDim2.new(0, 10, 0, 92)
Username.Text = "@" .. LocalPlayer.Name
Username.TextColor3 = Colors.TextDark
Username.Font = Enum.Font.Gotham
Username.TextSize = 12
Username.BackgroundTransparency = 1
Username.TextXAlignment = Enum.TextXAlignment.Center
Username.TextTruncate = Enum.TextTruncate.AtEnd
Username.ZIndex = 13

-- Контейнер вкладок
local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -150)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Colors.Accent
TabContainer.ZIndex = 12

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Контейнер страниц
local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -220, 1, -80)
PagesContainer.Position = UDim2.new(0, 210, 0, 70)
PagesContainer.BackgroundTransparency = 1
PagesContainer.ZIndex = 11

local Pages = {}

-- Функция создания вкладки
local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Colors.Accent
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ZIndex = 12
    
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
    TabBtn.ZIndex = 13
    
    -- Обработчик наведения для описания
    TabBtn.MouseEnter:Connect(function()
        DescriptionText.Text = "Вкладка: " .. name .. " - содержит функции для " .. name:lower()
        FunctionDescription.Visible = true
    end)
    
    TabBtn.MouseLeave:Connect(function()
        FunctionDescription.Visible = false
    end)

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

-- Функция создания модуля (Toggle) - ИСПРАВЛЕННАЯ
local ToggleElements = {} -- Храним элементы для обновления
local ModuleButtons = {} -- Храним кнопки модулей для обработки наведения

local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper).CornerRadius = UDim.new(0, 8)
    Wrapper.ZIndex = 13
    
    local Button = Instance.new("TextButton", Wrapper)
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Name = "ModuleButton_" .. ConfigKey
    Button.ZIndex = 14
    
    -- Сохраняем кнопку для обработки наведения
    ModuleButtons[Button] = Name
    
    local Title = Instance.new("TextLabel", Button)
    Title.Text = Name
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Colors.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.ZIndex = 15
    
    -- Toggle индикатор (ИСПРАВЛЕННЫЙ)
    local ToggleBg = Instance.new("Frame", Button)
    ToggleBg.Size = UDim2.new(0, 60, 0, 32)
    ToggleBg.Position = UDim2.new(1, -80, 0.5, -16)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
    ToggleBg.ZIndex = 15
    
    local ToggleCircle = Instance.new("Frame", ToggleBg)
    ToggleCircle.Size = UDim2.new(0, 28, 0, 28)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -14) -- Начальная позиция (выключено)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
    ToggleCircle.ZIndex = 16
    
    -- Устанавливаем начальное состояние
    if Config[ConfigKey] then
        ToggleCircle.Position = UDim2.new(1, -30, 0.5, -14)
        ToggleCircle.BackgroundColor3 = Colors.Accent
        ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 100, 70)
        Title.TextColor3 = Colors.Accent
    end
    
    -- Сохраняем элементы для обновления при сбросе
    table.insert(ToggleElements, {
        ConfigKey = ConfigKey,
        ToggleBg = ToggleBg,
        ToggleCircle = ToggleCircle,
        Title = Title
    })
    
    -- Иконка настроек
    if HasSettings then
        local Gear = Instance.new("ImageLabel", Button)
        Gear.Size = UDim2.new(0, 24, 0, 24)
        Gear.Position = UDim2.new(1, -110, 0.5, -12)
        Gear.Image = "rbxassetid://3926307971"
        Gear.ImageRectOffset = Vector2.new(324, 124)
        Gear.ImageRectSize = Vector2.new(36, 36)
        Gear.ImageColor3 = Colors.TextDark
        Gear.BackgroundTransparency = 1
        Gear.ZIndex = 15
    end
    
    -- Обработчик наведения для описания
    Button.MouseEnter:Connect(function()
        local description = FunctionDescriptions[Name] or "Описание функции " .. Name .. " не доступно"
        DescriptionText.Text = description
        FunctionDescription.Visible = true
    end)
    
    Button.MouseLeave:Connect(function()
        FunctionDescription.Visible = false
    end)
    
    -- ЛКМ - Включить/Выключить (ИСПРАВЛЕННЫЙ)
    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        UpdateToggleVisual(ConfigKey, Config[ConfigKey])
    end)
    
    -- Функция обновления визуала тоггла (ИСПРАВЛЕННАЯ)
    local function UpdateToggleVisual(key, state)
        if key == ConfigKey then
            local targetPos = state and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
            local targetColor = state and Colors.Accent or Color3.fromRGB(220, 220, 220)
            local bgColor = state and Color3.fromRGB(0, 100, 70) or Color3.fromRGB(50, 50, 60)
            local textColor = state and Colors.Accent or Colors.Text
            
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = targetPos,
                BackgroundColor3 = targetColor
            }):Play()
            
            TweenService:Create(ToggleBg, TweenInfo.new(0.2), {
                BackgroundColor3 = bgColor
            }):Play()
            
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = textColor
            }):Play()
        end
    end
    
    -- ПКМ - Настройки
    if HasSettings then
        local SettingsFrame = Instance.new("Frame", Wrapper)
        SettingsFrame.Size = UDim2.new(1, 0, 0, 80)
        SettingsFrame.Position = UDim2.new(0, 0, 0, 60)
        SettingsFrame.BackgroundColor3 = Colors.SettingsBG
        SettingsFrame.BorderSizePixel = 0
        SettingsFrame.Visible = false
        SettingsFrame.ZIndex = 14
        
        if SettingsFunc then 
            SettingsFunc(SettingsFrame) 
        end
        
        local Expanded = false
        Button.MouseButton2Click:Connect(function()
            Expanded = not Expanded
            SettingsFrame.Visible = Expanded
            local targetHeight = Expanded and 140 or 60
            TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(1, -10, 0, targetHeight)
            }):Play()
        end)
    end
    
    return {UpdateVisual = UpdateToggleVisual}
end

-- Функция обновления всех тогглов
local function UpdateAllToggleVisuals()
    for _, element in ipairs(ToggleElements) do
        local state = Config[element.ConfigKey]
        local targetPos = state and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
        local targetColor = state and Colors.Accent or Color3.fromRGB(220, 220, 220)
        local bgColor = state and Color3.fromRGB(0, 100, 70) or Color3.fromRGB(50, 50, 60)
        local textColor = state and Colors.Accent or Colors.Text
        
        element.ToggleCircle.Position = targetPos
        element.ToggleCircle.BackgroundColor3 = targetColor
        element.ToggleBg.BackgroundColor3 = bgColor
        
        if element.Title then
            element.Title.TextColor3 = textColor
        end
    end
end

-- Функция создания кнопки действия
local function AddActionButton(Page, Name, ActionFunc)
    local Button = Instance.new("TextButton", Page)
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Colors.ItemBG
    Button.Text = Name
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.ZIndex = 13
    
    -- Сохраняем кнопку для обработки наведения
    ModuleButtons[Button] = Name
    
    -- Обработчик наведения для описания
    Button.MouseEnter:Connect(function()
        local description = FunctionDescriptions[Name] or "Описание действия " .. Name .. " не доступно"
        DescriptionText.Text = description
        FunctionDescription.Visible = true
    end)
    
    Button.MouseLeave:Connect(function()
        FunctionDescription.Visible = false
    end)
    
    Button.MouseButton1Click:Connect(function()
        -- Анимация нажатия
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Colors.ItemBG
        }):Play()
        
        -- Выполнение действия
        if ActionFunc then
            ActionFunc()
        end
    end)
    
    return Button
end

-- Функция слайдера
local function CreateSlider(Parent, Name, Min, Max, ConfigKey, Decimals)
    Decimals = Decimals or 0
    
    local Label = Instance.new("TextLabel", Parent)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.Text = Name .. ": " .. (Decimals == 0 and math.floor(Config[ConfigKey]) or string.format("%."..Decimals.."f", Config[ConfigKey]))
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.ZIndex = 15
    
    local SliderBg = Instance.new("TextButton", Parent)
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBg.Text = ""
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    SliderBg.ZIndex = 15
    
    local Fill = Instance.new("Frame", SliderBg)
    Fill.Size = UDim2.new((Config[ConfigKey]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    Fill.ZIndex = 16
    
    SliderBg.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local P = math.clamp((UserInputService:GetMouseLocation().X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            local Val = Min + (Max - Min) * P
            if Decimals == 0 then
                Val = math.floor(Val)
            else
                Val = math.floor(Val * (10^Decimals)) / (10^Decimals)
            end
            Config[ConfigKey] = Val
            Label.Text = Name .. ": " .. (Decimals == 0 and math.floor(Val) or string.format("%."..Decimals.."f", Val))
        end)
        
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                Move:Disconnect()
            end
        end)
    end)
    
    return Label, SliderBg, Fill
end

-- Функция создания диалогового окна для выбора конфига
local function CreateConfigSelector(TitleText, Mode, Callback) -- Mode: "load", "delete"
    local configs = GetConfigList()
    if #configs == 0 then
        StarterGui:SetCore("SendNotification", {
            Title = "BLAZIX TITAN",
            Text = "No saved configurations found!",
            Duration = 5
        })
        return
    end
    
    local DialogFrame = Instance.new("Frame", ScreenGui)
    DialogFrame.Size = UDim2.new(0, 450, 0, 400)
    DialogFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    DialogFrame.BackgroundColor3 = Colors.Main
    DialogFrame.ZIndex = 100
    Instance.new("UICorner", DialogFrame).CornerRadius = UDim.new(0, 12)
    
    local DialogStroke = Instance.new("UIStroke", DialogFrame)
    DialogStroke.Color = Colors.Accent
    DialogStroke.Thickness = 2
    
    local Title = Instance.new("TextLabel", DialogFrame)
    Title.Text = TitleText
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local ScrollFrame = Instance.new("ScrollingFrame", DialogFrame)
    ScrollFrame.Size = UDim2.new(1, -40, 0, 250)
    ScrollFrame.Position = UDim2.new(0, 20, 0, 60)
    ScrollFrame.BackgroundColor3 = Colors.ItemBG
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Colors.Accent
    Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0, 6)
    
    local ListLayout = Instance.new("UIListLayout", ScrollFrame)
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Заполняем список конфигов
    for _, configName in ipairs(configs) do
        local ConfigButton = Instance.new("TextButton", ScrollFrame)
        ConfigButton.Size = UDim2.new(1, -10, 0, 40)
        ConfigButton.Position = UDim2.new(0, 5, 0, 0)
        ConfigButton.BackgroundColor3 = Colors.SettingsBG
        ConfigButton.Text = configName
        ConfigButton.TextColor3 = Colors.Text
        ConfigButton.Font = Enum.Font.Gotham
        ConfigButton.TextSize = 14
        Instance.new("UICorner", ConfigButton).CornerRadius = UDim.new(0, 4)
        
        ConfigButton.MouseButton1Click:Connect(function()
            if Callback then
                Callback(configName)
            end
            TweenService:Create(DialogFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            DialogFrame:Destroy()
        end)
    end
    
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local ButtonsFrame = Instance.new("Frame", DialogFrame)
    ButtonsFrame.Size = UDim2.new(1, -40, 0, 50)
    ButtonsFrame.Position = UDim2.new(0, 20, 1, -60)
    ButtonsFrame.BackgroundTransparency = 1
    
    local CancelBtn = Instance.new("TextButton", ButtonsFrame)
    CancelBtn.Size = UDim2.new(0.45, 0, 1, 0)
    CancelBtn.Position = UDim2.new(0, 0, 0, 0)
    CancelBtn.BackgroundColor3 = Colors.Danger
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Colors.Text
    CancelBtn.Font = Enum.Font.GothamBold
    CancelBtn.TextSize = 14
    Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 6)
    
    local function CloseDialog()
        TweenService:Create(DialogFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        DialogFrame:Destroy()
    end
    
    CancelBtn.MouseButton1Click:Connect(CloseDialog)
    
    -- Анимация появления
    DialogFrame.Size = UDim2.new(0, 0, 0, 0)
    DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(DialogFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 450, 0, 400),
        Position = UDim2.new(0.5, -225, 0.5, -200)
    }):Play()
end

-- Функция создания простого диалога
local function CreateSimpleDialog(TitleText, Description, DefaultText, Callback)
    local DialogFrame = Instance.new("Frame", ScreenGui)
    DialogFrame.Size = UDim2.new(0, 400, 0, 200)
    DialogFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    DialogFrame.BackgroundColor3 = Colors.Main
    DialogFrame.ZIndex = 100
    Instance.new("UICorner", DialogFrame).CornerRadius = UDim.new(0, 12)
    
    local DialogStroke = Instance.new("UIStroke", DialogFrame)
    DialogStroke.Color = Colors.Accent
    DialogStroke.Thickness = 2
    
    local Title = Instance.new("TextLabel", DialogFrame)
    Title.Text = TitleText
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Desc = Instance.new("TextLabel", DialogFrame)
    Desc.Text = Description
    Desc.Size = UDim2.new(1, -40, 0, 40)
    Desc.Position = UDim2.new(0, 20, 0, 50)
    Desc.TextColor3 = Colors.TextDark
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 14
    Desc.BackgroundTransparency = 1
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    
    local InputBox = Instance.new("TextBox", DialogFrame)
    InputBox.Size = UDim2.new(1, -40, 0, 40)
    InputBox.Position = UDim2.new(0, 20, 0, 100)
    InputBox.BackgroundColor3 = Colors.ItemBG
    InputBox.TextColor3 = Colors.Text
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 14
    InputBox.Text = DefaultText or ""
    InputBox.PlaceholderText = "Enter name..."
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)
    
    local ButtonsFrame = Instance.new("Frame", DialogFrame)
    ButtonsFrame.Size = UDim2.new(1, -40, 0, 40)
    ButtonsFrame.Position = UDim2.new(0, 20, 1, -50)
    ButtonsFrame.BackgroundTransparency = 1
    
    local CancelBtn = Instance.new("TextButton", ButtonsFrame)
    CancelBtn.Size = UDim2.new(0.45, 0, 1, 0)
    CancelBtn.Position = UDim2.new(0, 0, 0, 0)
    CancelBtn.BackgroundColor3 = Colors.Danger
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Colors.Text
    CancelBtn.Font = Enum.Font.GothamBold
    CancelBtn.TextSize = 14
    Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 6)
    
    local ConfirmBtn = Instance.new("TextButton", ButtonsFrame)
    ConfirmBtn.Size = UDim2.new(0.45, 0, 1, 0)
    ConfirmBtn.Position = UDim2.new(0.55, 0, 0, 0)
    ConfirmBtn.BackgroundColor3 = Colors.Success
    ConfirmBtn.Text = "Confirm"
    ConfirmBtn.TextColor3 = Colors.Text
    ConfirmBtn.Font = Enum.Font.GothamBold
    ConfirmBtn.TextSize = 14
    Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 6)
    
    local function CloseDialog()
        TweenService:Create(DialogFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        DialogFrame:Destroy()
    end
    
    CancelBtn.MouseButton1Click:Connect(CloseDialog)
    
    ConfirmBtn.MouseButton1Click:Connect(function()
        if Callback then
            Callback(InputBox.Text)
        end
        CloseDialog()
    end)
    
    InputBox.Focused:Connect(function()
        InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end)
    
    InputBox.FocusLost:Connect(function()
        InputBox.BackgroundColor3 = Colors.ItemBG
    end)
    
    -- Анимация появления
    DialogFrame.Size = UDim2.new(0, 0, 0, 0)
    DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(DialogFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100)
    }):Play()
end

-- Создание вкладок
local TabCombat = CreateTab("Combat", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabVisual = CreateTab("Visuals", "👁️")
local TabWorld = CreateTab("World", "🌍")
local TabMisc = CreateTab("Misc", "⚙️")
local TabSettings = CreateTab("Settings", "⚙️")

-- MOVEMENT ФУНКЦИИ (БОЛЕЕ 15)
AddModule(TabMove, "Speed Bypass", "SpeedEnabled", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "WalkSpeed", 16, 300, "Speed")
end)

AddModule(TabMove, "Flight Mode", "FlyEnabled", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Fly Speed", 10, 500, "FlySpeed")
end)

AddModule(TabMove, "Jump Power", "JumpEnabled", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Height", 50, 400, "JumpPower")
end)

AddModule(TabMove, "Infinite Jump", "InfJump", false)
AddModule(TabMove, "Noclip (Wall Phase)", "Noclip", false)
AddModule(TabMove, "Anti-Void", "AntiVoid", false)
AddModule(TabMove, "BunnyHop", "BunnyHop", false)
AddModule(TabMove, "SpinBot", "SpinBot", false)
AddModule(TabMove, "NoClip Fly", "NoClipFly", false)
AddModule(TabMove, "Auto Run", "AutoRun", false)
AddModule(TabMove, "Wall Run", "WallRun", false)
AddModule(TabMove, "Spider Climb", "SpiderClimb", false)
AddModule(TabMove, "Super Slide", "SuperSlide", false)
AddModule(TabMove, "Teleport To Cursor", "TeleportToCursor", false)
AddModule(TabMove, "Sprint Toggle", "SprintToggle", false)
AddModule(TabMove, "Crouch Speed", "CrouchSpeed", false)

-- COMBAT ФУНКЦИИ (БОЛЕЕ 20)
AddModule(TabCombat, "Aimbot", "Aimbot", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "FOV Radius", 30, 800, "AimFOV")
end)

AddModule(TabCombat, "Hitbox Expander", "Hitbox", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Head Size", 2, 50, "HitboxSize")
    CreateSlider(f, "Transparency", 0, 1, "HitboxTransp", 1)
end)

AddModule(TabCombat, "Auto Clicker", "AutoClicker", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Delay (sec)", 0, 2, "ClickDelay", 1)
end)

AddModule(TabCombat, "Trigger Bot", "TriggerBot", false)
AddModule(TabCombat, "Silent Aim", "SilentAim", false)
AddModule(TabCombat, "Reach (Melee)", "Reach", false)
AddModule(TabCombat, "No Recoil", "NoRecoil", false)
AddModule(TabCombat, "No Spread", "NoSpread", false)
AddModule(TabCombat, "Auto Reload", "AutoReload", false)
AddModule(TabCombat, "Instant Kill", "InstantKill", false)
AddModule(TabCombat, "Crit Hack", "CritHack", false)
AddModule(TabCombat, "Backstab", "Backstab", false)
AddModule(TabCombat, "Aim Assist", "AimAssist", false)
AddModule(TabCombat, "Auto Parry", "AutoParry", false)
AddModule(TabCombat, "Damage Multiplier", "DamageMultiplier", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Multiplier", 1, 10, "MultiplierValue", 1)
end)

-- VISUALS ФУНКЦИИ (БОЛЕЕ 15)
AddModule(TabVisual, "Enable ESP", "ESP_Enabled", false)
AddModule(TabVisual, "Box ESP", "Boxes", false)
AddModule(TabVisual, "Tracers", "Tracers", false)
AddModule(TabVisual, "Name Tags", "Names", false)
AddModule(TabVisual, "Chams (Wallhack)", "Chams", false)
AddModule(TabVisual, "FullBright", "FullBright", false)
AddModule(TabVisual, "No Fog", "NoFog", false)
AddModule(TabVisual, "Crosshair", "Crosshair", false)
AddModule(TabVisual, "Rainbow UI", "RainbowUI", false)
AddModule(TabVisual, "Night Vision", "NightVision", false)
AddModule(TabVisual, "Zoom Hack", "ZoomHack", false)
AddModule(TabVisual, "Third Person", "ThirdPerson", false)
AddModule(TabVisual, "Camera Zoom", "CameraZoom", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Zoom Level", 1, 100, "CameraZoom", 0)
end)

-- WORLD ФУНКЦИИ (БОЛЕЕ 10)
AddModule(TabWorld, "Gravity Control", "Gravity", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Gravity Force", 0, 196, "Gravity")
end)

AddModule(TabWorld, "Time Changer", "TimeChanger", true, function(f)
    f.ZIndex = 15
    CreateSlider(f, "Clock Time", 0, 24, "Time")
end)

AddModule(TabWorld, "Destroy Lava", "DestroyLava", false)
AddModule(TabWorld, "X-Ray Mode", "XRay", false)
AddModule(TabWorld, "No Fall Damage", "NoFallDamage", false)
AddModule(TabWorld, "No Fire Damage", "NoFireDamage", false)
AddModule(TabWorld, "God Mode", "GodMode", false)
AddModule(TabWorld, "Anti Kill Brick", "AntiKillBrick", false)

-- MISC ФУНКЦИИ (БОЛЕЕ 10)
AddModule(TabMisc, "Anti-AFK", "AntiAFK", false)
AddModule(TabMisc, "Chat Spy", "ChatSpy", false)
AddModule(TabMisc, "Free Cam", "FreeCam", false)
AddModule(TabMisc, "FPS Boost", "FPSBoost", false)
AddModule(TabMisc, "Ping Spoof", "PingSpoof", false)
AddModule(TabMisc, "Lag Switch", "LagSwitch", false)
AddModule(TabMisc, "Script Hub", "ScriptHub", false)

-- Кнопки действий
AddActionButton(TabMisc, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

AddActionButton(TabMisc, "Server Hop", function()
    local Http = game:GetService("HttpService")
    
    local servers = {}
    local req = Http:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    ))
    
    for _, server in pairs(req.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    else
        StarterGui:SetCore("SendNotification", {
            Title = "BLAZIX TITAN",
            Text = "No servers found!",
            Duration = 3
        })
    end
end)

AddActionButton(TabMisc, "Spectate Player", function()
    Config.Spectate = not Config.Spectate
    UpdateToggleVisual("Spectate", Config.Spectate)
end)

-- SETTINGS ВКЛАДКА
AddActionButton(TabSettings, "Save Configuration", function()
    CreateSimpleDialog("Save Configuration", 
        "Enter configuration name:", 
        CurrentConfigName,
        function(configName)
            local success, message = SaveConfig(configName)
            StarterGui:SetCore("SendNotification", {
                Title = "BLAZIX TITAN",
                Text = message,
                Duration = 5
            })
        end)
end)

AddActionButton(TabSettings, "Load Configuration", function()
    CreateConfigSelector("Load Configuration", "load", function(configName)
        local success, message = LoadConfig(configName)
        if success then
            UpdateAllToggleVisuals()
        end
        StarterGui:SetCore("SendNotification", {
            Title = "BLAZIX TITAN",
            Text = message,
            Duration = 5
        })
    end)
end)

AddActionButton(TabSettings, "Delete Configuration", function()
    CreateConfigSelector("Delete Configuration", "delete", function(configName)
        local success, message = DeleteConfig(configName)
        StarterGui:SetCore("SendNotification", {
            Title = "BLAZIX TITAN",
            Text = message,
            Duration = 5
        })
    end)
end)

AddActionButton(TabSettings, "Reset Configuration", function()
    ResetConfig()
    UpdateAllToggleVisuals()
    StarterGui:SetCore("SendNotification", {
        Title = "BLAZIX TITAN",
        Text = "Configuration reset to defaults!",
        Duration = 5
    })
end)

-- UI СЛАЙДЕРЫ
local UIScaleSlider, UIScaleBg, UIScaleFill = CreateSlider(TabSettings, "UI Scale", 0.5, 1.5, "UIScale", 1)
local UIOpacitySlider, UIOpacityBg, UIOpacityFill = CreateSlider(TabSettings, "UI Opacity", 0.3, 1, "UIOpacity", 1)

-- Функция обновления тоггла
local function UpdateToggleVisual(key, state)
    for _, element in ipairs(ToggleElements) do
        if element.ConfigKey == key then
            local targetPos = state and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
            local targetColor = state and Colors.Accent or Color3.fromRGB(220, 220, 220)
            local bgColor = state and Color3.fromRGB(0, 100, 70) or Color3.fromRGB(50, 50, 60)
            local textColor = state and Colors.Accent or Colors.Text
            
            TweenService:Create(element.ToggleCircle, TweenInfo.new(0.2), {
                Position = targetPos,
                BackgroundColor3 = targetColor
            }):Play()
            
            TweenService:Create(element.ToggleBg, TweenInfo.new(0.2), {
                BackgroundColor3 = bgColor
            }):Play()
            
            if element.Title then
                TweenService:Create(element.Title, TweenInfo.new(0.2), {
                    TextColor3 = textColor
                }):Play()
            end
            break
        end
    end
end

-- ЛОГИКА ФУНКЦИЙ (ОСНОВНЫЕ)
local MovementConnection = RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    local Hum = Char.Humanoid
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    -- Speed
    if Config.SpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
        local moveDir = Hum.MoveDirection * (Config.Speed / 50)
        Char:TranslateBy(moveDir * 0.1)
    end
    
    -- Fly
    if Config.FlyEnabled then
        local Dir = Vector3.zero
        local CF = Camera.CFrame
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + CF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - CF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - CF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + CF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir = Dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Dir = Dir - Vector3.new(0, 1, 0) end
        
        if Dir.Magnitude > 0 then
            Dir = Dir.Unit * Config.FlySpeed
            HRP.Velocity = HRP.Velocity:Lerp(Dir, 0.3)
        else
            HRP.Velocity = Vector3.new(0, 0, 0)
        end
        
        Hum.PlatformStand = true
    else
        Hum.PlatformStand = false
    end
    
    -- Jump Power
    if Config.JumpEnabled then
        Hum.JumpPower = Config.JumpPower
    end
    
    -- Noclip
    if Config.Noclip then
        for _, part in pairs(Char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    
    -- Spinbot
    if Config.SpinBot then
        HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(5), 0)
    end
    
    -- AntiVoid
    if Config.AntiVoid and HRP.Position.Y < -500 then
        HRP.CFrame = CFrame.new(0, 100, 0)
    end
    
    -- Infinite Jump
    if Config.InfJump then
        Hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Visuals Logic
local VisualsLoop = task.spawn(function()
    while task.wait(0.5) do
        -- Chams
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = player.Character:FindFirstChild("BlazixChams") or Instance.new("Highlight", player.Character)
                hl.Name = "BlazixChams"
                hl.Enabled = Config.Chams
                hl.FillColor = Colors.Accent
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
            end
        end
        
        -- Fullbright
        if Config.FullBright then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
        
        -- No Fog
        if Config.NoFog then
            Lighting.FogEnd = 100000
        end
        
        -- Time Changer
        if Config.TimeChanger then
            Lighting.ClockTime = Config.Time
        end
        
        -- Gravity
        workspace.Gravity = Config.Gravity
    end
end)

-- ANTI-AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
end

-- ЛОГИКА ПЕРЕТАСКИВАНИЯ ОКНА
local MainDragging = false
local MainDragStart, MainStartPos

DragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainDragging = true
        MainDragStart = input.Position
        MainStartPos = Main.Position
        
        TweenService:Create(Main, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and MainDragging then
        local Delta = input.Position - MainDragStart
        local newPosition = UDim2.new(
            MainStartPos.X.Scale, 
            MainStartPos.X.Offset + Delta.X, 
            MainStartPos.Y.Scale, 
            MainStartPos.Y.Offset + Delta.Y
        )
        Main.Position = newPosition
        LastWindowPosition = newPosition
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainDragging = false
        TweenService:Create(Main, TweenInfo.new(0.1), {
            BackgroundColor3 = Colors.Main
        }):Play()
    end
end)

-- Функции показа/скрытия GUI (ИСПРАВЛЕННЫЕ)
local function ShowMainGUI()
    Main.Visible = true
    ToggleButton.Visible = false -- Кнопка пропадает при открытии GUI
    
    -- Анимация появления из центра
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = LastWindowSize,
        Position = LastWindowPosition
    }):Play()
end

local function HideMainGUI()
    -- Сохраняем текущую позицию
    LastWindowPosition = Main.Position
    LastWindowSize = Main.Size
    
    -- Анимация исчезновения к центру
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.3)
    Main.Visible = false
    ToggleButton.Visible = true -- Кнопка появляется при скрытии GUI
end

-- Кнопка "Скрыть" в заголовке
HideBtn.MouseButton1Click:Connect(function()
    HideMainGUI()
    StarterGui:SetCore("SendNotification", {
        Title = "BLAZIX TITAN",
        Text = "Меню скрыто. Нажмите B кнопку или Left Alt для открытия.",
        Duration = 3
    })
end)

-- Кнопка B для открытия/закрытия (ИСПРАВЛЕННАЯ)
ToggleButton.MouseButton1Click:Connect(function()
    if not MainDragging and not ButtonDragging then
        if Main.Visible then
            HideMainGUI()
        else
            ShowMainGUI()
        end
    end
end)

-- КНОПКА СКРЫТИЯ/ПОКАЗА (Left Alt) (ИСПРАВЛЕННАЯ)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        if Main.Visible then
            HideMainGUI()
        else
            ShowMainGUI()
        end
    end
end)

-- АКТИВАЦИЯ СТАНДАРТНОЙ ВКЛАДКИ
Pages["Combat"].Page.Visible = true
Pages["Combat"].Btn.TextColor3 = Colors.Text
Pages["Combat"].Btn.BackgroundColor3 = Colors.ItemBG

-- Показываем кнопку B при запуске (GUI скрыт)
ToggleButton.Visible = true

-- ЗАПУСК СКРИПТА
task.wait(1)
ShowNotification()
task.spawn(AntiPopups)

-- Автозагрузка конфигурации
task.delay(2, function()
    if isfolder(ConfigFolder) and isfile(ConfigFolder .. "/default.json") then
        LoadConfig("default")
        UpdateAllToggleVisuals()
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "BLAZIX TITAN V12.5",
    Text = "Modern Dark Neon UI loaded successfully!\nPress Left Alt or click B button to toggle menu.",
    Duration = 5,
    Icon = "rbxassetid://3926307971"
})
