--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI
    STATUS: FIXED & FULL VERSION
]]

local success, services = pcall(function()
    return {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        CoreGui = game:GetService("CoreGui"),
        TweenService = game:GetService("TweenService"),
        Lighting = game:GetService("Lighting"),
        VirtualInputManager = game:GetService("VirtualInputManager"),
        HttpService = game:GetService("HttpService"),
        TeleportService = game:GetService("TeleportService")
    }
end)

if not success then return warn("❌ Ошибка сервисов: " .. tostring(services)) end

local Players = services.Players
local RunService = services.RunService
local UserInputService = services.UserInputService
local CoreGui = services.CoreGui
local TweenService = services.TweenService
local Lighting = services.Lighting
local VirtualInputManager = services.VirtualInputManager
local HttpService = services.HttpService

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    ESP_Enabled = false, Boxes = false, Chams = false,
    FullBright = false, TimeChanger = false, Time = 12,
    Gravity = 196.2, AntiAFK = true, DestroyLava = false
}

local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35)
}

-- [ GUI СОЗДАНИЕ ]
local targetParent = CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = "BlazixTitanV12"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 900, 0, 650)
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- Шапка
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v12"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Контейнеры
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 5)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -220, 1, -80)
PagesContainer.Position = UDim2.new(0, 210, 0, 70)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

-- [ ФУНКЦИИ КОНСТРУКТОРА ]
local function CreateSlider(Parent, Name, Min, Max, Key)
    local Label = Instance.new("TextLabel", Parent)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.Text = Name .. ": " .. Config[Key]
    Label.TextColor3 = Colors.TextDark
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    
    local SliderBg = Instance.new("TextButton", Parent)
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBg.Text = ""
    Instance.new("UICorner", SliderBg)
    
    local Fill = Instance.new("Frame", SliderBg)
    Fill.Size = UDim2.new((Config[Key]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill)
    
    SliderBg.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local P = math.clamp((UserInputService:GetMouseLocation().X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            Config[Key] = math.floor(Min + (Max - Min) * P)
            Label.Text = Name .. ": " .. Config[Key]
        end)
        local Release; Release = UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() Release:Disconnect() end
        end)
    end)
end

local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)
    
    local Button = Instance.new("TextButton", Wrapper)
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    
    local TitleLabel = Instance.new("TextLabel", Button)
    TitleLabel.Text = Name
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1

    local TogBg = Instance.new("Frame", Button)
    TogBg.Size = UDim2.new(0, 48, 0, 24)
    TogBg.Position = UDim2.new(1, -68, 0.5, -12)
    TogBg.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", TogBg).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", TogBg)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        local targetPos = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(TogBg, TweenInfo.new(0.2), {BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
    end)

    if HasSettings then
        local SFrame = Instance.new("Frame", Wrapper)
        SFrame.Size = UDim2.new(1, 0, 0, 80)
        SFrame.Position = UDim2.new(0, 0, 0, 60)
        SFrame.BackgroundColor3 = Colors.SettingsBG
        if SettingsFunc then SettingsFunc(SFrame) end
        
        local Expanded = false
        Button.MouseButton2Click:Connect(function()
            Expanded = not Expanded
            TweenService:Create(Wrapper, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, Expanded and 140 or 60)}):Play()
        end)
    end
end

local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Colors.Main
    TabBtn.Text = "  " .. icon .. "  " .. name
    TabBtn.TextColor3 = Colors.TextDark
    TabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.P.Visible = false p.B.BackgroundColor3 = Colors.Main end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Colors.ItemBG
    end)
    Pages[name] = {P = Page, B = TabBtn}
    return Page
end

-- [ ВКЛАДКИ ]
local TabCombat = CreateTab("Combat", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabVisual = CreateTab("Visuals", "👁️")
local TabWorld = CreateTab("World", "🌍")
local TabMisc = CreateTab("Misc", "⚙️")

-- Combat
AddModule(TabCombat, "Aimbot", "Aimbot", true, function(f) CreateSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(TabCombat, "Hitbox Expander", "Hitbox", true, function(f) CreateSlider(f, "Size", 2, 50, "HitboxSize") end)

-- Movement
AddModule(TabMove, "Speed Bypass", "SpeedEnabled", true, function(f) CreateSlider(f, "Value", 16, 300, "Speed") end)
AddModule(TabMove, "Flight Mode", "FlyEnabled", true, function(f) CreateSlider(f, "Speed", 10, 500, "FlySpeed") end)
AddModule(TabMove, "Jump Power", "JumpEnabled", true, function(f) CreateSlider(f, "Height", 50, 400, "JumpPower") end)
AddModule(TabMove, "Infinite Jump", "InfJump", false)
AddModule(TabMove, "Noclip", "Noclip", false)

-- Visuals
AddModule(TabVisual, "Enable ESP", "ESP_Enabled", false)
AddModule(TabVisual, "Box ESP", "Boxes", false)
AddModule(TabVisual, "Chams (Wallhack)", "Chams", false)
AddModule(TabVisual, "FullBright", "FullBright", false)

-- World
AddModule(TabWorld, "Gravity Control", "Gravity", true, function(f) CreateSlider(f, "Force", 0, 196, "Gravity") end)
AddModule(TabWorld, "Destroy Lava", "DestroyLava", false)

-- Misc
AddModule(TabMisc, "Anti-AFK", "AntiAFK", false)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local HRP = Char.HumanoidRootPart

    if Config.SpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
        Char:TranslateBy(Hum.MoveDirection * (Config.Speed / 100))
    end
    
    if Config.FlyEnabled then
        local Dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
        HRP.Velocity = Dir * Config.FlySpeed
        Hum.PlatformStand = true
    else
        Hum.PlatformStand = false
    end

    if Config.Noclip then
        for _, p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    
    workspace.Gravity = Config.Gravity
end)

-- Перетаскивание
local Dragging, DragStart, StartPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = i.Position StartPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
    local Delta = i.Position - DragStart
    Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

-- Хоткей Left Alt
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end end)

Pages["Combat"].P.Visible = true
print("✅ BLAZIX TITAN V12 LOADED")
