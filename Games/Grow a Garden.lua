-- NeoHax v2.0 - Modern Dark UI с неоновыми акцентами
-- Автор: Anonymous
-- Версия: 2.0

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Игрок
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Цвета
local NEON_GREEN = Color3.fromRGB(0, 255, 140)
local DARK_BG = Color3.fromRGB(20, 20, 25)
local DARKER_BG = Color3.fromRGB(15, 15, 20)
local LIGHT_TEXT = Color3.fromRGB(240, 240, 240)
local GRAY_TEXT = Color3.fromRGB(180, 180, 180)

-- Переменные UI
local MainFrame
local dragging, dragInput, dragStart, startPos
local uiHidden = false
local connections = {}
local modules = {}

-- Утилиты
function Create(class, props)
    local obj = Instance.new(class)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    obj.Parent = props.Parent
    return obj
end

function Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

-- Создание UI
do
    -- Основной экран
    local ScreenGui = Create("ScreenGui", {
        Name = "NeoHaxUI_" .. HttpService:GenerateGUID(false):sub(1, 8),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Основной фрейм
    MainFrame = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = DARK_BG,
        BorderColor3 = Color3.fromRGB(40, 40, 45),
        BorderSizePixel = 2,
        ClipsDescendants = true
    })

    -- Скругление углов
    Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })

    -- Тень
    Create("UIStroke", {
        Parent = MainFrame,
        Color = NEON_GREEN,
        Thickness = 1,
        Transparency = 0.7
    })

    -- Шапка
    local Header = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = DARKER_BG,
        BorderSizePixel = 0
    })

    Create("UICorner", {
        Parent = Header,
        CornerRadius = UDim.new(0, 8)
    })

    -- Заголовок
    local Title = Create("TextLabel", {
        Parent = Header,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "🔧 NeoHax v2.0",
        TextColor3 = NEON_GREEN,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Кнопки управления
    local CloseButton = Create("TextButton", {
        Parent = Header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        Text = "×",
        TextColor3 = LIGHT_TEXT,
        TextSize = 24,
        Font = Enum.Font.GothamBold
    })

    Create("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(1, 0)
    })

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
    end)

    -- Кнопка скрытия
    local HideButton = Create("TextButton", {
        Parent = Header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        Text = "_",
        TextColor3 = LIGHT_TEXT,
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })

    Create("UICorner", {
        Parent = HideButton,
        CornerRadius = UDim.new(1, 0)
    })

    HideButton.MouseButton1Click:Connect(function()
        uiHidden = not uiHidden
        MainFrame.Visible = not uiHidden
    end)

    -- Боковая панель
    local Sidebar = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(0, 80, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = DARKER_BG,
        BorderSizePixel = 0
    })

    -- Контейнер модулей
    local ModulesContainer = Create("ScrollingFrame", {
        Parent = MainFrame,
        Size = UDim2.new(1, -80, 1, -40),
        Position = UDim2.new(0, 80, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = NEON_GREEN,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    -- Список вкладок
    local tabs = {
        {"🏃", "Movement", function()
            CreateModuleTab("Movement", {
                {"Speed Bypass", "toggle", function(state)
                    modules.SpeedHack = state
                    if state then
                        connections.Speed = RunService.Heartbeat:Connect(function()
                            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                                Player.Character.Humanoid.WalkSpeed = 50
                            end
                        end)
                    else
                        if connections.Speed then
                            connections.Speed:Disconnect()
                            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                                Player.Character.Humanoid.WalkSpeed = 16
                            end
                        end
                    end
                end},
                {"Fly Mode", "toggle", function(state)
                    modules.Fly = state
                    if state then
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                        bodyVelocity.Parent = Player.Character:FindFirstChild("HumanoidRootPart")
                        
                        connections.Fly = RunService.Heartbeat:Connect(function()
                            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                local root = Player.Character.HumanoidRootPart
                                local vel = root.Velocity
                                local newVel = Vector3.new(0, 0, 0)
                                
                                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                    newVel = newVel + (root.CFrame.LookVector * 100)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                    newVel = newVel - (root.CFrame.LookVector * 100)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                    newVel = newVel - (root.CFrame.RightVector * 100)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                    newVel = newVel + (root.CFrame.RightVector * 100)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                    newVel = newVel + Vector3.new(0, 100, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                                    newVel = newVel - Vector3.new(0, 100, 0)
                                end
                                
                                bodyVelocity.Velocity = newVel
                            end
                        end)
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
                {"Infinite Jump", "toggle", function(state)
                    modules.InfiniteJump = state
                    if state then
                        connections.Jump = UserInputService.JumpRequest:Connect(function()
                            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end)
                    else
                        if connections.Jump then
                            connections.Jump:Disconnect()
                        end
                    end
                end},
                {"Noclip", "toggle", function(state)
                    modules.Noclip = state
                    if state then
                        connections.Noclip = RunService.Stepped:Connect(function()
                            if Player.Character then
                                for _, part in pairs(Player.Character:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end)
                    else
                        if connections.Noclip then
                            connections.Noclip:Disconnect()
                        end
                    end
                end},
                {"Anti-Void", "toggle", function(state)
                    modules.AntiVoid = state
                    if state then
                        connections.AntiVoid = RunService.Heartbeat:Connect(function()
                            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                local root = Player.Character.HumanoidRootPart
                                if root.Position.Y < -100 then
                                    root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
                                end
                            end
                        end)
                    else
                        if connections.AntiVoid then
                            connections.AntiVoid:Disconnect()
                        end
                    end
                end},
                {"SpinBot", "toggle", function(state)
                    modules.SpinBot = state
                    if state then
                        connections.Spin = RunService.Heartbeat:Connect(function()
                            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                local root = Player.Character.HumanoidRootPart
                                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(30), 0)
                            end
                        end)
                    else
                        if connections.Spin then
                            connections.Spin:Disconnect()
                        end
                    end
                end}
            })
        end},
        {"🔫", "Combat", function()
            CreateModuleTab("Combat", {
                {"Aimbot", "toggle", function(state)
                    modules.Aimbot = state
                    if state then
                        connections.Aimbot = RunService.Heartbeat:Connect(function()
                            local closest = nil
                            local dist = math.huge
                            
                            for _, plr in pairs(Players:GetPlayers()) do
                                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                    local mag = (plr.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                                    if mag < dist and mag < 100 then
                                        dist = mag
                                        closest = plr.Character.HumanoidRootPart
                                    end
                                end
                            end
                            
                            if closest then
                                Player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                                    Player.Character.HumanoidRootPart.Position,
                                    Vector3.new(closest.Position.X, Player.Character.HumanoidRootPart.Position.Y, closest.Position.Z)
                                )
                            end
                        end)
                    else
                        if connections.Aimbot then
                            connections.Aimbot:Disconnect()
                        end
                    end
                end},
                {"Hitbox Expander", "toggle", function(state)
                    modules.Hitbox = state
                    if state then
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= Player and plr.Character then
                                local head = plr.Character:FindFirstChild("Head")
                                if head then
                                    head.Size = Vector3.new(5, 5, 5)
                                    head.Transparency = 0.5
                                    head.Color = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    else
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= Player and plr.Character then
                                local head = plr.Character:FindFirstChild("Head")
                                if head then
                                    head.Size = Vector3.new(2, 1, 1)
                                    head.Transparency = 0
                                    head.Color = Color3.new(1, 1, 1)
                                end
                            end
                        end
                    end
                end},
                {"Auto Clicker", "toggle", function(state)
                    modules.AutoClick = state
                    if state then
                        connections.Clicker = RunService.Heartbeat:Connect(function()
                            mouse1click()
                        end)
                    else
                        if connections.Clicker then
                            connections.Clicker:Disconnect()
                        end
                    end
                end},
                {"Silent Aim", "toggle", function(state)
                    modules.SilentAim = state
                end},
                {"Reach", "toggle", function(state)
                    modules.Reach = state
                end}
            })
        end},
        {"👁️", "Visuals", function()
            CreateModuleTab("Visuals", {
                {"Chams", "toggle", function(state)
                    modules.Chams = state
                    if state then
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= Player and plr.Character then
                                for _, part in pairs(plr.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        local highlight = Instance.new("Highlight")
                                        highlight.FillColor = NEON_GREEN
                                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                        highlight.FillTransparency = 0.3
                                        highlight.Parent = part
                                    end
                                end
                            end
                        end
                    else
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr.Character then
                                for _, part in pairs(plr.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        local highlight = part:FindFirstChild("Highlight")
                                        if highlight then
                                            highlight:Destroy()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end},
                {"FullBright", "toggle", function(state)
                    modules.FullBright = state
                    if state then
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                    else
                        Lighting.Brightness = 1
                        Lighting.FogEnd = 10000
                        Lighting.GlobalShadows = true
                    end
                end},
                {"No Fog", "toggle", function(state)
                    modules.NoFog = state
                    if state then
                        Lighting.FogEnd = 100000
                    else
                        Lighting.FogEnd = 10000
                    end
                end},
                {"ESP Boxes", "toggle", function(state)
                    modules.ESP = state
                end}
            })
        end},
        {"🌍", "World", function()
            CreateModuleTab("World", {
                {"Gravity Control", "slider", function(value)
                    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                        Player.Character.Humanoid.JumpPower = value * 2
                    end
                end, 0, 100, 50},
                {"Time Changer", "slider", function(value)
                    Lighting.ClockTime = value
                end, 0, 24, 14},
                {"Destroy Lava", "toggle", function(state)
                    modules.DestroyLava = state
                    if state then
                        for _, part in pairs(workspace:GetDescendants()) do
                            if part.Name:lower():find("lava") or part.Name:lower():find("fire") then
                                part:Destroy()
                            end
                        end
                    end
                end},
                {"Anti-AFK", "toggle", function(state)
                    modules.AntiAFK = state
                    if state then
                        connections.AntiAFK = RunService.Heartbeat:Connect(function()
                            VirtualInputManager:SendMouseMoveEvent(100, 100, workspace)
                            task.wait(1)
                            VirtualInputManager:SendMouseMoveEvent(200, 200, workspace)
                        end)
                    else
                        if connections.AntiAFK then
                            connections.AntiAFK:Disconnect()
                        end
                    end
                end},
                {"Chat Spy", "toggle", function(state)
                    modules.ChatSpy = state
                end}
            })
        end},
        {"⚙️", "Settings", function()
            CreateModuleTab("Settings", {
                {"UI Color", "color", function(color)
                    NEON_GREEN = color
                    Title.TextColor3 = color
                    -- Обновить другие элементы
                end},
                {"Reset All", "button", function()
                    for name, state in pairs(modules) do
                        if type(state) == "boolean" then
                            modules[name] = false
                        end
                    end
                end}
            })
        end}
    }

    -- Создание кнопок вкладок
    for i, tab in ipairs(tabs) do
        local TabButton = Create("TextButton", {
            Parent = Sidebar,
            Size = UDim2.new(1, -10, 0, 60),
            Position = UDim2.new(0, 5, 0, 10 + (i-1) * 65),
            BackgroundColor3 = DARK_BG,
            Text = tab[1] .. "\n" .. tab[2],
            TextColor3 = GRAY_TEXT,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextWrapped = true
        })

        Create("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })

        Create("UIStroke", {
            Parent = TabButton,
            Color = Color3.fromRGB(50, 50, 55),
            Thickness = 1
        })

        TabButton.MouseButton1Click:Connect(function()
            tab[3]()
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = DARK_BG, TextColor3 = GRAY_TEXT})
                end
            end
            Tween(TabButton, {BackgroundColor3 = NEON_GREEN, TextColor3 = Color3.fromRGB(0, 0, 0)})
        end)

        if i == 1 then
            tab[3]()
            Tween(TabButton, {BackgroundColor3 = NEON_GREEN, TextColor3 = Color3.fromRGB(0, 0, 0)})
        end
    end

    -- Функция создания модулей
    function CreateModuleTab(category, moduleList)
        for _, child in pairs(ModulesContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local yPos = 10
        for i, module in ipairs(moduleList) do
            local ModuleFrame = Create("Frame", {
                Parent = ModulesContainer,
                Size = UDim2.new(1, -20, 0, 50),
                Position = UDim2.new(0, 10, 0, yPos),
                BackgroundColor3 = DARKER_BG,
                ClipsDescendants = true
            })

            Create("UICorner", {
                Parent = ModuleFrame,
                CornerRadius = UDim.new(0, 6)
            })

            Create("UIStroke", {
                Parent = ModuleFrame,
                Color = Color3.fromRGB(50, 50, 55),
                Thickness = 1
            })

            local ModuleName = Create("TextLabel", {
                Parent = ModuleFrame,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = module[1],
                TextColor3 = LIGHT_TEXT,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            if module[2] == "toggle" then
                local ToggleFrame = Create("Frame", {
                    Parent = ModuleFrame,
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -70, 0.5, -12.5),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                })

                Create("UICorner", {
                    Parent = ToggleFrame,
                    CornerRadius = UDim.new(1, 0)
                })

                local ToggleCircle = Create("Frame", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = UDim2.new(0, 2, 0.5, -10.5),
                    BackgroundColor3 = LIGHT_TEXT
                })

                Create("UICorner", {
                    Parent = ToggleCircle,
                    CornerRadius = UDim.new(1, 0)
                })

                local enabled = false
                
                local function UpdateToggle()
                    if enabled then
                        Tween(ToggleFrame, {BackgroundColor3 = NEON_GREEN})
                        Tween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10.5)})
                    else
                        Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)})
                        Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -10.5)})
                    end
                    module[3](enabled)
                end

                ModuleFrame.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    UpdateToggle()
                end)

                ModuleFrame.MouseButton2Click:Connect(function()
                    -- Открыть дополнительные настройки
                    print("Дополнительные настройки для: " .. module[1])
                end)

            elseif module[2] == "slider" then
                -- Реализация слайдера
                local SliderFrame = Create("Frame", {
                    Parent = ModuleFrame,
                    Size = UDim2.new(0, 150, 0, 5),
                    Position = UDim2.new(1, -160, 0.5, -2.5),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                })

                Create("UICorner", {
                    Parent = SliderFrame,
                    CornerRadius = UDim.new(1, 0)
                })

                local SliderFill = Create("Frame", {
                    Parent = SliderFrame,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundColor3 = NEON_GREEN
                })

                Create("UICorner", {
                    Parent = SliderFill,
                    CornerRadius = UDim.new(1, 0)
                })

                local SliderButton = Create("TextButton", {
                    Parent = SliderFrame,
                    Size = UDim2.new(0, 15, 0, 15),
                    Position = UDim2.new(0.5, -7.5, 0.5, -7.5),
                    BackgroundColor3 = LIGHT_TEXT,
                    Text = "",
                    ZIndex = 2
                })

                Create("UICorner", {
                    Parent = SliderButton,
                    CornerRadius = UDim.new(1, 0)
                })

                local min = module[4] or 0
                local max = module[5] or 100
                local default = module[6] or 50
                local value = default

                local function UpdateSlider(val)
                    local percent = (val - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderButton.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
                    module[3](val)
                end

                UpdateSlider(default)

                local draggingSlider = false
                
                SliderButton.MouseButton1Down:Connect(function()
                    draggingSlider = true
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)

                SliderFrame.MouseButton1Down:Connect(function(x, y)
                    local percent = (x - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X
                    percent = math.clamp(percent, 0, 1)
                    value = min + (max - min) * percent
                    UpdateSlider(value)
                end)

                ModuleFrame.MouseButton2Click:Connect(function()
                    -- Открыть дополнительные настройки
                    print("Доп. настройки слайдера: " .. module[1])
                end)
            end

            yPos = yPos + 60
        end

        ModulesContainer.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
    end

    -- Drag and Drop
    local function updateDrag(input)
        if not dragging then return end
        
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    -- Скрытие по RightControl
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            uiHidden = not uiHidden
            MainFrame.Visible = not uiHidden
        end
    end)
end

-- Инициализация
Player.CharacterAdded:Connect(function(character)
    -- Обновить ссылки на персонажа
    task.wait(1)
end)

print("✅ NeoHax v2.0 loaded!")
print("📌 Controls:")
print("  • RightControl - Hide/Show UI")
print("  • LMB - Toggle modules")
print("  • RMB - Additional settings")
print("  • Drag header - Move UI")
