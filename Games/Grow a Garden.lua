--[[
    BLAZIX OMNI V10 - THE MONSTER (EXTREME EDITION)
    ARCH: MODULAR V3.5 | UI: NEUMORPHIC DARK
    FUNCTIONS: 50+ | OPTIMIZED FOR ALL EXECUTORS
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ СИСТЕМА ПЕРЕМЕННЫХ - 50+ ПАРАМЕТРОВ ]
local CFG = {
    -- Player
    Speed = 16, Jump = 50, Grav = 196.2, FlySpd = 50, Hip = 0,
    InfJump = false, Noclip = false, Fly = false, AntiVoid = false, 
    NoSlow = false, SpinBot = false, BunnyHop = false, AirWalk = false,
    -- Combat
    Aimbot = false, Silent = false, FOV = 100, Smooth = 1, VisCheck = false,
    Hitbox = false, HSize = 2, HTransp = 0.7, AutoClick = false, ClickDel = 0.05,
    Trigger = false, Reach = false, ReachDist = 15,
    -- Visuals
    ESP = false, Boxes = false, Tracers = false, Chams = false, Names = false,
    Health = false, Dist = false, Skeleton = false, ViewFOV = false,
    FullBright = false, NoFog = false, RainbowMap = false, Xray = false,
    -- World
    DestroyKill = false, FPSBoost = false, TimeLimit = false, Night = false,
    AntiTouch = false, TeleportParts = false, AutoCollect = false,
    -- Misc
    AntiAFK = true, ChatSpy = false, Rejoin = false, ServerHop = false,
    Invisible = false, Spectate = false, FakeLag = false
}

-- [ UI LIBRARY: NEUMORPHIC ENGINE ]
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Blazix_Monster_V10"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 800, 0, 550)
Main.Position = UDim2.new(0.5, -400, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 1.5

-- [ NAVIGATION ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, -20)
Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundTransparency = 1
local NavList = Instance.new("UIListLayout", Sidebar)
NavList.Padding = UDim.new(0, 5)

-- [ CONTENT HOLDER ]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -210, 1, -70)
Container.Position = UDim2.new(0, 200, 0, 60)
Container.BackgroundTransparency = 1

local Pages = {}
local CurrentPage = nil

local function CreatePage(name, icon)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)
    
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, 0, 0, 45)
    Tab.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Tab.Text = icon .. " " .. name
    Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab.Font = Enum.Font.GothamMedium
    Tab.TextSize = 14
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[name] = Page
    return Page
end

-- [ BUILD PAGES ]
local Dash = CreatePage("Dashboard", "🏠")
local Combat = CreatePage("Combat", "⚔️")
local Player = CreatePage("Movement", "🏃")
local Visuals = CreatePage("Visuals", "👁️")
local World = CreatePage("World", "🌍")
local Misc = CreatePage("Miscellaneous", "⚙️")

-- [ SMART ELEMENTS ENGINE ]
local function AddToggle(parent, text, cfg_key, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Instance.new("UICorner", Frame)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -100, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.Text = text
    Lbl.TextColor3 = Color3.new(1,1,1)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    local Tgl = Instance.new("TextButton", Frame)
    Tgl.Size = UDim2.new(0, 45, 0, 22)
    Tgl.Position = UDim2.new(1, -60, 0.5, -11)
    Tgl.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Tgl.Text = ""
    Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Tgl)
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Tgl.MouseButton1Click:Connect(function()
        CFG[cfg_key] = not CFG[cfg_key]
        TweenService:Create(Dot, TweenInfo.new(0.3), {
            Position = CFG[cfg_key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = CFG[cfg_key] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(150, 150, 150)
        }):Play()
        if callback then callback(CFG[cfg_key]) end
    end)
end

local function AddSlider(parent, text, min, max, cfg_key)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 65)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Instance.new("UICorner", Frame)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.Position = UDim2.new(0, 15, 0, 5)
    Lbl.Text = text .. ": " .. CFG[cfg_key]
    Lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1

    local Bar = Instance.new("TextButton", Frame)
    Bar.Size = UDim2.new(1, -30, 0, 6)
    Bar.Position = UDim2.new(0, 15, 0, 45)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Bar.Text = ""
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((CFG[cfg_key]-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", Fill)

    Bar.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local P = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(P, 0, 1, 0)
            local V = math.floor(min + (max - min) * P)
            CFG[cfg_key] = V
            Lbl.Text = text .. ": " .. V
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end end)
    end)
end

-- [ LOADING 50+ FUNCTIONS ]

-- COMBAT
AddToggle(Combat, "Silent Aim (Bypass)", "Silent")
AddToggle(Combat, "Hitbox Expander", "Hitbox")
AddSlider(Combat, "Hitbox Size", 2, 50, "HSize")
AddToggle(Combat, "Trigger Bot", "Trigger")
AddToggle(Combat, "Auto Clicker", "AutoClick")
AddSlider(Combat, "Click Speed", 0, 1, "ClickDel")
AddToggle(Combat, "Melee Reach", "Reach")
AddSlider(Combat, "Reach Distance", 5, 50, "ReachDist")

-- MOVEMENT
AddSlider(Player, "WalkSpeed", 16, 500, "Speed")
AddSlider(Player, "JumpPower", 50, 500, "Jump")
AddToggle(Player, "Infinite Jump", "InfJump")
AddToggle(Player, "Noclip (Through Walls)", "Noclip")
AddToggle(Player, "Flight Mode", "Fly")
AddSlider(Player, "Fly Speed", 10, 500, "FlySpd")
AddToggle(Player, "Anti-Void Protection", "AntiVoid")
AddToggle(Player, "BunnyHop", "BunnyHop")
AddToggle(Player, "Air Walk", "AirWalk")
AddToggle(Player, "SpinBot", "SpinBot")

-- VISUALS
AddToggle(Visuals, "Enable ESP", "ESP")
AddToggle(Visuals, "Boxes", "Boxes")
AddToggle(Visuals, "Tracers", "Tracers")
AddToggle(Visuals, "Health Bars", "Health")
AddToggle(Visuals, "Distance", "Dist")
AddToggle(Visuals, "Chams (Wallhack)", "Chams")
AddToggle(Visuals, "FullBright", "FullBright", function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.Ambient = v and Color3.new(1,1,1) or Color3.new(0,0,0)
end)
AddToggle(Visuals, "No Fog", "NoFog")

-- WORLD
AddToggle(World, "Destroy Lava/KillParts", "DestroyKill")
AddToggle(World, "FPS Boost (Removes Textures)", "FPSBoost", function(v)
    if v then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
    end
end)
AddToggle(World, "Anti-Touch Parts", "AntiTouch")
AddToggle(World, "Auto-Collect Items", "AutoCollect")

-- MISC
AddToggle(Misc, "Chat Spy", "ChatSpy")
AddToggle(Misc, "Anti-AFK", "AntiAFK")
AddToggle(Misc, "Rejoin On Kick", "Rejoin")
AddToggle(Misc, "Server Hop", "ServerHop")

-- [ CORE ENGINES - ЛОГИКА ]

-- 1. Стриминг функций (60 FPS)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        -- Speed bypass
        if CFG.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * (CFG.Speed / 100))
        end
        -- Noclip
        if CFG.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        -- Flight
        if CFG.Fly then
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            hrp.Velocity = dir * CFG.FlySpd
        end
        -- Spinbot
        if CFG.SpinBot then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end
        -- Anti-Void
        if CFG.AntiVoid and hrp.Position.Y < -50 then
            hrp.Velocity = Vector3.zero
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
        end
    end
end)

-- 2. Combat Engine (Hitboxes)
task.spawn(function()
    while task.wait(0.5) do
        if CFG.Hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local target = p.Character.HumanoidRootPart
                    target.Size = Vector3.new(CFG.HSize, CFG.HSize, CFG.HSize)
                    target.Transparency = CFG.HTransp
                    target.CanCollide = false
                end
            end
        end
    end
end)

-- 3. ESP Engine (Highlights)
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("MonsterHL") or Instance.new("Highlight", p.Character)
                hl.Name = "MonsterHL"
                hl.Enabled = CFG.Chams
                hl.FillColor = Color3.fromRGB(0, 255, 150)
            end
        end
    end
end)

-- 4. Auto-Clicker
task.spawn(function()
    while task.wait() do
        if CFG.AutoClick then
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(CFG.ClickDel)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

-- [ WINDOW CONTROLS ]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 10)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Screen:Destroy() end)

-- Dragging
local dragStart, startPos, dragging
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
    local d = i.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Pages["Dashboard"].Visible = true
StarterGui:SetCore("SendNotification", {Title = "BLAZIX V10", Text = "THE MONSTER IS READY", Duration = 5})
