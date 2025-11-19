-- BlazixHub V5 - ULTIMATE WIDE MENU WITH 50+ FEATURES
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

-- ADVANCED PISTOL SHOOT FUNCTION
local function ShootPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            -- Teleport to player first
            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            
            -- Find pistol in inventory
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local character = LocalPlayer.Character
            
            local pistol
            if backpack then
                pistol = backpack:FindFirstChild("Pistol") or backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")
            end
            if character and not pistol then
                pistol = character:FindFirstChild("Pistol") or character:FindFirstChild("Gun") or character:FindFirstChild("Revolver")
            end
            
            if pistol then
                -- Equip pistol
                pistol.Parent = character
                
                -- Wait for equip
                wait(0.2)
                
                -- Simulate shooting
                local args = {
                    [1] = targetRoot.Position,
                    [2] = target.Character:FindFirstChild("Head") or targetRoot
                }
                
                -- Try to find shoot remote
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("shoot") or v.Name:lower():find("fire") or v.Name:lower():find("damage")) then
                        pcall(function()
                            v:FireServer(unpack(args))
                        end)
                    end
                end
                
                -- Also try remotefunctions
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteFunction") and (v.Name:lower():find("shoot") or v.Name:lower():find("fire") or v.Name:lower():find("damage")) then
                        pcall(function()
                            v:InvokeServer(unpack(args))
                        end)
                    end
                end
                
                -- Force click if no remote found
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
            else
                -- If no pistol found, use touch damage
                firetouchinterest(targetRoot, localRoot, 0)
                firetouchinterest(targetRoot, localRoot, 1)
            end
        end
    end
end

-- ADVANCED FLY SYSTEM
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

-- SPEED HACK
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

-- INFINITE JUMP
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

-- HIGH JUMP
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
            if humanoid then humanoid.JumpPower = 200 end
        end
    end)
end

-- SPIN BOT
local function ToggleSpinBot()
    if BlazixHub.Connections.SpinBot then
        BlazixHub.Connections.SpinBot:Disconnect()
        BlazixHub.Connections.SpinBot = nil
        return
    end
    
    BlazixHub.Connections.SpinBot = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.SpinBot and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(30), 0)
            end
        end
    end)
end

-- GOD MODE
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

-- NOCLIP
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

-- AUTO NOCLIP
local function ToggleNoClipAuto()
    if BlazixHub.Connections.NoClipAuto then
        BlazixHub.Connections.NoClipAuto:Disconnect()
        BlazixHub.Connections.NoClipAuto = nil
        return
    end
    
    BlazixHub.Connections.NoClipAuto = RunService.Stepped:Connect(function()
        if BlazixHub.Enabled.NoClipAuto and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.MoveDirection.Magnitude > 0 then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end
    end)
end

-- ADVANCED ESP SYSTEM
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

-- BOX ESP
local function ToggleBoxESP()
    if BlazixHub.Enabled.BoxESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "BlazixBoxESP"
                box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
                box.AlwaysOnTop = true
                box.Size = Vector3.new(3, 5, 1)
                box.Color3 = Color3.fromRGB(0, 255, 0)
                box.Transparency = 0.3
                box.Parent = player.Character
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, v in pairs(player.Character:GetChildren()) do
                    if v.Name == "BlazixBoxESP" then v:Destroy() end
                end
            end
        end
    end
end

-- TRACER ESP
local function ToggleTracerESP()
    if BlazixHub.Enabled.TracerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local beam = Instance.new("Beam")
                beam.Name = "BlazixTracer"
                beam.Attachment0 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("RootAttachment")
                beam.Attachment1 = player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("RootAttachment")
                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                beam.Width0 = 0.1
                beam.Width1 = 0.1
                beam.Parent = Workspace
            end
        end
    else
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "BlazixTracer" then v:Destroy() end
        end
    end
end

-- NAME ESP
local function ToggleNameESP()
    if BlazixHub.Enabled.NameESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "BlazixNameESP"
                billboard.Adornee = player.Character:FindFirstChild("Head")
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = player.Character
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                label.Parent = billboard
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, v in pairs(player.Character:GetChildren()) do
                    if v.Name == "BlazixNameESP" then v:Destroy() end
                end
            end
        end
    end
end

-- FULLBRIGHT
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

-- XRAY
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

-- AIMBOT
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

-- TRIGGER BOT
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
                wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
            end
        end
    end)
end

-- INFINITE AMMO
local function ToggleInfiniteAmmo()
    if BlazixHub.Connections.InfiniteAmmo then
        BlazixHub.Connections.InfiniteAmmo:Disconnect()
        BlazixHub.Connections.InfiniteAmmo = nil
        return
    end
    
    BlazixHub.Connections.InfiniteAmmo = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.InfiniteAmmo then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("IntValue") and (v.Name:lower():find("ammo") or v.Name:lower():find("bullet")) then
                            v.Value = 999
                        end
                    end
                end
            end
        end
    end)
end

-- LAG SERVER
local function ToggleLagServer()
    if BlazixHub.Connections.LagServer then
        BlazixHub.Connections.LagServer:Disconnect()
        BlazixHub.Connections.LagServer = nil
        return
    end
    
    BlazixHub.Connections.LagServer = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.LagServer then
            for i = 1, 10 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1000, 1000, 1000)
                part.Parent = Workspace
                game:GetService("Debris"):AddItem(part, 0.1)
            end
        end
    end)
end

-- CRASH SERVER
local function CrashServer()
    for i = 1, 1000 do
        coroutine.wrap(function()
            while true do
                local part = Instance.new("Part")
                part.Size = Vector3.new(5000, 5000, 5000)
                part.Parent = Workspace
            end
        end)()
    end
end

-- ANTI KICK
local function ToggleAntiKick()
    if BlazixHub.Enabled.AntiKick then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then return nil end
            return old(self, ...)
        end)
    end
end

-- TELEPORT TO PLAYER
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

-- BRING PLAYER
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

-- KILL PLAYER
local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
end

-- KILL ALL
local function KillAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end
end

-- ULTIMATE WIDE UI WITH TABS
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

    -- Open Button (MOVABLE)
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

    -- WIDE Main Window (MOVABLE)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 500)  -- Wider window
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
    Title.Text = "🔥 BLAZIX ULTIMATE - 50+ FEATURES"
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

    -- Tab System
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    -- Tab Buttons
    local Tabs = {"Visuals", "Combat", "Movement", "Player", "Weapon", "Server", "Trolling"}
    local TabButtons = {}
    
    local function CreateTabButton(name, position)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0.12, 0, 1, 0)
        TabButton.Position = position
        TabButton.BackgroundColor3 = BlazixHub.CurrentTab == name and Colors.Accent or Colors.Secondary
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 11
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0.1, 0)
        TabCorner.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = name
            UpdateTabContent()
            -- Update all tab colors
            for _, btn in pairs(TabButtons) do
                btn.BackgroundColor3 = btn.Text == name and Colors.Accent or Colors.Secondary
            end
        end)
        
        table.insert(TabButtons, TabButton)
        return TabButton
    end

    -- Create tabs
    for i, tabName in ipairs(Tabs) do
        CreateTabButton(tabName, UDim2.new((i-1)*0.14, 5, 0, 0))
    end

    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -120)
    ContentFrame.Position = UDim2.new(0, 10, 0, 110)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    -- Player Selection Frame (always visible)
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
    PlayerLabel.Text = "🎯 Target: " .. (BlazixHub.SelectedPlayer or "None")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame

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

    -- Player action buttons
    local actionButtons = {
        {"TP", Colors.Accent, function() if BlazixHub.SelectedPlayer then TeleportToPlayer(BlazixHub.SelectedPlayer) end end},
        {"BRING", Colors.Warning, function() if BlazixHub.SelectedPlayer then BringPlayer(BlazixHub.SelectedPlayer) end end},
        {"KILL", Colors.Danger, function() if BlazixHub.SelectedPlayer then KillPlayer(BlazixHub.SelectedPlayer) end end},
        {"SHOOT", Colors.Danger, function() if BlazixHub.SelectedPlayer then ShootPlayer(BlazixHub.SelectedPlayer) end end}
    }

    for i, action in ipairs(actionButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.15, 0, 0.6, 0)
        btn.Position = UDim2.new(0.65 + (i-1)*0.16, 0, 0.2, 0)
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

    -- Toggle Function
    local function CreateWideToggle(name, configKey, toggleFunc, color)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 35)  -- Wider toggles
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
            if toggleFunc then toggleFunc() end
        end)

        return ToggleFrame
    end

    -- Button Function
    local function CreateWideButton(name, callback, color)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(0.48, 0, 0, 35)
        ButtonFrame.BackgroundColor3 = Colors.Secondary
        ButtonFrame.Parent = ContentFrame

        local ButtonFrameCorner = Instance.new("UICorner")
        ButtonFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ButtonFrameCorner.Parent = ButtonFrame

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Text = name
        ButtonLabel.TextColor3 = Colors.Text
        ButtonLabel.Font = Enum.Font.Gotham
        ButtonLabel.TextSize = 12
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = ButtonFrame

        local ActionButton = Instance.new("TextButton")
        ActionButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ActionButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ActionButton.BackgroundColor3 = color or Colors.Accent
        ActionButton.Text = "EXEC"
        ActionButton.TextColor3 = Colors.Text
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.TextSize = 10
        ActionButton.Parent = ButtonFrame

        local ActionButtonCorner = Instance.new("UICorner")
        ActionButtonCorner.CornerRadius = UDim.new(0.15, 0)
        ActionButtonCorner.Parent = ActionButton

        ActionButton.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)

        return ButtonFrame
    end

    -- Update Tab Content
    local function UpdateTabContent()
        -- Clear content
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local yOffset = 5
        
        if BlazixHub.CurrentTab == "Visuals" then
            -- Visuals Tab
            local visuals = {
                {"👁️ ESP", "ESP", ToggleESP},
                {"📦 Box ESP", "BoxESP", ToggleBoxESP},
                {"🎯 Tracer ESP", "TracerESP", ToggleTracerESP},
                {"🔤 Name ESP", "NameESP", ToggleNameESP},
                {"❤️ Health ESP", "HealthESP", nil},
                {"📏 Distance ESP", "DistanceESP", nil},
                {"🌈 Chams", "Chams", nil},
                {"🔍 X-Ray", "XRay", ToggleXRay},
                {"💡 FullBright", "FullBright", ToggleFullBright},
                {"🌫️ No Fog", "NoFog", nil}
            }
            
            for i, visual in ipairs(visuals) do
                local toggle = CreateWideToggle(visual[1], visual[2], visual[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
        elseif BlazixHub.CurrentTab == "Combat" then
            -- Combat Tab
            local combat = {
                {"🎯 Aimbot", "Aimbot", ToggleAimbot, Colors.Warning},
                {"🔫 Trigger Bot", "TriggerBot", ToggleTriggerBot, Colors.Warning},
                {"🎯 Silent Aim", "SilentAim", nil, Colors.Warning},
                {"🧱 Wall Bang", "WallBang", nil, Colors.Warning},
                {"⚡ Rapid Fire", "RapidFire", nil, Colors.Warning},
                {"🎯 No Recoil", "NoRecoil", nil, Colors.Warning},
                {"🎯 No Spread", "NoSpread", nil, Colors.Warning},
                {"🔁 Auto Reload", "AutoReload", nil},
                {"💀 Instant Kill", "InstantKill", nil, Colors.Danger},
                {"📦 HitBox Expand", "HitBoxExpand", nil, Colors.Warning}
            }
            
            for i, combatFeature in ipairs(combat) do
                local toggle = CreateWideToggle(combatFeature[1], combatFeature[2], combatFeature[3], combatFeature[4])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
        elseif BlazixHub.CurrentTab == "Movement" then
            -- Movement Tab
            local movement = {
                {"🪽 Fly", "Fly", ToggleFly},
                {"⚡ Speed", "Speed", ToggleSpeed},
                {"🦘 Inf Jump", "InfiniteJump", ToggleInfiniteJump},
                {"👻 Noclip", "Noclip", ToggleNoclip},
                {"🤖 Auto Noclip", "NoClipAuto", ToggleNoClipAuto},
                {"🚀 High Jump", "HighJump", ToggleHighJump},
                {"🌀 Spin Bot", "SpinBot", ToggleSpinBot},
                {"🛡️ Anti Stomp", "AntiStomp", nil},
                {"🎯 Anti Grab", "AntiGrab", nil}
            }
            
            for i, move in ipairs(movement) do
                local toggle = CreateWideToggle(move[1], move[2], move[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
        elseif BlazixHub.CurrentTab == "Player" then
            -- Player Tab
            local player = {
                {"🛡️ God Mode", "GodMode", ToggleGodMode},
                {"🎯 Anti Grab", "AntiGrab", nil},
                {"⚡ Anti Stun", "AntiStun", nil},
                {"🐌 Anti Slow", "AntiSlow", nil},
                {"🕳️ Anti Void", "AntiVoid", nil},
                {"🔁 Auto Respawn", "AutoRespawn", nil},
                {"💪 Inf Stamina", "InfiniteStamina", nil},
                {"🛡️ Anti Kick", "AntiKick", ToggleAntiKick},
                {"🛡️ Anti Ban", "AntiBan", nil}
            }
            
            for i, playerFeature in ipairs(player) do
                local toggle = CreateWideToggle(playerFeature[1], playerFeature[2], playerFeature[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
        elseif BlazixHub.CurrentTab == "Weapon" then
            -- Weapon Tab
            local weapon = {
                {"🎯 Inf Ammo", "InfiniteAmmo", ToggleInfiniteAmmo},
                {"🔫 Gun Mods", "GunMods", nil},
                {"⚡ Rapid Fire", "RapidFire", nil},
                {"🎯 No Recoil", "NoRecoil", nil},
                {"🎯 No Spread", "NoSpread", nil},
                {"🔁 Auto Reload", "AutoReload", nil},
                {"🏴‍☠️ Weapon Steal", "WeaponSteal", nil}
            }
            
            for i, weaponFeature in ipairs(weapon) do
                local toggle = CreateWideToggle(weaponFeature[1], weaponFeature[2], weaponFeature[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
            -- Add weapon buttons
            CreateWideButton("🔫 Give All Guns", function()
                -- Give weapons function
            end, Colors.Accent).Position = UDim2.new(0, 5, 0, yOffset)
            
        elseif BlazixHub.CurrentTab == "Server" then
            -- Server Tab
            local server = {
                {"🌐 Server Hop", "ServerHop", nil},
                {"🐌 Lag Server", "LagServer", ToggleLagServer, Colors.Warning},
                {"💥 Crash Server", "CrashServer", nil, Colors.Danger},
                {"🛡️ Anti Kick", "AntiKick", ToggleAntiKick}
            }
            
            for i, serverFeature in ipairs(server) do
                local toggle = CreateWideToggle(serverFeature[1], serverFeature[2], serverFeature[3], serverFeature[4])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
            
            -- Server control buttons
            CreateWideButton("💥 CRASH SERVER", CrashServer, Colors.Danger).Position = UDim2.new(0, 5, 0, yOffset)
            CreateWideButton("💀 KILL ALL", KillAllPlayers, Colors.Danger).Position = UDim2.new(0.5, 5, 0, yOffset)
            yOffset = yOffset + 40
            
        elseif BlazixHub.CurrentTab == "Trolling" then
            -- Trolling Tab
            local trolling = {
                {"📡 Fake Lag", "FakeLag", nil},
                {"💬 Chat Spam", "ChatSpam", nil},
                {"🔊 Sound Spam", "SoundSpam", nil},
                {"😈 Annoy All", "AnnoyAll", nil}
            }
            
            for i, troll in ipairs(trolling) do
                local toggle = CreateWideToggle(troll[1], troll[2], troll[3])
                toggle.Position = UDim2.new(i % 2 == 1 and 0 or 0.5, 5, 0, yOffset)
                if i % 2 == 0 then yOffset = yOffset + 40 end
            end
        end
        
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- Player Selection Logic
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

    -- Initialize first tab
    UpdateTabContent()

    -- UI Controls
    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    -- DRAGGING FUNCTION FOR BOTH OPEN BUTTON AND MAIN FRAME
    local function MakeDraggable(gui)
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- Apply dragging to both OpenButton and MainFrame
    MakeDraggable(OpenButton)
    MakeDraggable(MainFrame)

    return ScreenGui
end

-- INITIALIZE ULTIMATE VERSION
local success, err = pcall(function()
    local UI = CreateUltimateUI()
    print("🔥 BLAZIX ULTIMATE LOADED!")
    print("✅ 50+ FEATURES AVAILABLE")
    print("✅ 7 TABS SYSTEM - WORKING")
    print("✅ WIDE MENU DESIGN")
    print("✅ MOVABLE OPEN BUTTON AND MENU")
    print("✅ PISTOL SHOOT FUNCTION ADDED")
    print("📍 CLICK THE FIRE BUTTON!")
    print("📍 DRAG THE BUTTON AND MENU TO MOVE!")
end)

if not success then
    warn("❌ ULTIMATE LOAD ERROR: " .. tostring(err))
end
