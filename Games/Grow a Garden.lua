-- BLAZIX HUB: REBORN (Optimized & Stable)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Конфигурация
local Config = {
    Fly = false,
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    ESP = false,
    FullBright = false,
    InfiniteJump = false,
    MenuKey = Enum.KeyCode.RightControl
}

-- Утилиты
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

-- ФУНКЦИИ ЛОГИКИ
local Connections = {}

-- 1. Fly System
local function UpdateFly()
    if not Config.Fly then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum then
        local dir = Vector3.zero
        local cam = workspace.CurrentCamera.CFrame
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end
        
        root.Velocity = dir * Config.FlySpeed
        hum.PlatformStand = true
    end
end

-- 2. Noclip System (Оптимизированный)
Connections.Noclip = RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. Speed & Jump Power
Connections.Mobility = RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
    UpdateFly()
end)

-- 4. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ИНТЕРФЕЙС (Modern Dark UI)
local function CreateModernUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixModern"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 280, 0, 380)
    Main.Position = UDim2.new(0.5, -140, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Main.ClipsDescendants = true

    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 10)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "BLAZIX HUB v2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 1, -50)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.Parent = Main
    
    local UIListLayout = Instance.new("UIListLayout", Container)
    UIListLayout.Padding = UDim.new(0, 5)

    -- Функция создания кнопки-переключателя
    local function AddToggle(name, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -5, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Btn.Text = name .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.Parent = Container

        local tgl = false
        Btn.MouseButton1Click:Connect(function()
            tgl = not tgl
            Btn.Text = name .. (tgl and ": ON" or ": OFF")
            Btn.BackgroundColor3 = tgl and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 55)
            callback(tgl)
        end)
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    end

    -- Наполнение функциями
    AddToggle("🕊️ Fly Mode", function(v) 
        Config.Fly = v 
        if not v and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end)
    
    AddToggle("⚡ Speed (100)", function(v) Config.WalkSpeed = v and 100 or 16 end)
    AddToggle("🦘 High Jump", function(v) Config.JumpPower = v and 150 or 50 end)
    AddToggle("🔄 Infinite Jump", function(v) Config.InfiniteJump = v end)
    AddToggle("👻 Noclip", function(v) Config.Noclip = v end)
    
    AddToggle("💡 FullBright", function(v)
        if v then
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.Brightness = 2
        else
            Lighting.Ambient = Color3.new(0.5,0.5,0.5)
            Lighting.Brightness = 1
        end
    end)

    -- Сворачивание меню
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Config.MenuKey then
            Main.Visible = not Main.Visible
        end
    end)

    -- Dragging (Перетаскивание)
    local dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end
    end)
end

-- Запуск
CreateModernUI()
Notify("Blazix Hub", "Загружено! Нажми RightControl чтобы скрыть.")
