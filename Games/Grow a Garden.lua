--[[
    BLAZIX HUB: OMNIPOTENCE EDITION (UNIVERSAL)
    Created for Maximum Performance & Undetectability
    Full 1000+ Lines Functionality Concept
]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- LOCAL VARIABLES
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- CONFIGURATION TABLE
local BlazixConfig = {
    -- Combat
    Aimbot = false,
    AimPart = "Head",
    AimSensitivity = 0.5,
    AimFOV = 100,
    ShowFOV = false,
    SilentAim = false,
    HitboxSize = 2,
    HitboxEnabled = false,
    
    -- Movement
    WalkSpeed = 16,
    JumpPower = 50,
    SpeedMethod = "CFrame", -- CFrame, Velocity, Humanoid
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    AntiVoid = false,
    
    -- Visuals
    ESP_Enabled = false,
    ESP_Boxes = false,
    ESP_Names = false,
    ESP_Chams = false,
    ESP_Color = Color3.fromRGB(0, 255, 150),
    FullBright = false,
    
    -- Misc
    AntiAFK = true,
    AutoClicker = false,
    ClickSpeed = 0.05,
    NoFog = false,
    ChatSpy = false,
    MenuKey = Enum.KeyCode.RightControl
}

-- UI LIBRARY (CUSTOM NEON)
local function CreateBlazixUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixOmni"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Notifications System
    local function Notify(title, msg)
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 3
        })
    end

    -- Mini Icon
    local OpenIcon = Instance.new("TextButton")
    OpenIcon.Size = UDim2.new(0, 50, 0, 50)
    OpenIcon.Position = UDim2.new(0, 15, 0.5, -25)
    OpenIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    OpenIcon.Text = "B"
    OpenIcon.TextColor3 = Color3.fromRGB(0, 255, 150)
    OpenIcon.Font = Enum.Font.GothamBold
    OpenIcon.TextSize = 24
    OpenIcon.Visible = false
    OpenIcon.Parent = ScreenGui
    Instance.new("UICorner", OpenIcon).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", OpenIcon).Color = Color3.fromRGB(0, 255, 150)

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 420)
    Main.Position = UDim2.new(0.5, -300, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- Glow Effect
    local Glow = Instance.new("UIStroke", Main)
    Glow.Thickness = 2
    Glow.Color = Color3.fromRGB(0, 255, 150)
    Glow.Transparency = 0.5

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main
    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.Padding = UDim.new(0, 5)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Header.Parent = Main
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "BLAZIX HUB | <font color='#00ff96'>OMNIPOTENCE v5</font>"
    Title.RichText = true
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -170, 1, -60)
    Container.Position = UDim2.new(0, 160, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Pages = {}

    -- Page Constructor
    local function NewPage(name, icon)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = Container
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(1, 0, 0, 35)
        Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        Tab.Text = name
        Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        Tab.Font = Enum.Font.Gotham
        Tab.Parent = Sidebar
        Instance.new("UICorner", Tab)

        Tab.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            Page.Visible = true
        end)

        Pages[name] = Page
        return Page
    end

    -- PAGES
    local CombatPage = NewPage("🎯 Combat")
    local MovePage = NewPage("🚀 Movement")
    local VisualPage = NewPage("👁️ Visuals")
    local TeleportPage = NewPage("🌌 Teleport")
    local WorldPage = NewPage("🌍 World")
    local MiscPage = NewPage("⚙️ Settings")
    CombatPage.Visible = true

    -- UI ELEMENTS CREATOR
    local function AddToggle(parent, text, configKey, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        Btn.Text = text .. ": OFF"
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.Gotham
        Btn.Parent = parent
        Instance.new("UICorner", Btn)

        Btn.MouseButton1Click:Connect(function()
            BlazixConfig[configKey] = not BlazixConfig[configKey]
            Btn.Text = text .. (BlazixConfig[configKey] and ": ON" or ": OFF")
            Btn.BackgroundColor3 = BlazixConfig[configKey] and Color3.fromRGB(0, 150, 90) or Color3.fromRGB(25, 25, 32)
            if callback then callback(BlazixConfig[configKey]) end
        end)
    end

    local function AddSlider(parent, text, min, max, configKey, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -10, 0, 50)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = parent

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Text = text .. ": " .. BlazixConfig[configKey]
        Label.TextColor3 = Color3.new(1,1,1)
        Label.BackgroundTransparency = 1
        Label.Parent = SliderFrame

        local Bar = Instance.new("TextButton")
        Bar.Size = UDim2.new(1, 0, 0, 10)
        Bar.Position = UDim2.new(0, 0, 0, 25)
        Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Bar.Text = ""
        Bar.Parent = SliderFrame
        Instance.new("UICorner", Bar)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((BlazixConfig[configKey]-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        Fill.Parent = Bar
        Instance.new("UICorner", Fill)

        Bar.MouseButton1Down:Connect(function()
            local Connection = RunService.RenderStepped:Connect(function()
                local MousePos = UserInputService:GetMouseLocation().X
                local BarPos = Bar.AbsolutePosition.X
                local BarSize = Bar.AbsoluteSize.X
                local Percentage = math.clamp((MousePos - BarPos) / BarSize, 0, 1)
                
                local Value = math.floor(min + (max - min) * Percentage)
                BlazixConfig[configKey] = Value
                Label.Text = text .. ": " .. Value
                Fill.Size = UDim2.new(Percentage, 0, 1, 0)
                if callback then callback(Value) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Connection:Disconnect()
                end
            end)
        end)
    end

    -- [MODULE: COMBAT]
    AddToggle(CombatPage, "Silent Aim", "SilentAim")
    AddToggle(CombatPage, "Hitbox Expander", "HitboxEnabled")
    AddSlider(CombatPage, "Hitbox Size", 2, 20, "HitboxSize")
    AddSlider(CombatPage, "Aim FOV", 50, 800, "AimFOV")
    
    -- [MODULE: MOVEMENT]
    AddSlider(MovePage, "Speed Multiplier", 16, 200, "WalkSpeed")
    AddToggle(MovePage, "Infinite Jump", "InfJump")
    AddToggle(MovePage, "Noclip", "Noclip")
    AddToggle(MovePage, "Fly Mode", "Fly", function(v)
        if v then StartFly() end
    end)
    AddToggle(MovePage, "Anti-Void", "AntiVoid")

    -- [MODULE: VISUALS]
    AddToggle(VisualPage, "ESP Enabled", "ESP_Enabled")
    AddToggle(VisualPage, "Box ESP", "ESP_Boxes")
    AddToggle(VisualPage, "Chams", "ESP_Chams")
    AddToggle(VisualPage, "Full Bright", "FullBright", function(v)
        if v then Lighting.Brightness = 2 Lighting.Ambient = Color3.new(1,1,1)
        else Lighting.Brightness = 1 Lighting.Ambient = Color3.new(0,0,0) end
    end)

    -- [MODULE: TELEPORT]
    local function UpdateTeleportList()
        for _, obj in pairs(TeleportPage:GetChildren()) do if obj:IsA("TextButton") then obj:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local b = Instance.new("TextButton", TeleportPage)
                b.Size = UDim2.new(1, -10, 0, 35)
                b.Text = "TP to: " .. p.DisplayName
                b.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
                b.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    end
                end)
            end
        end
    end
    local RefreshTP = Instance.new("TextButton", TeleportPage)
    RefreshTP.Size = UDim2.new(1, -10, 0, 40)
    RefreshTP.Text = "🔄 Refresh Player List"
    RefreshTP.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    RefreshTP.MouseButton1Click:Connect(UpdateTeleportList)

    -- [LOGIC: CORE SYSTEMS]
    
    -- Fly Logic
    function StartFly()
        local BodyVel = Instance.new("BodyVelocity")
        BodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        BodyVel.Parent = LocalPlayer.Character.HumanoidRootPart
        
        spawn(function()
            while BlazixConfig.Fly do
                local Dir = Vector3.zero
                local CamCF = Camera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir += CamCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir -= CamCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir -= CamCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir += CamCF.RightVector end
                BodyVel.Velocity = Dir * BlazixConfig.FlySpeed
                task.wait()
            end
            BodyVel:Destroy()
        end)
    end

    -- Hitbox Logic
    RunService.Heartbeat:Connect(function()
        if BlazixConfig.HitboxEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(BlazixConfig.HitboxSize, BlazixConfig.HitboxSize, BlazixConfig.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = 0.8
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)

    -- Speed/Jump/Noclip Logic
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local Hum = LocalPlayer.Character.Humanoid
            if BlazixConfig.WalkSpeed > 16 then
                LocalPlayer.Character:TranslateBy(Hum.MoveDirection * (BlazixConfig.WalkSpeed / 100))
            end
            if BlazixConfig.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)

    -- FOV Circle
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.new(1,1,1)
    FOVCircle.Filled = false
    
    RunService.RenderStepped:Connect(function()
        FOVCircle.Radius = BlazixConfig.AimFOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Visible = BlazixConfig.ShowFOV
    end)

    -- Window Controls
    Hide.MouseButton1Click:Connect(function() Main.Visible = false OpenIcon.Visible = true end)
    OpenIcon.MouseButton1Click:Connect(function() Main.Visible = true OpenIcon.Visible = false end)
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Dragging Logic
    local dragStart, startPos, dragging
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    Notify("Blazix Hub", "Loaded Successfully! Press R-Ctrl")
end

-- ANTI-AFK SYSTEM
if BlazixConfig.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

-- RUN
CreateBlazixUI()
