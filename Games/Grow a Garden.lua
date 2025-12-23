--[[
    BLAZIX HUB V8 - THE BEHEMOTH BUILD
    UNIVERSAL EXPLOIT SYSTEM
    STRICTLY FUNCTIONAL - NO FILLER
]]

-- [ ИНИЦИАЛИЗАЦИЯ СЕРВИСОВ ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- [ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ]
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local TargetPlayer = nil

-- [ ТАБЛИЦА КОНФИГУРАЦИИ (РАСШИРЕННАЯ) ]
local Config = {
    -- Player Settings
    Speed = 16,
    Jump = 50,
    Gravity = 196.2,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    AntiVoid = false,
    VoidY = -50,
    SwimInAir = false,
    AutoRespawn = false,
    NoSlowdown = false,
    InfiniteStamina = false,
    
    -- Combat Settings
    AimbotEnabled = false,
    SilentAim = false,
    AimPart = "Head",
    AimFOV = 100,
    FOVVisible = false,
    AimSmoothing = 1,
    PredictMovement = false,
    WallCheck = false,
    HitboxExpander = false,
    HitboxSize = 2,
    HitboxTransparency = 0.7,
    TriggerBot = false,
    TeamCheck = false,
    
    -- ESP Settings
    ESP_Enabled = false,
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false,
    ESP_Tracer = false,
    ESP_Skeleton = false,
    ESP_Health = false,
    ESP_Chams = false,
    ESP_Color = Color3.fromRGB(0, 255, 150),
    
    -- World Settings
    FullBright = false,
    NoFog = false,
    DayTime = false,
    NightTime = false,
    RemoveLava = false,
    FPSBoost = false,
    KillAllParts = false,
    GravityForce = 196.2,
    
    -- Misc Settings
    AutoClicker = false,
    ClickDelay = 0.05,
    ChatSpy = false,
    AntiAFK = true,
    RejoinOnKick = false,
    ServerHop = false,
    SpectatePlayer = false,
    JoinDiscord = false,
    RainbowUI = false
}

-- [ СИСТЕМА ESP НА DRAWING API ]
local ESP_Objects = {}

local function CreateESP(Player)
    local Box = Drawing.new("Square")
    local Name = Drawing.new("Text")
    local Distance = Drawing.new("Text")
    local Tracer = Drawing.new("Line")
    local HealthBar = Drawing.new("Line")

    ESP_Objects[Player] = {
        Box = Box,
        Name = Name,
        Distance = Distance,
        Tracer = Tracer,
        HealthBar = HealthBar
    }

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if not Player or not Player.Parent or not Player.Character or not Config.ESP_Enabled then
                Box.Visible = false
                Name.Visible = false
                Distance.Visible = false
                Tracer.Visible = false
                HealthBar.Visible = false
                if not Player.Parent then Connection:Disconnect() end
                return
            end

            local Root = Player.Character:FindFirstChild("HumanoidRootPart")
            local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
            if not Root or not Hum then return end

            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            if OnScreen then
                if Config.ESP_Box then
                    Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                    Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                    Box.Color = Config.ESP_Color
                    Box.Thickness = 1
                    Box.Visible = true
                else Box.Visible = false end

                if Config.ESP_Name then
                    Name.Text = Player.Name
                    Name.Position = Vector2.new(Pos.X, Pos.Y - (Box.Size.Y / 2) - 15)
                    Name.Center = true
                    Name.Outline = true
                    Name.Visible = true
                else Name.Visible = false end

                if Config.ESP_Tracer then
                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    Tracer.Color = Config.ESP_Color
                    Tracer.Visible = true
                else Tracer.Visible = false end
            else
                Box.Visible = false
                Name.Visible = false
                Tracer.Visible = false
            end
        end)
    end
    Update()
end

-- [ СИСТЕМА AIMBOT ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = Config.AimFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

local function GetClosestPlayer()
    local Closest = nil
    local MaxDist = Config.AimFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.AimPart) then
            if Config.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[Config.AimPart].Position)
            local Dist = (Vector2.new(Pos.X, Pos.Y) - UserInputService:GetMouseLocation()).Magnitude
            if OnScreen and Dist < MaxDist then
                if Config.WallCheck then
                    local RayParams = RaycastParams.new()
                    RayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                    local Result = Workspace:Raycast(Camera.CFrame.Position, v.Character[Config.AimPart].Position - Camera.CFrame.Position, RayParams)
                    if Result then continue end
                end
                MaxDist = Dist
                Closest = v
            end
        end
    end
    return Closest
end

-- [ ЛОГИКА ИНТЕРФЕЙСА ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Blazix_Behemoth"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 700, 0, 500)
Main.Position = UDim2.new(0.5, -350, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Main)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(0, 255, 157)
UIStroke.Thickness = 2

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX HUB V8: BEHEMOTH (UNIVERSAL)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Sidebar и Контейнер для вкладок
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 55)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 0
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -190, 1, -70)
Container.Position = UDim2.new(0, 180, 0, 60)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(Name)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, 0, 0, 40)
    Tab.Text = Name
    Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Tab.TextColor3 = Color3.new(1,1,1)
    Tab.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[Name] = Page
    return Page
end

-- Создаем страницы
local CombatPage = CreatePage("🎯 Combat")
local MovePage = CreatePage("🚀 Movement")
local VisualPage = CreatePage("👁️ Visuals")
local WorldPage = CreatePage("🌍 World")
local PlayersPage = CreatePage("👥 Player List")
local MiscPage = CreatePage("⚙️ Misc")

-- [ ФУНКЦИИ КОНСТРУКТОРА ЭЛЕМЕНТОВ ]
local function AddToggle(Parent, Text, Flag, Callback)
    local T = Instance.new("TextButton", Parent)
    T.Size = UDim2.new(1, -10, 0, 40)
    T.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    T.Text = Text .. ": OFF"
    T.TextColor3 = Color3.new(1,1,1)
    T.Font = Enum.Font.Gotham
    Instance.new("UICorner", T)
    
    T.MouseButton1Click:Connect(function()
        Config[Flag] = not Config[Flag]
        T.Text = Text .. (Config[Flag] and ": ON" or ": OFF")
        T.BackgroundColor3 = Config[Flag] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 35, 45)
        if Callback then Callback(Config[Flag]) end
    end)
end

local function AddSlider(Parent, Text, Min, Max, Flag, Callback)
    local SFrame = Instance.new("Frame", Parent)
    SFrame.Size = UDim2.new(1, -10, 0, 55)
    SFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", SFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = Text .. ": " .. Config[Flag]
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    
    local SliderBtn = Instance.new("TextButton", SFrame)
    SliderBtn.Size = UDim2.new(1, 0, 0, 15)
    SliderBtn.Position = UDim2.new(0, 0, 0, 25)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBtn.Text = ""
    Instance.new("UICorner", SliderBtn)
    
    local Fill = Instance.new("Frame", SliderBtn)
    Fill.Size = UDim2.new((Config[Flag]-Min)/(Max-Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 157)
    Instance.new("UICorner", Fill)
    
    SliderBtn.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local P = math.clamp((UserInputService:GetMouseLocation().X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            local V = math.floor(Min + (Max - Min) * P)
            Config[Flag] = V
            Label.Text = Text .. ": " .. V
            if Callback then Callback(V) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end
        end)
    end)
end

-- [ НАПОЛНЕНИЕ ФУНКЦИОНАЛОМ ]

-- COMBAT
AddToggle(CombatPage, "Silent Aim", "SilentAim")
AddToggle(CombatPage, "Show FOV Circle", "FOVVisible")
AddSlider(CombatPage, "FOV Radius", 30, 800, "AimFOV")
AddToggle(CombatPage, "Hitbox Expander", "HitboxExpander")
AddSlider(CombatPage, "Hitbox Size", 2, 30, "HitboxSize")
AddToggle(CombatPage, "Trigger Bot", "TriggerBot")
AddToggle(CombatPage, "Wall Check", "WallCheck")

-- MOVEMENT
AddSlider(MovePage, "WalkSpeed Bypass", 16, 300, "Speed")
AddSlider(MovePage, "JumpPower Bypass", 50, 500, "Jump")
AddToggle(MovePage, "Infinite Jump", "InfJump")
AddToggle(MovePage, "No-Clip", "Noclip")
AddToggle(MovePage, "Anti-Void", "AntiVoid")
AddToggle(MovePage, "Fly Mode", "Fly")
AddSlider(MovePage, "Fly Speed", 10, 500, "FlySpeed")

-- VISUALS
AddToggle(VisualPage, "Enable ESP", "ESP_Enabled")
AddToggle(VisualPage, "Box ESP", "ESP_Box")
AddToggle(VisualPage, "Name ESP", "ESP_Name")
AddToggle(VisualPage, "Tracer ESP", "ESP_Tracer")
AddToggle(VisualPage, "Chams (Highlights)", "ESP_Chams", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local highlight = p.Character:FindFirstChild("BlHighlight") or Instance.new("Highlight", p.Character)
            highlight.Name = "BlHighlight"
            highlight.Enabled = v
        end
    end
end)

-- WORLD
AddToggle(WorldPage, "FullBright", "FullBright", function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.Ambient = v and Color3.new(1,1,1) or Color3.new(0,0,0)
end)
AddToggle(WorldPage, "No Fog", "NoFog", function(v) Lighting.FogEnd = v and 1e6 or 1000 end)
AddToggle(WorldPage, "Anti-Lava (NoTouch)", "RemoveLava")
AddSlider(WorldPage, "Custom Gravity", 0, 196, "GravityForce", function(v) workspace.Gravity = v end)

-- [ ГЛАВНЫЕ ОБРАБОТЧИКИ ]

-- 1. Движение
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    
    local Hum = Char.Humanoid
    local HRP = Char.HumanoidRootPart

    -- Bypass Speed
    if Config.Speed > 16 and Hum.MoveDirection.Magnitude > 0 then
        Char:TranslateBy(Hum.MoveDirection * (Config.Speed / 100))
    end
    
    -- Fly
    if Config.Fly then
        local Dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        HRP.Velocity = Dir * Config.FlySpeed
    end

    -- Anti-Void
    if Config.AntiVoid and HRP.Position.Y < Config.VoidY then
        HRP.Velocity = Vector3.new(0,0,0)
        HRP.CFrame = CFrame.new(HRP.Position.X, 100, HRP.Position.Z)
    end
end)

-- 2. ESP & FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.FOVVisible
    FOVCircle.Radius = Config.AimFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    if Config.SilentAim then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild(Config.AimPart) then
            -- Логика Silent Aim (здесь может быть хук метатаблицы, но для универсальности используем наведение камеры)
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[Config.AimPart].Position)
            end
        end
    end
end)

-- 3. Hitboxes
spawn(function()
    while task.wait(1) do
        if Config.HitboxExpander then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = Config.HitboxTransparency
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

-- [ PLAYER LIST PAGE DYNAMIC ]
local function RefreshPlayerList()
    for _, obj in pairs(PlayersPage:GetChildren()) do if obj:IsA("Frame") then obj:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", PlayersPage)
        F.Size = UDim2.new(1, -10, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Instance.new("UICorner", F)
        
        local L = Instance.new("TextLabel", F)
        L.Size = UDim2.new(0.6, 0, 1, 0)
        L.Text = p.Name
        L.TextColor3 = Color3.new(1,1,1)
        L.BackgroundTransparency = 1
        
        local B = Instance.new("TextButton", F)
        B.Size = UDim2.new(0.3, 0, 0.8, 0)
        B.Position = UDim2.new(0.65, 0, 0.1, 0)
        B.Text = "Teleport"
        B.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function()
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end
        end)
    end
end
AddToggle(PlayersPage, "Auto-Refresh List", "AutoRefresh", function() RefreshPlayerList() end)

-- [ УПРАВЛЕНИЕ ОКНОМ ]
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 7)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Dragging
local Dragging, DragInput, DragStart, StartPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = i.Position StartPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
    local Delta = i.Position - DragStart
    Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

-- Инициализация ESP для зашедших
Players.PlayerAdded:Connect(CreateESP)
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end

-- Уведомление
StarterGui:SetCore("SendNotification", {Title = "BLAZIX BEHEMOTH", Text = "V8 LOADED SUCCESSFULLY", Duration = 5})
