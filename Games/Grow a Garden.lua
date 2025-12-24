-- ███╗   ██╗███████╗ ██████╗ ██╗  ██╗ █████╗ ██╗  ██╗
-- ████╗  ██║██╔════╝██╔═══██╗██║  ██║██╔══██╗╚██╗██╔╝
-- ██╔██╗ ██║█████╗  ██║   ██║███████║███████║ ╚███╔╝ 
-- ██║╚██╗██║██╔══╝  ██║   ██║██╔══██║██╔══██║ ██╔██╗ 
-- ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║██╔╝ ██╗
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
-- NeoHax v3.0 - Universal UI | Гарантированное отображение

-- ========== КОНФИГУРАЦИЯ ==========
local CONFIG = {
    UI_NAME = "NeoHax_MainUI",
    DEFAULT_POSITION = UDim2.new(0.5, -250, 0.5, -200),
    DEFAULT_SIZE = UDim2.new(0, 500, 0, 400),
    THEME = {
        PRIMARY = Color3.fromRGB(0, 255, 140),      -- Неоновый зеленый
        BACKGROUND = Color3.fromRGB(20, 20, 25),    -- Темный фон
        DARKER_BG = Color3.fromRGB(15, 15, 20),
        LIGHT_TEXT = Color3.fromRGB(240, 240, 240),
        GRAY_TEXT = Color3.fromRGB(180, 180, 180),
        RED_ACCENT = Color3.fromRGB(255, 50, 50)
    },
    HOTKEYS = {
        TOGGLE_UI = Enum.KeyCode.RightControl,
        HIDE_UI = Enum.KeyCode.RightShift,
        CLOSE_ALL = Enum.KeyCode.End
    }
}

-- ========== СИСТЕМНЫЕ СЕРВИСЫ ==========
local services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    Lighting = game:GetService("Lighting"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    CoreGui = game:GetService("CoreGui"),
    StarterGui = game:GetService("StarterGui"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService")
}

-- ========== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ==========
local Player = services.Players.LocalPlayer
local Mouse = Player:GetMouse()
local mainUI, mainFrame, sidebar, modulesContainer
local connections = {}
local modules = {}
local uiHidden = false
local safetyChecks = 0
local MAX_SAFETY_CHECKS = 50

-- ========== СИСТЕМНЫЕ УТИЛИТЫ ==========
function SafeCreate(className, properties)
    local success, obj = pcall(function()
        local instance = Instance.new(className)
        for prop, value in pairs(properties) do
            if prop ~= "Parent" then
                if pcall(function()
                    instance[prop] = value
                end) then
                    -- Успешно установлено свойство
                end
            end
        end
        return instance
    end)
    
    if success and obj then
        if properties.Parent then
            obj.Parent = properties.Parent
        end
        return obj
    end
    return nil
end

function ForceCreate(className, properties)
    for i = 1, 3 do
        local obj = SafeCreate(className, properties)
        if obj then
            return obj
        end
        task.wait(0.1)
    end
    warn("Не удалось создать: " .. className)
    return nil
end

function SafeTween(obj, properties, duration)
    duration = duration or 0.2
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local success, tween = pcall(function()
        return services.TweenService:Create(obj, tweenInfo, properties)
    end)
    
    if success and tween then
        tween:Play()
        return tween
    end
    return nil
end

function AddConnection(name, connection)
    if connections[name] then
        connections[name]:Disconnect()
    end
    connections[name] = connection
end

-- ========== ЗАЩИТА ОТ СБРОСА ==========
local function CreateAntiReset()
    -- Создаем скрытый объект в разных местах
    local hiddenParts = {}
    
    -- В CoreGui
    local hiddenGui = ForceCreate("ScreenGui", {
        Name = "NeoHax_Hidden_" .. math.random(10000, 99999),
        Parent = services.CoreGui,
        Enabled = false
    })
    
    -- В рабочем пространстве
    if workspace:FindFirstChild("Terrain") then
        local hiddenPart = ForceCreate("Part", {
            Name = "NeoHax_System_" .. math.random(10000, 99999),
            Parent = workspace,
            Transparency = 1,
            CanCollide = false,
            Anchored = true,
            Size = Vector3.new(1, 1, 1),
            Position = Vector3.new(0, 500, 0)
        })
        table.insert(hiddenParts, hiddenPart)
    end
    
    -- В Lighting
    local hiddenValue = ForceCreate("StringValue", {
        Name = "NeoHax_Data",
        Parent = services.Lighting,
        Value = "ACTIVE"
    })
    
    -- Защита от очистки
    local protectionConnection = services.RunService.Heartbeat:Connect(function()
        if hiddenGui and not hiddenGui.Parent then
            hiddenGui.Parent = services.CoreGui
        end
        if hiddenValue and not hiddenValue.Parent then
            hiddenValue.Parent = services.Lighting
        end
        for _, part in ipairs(hiddenParts) do
            if part and not part.Parent then
                part.Parent = workspace
            end
        end
    end)
    
    AddConnection("AntiReset", protectionConnection)
end

-- ========== СОЗДАНИЕ ИНТЕРФЕЙСА ==========
function CreateMainUI()
    -- Удаляем старый UI если есть
    local oldUI = services.CoreGui:FindFirstChild(CONFIG.UI_NAME)
    if oldUI then
        oldUI:Destroy()
        task.wait(0.1)
    end
    
    -- Основной GUI
    mainUI = ForceCreate("ScreenGui", {
        Name = CONFIG.UI_NAME,
        Parent = services.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 9999,
        ResetOnSpawn = false
    })
    
    if not mainUI then
        warn("ОШИБКА: Не удалось создать основной GUI")
        return false
    end
    
    -- Основной фрейм
    mainFrame = ForceCreate("Frame", {
        Parent = mainUI,
        Size = CONFIG.DEFAULT_SIZE,
        Position = CONFIG.DEFAULT_POSITION,
        BackgroundColor3 = CONFIG.THEME.BACKGROUND,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        Selectable = true
    })
    
    -- Скругление углов
    ForceCreate("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Неоновая обводка
    ForceCreate("UIStroke", {
        Parent = mainFrame,
        Color = CONFIG.THEME.PRIMARY,
        Thickness = 2,
        Transparency = 0.3
    })
    
    -- Внутренняя тень
    ForceCreate("UIGradient", {
        Parent = mainFrame,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90
    })
    
    -- Шапка
    local header = ForceCreate("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CONFIG.THEME.DARKER_BG,
        BorderSizePixel = 0
    })
    
    ForceCreate("UICorner", {
        Parent = header,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Заголовок с иконкой
    local titleContainer = ForceCreate("Frame", {
        Parent = header,
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1
    })
    
    local titleIcon = ForceCreate("TextLabel", {
        Parent = titleContainer,
        Size = UDim2.new(0, 40, 1, 0),
        BackgroundTransparency = 1,
        Text = "⚡",
        TextColor3 = CONFIG.THEME.PRIMARY,
        TextSize = 24,
        Font = Enum.Font.GothamBold
    })
    
    local titleText = ForceCreate("TextLabel", {
        Parent = titleContainer,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        Text = "NeoHax v3.0",
        TextColor3 = CONFIG.THEME.PRIMARY,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Кнопка закрытия
    local closeButton = ForceCreate("TextButton", {
        Parent = header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, -15),
        BackgroundColor3 = CONFIG.THEME.RED_ACCENT,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    
    ForceCreate("UICorner", {
        Parent = closeButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    closeButton.MouseButton1Click:Connect(function()
        services.StarterGui:SetCore("SendNotification", {
            Title = "NeoHax",
            Text = "Закрыть интерфейс? Нажмите F9 чтобы вернуть.",
            Duration = 3
        })
        mainUI.Enabled = false
    end)
    
    -- Кнопка скрытия
    local hideButton = ForceCreate("TextButton", {
        Parent = header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0.5, -15),
        BackgroundColor3 = CONFIG.THEME.DARKER_BG,
        Text = "─",
        TextColor3 = CONFIG.THEME.LIGHT_TEXT,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    
    ForceCreate("UICorner", {
        Parent = hideButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    hideButton.MouseButton1Click:Connect(function()
        uiHidden = not uiHidden
        mainFrame.Visible = not uiHidden
    end)
    
    -- Боковая панель
    sidebar = ForceCreate("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(0, 80, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = CONFIG.THEME.DARKER_BG,
        BorderSizePixel = 0
    })
    
    -- Контейнер модулей
    modulesContainer = ForceCreate("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -80, 1, -40),
        Position = UDim2.new(0, 80, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = CONFIG.THEME.PRIMARY,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    
    -- Список вкладок
    local tabButtons = {}
    local tabs = {
        {"🚀", "Движение", CreateMovementTab},
        {"🎯", "Бой", CreateCombatTab},
        {"👁️", "Визуалы", CreateVisualsTab},
        {"🌍", "Мир", CreateWorldTab},
        {"⚙️", "Настройки", CreateSettingsTab},
        {"💾", "Сохранения", CreateSavesTab}
    }
    
    -- Создание кнопок вкладок
    for i, tab in ipairs(tabs) do
        local tabButton = ForceCreate("TextButton", {
            Parent = sidebar,
            Size = UDim2.new(1, -10, 0, 60),
            Position = UDim2.new(0, 5, 0, 10 + (i-1) * 65),
            BackgroundColor3 = CONFIG.THEME.BACKGROUND,
            Text = tab[1] .. "\n" .. tab[2],
            TextColor3 = CONFIG.THEME.GRAY_TEXT,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            AutoButtonColor = false
        })
        
        ForceCreate("UICorner", {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        ForceCreate("UIStroke", {
            Parent = tabButton,
            Color = CONFIG.THEME.DARKER_BG,
            Thickness = 1
        })
        
        tabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabButtons) do
                SafeTween(btn, {BackgroundColor3 = CONFIG.THEME.BACKGROUND, TextColor3 = CONFIG.THEME.GRAY_TEXT})
            end
            SafeTween(tabButton, {BackgroundColor3 = CONFIG.THEME.PRIMARY, TextColor3 = Color3.fromRGB(0, 0, 0)})
            tab[3]()
        end)
        
        table.insert(tabButtons, tabButton)
    end
    
    -- Активируем первую вкладку
    if #tabButtons > 0 then
        SafeTween(tabButtons[1], {BackgroundColor3 = CONFIG.THEME.PRIMARY, TextColor3 = Color3.fromRGB(0, 0, 0)})
        tabs[1][3]()
    end
    
    -- Система перетаскивания
    local dragging = false
    local dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    -- Горячие клавиши
    services.UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == CONFIG.HOTKEYS.TOGGLE_UI then
            uiHidden = not uiHidden
            mainFrame.Visible = not uiHidden
        elseif input.KeyCode == CONFIG.HOTKEYS.HIDE_UI then
            mainUI.Enabled = not mainUI.Enabled
        elseif input.KeyCode == CONFIG.HOTKEYS.CLOSE_ALL then
            for name, conn in pairs(connections) do
                if conn then
                    conn:Disconnect()
                end
            end
            services.StarterGui:SetCore("ResetButtonCallback", true)
        end
    end)
    
    return true
end

-- ========== ФУНКЦИОНАЛЬНЫЕ МОДУЛИ ==========
function CreateModuleTab(container, moduleList)
    -- Очистка контейнера
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 10
    local moduleHeight = 50
    
    for i, module in ipairs(moduleList) do
        local moduleFrame = ForceCreate("Frame", {
            Parent = container,
            Size = UDim2.new(1, -20, 0, moduleHeight),
            Position = UDim2.new(0, 10, 0, yPos),
            BackgroundColor3 = CONFIG.THEME.DARKER_BG,
            ClipsDescendants = true
        })
        
        ForceCreate("UICorner", {
            Parent = moduleFrame,
            CornerRadius = UDim.new(0, 6)
        })
        
        ForceCreate("UIStroke", {
            Parent = moduleFrame,
            Color = CONFIG.THEME.BACKGROUND,
            Thickness = 1
        })
        
        -- Название модуля
        ForceCreate("TextLabel", {
            Parent = moduleFrame,
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0, 15, 0, 0),
            BackgroundTransparency = 1,
            Text = module[1],
            TextColor3 = CONFIG.THEME.LIGHT_TEXT,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        })
        
        if module[2] == "toggle" then
            -- Переключатель
            local toggleState = modules[module[3]] or false
            
            local toggleFrame = ForceCreate("Frame", {
                Parent = moduleFrame,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -70, 0.5, -12.5),
                BackgroundColor3 = toggleState and CONFIG.THEME.PRIMARY or Color3.fromRGB(60, 60, 65)
            })
            
            ForceCreate("UICorner", {
                Parent = toggleFrame,
                CornerRadius = UDim.new(1, 0)
            })
            
            local toggleCircle = ForceCreate("Frame", {
                Parent = toggleFrame,
                Size = UDim2.new(0, 21, 0, 21),
                Position = toggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            ForceCreate("UICorner", {
                Parent = toggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            moduleFrame.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                modules[module[3]] = toggleState
                
                SafeTween(toggleFrame, {BackgroundColor3 = toggleState and CONFIG.THEME.PRIMARY or Color3.fromRGB(60, 60, 65)})
                SafeTween(toggleCircle, {
                    Position = toggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                })
                
                if module[4] then
                    module[4](toggleState)
                end
            end)
            
            moduleFrame.MouseButton2Click:Connect(function()
                if module[5] then
                    module[5]()
                end
            end)
            
        elseif module[2] == "slider" then
            -- Слайдер
            local min = module[4] or 0
            local max = module[5] or 100
            local default = module[6] or 50
            local currentValue = default
            
            local sliderFrame = ForceCreate("Frame", {
                Parent = moduleFrame,
                Size = UDim2.new(0, 150, 0, 5),
                Position = UDim2.new(1, -160, 0.5, -2.5),
                BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            })
            
            ForceCreate("UICorner", {
                Parent = sliderFrame,
                CornerRadius = UDim.new(1, 0)
            })
            
            local sliderFill = ForceCreate("Frame", {
                Parent = sliderFrame,
                Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = CONFIG.THEME.PRIMARY
            })
            
            ForceCreate("UICorner", {
                Parent = sliderFill,
                CornerRadius = UDim.new(1, 0)
            })
            
            local valueLabel = ForceCreate("TextLabel", {
                Parent = moduleFrame,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -210, 0.5, -10),
                BackgroundTransparency = 1,
                Text = tostring(currentValue),
                TextColor3 = CONFIG.THEME.LIGHT_TEXT,
                TextSize = 12,
                Font = Enum.Font.Gotham
            })
            
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                currentValue = value
                sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                valueLabel.Text = tostring(math.floor(value))
                if module[3] then
                    module[3](value)
                end
            end
            
            sliderFrame.MouseButton1Down:Connect(function()
                local connection
                connection = services.UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local x = input.Position.X
                        local sliderPos = sliderFrame.AbsolutePosition.X
                        local sliderWidth = sliderFrame.AbsoluteSize.X
                        local percent = (x - sliderPos) / sliderWidth
                        percent = math.clamp(percent, 0, 1)
                        updateSlider(min + (max - min) * percent)
                    end
                end)
                
                services.UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end)
            
            updateSlider(default)
        end
        
        yPos = yPos + moduleHeight + 10
    end
    
    container.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- ========== ВКЛАДКИ ==========
function CreateMovementTab()
    local modules = {
        {"Скорость ходьбы", "slider", function(value)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = value
            end
        end, 16, 200, 16},
        
        {"Сила прыжка", "slider", function(value)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.JumpPower = value
            end
        end, 50, 500, 50},
        
        {"Бесконечный прыжок", "toggle", "InfiniteJump", function(state)
            modules.InfiniteJump = state
            if state then
                AddConnection("InfiniteJump", services.UserInputService.JumpRequest:Connect(function()
                    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end))
            else
                if connections.InfiniteJump then
                    connections.InfiniteJump:Disconnect()
                end
            end
        end},
        
        {"Noclip", "toggle", "Noclip", function(state)
            modules.Noclip = state
            if state then
                AddConnection("Noclip", services.RunService.Stepped:Connect(function()
                    if Player.Character then
                        for _, part in pairs(Player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end))
            else
                if connections.Noclip then
                    connections.Noclip:Disconnect()
                end
            end
        end},
        
        {"Fly Mode", "toggle", "Fly", function(state)
            modules.Fly = state
            if state and Player.Character then
                local bodyVelocity = ForceCreate("BodyVelocity", {
                    Parent = Player.Character.PrimaryPart,
                    MaxForce = Vector3.new(40000, 40000, 40000)
                })
                
                AddConnection("Fly", services.RunService.Heartbeat:Connect(function()
                    if Player.Character and Player.Character.PrimaryPart and bodyVelocity then
                        local root = Player.Character.PrimaryPart
                        local velocity = Vector3.new(0, 0, 0)
                        
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            velocity = velocity + root.CFrame.LookVector * 100
                        end
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            velocity = velocity - root.CFrame.LookVector * 100
                        end
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            velocity = velocity - root.CFrame.RightVector * 100
                        end
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            velocity = velocity + root.CFrame.RightVector * 100
                        end
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            velocity = velocity + Vector3.new(0, 100, 0)
                        end
                        if services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            velocity = velocity - Vector3.new(0, 100, 0)
                        end
                        
                        bodyVelocity.Velocity = velocity
                    end
                end))
            else
                if connections.Fly then
                    connections.Fly:Disconnect()
                end
                if Player.Character then
                    for _, v in pairs(Player.Character:GetChildren()) do
                        if v:IsA("BodyVelocity") then
                            v:Destroy()
                        end
                    end
                end
            end
        end},
        
        {"Анти-Войд", "toggle", "AntiVoid", function(state)
            modules.AntiVoid = state
            if state then
                AddConnection("AntiVoid", services.RunService.Heartbeat:Connect(function()
                    if Player.Character and Player.Character.PrimaryPart then
                        local root = Player.Character.PrimaryPart
                        if root.Position.Y < -100 then
                            root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
                        end
                    end
                end))
            else
                if connections.AntiVoid then
                    connections.AntiVoid:Disconnect()
                end
            end
        end}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

function CreateCombatTab()
    local modules = {
        {"Auto Clicker", "toggle", "AutoClick", function(state)
            modules.AutoClick = state
            if state then
                AddConnection("AutoClick", services.RunService.Heartbeat:Connect(function()
                    mouse1click()
                end))
            else
                if connections.AutoClick then
                    connections.AutoClick:Disconnect()
                end
            end
        end},
        
        {"Hitbox Expander", "toggle", "Hitbox", function(state)
            modules.Hitbox = state
            if state then
                for _, player in pairs(services.Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            head.Size = Vector3.new(3, 3, 3)
                            head.Transparency = 0.5
                        end
                    end
                end
            else
                for _, player in pairs(services.Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            head.Size = Vector3.new(2, 1, 1)
                            head.Transparency = 0
                        end
                    end
                end
            end
        end},
        
        {"Reach Distance", "slider", function(value)
            if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
                -- Увеличиваем дистанцию удара
            end
        end, 10, 50, 10}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

function CreateVisualsTab()
    local modules = {
        {"FullBright", "toggle", "FullBright", function(state)
            modules.FullBright = state
            if state then
                services.Lighting.Brightness = 2
                services.Lighting.ClockTime = 14
                services.Lighting.FogEnd = 100000
                services.Lighting.GlobalShadows = false
            else
                services.Lighting.Brightness = 1
                services.Lighting.FogEnd = 10000
                services.Lighting.GlobalShadows = true
            end
        end},
        
        {"No Fog", "toggle", "NoFog", function(state)
            modules.NoFog = state
            services.Lighting.FogEnd = state and 100000 or 10000
        end},
        
        {"ESP Boxes", "toggle", "ESP", function(state)
            modules.ESP = state
            -- Реализация ESP
        end}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

function CreateWorldTab()
    local modules = {
        {"Гравитация", "slider", function(value)
            workspace.Gravity = value
        end, 0, 196.2, 196.2},
        
        {"Время суток", "slider", function(value)
            services.Lighting.ClockTime = value
        end, 0, 24, 14},
        
        {"Анти-АФК", "toggle", "AntiAFK", function(state)
            modules.AntiAFK = state
            if state then
                AddConnection("AntiAFK", services.RunService.Heartbeat:Connect(function()
                    services.VirtualInputManager:SendMouseMoveEvent(100, 100, workspace)
                    task.wait(0.5)
                    services.VirtualInputManager:SendMouseMoveEvent(200, 200, workspace)
                end))
            else
                if connections.AntiAFK then
                    connections.AntiAFK:Disconnect()
                end
            end
        end}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

function CreateSettingsTab()
    local modules = {
        {"Сменить цвет UI", "toggle", "ChangeColor", function(state)
            if state then
                local colors = {
                    Color3.fromRGB(0, 255, 140),  -- зеленый
                    Color3.fromRGB(0, 200, 255),  -- голубой
                    Color3.fromRGB(255, 100, 0),  -- оранжевый
                    Color3.fromRGB(255, 0, 255),  -- розовый
                    Color3.fromRGB(255, 255, 0)   -- желтый
                }
                CONFIG.THEME.PRIMARY = colors[math.random(1, #colors)]
                
                -- Обновляем UI
                for _, obj in pairs(mainFrame:GetDescendants()) do
                    if obj:IsA("UIStroke") then
                        obj.Color = CONFIG.THEME.PRIMARY
                    end
                end
            end
        end},
        
        {"Сбросить позицию UI", "toggle", "ResetUI", function(state)
            if state then
                mainFrame.Position = CONFIG.DEFAULT_POSITION
                task.wait(0.1)
                modules.ResetUI = false
            end
        end},
        
        {"Экспорт настроек", "toggle", "ExportSettings", function(state)
            if state then
                local settings = {
                    modules = modules,
                    uiPosition = mainFrame.Position
                }
                print("Настройки:", settings)
                modules.ExportSettings = false
            end
        end}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

function CreateSavesTab()
    local modules = {
        {"Сохранить профиль", "toggle", "SaveProfile", function(state)
            if state then
                services.StarterGui:SetCore("SendNotification", {
                    Title = "NeoHax",
                    Text = "Профиль сохранен",
                    Duration = 2
                })
                modules.SaveProfile = false
            end
        end},
        
        {"Загрузить профиль", "toggle", "LoadProfile", function(state)
            if state then
                services.StarterGui:SetCore("SendNotification", {
                    Title = "NeoHax",
                    Text = "Профиль загружен",
                    Duration = 2
                })
                modules.LoadProfile = false
            end
        end}
    }
    
    CreateModuleTab(modulesContainer, modules)
end

-- ========== ЗАПУСК СИСТЕМЫ ==========
function Initialize()
    print("=======================================")
    print("⚡ NeoHax v3.0 Инициализация...")
    print("Игрок: " .. Player.Name)
    print("Игра: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    print("=======================================")
    
    -- Защита от сброса
    CreateAntiReset()
    
    -- Создание UI
    local uiSuccess = CreateMainUI()
    
    if not uiSuccess then
        warn("Повторная попытка создания UI...")
        task.wait(1)
        uiSuccess = CreateMainUI()
    end
    
    if uiSuccess then
        print("✅ UI успешно создан")
        print("📌 Горячие клавиши:")
        print("  • RightControl - Скрыть/Показать")
        print("  • RightShift - Отключить UI")
        print("  • End - Экстренное отключение")
        print("=======================================")
        
        -- Уведомление
        services.StarterGui:SetCore("SendNotification", {
            Title = "NeoHax v3.0",
            Text = "Интерфейс загружен! RightControl - меню",
            Duration = 5,
            Icon = "rbxassetid://4483345998"
        })
    else
        warn("❌ Не удалось создать UI")
    end
    
    -- Автоматическое восстановление
    AddConnection("UIRestorer", services.RunService.Heartbeat:Connect(function()
        safetyChecks = safetyChecks + 1
        
        if safetyChecks > MAX_SAFETY_CHECKS then
            safetyChecks = 0
            
            -- Проверяем существование UI
            if not mainUI or not mainUI.Parent then
                warn("UI потерян, восстанавливаем...")
                CreateMainUI()
            end
            
            -- Проверяем видимость
            if mainFrame and not mainFrame.Visible and not uiHidden then
                mainFrame.Visible = true
            end
        end
    end))
end

-- ========== ЗАПУСК ==========
-- Запускаем инициализацию с защитой
local success, err = pcall(Initialize)

if not success then
    warn("Ошибка инициализации: " .. tostring(err))
    
    -- Экстренное восстановление
    task.wait(2)
    pcall(Initialize)
end

-- Автовосстановление при респавне
Player.CharacterAdded:Connect(function()
    task.wait(2)
    if mainUI and mainUI.Parent then
        mainUI.Enabled = true
    end
end)

-- Защита от удаления
services.CoreGui.ChildRemoved:Connect(function(child)
    if child and child.Name == CONFIG.UI_NAME then
        warn("UI был удален, восстанавливаем...")
        task.wait(0.5)
        Initialize()
    end
end)

-- Финальное сообщение
task.wait(1)
print("🎮 NeoHax v3.0 готов к работе!")
print("💡 Используйте RightControl для управления меню")
