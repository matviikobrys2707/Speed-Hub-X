--[[
    BLAZIX TITAN V14 - VISUAL REMASTER
    [CHANGELOG]
    + Restored Beautiful Toggle Switches
    + Added Gear Icon (⚙️) for Right-Click hint
    + Kept User Profile & Auto-Save System
    + Smooth Animations
]]

-- [ СЕРВИСЫ ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

-- [ ПЕРЕМЕННЫЕ ]
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Connections = {} 

-- [ НАСТРОЙКИ ПО УМОЛЧАНИЮ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2,
    
    ESP_Enabled = false, Chams = false, FullBright = false,
    
    Gravity = 196.2, TimeChanger = false, Time = 12
}

-- [ СИСТЕМА СОХРАНЕНИЯ ]
local FileName = "Blazix_Config_" .. LocalPlayer.UserId .. ".json"
local function SaveConfig()
    if writefile then
        local success, json = pcall(function() return HttpService:JSONEncode(Config) end)
        if success then writefile(FileName, json) end
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(FileName) then
        local content = readfile(FileName)
        local success, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if success and decoded then
            for k, v in pairs(decoded) do Config[k] = v end
        end
    end
end
LoadConfig()

-- [ ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(24, 24, 30),
    Accent = Color3.fromRGB(0, 255, 140), -- Neon Green
    Text = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(160, 160, 160),
    ItemBG = Color3.fromRGB(32, 32, 38),
    SettingsBG = Color3.fromRGB(26, 26, 32),
    Red = Color3.fromRGB(255, 60, 60)
}

-- [ GUI SETUP ]
if CoreGui:FindFirstChild("BlazixV14") then CoreGui.BlazixV14:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixV14"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- [ ПЛАВАЮЩАЯ КНОПКА ]
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0.4, 0)
FloatBtn.BackgroundColor3 = Colors.Main
FloatBtn.Text = "B"
FloatBtn.TextColor3 = Colors.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 28
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatBtn).Color = Colors.Accent
Instance.new("UIStroke", FloatBtn).Thickness = 2

-- Dragging Float
local fd, fs, fp
FloatBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fd=true fs=i.Position fp=FloatBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and fd then
    local d = i.Position - fs
    FloatBtn.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X, fp.Y.Scale, fp.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fd=false end end)

-- [ MAIN FRAME ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Colors.Accent
Stroke.Thickness = 2

-- [ ФУНКЦИЯ ОЧИСТКИ ]
local function FullCleanup()
    if LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then Hum.WalkSpeed = 16 Hum.JumpPower = 50 end
        workspace.Gravity = 196.2
        Lighting.Brightness = 1
    end
    for _, conn in pairs(Connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end

-- [ HEADER ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> V14"
Title.RichText = true
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextColor3 = Colors.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Colors.Red
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(FullCleanup)

local HideBtn = Instance.new("TextButton", Header)
HideBtn.Size = UDim2.new(0, 35, 0, 35)
HideBtn.Position = UDim2.new(1, -90, 0.5, -17.5)
HideBtn.BackgroundColor3 = Colors.ItemBG
HideBtn.Text = "_"
HideBtn.TextColor3 = Colors.Text
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- [ SIDEBAR ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0

-- Профиль
local ProfileFrame = Instance.new("Frame", Sidebar)
ProfileFrame.Size = UDim2.new(1, -20, 0, 60)
ProfileFrame.Position = UDim2.new(0, 10, 1, -70)
ProfileFrame.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", ProfileFrame)
local Avatar = Instance.new("ImageLabel", ProfileFrame)
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 10, 0.5, -20)
Avatar.BackgroundColor3 = Colors.Main
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
local NameLbl = Instance.new("TextLabel", ProfileFrame)
NameLbl.Size = UDim2.new(0, 100, 0, 20)
NameLbl.Position = UDim2.new(0, 60, 0, 10)
NameLbl.Text = LocalPlayer.DisplayName
NameLbl.TextColor3 = Colors.Text
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 13
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.BackgroundTransparency = 1
local UserLbl = Instance.new("TextLabel", ProfileFrame)
UserLbl.Size = UDim2.new(0, 100, 0, 20)
UserLbl.Position = UDim2.new(0, 60, 0, 30)
UserLbl.Text = "@" .. LocalPlayer.Name
UserLbl.TextColor3 = Colors.TextGray
UserLbl.Font = Enum.Font.Gotham
UserLbl.TextSize = 11
UserLbl.TextXAlignment = Enum.TextXAlignment.Left
UserLbl.BackgroundTransparency = 1

-- Табы
local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)

-- Контейнер страниц
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
    Page.ScrollBarThickness = 2
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, 0)
    Btn.BackgroundColor3 = Colors.Sidebar
    Btn.Text = "   " .. icon .. "  " .. name
    Btn.TextColor3 = Colors.TextGray
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Page.Visible = false end
        for _, t in pairs(TabContainer:GetChildren()) do if t:IsA("TextButton") then t.TextColor3=Colors.TextGray t.BackgroundColor3=Colors.Sidebar end end
        Page.Visible = true
        Btn.TextColor3 = Colors.Text
        Btn.BackgroundColor3 = Colors.ItemBG
    end)
    Pages[name] = {Page = Page, Btn = Btn}
    return Page
end

-- [ НОВЫЙ ДИЗАЙН КНОПОК (КРАСИВЫЙ TOGGLE + ШЕСТЕРЕНКА) ]
local function AddModule(Page, Name, ConfigKey, HasSettings, SliderFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)

    local Hitbox = Instance.new("TextButton", Wrapper)
    Hitbox.Size = UDim2.new(1, 0, 0, 60)
    Hitbox.BackgroundTransparency = 1
    Hitbox.Text = ""

    local Title = Instance.new("TextLabel", Hitbox)
    Title.Text = Name
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Colors.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- КРАСИВЫЙ ПЕРЕКЛЮЧАТЕЛЬ (SWITCH)
    local ToggleBg = Instance.new("Frame", Hitbox)
    ToggleBg.Size = UDim2.new(0, 44, 0, 24)
    ToggleBg.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleBg.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", ToggleBg)
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = Config[ConfigKey] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    -- ИКОНКА ШЕСТЕРЕНКИ (GEAR) - ДЛЯ ПКМ
    if HasSettings then
        local Gear = Instance.new("ImageLabel", Hitbox)
        Gear.Size = UDim2.new(0, 20, 0, 20)
        Gear.Position = UDim2.new(1, -100, 0.5, -10)
        Gear.Image = "rbxassetid://3926307971" -- Gear Icon
        Gear.ImageRectOffset = Vector2.new(324, 124)
        Gear.ImageRectSize = Vector2.new(36, 36)
        Gear.ImageColor3 = Colors.TextGray
        Gear.BackgroundTransparency = 1
        
        -- Подсказка (Tooltip)
        local Hint = Instance.new("TextLabel", Hitbox)
        Hint.Size = UDim2.new(0, 0, 0, 0)
        Hint.Position = UDim2.new(1, -100, 0.5, 15)
        Hint.Text = "Right Click"
        Hint.TextSize = 9
        Hint.TextColor3 = Colors.TextGray
        Hint.BackgroundTransparency = 1
    end

    -- Логика ЛКМ (Вкл/Выкл)
    Hitbox.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        
        -- Анимация
        local targetPos = Config[ConfigKey] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetCol = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(50, 50, 60)
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
        
        SaveConfig()
    end)

    -- Логика ПКМ (Настройки)
    if HasSettings then
        local SettingsFrame = Instance.new("Frame", Wrapper)
        SettingsFrame.Size = UDim2.new(1, 0, 0, 80)
        SettingsFrame.Position = UDim2.new(0, 0, 0, 60)
        SettingsFrame.BackgroundColor3 = Colors.SettingsBG
        SettingsFrame.BorderSizePixel = 0
        if SliderFunc then SliderFunc(SettingsFrame) end

        local Expanded = false
        Hitbox.MouseButton2Click:Connect(function()
            Expanded = not Expanded
            local targetH = Expanded and 140 or 60
            TweenService:Create(Wrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, targetH)}):Play()
        end)
    end
end

-- [ ФУНКЦИЯ ДЕЙСТВИЯ (КНОПКА) ]
local function AddAction(Page, Name, Callback)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 50)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Instance.new("UICorner", Wrapper)
    local Btn = Instance.new("TextButton", Wrapper)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = Name
    Btn.TextColor3 = Colors.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Btn.MouseButton1Click:Connect(function() Callback() end)
end

-- [ СЛАЙДЕР ]
local function AddSlider(Parent, Name, Min, Max, Key)
    local L = Instance.new("TextLabel", Parent)
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 10, 0, 10)
    L.Text = Name .. ": " .. Config[Key]
    L.TextColor3 = Colors.TextGray
    L.BackgroundTransparency = 1
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    local B = Instance.new("TextButton", Parent)
    B.Size = UDim2.new(1, -20, 0, 6)
    B.Position = UDim2.new(0, 10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    B.Text = ""
    Instance.new("UICorner", B)
    local F = Instance.new("Frame", B)
    F.Size = UDim2.new((Config[Key]-Min)/(Max-Min), 0, 1, 0)
    F.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", F)
    B.MouseButton1Down:Connect(function()
        local m = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - B.AbsolutePosition.X)/B.AbsoluteSize.X, 0, 1)
            Config[Key] = math.floor(Min + (Max-Min)*p)
            L.Text = Name .. ": " .. Config[Key]
            F.Size = UDim2.new(p, 0, 1, 0)
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then m:Disconnect() SaveConfig() end end)
    end)
end

-- [ СТРАНИЦЫ ]
local PM = CreateTab("Main", "🏠")
local PC = CreateTab("Combat", "⚔️")
local PV = CreateTab("Visuals", "👁️")
local PSET = CreateTab("Misc", "⚙️")

AddModule(PM, "Speed Bypass", "SpeedEnabled", true, function(f) AddSlider(f, "Speed", 16, 300, "Speed") end)
AddModule(PM, "Flight", "FlyEnabled", true, function(f) AddSlider(f, "Velocity", 10, 400, "FlySpeed") end)
AddModule(PM, "Jump Power", "JumpEnabled", true, function(f) AddSlider(f, "Height", 50, 300, "JumpPower") end)
AddModule(PM, "Infinite Jump", "InfJump", false)
AddModule(PM, "Noclip", "Noclip", false)
AddModule(PM, "Anti-Void", "AntiVoid", false)

AddModule(PC, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(PC, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 40, "HitboxSize") end)

AddModule(PV, "ESP Enabled", "ESP_Enabled", false)
AddModule(PV, "Chams", "Chams", false)
AddModule(PV, "FullBright", "FullBright", false)

AddAction(PSET, "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("Humanoid") then
        local H = Char.Humanoid
        local RP = Char.HumanoidRootPart
        
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then
            Char:TranslateBy(H.MoveDirection * (Config.Speed/100))
        end
        
        if Config.FlyEnabled then
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
            RP.Velocity = v * Config.FlySpeed
            H.PlatformStand = true
        else
            H.PlatformStand = false
        end

        if Config.JumpEnabled then H.JumpPower = Config.JumpPower end

        if Config.Noclip then
            for _,p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
        
        if Config.AntiVoid and RP.Position.Y < -50 then
            RP.Velocity = Vector3.zero
            RP.CFrame = CFrame.new(RP.Position.X, 100, RP.Position.Z)
        end
    end
end)

-- ESP Logic
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("BlazixHL")
                if Config.Chams then
                    if not hl then hl = Instance.new("Highlight", p.Character); hl.Name="BlazixHL"; hl.FillColor=Colors.Accent end
                    hl.Enabled = true
                elseif hl then hl:Destroy() end
            end
        end
    end
end)

-- Controls
FloatBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end end)

-- Dragging
local md, ms, mp
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then md=true ms=i.Position mp=Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and md then
    local d = i.Position - ms
    Main.Position = UDim2.new(mp.X.Scale, mp.X.Offset + d.X, mp.Y.Scale, mp.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then md=false end end)

Pages["Main"].Btn.BackgroundColor3 = Colors.ItemBG
Pages["Main"].Btn.TextColor3 = Colors.Text
Pages["Main"].Page.Visible = true

StarterGui:SetCore("SendNotification", {Title="BLAZIX V14", Text="Visual Remaster Loaded", Duration=5})
