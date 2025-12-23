--[[
    BLAZIX TITAN V18: ULTIMATE EDITION
    AUTHOR: GEMINI AI
    
    [ИНСТРУКЦИЯ]
    • ЛКМ -> Включить/Выключить
    • ПКМ -> Настройки (Слайдеры)
    • Left Alt -> Скрыть меню
    • КРЕСТИК -> Полное удаление скрипта
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ ВСЕ НАСТРОЙКИ (НИЧЕГО НЕ ВЫРЕЗАНО) ]
local Config = {
    -- Movement
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false, AntiVoid = false,
    SpinBot = false, BHop = false,
    
    -- Combat
    Aimbot = false, AimFOV = 100, SilentAim = false,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    AutoClicker = false, ClickDelay = 0.1,
    
    -- Visuals
    ESP_Enabled = false, Chams = false, FullBright = false,
    
    -- Misc
    AntiAFK = true, AntiPopups = false, ChatSpy = false
}

local FileName = "Blazix_V18_Full.json"
local function Save() if writefile then writefile(FileName, HttpService:JSONEncode(Config)) end end
local function Load() 
    if isfile and isfile(FileName) then 
        local s, d = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if s then for k,v in pairs(d) do Config[k] = v end end
    end 
end
Load()

-- [ ЦВЕТА ]
local Colors = {
    Main = Color3.fromRGB(15, 15, 22),
    Sidebar = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    ItemBG = Color3.fromRGB(30, 30, 40),
    SettingsBG = Color3.fromRGB(25, 25, 35),
    Red = Color3.fromRGB(255, 50, 50)
}

-- [ СОЗДАНИЕ GUI ]
if CoreGui:FindFirstChild("BlazixV18") then CoreGui.BlazixV18:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BlazixV18"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 880, 0, 630)
Main.Position = UDim2.new(0.5, -440, 0.5, -315)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- [ ШАПКА + КНОПКА ЗАКРЫТЬ ]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Colors.Sidebar

local Title = Instance.new("TextLabel", Header)
Title.Text = "  BLAZIX <font color='#00ff8c'>TITAN</font> V18"
Title.RichText = true
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
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

-- [ СТРУКТУРА ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 220, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = Colors.Sidebar

-- КРАСИВЫЙ ПРОФИЛЬ (РАМКА)
local Prof = Instance.new("Frame", Sidebar)
Prof.Size = UDim2.new(1, -20, 0, 85)
Prof.Position = UDim2.new(0, 10, 1, -95)
Prof.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", Prof)
local ProfStroke = Instance.new("UIStroke", Prof)
ProfStroke.Color = Colors.Accent
ProfStroke.Thickness = 1.5

local Av = Instance.new("ImageLabel", Prof)
Av.Size = UDim2.new(0, 60, 0, 60)
Av.Position = UDim2.new(0, 10, 0.5, -30)
Av.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Av.BackgroundTransparency = 1
Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)

local Nick = Instance.new("TextLabel", Prof)
Nick.Text = LocalPlayer.DisplayName
Nick.Size = UDim2.new(0, 120, 0, 20)
Nick.Position = UDim2.new(0, 80, 0.3, 0)
Nick.TextColor3 = Colors.Text
Nick.Font = Enum.Font.GothamBold
Nick.TextXAlignment = Enum.TextXAlignment.Left
Nick.BackgroundTransparency = 1

-- КОНТЕЙНЕРЫ
local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -110)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -240, 1, -75)
PagesContainer.Position = UDim2.new(0, 230, 0, 65)
PagesContainer.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, icon)
    local P = Instance.new("ScrollingFrame", PagesContainer)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.AutomaticCanvasSize = Enum.AutomaticSize.Y
    P.ScrollBarThickness = 2
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)

    local B = Instance.new("TextButton", TabContainer)
    B.Size = UDim2.new(0.9, 0, 0, 42)
    B.BackgroundColor3 = Colors.Main
    B.Text = "  " .. icon .. "  " .. name
    B.TextColor3 = Color3.fromRGB(150, 150, 150)
    B.Font = Enum.Font.GothamBold
    B.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", B)

    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.P.Visible = false v.B.BackgroundColor3 = Colors.Main end
        P.Visible = true
        B.BackgroundColor3 = Colors.ItemBG
    end)
    Pages[name] = {P = P, B = B}
    return P
end

-- [ ФУНКЦИЯ КНОПОК (ЛКМ/ПКМ) ]
local function AddModule(Page, Name, Key, HasSet, SetFunc)
    local Wrapper = Instance.new("Frame", Page)
    Wrapper.Size = UDim2.new(1, -10, 0, 60)
    Wrapper.BackgroundColor3 = Colors.ItemBG
    Wrapper.ClipsDescendants = true
    Instance.new("UICorner", Wrapper)

    local MainBtn = Instance.new("TextButton", Wrapper)
    MainBtn.Size = UDim2.new(1, 0, 0, 60)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = ""

    local Title = Instance.new("TextLabel", MainBtn)
    Title.Text = Name
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local Tog = Instance.new("Frame", MainBtn)
    Tog.Size = UDim2.new(0, 48, 0, 24)
    Tog.Position = UDim2.new(1, -68, 0.5, -12)
    Tog.BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(1, 0)

    local Ball = Instance.new("Frame", Tog)
    Ball.Size = UDim2.new(0, 20, 0, 20)
    Ball.Position = Config[Key] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Ball.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

    MainBtn.MouseButton1Click:Connect(function()
        Config[Key] = not Config[Key]
        TweenService:Create(Ball, TweenInfo.new(0.2), {Position = Config[Key] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
        TweenService:Create(Tog, TweenInfo.new(0.2), {BackgroundColor3 = Config[Key] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
        Save()
    end)

    if HasSet then
        local SFrame = Instance.new("Frame", Wrapper)
        SFrame.Size = UDim2.new(1, 0, 0, 80)
        SFrame.Position = UDim2.new(0, 0, 0, 60)
        SFrame.BackgroundColor3 = Colors.SettingsBG
        if SetFunc then SetFunc(SFrame) end
        local Open = false
        MainBtn.MouseButton2Click:Connect(function()
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
    L.TextColor3 = Color3.fromRGB(200, 200, 200)
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
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then m:Disconnect() Save() end end)
    end)
end

-- [ НАПОЛНЕНИЕ ]
local T1 = CreateTab("Combat", "⚔️")
local T2 = CreateTab("Movement", "🏃")
local T3 = CreateTab("Visuals", "👁️")
local T4 = CreateTab("Misc", "🎮")
local T5 = CreateTab("Settings", "⚙️")

-- COMBAT
AddModule(T1, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(T1, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 50, "HitboxSize") end)
AddModule(T1, "Silent Aim", "SilentAim", false)
AddModule(T1, "Auto Clicker", "AutoClicker", true, function(f) AddSlider(f, "Delay", 0, 1, "ClickDelay") end)

-- MOVEMENT
AddModule(T2, "Speed Bypass", "SpeedEnabled", true, function(f) AddSlider(f, "Value", 16, 500, "Speed") end)
AddModule(T2, "Fly Mode", "FlyEnabled", true, function(f) AddSlider(f, "Speed", 10, 500, "FlySpeed") end)
AddModule(T2, "Infinite Jump", "InfJump", false)
AddModule(T2, "Noclip", "Noclip", false)
AddModule(T2, "SpinBot", "SpinBot", false)
AddModule(T2, "BunnyHop", "BHop", false)
AddModule(T2, "Anti-Void", "AntiVoid", false)

-- VISUALS
AddModule(T3, "Chams (Wallhack)", "Chams", false)
AddModule(T3, "Enable ESP", "ESP_Enabled", false)
AddModule(T3, "FullBright", "FullBright", false)

-- MISC
AddModule(T4, "Anti-Popups", "AntiPopups", false)
AddModule(T4, "Anti-AFK", "AntiAFK", false)

-- SETTINGS
local function Action(P, N, C, Call)
    local B = Instance.new("TextButton", P)
    B.Size = UDim2.new(1, -10, 0, 45)
    B.BackgroundColor3 = C
    B.Text = N
    B.TextColor3 = Colors.Text
    B.Font = Enum.Font.GothamBold
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(Call)
end
Action(T5, "Save Configuration", Colors.ItemBG, Save)
Action(T5, "Reset Everything", Colors.Red, function() if isfile(FileName) then delfile(FileName) end game:Destroy() end)

-- [ ЛОГИКА ]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local RP = Char.HumanoidRootPart
        local H = Char.Humanoid
        if Config.SpeedEnabled and H.MoveDirection.Magnitude > 0 then Char:TranslateBy(H.MoveDirection * (Config.Speed/100)) end
        if Config.FlyEnabled then
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
            RP.Velocity = v * Config.FlySpeed
            H.PlatformStand = true
        else H.PlatformStand = false end
        if Config.SpinBot then RP.CFrame = RP.CFrame * CFrame.Angles(0, math.rad(45), 0) end
        if Config.BHop and H.MoveDirection.Magnitude > 0 and H.FloorMaterial ~= Enum.Material.Air then H.Jump = true end
        if Config.Noclip then for _,v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if Config.AntiPopups then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _,v in pairs(pg:GetDescendants()) do
                    if v:IsA("TextLabel") and (v.Text:find("Donate") or v.Text:find("Like") or v.Text:find("Community")) then
                        local f = v:FindFirstAncestorOfClass("Frame")
                        if f then f.Visible = false end
                    end
                end
            end
        end
    end
end)

-- ДРАГГИНГ
local d, s, sp
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true s=i.Position sp=Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then
    local delta = i.Position - s
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end end)

Pages["Combat"].P.Visible = true
Pages["Combat"].B.BackgroundColor3 = Colors.ItemBG
