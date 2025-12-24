--[[
    BLAZIX HUB V12: TITAN EDITION
    OPTIMIZED FOR ALL EXPLOITS
]]

-- Функция для безопасного получения сервисов
local function GetService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    return success and service or nil
end

-- Получаем только основные сервисы
local Players = GetService("Players")
local RunService = GetService("RunService")
local UserInputService = GetService("UserInputService")
local TweenService = GetService("TweenService")
local Lighting = GetService("Lighting")

if not (Players and RunService and UserInputService) then
    warn("❌ Не удалось получить основные сервисы")
    return
end

-- Получаем LocalPlayer
local LocalPlayer
for i = 1, 10 do
    LocalPlayer = Players.LocalPlayer
    if LocalPlayer then break end
    task.wait(0.5)
end

if not LocalPlayer then
    warn("❌ Не удалось получить LocalPlayer")
    return
end

-- Ждём PlayerGui
local PlayerGui
for i = 1, 10 do
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 2)
    if PlayerGui then break end
    task.wait(0.5)
end

if not PlayerGui then
    warn("❌ Не удалось получить PlayerGui")
    return
end

print("🚀 Загрузка Blazix Titan v12...")

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false,
    BunnyHop = false, SpinBot = false,
    AutoSprint = false,
    
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2,
    AutoClicker = false, ClickDelay = 0.1,
    Reach = false, ReachDist = 10,
    
    ESP_Enabled = false, Boxes = false,
    BoxColorR = 0, BoxColorG = 255, BoxColorB = 140,
    Names = false, Health = false, Chams = false,
    FullBright = false, NoFog = false,
    
    DestroyLava = false, TimeChanger = false,
    Time = 12, Gravity = 196.2,
    
    AntiAFK = true, ServerHop = false,
    HidePopups = false
}

-- [ СОЗДАНИЕ GUI ]
local ScreenGui, Main

-- Создаём простейший GUI для теста
local function CreateSimpleGUI()
    local success, result = pcall(function()
        -- Пробуем сначала PlayerGui, если не получается - создаём новый
        local targetParent = PlayerGui
        
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "RobloxGui" -- Случайное имя для обхода античитов
        ScreenGui.Parent = targetParent
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 999999
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        
        -- Основной фрейм
        Main = Instance.new("Frame")
        Main.Name = "MainFrame"
        Main.Size = UDim2.new(0, 900, 0, 650)
        Main.Position = UDim2.new(0.5, -450, 0.5, -325)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Main.BorderSizePixel = 0
        Main.ClipsDescendants = true
        Main.Visible = true
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
    
    return success
end

-- Создаём GUI
if not CreateSimpleGUI() then
    -- Пробуем альтернативный способ
    warn("⚠️ Попытка альтернативного создания GUI...")
    
    -- Пробуем создать в StarterGui
    local StarterGui = GetService("StarterGui")
    if StarterGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "GameGui"
        ScreenGui.Parent = StarterGui
        ScreenGui.ResetOnSpawn = false
        
        Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, 900, 0, 650)
        Main.Position = UDim2.new(0.5, -450, 0.5, -325)
        Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Main.BorderSizePixel = 0
        Main.Visible = true
        Main.Parent = ScreenGui
        
        print("✅ GUI создан в StarterGui")
    else
        warn("❌ Не удалось создать GUI ни одним способом")
        return
    end
end

print("✅ GUI успешно создан!")

-- [ БАЗОВЫЙ ИНТЕРФЕЙС ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255)
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
Title.Text = "BLAZIX TITAN v12"
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

-- Информационное сообщение
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, -40, 0, 100)
InfoLabel.Position = UDim2.new(0, 20, 0, 80)
InfoLabel.Text = "✅ Blazix Titan v12 успешно загружен!\n\nНажмите Left Alt чтобы скрыть/показать меню\nНажмите кнопку '━' чтобы скрыть\nНажмите 'X' чтобы закрыть"
InfoLabel.TextColor3 = Colors.Text
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 16
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.BackgroundTransparency = 1
InfoLabel.Parent = Main

-- [ ОБРАБОТЧИКИ СОБЫТИЙ ]
HideBtn.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
    print("📌 Меню: " .. (Main.Visible and "Показано" or "Скрыто"))
end)

CloseBtn.MouseButton1Click:Connect(function() 
    if ScreenGui then
        ScreenGui:Destroy() 
        print("❌ Меню закрыто")
    end
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

if UserInputService then
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

    -- Горячая клавиша для скрытия
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            Main.Visible = not Main.Visible
            print("🔑 Left Alt: Меню " .. (Main.Visible and "показано" or "скрыто"))
        end
    end)
end

-- [ ПРОСТЫЕ ФУНКЦИИ ]
-- Speed
local speedConnection
local function ToggleSpeed()
    Config.SpeedEnabled = not Config.SpeedEnabled
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if Config.SpeedEnabled then
        speedConnection = RunService.Heartbeat:Connect(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if not Hum then return end
            
            if Hum.MoveDirection.Magnitude > 0 then
                Char:TranslateBy(Hum.MoveDirection * (Config.Speed / 100))
            end
        end)
        print("✅ Speed: Включено")
    else
        print("❌ Speed: Выключено")
    end
end

-- Jump Power
local function ToggleJump()
    Config.JumpEnabled = not Config.JumpEnabled
    
    local Char = LocalPlayer.Character
    if Char then
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if Hum then
            if Config.JumpEnabled then
                Hum.JumpPower = Config.JumpPower
                print("✅ Jump Power: Включено")
            else
                Hum.JumpPower = 50
                print("❌ Jump Power: Выключено")
            end
        end
    end
end

-- Infinite Jump
local infJumpConnection
local function ToggleInfJump()
    Config.InfJump = not Config.InfJump
    
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
    
    if Config.InfJump and UserInputService then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local Char = LocalPlayer.Character
            if Char then
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                if Hum then
                    Hum:ChangeState("Jumping")
                end
            end
        end)
        print("✅ Infinite Jump: Включено")
    else
        print("❌ Infinite Jump: Выключено")
    end
end

-- Noclip
local noclipConnection
local function ToggleNoclip()
    Config.Noclip = not Config.Noclip
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if Config.Noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            
            for _, part in pairs(Char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end)
        print("✅ Noclip: Включено")
    else
        print("❌ Noclip: Выключено")
    end
end

-- FullBright
local function ToggleFullBright()
    Config.FullBright = not Config.FullBright
    
    if Lighting then
        if Config.FullBright then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            print("✅ FullBright: Включено")
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            print("❌ FullBright: Выключено")
        end
    end
end

-- Gravity
local function ToggleGravity()
    if workspace then
        Config.Gravity = Config.Gravity == 196.2 and 50 or 196.2
        workspace.Gravity = Config.Gravity
        print("✅ Gravity: " .. Config.Gravity)
    end
end

-- [ СОЗДАНИЕ КНОПОК ФУНКЦИЙ ]
local function CreateFunctionButton(name, callback, color)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, 150)
    button.BackgroundColor3 = color or Color3.fromRGB(60, 60, 70)
    button.Text = name
    button.TextColor3 = Colors.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.AutoButtonColor = true
    button.Parent = Main
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Добавляем кнопки функций (позиции разные)
local yOffset = 150
local buttonSpacing = 50

CreateFunctionButton("Speed", ToggleSpeed, Color3.fromRGB(0, 100, 200))
yOffset = yOffset + buttonSpacing

CreateFunctionButton("Jump Power", ToggleJump, Color3.fromRGB(0, 150, 100))
yOffset = yOffset + buttonSpacing

CreateFunctionButton("Inf Jump", ToggleInfJump, Color3.fromRGB(200, 100, 0))
yOffset = yOffset + buttonSpacing

CreateFunctionButton("Noclip", ToggleNoclip, Color3.fromRGB(150, 0, 150))
yOffset = yOffset + buttonSpacing

CreateFunctionButton("FullBright", ToggleFullBright, Color3.fromRGB(200, 200, 0))
yOffset = yOffset + buttonSpacing

CreateFunctionButton("Gravity", ToggleGravity, Color3.fromRGB(0, 150, 200))

-- [ УВЕДОМЛЕНИЕ ПРИ ЗАПУСКЕ ]
task.spawn(function()
    task.wait(0.5)
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "Notification"
    NotificationGui.Parent = ScreenGui.Parent
    NotificationGui.DisplayOrder = 1000000
    
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
    MessageLabel.Text = "Хаб успешно загружен!\nLeft Alt - скрыть/показать"
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 14
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Parent = MainFrame
    
    -- Закрытие через 5 секунд
    task.wait(5)
    if NotificationGui and NotificationGui.Parent then
        NotificationGui:Destroy()
    end
end)

-- [ УБЕРАЕМ МЕНЮ ПРИ ВЫХОДЕ ]
LocalPlayer.CharacterRemoving:Connect(function()
    -- Отключаем все соединения
    if speedConnection then speedConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    
    -- Можно удалить GUI, но не обязательно
    -- if ScreenGui then ScreenGui:Destroy() end
end)

-- [ ФИНАЛЬНОЕ СООБЩЕНИЕ ]
print("=" .. string.rep("=", 50))
print("✅ Blazix Titan v12 успешно загружен!")
print("📌 Меню должно быть видно на экране")
print("📌 Нажмите F9 для просмотра консоли")
print("📌 Проверьте:")
print("   1. Видно ли черное окно с текстом?")
print("   2. Работает ли Left Alt?")
print("   3. Работают ли кнопки функций?")
print("=" .. string.rep("=", 50))

-- Принудительно обновляем видимость
task.wait(0.1)
if Main then
    Main.Visible = true
end

-- Тестовое сообщение в чат
task.spawn(function()
    task.wait(2)
    if game:GetService("TextChatService") then
        pcall(function()
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("🔓 Blazix Titan v12 loaded!")
        end)
    end
end)
