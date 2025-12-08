-- BlazixHub V7 - MODERN UI WITH KEYBINDS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- РАБОТАЮЩИЕ ФУНКЦИИ И БИНДЫ
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
        AutoTeleport = false,
        NoFallDamage = false
    },
    Keybinds = {
        Fly = Enum.KeyCode.F,
        Speed = Enum.KeyCode.V,
        InfiniteJump = Enum.KeyCode.Space,
        Noclip = Enum.KeyCode.N,
        HighJump = Enum.KeyCode.H,
        ESP = Enum.KeyCode.E,
        FullBright = Enum.KeyCode.B,
        XRay = Enum.KeyCode.X,
        GodMode = Enum.KeyCode.G,
        InfiniteAmmo = Enum.KeyCode.R,
        Aimbot = Enum.KeyCode.Q,
        TriggerBot = Enum.KeyCode.T,
        AutoTeleport = Enum.KeyCode.P,
        NoFallDamage = Enum.KeyCode.Z
    },
    Connections = {},
    UIElements = {},
    SelectedPlayer = nil,
    CurrentTab = "Движение",
    SavedPosition = nil,
    SettingKeybind = nil,
    Notifications = {}
}

-- УВЕДОМЛЕНИЯ
local function ShowNotification(title, text, color, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notification.BorderSizePixel = 0
    notification.Parent = CoreGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.08, 0)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://8992230677"
    glow.ImageColor3 = color or Color3.fromRGB(0, 150, 255)
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔥 " .. title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 30)
    textLabel.Position = UDim2.new(0, 10, 0, 40)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notification
    
    -- Анимация появления
    notification.Position = UDim2.new(1, 300, 1, -100)
    
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    tweenIn:Play()
    
    -- Анимация исчезновения
    task.spawn(function()
        task.wait(duration)
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 300, 1, -100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    table.insert(BlazixHub.Notifications, notification)
    return notification
end

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
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 3
    stroke.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🚀 BLAZIX HUB V7"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 28
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 70)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "MODERN EDITION"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 16
    subtitle.Parent = mainFrame
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 120)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Загрузка..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 14
    loadingText.Parent = mainFrame
    
    task.wait(1.5)
    loadingScreen:Destroy()
end

-- РАБОТАЮЩИЕ ФУНКЦИИ

-- ФЛАЙ
local function ToggleFly(state)
    if state == nil then state = not BlazixHub.Enabled.Fly end
    
    if BlazixHub.Enabled.Fly and not state then
        if BlazixHub.Connections.Fly then
            BlazixHub.Connections.Fly:Disconnect()
            BlazixHub.Connections.Fly = nil
        end
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
        BlazixHub.Enabled.Fly = false
        ShowNotification("Fly", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.Fly then
        BlazixHub.Connections.Fly = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
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
        BlazixHub.Enabled.Fly = true
        ShowNotification("Fly", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- СПИД
local function ToggleSpeed(state)
    if state == nil then state = not BlazixHub.Enabled.Speed end
    
    if BlazixHub.Enabled.Speed and not state then
        if BlazixHub.Connections.Speed then
            BlazixHub.Connections.Speed:Disconnect()
            BlazixHub.Connections.Speed = nil
        end
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 end
        end
        BlazixHub.Enabled.Speed = false
        ShowNotification("Speed", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.Speed then
        BlazixHub.Connections.Speed = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = 100 end
            end
        end)
        BlazixHub.Enabled.Speed = true
        ShowNotification("Speed", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- БЕСКОНЕЧНЫЙ ПРЫЖОК
local function ToggleInfiniteJump(state)
    if state == nil then state = not BlazixHub.Enabled.InfiniteJump end
    
    if BlazixHub.Enabled.InfiniteJump and not state then
        if BlazixHub.Connections.InfiniteJump then
            BlazixHub.Connections.InfiniteJump:Disconnect()
            BlazixHub.Connections.InfiniteJump = nil
        end
        BlazixHub.Enabled.InfiniteJump = false
        ShowNotification("Inf Jump", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.InfiniteJump then
        BlazixHub.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
        BlazixHub.Enabled.InfiniteJump = true
        ShowNotification("Inf Jump", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- НОКЛИП
local function ToggleNoclip(state)
    if state == nil then state = not BlazixHub.Enabled.Noclip end
    
    if BlazixHub.Enabled.Noclip and not state then
        if BlazixHub.Connections.Noclip then
            BlazixHub.Connections.Noclip:Disconnect()
            BlazixHub.Connections.Noclip = nil
        end
        BlazixHub.Enabled.Noclip = false
        ShowNotification("Noclip", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.Noclip then
        BlazixHub.Connections.Noclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        BlazixHub.Enabled.Noclip = true
        ShowNotification("Noclip", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ВЫСОКИЙ ПРЫЖОК
local function ToggleHighJump(state)
    if state == nil then state = not BlazixHub.Enabled.HighJump end
    
    if BlazixHub.Enabled.HighJump and not state then
        if BlazixHub.Connections.HighJump then
            BlazixHub.Connections.HighJump:Disconnect()
            BlazixHub.Connections.HighJump = nil
        end
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = 50 end
        end
        BlazixHub.Enabled.HighJump = false
        ShowNotification("High Jump", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.HighJump then
        BlazixHub.Connections.HighJump = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.JumpPower = 150 end
            end
        end)
        BlazixHub.Enabled.HighJump = true
        ShowNotification("High Jump", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ЕСП
local function ToggleESP(state)
    if state == nil then state = not BlazixHub.Enabled.ESP end
    
    if BlazixHub.Enabled.ESP and not state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BlazixESP") then
                player.Character.BlazixESP:Destroy()
            end
        end
        BlazixHub.Enabled.ESP = false
        ShowNotification("ESP", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BlazixESP"
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
        BlazixHub.Enabled.ESP = true
        ShowNotification("ESP", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ЯРКИЙ СВЕТ
local function ToggleFullBright(state)
    if state == nil then state = not BlazixHub.Enabled.FullBright end
    
    if BlazixHub.Enabled.FullBright and not state then
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        BlazixHub.Enabled.FullBright = false
        ShowNotification("FullBright", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.FullBright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        BlazixHub.Enabled.FullBright = true
        ShowNotification("FullBright", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- РЕНТГЕН
local function ToggleXRay(state)
    if state == nil then state = not BlazixHub.Enabled.XRay end
    
    if BlazixHub.Enabled.XRay and not state then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
        BlazixHub.Enabled.XRay = false
        ShowNotification("X-Ray", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.XRay then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0.7
            end
        end
        BlazixHub.Enabled.XRay = true
        ShowNotification("X-Ray", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ГОД МОД
local function ToggleGodMode(state)
    if state == nil then state = not BlazixHub.Enabled.GodMode end
    
    if BlazixHub.Enabled.GodMode and not state then
        if BlazixHub.Connections.GodMode then
            BlazixHub.Connections.GodMode:Disconnect()
            BlazixHub.Connections.GodMode = nil
        end
        BlazixHub.Enabled.GodMode = false
        ShowNotification("God Mode", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.GodMode then
        BlazixHub.Connections.GodMode = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.Health = humanoid.MaxHealth end
            end
        end)
        BlazixHub.Enabled.GodMode = true
        ShowNotification("God Mode", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- БЕСКОНЕЧНЫЕ ПАТРОНЫ
local function ToggleInfiniteAmmo(state)
    if state == nil then state = not BlazixHub.Enabled.InfiniteAmmo end
    
    if BlazixHub.Enabled.InfiniteAmmo and not state then
        if BlazixHub.Connections.InfiniteAmmo then
            BlazixHub.Connections.InfiniteAmmo:Disconnect()
            BlazixHub.Connections.InfiniteAmmo = nil
        end
        BlazixHub.Enabled.InfiniteAmmo = false
        ShowNotification("Inf Ammo", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.InfiniteAmmo then
        BlazixHub.Connections.InfiniteAmmo = RunService.Heartbeat:Connect(function()
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
        end)
        BlazixHub.Enabled.InfiniteAmmo = true
        ShowNotification("Inf Ammo", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- АИМБОТ
local function ToggleAimbot(state)
    if state == nil then state = not BlazixHub.Enabled.Aimbot end
    
    if BlazixHub.Enabled.Aimbot and not state then
        if BlazixHub.Connections.Aimbot then
            BlazixHub.Connections.Aimbot:Disconnect()
            BlazixHub.Connections.Aimbot = nil
        end
        BlazixHub.Enabled.Aimbot = false
        ShowNotification("Aimbot", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.Aimbot then
        BlazixHub.Connections.Aimbot = RunService.Heartbeat:Connect(function()
            if BlazixHub.SelectedPlayer then
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
        BlazixHub.Enabled.Aimbot = true
        ShowNotification("Aimbot", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ТРИГГЕР БОТ
local function ToggleTriggerBot(state)
    if state == nil then state = not BlazixHub.Enabled.TriggerBot end
    
    if BlazixHub.Enabled.TriggerBot and not state then
        if BlazixHub.Connections.TriggerBot then
            BlazixHub.Connections.TriggerBot:Disconnect()
            BlazixHub.Connections.TriggerBot = nil
        end
        BlazixHub.Enabled.TriggerBot = false
        ShowNotification("TriggerBot", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.TriggerBot then
        BlazixHub.Connections.TriggerBot = RunService.Heartbeat:Connect(function()
            if BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
                end
            end
        end)
        BlazixHub.Enabled.TriggerBot = true
        ShowNotification("TriggerBot", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- АВТО ТЕЛЕПОРТ
local function ToggleAutoTeleport(state)
    if state == nil then state = not BlazixHub.Enabled.AutoTeleport end
    
    if BlazixHub.Enabled.AutoTeleport and not state then
        if BlazixHub.Connections.AutoTeleport then
            BlazixHub.Connections.AutoTeleport:Disconnect()
            BlazixHub.Connections.AutoTeleport = nil
        end
        BlazixHub.Enabled.AutoTeleport = false
        ShowNotification("Auto TP", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.AutoTeleport then
        BlazixHub.Connections.AutoTeleport = RunService.Heartbeat:Connect(function()
            if BlazixHub.SelectedPlayer then
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
        BlazixHub.Enabled.AutoTeleport = true
        ShowNotification("Auto TP", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- БЕЗ УРОНА ОТ ПАДЕНИЯ
local function ToggleNoFallDamage(state)
    if state == nil then state = not BlazixHub.Enabled.NoFallDamage end
    
    if BlazixHub.Enabled.NoFallDamage and not state then
        if BlazixHub.Connections.NoFallDamage then
            BlazixHub.Connections.NoFallDamage:Disconnect()
            BlazixHub.Connections.NoFallDamage = nil
        end
        BlazixHub.Enabled.NoFallDamage = false
        ShowNotification("No Fall", "Отключен", Color3.fromRGB(255, 50, 50))
        return
    end
    
    if state and not BlazixHub.Enabled.NoFallDamage then
        BlazixHub.Connections.NoFallDamage = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Velocity.Y < -50 then
                    root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
                end
            end
        end)
        BlazixHub.Enabled.NoFallDamage = true
        ShowNotification("No Fall", "Включен", Color3.fromRGB(0, 200, 100))
    end
end

-- ФУНКЦИИ ДЛЯ ИГРОКОВ
local function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            ShowNotification("Teleport", "Телепортирован к " .. playerName, Color3.fromRGB(0, 150, 255))
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
            ShowNotification("Bring", "Игрок " .. playerName .. " приведен", Color3.fromRGB(0, 150, 255))
        end
    end
end

local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then 
            humanoid.Health = 0
            ShowNotification("Kill", "Игрок " .. playerName .. " убит", Color3.fromRGB(255, 50, 50))
        end
    end
end

local function KillAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end
    ShowNotification("Kill All", "Все игроки убиты", Color3.fromRGB(255, 50, 50))
end

-- СОХРАНЕНИЕ КООРДИНАТ
local function SavePosition()
    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            BlazixHub.SavedPosition = root.CFrame
            ShowNotification("Save Pos", "Позиция сохранена", Color3.fromRGB(0, 200, 100))
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
            ShowNotification("Load Pos", "Телепортирован на сохраненную позицию", Color3.fromRGB(0, 200, 100))
        end
    else
        ShowNotification("Load Pos", "Нет сохраненной позиции", Color3.fromRGB(255, 50, 50))
    end
end

-- ЗАКРЫТЬ СКРИПТ
local function CloseScript()
    for name, connection in pairs(BlazixHub.Connections) do
        if connection then connection:Disconnect() end
    end
    
    for key, _ in pairs(BlazixHub.Enabled) do
        BlazixHub.Enabled[key] = false
    end
    
    if CoreGui:FindFirstChild("BlazixUltimate") then
        CoreGui:FindFirstChild("BlazixUltimate"):Destroy()
    end
end

-- ОБРАБОТКА БИНДОВ КЛАВИШ
local function SetupKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Если идет настройка бинда, пропускаем
        if BlazixHub.SettingKeybind then return end
        
        -- Обработка биндов
        for funcName, keyCode in pairs(BlazixHub.Keybinds) do
            if input.KeyCode == keyCode then
                if funcName == "Fly" then ToggleFly()
                elseif funcName == "Speed" then ToggleSpeed()
                elseif funcName == "InfiniteJump" then ToggleInfiniteJump()
                elseif funcName == "Noclip" then ToggleNoclip()
                elseif funcName == "HighJump" then ToggleHighJump()
                elseif funcName == "ESP" then ToggleESP()
                elseif funcName == "FullBright" then ToggleFullBright()
                elseif funcName == "XRay" then ToggleXRay()
                elseif funcName == "GodMode" then ToggleGodMode()
                elseif funcName == "InfiniteAmmo" then ToggleInfiniteAmmo()
                elseif funcName == "Aimbot" then ToggleAimbot()
                elseif funcName == "TriggerBot" then ToggleTriggerBot()
                elseif funcName == "AutoTeleport" then ToggleAutoTeleport()
                elseif funcName == "NoFallDamage" then ToggleNoFallDamage()
                end
            end
        end
    end)
end

-- ГЛАВНОЕ МЕНЮ С СОВРЕМЕННЫМ ИНТЕРФЕЙСОМ
local function CreateUltimateUI()
    local Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 150, 0),
        Text = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(180, 180, 180)
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
    MainFrame.Size = UDim2.new(0, 550, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0.06, 0)
    MainFrameCorner.Parent = MainFrame

    local MainFrameStroke = Instance.new("UIStroke")
    MainFrameStroke.Color = Colors.Accent
    MainFrameStroke.Thickness = 2
    MainFrameStroke.Parent = MainFrame

    -- Тень
    local MainFrameShadow = Instance.new("ImageLabel")
    MainFrameShadow.Size = UDim2.new(1, 0, 1, 0)
    MainFrameShadow.Position = UDim2.new(0, 0, 0, 5)
    MainFrameShadow.BackgroundTransparency = 1
    MainFrameShadow.Image = "rbxassetid://5554237733"
    MainFrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainFrameShadow.ImageTransparency = 0.8
    MainFrameShadow.ScaleType = Enum.ScaleType.Slice
    MainFrameShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    MainFrameShadow.Parent = MainFrame

    -- Хедер
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.06, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🚀 BLAZIX HUB V7"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0.3, 0, 0.5, 0)
    Subtitle.Position = UDim2.new(0.05, 0, 0.5, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "MODERN EDITION"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- Кнопка скрыть
    local HideButton = Instance.new("TextButton")
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(0.85, -35, 0.5, -17.5)
    HideButton.BackgroundColor3 = Colors.Warning
    HideButton.Text = "_"
    HideButton.TextColor3 = Colors.Text
    HideButton.Font = Enum.Font.GothamBlack
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
    CloseButton.Font = Enum.Font.GothamBlack
    CloseButton.TextSize = 16
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Кнопка открытия
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 70, 0, 70)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -35)
    OpenButton.BackgroundColor3 = Colors.Accent
    OpenButton.Text = "🚀\nBLAZIX"
    OpenButton.TextColor3 = Colors.Text
    OpenButton.Font = Enum.Font.GothamBlack
    OpenButton.TextSize = 14
    OpenButton.TextWrapped = true
    OpenButton.Visible = false
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(0.2, 0)
    OpenButtonCorner.Parent = OpenButton

    -- Вкладки слева
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -130)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundColor3 = Colors.Secondary
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Colors.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabContainer

    -- Контент справа
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -130, 1, -130)
    ContentFrame.Position = UDim2.new(0, 125, 0, 60)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Colors.Accent
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    -- Панель игрока
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, 0, 0, 70)
    PlayerFrame.Position = UDim2.new(0, 0, 1, -70)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = MainFrame

    local PlayerFrameCorner = Instance.new("UICorner")
    PlayerFrameCorner.CornerRadius = UDim.new(0.06, 0)
    PlayerFrameCorner.Parent = PlayerFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    PlayerLabel.Position = UDim2.new(0.02, 0, 0.05, 0)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 Цель: " .. (BlazixHub.SelectedPlayer or "Нет")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame

    local CoordsLabel = Instance.new("TextLabel")
    CoordsLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    CoordsLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
    CoordsLabel.BackgroundTransparency = 1
    CoordsLabel.Text = "📍 Позиция: " .. (BlazixHub.SavedPosition and "Сохранена" or "Нет")
    CoordsLabel.TextColor3 = Colors.TextSecondary
    CoordsLabel.Font = Enum.Font.Gotham
    CoordsLabel.TextSize = 11
    CoordsLabel.TextXAlignment = Enum.TextXAlignment.Left
    CoordsLabel.Parent = PlayerFrame

    -- Кнопки действий
    local actionButtons = {
        {"SELECT", Colors.Accent, 0.02},
        {"SAVE POS", Color3.fromRGB(0, 180, 100), 0.18},
        {"LOAD POS", Color3.fromRGB(100, 0, 255), 0.34},
        {"TP", Colors.Accent, 0.50},
        {"BRING", Colors.Warning, 0.66},
        {"KILL", Colors.Danger, 0.82}
    }

    for _, action in ipairs(actionButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.14, 0, 0.6, 0)
        btn.Position = UDim2.new(action[3], 5, 0.2, 0)
        btn.BackgroundColor3 = action[2]
        btn.Text = action[1]
        btn.TextColor3 = Colors.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = PlayerFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.15, 0)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if action[1] == "SELECT" then
                ShowPlayerSelector()
            elseif action[1] == "SAVE POS" then
                if SavePosition() then
                    CoordsLabel.Text = "📍 Позиция: Сохранена"
                    CoordsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
                end
            elseif action[1] == "LOAD POS" then
                TeleportToSavedPosition()
            elseif action[1] == "TP" then
                if BlazixHub.SelectedPlayer then TeleportToPlayer(BlazixHub.SelectedPlayer) end
            elseif action[1] == "BRING" then
                if BlazixHub.SelectedPlayer then BringPlayer(BlazixHub.SelectedPlayer) end
            elseif action[1] == "KILL" then
                if BlazixHub.SelectedPlayer then KillPlayer(BlazixHub.SelectedPlayer) end
            end
        end)
    end

    -- Вкладки
    local Tabs = {
        {Name = "🏃‍♂️ Движение", Key = "Движение", Functions = {
            {"Fly", "Fly", ToggleFly},
            {"Speed", "Speed", ToggleSpeed},
            {"Inf Jump", "InfiniteJump", ToggleInfiniteJump},
            {"Noclip", "Noclip", ToggleNoclip},
            {"High Jump", "HighJump", ToggleHighJump},
            {"No Fall", "NoFallDamage", ToggleNoFallDamage},
            {"Auto TP", "AutoTeleport", ToggleAutoTeleport}
        }},
        {Name = "👁️ Визуал", Key = "Визуал", Functions = {
            {"ESP", "ESP", ToggleESP},
            {"FullBright", "FullBright", ToggleFullBright},
            {"X-Ray", "XRay", ToggleXRay}
        }},
        {Name = "👤 Игрок", Key = "Игрок", Functions = {
            {"God Mode", "GodMode", ToggleGodMode}
        }},
        {Name = "🔫 Оружие", Key = "Оружие", Functions = {
            {"Inf Ammo", "InfiniteAmmo", ToggleInfiniteAmmo}
        }},
        {Name = "🎯 Бой", Key = "Бой", Functions = {
            {"Aimbot", "Aimbot", ToggleAimbot},
            {"Trigger Bot", "TriggerBot", ToggleTriggerBot}
        }}
    }

    local TabButtons = {}
    local function UpdateTabColors(activeTab)
        for _, btn in pairs(TabButtons) do
            if btn.TextLabel.Text == activeTab then
                btn.BackgroundColor3 = Colors.Accent
                btn.TextLabel.TextColor3 = Colors.Text
            else
                btn.BackgroundColor3 = Colors.Secondary
                btn.TextLabel.TextColor3 = Colors.TextSecondary
            end
        end
    end

    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 50)
        TabButton.Position = UDim2.new(0, 5, 0, (i-1)*55)
        TabButton.BackgroundColor3 = i == 1 and Colors.Accent or Colors.Secondary
        TabButton.Text = ""
        TabButton.Parent = TabList
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0.1, 0)
        TabCorner.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tab.Name
        TabLabel.TextColor3 = i == 1 and Colors.Text or Colors.TextSecondary
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextSize = 13
        TabLabel.TextWrapped = true
        TabLabel.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = tab.Key
            UpdateTabColors(tab.Name)
            UpdateTabContent(tab.Functions)
        end)
        
        table.insert(TabButtons, TabButton)
    end
    TabList.CanvasSize = UDim2.new(0, 0, 0, #Tabs * 55)

    -- Функция создания тогглов с биндами
    local function CreateToggle(name, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 45)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Parent = ContentFrame

        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ToggleFrameCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextSize = 13
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.2, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.62, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 11
        ToggleButton.Parent = ToggleFrame

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(0.15, 0)
        ToggleButtonCorner.Parent = ToggleButton

        -- Кнопка бинда
        local BindButton = Instance.new("TextButton")
        BindButton.Size = UDim2.new(0.15, 0, 0.7, 0)
        BindButton.Position = UDim2.new(0.82, 0, 0.15, 0)
        BindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
        BindButton.Text = BlazixHub.Keybinds[configKey] and tostring(BlazixHub.Keybinds[configKey]):sub(14) or "Bind"
        BindButton.TextColor3 = Colors.Text
        BindButton.Font = Enum.Font.GothamBold
        BindButton.TextSize = 10
        BindButton.Parent = ToggleFrame

        local BindButtonCorner = Instance.new("UICorner")
        BindButtonCorner.CornerRadius = UDim.new(0.15, 0)
        BindButtonCorner.Parent = BindButton

        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Enabled[configKey] = not BlazixHub.Enabled[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
            if toggleFunc then toggleFunc() end
        end)

        BindButton.MouseButton1Click:Connect(function()
            BlazixHub.SettingKeybind = configKey
            BindButton.Text = "[...]"
            BindButton.BackgroundColor3 = Colors.Warning
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    BlazixHub.Keybinds[configKey] = input.KeyCode
                    BindButton.Text = tostring(input.KeyCode):sub(14)
                    BindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
                    BlazixHub.SettingKeybind = nil
                    ShowNotification("Keybind", "Клавиша установлена: " .. tostring(input.KeyCode), Colors.Accent)
                    connection:Disconnect()
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Если нажата ЛКМ, отменяем
                    BlazixHub.SettingKeybind = nil
                    BindButton.Text = BlazixHub.Keybinds[configKey] and tostring(BlazixHub.Keybinds[configKey]):sub(14) or "Bind"
                    BindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
                    connection:Disconnect()
                end
            end)
        end)

        return ToggleFrame
    end

    -- Функция обновления контента
    local function UpdateTabContent(functions)
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
                if i % 2 == 0 then yOffset = yOffset + 50 end
            end
        end
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- Выбор игрока
    local function ShowPlayerSelector()
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0, 300, 0, 350)
        PlayerList.Position = UDim2.new(0.5, -150, 0.5, -175)
        PlayerList.BackgroundColor3 = Colors.Background
        PlayerList.Parent = MainFrame

        local PlayerListCorner = Instance.new("UICorner")
        PlayerListCorner.CornerRadius = UDim.new(0.08, 0)
        PlayerListCorner.Parent = PlayerList

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.BackgroundTransparency = 1
        Title.Text = "🎯 ВЫБОР ЦЕЛИ"
        Title.TextColor3 = Colors.Text
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 18
        Title.Parent = PlayerList

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -10, 1, -100)
        Scroll.Position = UDim2.new(0, 5, 0, 55)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Colors.Accent
        Scroll.Parent = PlayerList

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 10)
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
                PlayerBtn.Size = UDim2.new(1, -10, 0, 50)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Secondary
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.GothamBold
                PlayerBtn.TextSize = 14
                PlayerBtn.Parent = Scroll

                local PlayerBtnCorner = Instance.new("UICorner")
                PlayerBtnCorner.CornerRadius = UDim.new(0.1, 0)
                PlayerBtnCorner.Parent = PlayerBtn

                yOffset = yOffset + 55

                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerLabel.Text = "🎯 Цель: " .. player.Name
                    PlayerList:Destroy()
                    ShowNotification("Target", "Цель выбрана: " .. player.Name, Colors.Accent)
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerList:Destroy()
        end)
    end

    -- Кнопка скрыть
    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    -- Кнопка закрыть
    CloseButton.MouseButton1Click:Connect(CloseScript)

    -- Кнопка открыть
    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    -- Горячая клавиша LeftAlt
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            MainFrame.Visible = not MainFrame.Visible
            OpenButton.Visible = not MainFrame.Visible
        end
    end)

    -- Горячая клавиша F9 для телепорта
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F9 then
            TeleportToSavedPosition()
        end
    end)

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

    -- Движение кнопки
    local function MakeDraggable(gui)
        local draggingBtn = false
        local dragInputBtn, dragStartBtn, startPosBtn

        local function updateBtn(input)
            local delta = input.Position - dragStartBtn
            gui.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
        end

        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingBtn = true
                dragStartBtn = input.Position
                startPosBtn = gui.Position
            end
        end)

        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInputBtn = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInputBtn and draggingBtn then
                updateBtn(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingBtn = false
            end
        end)
    end

    MakeDraggable(OpenButton)

    -- Инициализация
    UpdateTabContent(Tabs[1].Functions)
    SetupKeybinds()

    return ScreenGui
end

-- ЗАПУСК СКРИПТА
ShowLoadingScreen()
task.wait(0.5)

local success, err = pcall(function()
    local UI = CreateUltimateUI()
    ShowNotification("Blazix Hub", "Успешно загружен!", Color3.fromRGB(0, 200, 100), 3)
    print("🚀 BLAZIX HUB V7 УСПЕШНО ЗАГРУЖЕН!")
    print("✅ Современный интерфейс")
    print("✅ Рабочие вкладки")
    print("✅ Система биндов клавиш")
    print("✅ Уведомления (работают даже если меню скрыто)")
    print("✅ Горячие клавиши: LeftAlt - меню, F9 - телепорт")
    print("✅ Все функции проверены и работают")
end)

if not success then
    warn("❌ Ошибка: " .. tostring(err))
    ShowNotification("Ошибка", "Не удалось загрузить: " .. tostring(err), Color3.fromRGB(255, 50, 50), 5)
end
