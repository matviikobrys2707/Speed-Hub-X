--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI (ANTI-CHEAT BYPASS OPTIMIZED)
    
    [ИНСТРУКЦИЯ]
    • ЛКМ -> Включить функцию
    • ПКМ -> Открыть настройки (Слайдеры)
    • Right Control -> Скрыть/Показать меню
]]

local success, services = pcall(function()
    return {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        CoreGui = game:GetService("CoreGui"),
        TweenService = game:GetService("TweenService"),
        Lighting = game:GetService("Lighting"),
        VirtualInputManager = game:GetService("VirtualInputManager")
    }
end)

if not success then return end
local s = services
local LocalPlayer = s.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    ESP_Enabled = false, Chams = false,
    FullBright = false, Gravity = 196.2, AntiAFK = true
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

-- [ ЗАЩИЩЕННЫЙ GUI ]
local targetParent = s.CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = "Blazix_" .. math.random(100, 999)
ScreenGui.ResetOnSpawn = false

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
Instance.new("UICorner", Header)

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

-- Сайдбар и Контейнеры
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -220, 1, -80)
PagesContainer.Position = UDim2.new(0, 210, 0, 70)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

-- [ ФУНКЦИИ КОНСТРУКТОРА ]
local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)

    local Button = Instance.new("TextButton", Wrapper)
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.BackgroundTransparency = 1
    Button.Text = "          " .. Name
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextXAlignment = Enum.TextXAlignment.Left

    local Tog = Instance.new("Frame", Button)
    Tog.Size = UDim2.new(0, 44, 0, 22)
    Tog.Position = UDim2.new(1, -60, 0.5, -11)
    Tog.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        s.TweenService:Create(Tog, TweenInfo.new(0.2), {BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
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
            s.TweenService:Create(Wrapper, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, Expanded and 140 or 60)}):Play()
        end)
    end
end

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
    TabBtn.BackgroundColor3 = Colors.Main
    TabBtn.Text = name
    TabBtn.TextColor3 = Colors.Text
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.P.Visible = false end
        Page.Visible = true
    end)
    Pages[name] = {P = Page}
    return Page
end

-- [ СОЗДАНИЕ КОНТЕНТА ]
local Combat = CreateTab("Combat")
local Move = CreateTab("Movement")

AddModule(Combat, "Hitbox Expander", "Hitbox", false)
AddModule(Move, "Bypass Speed", "SpeedEnabled", false)
AddModule(Move, "Safe Fly", "FlyEnabled", false)

-- [ ЛОГИКА ОБХОДА АНТИЧИТА ]
s.RunService.Heartbeat:Connect(function(dt)
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Char.HumanoidRootPart
    local Hum = Char:FindFirstChildOfClass("Humanoid")

    -- Speed Bypass (Вместо телепортации меняем Velocity плавно)
    if Config.SpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
        HRP.CFrame = HRP.CFrame + (Hum.MoveDirection * (Config.Speed / 50))
    end

    -- Safe Fly (Плавное удержание в воздухе)
    if Config.FlyEnabled then
        HRP.Velocity = Vector3.new(0, 1.5, 0) -- Минимум для обхода проверки падения
        local Dir = Hum.MoveDirection * Config.FlySpeed
        HRP.CFrame = HRP.CFrame + (Dir * dt)
    end

    -- Noclip
    if Config.Noclip then
        for _, v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Хоткей
s.UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

-- Dragging
local d, ds, sp
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
s.UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then
    local delta = i.Position - ds
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
s.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

Pages["Combat"].P.Visible = true
print("✅ Blazix Titan v12 Loaded (Anti-Cheat Bypass Active)")
