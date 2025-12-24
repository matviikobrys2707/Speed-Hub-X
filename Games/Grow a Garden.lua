--[[
    BLAZIX HUB V12: TITAN EDITION (STABLE)
    [ИНСТРУКЦИЯ]
    • ЛКМ -> Вкл/Выкл
    • ПКМ -> Настройки (Слайдеры)
    • Right Control -> Скрыть/Показать
    • КРЕСТИК -> Полное удаление
]]

-- Защищённое получение сервисов
local function getService(name)
    local s, res = pcall(function() return game:GetService(name) end)
    return s and res or nil
end

local Players = getService("Players")
local RunService = getService("RunService")
local UserInputService = getService("UserInputService")
local CoreGui = getService("CoreGui")
local TweenService = getService("TweenService")
local Lighting = getService("Lighting")
local VirtualInputManager = getService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Определяем, куда вставлять GUI (защита от краша)
local targetParent = CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    BunnyHop = false, SpinBot = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    AutoClicker = false, ClickDelay = 0.1,
    ESP_Enabled = false, Chams = false, FullBright = false,
    Gravity = 196.2, TimeChanger = false, Time = 12,
    AntiAFK = true
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
local success, err = pcall(function()
    if targetParent:FindFirstChild("BlazixTitan") then targetParent.BlazixTitan:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui", targetParent)
    ScreenGui.Name = "BlazixTitan"
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

    -- [ ШАПКА С КНОПКОЙ ЗАКРЫТЬ ]
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Colors.Sidebar
    
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
    Instance.new("UICorner", CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- [ САЙДБАР И СТРАНИЦЫ ]
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 200, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundColor3 = Colors.Sidebar

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PagesContainer = Instance.new("Frame", Main)
    PagesContainer.Size = UDim2.new(1, -220, 1, -80)
    PagesContainer.Position = UDim2.new(0, 210, 0, 70)
    PagesContainer.BackgroundTransparency = 1

    local Pages = {}

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

    -- [ ФУНКЦИИ ]
    local function AddModule(Page, Name, Key, HasSet, SetFunc)
        local Wrapper = Instance.new("Frame", Page)
        Wrapper.Size = UDim2.new(1, -10, 0, 60)
        Wrapper.BackgroundColor3 = Colors.ItemBG
        Wrapper.ClipsDescendants = true
        Instance.new("UICorner", Wrapper)

        local Btn = Instance.new("TextButton", Wrapper)
        Btn.Size = UDim2.new(1, 0, 0, 60)
        Btn.BackgroundTransparency = 1
        Btn.Text = ""

        local T = Instance.new("TextLabel", Btn)
        T.Text = Name
        T.Size = UDim2.new(0.7, 0, 1, 0)
        T.Position = UDim2.new(0, 20, 0, 0)
        T.TextColor3 = Colors.Text
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.BackgroundTransparency = 1

        local Tog = Instance.new("Frame", Btn)
        Tog.Size = UDim2.new(0, 48, 0, 24)
        Tog.Position = UDim2.new(1, -68, 0.5, -12)
        Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
        Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

        Btn.MouseButton1Click:Connect(function()
            Config[Key] = not Config[Key]
            Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
        end)

        if HasSet then
            local SF = Instance.new("Frame", Wrapper)
            SF.Size = UDim2.new(1, 0, 0, 80)
            SF.Position = UDim2.new(0, 0, 0, 60)
            SF.BackgroundColor3 = Colors.SettingsBG
            if SetFunc then SetFunc(SF) end
            local Exp = false
            Btn.MouseButton2Click:Connect(function()
                Exp = not Exp
                Wrapper.Size = UDim2.new(1, -10, 0, Exp and 140 or 60)
            end)
        end
    end

    local function AddSlider(Par, Nam, Min, Max, Key)
        local L = Instance.new("TextLabel", Par)
        L.Text = Nam .. ": " .. Config[Key]
        L.Size = UDim2.new(1, -20, 0, 20)
        L.Position = UDim2.new(0, 10, 0, 10)
        L.TextColor3 = Colors.TextDark
        L.BackgroundTransparency = 1
        
        local B = Instance.new("TextButton", Par)
        B.Size = UDim2.new(1, -20, 0, 6)
        B.Position = UDim2.new(0, 10, 0, 40)
        B.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        B.Text = ""
        Instance.new("UICorner", B)
        
        local F = Instance.new("Frame", B)
        F.Size = UDim2.new((Config[Key]-Min)/(Max-Min), 0, 1, 0)
        F.BackgroundColor3 = Colors.Accent
        Instance.new("UICorner", F)

        B.MouseButton1Down:Connect(function()
            local Move = RunService.RenderStepped:Connect(function()
                local P = math.clamp((UserInputService:GetMouseLocation().X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                F.Size = UDim2.new(P, 0, 1, 0)
                Config[Key] = math.floor(Min + (Max - Min) * P)
                L.Text = Nam .. ": " .. Config[Key]
            end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end end)
        end)
    end

    -- [ ТАБЫ ]
    local T1 = CreateTab("Combat", "⚔️")
    local T2 = CreateTab("Move", "🏃")
    local T3 = CreateTab("World", "🌍")

    AddModule(T1, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)
    AddModule(T2, "Speed", "SpeedEnabled", true, function(f) AddSlider(f, "WalkSpeed", 16, 300, "Speed") end)
    AddModule(T3, "Gravity", "Gravity", true, function(f) AddSlider(f, "Force", 0, 196, "Gravity") end)

    -- [ ДРАГГИНГ ]
    local Dragging, DragStart, StartPos
    Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = i.Position StartPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        local Delta = i.Position - DragStart
        Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    -- Хоткей
    UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

    Pages["Combat"].P.Visible = true
    Pages["Combat"].B.BackgroundColor3 = Colors.ItemBG

end)

if not success then
    warn("❌ Ошибка запуска BLAZIX: " .. tostring(err))
end
