-- BLAZIX HUB: NEON UNIVERSAL (v3.0)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Переменные функций
local Config = {
    Speed = 16,
    Jump = 50,
    Gravity = 196.2,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    FullBright = false,
    AntiAFK = true,
    AutoClicker = false
}

-- Anti-AFK (Чтобы не вылетало через 20 минут)
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- СОЗДАНИЕ ИНТЕРФЕЙСА
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixNeon"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Мини-кнопка открытия
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
OpenBtn.Text = "B"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 25
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Thickness = 2

-- Главный фрейм
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 200)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00FFC8'>HUB</font> REBORN"
Title.RichText = true
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Кнопки в хедере
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 10)
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Parent = Header
Instance.new("UICorner", Close)

local Hide = Instance.new("TextButton", Header)
Hide.Size = UDim2.new(0, 30, 0, 30)
Hide.Position = UDim2.new(1, -80, 0, 10)
Hide.Text = "-"
Hide.TextColor3 = Color3.new(1, 1, 1)
Hide.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Hide.Parent = Header
Instance.new("UICorner", Hide)

-- Вкладки (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 55)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -160, 1, -70)
Container.Position = UDim2.new(0, 150, 0, 60)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    p.Parent = Container
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(150, 150, 150)
    b.Font = Enum.Font.GothamMedium
    b.Parent = Sidebar
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        for _, page in pairs(Pages) do page.Visible = false end
        p.Visible = true
    end)
    Pages[name] = p
    return p
end

-- Создаем страницы
local PlayerPg = CreatePage("👤 Player")
local MovePg = CreatePage("🚀 Movement")
local VisPg = CreatePage("👁️ Visuals")
local WorldPg = CreatePage("🌍 World")
local MiscPg = CreatePage("⚙️ Misc")
PlayerPg.Visible = true

-- Кастомные элементы (Toggle & Slider)
local function AddToggle(parent, text, default, callback)
    local state = default
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 40)
    b.BackgroundColor3 = state and Color3.fromRGB(0, 100, 80) or Color3.fromRGB(25, 25, 30)
    b.Text = text .. (state and ": ON" or ": OFF")
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.Parent = parent
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 100, 80) or Color3.fromRGB(25, 25, 30)
        b.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -5, 0, 55)
    f.BackgroundTransparency = 1
    f.Parent = parent
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 20)
    t.Text = text .. ": " .. default
    t.TextColor3 = Color3.new(1, 1, 1)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.Gotham
    t.Parent = f
    
    local s = Instance.new("TextButton")
    s.Size = UDim2.new(1, 0, 0, 10)
    s.Position = UDim2.new(0, 0, 0, 30)
    s.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    s.Text = ""
    s.Parent = f
    Instance.new("UICorner", s)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    fill.Parent = s
    Instance.new("UICorner", fill)
    
    s.MouseButton1Down:Connect(function()
        local move = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local per = math.clamp((input.Position.X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(per, 0, 1, 0)
                local val = math.floor(min + (max - min) * per)
                t.Text = text .. ": " .. val
                callback(val)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
        end)
    end)
end

-- ЛОГИКА ФУНКЦИЙ (Movement & Global)
-- 1. Fly System
local function StartFly()
    local char = LocalPlayer.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bodyVel = Instance.new("BodyVelocity", hrp)
    bodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    
    RunService.RenderStepped:Connect(function()
        if Config.Fly then
            local dir = Vector3.zero
            local cam = workspace.CurrentCamera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
            bodyVel.Velocity = dir * Config.FlySpeed
        else
            bodyVel:Destroy()
        end
    end)
end

-- 2. Noclip
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 3. Speed/Jump/InfJump
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = Config.Speed
        hum.JumpPower = Config.Jump
        if Config.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(hum.MoveDirection.X * Config.Speed, 40, hum.MoveDirection.Z * Config.Speed)
        end
    end
end)

-- НАПОЛНЕНИЕ
-- Player
AddSlider(PlayerPg, "WalkSpeed", 16, 250, 16, function(v) Config.Speed = v end)
AddSlider(PlayerPg, "JumpPower", 50, 300, 50, function(v) Config.Jump = v end)
AddToggle(PlayerPg, "Infinite Jump", false, function(v) Config.InfJump = v end)
AddToggle(PlayerPg, "Noclip", false, function(v) Config.Noclip = v end)

-- Movement
AddToggle(MovePg, "Enable Fly", false, function(v) Config.Fly = v if v then StartFly() end end)
AddSlider(MovePg, "Fly Speed", 10, 300, 50, function(v) Config.FlySpeed = v end)
AddToggle(MovePg, "AutoClicker", false, function(v) 
    Config.AutoClicker = v
    spawn(function()
        while Config.AutoClicker do
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,0)
            wait(0.01)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,0)
            wait(0.01)
        end
    end)
end)

-- World
AddSlider(WorldPg, "Gravity", 0, 196, 196, function(v) workspace.Gravity = v end)
AddToggle(WorldPg, "FullBright", false, function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- Visuals
AddToggle(VisPg, "Player ESP", false, function(v)
    Config.ESP = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("BlHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "BlHighlight"
            h.Enabled = v
            h.FillColor = Color3.fromRGB(0, 255, 200)
        end
    end
end)

-- Misc
local btnRejoin = Instance.new("TextButton", MiscPg)
btnRejoin.Size = UDim2.new(1, -5, 0, 40)
btnRejoin.Text = "Rejoin Server"
btnRejoin.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnRejoin.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnRejoin)
btnRejoin.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- УПРАВЛЕНИЕ МЕНЮ (Drag & Hide)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Hide.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- Перетаскивание
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
