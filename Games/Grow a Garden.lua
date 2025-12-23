--[[
    BLAZIX TITAN V13 - ULTIMATE PROFILE EDITION
    FEATURES:
    - User Profile (Avatar + Name)
    - Auto-Saving System (JSON)
    - One-Click Actions
    - Full Cleanup on Close
    - Draggable Toggle Button
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
local Connections = {} -- Для очистки событий при закрытии

-- [ НАСТРОЙКИ ПО УМОЛЧАНИЮ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    
    Aimbot = false, AimFOV = 100, SilentAim = false,
    Hitbox = false, HitboxSize = 2,
    
    ESP_Enabled = false, Boxes = false, Tracers = false,
    Chams = false, FullBright = false,
    
    Gravity = 196.2, TimeChanger = false, Time = 12
}

-- [ СИСТЕМА СОХРАНЕНИЯ (FILE SYSTEM) ]
local FileName = "Blazix_Config_" .. LocalPlayer.UserId .. ".json"
local function SaveConfig()
    if writefile then
        local json = HttpService:JSONEncode(Config)
        writefile(FileName, json)
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(FileName) then
        local content = readfile(FileName)
        local success, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if success and decoded then
            for k, v in pairs(decoded) do
                Config[k] = v
            end
        end
    end
end
LoadConfig() -- Загружаем при старте

-- [ ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(0, 255, 160), -- Toxic Green
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    ItemBG = Color3.fromRGB(30, 30, 35),
    Red = Color3.fromRGB(255, 60, 60)
}

-- [ GUI SETUP ]
if CoreGui:FindFirstChild("BlazixV13") then CoreGui.BlazixV13:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixV13"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- [ ПЛАВАЮЩАЯ КНОПКА (TOGGLE BTN) ]
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0.4, 0)
FloatBtn.BackgroundColor3 = Colors.Main
FloatBtn.Text = "B"
FloatBtn.TextColor3 = Colors.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 30
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatBtn).Color = Colors.Accent
Instance.new("UIStroke", FloatBtn).Thickness = 2

-- Драггинг для плавающей кнопки
local fDrag, fStart, fPos
FloatBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fDrag = true fStart = i.Position fPos = FloatBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and fDrag then
    local d = i.Position - fStart
    FloatBtn.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + d.X, fPos.Y.Scale, fPos.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fDrag = false end end)

-- [ MAIN FRAME ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Colors.Accent
Stroke.Thickness = 2

-- [ ФУНКЦИЯ ОЧИСТКИ (CLOSE) ]
local function FullCleanup()
    -- Сброс персонажа
    if LocalPlayer.Character then
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then Hum.WalkSpeed = 16 Hum.JumpPower = 50 end
        workspace.Gravity = 196.2
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
    end
    -- Разрыв соединений
    for _, conn in pairs(Connections) do conn:Disconnect() end
    -- Удаление ESP
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "BlazixChams" then v:Destroy() end
    end
    -- Удаление GUI
    ScreenGui:Destroy()
end

-- [ HEADER ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar

local Title = Instance.new("TextLabel", Header)
Title.Text = "BLAZIX <font color='#00ffa0'>TITAN</font> v13"
Title.RichText = true
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = Colors.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Кнопки окна
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Colors.Red
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(FullCleanup)

local HideBtn = Instance.new("TextButton", Header)
HideBtn.Size = UDim2.new(0, 40, 0, 40)
HideBtn.Position = UDim2.new(1, -100, 0.5, -20)
HideBtn.BackgroundColor3 = Colors.ItemBG
HideBtn.Text = "_"
HideBtn.TextColor3 = Colors.Text
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- [ SIDEBAR & PROFILE ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 220, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar

-- ПРОФИЛЬ ИГРОКА (НОВОЕ)
local ProfileFrame = Instance.new("Frame", Sidebar)
ProfileFrame.Size = UDim2.new(1, -20, 0, 70)
ProfileFrame.Position = UDim2.new(0, 10, 1, -80)
ProfileFrame.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", ProfileFrame)
Instance.new("UIStroke", ProfileFrame).Color = Colors.Accent

local Avatar = Instance.new("ImageLabel", ProfileFrame)
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Position = UDim2.new(0, 10, 0.5, -25)
Avatar.BackgroundColor3 = Colors.Main
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local NameLbl = Instance.new("TextLabel", ProfileFrame)
NameLbl.Size = UDim2.new(0, 120, 0, 20)
NameLbl.Position = UDim2.new(0, 70, 0, 15)
NameLbl.Text = LocalPlayer.DisplayName
NameLbl.TextColor3 = Colors.Text
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 14
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.BackgroundTransparency = 1

local UserLbl = Instance.new("TextLabel", ProfileFrame)
UserLbl.Size = UDim2.new(0, 120, 0, 20)
UserLbl.Position = UDim2.new(0, 70, 0, 35)
UserLbl.Text = "@" .. LocalPlayer.Name
UserLbl.TextColor3 = Colors.TextDark
UserLbl.Font = Enum.Font.Gotham
UserLbl.TextSize = 12
UserLbl.TextXAlignment = Enum.TextXAlignment.Left
UserLbl.BackgroundTransparency = 1

-- Табы
local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -100)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -240, 1, -80)
PagesContainer.Position = UDim2.new(0, 230, 0, 70)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.BackgroundColor3 = Colors.Sidebar
    Btn.Text = "  " .. icon .. "  " .. name
    Btn.TextColor3 = Colors.TextDark
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Page.Visible = false end
        for _, t in pairs(TabContainer:GetChildren()) do if t:IsA("TextButton") then t.TextColor3 = Colors.TextDark t.BackgroundColor3 = Colors.Sidebar end end
        Page.Visible = true
        Btn.TextColor3 = Colors.Text
        Btn.BackgroundColor3 = Colors.ItemBG
    end)

    Pages[name] = {Page = Page, Btn = Btn}
    return Page
end

-- [ МОДУЛЬ: ТОГГЛ + СЛАЙДЕРЫ ]
local function AddToggle(Page, Name, ConfigKey, HasSettings, SliderFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 65)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)

    local Btn = Instance.new("TextButton", Wrapper)
    Btn.Size = UDim2.new(1, 0, 0, 65)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local Title = Instance.new("TextLabel", Btn)
    Title.Text = Name
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Colors.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Индикатор
    local Dot = Instance.new("Frame", Btn)
    Dot.Size = UDim2.new(0, 15, 0, 15)
    Dot.Position = UDim2.new(1, -40, 0.5, -7)
    Dot.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    -- ЛКМ: Включить/Выключить
    Btn.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        Dot.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 60)
        SaveConfig() -- Автосохранение
    end)

    -- ПКМ: Настройки
    if HasSettings then
        local SettingsFrame = Instance.new("Frame", Wrapper)
        SettingsFrame.Size = UDim2.new(1, 0, 0, 60)
        SettingsFrame.Position = UDim2.new(0, 0, 0, 65)
        SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        if SliderFunc then SliderFunc(SettingsFrame) end
        
        local Expanded = false
        Btn.MouseButton2Click:Connect(function()
            Expanded = not Expanded
            local targetH = Expanded and 125 or 65
            TweenService:Create(Wrapper, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, targetH)}):Play()
        end)
    end
end

-- [ МОДУЛЬ: КНОПКА ДЕЙСТВИЯ (Один клик) ]
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
    
    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Done!"
        Btn.TextColor3 = Colors.Accent
        task.wait(0.5)
        Btn.Text = Name
        Btn.TextColor3 = Colors.Text
        if Callback then Callback() end
    end)
end

-- [ СЛАЙДЕР ]
local function AddSlider(Parent, Name, Min, Max, Key)
    local Label = Instance.new("TextLabel", Parent)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.Text = Name .. ": " .. Config[Key]
    Label.TextColor3 = Colors.TextDark
    Label.BackgroundTransparency = 1
    
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
        local c = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(Min + (Max-Min)*p)
            Config[Key] = v
            Label.Text = Name .. ": " .. v
            Fill.Size = UDim2.new(p, 0, 1, 0)
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then c:Disconnect() SaveConfig() end end)
    end)
end

-- [ СТРАНИЦЫ И ФУНКЦИИ ]
local P_Main = CreateTab("Main", "🏠")
local P_Combat = CreateTab("Combat", "⚔️")
local P_Visual = CreateTab("Visuals", "👁️")
local P_Misc = CreateTab("Misc", "⚙️")

-- Main
AddToggle(P_Main, "Speed Bypass", "SpeedEnabled", true, function(f) AddSlider(f, "Value", 16, 300, "Speed") end)
AddToggle(P_Main, "Flight", "FlyEnabled", true, function(f) AddSlider(f, "Speed", 10, 400, "FlySpeed") end)
AddToggle(P_Main, "Infinite Jump", "InfJump", false)
AddToggle(P_Main, "Noclip", "Noclip", false)
AddToggle(P_Main, "Anti-Void", "AntiVoid", false)

-- Combat
AddToggle(P_Combat, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 20, 500, "AimFOV") end)
AddToggle(P_Combat, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 40, "HitboxSize") end)

-- Visuals
AddToggle(P_Visual, "ESP Enable", "ESP_Enabled", false)
AddToggle(P_Visual, "Chams", "Chams", false)
AddToggle(P_Visual, "FullBright", "FullBright", false)

-- Misc
AddAction(P_Misc, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
AddAction(P_Misc, "Server Hop", function()
    -- Простая логика хопа
    local Http = game:GetService("HttpService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing ~= s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

-- [ ГЛАВНЫЕ ЦИКЛЫ (LOGIC) ]
Connections.Loop = RunService.Heartbeat:Connect(function()
    if not Main.Parent then return end -- Защита если GUI удалено
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("Humanoid") then
        local H = Char.Humanoid
        local RP = Char.HumanoidRootPart
        
        -- Move
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then
            Char:TranslateBy(H.MoveDirection * (Config.Speed/100))
        end
        -- Fly
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
        -- Noclip
        if Config.Noclip then
            for _,p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
        -- AntiVoid
        if Config.AntiVoid and RP.Position.Y < -50 then
            RP.Velocity = Vector3.zero
            RP.CFrame = CFrame.new(RP.Position.X, 100, RP.Position.Z)
        end
    end
end)

-- ESP Loop
task.spawn(function()
    while task.wait(1) do
        if not Main.Parent then break end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("BlazixChams")
                if Config.Chams then
                    if not hl then
                        hl = Instance.new("Highlight", p.Character)
                        hl.Name = "BlazixChams"
                        hl.FillColor = Colors.Accent
                    end
                    hl.Enabled = true
                elseif hl then
                    hl:Destroy()
                end
            end
        end
    end
end)

-- [ УПРАВЛЕНИЕ ]
FloatBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftAlt then
        Main.Visible = not Main.Visible
    end
end)

-- Dragging Main
local mDrag, mStart, mPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then mDrag = true mStart = i.Position mPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and mDrag then
    local d = i.Position - mStart
    Main.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then mDrag = false end end)

-- Старт
Pages["Main"].Page.Visible = true
StarterGui:SetCore("SendNotification", {
    Title = "BLAZIX TITAN",
    Text = "Welcome, " .. LocalPlayer.DisplayName .. "!\nSettings loaded.",
    Icon = "rbxassetid://13473268686",
    Duration = 5
})
