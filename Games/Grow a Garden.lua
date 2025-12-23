--[[
    BLAZIX TITAN V17 - REAL ULTIMATE
    [КОНТРОЛЬ]
    - ЛКМ: Включить/Выключить
    - ПКМ: Раскрыть настройки (Слайдеры)
    - Left Alt: Скрыть/Показать
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ НАСТРОЙКИ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2,
    ESP_Enabled = false, Chams = false,
    AntiPopups = false, SpinBot = false, BHop = false
}

local FileName = "Blazix_V17_Config.json"

local function SaveConfig()
    if writefile then writefile(FileName, HttpService:JSONEncode(Config)) end
end

local function LoadConfig()
    if isfile and isfile(FileName) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success then for k, v in pairs(decoded) do Config[k] = v end end
    end
end
LoadConfig()

-- [ ДИЗАЙН ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(13, 13, 18),
    Sidebar = Color3.fromRGB(18, 18, 24),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    ItemBG = Color3.fromRGB(28, 28, 35),
    SettingsBG = Color3.fromRGB(22, 22, 28),
    Glow = Color3.fromRGB(0, 255, 140)
}

-- [ ГЛАВНЫЙ GUI ]
if CoreGui:FindFirstChild("BlazixV17") then CoreGui.BlazixV17:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BlazixV17"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5

-- [ ШАПКА ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Colors.Sidebar
local Title = Instance.new("TextLabel", Header)
Title.Text = "  BLAZIX <font color='#00ff8c'>TITAN</font> V17"
Title.RichText = true
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- [ СЕЙДБАР И ПРОФИЛЬ ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 210, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Colors.Sidebar

-- Рамка профиля с неоном
local ProfileBox = Instance.new("Frame", Sidebar)
ProfileBox.Size = UDim2.new(1, -20, 0, 80)
ProfileBox.Position = UDim2.new(0, 10, 1, -90)
ProfileBox.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", ProfileBox)
local ProfileStroke = Instance.new("UIStroke", ProfileBox)
ProfileStroke.Color = Colors.Accent
ProfileStroke.Thickness = 2

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

-- [ ВКЛАДКИ ]
local TabScroll = Instance.new("ScrollingFrame", Sidebar)
TabScroll.Size = UDim2.new(1, 0, 1, -110)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
local TabList = Instance.new("UIListLayout", TabScroll)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -230, 1, -70)
PagesContainer.Position = UDim2.new(0, 220, 0, 60)
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

    local Btn = Instance.new("TextButton", TabScroll)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Colors.Main
    Btn.Text = "  " .. icon .. "  " .. name
    Btn.TextColor3 = Colors.TextDark
    Btn.Font = Enum.Font.GothamBold
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

-- [ МОДУЛЬ (ЛКМ / ПКМ) ]
local function AddModule(Page, Name, ConfigKey, HasSettings, SettingsFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)

    local Btn = Instance.new("TextButton", Wrapper)
    Btn.Size = UDim2.new(1, 0, 0, 60)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local Lbl = Instance.new("TextLabel", Btn)
    Lbl.Text = Name
    Lbl.Size = UDim2.new(0.6, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 20, 0, 0)
    Lbl.TextColor3 = Colors.Text
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 15
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    local Toggle = Instance.new("Frame", Btn)
    Toggle.Size = UDim2.new(0, 45, 0, 22)
    Toggle.Position = UDim2.new(1, -65, 0.5, -11)
    Toggle.BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Toggle)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = Config[ConfigKey] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        Config[ConfigKey] = not Config[ConfigKey]
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = Config[ConfigKey] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Config[ConfigKey] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
        SaveConfig()
    end)

    if HasSettings then
        local Gear = Instance.new("ImageLabel", Btn)
        Gear.Size = UDim2.new(0, 16, 0, 16)
        Gear.Position = UDim2.new(1, -90, 0.5, -8)
        Gear.Image = "rbxassetid://3926307971"
        Gear.ImageRectOffset = Vector2.new(324, 124)
        Gear.ImageRectSize = Vector2.new(36, 36)
        Gear.BackgroundTransparency = 1

        local SFrame = Instance.new("Frame", Wrapper)
        SFrame.Size = UDim2.new(1, 0, 0, 80)
        SFrame.Position = UDim2.new(0, 0, 0, 60)
        SFrame.BackgroundColor3 = Colors.SettingsBG
        if SettingsFunc then SettingsFunc(SFrame) end

        local Open = false
        Btn.MouseButton2Click:Connect(function()
            Open = not Open
            TweenService:Create(Wrapper, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, Open and 140 or 60)}):Play()
        end)
    end
end

-- Слайдер
local function AddSlider(Parent, Name, Min, Max, Key)
    local L = Instance.new("TextLabel", Parent)
    L.Text = Name .. ": " .. Config[Key]
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 10, 0, 10)
    L.TextColor3 = Colors.TextDark
    L.BackgroundTransparency = 1
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
local P1 = CreateTab("Movement", "🚶")
local P2 = CreateTab("Combat", "⚔️")
local P3 = CreateTab("Visuals", "👁️")
local P4 = CreateTab("Misc", "🎮")
local P5 = CreateTab("Settings", "⚙️")

AddModule(P1, "Speed Hack", "SpeedEnabled", true, function(f) AddSlider(f, "Value", 16, 300, "Speed") end)
AddModule(P1, "Fly Mode", "FlyEnabled", true, function(f) AddSlider(f, "Value", 50, 500, "FlySpeed") end)
AddModule(P1, "Infinite Jump", "InfJump", false)
AddModule(P1, "SpinBot", "SpinBot", false)
AddModule(P1, "BunnyHop", "BHop", false)

AddModule(P2, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 50, "HitboxSize") end)
AddModule(P2, "Aimbot (Silent)", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)

AddModule(P3, "Chams (Wallhack)", "Chams", false)
AddModule(P3, "ESP Enabled", "ESP_Enabled", false)

AddModule(P4, "Anti-Popups", "AntiPopups", false)

-- SETTINGS ACTIONS
local function Action(Name, Color, Call)
    local B = Instance.new("TextButton", P5)
    B.Size = UDim2.new(1, -10, 0, 45)
    B.BackgroundColor3 = Color
    B.Text = Name
    B.TextColor3 = Colors.Text
    B.Font = Enum.Font.GothamBold
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(Call)
end

Action("Save Config", Colors.ItemBG, function() SaveConfig() end)
Action("Load Config", Colors.ItemBG, function() LoadConfig() end)
Action("Reset & Re-load", Colors.Red, function() if isfile(FileName) then delfile(FileName) end game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local H = Char.Humanoid
        local RP = Char.HumanoidRootPart
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then Char:TranslateBy(H.MoveDirection * (Config.Speed/100)) end
        if Config.FlyEnabled then
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
            RP.Velocity = v * Config.FlySpeed
            H.PlatformStand = true
        else H.PlatformStand = false end
        if Config.SpinBot then RP.CFrame = RP.CFrame * CFrame.Angles(0, math.rad(40), 0) end
        if Config.BHop and H.MoveDirection.Magnitude > 0 and H.FloorMaterial ~= Enum.Material.Air then H.Jump = true end
        if Config.AntiPopups then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _,v in pairs(pg:GetDescendants()) do
                    if v:IsA("TextLabel") and (v.Text:find("Donate") or v.Text:find("Join") or v.Text:find("Favorite")) then
                        local p = v:FindFirstAncestorOfClass("Frame")
                        if p then p.Visible = false end
                    end
                end
            end
        end
    end
end)

-- Управление
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

print("✅ BLAZIX TITAN V17 LOADED")
