--[[
    BLAZIX HUB V12: TITAN EDITION
    ПОЛНАЯ ИСПРАВЛЕННАЯ ВЕРСИЯ
    • ЛКМ -> Вкл/Выкл
    • ПКМ -> Настройки (Слайдеры)
    • Left Alt -> Скрыть/Показать меню
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
    Hitbox = false, HitboxSize = 2,
    ESP_Enabled = false, Boxes = false, Chams = false,
    FullBright = false, TimeChanger = false, Time = 12,
    Gravity = 196.2, AntiAFK = true, DestroyLava = false
}

local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35)
}

-- [ GUI ]
local ScreenGui = Instance.new("ScreenGui", CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui"))
ScreenGui.Name = "BlazixTitanV12"
ScreenGui.DisplayOrder = 999999

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 900, 0, 650)
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Colors.Accent

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Header)

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

-- [ КОНСТРУКТОРЫ ]
local function CreateSlider(Parent, Name, Min, Max, Key)
    local Label = Instance.new("TextLabel", Parent)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.Text = Name .. ": " .. Config[Key]
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    
    local SliderBg = Instance.new("TextButton", Parent)
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBg.Text = ""
    
    local Fill = Instance.new("Frame", SliderBg)
    Fill.Size = UDim2.new((Config[Key]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    
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
    Button.Text = "          " .. Name
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextXAlignment = Enum.TextXAlignment.Left

    local Tog = Instance.new("Frame", Button)
    Tog.Size = UDim2.new(0, 40, 0, 20)
    Tog.Position = UDim2.new(1, -60, 0.5, -10)
    Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Config[Key] = not Config[Key]
        Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
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

local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
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

-- [ НАПОЛНЕНИЕ ]
local Combat = CreateTab("Combat")
local Movement = CreateTab("Movement")
local Visuals = CreateTab("Visuals")
local World = CreateTab("World")

AddModule(Combat, "Aimbot", "Aimbot", true, function(f) CreateSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(Movement, "Speed", "SpeedEnabled", true, function(f) CreateSlider(f, "Value", 16, 250, "Speed") end)
AddModule(Movement, "Fly", "FlyEnabled", true, function(f) CreateSlider(f, "Speed", 10, 300, "FlySpeed") end)
AddModule(Visuals, "ESP Box", "Boxes", false)
AddModule(World, "Gravity", "Gravity", true, function(f) CreateSlider(f, "Force", 0, 200, "Gravity") end)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    
    if Config.SpeedEnabled and Hum.MoveDirection.Magnitude > 0 then
        Char:TranslateBy(Hum.MoveDirection * (Config.Speed / 100))
    end
    
    if Config.FlyEnabled then
        Char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) -- Простейший анти-гравити флай
    end
    
    workspace.Gravity = Config.Gravity [cite: 92]
end)

-- Хоткей
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end [cite: 80]
end)

Pages["Combat"].P.Visible = true
print("✅ BLAZIX TITAN V12 LOADED")
