-- BlazixHub ULTIMATE WORKING VERSION
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- SIMPLE CONFIG
local BlazixHub = {
    Fly = false,
    GodMode = false,
    Speed = false,
    Jump = false,
    Noclip = false,
    SelectedPlayer = nil
}

-- SIMPLE FLY THAT WORKS
local function ToggleFly()
    BlazixHub.Fly = not BlazixHub.Fly
    
    if BlazixHub.Fly then
        local bodyVelocity = Instance.new("BodyVelocity")
        local bodyGyro = Instance.new("BodyGyro")
        
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        
        bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        bodyGyro.P = 1000
        
        RunService.Heartbeat:Connect(function()
            if BlazixHub.Fly and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    bodyVelocity.Parent = root
                    bodyGyro.Parent = root
                    
                    local cam = workspace.CurrentCamera
                    bodyGyro.CFrame = cam.CFrame
                    
                    local direction = Vector3.new()
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
                    
                    if direction.Magnitude > 0 then
                        bodyVelocity.Velocity = direction.Unit * 50
                    else
                        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            else
                bodyVelocity:Destroy()
                bodyGyro:Destroy()
            end
        end)
    end
end

-- SIMPLE GOD MODE
local function ToggleGodMode()
    BlazixHub.GodMode = not BlazixHub.GodMode
    
    RunService.Heartbeat:Connect(function()
        if BlazixHub.GodMode and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 100
            end
        end
    end)
end

-- SIMPLE SPEED
local function ToggleSpeed()
    BlazixHub.Speed = not BlazixHub.Speed
    
    RunService.Heartbeat:Connect(function()
        if BlazixHub.Speed and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 100
            end
        end
    end)
end

-- SIMPLE INFINITE JUMP
local function ToggleJump()
    BlazixHub.Jump = not BlazixHub.Jump
    
    UserInputService.JumpRequest:Connect(function()
        if BlazixHub.Jump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- SIMPLE NOCLIP
local function ToggleNoclip()
    BlazixHub.Noclip = not BlazixHub.Noclip
    
    RunService.Stepped:Connect(function()
        if BlazixHub.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- SIMPLE TELEPORT TO PLAYER
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

-- SIMPLE KILL PLAYER
local function KillPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

-- SIMPLE BRING PLAYER
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

-- CREATE SIMPLE UI THAT WORKS
local function CreateSimpleUI()
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = CoreGui
    
    -- Open Button
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    OpenBtn.Text = "OPEN"
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    OpenBtn.Parent = ScreenGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    Title.Text = "BLAZIX HUB - WORKING"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = MainFrame
    
    -- Scrolling Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ScrollFrame.Parent = MainFrame
    
    -- Create Simple Toggle
    local function CreateToggle(name, yPos, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
        ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleFrame.Parent = ScrollFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.Font = Enum.Font.GothamBold
        ToggleLabel.TextSize = 14
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
        ToggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        ToggleBtn.Text = "OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.TextSize = 12
        ToggleBtn.Parent = ToggleFrame
        
        ToggleBtn.MouseButton1Click:Connect(function()
            toggleFunc()
            if ToggleBtn.Text == "OFF" then
                ToggleBtn.Text = "ON"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            else
                ToggleBtn.Text = "OFF"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end
        end)
    end
    
    -- Add Toggles
    CreateToggle("Fly", 10, ToggleFly)
    CreateToggle("God Mode", 60, ToggleGodMode)
    CreateToggle("Speed", 110, ToggleSpeed)
    CreateToggle("Infinite Jump", 160, ToggleJump)
    CreateToggle("Noclip", 210, ToggleNoclip)
    
    -- Player Selection
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(1, -20, 0, 120)
    PlayerFrame.Position = UDim2.new(0, 10, 0, 270)
    PlayerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlayerFrame.Parent = ScrollFrame
    
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, 0, 0, 30)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "SELECT PLAYER:"
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 14
    PlayerLabel.Parent = PlayerFrame
    
    local PlayerBtn = Instance.new("TextButton")
    PlayerBtn.Size = UDim2.new(1, -20, 0, 30)
    PlayerBtn.Position = UDim2.new(0, 10, 0, 35)
    PlayerBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    PlayerBtn.Text = "Click to select"
    PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerBtn.Font = Enum.Font.Gotham
    PlayerBtn.TextSize = 12
    PlayerBtn.Parent = PlayerFrame
    
    -- Player Actions
    local function CreatePlayerAction(text, yPos, action, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 25)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = PlayerFrame
        
        btn.MouseButton1Click:Connect(function()
            if BlazixHub.SelectedPlayer then
                action(BlazixHub.SelectedPlayer)
            end
        end)
    end
    
    CreatePlayerAction("TELEPORT TO", 70, TeleportToPlayer, Color3.fromRGB(0, 100, 255))
    CreatePlayerAction("KILL PLAYER", 100, KillPlayer, Color3.fromRGB(255, 50, 50))
    CreatePlayerAction("BRING PLAYER", 130, BringPlayer, Color3.fromRGB(0, 150, 100))
    
    -- Player Selection Logic
    PlayerBtn.MouseButton1Click:Connect(function()
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(1, -20, 0, 150)
        PlayerList.Position = UDim2.new(0, 10, 0, 65)
        PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        PlayerList.Parent = PlayerFrame
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Text = player.Name
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 10
                btn.Parent = PlayerList
                
                btn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerBtn.Text = player.Name
                    PlayerList:Destroy()
                end)
            end
        end
    end)
    
    -- Button Events
    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenBtn.Visible = false
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
    
    return ScreenGui
end

-- INITIALIZE
CreateSimpleUI()

print("✅ BlazixHub loaded successfully!")
print("✅ Simple UI created!")
print("✅ All functions ready!")
print("📍 Click OPEN button to start!")
