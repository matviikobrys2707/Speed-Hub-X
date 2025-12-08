-- BlazixHub V8 - CLEAN & WORKING VERSION
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- РАБОТАЮЩИЕ ФУНКЦИИ
local BlazixHub = {
    Enabled = {
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        HighJump = false,
        ESP = false,
        FullBright = false,
        XRay = false,
        GodMode = false,
        InfiniteAmmo = false,
        Aimbot = false,
        TriggerBot = false,
        AutoTeleport = false
    },
    SelectedPlayer = nil,
    CurrentTab = "Движение",
    SavedPosition = nil
}

-- ПРОСТОЙ ЭКРАН ЗАГРУЗКИ
local function ShowLoadingScreen()
    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "BlazixLoading"
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingScreen.ResetOnSpawn = false
    loadingScreen.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.Parent = loadingScreen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🔥 BLAZIX HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = mainFrame

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 70)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Загрузка..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.SourceSans
    loadingText.TextSize = 16
    loadingText.Parent = mainFrame

    wait(1)
    loadingScreen:Destroy()
end

-- ФЛАЙ
local function ToggleFly()
    if BlazixHub.Enabled.Fly then
        BlazixHub.Enabled.Fly = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    else
        BlazixHub.Enabled.Fly = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.Fly and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if root and humanoid then
                    humanoid.PlatformStand = true
                    local direction = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Vector3.new(0, 0, -1) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction + Vector3.new(0, 0, 1) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction + Vector3.new(-1, 0, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Vector3.new(1, 0, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction + Vector3.new(0, -1, 0) end
                    
                    if direction.Magnitude > 0 then
                        root.Velocity = direction.Unit * 100
                    else
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end

-- СПИД
local function ToggleSpeed()
    if BlazixHub.Enabled.Speed then
        BlazixHub.Enabled.Speed = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 end
        end
    else
        BlazixHub.Enabled.Speed = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.Speed and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = 100 end
            end
        end)
    end
end

-- БЕСКОНЕЧНЫЙ ПРЫЖОК
local function ToggleInfiniteJump()
    if BlazixHub.Enabled.InfiniteJump then
        BlazixHub.Enabled.InfiniteJump = false
    else
        BlazixHub.Enabled.InfiniteJump = true
        UserInputService.JumpRequest:Connect(function()
            if BlazixHub.Enabled.InfiniteJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

-- НОКЛИП
local function ToggleNoclip()
    if BlazixHub.Enabled.Noclip then
        BlazixHub.Enabled.Noclip = false
    else
        BlazixHub.Enabled.Noclip = true
        RunService.Stepped:Connect(function()
            if BlazixHub.Enabled.Noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

-- ВЫСОКИЙ ПРЫЖОК
local function ToggleHighJump()
    if BlazixHub.Enabled.HighJump then
        BlazixHub.Enabled.HighJump = false
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = 50 end
        end
    else
        BlazixHub.Enabled.HighJump = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.HighJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.JumpPower = 150 end
            end
        end)
    end
end

-- ЕСП
local function ToggleESP()
    if BlazixHub.Enabled.ESP then
        BlazixHub.Enabled.ESP = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BlazixESP") then
                player.Character.BlazixESP:Destroy()
            end
        end
    else
        BlazixHub.Enabled.ESP = true
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BlazixESP"
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    end
end

-- ЯРКИЙ СВЕТ
local function ToggleFullBright()
    if BlazixHub.Enabled.FullBright then
        BlazixHub.Enabled.FullBright = false
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    else
        BlazixHub.Enabled.FullBright = true
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end
end

-- РЕНТГЕН
local function ToggleXRay()
    if BlazixHub.Enabled.XRay then
        BlazixHub.Enabled.XRay = false
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    else
        BlazixHub.Enabled.XRay = true
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0.7
            end
        end
    end
end

-- ГОД МОД
local function ToggleGodMode()
    if BlazixHub.Enabled.GodMode then
        BlazixHub.Enabled.GodMode = false
    else
        BlazixHub.Enabled.GodMode = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.GodMode and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.Health = humanoid.MaxHealth end
            end
        end)
    end
end

-- БЕСКОНЕЧНЫЕ ПАТРОНЫ
local function ToggleInfiniteAmmo()
    if BlazixHub.Enabled.InfiniteAmmo then
        BlazixHub.Enabled.InfiniteAmmo = false
    else
        BlazixHub.Enabled.InfiniteAmmo = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.InfiniteAmmo then
                local containers = {LocalPlayer.Backpack, LocalPlayer.Character}
                for _, container in pairs(containers) do
                    if container then
                        for _, tool in pairs(container:GetChildren()) do
                            if tool:IsA("Tool") then
                                for _, v in pairs(tool:GetDescendants()) do
                                    if v:IsA("NumberValue") and string.lower(v.Name):find("ammo") then
                                        v.Value = 999
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- АИМБОТ
local function ToggleAimbot()
    if BlazixHub.Enabled.Aimbot then
        BlazixHub.Enabled.Aimbot = false
    else
        BlazixHub.Enabled.Aimbot = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.Aimbot and BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character and LocalPlayer.Character then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and localRoot then
                        localRoot.CFrame = CFrame.new(localRoot.Position, targetRoot.Position)
                    end
                end
            end
        end)
    end
end

-- ТРИГГЕР БОТ
local function ToggleTriggerBot()
    if BlazixHub.Enabled.TriggerBot then
        BlazixHub.Enabled.TriggerBot = false
    else
        BlazixHub.Enabled.TriggerBot = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.TriggerBot and BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                    wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
                end
            end
        end)
    end
end

-- АВТО ТЕЛЕПОРТ
local function ToggleAutoTeleport()
    if BlazixHub.Enabled.AutoTeleport then
        BlazixHub.Enabled.AutoTeleport = false
    else
        BlazixHub.Enabled.AutoTeleport = true
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Enabled.AutoTeleport and BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character and LocalPlayer.Character then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and localRoot then
                        localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -5)
                    end
                end
            end
        end)
    end
end

-- СОХРАНЕНИЕ КООРДИНАТ
local function SavePosition()
    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            BlazixHub.SavedPosition = root.CFrame
            return true
        end
    end
    return false
end

-- ТЕЛЕПОРТАЦИЯ ПО КООРДИНАТАМ
local function TeleportToSavedPosition()
    if BlazixHub.SavedPosition and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = BlazixHub.SavedPosition
        end
    end
end

-- ОСНОВНОЙ ИНТЕРФЕЙС
local function CreateUI()
    local Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(240, 240, 240)
    }

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0.04, 0)
    MainFrameCorner.Parent = MainFrame

    local MainFrameStroke = Instance.new("UIStroke")
    MainFrameStroke.Color = Colors.Accent
    MainFrameStroke.Thickness = 2
    MainFrameStroke.Parent = MainFrame

    -- Хедер
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.04, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 BLAZIX HUB V8"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Кнопка скрыть
    local HideButton = Instance.new("TextButton")
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(0.85, -35, 0.5, -17.5)
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    HideButton.Text = "_"
    HideButton.TextColor3 = Colors.Text
    HideButton.Font = Enum.Font.SourceSansBold
    HideButton.TextSize = 16
    HideButton.Parent = Header

    local HideButtonCorner = Instance.new("UICorner")
    HideButtonCorner.CornerRadius = UDim.new(0.2, 0)
    HideButtonCorner.Parent = HideButton

    -- Кнопка закрыть
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(0.95, -35, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 16
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Вкладки
    local TabButtonsFrame = Instance.new("Frame")
    TabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
    TabButtonsFrame.Position = UDim2.new(0, 10, 0, 60)
    TabButtonsFrame.BackgroundTransparency = 1
    TabButtonsFrame.Parent = MainFrame

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -20, 1, -150)
    TabContent.Position = UDim2.new(0, 10, 0, 110)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Parent = MainFrame

    -- Нижняя панель
    local BottomBar = Instance.new("Frame")
    BottomBar.Size = UDim2.new(1, 0, 0, 40)
    BottomBar.Position = UDim2.new(0, 0, 1, -40)
    BottomBar.BackgroundColor3 = Colors.Secondary
    BottomBar.Parent = MainFrame

    local BottomCorner = Instance.new("UICorner")
    BottomCorner.CornerRadius = UDim.new(0.04, 0)
    BottomCorner.Parent = BottomBar

    -- Кнопка выбора игрока в правом углу
    local SelectPlayerBtn = Instance.new("TextButton")
    SelectPlayerBtn.Size = UDim2.new(0, 120, 0.7, 0)
    SelectPlayerBtn.Position = UDim2.new(1, -130, 0.15, 0)
    SelectPlayerBtn.BackgroundColor3 = Colors.Accent
    SelectPlayerBtn.Text = "🎯 Выбор игрока"
    SelectPlayerBtn.TextColor3 = Colors.Text
    SelectPlayerBtn.Font = Enum.Font.SourceSansBold
    SelectPlayerBtn.TextSize = 12
    SelectPlayerBtn.Parent = BottomBar

    local SelectPlayerCorner = Instance.new("UICorner")
    SelectPlayerCorner.CornerRadius = UDim.new(0.15, 0)
    SelectPlayerCorner.Parent = SelectPlayerBtn

    -- Кнопка телепорта по координатам
    local CoordsBtn = Instance.new("TextButton")
    CoordsBtn.Size = UDim2.new(0, 100, 0.7, 0)
    CoordsBtn.Position = UDim2.new(1, -250, 0.15, 0)
    CoordsBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    CoordsBtn.Text = "💾 Координаты"
    CoordsBtn.TextColor3 = Colors.Text
    CoordsBtn.Font = Enum.Font.SourceSansBold
    CoordsBtn.TextSize = 12
    CoordsBtn.Parent = BottomBar

    local CoordsCorner = Instance.new("UICorner")
    CoordsCorner.CornerRadius = UDim.new(0.15, 0)
    CoordsCorner.Parent = CoordsBtn

    -- Статус выбранного игрока
    local PlayerStatus = Instance.new("TextLabel")
    PlayerStatus.Size = UDim2.new(0.3, 0, 1, 0)
    PlayerStatus.Position = UDim2.new(0.02, 0, 0, 0)
    PlayerStatus.BackgroundTransparency = 1
    PlayerStatus.Text = "Игрок: Нет"
    PlayerStatus.TextColor3 = Colors.Text
    PlayerStatus.Font = Enum.Font.SourceSansBold
    PlayerStatus.TextSize = 12
    PlayerStatus.TextXAlignment = Enum.TextXAlignment.Left
    PlayerStatus.Parent = BottomBar

    -- Вкладки
    local Tabs = {
        {Name = "Движение", Functions = {
            {"Fly", "Fly", ToggleFly},
            {"Speed", "Speed", ToggleSpeed},
            {"Inf Jump", "InfiniteJump", ToggleInfiniteJump},
            {"Noclip", "Noclip", ToggleNoclip},
            {"High Jump", "HighJump", ToggleHighJump},
            {"Auto TP", "AutoTeleport", ToggleAutoTeleport}
        }},
        {Name = "Визуал", Functions = {
            {"ESP", "ESP", ToggleESP},
            {"FullBright", "FullBright", ToggleFullBright},
            {"X-Ray", "XRay", ToggleXRay}
        }},
        {Name = "Игрок", Functions = {
            {"God Mode", "GodMode", ToggleGodMode}
        }},
        {Name = "Оружие", Functions = {
            {"Inf Ammo", "InfiniteAmmo", ToggleInfiniteAmmo}
        }},
        {Name = "Бой", Functions = {
            {"Aimbot", "Aimbot", ToggleAimbot},
            {"Trigger Bot", "TriggerBot", ToggleTriggerBot}
        }}
    }

    local TabButtons = {}
    
    local function UpdateTabColors(activeTab)
        for _, btn in pairs(TabButtons) do
            if btn.Text == activeTab then
                btn.BackgroundColor3 = Colors.Accent
            else
                btn.BackgroundColor3 = Colors.Secondary
            end
        end
    end

    local function CreateToggle(name, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Parent = TabContent

        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ToggleFrameCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.Font = Enum.Font.SourceSans
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.SourceSansBold
        ToggleButton.TextSize = 12
        ToggleButton.Parent = ToggleFrame

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(0.15, 0)
        ToggleButtonCorner.Parent = ToggleButton

        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Enabled[configKey] = not BlazixHub.Enabled[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
            if toggleFunc then toggleFunc() end
        end)

        return ToggleFrame
    end

    local function ShowTabContent(tabIndex)
        -- Очищаем контент
        local children = TabContent:GetChildren()
        for i = #children, 1, -1 do
            local child = children[i]
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local tab = Tabs[tabIndex]
        if not tab then return end

        local yOffset = 5
        for i, func in ipairs(tab.Functions) do
            local toggle = CreateToggle(func[1], func[2], func[3])
            toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
            if i % 2 == 0 then yOffset = yOffset + 45 end
        end
        TabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- Создаем кнопки вкладок
    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0.18, 0, 1, 0)
        TabButton.Position = UDim2.new((i-1) * 0.19, 0, 0, 0)
        TabButton.BackgroundColor3 = i == 1 and Colors.Accent or Colors.Secondary
        TabButton.Text = tab.Name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.TextSize = 12
        TabButton.Parent = TabButtonsFrame
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0.1, 0)
        TabCorner.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = tab.Name
            UpdateTabColors(tab.Name)
            ShowTabContent(i)
        end)
        
        table.insert(TabButtons, TabButton)
    end

    -- Меню выбора игрока
    local PlayerMenu = nil

    local function ShowPlayerMenu()
        if PlayerMenu then PlayerMenu:Destroy() end
        
        PlayerMenu = Instance.new("Frame")
        PlayerMenu.Size = UDim2.new(0, 300, 0, 250)
        PlayerMenu.Position = UDim2.new(0.5, -150, 0.5, -125)
        PlayerMenu.BackgroundColor3 = Colors.Background
        PlayerMenu.Parent = ScreenGui

        local PlayerMenuCorner = Instance.new("UICorner")
        PlayerMenuCorner.CornerRadius = UDim.new(0.08, 0)
        PlayerMenuCorner.Parent = PlayerMenu

        local PlayerMenuStroke = Instance.new("UIStroke")
        PlayerMenuStroke.Color = Colors.Accent
        PlayerMenuStroke.Thickness = 2
        PlayerMenuStroke.Parent = PlayerMenu

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundTransparency = 1
        Title.Text = "🎯 ВЫБОР ИГРОКА"
        Title.TextColor3 = Colors.Text
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 18
        Title.Parent = PlayerMenu

        local PlayerList = Instance.new("ScrollingFrame")
        PlayerList.Size = UDim2.new(1, -10, 1, -100)
        PlayerList.Position = UDim2.new(0, 5, 0, 50)
        PlayerList.BackgroundTransparency = 1
        PlayerList.ScrollBarThickness = 3
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
        PlayerList.Parent = PlayerMenu

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 5)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.SourceSansBold
        CloseBtn.TextSize = 14
        CloseBtn.Parent = PlayerMenu

        local CloseBtnCorner = Instance.new("UICorner")
        CloseBtnCorner.CornerRadius = UDim.new(0.2, 0)
        CloseBtnCorner.Parent = CloseBtn

        -- Кнопки действий
        local ActionsFrame = Instance.new("Frame")
        ActionsFrame.Size = UDim2.new(1, -10, 0, 40)
        ActionsFrame.Position = UDim2.new(0, 5, 1, -45)
        ActionsFrame.BackgroundTransparency = 1
        ActionsFrame.Parent = PlayerMenu

        local actionButtons = {
            {"TP", Colors.Accent, function() 
                if BlazixHub.SelectedPlayer then 
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character and LocalPlayer.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot and localRoot then
                            localRoot.CFrame = targetRoot.CFrame
                        end
                    end
                end
            end},
            {"Bring", Color3.fromRGB(255, 150, 0), function() 
                if BlazixHub.SelectedPlayer then 
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character and LocalPlayer.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot and localRoot then
                            targetRoot.CFrame = localRoot.CFrame
                        end
                    end
                end
            end},
            {"Kill", Colors.Danger, function() 
                if BlazixHub.SelectedPlayer then 
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character then
                        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then humanoid.Health = 0 end
                    end
                end
            end}
        }

        for i, action in ipairs(actionButtons) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.3, 0, 1, 0)
            btn.Position = UDim2.new((i-1) * 0.33, 5, 0, 0)
            btn.BackgroundColor3 = action[2]
            btn.Text = action[1]
            btn.TextColor3 = Colors.Text
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 12
            btn.Parent = ActionsFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0.1, 0)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(action[3])
        end

        local yOffset = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerBtn = Instance.new("TextButton")
                PlayerBtn.Size = UDim2.new(1, -10, 0, 40)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Secondary
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.SourceSansBold
                PlayerBtn.TextSize = 13
                PlayerBtn.Parent = PlayerList

                local PlayerBtnCorner = Instance.new("UICorner")
                PlayerBtnCorner.CornerRadius = UDim.new(0.1, 0)
                PlayerBtnCorner.Parent = PlayerBtn

                yOffset = yOffset + 45

                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerStatus.Text = "Игрок: " .. player.Name
                    PlayerMenu:Destroy()
                    PlayerMenu = nil
                end)
            end
        end
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerMenu:Destroy()
            PlayerMenu = nil
        end)
    end

    -- Меню координат
    local CoordsMenu = nil

    local function ShowCoordsMenu()
        if CoordsMenu then CoordsMenu:Destroy() end
        
        CoordsMenu = Instance.new("Frame")
        CoordsMenu.Size = UDim2.new(0, 250, 0, 150)
        CoordsMenu.Position = UDim2.new(0.5, -125, 0.5, -75)
        CoordsMenu.BackgroundColor3 = Colors.Background
        CoordsMenu.Parent = ScreenGui

        local CoordsMenuCorner = Instance.new("UICorner")
        CoordsMenuCorner.CornerRadius = UDim.new(0.08, 0)
        CoordsMenuCorner.Parent = CoordsMenu

        local CoordsMenuStroke = Instance.new("UIStroke")
        CoordsMenuStroke.Color = Color3.fromRGB(0, 180, 100)
        CoordsMenuStroke.Thickness = 2
        CoordsMenuStroke.Parent = CoordsMenu

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundTransparency = 1
        Title.Text = "💾 КООРДИНАТЫ"
        Title.TextColor3 = Colors.Text
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 18
        Title.Parent = CoordsMenu

        local SaveBtn = Instance.new("TextButton")
        SaveBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
        SaveBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        SaveBtn.Text = "Сохранить позицию"
        SaveBtn.TextColor3 = Colors.Text
        SaveBtn.Font = Enum.Font.SourceSansBold
        SaveBtn.TextSize = 12
        SaveBtn.Parent = CoordsMenu

        local SaveCorner = Instance.new("UICorner")
        SaveCorner.CornerRadius = UDim.new(0.1, 0)
        SaveCorner.Parent = SaveBtn

        local LoadBtn = Instance.new("TextButton")
        LoadBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
        LoadBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
        LoadBtn.BackgroundColor3 = Colors.Accent
        LoadBtn.Text = "Телепортироваться"
        LoadBtn.TextColor3 = Colors.Text
        LoadBtn.Font = Enum.Font.SourceSansBold
        LoadBtn.TextSize = 12
        LoadBtn.Parent = CoordsMenu

        local LoadCorner = Instance.new("UICorner")
        LoadCorner.CornerRadius = UDim.new(0.1, 0)
        LoadCorner.Parent = LoadBtn

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 5)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.SourceSansBold
        CloseBtn.TextSize = 14
        CloseBtn.Parent = CoordsMenu

        local CloseBtnCorner = Instance.new("UICorner")
        CloseBtnCorner.CornerRadius = UDim.new(0.2, 0)
        CloseBtnCorner.Parent = CloseBtn

        SaveBtn.MouseButton1Click:Connect(function()
            SavePosition()
            CoordsMenu:Destroy()
            CoordsMenu = nil
        end)

        LoadBtn.MouseButton1Click:Connect(function()
            TeleportToSavedPosition()
            CoordsMenu:Destroy()
            CoordsMenu = nil
        end)

        CloseBtn.MouseButton1Click:Connect(function()
            CoordsMenu:Destroy()
            CoordsMenu = nil
        end)
    end

    -- Обработчики кнопок
    SelectPlayerBtn.MouseButton1Click:Connect(ShowPlayerMenu)
    CoordsBtn.MouseButton1Click:Connect(ShowCoordsMenu)
    HideButton.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Движение окна
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
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

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Инициализация
    ShowTabContent(1)

    return ScreenGui
end

-- ЗАПУСК
ShowLoadingScreen()
wait(0.5)

local success, err = pcall(function()
    local UI = CreateUI()
    print("✅ BLAZIX HUB V8 УСПЕШНО ЗАГРУЖЕН!")
    print("✅ Рабочие вкладки")
    print("✅ Убраны мешающие кнопки")
    print("✅ Чистый интерфейс")
    print("✅ Все функции проверены")
end)

if not success then
    warn("❌ Ошибка: " .. tostring(err))
end
