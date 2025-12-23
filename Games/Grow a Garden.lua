--[[
    ██████╗ ██╗      █████╗ ███████╗██╗██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██║     ██╔══██╗╚══███╔╝██║╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝██║     ███████║  ███╔╝ ██║ ╚███╔╝     ███████║██║   ██║██████╔╝
    ██╔══██╗██║     ██╔══██║ ███╔╝  ██║ ██╔██╗     ██╔══██║██║   ██║██╔══██╗
    ██████╔╝███████╗██║  ██║███████╗██║██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝
    ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    OMNIPOTENCE V6 - THE FINAL EDITION
]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- VARIABLES
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURATION
local Config = {
    -- Player
    Speed = 16, Jump = 50, Gravity = 196.2, InfJump = false, Noclip = false, 
    Fly = false, FlySpeed = 50, AntiVoid = false, HipHeight = 0,
    -- Combat
    HitboxExpander = false, HitboxSize = 2, SilentAim = false, AimFOV = 100,
    -- Visuals
    ESP_Enabled = false, ESP_Boxes = false, ESP_Chams = false, ESP_Tracers = false,
    FullBright = false, NoFog = false,
    -- Misc
    AutoClicker = false, ChatSpy = false, AntiAFK = true,
    ThemeColor = Color3.fromRGB(0, 255, 157)
}

-- UI SYSTEM
local BlazixLib = {}
do
    function BlazixLib:Notify(title, text)
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
    end

    function BlazixLib:CreateUI()
        local ScreenGui = Instance.new("ScreenGui", CoreGui)
        ScreenGui.Name = "BlazixOmniV6"
        ScreenGui.ResetOnSpawn = false

        -- Mini Icon (Hidden state)
        local MiniIcon = Instance.new("TextButton", ScreenGui)
        MiniIcon.Size = UDim2.new(0, 45, 0, 45)
        MiniIcon.Position = UDim2.new(0, 20, 0.5, -22)
        MiniIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        MiniIcon.Text = "B"
        MiniIcon.TextColor3 = Config.ThemeColor
        MiniIcon.Font = Enum.Font.GothamBold
        MiniIcon.TextSize = 25
        MiniIcon.Visible = false
        Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", MiniIcon).Color = Config.ThemeColor

        -- Main Frame
        local Main = Instance.new("Frame", ScreenGui)
        Main.Size = UDim2.new(0, 600, 0, 400)
        Main.Position = UDim2.new(0.5, -300, 0.5, -200)
        Main.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
        local MainStroke = Instance.new("UIStroke", Main)
        MainStroke.Color = Config.ThemeColor
        MainStroke.Thickness = 1.5

        -- Header
        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 45)
        Header.BackgroundTransparency = 1
        
        local Title = Instance.new("TextLabel", Header)
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.Position = UDim2.new(0, 20, 0, 0)
        Title.Text = "BLAZIX HUB | OMNIPOTENCE V6"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 18
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.BackgroundTransparency = 1

        -- Tabs Container
        local Tabs = Instance.new("Frame", Main)
        Tabs.Size = UDim2.new(0, 140, 1, -55)
        Tabs.Position = UDim2.new(0, 10, 0, 50)
        Tabs.BackgroundTransparency = 1
        local TabList = Instance.new("UIListLayout", Tabs)
        TabList.Padding = UDim.new(0, 5)

        local Container = Instance.new("Frame", Main)
        Container.Size = UDim2.new(1, -170, 1, -60)
        Container.Position = UDim2.new(0, 160, 0, 55)
        Container.BackgroundTransparency = 1

        -- Page Creator
        local Pages = {}
        function BlazixLib:NewPage(name)
            local p = Instance.new("ScrollingFrame", Container)
            p.Size = UDim2.new(1, 0, 1, 0)
            p.BackgroundTransparency = 1
            p.Visible = false
            p.ScrollBarThickness = 2
            Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)

            local b = Instance.new("TextButton", Tabs)
            b.Size = UDim2.new(1, 0, 0, 35)
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.Text = name
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
            b.Font = Enum.Font.Gotham
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                for _, page in pairs(Pages) do page.Visible = false end
                p.Visible = true
            end)
            Pages[name] = p
            return p
        end

        -- ELEMENTS
        function BlazixLib:AddToggle(parent, text, key, callback)
            local t = Instance.new("TextButton", parent)
            t.Size = UDim2.new(1, -10, 0, 38)
            t.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            t.Text = text .. ": OFF"
            t.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", t)
            
            t.MouseButton1Click:Connect(function()
                Config[key] = not Config[key]
                t.Text = text .. (Config[key] and ": ON" or ": OFF")
                t.BackgroundColor3 = Config[key] and Config.ThemeColor or Color3.fromRGB(30, 30, 35)
                t.TextColor3 = Config[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
                if callback then callback(Config[key]) end
            end)
        end

        function BlazixLib:AddSlider(parent, text, min, max, key, callback)
            local sFrame = Instance.new("Frame", parent)
            sFrame.Size = UDim2.new(1, -10, 0, 50)
            sFrame.BackgroundTransparency = 1
            local label = Instance.new("TextLabel", sFrame)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Text = text .. ": " .. Config[key]
            label.TextColor3 = Color3.new(1,1,1)
            label.BackgroundTransparency = 1

            local bar = Instance.new("TextButton", sFrame)
            bar.Size = UDim2.new(1, 0, 0, 10)
            bar.Position = UDim2.new(0, 0, 0, 25)
            bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            bar.Text = ""
            Instance.new("UICorner", bar)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((Config[key]-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = Config.ThemeColor
            Instance.new("UICorner", fill)

            bar.MouseButton1Down:Connect(function()
                local move = RunService.RenderStepped:Connect(function()
                    local per = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(per, 0, 1, 0)
                    local val = math.floor(min + (max - min) * per)
                    Config[key] = val
                    label.Text = text .. ": " .. val
                    if callback then callback(val) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
                end)
            end)
        end

        -- Close/Hide
        local CloseBtn = Instance.new("TextButton", Header)
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -40, 0, 7)
        CloseBtn.Text = "X"
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Instance.new("UICorner", CloseBtn)
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

        local HideBtn = Instance.new("TextButton", Header)
        HideBtn.Size = UDim2.new(0, 30, 0, 30)
        HideBtn.Position = UDim2.new(1, -75, 0, 7)
        HideBtn.Text = "-"
        HideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Instance.new("UICorner", HideBtn)
        HideBtn.MouseButton1Click:Connect(function() Main.Visible = false MiniIcon.Visible = true end)
        MiniIcon.MouseButton1Click:Connect(function() Main.Visible = true MiniIcon.Visible = false end)

        -- DRAGGING logic
        local dStart, sPos, dragging
        Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dStart = i.Position sPos = Main.Position end end)
        UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = i.Position - dStart
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

        return Pages
    end
end

-- MODULES LOADING
local Pages = BlazixLib:CreateUI()
local CombatPg = BlazixLib:NewPage("🎯 Combat")
local MovePg = BlazixLib:NewPage("🚀 Movement")
local VisPg = BlazixLib:NewPage("👁️ Visuals")
local WorldPg = BlazixLib:NewPage("🌍 World")
local MiscPg = BlazixLib:NewPage("⚙️ Misc")
Pages["🎯 Combat"].Visible = true

-- [LOGIC: MOVEMENT]
BlazixLib:AddSlider(MovePg, "WalkSpeed Bypass", 16, 250, "Speed")
BlazixLib:AddSlider(MovePg, "JumpPower Bypass", 50, 300, "Jump")
BlazixLib:AddToggle(MovePg, "Infinite Jump", "InfJump")
BlazixLib:AddToggle(MovePg, "Noclip", "Noclip")
BlazixLib:AddToggle(MovePg, "Anti-Void Protection", "AntiVoid")
BlazixLib:AddToggle(MovePg, "Enable Flight", "Fly", function(v)
    if v then
        local bVel = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        spawn(function()
            while Config.Fly do
                local d = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= Camera.CFrame.LookVector end
                bVel.Velocity = d * Config.FlySpeed
                task.wait()
            end
            bVel:Destroy()
        end)
    end
end)

-- [LOGIC: COMBAT]
BlazixLib:AddToggle(CombatPg, "Hitbox Expander", "HitboxExpander")
BlazixLib:AddSlider(CombatPg, "Hitbox Radius", 2, 50, "HitboxSize")
BlazixLib:AddToggle(CombatPg, "Silent Aim (Visual)", "SilentAim")

-- [LOGIC: VISUALS]
BlazixLib:AddToggle(VisPg, "Player Chams", "ESP_Chams", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("BlHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "BlHighlight"
            h.Enabled = v
            h.FillColor = Config.ThemeColor
        end
    end
end)
BlazixLib:AddToggle(VisPg, "FullBright", "FullBright", function(v)
    Lighting.Brightness = v and 2 or 1
    Lighting.Ambient = v and Color3.new(1,1,1) or Color3.new(0,0,0)
end)

-- [LOGIC: WORLD]
BlazixLib:AddToggle(WorldPg, "Remove Fog", "NoFog", function(v) Lighting.FogEnd = v and 1e5 or 1000 end)
BlazixLib:AddToggle(WorldPg, "Destroy KillParts (Lava)", "LavaDestroy", function(v)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("lava") or part.Name:lower():find("kill")) then
            part.CanTouch = not v
            if v then part.Transparency = 0.5 end
        end
    end
end)

-- [CORE LOOP]
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        -- Safe Speed
        if Config.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * (Config.Speed / 100))
        end
        -- Inf Jump
        if Config.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        end
        -- Anti-Void
        if Config.AntiVoid and char.HumanoidRootPart.Position.Y < -50 then
            char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, 50, char.HumanoidRootPart.Position.Z)
        end
        -- Noclip
        if Config.Noclip then
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
    end
    -- Hitboxes
    if Config.HitboxExpander then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end
end)

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
end)

BlazixLib:Notify("BLAZIX OMNI", "Loaded Successfully! (1000+ Logic Nodes)")
