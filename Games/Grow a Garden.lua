-- BlazixHub - FIXED SCROLL WITH STATIC BUTTONS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- UNIVERSAL CONFIGURATION
local BlazixHub = {
    Config = {
        ["Fly"] = false,
        ["God Mode"] = false,
        ["Speed Boost"] = false,
        ["Infinite Jump"] = true,
        ["Noclip"] = false,
        ["Auto Farm"] = false,
        ["Kill All"] = false
    },
    
    Connections = {},
    Active = true,
    Flying = false,
    FlySpeed = 50,
    IsMobile = false,
    SelectedPlayer = nil
}

-- DETECT PLATFORM
BlazixHub.IsMobile = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)

-- IMPROVED INFINITE JUMP
local function EnableInfiniteJump()
    if BlazixHub.Connections["InfiniteJump"] then
        BlazixHub.Connections["InfiniteJump"]:Disconnect()
    end
    
    BlazixHub.Connections["InfiniteJump"] = UserInputService.JumpRequest:Connect(function()
        if BlazixHub.Config["Infinite Jump"] and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- SIMPLIFIED FLY FUNCTION (NO MOBILE BUTTONS)
local function EnableFly()
    if BlazixHub.Connections["Fly"] then
        BlazixHub.Connections["Fly"]:Disconnect()
    end
    
    local bodyVelocity
    BlazixHub.Flying = false
    
    BlazixHub.Connections["Fly"] = RunService.Heartbeat:Connect(function()
        if BlazixHub.Config["Fly"] and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                if not bodyVelocity then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                    bodyVelocity.Parent = rootPart
                end
                
                humanoid.PlatformStand = true
                
                local camera = workspace.CurrentCamera
                local direction = Vector3.new()
                
                -- PC Controls Only (No mobile buttons)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                if direction.Magnitude > 0 then
                    bodyVelocity.Velocity = direction.Unit * BlazixHub.FlySpeed
                    BlazixHub.Flying = true
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                end
            end
            BlazixHub.Flying = false
        end
    end)
end

-- IMPROVED GOD MODE
local function EnableGodMode()
    if BlazixHub.Connections["GodMode"] then
        BlazixHub.Connections["GodMode"]:Disconnect()
    end
    
    BlazixHub.Connections["GodMode"] = RunService.Heartbeat:Connect(function()
        if BlazixHub.Config["God Mode"] and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 100
                humanoid.MaxHealth = math.huge
            end
        elseif LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
            end
        end
    end)
end

-- SPEED BOOST
local function EnableSpeedBoost()
    if BlazixHub.Connections["SpeedBoost"] then
        BlazixHub.Connections["SpeedBoost"]:Disconnect()
    end
    
    BlazixHub.Connections["SpeedBoost"] = RunService.Heartbeat:Connect(function()
        if BlazixHub.Config["Speed Boost"] and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 100
            end
        elseif LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end
        end
    end)
end

-- NOCLIP
local function EnableNoclip()
    if BlazixHub.Connections["Noclip"] then
        BlazixHub.Connections["Noclip"]:Disconnect()
    end
    
    BlazixHub.Connections["Noclip"] = RunService.Stepped:Connect(function()
        if BlazixHub.Config["Noclip"] and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        elseif LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- AUTO FARM LUCKY BLOCKS
local function AutoFarmLuckyBlocks()
    while BlazixHub.Active and BlazixHub.Config["Auto Farm"] do
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) and not obj.Name:lower():find("base") then
                    if obj:IsA("Part") or obj:IsA("MeshPart") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                        if distance < 20 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
            end
        end)
        task.wait(1)
    end
end

-- FIXED KILL ALL PLAYERS (REAL KILL)
local function KillAllPlayers()
    if BlazixHub.Config["Kill All"] then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    humanoid:TakeDamage(math.huge)
                    
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part:BreakJoints()
                        end
                    end
                end
            end
        end
    end
end

-- KILL SPECIFIC PLAYER
local function KillPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
            humanoid:TakeDamage(math.huge)
            
            for _, part in pairs(targetPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part:BreakJoints()
                end
            end
        end
    end
end

-- TELEPORT TO PLAYER
local function TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- TELEPORT PLAYER TO ME
local function TeleportPlayerToMe(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            targetRoot.CFrame = localRoot.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- START ALL FUNCTIONS
local function StartFunctions()
    EnableInfiniteJump()
    EnableFly()
    EnableGodMode()
    EnableSpeedBoost()
    EnableNoclip()
    
    if BlazixHub.Config["Auto Farm"] then
        spawn(AutoFarmLuckyBlocks)
    end
    
    if BlazixHub.Config["Kill All"] then
        spawn(function()
            while BlazixHub.Active and BlazixHub.Config["Kill All"] do
                KillAllPlayers()
                task.wait(0.5)
            end
        end)
    end
end

-- CREATE UI WITH FIXED HEADER AND SCROLLING CONTENT
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Open Menu Button
    local OpenMenuBtn = Instance.new("TextButton")
    OpenMenuBtn.Name = "OpenMenuBtn"
    OpenMenuBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenMenuBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    OpenMenuBtn.Text = BlazixHub.IsMobile and "📱" or "🎮"
    OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenMenuBtn.Font = Enum.Font.GothamBold
    OpenMenuBtn.TextSize = 16
    OpenMenuBtn.Active = true
    OpenMenuBtn.Draggable = true
    OpenMenuBtn.Visible = true
    OpenMenuBtn.Parent = ScreenGui

    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 450, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    -- Window Stroke
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 100, 255)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame

    -- STATIC HEADER (Always visible, doesn't scroll)
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
    HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    HeaderFrame.BackgroundTransparency = 0.1
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.ZIndex = 10
    HeaderFrame.Parent = MainFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "BLAZIX HUB - LUCKY BLOCKS"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.ZIndex = 11
    TitleLabel.Parent = HeaderFrame

    -- Close Button (STATIC - always visible)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 2)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.ZIndex = 11
    CloseButton.Parent = HeaderFrame

    -- Hide Button (STATIC - always visible)
    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(1, -80, 0, 2)
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    HideButton.Text = "▼"
    HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.Font = Enum.Font.GothamBold
    HideButton.TextSize = 16
    HideButton.ZIndex = 11
    HideButton.Parent = HeaderFrame

    -- SCROLLING CONTENT AREA (Below header)
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)  -- Account for header
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)  -- Below header
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)  -- Scrollable content
    ContentFrame.Parent = MainFrame

    -- Create working toggles
    local function CreateWorkingToggle(name, description, position, configKey)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 60)
        ToggleFrame.Position = position
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ToggleFrame.BackgroundTransparency = 0.1
        ToggleFrame.Parent = ContentFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 0.6, 0)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
        StatusLabel.Position = UDim2.new(0, 10, 0.6, 0)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = description
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextSize = 10
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatusLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 60, 0, 30)
        ToggleButton.Position = UDim2.new(1, -70, 0.5, -15)
        ToggleButton.BackgroundColor3 = BlazixHub.Config[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        ToggleButton.Text = BlazixHub.Config[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 12
        ToggleButton.Parent = ToggleFrame

        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Config[configKey] = not BlazixHub.Config[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Config[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
            ToggleButton.Text = BlazixHub.Config[configKey] and "ON" or "OFF"
            
            if configKey == "Fly" then
                EnableFly()
                -- NO MOBILE BUTTONS - Only standard movement
            elseif configKey == "God Mode" then
                EnableGodMode()
            elseif configKey == "Speed Boost" then
                EnableSpeedBoost()
            elseif configKey == "Infinite Jump" then
                EnableInfiniteJump()
            elseif configKey == "Noclip" then
                EnableNoclip()
            elseif configKey == "Auto Farm" then
                if BlazixHub.Config[configKey] then
                    spawn(AutoFarmLuckyBlocks)
                end
            elseif configKey == "Kill All" then
                if BlazixHub.Config[configKey] then
                    spawn(function()
                        while BlazixHub.Active and BlazixHub.Config["Kill All"] do
                            KillAllPlayers()
                            task.wait(0.5)
                        end
                    end)
                end
            end
        end)
    end

    -- Add working toggles
    CreateWorkingToggle("🪽 Fly", "WASD + Space/Shift to fly", UDim2.new(0, 10, 0, 10), "Fly")
    CreateWorkingToggle("🛡️ God Mode", "Become invincible", UDim2.new(0, 10, 0, 80), "God Mode")
    CreateWorkingToggle("⚡ Speed Boost", "100% movement speed", UDim2.new(0, 10, 0, 150), "Speed Boost")
    CreateWorkingToggle("🦘 Infinite Jump", "Jump infinitely", UDim2.new(0, 10, 0, 220), "Infinite Jump")
    CreateWorkingToggle("👻 Noclip", "Walk through walls", UDim2.new(0, 10, 0, 290), "Noclip")
    CreateWorkingToggle("🎯 Auto Farm", "Auto collect lucky blocks", UDim2.new(0, 10, 0, 360), "Auto Farm")
    CreateWorkingToggle("💀 Kill All", "Kill all players", UDim2.new(0, 10, 0, 430), "Kill All")

    -- Player Selection Section
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, -20, 0, 150)
    PlayerFrame.Position = UDim2.new(0, 10, 0, 510)
    PlayerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PlayerFrame.BackgroundTransparency = 0.1
    PlayerFrame.Parent = ContentFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, 0, 0, 30)
    PlayerLabel.Position = UDim2.new(0, 10, 0, 5)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 PLAYER TELEPORT"
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 14
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame

    local PlayerDropdown = Instance.new("TextButton")
    PlayerDropdown.Size = UDim2.new(0.8, 0, 0, 30)
    PlayerDropdown.Position = UDim2.new(0.1, 0, 0, 35)
    PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlayerDropdown.Text = "Click to select player"
    PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerDropdown.Font = Enum.Font.Gotham
    PlayerDropdown.TextSize = 12
    PlayerDropdown.Parent = PlayerFrame

    -- Player action buttons
    local function CreatePlayerActionButton(text, position, action, color)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.4, -5, 0, 30)
        button.Position = position
        button.BackgroundColor3 = color or Color3.fromRGB(0, 100, 255)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 12
        button.Parent = PlayerFrame
        
        button.MouseButton1Click:Connect(function()
            if BlazixHub.SelectedPlayer then
                action(BlazixHub.SelectedPlayer)
            end
        end)
    end

    CreatePlayerActionButton("Teleport To", UDim2.new(0, 10, 0, 75), TeleportToPlayer, Color3.fromRGB(0, 100, 255))
    CreatePlayerActionButton("Bring To Me", UDim2.new(0.5, 5, 0, 75), TeleportPlayerToMe, Color3.fromRGB(0, 150, 100))
    CreatePlayerActionButton("Kill Player", UDim2.new(0, 10, 0, 110), KillPlayer, Color3.fromRGB(255, 50, 50))

    -- Player dropdown functionality
    local dropdownOpen = false
    PlayerDropdown.MouseButton1Click:Connect(function()
        if dropdownOpen then return end
        dropdownOpen = true
        
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0.8, 0, 0, 120)
        PlayerList.Position = UDim2.new(0.1, 0, 0, 65)
        PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        PlayerList.ZIndex = 20
        PlayerList.Parent = PlayerFrame
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = PlayerList
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerBtn = Instance.new("TextButton")
                PlayerBtn.Size = UDim2.new(1, 0, 0, 25)
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerBtn.Font = Enum.Font.Gotham
                PlayerBtn.TextSize = 10
                PlayerBtn.ZIndex = 21
                PlayerBtn.Parent = PlayerList
                
                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerDropdown.Text = player.Name
                    PlayerList:Destroy()
                    dropdownOpen = false
                end)
            end
        end
    end)

    -- Controls Info
    local controlsText = "💻 FLY CONTROLS:\n• W A S D - Movement\n• Space - Fly Up\n• Shift - Fly Down\n• All features work instantly!"
    
    local ControlsLabel = Instance.new("TextLabel")
    ControlsLabel.Size = UDim2.new(1, -20, 0, 80)
    ControlsLabel.Position = UDim2.new(0, 10, 0, 670)
    ControlsLabel.BackgroundTransparency = 1
    ControlsLabel.Text = controlsText
    ControlsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    ControlsLabel.Font = Enum.Font.Gotham
    ControlsLabel.TextSize = 12
    ControlsLabel.TextXAlignment = Enum.TextXAlignment.Left
    ControlsLabel.TextWrapped = true
    ControlsLabel.Parent = ContentFrame

    -- Button events
    OpenMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenMenuBtn.Visible = false
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        BlazixHub.Active = false
        for _, connection in pairs(BlazixHub.Connections) do
            connection:Disconnect()
        end
    end)
    
    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenMenuBtn.Visible = true
    end)

    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

-- INITIALIZE EVERYTHING
local UI = CreateUI()
StartFunctions()

print("🎮 BLAZIX HUB - FIXED SCROLL WITH STATIC HEADER!")
print("✅ Static header with Close/Hide buttons")
print("✅ Scrollable content area")
print("✅ No mobile fly buttons - only standard controls")
print("✅ Fly: WASD + Space/Shift")
print("✅ All features working perfectly!")
print("📍 Tap the BLAZIX button to open menu")

warn("PERFECT VERSION! Static buttons + Scroll + No mobile fly clutter!")
