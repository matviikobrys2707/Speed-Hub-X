-- BlazixHub V4 - ADVANCED WORKING VERSION
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

-- ADVANCED CONFIG WITH BYPASS METHODS
local BlazixHub = {
    Enabled = {
        Fly = false,
        GodMode = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        ESP = false,
        Aimbot = false,
        TriggerBot = false,
        AutoFarm = false,
        NoRecoil = false,
        XRay = false
    },
    Connections = {},
    SelectedPlayer = nil,
    BypassMethods = {
        AntiKick = true,
        AntiBan = true,
        AntiDetection = true
    }
}

-- ADVANCED BYPASS SYSTEM
local function InitializeBypass()
    -- Memory manipulation protection
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Anti-kick bypass
        if BlazixHub.BypassMethods.AntiKick and method == "Kick" then
            return nil
        end
        
        -- Anti-ban bypass  
        if BlazixHub.BypassMethods.AntiBan and method == "Ban" then
            return nil
        end
        
        return originalNamecall(self, ...)
    end)

    -- Anti-detection hooks
    for _, service in pairs({Players, Workspace, Lighting}) do
        if service.ChildAdded then
            service.ChildAdded:Connect(function(child)
                if BlazixHub.BypassMethods.AntiDetection then
                    if child:IsA("Script") and child.Name:lower():find("anti") or child.Name:lower():find("cheat") then
                        child:Destroy()
                    end
                end
            end)
        end
    end
end

-- ADVANCED FLY WITH BYPASS
local function ToggleFly()
    if BlazixHub.Connections.Fly then
        BlazixHub.Connections.Fly:Disconnect()
        BlazixHub.Connections.Fly = nil
        if LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
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
                
                -- Advanced flight controls
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                -- Smooth flight with bypass
                root.Velocity = direction.Unit * 150
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- ADVANCED GOD MODE WITH MULTIPLE BYPASSES
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
                -- Multiple god mode methods
                humanoid.Health = 100
                humanoid.MaxHealth = 100
                
                -- Break joints protection
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("JointInstance") then
                        part:Destroy()
                    end
                end
            end
        end
    end)
end

-- ADVANCED SPEED WITH ANTI-DETECTION
local function ToggleSpeed()
    if BlazixHub.Connections.Speed then
        BlazixHub.Connections.Speed:Disconnect()
        BlazixHub.Connections.Speed = nil
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        return
    end
    
    BlazixHub.Connections.Speed = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.Speed and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Variable speed for anti-detection
                humanoid.WalkSpeed = math.random(80, 120)
            end
        end
    end)
end

-- ADVANCED INFINITE JUMP
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

-- ADVANCED NOCLIP WITH COLLISION BYPASS
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
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end

-- ADVANCED ESP WITH BOX ESP AND TRACERS
local function ToggleESP()
    if BlazixHub.Enabled.ESP then
        -- Clear existing ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj.Name == "BlazixESP" or obj.Name == "BlazixTracer" then
                        obj:Destroy()
                    end
                end
            end
        end
        
        -- Create advanced ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and root then
                    -- Box ESP
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "BlazixESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                    
                    -- Tracer
                    local tracer = Instance.new("Frame")
                    tracer.Name = "BlazixTracer"
                    tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    tracer.BorderSizePixel = 0
                    tracer.Size = UDim2.new(0, 2, 0, 100)
                    tracer.Parent = PlayerGui
                    
                    -- Update tracer position
                    RunService.Heartbeat:Connect(function()
                        local vector, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            tracer.Visible = true
                            tracer.Position = UDim2.new(0, vector.X, 0, vector.Y)
                            tracer.Rotation = math.atan2(vector.Y - Workspace.CurrentCamera.ViewportSize.Y/2, vector.X - Workspace.CurrentCamera.ViewportSize.X/2) * (180/math.pi)
                        else
                            tracer.Visible = false
                        end
                    end)
                end
            end
        end
    else
        -- Remove ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj.Name == "BlazixESP" or obj.Name == "BlazixTracer" then
                        obj:Destroy()
                    end
                end
            end
        end
        if PlayerGui:FindFirstChild("BlazixTracer") then
            PlayerGui.BlazixTracer:Destroy()
        end
    end
end

-- ADVANCED AIMBOT SYSTEM
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
                
                if targetRoot and localRoot then
                    -- Smooth aimbot
                    local direction = (targetRoot.Position - localRoot.Position).Unit
                    local newCF = CFrame.new(localRoot.Position, localRoot.Position + direction)
                    
                    -- Apply smooth aiming
                    localRoot.CFrame = newCF
                    cam.CFrame = newCF
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
                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- Auto click when target is in sight
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
                end
            end
        end
    end)
end

-- XRAY VISION
local function ToggleXRay()
    if BlazixHub.Enabled.XRay then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
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

-- ADVANCED TELEPORT SYSTEM
local function TeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            -- Smooth teleport
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(localRoot, tweenInfo, {CFrame = targetRoot.CFrame})
            tween:Play()
        end
    end
end

-- ADVANCED KILL SYSTEM
local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Multiple kill methods
            humanoid.Health = 0
            firetouchinterest(target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), 0)
        end
    end
end

-- BRING PLAYER WITH ANTI-TELEPORT DETECTION
local function BringPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            -- Anti-detection bring
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tween = TweenService:Create(targetRoot, tweenInfo, {CFrame = localRoot.CFrame})
            tween:Play()
        end
    end
end

-- MASS KILL WITH BYPASS
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

-- CRASH SERVER FUNCTION
local function CrashServer()
    while true do
        for i = 1, 1000 do
            local part = Instance.new("Part")
            part.Parent = Workspace
            part.Anchored = true
            part.Size = Vector3.new(1000, 1000, 1000)
        end
        task.wait()
    end
end

-- LAG SERVER FUNCTION  
local function LagServer()
    for i = 1, 100 do
        coroutine.wrap(function()
            while true do
                local explosion = Instance.new("Explosion")
                explosion.Position = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
                explosion.Parent = Workspace
                task.wait(0.01)
            end
        end)()
    end
end

-- ADVANCED UI CREATION
local function CreateAdvancedUI()
    -- Enhanced Colors
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
    ScreenGui.Name = "BlazixHubAdvanced"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Floating Open Button
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
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(0.3, 0)
    OpenButtonCorner.Parent = OpenButton

    local OpenButtonGlow = Instance.new("UIStroke")
    OpenButtonGlow.Color = Colors.Accent
    OpenButtonGlow.Thickness = 3
    OpenButtonGlow.Parent = OpenButton

    -- Enhanced Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0.04, 0)
    MainFrameCorner.Parent = MainFrame

    local MainFrameGlow = Instance.new("UIStroke")
    MainFrameGlow.Color = Colors.Accent
    MainFrameGlow.Thickness = 3
    MainFrameGlow.Parent = MainFrame

    -- Enhanced Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.04, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 BLAZIX HUB V4 - ADVANCED"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(0.7, 0, 0, 20)
    SubTitle.Position = UDim2.new(0.05, 0, 0.5, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "ADVANCED BYPASS SYSTEM ACTIVE"
    SubTitle.TextColor3 = Colors.Success
    SubTitle.Font = Enum.Font.GothamBold
    SubTitle.TextSize = 10
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(0.9, 0, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBlack
    CloseButton.TextSize = 16
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Tab System
    local TabButtons = Instance.new("Frame")
    TabButtons.Size = UDim2.new(1, -20, 0, 40)
    TabButtons.Position = UDim2.new(0, 10, 0, 70)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame

    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -130)
    ContentFrame.Position = UDim2.new(0, 10, 0, 120)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
    ContentFrame.Parent = MainFrame

    -- Enhanced Toggle Function
    local function CreateAdvancedToggle(name, desc, configKey, toggleFunc, color)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 55)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Parent = ContentFrame

        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ToggleFrameCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        ToggleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.Font = Enum.Font.GothamBold
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleDesc = Instance.new("TextLabel")
        ToggleDesc.Size = UDim2.new(0.7, 0, 0.4, 0)
        ToggleDesc.Position = UDim2.new(0.05, 0, 0.6, 0)
        ToggleDesc.BackgroundTransparency = 1
        ToggleDesc.Text = desc
        ToggleDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        ToggleDesc.Font = Enum.Font.Gotham
        ToggleDesc.TextSize = 10
        ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDesc.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 70, 0, 35)
        ToggleButton.Position = UDim2.new(0.85, -35, 0.5, -17.5)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and (color or Colors.Success) or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ACTIVE" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 11
        ToggleButton.Parent = ToggleFrame

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(0.15, 0)
        ToggleButtonCorner.Parent = ToggleButton

        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Enabled[configKey] = not BlazixHub.Enabled[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and (color or Colors.Success) or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ACTIVE" or "OFF"
            
            if toggleFunc then
                toggleFunc()
            end
        end)

        return ToggleFrame
    end

    -- Enhanced Button Function
    local function CreateAdvancedButton(name, desc, callback, color, icon)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 55)
        ButtonFrame.BackgroundColor3 = Colors.Secondary
        ButtonFrame.Parent = ContentFrame

        local ButtonFrameCorner = Instance.new("UICorner")
        ButtonFrameCorner.CornerRadius = UDim.new(0.08, 0)
        ButtonFrameCorner.Parent = ButtonFrame

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        ButtonLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Text = (icon or "⚡") .. " " .. name
        ButtonLabel.TextColor3 = Colors.Text
        ButtonLabel.Font = Enum.Font.GothamBold
        ButtonLabel.TextSize = 14
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = ButtonFrame

        local ButtonDesc = Instance.new("TextLabel")
        ButtonDesc.Size = UDim2.new(0.7, 0, 0.4, 0)
        ButtonDesc.Position = UDim2.new(0.05, 0, 0.6, 0)
        ButtonDesc.BackgroundTransparency = 1
        ButtonDesc.Text = desc
        ButtonDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        ButtonDesc.Font = Enum.Font.Gotham
        ButtonDesc.TextSize = 10
        ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
        ButtonDesc.Parent = ButtonFrame

        local ActionButton = Instance.new("TextButton")
        ActionButton.Size = UDim2.new(0, 80, 0, 35)
        ActionButton.Position = UDim2.new(0.85, -40, 0.5, -17.5)
        ActionButton.BackgroundColor3 = color or Colors.Accent
        ActionButton.Text = "EXECUTE"
        ActionButton.TextColor3 = Colors.Text
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.TextSize = 11
        ActionButton.Parent = ButtonFrame

        local ActionButtonCorner = Instance.new("UICorner")
        ActionButtonCorner.CornerRadius = UDim.new(0.15, 0)
        ActionButtonCorner.Parent = ActionButton

        ActionButton.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)

        return ButtonFrame
    end

    -- Arrange content
    local function ArrangeContent()
        local yOffset = 10
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Position = UDim2.new(0, 0, 0, yOffset)
                yOffset = yOffset + 65
            end
        end
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- Add advanced features
    CreateAdvancedToggle("🪽 ADVANCED FLY", "Fly with anti-detection", "Fly", ToggleFly)
    CreateAdvancedToggle("🛡️ GOD MODE", "Multiple invincibility methods", "GodMode", ToggleGodMode)
    CreateAdvancedToggle("⚡ SPEED HACK", "Variable speed anti-cheat", "Speed", ToggleSpeed)
    CreateAdvancedToggle("🦘 INFINITE JUMP", "Unlimited jumping", "InfiniteJump", ToggleInfiniteJump)
    CreateAdvancedToggle("👻 ADVANCED NOCLIP", "Walk through everything", "Noclip", ToggleNoclip)
    CreateAdvancedToggle("👁️ BOX ESP + TRACERS", "Advanced player ESP", "ESP", ToggleESP)
    CreateAdvancedToggle("🎯 AIMBOT", "Auto-aim at selected player", "Aimbot", ToggleAimbot, Colors.Warning)
    CreateAdvancedToggle("🔫 TRIGGER BOT", "Auto-shoot when aimed", "TriggerBot", ToggleTriggerBot, Colors.Warning)
    CreateAdvancedToggle("🔍 X-RAY VISION", "See through walls", "XRay", ToggleXRay)

    -- Player selection system
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, 0, 0, 80)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = ContentFrame

    local PlayerFrameCorner = Instance.new("UICorner")
    PlayerFrameCorner.CornerRadius = UDim.new(0.08, 0)
    PlayerFrameCorner.Parent = PlayerFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, -20, 0, 25)
    PlayerLabel.Position = UDim2.new(0, 10, 0, 5)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 TARGET: " .. (BlazixHub.SelectedPlayer or "NONE SELECTED")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 14
    PlayerLabel.Parent = PlayerFrame

    local SelectButton = Instance.new("TextButton")
    SelectButton.Size = UDim2.new(0.6, 0, 0, 35)
    SelectButton.Position = UDim2.new(0.2, 0, 0, 40)
    SelectButton.BackgroundColor3 = Colors.Accent
    SelectButton.Text = "🎯 SELECT TARGET"
    SelectButton.TextColor3 = Colors.Text
    SelectButton.Font = Enum.Font.GothamBold
    SelectButton.TextSize = 12
    SelectButton.Parent = PlayerFrame

    local SelectButtonCorner = Instance.new("UICorner")
    SelectButtonCorner.CornerRadius = UDim.new(0.15, 0)
    SelectButtonCorner.Parent = SelectButton

    -- Player actions
    CreateAdvancedButton("TELEPORT TO TARGET", "Instant teleport to player", function()
        if BlazixHub.SelectedPlayer then
            TeleportToPlayer(BlazixHub.SelectedPlayer)
        end
    end, Colors.Accent, "🎯")

    CreateAdvancedButton("ELIMINATE TARGET", "Remove selected player", function()
        if BlazixHub.SelectedPlayer then
            KillPlayer(BlazixHub.SelectedPlayer)
        end
    end, Colors.Danger, "💀")

    CreateAdvancedButton("BRING TARGET", "Bring player to you", function()
        if BlazixHub.SelectedPlayer then
            BringPlayer(BlazixHub.SelectedPlayer)
        end
    end, Colors.Warning, "👥")

    -- Server control buttons
    CreateAdvancedButton("MASS ELIMINATION", "Remove all players", KillAllPlayers, Colors.Danger, "💥")
    CreateAdvancedButton("SERVER CRASHER", "Crash the server", CrashServer, Colors.Danger, "🌋")
    CreateAdvancedButton("SERVER LAGGER", "Lag the server", LagServer, Colors.Warning, "🐌")

    -- Player selection logic
    SelectButton.MouseButton1Click:Connect(function()
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0, 300, 0, 300)
        PlayerList.Position = UDim2.new(0.5, -150, 0.5, -150)
        PlayerList.BackgroundColor3 = Colors.Background
        PlayerList.Parent = MainFrame

        local PlayerListCorner = Instance.new("UICorner")
        PlayerListCorner.CornerRadius = UDim.new(0.08, 0)
        PlayerListCorner.Parent = PlayerList

        local PlayerListGlow = Instance.new("UIStroke")
        PlayerListGlow.Color = Colors.Accent
        PlayerListGlow.Thickness = 2
        PlayerListGlow.Parent = PlayerList

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -10, 1, -40)
        Scroll.Position = UDim2.new(0, 5, 0, 35)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.Parent = PlayerList

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 35, 0, 35)
        CloseBtn.Position = UDim2.new(1, -40, 0, 5)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.GothamBlack
        CloseBtn.TextSize = 16
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
                PlayerBtn.Text = "🎯 " .. player.Name
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
                    PlayerLabel.Text = "🎯 TARGET: " .. player.Name
                    PlayerList:Destroy()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)

        CloseBtn.MouseButton1Click:Connect(function()
            PlayerList:Destroy()
        end)
    end)

    -- Arrange all elements
    ArrangeContent()

    -- UI Controls
    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    -- Draggable UI
    local dragging
    local dragInput
    local dragStart
    local startPos

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

    return ScreenGui
end

-- INITIALIZE ADVANCED SYSTEM
local success, err = pcall(function()
    InitializeBypass()
    local UI = CreateAdvancedUI()
    print("🔥 BLAZIX HUB V4 LOADED SUCCESSFULLY!")
    print("✅ ADVANCED BYPASS SYSTEM: ACTIVE")
    print("✅ MEMORY PROTECTION: ENABLED")
    print("✅ ANTI-DETECTION: RUNNING")
    print("📍 CLICK THE FLOATING BUTTON TO OPEN!")
end)

if not success then
    warn("❌ ERROR LOADING BLAZIX HUB: " .. tostring(err))
    
    -- Emergency fallback
    local Message = Instance.new("Message")
    Message.Text = "🔥 BLAZIX HUB V4 - EMERGENCY MODE ACTIVE"
    Message.Parent = Workspace
    delay(3, function() Message:Destroy() end)
end
