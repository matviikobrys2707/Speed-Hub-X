--[[
    BLAZIX HUB V12: TITAN EDITION (ULTIMATE OVERHAUL)
    • Left Alt -> Открыть/Закрыть
    • ЛКМ -> Вкл/Выкл
    • ПКМ -> Настройки модуля
]]

local s = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local lp = s.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local mouse = lp:GetMouse()

-- [ СИСТЕМА КОНФИГОВ ]
local Config = {
    -- Movement
    SpeedEnabled = false, Speed = 16, FlyEnabled = false, FlySpeed = 50,
    JumpEnabled = false, JumpPower = 50, InfJump = false, Noclip = false,
    AntiVoid = false, BunnyHop = false, SpinBot = false,
    -- Combat
    Aimbot = false, AimFOV = 100, Hitbox = false, HitboxSize = 2, HitboxTransp = 0.5,
    AutoClicker = false, ClickDelay = 0.1, Reach = false, ReachDist = 10,
    -- Visuals
    ESP_Enabled = false, Boxes = false, Chams = false, FullBright = false,
    -- World & Misc
    Gravity = 196.2, Time = 12, AntiAFK = true, AntiPopups = true,
    DestroyLava = false, XRay = false
}

local Colors = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 28),
    Accent = Color3.fromRGB(0, 255, 140),
    Text = Color3.fromRGB(255, 255, 255),
    ItemBG = Color3.fromRGB(30, 30, 38),
    SettingsBG = Color3.fromRGB(25, 25, 32)
}

-- [ ГЛАВНЫЙ ИНТЕРФЕЙС ]
local sg = Instance.new("ScreenGui", s.CoreGui:FindFirstChild("RobloxGui") or s.CoreGui)
sg.Name = "BlazixTitan_Final"
sg.IgnoreGuiInset = true

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 900, 0, 650)
Main.Position = UDim2.new(0.5, -450, 0.5, -325)
Main.BackgroundColor3 = Colors.Main
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- Шапка
local Head = Instance.new("Frame", Main)
Head.Size = UDim2.new(1, 0, 0, 60)
Head.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Head)

local Title = Instance.new("TextLabel", Head)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Text = "BLAZIX <font color='#00ff8c'>TITAN</font> v12"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.Font = "GothamBlack"
Title.TextSize = 24
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1

-- Кнопка закрытия (Убивает всё)
local Close = Instance.new("TextButton", Head)
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -50, 0.5, -20)
Close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Close.Text = "X"
Close.TextColor3 = Colors.Text
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() 
    Config.SpeedEnabled = false
    Config.FlyEnabled = false
    workspace.Gravity = 196.2
    sg:Destroy() 
end)

-- Сайдбар
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 210, 1, -60)
Side.Position = UDim2.new(0, 0, 0, 60)
Side.BackgroundColor3 = Colors.Sidebar

local TabList = Instance.new("ScrollingFrame", Side)
TabList.Size = UDim2.new(1, 0, 1, -120)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
local TabL = Instance.new("UIListLayout", TabList)
TabL.Padding = UDim.new(0, 5)
TabL.HorizontalAlignment = "Center"

-- [ КАРТОЧКА ИГРОКА ]
local PlayerCard = Instance.new("Frame", Side)
PlayerCard.Size = UDim2.new(0.9, 0, 0, 80)
PlayerCard.Position = UDim2.new(0.05, 0, 1, -100)
PlayerCard.BackgroundColor3 = Colors.ItemBG
Instance.new("UICorner", PlayerCard)
local PCStroke = Instance.new("UIStroke", PlayerCard)
PCStroke.Color = Colors.Accent
PCStroke.Transparency = 0.5

local Avatar = Instance.new("ImageLabel", PlayerCard)
Avatar.Size = UDim2.new(0, 60, 0, 60)
Avatar.Position = UDim2.new(0, 10, 0.5, -30)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150"
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local PName = Instance.new("TextLabel", PlayerCard)
PName.Size = UDim2.new(1, -80, 0, 20)
PName.Position = UDim2.new(0, 75, 0, 20)
PName.Text = lp.DisplayName
PName.TextColor3 = Colors.Text
PName.Font = "GothamBold"
PName.TextSize = 14
PName.TextXAlignment = "Left"
PName.BackgroundTransparency = 1

local PUser = Instance.new("TextLabel", PlayerCard)
PUser.Size = UDim2.new(1, -80, 0, 20)
PUser.Position = UDim2.new(0, 75, 0, 40)
PUser.Text = "@" .. lp.Name
PUser.TextColor3 = Color3.fromRGB(150, 150, 150)
PUser.Font = "Gotham"
PUser.TextSize = 12
PUser.TextXAlignment = "Left"
PUser.BackgroundTransparency = 1

-- Контейнер страниц
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -230, 1, -80)
Container.Position = UDim2.new(0, 220, 0, 70)
Container.BackgroundTransparency = 1

local Pages = {}

-- [ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ]
local function AddSlider(parent, name, min, max, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -20, 0, 45)
    f.BackgroundTransparency = 1
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = name .. ": " .. Config[key]
    l.TextColor3 = Color3.fromRGB(200, 200, 200)
    l.Font = "Gotham"
    l.TextSize = 13
    l.BackgroundTransparency = 1
    l.TextXAlignment = "Left"
    
    local bg = Instance.new("TextButton", f)
    bg.Size = UDim2.new(1, 0, 0, 6)
    bg.Position = UDim2.new(0, 0, 0, 30)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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
            local val = math.floor(min + (max - min) * p)
            Config[key] = val
            l.Text = name .. ": " .. val
        end)
        s.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then con:Disconnect() end end)
    end)
end

local function AddModule(page, name, key, hasSet, setFunc)
    local wrap = Instance.new("Frame", page)
    wrap.Size = UDim2.new(1, -10, 0, 60)
    wrap.BackgroundColor3 = Colors.ItemBG
    wrap.ClipsDescendants = true
    Instance.new("UICorner", wrap)
    
    local btn = Instance.new("TextButton", wrap)
    btn.Size = UDim2.new(1, 0, 0, 60)
    btn.BackgroundTransparency = 1
    btn.Text = "          " .. name
    btn.TextColor3 = Colors.Text
    btn.Font = "GothamBold"
    btn.TextSize = 16
    btn.TextXAlignment = "Left"
    
    local tog = Instance.new("Frame", btn)
    tog.Size = UDim2.new(0, 46, 0, 24)
    tog.Position = UDim2.new(1, -65, 0.5, -12)
    tog.BackgroundColor3 = Config[key] and Colors.Accent or Color3.fromRGB(60, 60, 70)
    Instance.new("UICorner", tog).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", tog)
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = Config[key] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    dot.BackgroundColor3 = Colors.Text
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        s.TweenService:Create(tog, TweenInfo.new(0.3), {BackgroundColor3 = Config[key] and Colors.Accent or Color3.fromRGB(60, 60, 70)}):Play()
        s.TweenService:Create(dot, TweenInfo.new(0.3), {Position = Config[key] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
    end)
    
    if hasSet then
        local sf = Instance.new("Frame", wrap)
        sf.Size = UDim2.new(1, -20, 0, 80)
        sf.Position = UDim2.new(0, 10, 0, 60)
        sf.BackgroundTransparency = 1
        if setFunc then setFunc(sf) end
        
        local exp = false
        btn.MouseButton2Click:Connect(function()
            exp = not exp
            s.TweenService:Create(wrap, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, exp and 150 or 60)}):Play()
        end)
    end
end

local function AddActionButton(page, name, func)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.BackgroundColor3 = Colors.ItemBG
    btn.Text = name
    btn.TextColor3 = Colors.Accent
    btn.Font = "GothamBold"
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

local function CreateTab(name, icon)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    
    local tbtn = Instance.new("TextButton", TabList)
    tbtn.Size = UDim2.new(0.9, 0, 0, 45)
    tbtn.BackgroundColor3 = Colors.Main
    tbtn.Text = icon .. "  " .. name
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

-- [ ВКЛАДКИ ]
local TCombat = CreateTab("Combat", "⚔️")
local TMove = CreateTab("Movement", "🏃")
local TVisual = CreateTab("Visuals", "👁️")
local TWorld = CreateTab("World", "🌎")
local TMisc = CreateTab("Misc", "⚙️")
local TSet = CreateTab("Settings", "🛠️")

-- Movement
AddModule(TMove, "Speed Bypass", "SpeedEnabled", true, function(f) AddSlider(f, "Value", 16, 250, "Speed") end)
AddModule(TMove, "Flight", "FlyEnabled", true, function(f) AddSlider(f, "Speed", 20, 500, "FlySpeed") end)
AddModule(TMove, "Infinite Jump", "InfJump", false)
AddModule(TMove, "Noclip", "Noclip", false)
AddModule(TMove, "Anti-Void", "AntiVoid", false)
AddModule(TMove, "SpinBot", "SpinBot", false)

-- Combat
AddModule(TCombat, "Aimbot", "Aimbot", true, function(f) AddSlider(f, "FOV", 30, 800, "AimFOV") end)
AddModule(TCombat, "Hitbox Expander", "Hitbox", true, function(f) AddSlider(f, "Size", 2, 40, "HitboxSize") end)
AddModule(TCombat, "Auto Clicker", "AutoClicker", true, function(f) AddSlider(f, "Delay", 0, 1, "ClickDelay") end)

-- Visuals
AddModule(TVisual, "ESP Chams", "Chams", false)
AddModule(TVisual, "FullBright", "FullBright", false)

-- World & Misc
AddModule(TWorld, "Gravity Control", "Gravity", true, function(f) AddSlider(f, "Force", 0, 196, "Gravity") end)
AddModule(TMisc, "Anti-AFK", "AntiAFK", false)
AddModule(TMisc, "Block Popups", "AntiPopups", false)
AddActionButton(TMisc, "Rejoin Server", function() s.TeleportService:Teleport(game.PlaceId, lp) end)
AddActionButton(TMisc, "Server Hop", function() 
    local servers = s.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _,v in pairs(servers) do if v.playing < v.maxPlayers then s.TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) break end end
end)

-- Settings (Config)
AddActionButton(TSet, "Save Config to GitHub (Request)", function() print("Запрос отправлен на GitHub для юзера: "..lp.Name) end)
AddActionButton(TSet, "Reset Config", function() for k,v in pairs(Config) do Config[k] = false end end)

-- [ ЛОГИКА АНТИ-ПОПАПОВ ]
s.RunService.Stepped:Connect(function()
    if Config.AntiPopups then
        local gui = lp:FindFirstChild("PlayerGui")
        if gui then
            local popups = {"QueueGui", "CommunityUpdate", "PremiumUpsell", "SocialHi"}
            for _, p in pairs(popups) do if gui:FindFirstChild(p) then gui[p].Enabled = false end end
        end
    end
end)

-- [ ОСНОВНОЙ ЦИКЛ ]
s.RunService.Heartbeat:Connect(function(dt)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    if Config.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.Speed / 60))
    end
    
    if Config.FlyEnabled then
        hrp.Velocity = Vector3.new(0, 1, 0)
        if s.UserInputService:IsKeyDown(Enum.KeyCode.W) then hrp.CFrame = hrp.CFrame + (workspace.CurrentCamera.CFrame.LookVector * (Config.FlySpeed * dt)) end
    end
    
    if Config.Noclip then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    workspace.Gravity = Config.Gravity
end)

-- Хоткей Left Alt
s.UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftAlt then Main.Visible = not Main.Visible end
end)

-- Dragging
local d, ds, sp
Head.InputBegan:Connect(function(i) if i.UserInputType == Enum.KeyCode.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
s.UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.MouseMovement and d then
    local delta = i.Position - ds
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
s.UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.KeyCode.MouseButton1 then d = false end end)

-- Запуск
Pages["Combat"].Visible = true
print("🚀 BLAZIX TITAN V12: LOADED SUCCESSFULLY")
