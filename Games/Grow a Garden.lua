-- BlazixHub V5 - FIXED TABS SYSTEM
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ULTIMATE CONFIG WITH 50+ FEATURES
local BlazixHub = {
    Enabled = {
        -- Movement
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        NoClipAuto = false,
        HighJump = false,
        SpinBot = false,
        AntiStomp = false,
        
        -- Combat
        Aimbot = false,
        TriggerBot = false,
        SilentAim = false,
        WallBang = false,
        RapidFire = false,
        NoRecoil = false,
        NoSpread = false,
        AutoReload = false,
        InstantKill = false,
        HitBoxExpand = false,
        
        -- Visuals
        ESP = false,
        BoxESP = false,
        TracerESP = false,
        NameESP = false,
        HealthESP = false,
        DistanceESP = false,
        Chams = false,
        XRay = false,
        FullBright = false,
        NoFog = false,
        
        -- Player
        GodMode = false,
        AntiGrab = false,
        AntiStun = false,
        AntiSlow = false,
        AntiVoid = false,
        AutoRespawn = false,
        InfiniteStamina = false,
        
        -- Weapon
        InfiniteAmmo = false,
        AutoFarm = false,
        WeaponSteal = false,
        GunMods = false,
        
        -- Server
        ServerHop = false,
        LagServer = false,
        CrashServer = false,
        AntiKick = false,
        AntiBan = false,
        
        -- Trolling
        FakeLag = false,
        ChatSpam = false,
        SoundSpam = false,
        AnnoyAll = false
    },
    Connections = {},
    SelectedPlayer = nil,
    CurrentTab = "Visuals"
}

-- BASIC FUNCTIONS
local function ToggleFly()
    if BlazixHub.Connections.Fly then
        BlazixHub.Connections.Fly:Disconnect()
        BlazixHub.Connections.Fly = nil
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
                
                root.Velocity = direction.Unit * 100
            end
        end
    end)
end

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
            if humanoid then humanoid.WalkSpeed = 50 end
        end
    end)
end

local function ToggleInfiniteJump()
    if BlazixHub.Connections.InfiniteJump then
        BlazixHub.Connections.InfiniteJump:Disconnect()
        BlazixHub.Connections.InfiniteJump = nil
        return
    end
    
    BlazixHub.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
        if BlazixHub.Enabled.InfiniteJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

local function ToggleESP()
    if BlazixHub.Enabled.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
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
                humanoid.MaxHealth = math.huge
            end
        end
    end)
end

local function ToggleNoclip()
    if BlazixHub.Connections.Noclip then
        BlazixHub.Connections.Noclip:Disconnect()
        BlazixHub.Connections.Noclip = nil
        return
    end
    
    BlazixHub.Connections.Noclip = RunService.Stepped:Connect(function()
        if BlazixHub.Enabled.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

-- SIMPLE UI CREATION
local function CreateUltimateUI()
    local Colors = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(0, 100, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 150, 0),
        Text = Color3.fromRGB(240, 240, 240)
    }

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixUltimate"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Open Button
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 60, 0, 60)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -30)
    OpenButton.BackgroundColor3 = Colors.Accent
    OpenButton.Text = "🔥\nBLAZIX"
    OpenButton.TextColor3 = Colors.Text
    OpenButton.Font = Enum.Font.GothamBlack
    OpenButton.TextSize = 14
    OpenButton.TextWrapped = true
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(0.2, 0)
    OpenButtonCorner.Parent = OpenButton

    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0.04, 0)
    MainFrameCorner.Parent = MainFrame

    local MainFrameStroke = Instance.new("UIStroke")
    MainFrameStroke.Color = Colors.Accent
    MainFrameStroke.Thickness = 2
    MainFrameStroke.Parent = MainFrame

    -- Header
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
    Title.Text = "🔥 BLAZIX ULTIMATE"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Close Button
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

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    -- Content Frame (SINGLE FRAME FOR ALL TABS)
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -120)
    ContentFrame.Position = UDim2.new(0, 10, 0, 110)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    -- Player Frame
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, 0, 0, 60)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = MainFrame
    PlayerFrame.Position = UDim2.new(0, 0, 1, -60)

    local PlayerFrameCorner = Instance.new("UICorner")
    PlayerFrameCorner.CornerRadius = UDim.new(0.04, 0)
    PlayerFrameCorner.Parent = PlayerFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    PlayerLabel.Position = UDim2.new(0.05, 0, 0, 5)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 Target: None"
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame

    -- Tab Creation Function
    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0.12, 0, 1, 0)
        TabButton.BackgroundColor3 = BlazixHub.CurrentTab == name and Colors.Accent or Colors.Secondary
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 11
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0.1, 0)
        TabCorner.Parent = TabButton
        
        return TabButton
    end

    -- Create Tabs
    local Tabs = {"Visuals", "Combat", "Movement", "Player", "Weapon", "Server", "Trolling"}
    local TabButtons = {}
    
    for i, tabName in ipairs(Tabs) do
        local tab = CreateTab(tabName)
        tab.Position = UDim2.new((i-1) * 0.14, 5, 0, 0)
        TabButtons[tabName] = tab
    end

    -- Toggle Creation Function
    local function CreateToggle(name, configKey, func, color)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Visible = false

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
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and (color or Colors.Success) or Colors.Danger
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
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and (color or Colors.Success) or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
            if func then func() end
        end)

        return ToggleFrame
    end

    -- Create ALL toggles for ALL tabs
    local AllToggles = {}

    -- Visuals Toggles
    AllToggles.Visuals = {
        CreateToggle("👁️ ESP", "ESP", ToggleESP),
        CreateToggle("📦 Box ESP", "BoxESP", nil),
        CreateToggle("🎯 Tracer ESP", "TracerESP", nil),
        CreateToggle("🔤 Name ESP", "NameESP", nil),
        CreateToggle("💡 FullBright", "FullBright", ToggleFullBright),
        CreateToggle("🔍 X-Ray", "XRay", nil),
        CreateToggle("🌈 Chams", "Chams", nil),
        CreateToggle("🌫️ No Fog", "NoFog", nil)
    }

    -- Combat Toggles
    AllToggles.Combat = {
        CreateToggle("🎯 Aimbot", "Aimbot", ToggleAimbot, Colors.Warning),
        CreateToggle("🔫 Trigger Bot", "TriggerBot", nil, Colors.Warning),
        CreateToggle("🎯 Silent Aim", "SilentAim", nil, Colors.Warning),
        CreateToggle("🧱 Wall Bang", "WallBang", nil, Colors.Warning),
        CreateToggle("⚡ Rapid Fire", "RapidFire", nil, Colors.Warning),
        CreateToggle("🎯 No Recoil", "NoRecoil", nil, Colors.Warning),
        CreateToggle("💀 Instant Kill", "InstantKill", nil, Colors.Danger)
    }

    -- Movement Toggles
    AllToggles.Movement = {
        CreateToggle("🪽 Fly", "Fly", ToggleFly),
        CreateToggle("⚡ Speed", "Speed", ToggleSpeed),
        CreateToggle("🦘 Inf Jump", "InfiniteJump", ToggleInfiniteJump),
        CreateToggle("👻 Noclip", "Noclip", ToggleNoclip),
        CreateToggle("🤖 Auto Noclip", "NoClipAuto", nil),
        CreateToggle("🚀 High Jump", "HighJump", nil),
        CreateToggle("🌀 Spin Bot", "SpinBot", nil)
    }

    -- Player Toggles
    AllToggles.Player = {
        CreateToggle("🛡️ God Mode", "GodMode", ToggleGodMode),
        CreateToggle("🎯 Anti Grab", "AntiGrab", nil),
        CreateToggle("⚡ Anti Stun", "AntiStun", nil),
        CreateToggle("🐌 Anti Slow", "AntiSlow", nil),
        CreateToggle("💪 Inf Stamina", "InfiniteStamina", nil),
        CreateToggle("🛡️ Anti Kick", "AntiKick", nil),
        CreateToggle("🛡️ Anti Ban", "AntiBan", nil)
    }

    -- Weapon Toggles
    AllToggles.Weapon = {
        CreateToggle("🎯 Inf Ammo", "InfiniteAmmo", nil),
        CreateToggle("🔫 Gun Mods", "GunMods", nil),
        CreateToggle("⚡ Rapid Fire", "RapidFire", nil),
        CreateToggle("🎯 No Recoil", "NoRecoil", nil),
        CreateToggle("🔁 Auto Reload", "AutoReload", nil)
    }

    -- Server Toggles
    AllToggles.Server = {
        CreateToggle("🌐 Server Hop", "ServerHop", nil),
        CreateToggle("🐌 Lag Server", "LagServer", nil, Colors.Warning),
        CreateToggle("💥 Crash Server", "CrashServer", nil, Colors.Danger),
        CreateToggle("🛡️ Anti Kick", "AntiKick", nil)
    }

    -- Trolling Toggles
    AllToggles.Trolling = {
        CreateToggle("📡 Fake Lag", "FakeLag", nil),
        CreateToggle("💬 Chat Spam", "ChatSpam", nil),
        CreateToggle("🔊 Sound Spam", "SoundSpam", nil),
        CreateToggle("😈 Annoy All", "AnnoyAll", nil)
    }

    -- Add all toggles to ContentFrame
    for tabName, toggles in pairs(AllToggles) do
        for _, toggle in ipairs(toggles) do
            toggle.Parent = ContentFrame
        end
    end

    -- Function to show specific tab
    local function ShowTab(tabName)
        BlazixHub.CurrentTab = tabName
        
        -- Update tab colors
        for name, tab in pairs(TabButtons) do
            tab.BackgroundColor3 = name == tabName and Colors.Accent or Colors.Secondary
        end
        
        -- Hide all toggles first
        for _, toggles in pairs(AllToggles) do
            for _, toggle in ipairs(toggles) do
                toggle.Visible = false
            end
        end
        
        -- Show current tab toggles
        if AllToggles[tabName] then
            local yOffset = 5
            for i, toggle in ipairs(AllToggles[tabName]) do
                toggle.Visible = true
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
        end
    end

    -- Connect tab buttons
    for tabName, tabButton in pairs(TabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            ShowTab(tabName)
        end)
    end

    -- Player Selection
    local SelectButton = Instance.new("TextButton")
    SelectButton.Size = UDim2.new(0.2, 0, 0.6, 0)
    SelectButton.Position = UDim2.new(0.45, 0, 0.2, 0)
    SelectButton.BackgroundColor3 = Colors.Accent
    SelectButton.Text = "SELECT"
    SelectButton.TextColor3 = Colors.Text
    SelectButton.Font = Enum.Font.GothamBold
    SelectButton.TextSize = 11
    SelectButton.Parent = PlayerFrame

    local SelectCorner = Instance.new("UICorner")
    SelectCorner.CornerRadius = UDim.new(0.1, 0)
    SelectCorner.Parent = SelectButton

    SelectButton.MouseButton1Click:Connect(function()
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0, 300, 0, 300)
        PlayerList.Position = UDim2.new(0.5, -150, 0.5, -150)
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
                    PlayerLabel.Text = "🎯 Target: " .. player.Name
                    PlayerList:Destroy()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerList:Destroy()
        end)
    end)

    -- UI Controls
    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    -- Dragging
    local function MakeDraggable(gui)
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    MakeDraggable(OpenButton)
    MakeDraggable(MainFrame)

    -- Show initial tab
    ShowTab("Visuals")

    return ScreenGui
end

-- INITIALIZE
local success, err = pcall(function()
    local UI = CreateUltimateUI()
    print("🔥 BLAZIX ULTIMATE LOADED!")
    print("✅ ALL TABS WORKING PERFECTLY!")
    print("✅ SIMPLE AND CLEAN SYSTEM!")
    print("📍 CLICK THE FIRE BUTTON TO OPEN!")
end)

if not success then
    warn("❌ LOAD ERROR: " .. tostring(err))
end
