-- BlazixHub V6 - WORKING VERSION
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ТОЛЬКО РАБОТАЮЩИЕ ФУНКЦИИ
local BlazixHub = {
    Enabled = {
        -- Работающие функции
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        HighJump = false,
        ESP = false,
        FullBright = false,
        XRay = false,
        NightVision = false,
        GodMode = false,
        InfiniteStamina = false,
        NoFallDamage = false,
        InfiniteAmmo = false,
        Aimbot = false,
        TriggerBot = false,
        AutoTeleport = false
    },
    Connections = {},
    SelectedPlayer = nil,
    CurrentTab = "Movement"
}

-- ЭКРАН ЗАГРУЗКИ
local function ShowLoadingScreen()
    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "BlazixLoading"
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingScreen.ResetOnSpawn = false
    loadingScreen.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.Parent = loadingScreen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 100, 255)
    stroke.Thickness = 3
    stroke.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🔥 BLAZIX HUB V6"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24
    title.Parent = mainFrame

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 80)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 16
    loadingText.Parent = mainFrame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0.8, 0, 0, 10)
    progressBar.Position = UDim2.new(0.1, 0, 0, 130)
    progressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBar.Parent = mainFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0)
    progressCorner.Parent = progressBar

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    progressFill.Parent = progressBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = progressFill

    -- Анимация загрузки
    local startTime = tick()
    
    RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 2, 1) -- 2 секунды загрузки
        
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        loadingText.Text = "Loading... " .. math.floor(progress * 100) .. "%"
        
        if progress >= 1 then
            loadingScreen:Destroy()
        end
    end)
    
    return loadingScreen
end

-- РАБОТАЮЩИЕ ФУНКЦИИ

-- ФЛАЙ
local function ToggleFly()
    if BlazixHub.Connections.Fly then
        BlazixHub.Connections.Fly:Disconnect()
        BlazixHub.Connections.Fly = nil
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        return
    end
    
    BlazixHub.Connections.Fly = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.Fly and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if root and humanoid then
                humanoid.PlatformStand = true
                local cam = Workspace.CurrentCamera
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
                
                if direction.Magnitude > 0 then
                    root.Velocity = direction.Unit * 100
                else
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end

-- СПИД
local function ToggleSpeed()
    if BlazixHub.Connections.Speed then
        BlazixHub.Connections.Speed:Disconnect()
        BlazixHub.Connections.Speed = nil
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 end
        end
        return
    end
    
    BlazixHub.Connections.Speed = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.Speed and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = 100 end
        end
    end)
end

-- БЕСКОНЕЧНЫЙ ПРЫЖОК
local function ToggleInfiniteJump()
    if BlazixHub.Connections.InfiniteJump then
        BlazixHub.Connections.InfiniteJump:Disconnect()
        BlazixHub.Connections.InfiniteJump = nil
        return
    end
    
    BlazixHub.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
        if BlazixHub.Enabled.InfiniteJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- ВЫСОКИЙ ПРЫЖОК
local function ToggleHighJump()
    if BlazixHub.Connections.HighJump then
        BlazixHub.Connections.HighJump:Disconnect()
        BlazixHub.Connections.HighJump = nil
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = 50 end
        end
        return
    end
    
    BlazixHub.Connections.HighJump = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.HighJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = 150 end
        end
    end)
end

-- НОКЛИП
local function ToggleNoclip()
    if BlazixHub.Connections.Noclip then
        BlazixHub.Connections.Noclip:Disconnect()
        BlazixHub.Connections.Noclip = nil
        return
    end
    
    BlazixHub.Connections.Noclip = RunService.Stepped:Connect(function()
        if BlazixHub.Enabled.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- ГОД МОД
local function ToggleGodMode()
    if BlazixHub.Connections.GodMode then
        BlazixHub.Connections.GodMode:Disconnect()
        BlazixHub.Connections.GodMode = nil
        return
    end
    
    BlazixHub.Connections.GodMode = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.GodMode and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                if humanoid.Health <= 1 then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    end)
end

-- ЕСП
local function ToggleESP()
    if BlazixHub.Enabled.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if player.Character:FindFirstChild("BlazixESP") then
                    player.Character.BlazixESP:Destroy()
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "BlazixESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BlazixESP") then
                player.Character.BlazixESP:Destroy()
            end
        end
    end
end

-- ЯРКИЙ СВЕТ
local function ToggleFullBright()
    if BlazixHub.Enabled.FullBright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end

-- РЕНТГЕН
local function ToggleXRay()
    if BlazixHub.Enabled.XRay then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.9 then
                part.LocalTransparencyModifier = 0.8
            end
        end
    else
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- НОЧНОЕ ВИДЕНИЕ
local function ToggleNightVision()
    if BlazixHub.Enabled.NightVision then
        Lighting.Ambient = Color3.fromRGB(128, 128, 255)
        Lighting.Brightness = 0.5
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
    end
end

-- БЕСКОНЕЧНЫЕ ПАТРОНЫ
local function ToggleInfiniteAmmo()
    if BlazixHub.Connections.InfiniteAmmo then
        BlazixHub.Connections.InfiniteAmmo:Disconnect()
        BlazixHub.Connections.InfiniteAmmo = nil
        return
    end
    
    BlazixHub.Connections.InfiniteAmmo = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.InfiniteAmmo then
            local containers = {LocalPlayer.Backpack, LocalPlayer.Character}
            for _, container in pairs(containers) do
                if container then
                    for _, tool in pairs(container:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, v in pairs(tool:GetDescendants()) do
                                if v:IsA("NumberValue") or v:IsA("IntValue") then
                                    if string.lower(v.Name):find("ammo") or string.lower(v.Name):find("bullet") then
                                        v.Value = 999
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- БЕСКОНЕЧНАЯ ВЫНОСЛИВОСТЬ
local function ToggleInfiniteStamina()
    if BlazixHub.Connections.InfiniteStamina then
        BlazixHub.Connections.InfiniteStamina:Disconnect()
        BlazixHub.Connections.InfiniteStamina = nil
        return
    end
    
    BlazixHub.Connections.InfiniteStamina = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.InfiniteStamina and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, v in pairs(humanoid:GetChildren()) do
                    if v:IsA("NumberValue") and string.lower(v.Name):find("stamina") then
                        v.Value = 100
                    end
                end
            end
        end
    end)
end

-- БЕЗ УРОНА ОТ ПАДЕНИЯ
local function ToggleNoFallDamage()
    if BlazixHub.Connections.NoFallDamage then
        BlazixHub.Connections.NoFallDamage:Disconnect()
        BlazixHub.Connections.NoFallDamage = nil
        return
    end
    
    BlazixHub.Connections.NoFallDamage = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.NoFallDamage and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and root.Velocity.Y < -50 then
                root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
            end
        end
    end)
end

-- АИМБОТ
local function ToggleAimbot()
    if BlazixHub.Connections.Aimbot then
        BlazixHub.Connections.Aimbot:Disconnect()
        BlazixHub.Connections.Aimbot = nil
        return
    end
    
    BlazixHub.Connections.Aimbot = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.Aimbot and BlazixHub.SelectedPlayer then
            local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
            if target and target.Character and LocalPlayer.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot and localRoot then
                    local direction = (targetRoot.Position - localRoot.Position).Unit
                    local newCF = CFrame.new(localRoot.Position, localRoot.Position + direction)
                    localRoot.CFrame = newCF
                end
            end
        end
    end)
end

-- ТРИГГЕР БОТ
local function ToggleTriggerBot()
    if BlazixHub.Connections.TriggerBot then
        BlazixHub.Connections.TriggerBot:Disconnect()
        BlazixHub.Connections.TriggerBot = nil
        return
    end
    
    BlazixHub.Connections.TriggerBot = RunService.Heartbeat:Connect(function()
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

-- АВТО ТЕЛЕПОРТ
local function ToggleAutoTeleport()
    if BlazixHub.Connections.AutoTeleport then
        BlazixHub.Connections.AutoTeleport:Disconnect()
        BlazixHub.Connections.AutoTeleport = nil
        return
    end
    
    BlazixHub.Connections.AutoTeleport = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.AutoTeleport and BlazixHub.SelectedPlayer then
            local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
            if target and target.Character and LocalPlayer.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot and localRoot then
                    local offset = targetRoot.CFrame.lookVector * -4
                    local newPosition = targetRoot.Position + offset + Vector3.new(0, 3, 0)
                    localRoot.CFrame = CFrame.new(newPosition, targetRoot.Position)
                end
            end
        end
    end)
end

-- ФУНКЦИИ ДЛЯ ИГРОКОВ
local function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
        end
    end
end

local function BringPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            targetRoot.CFrame = localRoot.CFrame
        end
    end
end

local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then 
            humanoid.Health = 0
        end
    end
end

local function KillAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.Health = 0
            end
        end
    end
end

-- ЗАКРЫТЬ СКРИПТ
local function CloseScript()
    for name, connection in pairs(BlazixHub.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    for key, _ in pairs(BlazixHub.Enabled) do
        BlazixHub.Enabled[key] = false
    end
    
    if CoreGui:FindFirstChild("BlazixUltimate") then
        CoreGui:FindFirstChild("BlazixUltimate"):Destroy()
    end
end

-- ОСНОВНОЙ ИНТЕРФЕЙС С ВКЛАДКАМИ СЛЕВА
local function CreateUltimateUI()
    local Colors = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(0, 100, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(240, 240, 240)
    }

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixUltimate"
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

    -- Вкладки слева
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 100, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Colors.Secondary
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabContainer

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
    Title.Text = "🔥 BLAZIX HUB"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Кнопка закрытия
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(0.95, -35, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBlack
    CloseButton.TextSize = 16
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Вкладки
    local Tabs = {
        {Name = "Движение", Key = "Movement", Functions = {
            {"Fly", "Fly", ToggleFly},
            {"Speed", "Speed", ToggleSpeed},
            {"Infinite Jump", "InfiniteJump", ToggleInfiniteJump},
            {"Noclip", "Noclip", ToggleNoclip},
            {"High Jump", "HighJump", ToggleHighJump}
        }},
        {Name = "Визуал", Key = "Visuals", Functions = {
            {"ESP", "ESP", ToggleESP},
            {"FullBright", "FullBright", ToggleFullBright},
            {"XRay", "XRay", ToggleXRay},
            {"Night Vision", "NightVision", ToggleNightVision}
        }},
        {Name = "Игрок", Key = "Player", Functions = {
            {"God Mode", "GodMode", ToggleGodMode},
            {"Infinite Stamina", "InfiniteStamina", ToggleInfiniteStamina},
            {"No Fall Damage", "NoFallDamage", ToggleNoFallDamage}
        }},
        {Name = "Оружие", Key = "Weapon", Functions = {
            {"Infinite Ammo", "InfiniteAmmo", ToggleInfiniteAmmo}
        }},
        {Name = "Бой", Key = "Combat", Functions = {
            {"Aimbot", "Aimbot", ToggleAimbot},
            {"Trigger Bot", "TriggerBot", ToggleTriggerBot},
            {"Auto Teleport", "AutoTeleport", ToggleAutoTeleport}
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

    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, (i-1)*45)
        TabButton.BackgroundColor3 = Colors.Secondary
        TabButton.Text = tab.Name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        TabButton.Parent = TabList
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0.1, 0)
        TabCorner.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = tab.Key
            UpdateTabColors(tab.Name)
            UpdateTabContent(tab.Functions)
        end)
        
        table.insert(TabButtons, TabButton)
    end
    TabList.CanvasSize = UDim2.new(0, 0, 0, #Tabs * 45)

    -- Контент
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -110, 1, -110)
    ContentFrame.Position = UDim2.new(0, 105, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    -- Игроки
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, -110, 0, 50)
    PlayerFrame.Position = UDim2.new(0, 105, 1, -60)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = MainFrame

    local PlayerFrameCorner = Instance.new("UICorner")
    PlayerFrameCorner.CornerRadius = UDim.new(0.04, 0)
    PlayerFrameCorner.Parent = PlayerFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(0.3, 0, 1, 0)
    PlayerLabel.Position = UDim2.new(0.05, 0, 0, 0)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 " .. (BlazixHub.SelectedPlayer or "None")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame

    local SelectButton = Instance.new("TextButton")
    SelectButton.Size = UDim2.new(0.15, 0, 0.6, 0)
    SelectButton.Position = UDim2.new(0.35, 0, 0.2, 0)
    SelectButton.BackgroundColor3 = Colors.Accent
    SelectButton.Text = "SELECT"
    SelectButton.TextColor3 = Colors.Text
    SelectButton.Font = Enum.Font.GothamBold
    SelectButton.TextSize = 11
    SelectButton.Parent = PlayerFrame

    local SelectCorner = Instance.new("UICorner")
    SelectCorner.CornerRadius = UDim.new(0.1, 0)
    SelectCorner.Parent = SelectButton

    local actionButtons = {
        {"TP", Colors.Accent, function() if BlazixHub.SelectedPlayer then TeleportToPlayer(BlazixHub.SelectedPlayer) end end},
        {"BRING", Colors.Warning, function() if BlazixHub.SelectedPlayer then BringPlayer(BlazixHub.SelectedPlayer) end end},
        {"KILL", Colors.Danger, function() if BlazixHub.SelectedPlayer then KillPlayer(BlazixHub.SelectedPlayer) end end}
    }

    for i, action in ipairs(actionButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.15, 0, 0.6, 0)
        btn.Position = UDim2.new(0.5 + (i-1)*0.16, 0, 0.2, 0)
        btn.BackgroundColor3 = action[2]
        btn.Text = action[1]
        btn.TextColor3 = Colors.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = PlayerFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.1, 0)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(action[3])
    end

    local KillAllBtn = Instance.new("TextButton")
    KillAllBtn.Size = UDim2.new(0.15, 0, 0.6, 0)
    KillAllBtn.Position = UDim2.new(0.98, -0.15, 0.2, 0)
    KillAllBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    KillAllBtn.Text = "KILL ALL"
    KillAllBtn.TextColor3 = Colors.Text
    KillAllBtn.Font = Enum.Font.GothamBold
    KillAllBtn.TextSize = 11
    KillAllBtn.Parent = PlayerFrame
    
    local killAllCorner = Instance.new("UICorner")
    killAllCorner.CornerRadius = UDim.new(0.1, 0)
    killAllCorner.Parent = KillAllBtn
    
    KillAllBtn.MouseButton1Click:Connect(KillAllPlayers)

    -- Тогглы
    local function CreateToggle(name, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Parent = ContentFrame

        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ToggleFrameCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextSize = 12
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 10
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

    function UpdateTabContent(functions)
        local children = ContentFrame:GetChildren()
        for i = #children, 1, -1 do
            local child = children[i]
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local yOffset = 5
        if functions then
            for i, func in ipairs(functions) do
                local toggle = CreateToggle(func[1], func[2], func[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
        end
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- Выбор игрока
    SelectButton.MouseButton1Click:Connect(function()
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0, 250, 0, 200)
        PlayerList.Position = UDim2.new(0.5, -125, 0.5, -100)
        PlayerList.BackgroundColor3 = Colors.Background
        PlayerList.Parent = MainFrame

        local PlayerListCorner = Instance.new("UICorner")
        PlayerListCorner.CornerRadius = UDim.new(0.08, 0)
        PlayerListCorner.Parent = PlayerList

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -10, 1, -40)
        Scroll.Position = UDim2.new(0, 5, 0, 35)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.Parent = PlayerList

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 5)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.GothamBlack
        CloseBtn.TextSize = 14
        CloseBtn.Parent = PlayerList

        local CloseBtnCorner = Instance.new("UICorner")
        CloseBtnCorner.CornerRadius = UDim.new(0.2, 0)
        CloseBtnCorner.Parent = CloseBtn

        local yOffset = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerBtn = Instance.new("TextButton")
                PlayerBtn.Size = UDim2.new(1, -10, 0, 40)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Secondary
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.GothamBold
                PlayerBtn.TextSize = 12
                PlayerBtn.Parent = Scroll

                local PlayerBtnCorner = Instance.new("UICorner")
                PlayerBtnCorner.CornerRadius = UDim.new(0.1, 0)
                PlayerBtnCorner.Parent = PlayerBtn

                yOffset = yOffset + 45

                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerLabel.Text = "🎯 " .. player.Name
                    PlayerList:Destroy()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerList:Destroy()
        end)
    end)

    -- Закрытие
    CloseButton.MouseButton1Click:Connect(CloseScript)

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
            update(input)
        end
    end)

    -- Инициализация
    UpdateTabColors(Tabs[1].Name)
    UpdateTabContent(Tabs[1].Functions)

    return ScreenGui
end

-- ЗАПУСК С ЗАГРУЗКОЙ
wait(0.5) -- Небольшая задержка перед запуском
ShowLoadingScreen()
wait(2) -- Ждем завершения загрузки

local success, err = pcall(function()
    local UI = CreateUltimateUI()
    print("🔥 BLAZIX HUB V6 ЗАГРУЖЕН!")
    print("✅ Все функции рабочие")
    print("✅ Вкладки слева")
    print("✅ Автоматическое меню")
end)

if not success then
    warn("❌ Ошибка: " .. tostring(err))
end
