-- BLAZIX HUB: TOWER OF HELL PRO
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Конфиг
local Config = {
    Speed = false,
    SpeedValue = 45,
    Jump = false,
    God = false,
    ESP = false
}

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixPro"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Мини-иконка восстановления
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0, 45, 0, 45)
RestoreBtn.Position = UDim2.new(0, 10, 0.5, -22)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
RestoreBtn.Text = "B"
RestoreBtn.TextColor3 = Color3.new(1, 1, 1)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextSize = 20
RestoreBtn.Visible = false
RestoreBtn.Parent = ScreenGui
Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(1, 0)

-- Главный фрейм
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Заголовок (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "BLAZIX HUB | ToH"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопки управления (Закрыть / Свернуть)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 7)
Close.Text = "×"
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.Parent = TopBar
Instance.new("UICorner", Close)

local Hide = Instance.new("TextButton")
Hide.Size = UDim2.new(0, 30, 0, 30)
Hide.Position = UDim2.new(1, -75, 0, 7)
Hide.Text = "-"
Hide.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
Hide.TextColor3 = Color3.new(1, 1, 1)
Hide.Font = Enum.Font.GothamBold
Hide.TextSize = 20
Hide.Parent = TopBar
Instance.new("UICorner", Hide)

-- Боковое меню (Вкладки)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 110, 1, -55)
TabsFrame.Position = UDim2.new(0, 8, 0, 50)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = Main

local TabList = Instance.new("UIListLayout", TabsFrame)
TabList.Padding = UDim.new(0, 5)

-- Контейнер для страниц
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -135, 1, -60)
Pages.Position = UDim2.new(0, 125, 0, 55)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

-- Хранилище страниц
local TabPages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = Pages
    
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Parent = TabsFrame
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabPages) do p.Visible = false end
        Page.Visible = true
    end)
    
    TabPages[name] = Page
    return Page
end

-- Создаем вкладки
local MainPage = CreatePage("Main")
local VisualsPage = CreatePage("Visuals")
local TeleportPage = CreatePage("Teleport")
MainPage.Visible = true

-- Функция для кнопок (Toggles)
local function NewToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(1, -10, 0, 40)
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Tgl.Text = text .. ": OFF"
    Tgl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Tgl.Font = Enum.Font.Gotham
    Tgl.TextSize = 13
    Tgl.Parent = parent
    Instance.new("UICorner", Tgl)
    
    local state = false
    Tgl.MouseButton1Click:Connect(function()
        state = not state
        Tgl.Text = text .. (state and ": ON" or ": OFF")
        Tgl.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(35, 35, 45)
        callback(state)
    end)
end

-- ЛОГИКА ФУНКЦИЙ
-- 1. Безопасная скорость
RunService.Heartbeat:Connect(function()
    if Config.Speed and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue / 100))
        end
    end
end)

-- 2. Инф прыжок
UserInputService.JumpRequest:Connect(function()
    if Config.Jump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- НАПОЛНЕНИЕ ВКЛАДОК
NewToggle(MainPage, "⚡ Speed Hack", function(v) Config.Speed = v end)
NewToggle(MainPage, "🦘 Infinite Jump", function(v) Config.Jump = v end)
NewToggle(MainPage, "🛡️ Anti-Lava", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("KillScript") then
        char.KillScript.Disabled = v
    end
end)

NewToggle(VisualsPage, "🎯 ESP Box", function(v)
    Config.ESP = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local high = p.Character:FindFirstChild("BlazixESP") or Instance.new("Highlight", p.Character)
            high.Name = "BlazixESP"
            high.Enabled = v
        end
    end
end)

-- Вкладка Телепорт
local function CreateTeleBtn(text, pos)
    local Btn = Instance.new("TextButton", TeleportPage)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = TeleportPage
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = pos
        end
    end)
end

-- Кнопки телепорта на финиш (ищем платформу Win)
task.spawn(function()
    local winPos = Vector3.new(0, 0, 0)
    -- Попытка найти финишную зону автоматически
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "WinPart" or v.Name == "Finish" then
            winPos = v.CFrame
        end
    end
    CreateTeleBtn("🏆 Teleport to Win", CFrame.new(winPos.X, winPos.Y + 5, winPos.Z))
end)

-- УПРАВЛЕНИЕ ОКНОМ
Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    RestoreBtn.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Перетаскивание (Drag)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
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
