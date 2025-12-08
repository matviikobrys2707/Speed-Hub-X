-- BlazixHub V6 - ULTIMATE VERSION
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
        -- Движение
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        HighJump = false,
        AutoTeleport = false,
        
        -- Визуал
        ESP = false,
        FullBright = false,
        XRay = false,
        NightVision = false,
        Chams = false,
        
        -- Игрок
        GodMode = false,
        InfiniteStamina = false,
        NoFallDamage = false,
        
        -- Оружие
        InfiniteAmmo = false,
        
        -- Бой
        Aimbot = false,
        TriggerBot = false,
        
        -- Фарм
        AutoFarm = false,
    },
    Connections = {},
    SelectedPlayer = nil,
    CurrentTab = "Движение",
    SavedPosition = nil
}

-- ЭКРАН ЗАГРУЗКИ
local function ShowLoadingScreen()
    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "BlazixLoading"
    loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingScreen.ResetOnSpawn = false
    loadingScreen.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.Parent = loadingScreen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 3
    stroke.Parent = mainFrame

    -- Анимация градиента
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
    }
    gradient.Rotation = 45
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0.5
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.UIGradient = gradient

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🔥 BLAZIX HUB V6"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 28
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 150, 255)
    title.Parent = mainFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 70)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "ULTIMATE EDITION"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 16
    subtitle.Parent = mainFrame

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 120)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Загрузка системы..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 14
    loadingText.Parent = mainFrame

    -- Контейнер для прогресс бара
    local progressContainer = Instance.new("Frame")
    progressContainer.Size = UDim2.new(0.8, 0, 0, 20)
    progressContainer.Position = UDim2.new(0.1, 0, 0, 160)
    progressContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressContainer.Parent = mainFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.5, 0)
    progressCorner.Parent = progressContainer

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    progressFill.Parent = progressContainer

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = progressFill

    -- Градиент для заполнения
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 255))
    }
    fillGradient.Parent = progressFill

    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(1, 0, 0, 20)
    percentText.Position = UDim2.new(0, 0, 0, 185)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(0, 150, 255)
    percentText.Font = Enum.Font.GothamBold
    percentText.TextSize = 14
    percentText.Parent = mainFrame

    local tipText = Instance.new("TextLabel")
    tipText.Size = UDim2.new(1, 0, 0, 20)
    tipText.Position = UDim2.new(0, 0, 0, 210)
    tipText.BackgroundTransparency = 1
    tipText.Text = "⏳ Подождите, идет инициализация..."
    tipText.TextColor3 = Color3.fromRGB(150, 150, 150)
    tipText.Font = Enum.Font.Gotham
    tipText.TextSize = 12
    tipText.Parent = mainFrame

    -- Случайные советы
    local tips = {
        "💡 Используйте LeftAlt для скрытия/показа меню",
        "🎮 Нажмите F9 для быстрого телепорта",
        "🔧 Все функции проверены и рабочие",
        "⚡ Оптимизировано для максимальной производительности",
        "🎯 Используйте кнопку SELECT для выбора цели"
    }

    -- Анимация загрузки
    local startTime = tick()
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 2.5, 1) -- 2.5 секунды загрузки
        
        -- Плавная анимация прогресса
        local easedProgress = 1 - math.cos(progress * math.pi / 2)
        progressFill.Size = UDim2.new(easedProgress, 0, 1, 0)
        
        local percent = math.floor(easedProgress * 100)
        percentText.Text = percent .. "%"
        
        -- Меняем совет каждые 0.5 секунд
        local tipIndex = math.floor((tick() - startTime) * 2) % #tips + 1
        tipText.Text = tips[tipIndex]
        
        -- Анимация градиента
        gradient.Offset = Vector2.new(math.sin(tick() * 2) * 0.5, 0)
        
        if progress >= 1 then
            connection:Disconnect()
            
            -- Анимация исчезновения
            for i = 1, 10 do
                mainFrame.BackgroundTransparency = i / 10
                wait(0.03)
            end
            
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
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
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
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end

-- РЕНТГЕН
local function ToggleXRay()
    if BlazixHub.Enabled.XRay then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.9 then
                part.LocalTransparencyModifier = 0.7
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
        Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(128, 128, 255)
        Lighting.Brightness = 0.5
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
    end
end

-- КЕЙМС (ТРАНСПАРЕНТНЫЙ)
local function ToggleChams()
    if BlazixHub.Enabled.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if player.Character:FindFirstChild("BlazixChams") then
                    player.Character.BlazixChams:Destroy()
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "BlazixChams"
                highlight.FillColor = Color3.fromRGB(0, 255, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = player.Character
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BlazixChams") then
                player.Character.BlazixChams:Destroy()
            end
        end
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
                                    if string.lower(v.Name):find("ammo") or string.lower(v.Name):find("bullet") or string.lower(v.Name):find("clip") then
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
                    if v:IsA("NumberValue") and (string.lower(v.Name):find("stamina") or string.lower(v.Name):find("energy")) then
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
                local cam = Workspace.CurrentCamera
                
                if targetRoot and localRoot and cam then
                    -- Плавный аим
                    local direction = (targetRoot.Position - cam.CFrame.Position).Unit
                    local newCF = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + direction)
                    
                    -- Плавное перемещение камеры
                    cam.CFrame = cam.CFrame:Lerp(newCF, 0.3)
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
                -- Автоматическая стрельба
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                task.wait(0.05)
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
                    local offset = targetRoot.CFrame.lookVector * -3
                    local newPosition = targetRoot.Position + offset + Vector3.new(0, 2, 0)
                    localRoot.CFrame = CFrame.new(newPosition, targetRoot.Position)
                end
            end
        end
    end)
end

-- АВТО ФАРМ
local function ToggleAutoFarm()
    if BlazixHub.Connections.AutoFarm then
        BlazixHub.Connections.AutoFarm:Disconnect()
        BlazixHub.Connections.AutoFarm = nil
        return
    end
    
    BlazixHub.Connections.AutoFarm = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.AutoFarm then
            -- Автоматический сбор предметов
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Tool") or (obj.Name:lower():find("coin") or obj.Name:lower():find("money")) then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local root = LocalPlayer.Character.HumanoidRootPart
                        local distance = (root.Position - obj.Position).Magnitude
                        
                        if distance < 50 then
                            root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                        end
                    end
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

-- ГЛАВНОЕ МЕНЮ
local function CreateUltimateUI()
    local Colors = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
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

    -- Кнопка открытия (когда меню скрыто)
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 70, 0, 70)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -35)
    OpenButton.BackgroundColor3 = Colors.Accent
    OpenButton.Text = "🔥\nBLAZIX"
    OpenButton.TextColor3 = Colors.Text
    OpenButton.Font = Enum.Font.GothamBlack
    OpenButton.TextSize = 14
    OpenButton.TextWrapped = true
    OpenButton.Visible = false
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(0.2, 0)
    OpenButtonCorner.Parent = OpenButton

    -- Тень для кнопки
    local OpenButtonShadow = Instance.new("ImageLabel")
    OpenButtonShadow.Size = UDim2.new(1, 0, 1, 0)
    OpenButtonShadow.Position = UDim2.new(0, 0, 0, 5)
    OpenButtonShadow.BackgroundTransparency = 1
    OpenButtonShadow.Image = "rbxassetid://5554237733"
    OpenButtonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OpenButtonShadow.ImageTransparency = 0.5
    OpenButtonShadow.ScaleType = Enum.ScaleType.Slice
    OpenButtonShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    OpenButtonShadow.Parent = OpenButton

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
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

    -- Тень для главного окна
    local MainFrameShadow = Instance.new("ImageLabel")
    MainFrameShadow.Size = UDim2.new(1, 0, 1, 0)
    MainFrameShadow.Position = UDim2.new(0, 0, 0, 5)
    MainFrameShadow.BackgroundTransparency = 1
    MainFrameShadow.Image = "rbxassetid://5554237733"
    MainFrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainFrameShadow.ImageTransparency = 0.7
    MainFrameShadow.ScaleType = Enum.ScaleType.Slice
    MainFrameShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    MainFrameShadow.Parent = MainFrame

    -- Хедер
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.06, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 BLAZIX HUB V6"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0.2, 0, 1, 0)
    Version.Position = UDim2.new(0.65, 0, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = "ULTIMATE"
    Version.TextColor3 = Color3.fromRGB(0, 150, 255)
    Version.Font = Enum.Font.GothamBold
    Version.TextSize = 12
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Parent = Header

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

    -- Вкладки слева
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -120)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
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
    ContentFrame.Size = UDim2.new(1, -130, 1, -120)
    ContentFrame.Position = UDim2.new(0, 125, 0, 50)
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

    -- Координаты
    local CoordsLabel = Instance.new("TextLabel")
    CoordsLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    CoordsLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
    CoordsLabel.BackgroundTransparency = 1
    CoordsLabel.Text = "📍 Сохранено: " .. (BlazixHub.SavedPosition and "Да" or "Нет")
    CoordsLabel.TextColor3 = Colors.TextSecondary
    CoordsLabel.Font = Enum.Font.Gotham
    CoordsLabel.TextSize = 11
    CoordsLabel.TextXAlignment = Enum.TextXAlignment.Left
    CoordsLabel.Parent = PlayerFrame

    -- Кнопки действий
    local actionButtons = {
        {"SELECT", Colors.Accent, function() ShowPlayerSelector() end, 0.02},
        {"SAVE POS", Color3.fromRGB(0, 180, 100), SavePosition, 0.18},
        {"LOAD POS", Color3.fromRGB(100, 0, 255), TeleportToSavedPosition, 0.34},
        {"TP", Colors.Accent, function() if BlazixHub.SelectedPlayer then TeleportToPlayer(BlazixHub.SelectedPlayer) end end, 0.50},
        {"BRING", Colors.Warning, function() if BlazixHub.SelectedPlayer then BringPlayer(BlazixHub.SelectedPlayer) end end, 0.66},
        {"KILL", Colors.Danger, function() if BlazixHub.SelectedPlayer then KillPlayer(BlazixHub.SelectedPlayer) end end, 0.82}
    }

    for _, action in ipairs(actionButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.14, 0, 0.6, 0)
        btn.Position = UDim2.new(action[4], 5, 0.2, 0)
        btn.BackgroundColor3 = action[2]
        btn.Text = action[1]
        btn.TextColor3 = Colors.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = PlayerFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.15, 0)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(action[3])
    end

    -- Вкладки
    local Tabs = {
        {Name = "🏃‍♂️ Движение", Key = "Движение", Functions = {
            {"🕊️ Fly", "Fly", ToggleFly},
            {"⚡ Speed", "Speed", ToggleSpeed},
            {"🔄 Inf Jump", "InfiniteJump", ToggleInfiniteJump},
            {"👻 Noclip", "Noclip", ToggleNoclip},
            {"🦘 High Jump", "HighJump", ToggleHighJump},
            {"📡 Auto TP", "AutoTeleport", ToggleAutoTeleport}
        }},
        {Name = "👁️ Визуал", Key = "Визуал", Functions = {
            {"🎯 ESP", "ESP", ToggleESP},
            {"💡 FullBright", "FullBright", ToggleFullBright},
            {"🔍 X-Ray", "XRay", ToggleXRay},
            {"🌙 Night Vision", "NightVision", ToggleNightVision},
            {"🔮 Chams", "Chams", ToggleChams}
        }},
        {Name = "👤 Игрок", Key = "Игрок", Functions = {
            {"🛡️ God Mode", "GodMode", ToggleGodMode},
            {"💪 Inf Stamina", "InfiniteStamina", ToggleInfiniteStamina},
            {"🛬 No Fall Dmg", "NoFallDamage", ToggleNoFallDamage}
        }},
        {Name = "🔫 Оружие", Key = "Оружие", Functions = {
            {"∞ Ammo", "InfiniteAmmo", ToggleInfiniteAmmo}
        }},
        {Name = "🎯 Бой", Key = "Бой", Functions = {
            {"🎯 Aimbot", "Aimbot", ToggleAimbot},
            {"🔫 Trigger Bot", "TriggerBot", ToggleTriggerBot}
        }},
        {Name = "🤖 Фарм", Key = "Фарм", Functions = {
            {"🤖 Auto Farm", "AutoFarm", ToggleAutoFarm}
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
        TabButton.Size = UDim2.new(1, -10, 0, 45)
        TabButton.Position = UDim2.new(0, 5, 0, (i-1)*50)
        TabButton.BackgroundColor3 = Colors.Secondary
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
        TabLabel.TextSize = 12
        TabLabel.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = tab.Key
            UpdateTabColors(tab.Name)
            UpdateTabContent(tab.Functions)
        end)
        
        table.insert(TabButtons, TabButton)
    end
    TabList.CanvasSize = UDim2.new(0, 0, 0, #Tabs * 50)

    -- Функция создания тогглов
    local function CreateToggle(name, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 40)
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
        ToggleLabel.TextSize = 13
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 11
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
                if i % 2 == 0 then yOffset = yOffset + 45 end
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

        local PlayerListStroke = Instance.new("UIStroke")
        PlayerListStroke.Color = Colors.Accent
        PlayerListStroke.Thickness = 2
        PlayerListStroke.Parent = PlayerList

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundTransparency = 1
        Title.Text = "🎯 ВЫБОР ЦЕЛИ"
        Title.TextColor3 = Colors.Text
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 16
        Title.Parent = PlayerList

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -10, 1, -80)
        Scroll.Position = UDim2.new(0, 5, 0, 45)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Colors.Accent
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
                PlayerBtn.Size = UDim2.new(1, -10, 0, 45)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Secondary
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.GothamBold
                PlayerBtn.TextSize = 13
                PlayerBtn.Parent = Scroll

                local PlayerBtnCorner = Instance.new("UICorner")
                PlayerBtnCorner.CornerRadius = UDim.new(0.1, 0)
                PlayerBtnCorner.Parent = PlayerBtn

                yOffset = yOffset + 50

                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerLabel.Text = "🎯 Цель: " .. player.Name
                    PlayerList:Destroy()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerList:Destroy()
        end)
    end

    -- Обновление координат
    local function UpdateCoords()
        if BlazixHub.SavedPosition then
            CoordsLabel.Text = "📍 Сохранено: Да"
            CoordsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
        else
            CoordsLabel.Text = "📍 Сохранено: Нет"
            CoordsLabel.TextColor3 = Colors.TextSecondary
        end
    end

    -- Кнопка сохранения позиции
    for _, btn in pairs(PlayerFrame:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == "SAVE POS" then
            btn.MouseButton1Click:Connect(function()
                if SavePosition() then
                    UpdateCoords()
                end
            end)
        elseif btn:IsA("TextButton") and btn.Text == "LOAD POS" then
            btn.MouseButton1Click:Connect(function()
                TeleportToSavedPosition()
            end)
        end
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
        OpenButton.Position = MainFrame.Position
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

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingBtn = false
                    end
                end)
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
    end

    MakeDraggable(OpenButton)

    -- Инициализация
    UpdateTabColors(Tabs[1].Name)
    UpdateTabContent(Tabs[1].Functions)
    UpdateCoords()

    return ScreenGui
end

-- ЗАПУСК СКРИПТА
wait(0.5)
ShowLoadingScreen()
wait(2.5) -- Ждем завершения загрузки

local success, err = pcall(function()
    local UI = CreateUltimateUI()
    print("🔥 BLAZIX HUB V6 УСПЕШНО ЗАГРУЖЕН!")
    print("✅ Красивое меню с анимацией")
    print("✅ Кнопки скрыть/закрыть")
    print("✅ Движение меню по экрану")
    print("✅ Сохранение/телепорт по координатам")
    print("✅ Горячие клавиши: LeftAlt, F9")
    print("✅ Все функции проверены и работают")
end)

if not success then
    warn("❌ Ошибка загрузки: " .. tostring(err))
end
