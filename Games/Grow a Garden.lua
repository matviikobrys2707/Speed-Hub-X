--[[
    BLAZIX TITAN V15 - PRO EDITION
    - Кнопки из V12 (ЛКМ - вкл, ПКМ - настройки)
    - Профиль игрока (Аватар + Ник)
    - Система авто-сохранений на диск
    - Полная очистка при закрытии
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ / СОХРАНЕНИЕ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2,
    ESP_Enabled = false, Chams = false
}

local FileName = "Blazix_TITAN_Save_" .. LocalPlayer.UserId .. ".json"

local function SaveConfig()
    if writefile then
        writefile(FileName, HttpService:JSONEncode(Config))
    end
end

local function LoadConfig()
    if isfile and isfile(FileName) then
        local content = readfile(FileName)
        local success, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if success then 
            for k, v in pairs(decoded) do Config[k] = v end 
        end
    end
end
LoadConfig()

-- [ ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35),
    Red = Color3.fromRGB(220, 60, 60)
}

-- [ ГЛАВНЫЙ ТЕРМИНАТОР (ЗАКРЫТИЕ) ]
local Connections = {}
local function FullCleanup()
    if LocalPlayer.Character then
        local H = LocalPlayer.Character:FindFirstChild("Humanoid")
        if H then H.WalkSpeed = 16 H.JumpPower = 50 end
    end
    for _, c in pairs(Connections) do c:Disconnect() end
    if CoreGui:FindFirstChild("BlazixV15") then CoreGui.BlazixV15:Destroy() end
end

-- [ СОЗДАНИЕ GUI ]
if CoreGui:FindFirstChild("BlazixV15") then CoreGui.BlazixV15:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BlazixV15"
ScreenGui.IgnoreGuiInset = true

-- Плавающая кнопка
local Float = Instance.new("TextButton", ScreenGui)
Float.Size = UDim2.new(0, 45, 0, 45)
Float.Position = UDim2.new(0, 10, 0.5, 0)
Float.BackgroundColor3 = Colors.Main
Float.Text = "B"
Float.TextColor3 = Colors.Accent
Float.Font = Enum.Font.GothamBold
Float.TextSize = 24
Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Float).Color = Colors.Accent

-- Главное окно
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5

-- [ ШАПКА ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Colors.Sidebar

local Title = Instance.new("TextLabel", Header)
Title.Text = "  BLAZIX <font color='#00ff8c'>TITAN</font> V15"
Title.RichText = true
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Colors.Red
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(FullCleanup)

-- [ ПРОФИЛЬ (ВНИЗУ СЛЕВА) ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Colors.Sidebar

local Profile = Instance.new("Frame", Sidebar)
Profile.Size = UDim2.new(1, -20, 0, 60)
Profile.Position = UDim2.new(0, 10, 1, -70)
Profile.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", Profile)

local Avatar = Instance.new("ImageLabel", Profile)
Avatar.Size = UDim2.new(0, 45, 0, 45)
Avatar.Position = UDim2.new(0, 7, 0.5, -22.5)
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.BackgroundTransparency = 1
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local NameLbl = Instance.new("TextLabel", Profile)
NameLbl.Text = LocalPlayer.DisplayName
NameLbl.Size = UDim2.new(0, 120, 0, 20)
NameLbl.Position = UDim2.new(0, 57, 0.2, 0)
NameLbl.TextColor3 = Colors.Text
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 13
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.BackgroundTransparency = 1

local UserLbl = Instance.new("TextLabel", Profile)
UserLbl.Text = "@" .. LocalPlayer.Name
UserLbl.Size = UDim2.new(0, 120, 0, 20)
UserLbl.Position = UDim2.new(0, 57, 0.55, 0)
UserLbl.TextColor3 = Colors.TextDark
UserLbl.Font = Enum.Font.Gotham
UserLbl.TextSize = 11
UserLbl.TextXAlignment = Enum.TextXAlignment.Left
UserLbl.BackgroundTransparency = 1

-- [ ВКЛАДКИ ]
local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -220, 1, -70)
PagesContainer.Position = UDim2.new(0, 210, 0, 60)
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

    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Colors.Main
    Btn.Text = "  " .. icon .. "  " .. name
    Btn.TextColor3 = Colors.TextDark
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Page.Visible = false p.Btn.TextColor3 = Colors.TextDark p.Btn.BackgroundColor3 = Colors.Main end
        Page.Visible = true
        Btn.TextColor3 = Colors.Text
        Btn.BackgroundColor3 = Colors.ItemBG
    end)
    Pages[name] = {Page = Page, Btn = Btn}
    return Page
end

-- [ ФУНКЦИЯ МОДУЛЯ (КАК В V12) ]
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

    local Title = Instance.new("TextLabel", Button)
    Title.Text = Name
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Овальный переключатель (Toggle)
    local ToggleBg = Instance.new("Frame", Button)
    ToggleBg.Size = UDim2.new(0, 46, 0, 24)
    ToggleBg.Position = UDim2.new(1, -66, 0.5, -12)
    ToggleBg.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", ToggleBg)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    if HasSettings then
        local Gear = Instance.new("ImageLabel", Button)
        Gear.Size = UDim2.new(0, 18, 0, 18)
        Gear.Position = UDim2.new(1, -95, 0.5, -9)
        Gear.Image = "rbxassetid://3926307971"
        Gear.ImageRectOffset = Vector2.new(324, 124)
        Gear.ImageRectSize = Vector2.new(36, 36)
        Gear.ImageColor3 = Colors.TextDark
        Gear.BackgroundTransparency = 1
    end

    -- ЛКМ: Вкл/Выкл
    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        local targetPos = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local targetCol = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
        SaveConfig()
    end)

    -- ПКМ: Раскрыть настройки
    if HasSettings then
        local SFrame = Instance.new("Frame", Wrapper)
        SFrame.Size = UDim2.new(1, 0, 0, 80)
        SFrame.Position = UDim2.new(0, 0, 0, 60)
        SFrame.BackgroundColor3 = Colors.SettingsBG
        if SettingsFunc then SettingsFunc(SFrame) end

        local Open = false
        Button.MouseButton2Click:Connect(function()
            Open = not Open
            TweenService:Create(Wrapper, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, Open and 140 or 60)}):Play()
        end)
    end
end

-- Функция Слайдера
local function AddSlider(Parent, Name, Min, Max, Key)
    local L = Instance.new("TextLabel", Parent)
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 10, 0, 10)
    L.Text = Name .. ": " .. Config[Key]
    L.TextColor3 = Colors.TextDark
    L.Font = Enum.Font.Gotham
    L.BackgroundTransparency = 1
    local Bar = Instance.new("TextButton", Parent)
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 40)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Bar.Text = ""
    Instance.new("UICorner", Bar)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((Config[Key]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill)
    Bar.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
            Config[Key] = math.floor(Min + (Max-Min)*p)
            L.Text = Name .. ": " .. Config[Key]
            Fill.Size = UDim2.new(p, 0, 1, 0)
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() SaveConfig() end end)
    end)
end

-- Кнопка действия (1 клик)
local function AddAction(Page, Name, Callback)
    local B = Instance.new("TextButton", Page)
    B.Size = UDim2.new(1, -10, 0, 45)
    B.BackgroundColor3 = Colors.ItemBG
    B.Text = Name
    B.TextColor3 = Colors.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 14
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(Callback)
end

-- [ СТРАНИЦЫ ]
local P_Main = CreateTab("Movement", "🏃")
local P_Combat = CreateTab("Combat", "⚔️")
local P_Misc = CreateTab("Misc", "⚙️")

AddModule(P_Main, "Speed Hack", "SpeedEnabled", true, function(f) AddSlider(f, "WalkSpeed", 16, 300, "Speed") end)
AddModule(P_Main, "Flight", "FlyEnabled", true, function(f) AddSlider(f, "Velocity", 10, 500, "FlySpeed") end)
AddModule(P_Main, "Infinite Jump", "InfJump", false)
AddModule(P_Main, "Noclip", "Noclip", false)

AddModule(P_Combat, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 50, "HitboxSize") end)

AddAction(P_Misc, "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
AddAction(P_Misc, "Server Hop", function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing ~= s.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) break end
    end
end)

-- [ ЛОГИКА ]
Connections.Heartbeat = RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local H = Char.Humanoid
        local RP = Char.HumanoidRootPart
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then Char:TranslateBy(H.MoveDirection * (Config.Speed/100)) end
        if Config.FlyEnabled then
            local Dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Dir = Dir + Vector3.new(0,1,0) end
            RP.Velocity = Dir * Config.FlySpeed
            H.PlatformStand = true
        else H.PlatformStand = false end
        if Config.Noclip then for _,v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- Управление интерфейсом
Float.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end end)

-- Перетаскивание
local d, s, sp
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true s=i.Position sp=Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then
    local delta = i.Position - s
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

Pages["Movement"].Btn.BackgroundColor3 = Colors.ItemBG
Pages["Movement"].Btn.TextColor3 = Colors.Text
Pages["Movement"].Page.Visible = true

print("✅ BLAZIX TITAN V15 LOADED")
