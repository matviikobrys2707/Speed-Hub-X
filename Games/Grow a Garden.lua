--[[
    BLAZIX TITAN V19: GIGA OVERHAUL
    
    [ИНСТРУКЦИЯ]
    • ЛЕВАЯ КНОПКА МЫШИ -> Включить функцию
    • ПРАВАЯ КНОПКА МЫШИ -> Открыть настройки (Слайдеры)
    • Right Control -> Скрыть меню
    • КРЕСТИК -> Удалить GUI
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    -- Movement
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    BunnyHop = false, SpinBot = false,
    
    -- Combat
    Aimbot = false, AimFOV = 100, SilentAim = false,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    AutoClicker = false, ClickDelay = 0.1, TriggerBot = false,
    
    -- Visuals
    ESP_Enabled = false, Chams = false, FullBright = false, Boxes = false,
    
    -- World
    Gravity = 196.2, Time = 12, DestroyLava = false, XRay = false,
    
    -- Misc
    AntiAFK = true, AntiPopups = false, ChatSpy = false
}

local FileName = "BlazixTitan_Config.json"
local function SaveConfig() if writefile then writefile(FileName, HttpService:JSONEncode(Config)) end end
local function LoadConfig()
    if isfile and isfile(FileName) then
        local s, d = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if s then for k, v in pairs(d) do Config[k] = v end end
    end
end
LoadConfig()

-- [ ДИЗАЙН ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 28),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 160),
    ItemBG = Color3.fromRGB(30, 30, 38),
    SettingsBG = Color3.fromRGB(25, 25, 32),
    Red = Color3.fromRGB(220, 60, 60)
}

-- [ СОЗДАНИЕ GUI ]
if CoreGui:FindFirstChild("BlazixTitanV19") then CoreGui.BlazixTitanV19:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BlazixTitanV19"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 900, 0, 650)
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- [ ШАПКА ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Colors.Sidebar
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v19"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17)
CloseBtn.BackgroundColor3 = Colors.Red
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [ САЙДБАР ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 210, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Colors.Sidebar

-- КРАСИВЫЙ БОКС ПРОФИЛЯ
local ProfileBox = Instance.new("Frame", Sidebar)
ProfileBox.Size = UDim2.new(1, -20, 0, 80)
ProfileBox.Position = UDim2.new(0, 10, 1, -90)
ProfileBox.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", ProfileBox)
local PStroke = Instance.new("UIStroke", ProfileBox)
PStroke.Color = Colors.Accent
PStroke.Thickness = 1.5

local Avatar = Instance.new("ImageLabel", ProfileBox)
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Position = UDim2.new(0, 10, 0.5, -25)
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.BackgroundTransparency = 1
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local NameLbl = Instance.new("TextLabel", ProfileBox)
NameLbl.Text = LocalPlayer.DisplayName
NameLbl.Size = UDim2.new(0, 120, 0, 20)
NameLbl.Position = UDim2.new(0, 70, 0.25, 0)
NameLbl.TextColor3 = Colors.Text
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 14
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.BackgroundTransparency = 1

local UserLbl = Instance.new("TextLabel", ProfileBox)
UserLbl.Text = "@" .. LocalPlayer.Name
UserLbl.Size = UDim2.new(0, 120, 0, 20)
UserLbl.Position = UDim2.new(0, 70, 0.55, 0)
UserLbl.TextColor3 = Colors.TextDark
UserLbl.Font = Enum.Font.Gotham
UserLbl.TextSize = 11
UserLbl.TextXAlignment = Enum.TextXAlignment.Left
UserLbl.BackgroundTransparency = 1

-- ТАБЫ
local TabScroll = Instance.new("ScrollingFrame", Sidebar)
TabScroll.Size = UDim2.new(1, 0, 1, -110)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
local TabList = Instance.new("UIListLayout", TabScroll)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -230, 1, -80)
PagesContainer.Position = UDim2.new(0, 220, 0, 70)
PagesContainer.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, icon)
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    local Btn = Instance.new("TextButton", TabScroll)
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.BackgroundColor3 = Colors.Main
    Btn.Text = "  " .. icon .. "  " .. name
    Btn.TextColor3 = Colors.TextDark
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.P.Visible = false p.B.TextColor3 = Colors.TextDark p.B.BackgroundColor3 = Colors.Main end
        Page.Visible = true
        Btn.TextColor3 = Colors.Text
        Btn.BackgroundColor3 = Colors.ItemBG
    end)
    Pages[name] = {P = Page, B = Btn}
    return Page
end

-- [ ФУНКЦИЯ МОДУЛЯ ]
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

    local Tog = Instance.new("Frame", Button)
    Tog.Size = UDim2.new(0, 46, 0, 24)
    Tog.Position = UDim2.new(1, -66, 0.5, -12)
    Tog.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

    local Ball = Instance.new("Frame", Tog)
    Ball.Size = UDim2.new(0, 20, 0, 20)
    Ball.Position = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Ball.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        TweenService:Create(Ball, TweenInfo.new(0.2), {Position = Config[ConfigKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
        TweenService:Create(Tog, TweenInfo.new(0.2), {BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
        SaveConfig()
    end)

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

local function AddSlider(Parent, Name, Min, Max, Key)
    local L = Instance.new("TextLabel", Parent)
    L.Text = Name .. ": " .. Config[Key]
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 10, 0, 10)
    L.TextColor3 = Colors.TextDark
    L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", Parent)
    B.Size = UDim2.new(1, -20, 0, 6)
    B.Position = UDim2.new(0, 10, 0, 45)
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

-- [ ВКЛАДКИ ]
local TabCombat = CreateTab("Combat", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabVisual = CreateTab("Visuals", "👁️")
local TabWorld = CreateTab("World", "🌍")
local TabMisc = CreateTab("Misc", "⚙️")
local TabSettings = CreateTab("Settings", "🛠️")

-- MOVEMENT
AddModule(TabMove, "Speed Hack", "SpeedEnabled", true, function(f) AddSlider(f, "Value", 16, 500, "Speed") end)
AddModule(TabMove, "Fly Mode", "FlyEnabled", true, function(f) AddSlider(f, "Fly Speed", 10, 500, "FlySpeed") end)
AddModule(TabMove, "Jump Power", "JumpEnabled", true, function(f) AddSlider(f, "Power", 50, 500, "JumpPower") end)
AddModule(TabMove, "Infinite Jump", "InfJump", false)
AddModule(TabMove, "Noclip", "Noclip", false)
AddModule(TabMove, "SpinBot", "SpinBot", false)
AddModule(TabMove, "BunnyHop", "BunnyHop", false)
AddModule(TabMove, "Anti-Void", "AntiVoid", false)

-- COMBAT
AddModule(TabCombat, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(TabCombat, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 50, "HitboxSize") end)
AddModule(TabCombat, "Auto Clicker", "AutoClicker", true, function(f) AddSlider(f, "Delay", 0, 1, "ClickDelay") end)
AddModule(TabCombat, "Silent Aim", "SilentAim", false)

-- VISUALS
AddModule(TabVisual, "ESP Master", "ESP_Enabled", false)
AddModule(TabVisual, "Chams (Wallhack)", "Chams", false)
AddModule(TabVisual, "FullBright", "FullBright", false)

-- WORLD
AddModule(TabWorld, "Gravity Control", "Gravity", true, function(f) AddSlider(f, "Force", 0, 196, "Gravity") end)
AddModule(TabWorld, "Time Changer", "Time", true, function(f) AddSlider(f, "Clock", 0, 24, "Time") end)
AddModule(TabWorld, "Destroy Lava", "DestroyLava", false)
AddModule(TabWorld, "X-Ray", "XRay", false)

-- MISC
AddModule(TabMisc, "Anti-Popups", "AntiPopups", false)
AddModule(TabMisc, "Anti-AFK", "AntiAFK", false)

-- SETTINGS TAB
local function ActionBtn(P, N, C, Call)
    local B = Instance.new("TextButton", P)
    B.Size = UDim2.new(1, -10, 0, 50)
    B.BackgroundColor3 = C
    B.Text = N
    B.TextColor3 = Colors.Text
    B.Font = Enum.Font.GothamBold
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(Call)
end

ActionBtn(TabSettings, "Save Configuration", Colors.ItemBG, SaveConfig)
ActionBtn(TabSettings, "Load Configuration", Colors.ItemBG, LoadConfig)
ActionBtn(TabSettings, "Reset Config", Colors.Red, function()
    if isfile(FileName) then delfile(FileName) end
    ScreenGui:Destroy()
end)

-- [ ГЛАВНЫЕ ЦИКЛЫ ЛОГИКИ ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local RP = Char.HumanoidRootPart
        local H = Char.Humanoid
        -- Speed
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then Char:TranslateBy(H.MoveDirection * (Config.Speed/100)) end
        -- Fly
        if Config.FlyEnabled then
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
            RP.Velocity = v * Config.FlySpeed
            H.PlatformStand = true
        else H.PlatformStand = false end
        -- Spin
        if Config.SpinBot then RP.CFrame = RP.CFrame * CFrame.Angles(0, math.rad(45), 0) end
        -- BHop
        if Config.BunnyHop and H.MoveDirection.Magnitude > 0 and H.FloorMaterial ~= Enum.Material.Air then H.Jump = true end
        -- Noclip
        if Config.Noclip then for _,v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        -- World
        workspace.Gravity = Config.Gravity
        -- AntiPopups
        if Config.AntiPopups then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _,v in pairs(pg:GetDescendants()) do
                    if v:IsA("TextLabel") and (v.Text:find("Donate") or v.Text:find("Like") or v.Text:find("Favorite")) then
                        local f = v:FindFirstAncestorOfClass("Frame")
                        if f then f.Visible = false end
                    end
                end
            end
        end
    end
end)

-- Драггинг
local d, s, sp
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true s=i.Position sp=Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then
    local delta = i.Position - s
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

-- Переключение видимости
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

Pages["Combat"].P.Visible = true
Pages["Combat"].B.BackgroundColor3 = Colors.ItemBG
Pages["Combat"].B.TextColor3 = Colors.Text

print("✅ BLAZIX TITAN V19 LOADED!")
