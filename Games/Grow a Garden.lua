--[[
    BLAZIX HUB V12: TITAN EDITION (FIXED & STEALTH)
    • ЛКМ -> ВКЛ/ВЫКЛ
    • ПКМ -> НАСТРОЙКИ (Slider)
    • Right Control -> СКРЫТЬ/ПОКАЗАТЬ
]]

local s = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local lp = s.Players.LocalPlayer
local mouse = lp:GetMouse()

-- [ КОНФИГУРАЦИЯ ]
local Config = {
    SpeedEnabled = false, Speed = 16,
    FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50,
    InfJump = false, Noclip = false,
    Aimbot = false, AimFOV = 100,
    Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    Gravity = 196.2, AntiAFK = true
}

local Colors = {
    Main = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    ItemBG = Color3.fromRGB(35, 35, 42),
    SettingsBG = Color3.fromRGB(28, 28, 35)
}

-- [ ЗАЩИТА GUI ]
local target = s.RunService:IsStudio() and lp.PlayerGui or (s.CoreGui:FindFirstChild("RobloxGui") or s.CoreGui)
local sg = Instance.new("ScreenGui", target)
sg.Name = "SystemCheck_" .. math.random(1000, 9999) -- Рандомное имя для обхода сканеров
sg.IgnoreGuiInset = true

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Colors.Accent
stroke.Thickness = 1.5

-- Шапка (Перетаскивание)
local Head = Instance.new("Frame", Main)
Head.Size = UDim2.new(1, 0, 0, 50)
Head.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Head)

local Title = Instance.new("TextLabel", Head)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> V12"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- Контейнеры
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 180, 1, -50)
Side.Position = UDim2.new(0, 0, 0, 50)
Side.BackgroundColor3 = Colors.Sidebar

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -200, 1, -70)
Container.Position = UDim2.new(0, 190, 0, 60)
Container.BackgroundTransparency = 1

local Pages = {}

-- [ ФУНКЦИИ КОНСТРУКТОРА ]
local function CreateSlider(parent, name, min, max, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -20, 0, 40)
    f.BackgroundTransparency = 1
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = name .. ": " .. Config[key]
    l.TextColor3 = Color3.fromRGB(200, 200, 200)
    l.Font = "Gotham"
    l.TextSize = 12
    l.BackgroundTransparency = 1
    
    local bg = Instance.new("TextButton", f)
    bg.Size = UDim2.new(1, 0, 0, 4)
    bg.Position = UDim2.new(0, 0, 0, 25)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bg.Text = ""
    Instance.new("UICorner", bg)
    
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((Config[key]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", fill)
    
    bg.MouseButton1Down:Connect(function()
        local con; con = s.RunService.RenderStepped:Connect(function()
            local p = math.clamp((s.UserInputService:GetMouseLocation().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0)
            Config[key] = math.floor(min + (max - min) * p)
            l.Text = name .. ": " .. Config[key]
        end)
        s.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then con:Disconnect() end end)
    end)
end

local function AddModule(page, name, key, hasSet, setFunc)
    local wrap = Instance.new("Frame", page)
    wrap.Size = UDim2.new(1, -10, 0, 50)
    wrap.BackgroundColor3 = Colors.ItemBG
    wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap)
    
    local btn = Instance.new("TextButton", wrap)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundTransparency = 1
    btn.Text = "     " .. name
    btn.TextColor3 = Colors.Text
    btn.Font = "GothamBold"
    btn.TextSize = 14
    btn.TextXAlignment = "Left"
    
    local tog = Instance.new("Frame", btn)
    tog.Size = UDim2.new(0, 36, 0, 18)
    tog.Position = UDim2.new(1, -50, 0.5, -9)
    tog.BackgroundColor3 = Config[key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", tog).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        s.TweenService:Create(tog, TweenInfo.new(0.2), {BackgroundColor3 = Config[key] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
    end)
    
    if hasSet then
        local sf = Instance.new("Frame", wrap)
        sf.Size = UDim2.new(1, 0, 0, 70)
        sf.Position = UDim2.new(0, 0, 0, 50)
        sf.BackgroundColor3 = Colors.SettingsBG
        if setFunc then setFunc(sf) end
        
        local exp = false
        btn.MouseButton2Click:Connect(function()
            exp = not exp
            s.TweenService:Create(wrap, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, exp and 120 or 50)}):Play()
        end)
    end
end

local function CreateTab(name)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    local tbtn = Instance.new("TextButton", Side)
    tbtn.Size = UDim2.new(1, -20, 0, 40)
    tbtn.Position = UDim2.new(0, 10, 0, #Side:GetChildren()*45)
    tbtn.BackgroundColor3 = Colors.Main
    tbtn.Text = name
    tbtn.TextColor3 = Colors.Text
    tbtn.Font = "GothamBold"
    Instance.new("UICorner", tbtn)
    
    tbtn.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
    end)
    Pages[name] = p
    return p
end

-- [ НАПОЛНЕНИЕ ]
local T1 = CreateTab("Movement")
local T2 = CreateTab("Combat")

AddModule(T1, "Speed Stealth", "SpeedEnabled", true, function(f) CreateSlider(f, "Power", 16, 200, "Speed") end)
AddModule(T1, "Fly Safe", "FlyEnabled", true, function(f) CreateSlider(f, "Speed", 20, 300, "FlySpeed") end)
AddModule(T2, "Hitbox", "Hitbox", true, function(f) CreateSlider(f, "Size", 2, 30, "HitboxSize") end)

-- [ ЛОГИКА ОБХОДА (STEALTH) ]
s.RunService.Heartbeat:Connect(function(dt)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char.Humanoid

    -- Speed: Вместо телепортов используем плавное смещение по вектору движения
    if Config.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed/60))
    end

    -- Fly: Удержание позиции без BodyVelocity (палится античитом)
    if Config.FlyEnabled then
        hrp.Velocity = Vector3.new(0, 1.2, 0) -- Обман гравитации
        if s.UserInputService:IsKeyDown(Enum.KeyCode.W) then hrp.CFrame = hrp.CFrame + (workspace.CurrentCamera.CFrame.LookVector * (Config.FlySpeed/60)) end
    end
    
    workspace.Gravity = Config.Gravity
end)

-- Перетаскивание
local drag, dstart, spos
Head.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true dstart = i.Position spos = Main.Position end end)
s.UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and drag then
    local delta = i.Position - dstart
    Main.Position = UDim2.new(spos.X.Scale, spos.X.Offset + delta.X, spos.Y.Scale, spos.Y.Offset + delta.Y)
end end)
s.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

-- Хоткей
s.UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

Pages["Movement"].Visible = true
print("✅ BLAZIX TITAN V12 STEALTH LOADED")
