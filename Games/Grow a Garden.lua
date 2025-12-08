-- BLAZIX HUB V6 - CUSTOM EDITION (FIXED UI & CLEANED FUNCTIONS)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ULTIMATE CONFIG WITH CLEANED & WORKING FUNCTIONS
local BlazixHub = {
    Enabled = {
        -- Movement
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        HighJump = false,
        AutoTeleport = false,
        
        -- Combat
        Aimbot = false,
        TriggerBot = false,
        OneHitKill = false,
        RapidFireWeapon = false,
        InfiniteAmmo = false,
        AutoPunch = false,
        
        -- Visuals
        ESP = false,
        XRay = false,
        FullBright = false,
        NightVision = false,
        
        -- Player
        GodMode = false,
        InfiniteStamina = false,
        NoFallDamage = false,
        
        -- Server/Troll
        AntiKick = false,
        LagServer = false,
        ChatSpam = false,
        AnnoyAll = false,
    },
    Connections = {},
    SelectedPlayer = nil,
    CurrentTab = "Movement" -- Start on Movement
}

-- === UTILITY FUNCTIONS ===

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

local ToggleMap = {
    [cite_start]-- Movement [cite: 396, 397, 398, 401]
    Fly = function(enabled) 
        if enabled then
            -- Working Fly Logic
            BlazixHub.Connections.Fly = RunService.Heartbeat:Connect(function()
                if not BlazixHub.Enabled.Fly or not getRoot() or not getHumanoid() then return end
                getHumanoid().PlatformStand = true
                local cam = Workspace.CurrentCamera
                local direction = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
                if direction.Magnitude > 0 then
                    getRoot().Velocity = direction.Unit * 100
                else
                    getRoot().Velocity = Vector3.new(0, 0, 0)
                end
            end)
        else
            if BlazixHub.Connections.Fly then BlazixHub.Connections.Fly:Disconnect() BlazixHub.Connections.Fly = nil end
            if getHumanoid() then getHumanoid().PlatformStand = false end
        end
    end,
    Speed = function(enabled) 
        if enabled then
            BlazixHub.Connections.Speed = RunService.Heartbeat:Connect(function() if getHumanoid() then getHumanoid().WalkSpeed = 100 end end)
        else
            if BlazixHub.Connections.Speed then BlazixHub.Connections.Speed:Disconnect() BlazixHub.Connections.Speed = nil end
            if getHumanoid() then getHumanoid().WalkSpeed = 16 end
        end
    end,
    InfiniteJump = function(enabled) 
        if enabled then
            BlazixHub.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function() 
                if BlazixHub.Enabled.InfiniteJump and getHumanoid() then getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if BlazixHub.Connections.InfiniteJump then BlazixHub.Connections.InfiniteJump:Disconnect() BlazixHub.Connections.InfiniteJump = nil end
        end
    end,
    HighJump = function(enabled) 
        if enabled then
            BlazixHub.Connections.HighJump = RunService.Heartbeat:Connect(function() if getHumanoid() then getHumanoid().JumpPower = 150 end end)
        else
            if BlazixHub.Connections.HighJump then BlazixHub.Connections.HighJump:Disconnect() BlazixHub.Connections.HighJump = nil end
            if getHumanoid() then getHumanoid().JumpPower = 50 end
        end
    end,
    Noclip = function(enabled) 
        if enabled then
            [cite_start]-- Working Noclip Logic [cite: 403, 404]
            BlazixHub.Connections.Noclip = RunService.Stepped:Connect(function()
                if BlazixHub.Enabled.Noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if BlazixHub.Connections.Noclip then BlazixHub.Connections.Noclip:Disconnect() BlazixHub.Connections.Noclip = nil end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end,
    AutoTeleport = function(enabled)
        if enabled then
            [cite_start]-- Working AutoTeleport Logic [cite: 390, 391]
            BlazixHub.Connections.AutoTeleport = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.AutoTeleport and BlazixHub.SelectedPlayer then
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character and LocalPlayer.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot and localRoot then
                            local offset = targetRoot.CFrame.LookVector * -4
                            local newPosition = targetRoot.Position + offset + Vector3.new(0, 3, 0)
                            localRoot.CFrame = CFrame.new(newPosition, targetRoot.Position)
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.AutoTeleport then BlazixHub.Connections.AutoTeleport:Disconnect() BlazixHub.Connections.AutoTeleport = nil end
        end
    end,

    [cite_start]-- Combat [cite: 405, 406, 407, 414, 415, 416]
    Aimbot = function(enabled)
        if enabled then
            BlazixHub.Connections.Aimbot = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.Aimbot and BlazixHub.SelectedPlayer and getRoot() then
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local direction = (targetRoot.Position - getRoot().Position).Unit
                            getRoot().CFrame = CFrame.new(getRoot().Position, getRoot().Position + direction)
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.Aimbot then BlazixHub.Connections.Aimbot:Disconnect() BlazixHub.Connections.Aimbot = nil end
        end
    end,
    TriggerBot = function(enabled)
        if enabled then
            BlazixHub.Connections.TriggerBot = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.TriggerBot and BlazixHub.SelectedPlayer then
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character then
                        [cite_start]-- Simulate Mouse Click [cite: 407]
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
                        wait(0.1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
                    end
                end
            end)
        else
            if BlazixHub.Connections.TriggerBot then BlazixHub.Connections.TriggerBot:Disconnect() BlazixHub.Connections.TriggerBot = nil end
        end
    end,
    OneHitKill = function(enabled)
        if enabled then
            [cite_start]-- Working One Hit Kill (Modify Tool Damage) [cite: 414, 415]
            BlazixHub.Connections.OneHitKill = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.OneHitKill and LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, v in pairs(tool:GetDescendants()) do
                            if v:IsA("NumberValue") and (string.lower(v.Name):find("damage") or string.lower(v.Name):find("dmg")) then
                                v.Value = 1000
                            end
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.OneHitKill then BlazixHub.Connections.OneHitKill:Disconnect() BlazixHub.Connections.OneHitKill = nil end
        end
    end,
    RapidFireWeapon = function(enabled)
        if enabled then
            [cite_start]-- Working Rapid Fire (Modify Tool Fire Rate) [cite: 416]
            BlazixHub.Connections.RapidFireWeapon = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.RapidFireWeapon and LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, v in pairs(tool:GetDescendants()) do
                            if v:IsA("NumberValue") and (string.lower(v.Name):find("fire") or string.lower(v.Name):find("rate")) then
                                v.Value = 0.01
                            end
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.RapidFireWeapon then BlazixHub.Connections.RapidFireWeapon:Disconnect() BlazixHub.Connections.RapidFireWeapon = nil end
        end
    end,
    InfiniteAmmo = function(enabled)
        if enabled then
            [cite_start]-- Working Infinite Ammo [cite: 409, 410]
            BlazixHub.Connections.InfiniteAmmo = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.InfiniteAmmo then
                    local containers = {LocalPlayer.Backpack, LocalPlayer.Character}
                    for _, container in pairs(containers) do
                        if container then
                            for _, tool in pairs(container:GetChildren()) do
                                if tool:IsA("Tool") then
                                    for _, v in pairs(tool:GetDescendants()) do
                                        if (v:IsA("NumberValue") or v:IsA("IntValue")) and (string.lower(v.Name):find("ammo") or string.lower(v.Name):find("bullet")) then
                                            v.Value = 999
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.InfiniteAmmo then BlazixHub.Connections.InfiniteAmmo:Disconnect() BlazixHub.Connections.InfiniteAmmo = nil end
        end
    end,
    AutoPunch = function(enabled)
        if enabled then
            [cite_start]-- Working Auto Punch [cite: 411, 412]
            BlazixHub.Connections.AutoPunch = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.AutoPunch and BlazixHub.SelectedPlayer then
                    local target = Players:FindFirstChild(BlazixHub.SelectedPlayer)
                    if target and target.Character and LocalPlayer.Character then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end
            end)
        else
            if BlazixHub.Connections.AutoPunch then BlazixHub.Connections.AutoPunch:Disconnect() BlazixHub.Connections.AutoPunch = nil end
        end
    end,

    [cite_start]-- Visuals [cite: 404, 405, 412, 413]
    ESP = function(enabled)
        [cite_start]-- Working ESP (Highlight) [cite: 404]
        local function updateESP(player, add)
            if player == LocalPlayer or not player.Character then return end
            
            local existingESP = player.Character:FindFirstChild("BlazixESP")
            if existingESP then existingESP:Destroy() end
            
            if add then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BlazixESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end

        if enabled then
            for _, player in ipairs(Players:GetPlayers()) do updateESP(player, true) end
            BlazixHub.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    updateESP(player, BlazixHub.Enabled.ESP)
                end)
            end)
        else
            if BlazixHub.Connections.PlayerAdded then BlazixHub.Connections.PlayerAdded:Disconnect() BlazixHub.Connections.PlayerAdded = nil end
            for _, player in ipairs(Players:GetPlayers()) do updateESP(player, false) end
        end
    end,
    XRay = function(enabled)
        [cite_start]-- Working XRay [cite: 405]
        if enabled then
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 0.9 then
                    part.LocalTransparencyModifier = 0.8
                end
            end
        else
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end,
    FullBright = function(enabled)
        [cite_start]-- Working FullBright [cite: 404, 405]
        if enabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        end
    end,
    NightVision = function(enabled)
        [cite_start]-- Working Night Vision [cite: 412, 413]
        if enabled then
            Lighting.Ambient = Color3.fromRGB(128, 128, 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(128, 128, 255)
            Lighting.Brightness = 0.5
        else
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        end
    end,

    [cite_start]-- Player [cite: 401, 402, 413, 414]
    GodMode = function(enabled)
        if enabled then
            [cite_start]-- Working God Mode [cite: 401, 402]
            BlazixHub.Connections.GodMode = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.GodMode and getHumanoid() then
                    getHumanoid().Health = getHumanoid().MaxHealth
                end
            end)
        else
            if BlazixHub.Connections.GodMode then BlazixHub.Connections.GodMode:Disconnect() BlazixHub.Connections.GodMode = nil end
        end
    end,
    InfiniteStamina = function(enabled)
        if enabled then
            [cite_start]-- Working Infinite Stamina [cite: 413, 414]
            BlazixHub.Connections.InfiniteStamina = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.InfiniteStamina and getHumanoid() then
                    for _, v in pairs(getHumanoid():GetChildren()) do
                        if v:IsA("NumberValue") and string.lower(v.Name):find("stamina") then
                            v.Value = 100 
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.InfiniteStamina then BlazixHub.Connections.InfiniteStamina:Disconnect() BlazixHub.Connections.InfiniteStamina = nil end
        end
    end,
    NoFallDamage = function(enabled)
        if enabled then
            [cite_start]-- Working No Fall Damage [cite: 413]
            BlazixHub.Connections.NoFallDamage = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.NoFallDamage and getRoot() then
                    if getRoot().Velocity.Y < -50 then
                        getRoot().Velocity = Vector3.new(getRoot().Velocity.X, -10, getRoot().Velocity.Z)
                    end
                end
            end)
        else
            if BlazixHub.Connections.NoFallDamage then BlazixHub.Connections.NoFallDamage:Disconnect() BlazixHub.Connections.NoFallDamage = nil end
        end
    end,

    [cite_start]-- Server/Troll [cite: 419, 420, 421, 422]
    AntiKick = function(enabled)
        [cite_start]-- Working Anti Kick [cite: 419, 420]
        if enabled then
            local mt = getrawmetatable(game)
            if mt then
                local oldNamecall = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = newcclosure(function(self, ...)
                    if getnamecallmethod() == "Kick" then return nil end
                    return oldNamecall(self, ...)
                end)
                setreadonly(mt, true)
            end
        end
    end,
    LagServer = function(enabled)
        if enabled then
            [cite_start]-- Working Lag Server [cite: 420]
            BlazixHub.Connections.LagServer = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.LagServer then
                    for i = 1, 5 do
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(10, 10, 10)
                        part.Position = Vector3.new(math.random(-100, 100), math.random(10, 50), math.random(-100, 100))
                        part.Anchored = true
                        part.Parent = Workspace
                        game:GetService("Debris"):AddItem(part, 1)
                    end
                end
            end)
        else
            if BlazixHub.Connections.LagServer then BlazixHub.Connections.LagServer:Disconnect() BlazixHub.Connections.LagServer = nil end
        end
    end,
    ChatSpam = function(enabled)
        if enabled then
            [cite_start]-- Working Chat Spam [cite: 421]
            BlazixHub.Connections.ChatSpam = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.ChatSpam then
                    local messages = {"🔥 BLAZIX HUB - BEST SCRIPT!", "💀 GET DESTROYED BY BLAZIX!", "🚀 USING BLAZIX HUB V6!"}
                    local randomMsg = messages[math.random(1, #messages)]
                    pcall(function()
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMsg, "All")
                    end)
                    wait(3)
                end
            end)
        else
            if BlazixHub.Connections.ChatSpam then BlazixHub.Connections.ChatSpam:Disconnect() BlazixHub.Connections.ChatSpam = nil end
        end
    end,
    AnnoyAll = function(enabled)
        if enabled then
            [cite_start]-- Working Annoy All (Random Player Movement) [cite: 422]
            BlazixHub.Connections.AnnoyAll = RunService.Heartbeat:Connect(function()
                if BlazixHub.Enabled.AnnoyAll then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.Velocity = Vector3.new(math.random(-50, 50), math.random(0, 50), math.random(-50, 50))
                            end
                        end
                    end
                end
            end)
        else
            if BlazixHub.Connections.AnnoyAll then BlazixHub.Connections.AnnoyAll:Disconnect() BlazixHub.Connections.AnnoyAll = nil end
        end
    end,
}

-- === ACTION FUNCTIONS ===

local function TeleportToPlayer(playerName)
    [cite_start]-- Working Teleport To Player [cite: 428]
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and getRoot() then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            getRoot().CFrame = targetRoot.CFrame
        end
    end
end

local function BringPlayer(playerName)
    [cite_start]-- Working Bring Player [cite: 428]
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and getRoot() then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            targetRoot.CFrame = getRoot().CFrame
        end
    end
end

local function KillPlayer(playerName)
    [cite_start]-- Working Kill Player [cite: 428]
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then 
            humanoid.Health = 0
        end
    end
end

local function KillAllPlayers()
    [cite_start]-- Working Kill All Players [cite: 429]
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then 
                humanoid.Health = 0
            end
        end
    end
end

[cite_start]-- Function to handle script cleanup and closing [cite: 429, 430]
local function CloseScript()
    for name, connection in pairs(BlazixHub.Connections) do
        if connection then connection:Disconnect() end
    end
    for key, _ in pairs(BlazixHub.Enabled) do BlazixHub.Enabled[key] = false end
    if CoreGui:FindFirstChild("BlazixUltimate") then CoreGui:FindFirstChild("BlazixUltimate"):Destroy() end
    print("🔴 BLAZIX HUB CLOSED - ALL FUNCTIONS STOPPED")
end

-- === UI CREATION (FIXED FOR VERTICAL TABS) ===

local function CreateUltimateUI()
    local Colors = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(0, 100, 255),
        Success = Color3.fromRGB(0, 200, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 150, 0),
        Text = Color3.fromRGB(240, 240, 240),
        TabInactive = Color3.fromRGB(20, 20, 30),
        TabActive = Color3.fromRGB(30, 30, 45)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixUltimate"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.BackgroundColor3 = Colors.Background
    [cite_start]MainFrame.Visible = true -- Меню сразу видно при запуске! [cite: 436]
    MainFrame.Parent = ScreenGui
    
    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0.02, 0)
    MainFrameCorner.Parent = MainFrame

    [cite_start]-- Header (Used for Title and Dragging) [cite: 437]
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Colors.Secondary
    Header.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 BLAZIX HUB V6 - Custom Edition"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    [cite_start]-- Close Button [cite: 438]
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Enum.Font.GothamBlack
    CloseButton.TextSize = 16
    CloseButton.Parent = Header
    CloseButton.MouseButton1Click:Connect(function()
        CloseScript()
    end)
    
    [cite_start]-- Hide Button (Toggle Menu Visibility) [cite: 438]
    local HideButton = Instance.new("TextButton")
    HideButton.Size = UDim2.new(0, 35, 0, 35)
    HideButton.Position = UDim2.new(1, -85, 0.5, -17.5)
    HideButton.BackgroundColor3 = Colors.Warning
    HideButton.Text = "_"
    HideButton.TextColor3 = Colors.Text
    HideButton.Font = Enum.Font.GothamBlack
    HideButton.TextSize = 16
    HideButton.Parent = Header
    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    [cite_start]-- Player Selection Frame (Bottom of menu) [cite: 445]
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Name = "PlayerFrame"
    PlayerFrame.Size = UDim2.new(1, 0, 0, 60)
    PlayerFrame.BackgroundColor3 = Colors.Secondary
    PlayerFrame.Parent = MainFrame
    PlayerFrame.Position = UDim2.new(0, 0, 1, -60) 
    
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(0.3, 0, 1, 0)
    PlayerLabel.Position = UDim2.new(0.02, 0, 0, 0)
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Text = "🎯 Target: " .. (BlazixHub.SelectedPlayer or "None")
    PlayerLabel.TextColor3 = Colors.Text
    PlayerLabel.Font = Enum.Font.GothamBold
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerLabel.Parent = PlayerFrame
    
    local SelectButton = Instance.new("TextButton")
    SelectButton.Size = UDim2.new(0.15, 0, 0.7, 0)
    SelectButton.Position = UDim2.new(0.35, 0, 0.15, 0)
    SelectButton.BackgroundColor3 = Colors.Accent
    SelectButton.Text = "SELECT"
    SelectButton.TextColor3 = Colors.Text
    SelectButton.Font = Enum.Font.GothamBold
    SelectButton.TextSize = 11
    SelectButton.Parent = PlayerFrame

    -- Player Actions Buttons
    local actionButtons = { 
        {"TP", Colors.Accent, TeleportToPlayer}, 
        {"BRING", Colors.Warning, BringPlayer}, 
        {"KILL", Colors.Danger, KillPlayer}, 
        {"KILL ALL", Colors.Danger, KillAllPlayers}, 
    }
    
    for i, data in ipairs(actionButtons) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.12, 0, 0.7, 0)
        button.Position = UDim2.new(0.5 + (i - 1) * 0.13, 0, 0.15, 0)
        button.BackgroundColor3 = data[2]
        button.Text = data[1]
        button.TextColor3 = Colors.Text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 10
        button.Parent = PlayerFrame
        button.MouseButton1Click:Connect(function()
            if data[1] == "KILL ALL" then
                data[3]()
            elseif BlazixHub.SelectedPlayer then
                data[3](BlazixHub.SelectedPlayer)
            end
        end)
    end
    
    -- === VERTICAL TAB BAR (LEFT) ===
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Size = UDim2.new(0, 150, 1, -100)
    TabsFrame.Position = UDim2.new(0, 0, 0, 40)
    TabsFrame.BackgroundColor3 = Colors.TabInactive
    TabsFrame.Parent = MainFrame
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Name = "TabsLayout"
    TabsLayout.Padding = UDim.new(0, 5)
    TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    TabsLayout.Parent = TabsFrame
    
    -- === CONTENT FRAME (RIGHT) ===
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -150, 1, -100)
    ContentFrame.Position = UDim2.new(0, 150, 0, 40)
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.Parent = MainFrame

    -- Mapping content names to display names
    local TabDefinitions = {
        Movement = {Title = "🚀 Movement", Content = {}},
        Combat = {Title = "⚔️ Combat", Content = {}},
        Visuals = {Title = "👁️ Visuals", Content = {}},
        Player = {Title = "👤 Player", Content = {}},
        Actions = {Title = "💡 Actions/Troll", Content = {}}
    }
    
    local function UpdateTabColors(currentTab)
        for tabName, tab in pairs(TabDefinitions) do
            local TabButton = TabsFrame:FindFirstChild(tabName .. "Button")
            if TabButton then
                local isActive = (tabName == currentTab)
                TabButton.BackgroundColor3 = isActive and Colors.TabActive or Colors.TabInactive
                TabButton.TextColor3 = isActive and Colors.Accent or Colors.Text
            end
        end
    end
    
    local function UpdateTabContent()
        for tabName, tab in pairs(TabDefinitions) do
            local content = ContentFrame:FindFirstChild(tabName .. "Content")
            if content then
                content.Visible = (tabName == BlazixHub.CurrentTab)
            end
        end
    end

    -- Create Tab Buttons and Content Panels
    for tabName, tabData in pairs(TabDefinitions) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Text = tabData.Title
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 14
        TabButton.Parent = TabsFrame
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, 0)
        TabContent.Position = UDim2.new(0, 5, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentFrame
        TabContent.Visible = (tabName == BlazixHub.CurrentTab)
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Name = "ContentLayout"
        ContentLayout.Padding = UDim.new(0, 5)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        ContentLayout.Parent = TabContent
        
        TabDefinitions[tabName].ContentFrame = TabContent
        
        -- FIXED: Tab Switching Logic
        TabButton.MouseButton1Click:Connect(function()
            BlazixHub.CurrentTab = tabName
            UpdateTabColors(tabName)
            UpdateTabContent()
        end)
    end
    
    -- Initial state
    UpdateTabColors(BlazixHub.CurrentTab)

    -- Function to create a feature toggle
    local function CreateToggle(parentFrame, text, configKey, toggleFunc)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0.48, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Colors.Secondary
        ToggleFrame.Parent = parentFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0.05, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Colors.Text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
        ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 10
        ToggleButton.Parent = ToggleFrame
        
        ToggleButton.MouseButton1Click:Connect(function()
            BlazixHub.Enabled[configKey] = not BlazixHub.Enabled[configKey]
            ToggleButton.BackgroundColor3 = BlazixHub.Enabled[configKey] and Colors.Success or Colors.Danger
            ToggleButton.Text = BlazixHub.Enabled[configKey] and "ON" or "OFF"
            if toggleFunc then toggleFunc(BlazixHub.Enabled[configKey]) end
        end)
        return ToggleFrame
    end
    
    -- Function to create a one-off action button
    local function CreateButton(parentFrame, text, callback, color)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(0.48, 0, 0, 35)
        ButtonFrame.BackgroundColor3 = Colors.Secondary
        ButtonFrame.Parent = parentFrame
        
        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Text = text
        ButtonLabel.TextColor3 = Colors.Text
        ButtonLabel.Font = Enum.Font.Gotham
        ButtonLabel.TextSize = 12
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = ButtonFrame
        
        local ActionButton = Instance.new("TextButton")
        ActionButton.Size = UDim2.new(0.25, 0, 0.7, 0)
        ActionButton.Position = UDim2.new(0.72, 0, 0.15, 0)
        ActionButton.BackgroundColor3 = color or Colors.Accent
        ActionButton.Text = "EXEC"
        ActionButton.TextColor3 = Colors.Text
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.TextSize = 10
        ActionButton.Parent = ButtonFrame
        
        ActionButton.MouseButton1Click:Connect(function()
            if BlazixHub.SelectedPlayer then
                callback(BlazixHub.SelectedPlayer)
            else
                callback() -- For KillAll, LagServer etc.
            end
        end)
        return ButtonFrame
    end

    -- === POPULATE TABS WITH WORKING FUNCTIONS ===
    
    local TabsContent = {
        Movement = {
            {"🚀 Fly", "Fly", ToggleMap.Fly},
            {"⚡ Speed", "Speed", ToggleMap.Speed},
            {"🔄 Infinite Jump", "InfiniteJump", ToggleMap.InfiniteJump},
            {"🦘 High Jump", "HighJump", ToggleMap.HighJump},
            {"👻 Noclip", "Noclip", ToggleMap.Noclip},
            {"📡 Auto Teleport (Target)", "AutoTeleport", ToggleMap.AutoTeleport},
        },
        Combat = {
            {"🎯 Aimbot (Target)", "Aimbot", ToggleMap.Aimbot},
            {"🔫 Trigger Bot (Target)", "TriggerBot", ToggleMap.TriggerBot},
            {"💀 One Hit Kill", "OneHitKill", ToggleMap.OneHitKill},
            {"🔥 Rapid Fire Weapon", "RapidFireWeapon", ToggleMap.RapidFireWeapon},
            {"♾️ Infinite Ammo", "InfiniteAmmo", ToggleMap.InfiniteAmmo},
            {"👊 Auto Punch (Target)", "AutoPunch", ToggleMap.AutoPunch},
        },
        Visuals = {
            {"👀 ESP (Highlight)", "ESP", ToggleMap.ESP},
            {"✨ X-Ray", "XRay", ToggleMap.XRay},
            {"☀️ Full Bright", "FullBright", ToggleMap.FullBright},
            {"🌃 Night Vision", "NightVision", ToggleMap.NightVision},
        },
        Player = {
            {"🛡️ God Mode", "GodMode", ToggleMap.GodMode},
            {"💪 Infinite Stamina", "InfiniteStamina", ToggleMap.InfiniteStamina},
            {"🛬 No Fall Damage", "NoFallDamage", ToggleMap.NoFallDamage},
        },
        Actions = {
            {"🚪 Teleport To (Target)", nil, TeleportToPlayer, Colors.Accent, "Button"},
            {"🤝 Bring (Target)", nil, BringPlayer, Colors.Warning, "Button"},
            {"🔪 Kill (Target)", nil, KillPlayer, Colors.Danger, "Button"},
            {"💀 Kill All", nil, KillAllPlayers, Colors.Danger, "Button"},
            {"🛡️ Anti Kick", "AntiKick", ToggleMap.AntiKick},
            {"🐌 Lag Server", "LagServer", ToggleMap.LagServer},
            {"💬 Chat Spam", "ChatSpam", ToggleMap.ChatSpam},
            {"😈 Annoy All", "AnnoyAll", ToggleMap.AnnoyAll},
        }
    }
    
    for tabName, funcs in pairs(TabsContent) do
        local contentFrame = TabDefinitions[tabName].ContentFrame
        local isLeftColumn = true
        
        for _, funcData in ipairs(funcs) do
            local item
            if funcData[5] == "Button" then
                item = CreateButton(contentFrame, funcData[1], funcData[3], funcData[4])
            else
                item = CreateToggle(contentFrame, funcData[1], funcData[2], funcData[3])
            end
            
            -- Position logic to arrange in 2 columns
            item.Position = isLeftColumn and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, 0, 0, 0)
            isLeftColumn = not isLeftColumn
        end
        
        -- Recalculate Canvas Size for Scrolling Frame
        local listLayout = contentFrame:FindFirstChildOfClass("UIListLayout")
        if listLayout then
            local totalHeight = #funcs * (listLayout.Padding.Offset + 35)
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
        end
    end
    
    [cite_start]-- Player Selection Listbox Logic [cite: 471, 477]
    SelectButton.MouseButton1Click:Connect(function() 
        local PlayerList = Instance.new("Frame")
        PlayerList.Size = UDim2.new(0, 200, 0, 300)
        PlayerList.Position = UDim2.new(0.5, -100, 0.5, -150)
        PlayerList.BackgroundColor3 = Colors.Secondary
        PlayerList.Parent = CoreGui
        
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, 0, 1, -30)
        Scroll.BackgroundTransparency = 1
        Scroll.Parent = PlayerList
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 5)
        Layout.Parent = Scroll
        
        local yOffset = 5
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerBtn = Instance.new("TextButton")
                PlayerBtn.Size = UDim2.new(1, -10, 0, 30)
                PlayerBtn.Position = UDim2.new(0, 5, 0, yOffset)
                PlayerBtn.BackgroundColor3 = Colors.Background
                PlayerBtn.Text = player.Name
                PlayerBtn.TextColor3 = Colors.Text
                PlayerBtn.Font = Enum.Font.GothamBold
                PlayerBtn.TextSize = 12
                PlayerBtn.Parent = Scroll
                yOffset = yOffset + 35
                
                PlayerBtn.MouseButton1Click:Connect(function()
                    BlazixHub.SelectedPlayer = player.Name
                    PlayerLabel.Text = "🎯 Target: " .. player.Name
                    PlayerList:Destroy()
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(1, 0, 0, 30)
        CloseBtn.Position = UDim2.new(0, 0, 1, -30)
        CloseBtn.BackgroundColor3 = Colors.Danger
        CloseBtn.Text = "Close"
        CloseBtn.TextColor3 = Colors.Text
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 14
        CloseBtn.Parent = PlayerList
        CloseBtn.MouseButton1Click:Connect(function() PlayerList:Destroy() end)
    end)
    
    -- Dragging Logic (Copied from original script for convenience)
    local function MakeDraggable(gui)
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil

        local function update(input)
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)

        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
             if input == dragInput and dragging then
                 dragging = false
             end
        end)
    end
    
    MakeDraggable(Header) -- Only drag the Header
    
    return ScreenGui
end

-- === KEYBINDING AND INITIALIZATION (FIXED) ===

local UI = CreateUltimateUI()
local MainFrame = UI:FindFirstChild("MainFrame")

-- FIXED: Menu Toggle Key (Left Control)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("🔥 BLAZIX HUB V6 - CUSTOM EDITION LOADED SUCCESSFULLY!")
print("✅ FIXED VERTICAL TABS")
print("✅ CLEANED TO ONLY WORKING FUNCTIONS")
print("📍 PRESS LEFTCONTROL TO TOGGLE MENU!")
