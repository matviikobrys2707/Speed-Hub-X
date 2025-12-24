--[[
    BLAZIX HUB V12: TITAN EDITION
    AUTHOR: GEMINI AI (FIXED VERSION)
    • ЛКМ -> Включить функцию
    • ПКМ -> Настройки (Слайдеры)
    • Right Control -> Скрыть/Показать
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
        HttpService = game:GetService("HttpService")
    }
end)

if not success then return end

local Players, RunService, UserInputService, CoreGui, TweenService, Lighting, VirtualInputManager = 
    services.Players, services.RunService, services.UserInputService, services.CoreGui, services.TweenService, services.Lighting, services.VirtualInputManager

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    ESP_Enabled = false, Boxes = false, Chams = false,
    Gravity = 196.2, AntiAFK = true
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

-- [ СОЗДАНИЕ GUI ]
local targetParent = CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = "BlazixTitanV12"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 [cite: 62]

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 900, 0, 650)
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Colors.Accent
Stroke.Thickness = 2

-- Шапка
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0

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
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    
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

local function AddModule(Page, Name, Key, HasSettings, SettingsFunc)
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

    local Tog = Instance.new("Frame", Button)
    Tog.Size = UDim2.new(0, 48, 0, 24)
    Tog.Position = UDim2.new(1, -68, 0.5, -12)
    Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Config[Key] = not Config[Key]
        TweenService:Create(Tog, TweenInfo.new(0.2), {BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
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

-- [ ИНИЦИАЛИЗАЦИЯ ВКЛАДОК ]
local T1 = CreateTab("Combat", "⚔️")
local T2 = CreateTab("Movement", "🏃")

AddModule(T1, "Aimbot", "Aimbot", true, function(f) CreateSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(T2, "Speed", "SpeedEnabled", true, function(f) CreateSlider(f, "Value", 16, 300, "Speed") end)

-- [ ГОРЯЧИЕ КЛАВИШИ ]
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

-- Перетаскивание
local Dragging, DragStart, StartPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = i.Position StartPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
    local Delta = i.Position - DragStart
    Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

Pages["Combat"].P.Visible = true
print("✅ Blazix Titan v12 loaded!")
