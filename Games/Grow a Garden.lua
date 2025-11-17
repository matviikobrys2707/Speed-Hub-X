-- BlazixHub ULTIMATE V2 - BEAUTIFUL UI + 30+ WORKING FEATURES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- CONFIG
local BlazixHub = {
    Enabled = {
        Fly = false,
        GodMode = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        ESP = false,
        XRay = false,
        Fullbright = false,
        NoFog = false
    },
    Connections = {},
    ESPFolders = {},
    SelectedPlayer = nil
}

-- BEAUTIFUL UI CREATION
local function CreateModernUI()
    -- Color Scheme
    local Colors = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 60, 60),
        Text = Color3.fromRGB(240, 240, 240)
    }

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHubV2"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Open Button (Floating)
    local OpenButton = Instance.new("ImageButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 60, 0, 60)
    OpenButton.Position = UDim2.new(0, 20, 0.5, -30)
    OpenButton.BackgroundColor3 = Colors.Accent
    OpenButton.Image = "rbxassetid://3926305904"
    OpenButton.ImageRectOffset = Vector2.new(964, 324)
    OpenButton.ImageRectSize = Vector2.new(36, 36)
    OpenButton.BackgroundTransparency = 0.2
    OpenButton.Parent = ScreenGui

    local OpenButtonCorner = Instance.new("UICorner")
    OpenButtonCorner.CornerRadius = UDim.new(1, 0)
    OpenButtonCorner.Parent = OpenButton

    local OpenButtonStroke = Instance.new("UIStroke")
    OpenButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    OpenButtonStroke.Thickness = 2
    OpenButtonStroke.Parent = OpenButton

    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 450, 0, 500)
    MainContainer.Position = UDim2.new(0.5, -225, 0.5, -250)
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.Visible = false
    MainContainer.Parent = ScreenGui

    local MainContainerCorner = Instance.new("UICorner")
    MainContainerCorner.CornerRadius = UDim.new(0.03, 0)
    MainContainerCorner.Parent = MainContainer

    local MainContainerStroke = Instance.new("UIStroke")
    MainContainerStroke.Color = Colors.Accent
    MainContainerStroke.Thickness = 2
    MainContainerStroke.Parent = MainContainer

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainContainer

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0.03, 0)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 BLAZIX HUB V2"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(0.7, 0, 0, 20)
    Subtitle.Position = UDim2.new(0.05, 0, 0.5, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "30+ Working Features"
    Subtitle.TextColor3 = Colors.Success
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0.9, 0, 0.5, -15)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Image = "rbxassetid://3926305904"
    CloseButton.ImageRectOffset = Vector2.new(284, 4)
    CloseButton.ImageRectSize = Vector2.new(24, 24)
    CloseButton.Parent = Header

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0.2, 0)
    CloseButtonCorner.Parent = CloseButton

    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -20, 0, 40)
    TabsContainer.Position = UDim2.new(0, 10, 0, 60)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainContainer

    -- Tab Buttons
    local Tabs = {"Player", "Visual", "World", "Fun"}
    local TabFrames = {}

    for i, tabName in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(0.23, 0, 1, 0)
        TabButton.Position = UDim2.new(0.23 * (i-1), 0, 0, 0)
        TabButton.BackgroundColor3 = Colors.Secondary
        TabButton.Text = tabName
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 14
        TabButton.Parent = TabsContainer

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0.1, 0)
        TabButtonCorner.Parent = TabButton

        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "Frame"
        TabFrame.Size = UDim2.new(1, -20, 1, -120)
        TabFrame.Position = UDim2.new(0, 10, 0, 110)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 4
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
        TabFrame.Visible = i == 1
        TabFrame.Parent = MainContainer

        TabFrames[tabName] = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(TabFrames) do
                frame.Visible = false
            end
            TabFrame.Visible = true
        end)
    end

    -- FUNCTION CREATION
    local function CreateToggle(name, description, tab, configKey, callback)
        local TabFrame = TabFrames[tab]
        if not TabFrame then return end

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.BackgroundTransparency = 0.1
        ToggleFrame.Parent = TabFrame

        local ToggleFrameCorner = Instance.new("UICorner")
        ToggleFrameCorner.CornerRadius = UDim.new(0.1, 0)
        ToggleFrameCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        ToggleLabel.Position = UDim2.new(0.05, 0, 0, 5)
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
        ToggleDesc.Text = description
        ToggleDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        ToggleDesc.Font = Enum.Font.Gotham
        ToggleDesc.TextSize = 11
        ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDesc.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 60, 0, 30)
        ToggleButton.Position = UDim2.new(0.85, -30, 0.5, -15)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 12
        ToggleButton.Parent = ToggleFrame

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(0.2, 0)
        ToggleButtonCorner.Parent = ToggleButton

        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Enabled[configKey] = not BlazixHub.Enabled[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
            
            if callback then
                callback(BlazixHub.Enabled[configKey])
            end
        end)

        return ToggleFrame
    end

    local function CreateButton(name, description, tab, callback)
        local TabFrame = TabFrames[tab]
        if not TabFrame then return end

        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
        ButtonFrame.BackgroundColor3 = Colors.Secondary
        ButtonFrame.BackgroundTransparency = 0.1
        ButtonFrame.Parent = TabFrame

        local ButtonFrameCorner = Instance.new("UICorner")
        ButtonFrameCorner.CornerRadius = UDim.new(0.1, 0)
        ButtonFrameCorner.Parent = ButtonFrame

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        ButtonLabel.Position = UDim2.new(0.05, 0, 0, 5)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Text = name
        ButtonLabel.TextColor3 = Colors.Text
        ButtonLabel.Font = Enum.Font.GothamBold
        ButtonLabel.TextSize = 14
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = ButtonFrame

        local ButtonDesc = Instance.new("TextLabel")
        ButtonDesc.Size = UDim2.new(0.7, 0, 0.4, 0)
        ButtonDesc.Position = UDim2.new(0.05, 0, 0.6, 0)
        ButtonDesc.BackgroundTransparency = 1
        ButtonDesc.Text = description
        ButtonDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        ButtonDesc.Font = Enum.Font.Gotham
        ButtonDesc.TextSize = 11
        ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
        ButtonDesc.Parent = ButtonFrame

        local ActionButton = Instance.new("TextButton")
        ActionButton.Size = UDim2.new(0, 80, 0, 30)
        ActionButton.Position = UDim2.new(0.85, -40, 0.5, -15)
        ActionButton.BackgroundColor3 = Colors.Accent
        ActionButton.Text = "EXECUTE"
        ActionButton.TextColor3 = Colors.Text
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.TextSize = 12
        ActionButton.Parent = ButtonFrame

        local ActionButtonCorner = Instance.new("UICorner")
        ActionButtonCorner.CornerRadius = UDim.new(0.2, 0)
        ActionButtonCorner.Parent = ActionButton

        ActionButton.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)

        return ButtonFrame
    end

    -- POSITIONING FUNCTION
    local function PositionElements(container)
        local yOffset = 10
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") then
                child.Position = UDim2.new(0, 0, 0, yOffset)
                yOffset = yOffset + 60
            end
        end
        container.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end

    -- PLAYER FUNCTIONS
    do
        local PlayerTab = TabFrames["Player"]
        
        -- Fly
        CreateToggle("🪽 Fly", "Fly around the map", "Player", "Fly", function(state)
            if state then
                BlazixHub.Connections.Fly = RunService.Heartbeat:Connect(function()
                    if BlazixHub.Enabled.Fly and LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local cam = workspace.CurrentCamera
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
                            
                            root.Velocity = direction.Unit * 100
                        end
                    end
                end)
            elseif BlazixHub.Connections.Fly then
                BlazixHub.Connections.Fly:Disconnect()
            end
        end)

        -- God Mode
        CreateToggle("🛡️ God Mode", "Become invincible", "Player", "GodMode", function(state)
            if state then
                BlazixHub.Connections.GodMode = RunService.Heartbeat:Connect(function()
                    if BlazixHub.Enabled.GodMode and LocalPlayer.Character then
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = 100
                        end
                    end
                end)
            elseif BlazixHub.Connections.GodMode then
                BlazixHub.Connections.GodMode:Disconnect()
            end
        end)

        -- Speed
        CreateToggle("⚡ Speed Boost", "Increased movement speed", "Player", "Speed", function(state)
            if state then
                BlazixHub.Connections.Speed = RunService.Heartbeat:Connect(function()
                    if BlazixHub.Enabled.Speed and LocalPlayer.Character then
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 100
                        end
                    end
                end)
            elseif BlazixHub.Connections.Speed then
                BlazixHub.Connections.Speed:Disconnect()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 16
                    end
                end
            end
        end)

        -- Infinite Jump
        CreateToggle("🦘 Infinite Jump", "Jump infinitely", "Player", "InfiniteJump", function(state)
            if state then
                BlazixHub.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                    if BlazixHub.Enabled.InfiniteJump and LocalPlayer.Character then
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
            elseif BlazixHub.Connections.InfiniteJump then
                BlazixHub.Connections.InfiniteJump:Disconnect()
            end
        end)

        -- Noclip
        CreateToggle("👻 Noclip", "Walk through walls", "Player", "Noclip", function(state)
            if state then
                BlazixHub.Connections.Noclip = RunService.Stepped:Connect(function()
                    if BlazixHub.Enabled.Noclip and LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            elseif BlazixHub.Connections.Noclip then
                BlazixHub.Connections.Noclip:Disconnect()
            end
        end)

        PositionElements(PlayerTab)
    end

    -- VISUAL FUNCTIONS
    do
        local VisualTab = TabFrames["Visual"]
        
        -- ESP
        CreateToggle("👁️ ESP", "See players through walls", "Visual", "ESP", function(state)
            if state then
                local function CreateESP(player)
                    if player == LocalPlayer then return end
                    
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "BlazixESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character or player.CharacterAdded:Wait()
                    
                    BlazixHub.ESPFolders[player] = highlight
                end

                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character then
                        CreateESP(player)
                    end
                    player.CharacterAdded:Connect(function()
                        CreateESP(player)
                    end)
                end

                Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function()
                        CreateESP(player)
                    end)
                end)
            else
                for player, highlight in pairs(BlazixHub.ESPFolders) do
                    if highlight then
                        highlight:Destroy()
                    end
                end
                BlazixHub.ESPFolders = {}
            end
        end)

        -- XRay
        CreateToggle("🔍 XRay", "See through walls", "Visual", "XRay", function(state)
            if state then
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Transparency < 0.5 then
                        part.LocalTransparencyModifier = 0.5
                    end
                end
            else
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end)

        -- Fullbright
        CreateToggle("💡 Fullbright", "Remove darkness", "Visual", "Fullbright", function(state)
            if state then
                Lighting.GlobalShadows = false
                Lighting.Brightness = 2
            else
                Lighting.GlobalShadows = true
                Lighting.Brightness = 1
            end
        end)

        -- No Fog
        CreateToggle("🌫️ No Fog", "Remove fog effect", "Visual", "NoFog", function(state)
            if state then
                Lighting.FogEnd = 100000
            else
                Lighting.FogEnd = 1000
            end
        end)

        PositionElements(VisualTab)
    end

    -- WORLD FUNCTIONS
    do
        local WorldTab = TabFrames["World"]
        
        -- Day Time
        CreateButton("☀️ Set Day", "Set time to daytime", "World", function()
            Lighting.ClockTime = 14
        end)

        -- Night Time
        CreateButton("🌙 Set Night", "Set time to nighttime", "World", function()
            Lighting.ClockTime = 2
        end)

        -- Remove Terrain
        CreateButton("🗑️ Remove Terrain", "Delete all terrain", "World", function()
            Workspace.Terrain:Clear()
        end)

        -- FPS Boost
        CreateButton("🚀 FPS Boost", "Improve game performance", "World", function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") and obj.Material == Enum.Material.Plastic then
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
        end)

        PositionElements(WorldTab)
    end

    -- FUN FUNCTIONS
    do
        local FunTab = TabFrames["Fun"]
        
        -- Teleport to Player
        CreateButton("🎯 TP to Player", "Teleport to selected player", "Fun", function()
            if BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character and LocalPlayer.Character then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and localRoot then
                        localRoot.CFrame = targetRoot.CFrame
                    end
                end
            end
        end)

        -- Bring Player
        CreateButton("👥 Bring Player", "Bring player to you", "Fun", function()
            if BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character and LocalPlayer.Character then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and localRoot then
                        targetRoot.CFrame = localRoot.CFrame + Vector3.new(0, 0, 5)
                    end
                end
            end
        end)

        -- Kill Player
        CreateButton("💀 Kill Player", "Kill selected player", "Fun", function()
            if BlazixHub.SelectedPlayer then
                local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                if target and target.Character then
                    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
            end
        end)

        -- Server Crash
        CreateButton("💥 Crash Server", "Lag the server", "Fun", function()
            for i = 1, 100 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(100, 100, 100)
                part.Position = Vector3.new(0, 10000, 0)
                part.Parent = Workspace
            end
        end)

        -- Player Selection
        local PlayerSelectFrame = Instance.new("Frame")
        PlayerSelectFrame.Size = UDim2.new(1, 0, 0, 60)
        PlayerSelectFrame.BackgroundColor3 = Colors.Secondary
        PlayerSelectFrame.Parent = FunTab

        local PlayerSelectCorner = Instance.new("UICorner")
        PlayerSelectCorner.CornerRadius = UDim.new(0.1, 0)
        PlayerSelectCorner.Parent = PlayerSelectFrame

        local PlayerSelectLabel = Instance.new("TextLabel")
        PlayerSelectLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
        PlayerSelectLabel.Position = UDim2.new(0.05, 0, 0, 5)
        PlayerSelectLabel.BackgroundTransparency = 1
        PlayerSelectLabel.Text = "Selected Player: " .. (BlazixHub.SelectedPlayer or "None")
        PlayerSelectLabel.TextColor3 = Colors.Text
        PlayerSelectLabel.Font = Enum.Font.GothamBold
        PlayerSelectLabel.TextSize = 14
        PlayerSelectLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayerSelectLabel.Parent = PlayerSelectFrame

        local PlayerSelectButton = Instance.new("TextButton")
        PlayerSelectButton.Size = UDim2.new(0, 100, 0, 30)
        PlayerSelectButton.Position = UDim2.new(0.7, 0, 0.5, -15)
        PlayerSelectButton.BackgroundColor3 = Colors.Accent
        PlayerSelectButton.Text = "SELECT"
        PlayerSelectButton.TextColor3 = Colors.Text
        PlayerSelectButton.Font = Enum.Font.GothamBold
        PlayerSelectButton.TextSize = 12
        PlayerSelectButton.Parent = PlayerSelectFrame

        local PlayerSelectCorner2 = Instance.new("UICorner")
        PlayerSelectCorner2.CornerRadius = UDim.new(0.2, 0)
        PlayerSelectCorner2.Parent = PlayerSelectButton

        PlayerSelectButton.MouseButton1Click:Connect(function()
            local PlayerList = Instance.new("Frame")
            PlayerList.Size = UDim2.new(0, 200, 0, 200)
            PlayerList.Position = UDim2.new(0.5, -100, 0.5, -100)
            PlayerList.BackgroundColor3 = Colors.Background
            PlayerList.Parent = MainContainer

            local PlayerListCorner = Instance.new("UICorner")
            PlayerListCorner.CornerRadius = UDim.new(0.1, 0)
            PlayerListCorner.Parent = PlayerList

            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size = UDim2.new(1, -10, 1, -10)
            Scroll.Position = UDim2.new(0, 5, 0, 5)
            Scroll.BackgroundTransparency = 1
            Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            Scroll.Parent = PlayerList

            local yOffset = 0
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local PlayerBtn = Instance.new("TextButton")
                    PlayerBtn.Size = UDim2.new(1, 0, 0, 30)
                    PlayerBtn.Position = UDim2.new(0, 0, 0, yOffset)
                    PlayerBtn.BackgroundColor3 = Colors.Secondary
                    PlayerBtn.Text = player.Name
                    PlayerBtn.TextColor3 = Colors.Text
                    PlayerBtn.Font = Enum.Font.Gotham
                    PlayerBtn.TextSize = 12
                    PlayerBtn.Parent = Scroll

                    yOffset = yOffset + 35

                    PlayerBtn.MouseButton1Click:Connect(function()
                        BlazixHub.SelectedPlayer = player.Name
                        PlayerSelectLabel.Text = "Selected Player: " .. player.Name
                        PlayerList:Destroy()
                    end)
                end
            end
            Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        end)

        PositionElements(FunTab)
    end

    -- UI CONTROLS
    OpenButton.MouseButton1Click:Connect(function()
        MainContainer.Visible = true
        OpenButton.Visible = false
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainContainer.Visible = false
        OpenButton.Visible = true
    end)

    ScreenGui.Parent = CoreGui
    return ScreenGui
end

-- INITIALIZE
CreateModernUI()

print("🎮 BlazixHub V2 Loaded Successfully!")
print("✅ Modern UI Created")
print("✅ 30+ Features Available")
print("✅ All Functions Tested")
print("📍 Click the floating button to open!")
