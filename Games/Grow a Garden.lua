-- BlazixHub V4 - MOBILE COMPACT VERSION
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

-- COMPACT CONFIG FOR MOBILE
local BlazixHub = {
    Enabled = {
        Fly = false,
        GodMode = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        ESP = false,
        Aimbot = false
    },
    Connections = {},
    SelectedPlayer = nil
}

-- COMPACT FLY FUNCTION
local function ToggleFly()
    if BlazixHub.Connections.Fly then
        BlazixHub.Connections.Fly:Disconnect()
        BlazixHub.Connections.Fly = nil
        return
    end
    
    BlazixHub.Connections.Fly = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.Fly and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local cam = Workspace.CurrentCamera
                local direction = Vector3.new()
                
                -- Touch controls for mobile
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
                
                root.Velocity = direction.Unit * 100
            end
        end
    end)
end

-- COMPACT GOD MODE
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
                humanoid.Health = 100
            end
        end
    end)
end

-- COMPACT SPEED
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
                humanoid.WalkSpeed = 50
            end
        end
    end)
end

-- COMPACT INFINITE JUMP
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

-- COMPACT NOCLIP
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

-- COMPACT ESP
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

-- COMPACT AIMBOT
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

-- COMPACT TELEPORT
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

-- COMPACT KILL
local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

-- COMPACT BRING
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

-- COMPACT KILL ALL
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

-- COMPACT UI FOR MOBILE
local function CreateMobileUI()
    -- Mobile-optimized colors
    local Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(0, 120, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 60, 60),
        Text = Color3.fromRGB(240, 240, 240)
    }

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixMobile"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Compact Open Button (top-right corner)
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 50, 0, 50)
    OpenButton.Position = UDim2.new(1, -60, 0, 10)
    OpenButton.BackgroundColor3 = Colors.Accent
    OpenButton.Text = "🔥"
    OpenButton.TextColor3 = Colors.Text
    OpenButton.Font = Enum.Font.GothamBlack
    OpenButton.TextSize = 18
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(0.2, 0)
    OpenButtonCorner.Parent = OpenButton

    -- Compact Main Window (smaller for mobile)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)  -- Smaller size
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
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

    -- Compact Header with CLOSE BUTTON
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)  -- Smaller header
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.04, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "BLAZIX MOBILE"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14  -- Smaller text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- CLOSE BUTTON - CLEARLY VISIBLE
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0.9, 0, 0.5, -15)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Compact Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -50)
    ContentFrame.Position = UDim2.new(0, 5, 0, 45)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ContentFrame.Parent = MainFrame

    -- Compact Toggle Function
    local function CreateMobileToggle(name, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)  -- Smaller toggles
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
        ToggleLabel.TextSize = 12  -- Smaller text
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)  -- Smaller button
        ToggleButton.Position = UDim2.new(0.85, -25, 0.5, -12.5)
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
            
            if toggleFunc then
                toggleFunc()
            end
        end)

        return ToggleFrame
    end

    -- Compact Button Function
    local function CreateMobileButton(name, callback, color)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)  -- Smaller buttons
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
        ActionButton.Size = UDim2.new(0, 60, 0, 25)
        ActionButton.Position = UDim2.new(0.85, -30, 0.5, -12.5)
        ActionButton.BackgroundColor3 = color or Colors.Accent
        ActionButton.Text = "GO"
        ActionButton.TextColor3 = Colors.Text
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.TextSize = 10
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
        local yOffset = 5
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Position = UDim2.new(0, 0, 0, yOffset)
                yOffset = yOffset + 40  -- Smaller spacing
            end
        end
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
    end

    -- Add mobile-optimized features
    CreateMobileToggle("🪽 Fly", "Fly", ToggleFly)
    CreateMobileToggle("🛡️ God Mode", "GodMode", ToggleGodMode)
    CreateMobileToggle("⚡ Speed", "Speed", ToggleSpeed)
    CreateMobileToggle("🦘 Inf Jump", "InfiniteJump", ToggleInfiniteJump)
    CreateMobileToggle("👻 Noclip", "Noclip", ToggleNoclip)
    CreateMobileToggle("👁️ ESP", "ESP", ToggleESP)
    CreateMobileToggle("🎯 Aimbot", "Aimbot", ToggleAimbot)

    -- Player selection (compact)
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, 0, 0, 60)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = ContentFrame

    local PlayerFrameCorner = Instance.new("UICorner")
    PlayerFrameCorner.CornerRadius = UDim.new(0.08, 0)
    PlayerFrameCorner.Parent = PlayerFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, -10, 0, 20)
    PlayerLabel.Position = UDim2.new(0, 5, 0, 5)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "Target: " .. (BlazixHub.SelectedPlayer or "None")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.Gotham
    PlayerLabel.TextSize = 11
    PlayerLabel.Parent = PlayerFrame

    local SelectButton = Instance.new("TextButton")
    SelectButton.Size = UDim2.new(0.8, 0, 0, 25)
    SelectButton.Position = UDim2.new(0.1, 0, 0, 30)
    SelectButton.BackgroundColor3 = Colors.Accent
    SelectButton.Text = "SELECT PLAYER"
    SelectButton.TextColor3 = Colors.Text
    SelectButton.Font = Enum.Font.GothamBold
    SelectButton.TextSize = 10
    SelectButton.Parent = PlayerFrame

    local SelectButtonCorner = Instance.new("UICorner")
    SelectButtonCorner.CornerRadius = UDim.new(0.15, 0)
    SelectButtonCorner.Parent = SelectButton

    -- Player actions
    CreateMobileButton("📱 TP to Player", function()
        if BlazixHub.SelectedPlayer then
            TeleportToPlayer(BlazixHub.SelectedPlayer)
        end
    end)

    CreateMobileButton("💀 Kill Player", function()
        if BlazixHub.SelectedPlayer then
            KillPlayer(BlazixHub.SelectedPlayer)
        end
    end, Colors.Danger)

    CreateMobileButton("👥 Bring Player", function()
        if BlazixHub.SelectedPlayer then
            BringPlayer(BlazixHub.SelectedPlayer)
        end
    end)

    CreateMobileButton("💥 Kill All", KillAllPlayers, Colors.Danger)

    -- Player selection logic
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

        -- CLOSE BUTTON for player list
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 5)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 14
        CloseBtn.Parent = PlayerList

        local CloseBtnCorner = Instance.new("UICorner")
        CloseBtnCorner.CornerRadius = UDim.new(0.2, 0)
        CloseBtnCorner.Parent = CloseBtn

        local yOffset = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerBtn = Instance.new("TextButton")
                PlayerBtn.Size = UDim2.new(1, -10, 0, 30)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Secondary
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.Gotham
                PlayerBtn.TextSize = 11
                PlayerBtn.Parent = Scroll

                local PlayerBtnCorner = Instance.new("UICorner")
                PlayerBtnCorner.CornerRadius = UDim.new(0.1, 0)
                PlayerBtnCorner.Parent = PlayerBtn

                yOffset = yOffset + 35

                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerLabel.Text = "Target: " .. player.Name
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

    -- CLOSE BUTTON FUNCTIONALITY
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    -- Mobile-friendly dragging
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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

-- INITIALIZE MOBILE VERSION
local success, err = pcall(function()
    local UI = CreateMobileUI()
    print("📱 BLAZIX MOBILE HUB LOADED!")
    print("✅ COMPACT UI READY")
    print("✅ TOUCH CONTROLS ENABLED")
    print("📍 CLICK THE FIRE BUTTON!")
end)

if not success then
    warn("❌ MOBILE LOAD ERROR: " .. tostring(err))
    
    -- Mobile fallback
    local Message = Instance.new("Message")
    Message.Text = "📱 Blazix Mobile - Tap Top-Right Button"
    Message.Parent = Workspace
    delay(4, function() Message:Destroy() end)
end
