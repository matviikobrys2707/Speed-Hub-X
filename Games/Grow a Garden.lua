-- BLAZIX HUB: TOWER OF HELL EDITION
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Настройки
local Config = {
    SpeedEnabled = false,
    SpeedValue = 40,
    InfJump = false,
    NoCoil = false,
    MenuKey = Enum.KeyCode.RightControl
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlazixTower"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Мини-иконка (когда свернуто)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Size = UDim2.new(0, 40, 0, 40)
MiniIcon.Position = UDim2.new(0, 20, 0.5, -20)
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
MiniIcon.Text = "B"
MiniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- Главное окно
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Заголовок с кнопками
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "BLAZIX HUB | TOWER OF HELL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = Header

-- Вкладки
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 100, 1, -40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Tabs.Parent = Main

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, -110, 1, -50)
MainContainer.Position = UDim2.new(0, 105, 0, 45)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = Main

-- Логика переключения вкладок
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = MainContainer
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 5)
    return Page
end

local MainTab = CreatePage("Main")
local VisualsTab = CreatePage("Visuals")
MainTab.Visible = true

-- Функция создания кнопки (Toggle)
local function AddToggle(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = name .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = parent
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = name .. (enabled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
        callback(enabled)
    end)
    Instance.new("UICorner", Btn)
end

-- ФУНКЦИИ
-- Safe Speed (обход античита)
RunService.Heartbeat:Connect(function()
    if Config.SpeedEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Config.SpeedValue / 100))
        end
    end
end)

-- Safe Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            -- Добавляем крошечную задержку, чтобы античит не видел спам прыжков
            task.wait(0.1)
        end
    end
end)

-- Наполнение вкладок
AddToggle(MainTab, "⚡ Safe Speed", function(v) Config.SpeedEnabled = v end)
AddToggle(MainTab, "🔄 Safe InfJump", function(v) Config.InfJump = v end)
AddToggle(MainTab, "🛡️ GodMode (Anti-Lava)", function(v)
    -- В ToH GodMode часто палится, лучше просто удалять скрипт смерти
    local kill = LocalPlayer.Character:FindFirstChild("KillScript") or LocalPlayer.Character:FindFirstChild("death")
    if v and kill then kill.Disabled = true end
end)

AddToggle(VisualsTab, "🎯 Player ESP", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local high = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            high.Enabled = v
        end
    end
end)

-- Управление окном
MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    Main.Visible = true
    MiniIcon.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Кнопки вкладок
local btnMain = Instance.new("TextButton", Tabs)
btnMain.Size = UDim2.new(1, 0, 0, 30)
btnMain.Text = "Main"
btnMain.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnMain.TextColor3 = Color3.fromRGB(255, 255, 255)

local btnVis = Instance.new("TextButton", Tabs)
btnVis.Size = UDim2.new(1, 0, 0, 30)
btnVis.Position = UDim2.new(0, 0, 0, 35)
btnVis.Text = "Visuals"
btnVis.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnVis.TextColor3 = Color3.fromRGB(255, 255, 255)

btnMain.MouseButton1Click:Connect(function()
    MainTab.Visible = true
    VisualsTab.Visible = false
end)

btnVis.MouseButton1Click:Connect(function()
    MainTab.Visible = false
    VisualsTab.Visible = true
end)

-- Dragging
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
