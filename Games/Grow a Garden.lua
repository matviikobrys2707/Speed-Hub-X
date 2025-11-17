-- BlazixHub - Lucky Blocks WORKING SCRIPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- WORKING CONFIGURATION
local BlazixHub = {
    Config = {
        ["Fly"] = false,
        ["God Mode"] = false,
        ["Speed Boost"] = false,
        ["Infinite Jump"] = true,
        ["Noclip"] = false,
        ["Auto Farm"] = false
    },
    
    Connections = {},
    Active = true,
    Flying = false,
    FlySpeed = 50
}

-- REAL FLY FUNCTION
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
                end
            end
            BlazixHub.Flying = false
        end
    end)
end

-- REAL GOD MODE
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
        end
    end)
end

-- REAL SPEED BOOST
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

-- REAL INFINITE JUMP
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

-- REAL NOCLIP
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
            -- Find lucky blocks in workspace
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("lucky") or obj.Name:lower():find("block") then
                    if obj:IsA("Part") or obj:IsA("MeshPart") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                        if distance < 20 then
                            -- Teleport to block
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                            
                            -- Click on block (simulate touch)
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

-- START ALL FUNCTIONS
local function StartFunctions()
    EnableFly()
    EnableGodMode()
    EnableSpeedBoost()
    EnableInfiniteJump()
    EnableNoclip()
    
    if BlazixHub.Config["Auto Farm"] then
        spawn(AutoFarmLuckyBlocks)
    end
end

-- CREATE UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Open Menu Button
    local OpenMenuBtn = Instance.new("TextButton")
    OpenMenuBtn.Name = "OpenMenuBtn"
    OpenMenuBtn.Size = UDim2.new(0, 80, 0, 80)
    OpenMenuBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    OpenMenuBtn.Text = "🎮\nBLAZIX"
    OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenMenuBtn.Font = Enum.Font.GothamBold
    OpenMenuBtn.TextSize = 14
    OpenMenuBtn.TextWrapped = true
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

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

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
    TitleLabel.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 2)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = TitleBar

    -- Hide Button
    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(1, -80, 0, 2)
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    HideButton.Text = "▼"
    HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.Font = Enum.Font.GothamBold
    HideButton.TextSize = 16
    HideButton.Parent = TitleBar

    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
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
            
            -- Restart function when toggled
            if configKey == "Fly" then
                EnableFly()
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
            end
        end)
    end

    -- Add working toggles for Lucky Blocks
    CreateWorkingToggle("🪽 Fly", "WASD + Space/Shift to fly", UDim2.new(0, 10, 0, 20), "Fly")
    CreateWorkingToggle("🛡️ God Mode", "Become invincible", UDim2.new(0, 10, 0, 90), "God Mode")
    CreateWorkingToggle("⚡ Speed Boost", "100% movement speed", UDim2.new(0, 10, 0, 160), "Speed Boost")
    CreateWorkingToggle("🦘 Infinite Jump", "Jump infinitely", UDim2.new(0, 10, 0, 230), "Infinite Jump")
    CreateWorkingToggle("👻 Noclip", "Walk through walls", UDim2.new(0, 10, 0, 300), "Noclip")
    CreateWorkingToggle("🎯 Auto Farm", "Auto collect lucky blocks", UDim2.new(0, 10, 0, 370), "Auto Farm")

    -- Controls Info
    local ControlsLabel = Instance.new("TextLabel")
    ControlsLabel.Size = UDim2.new(1, -20, 0, 60)
    ControlsLabel.Position = UDim2.new(0, 10, 0, 440)
    ControlsLabel.BackgroundTransparency = 1
    ControlsLabel.Text = "🎮 CONTROLS:\nFly: WASD + Space/Shift\nAll features work instantly!"
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
        -- Disconnect all connections
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

print("🎮 BLAZIX HUB - LUCKY BLOCKS LOADED!")
print("✅ Fly: W A S D + Space/Shift")
print("✅ God Mode: Invincibility")
print("✅ Speed Boost: 100% speed")
print("✅ Infinite Jump: Unlimited jumps")
print("✅ Noclip: Walk through walls")
print("✅ Auto Farm: Collect lucky blocks")
print("📍 Tap the BLAZIX button to open menu")

warn("BLAZIX HUB FOR LUCKY BLOCKS IS WORKING!")
