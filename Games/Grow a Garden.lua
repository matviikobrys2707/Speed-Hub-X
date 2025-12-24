-- Минимальный тест UI для проверки бага
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

print("=== НАЧАЛО ТЕСТА UI ===")
print("Игрок:", player.Name)
print("CoreGui существует:", CoreGui ~= nil)

-- 1. Простейший тест - TextLabel
local testGui = Instance.new("ScreenGui")
testGui.Name = "TestGUI_" .. tick()
testGui.Parent = CoreGui
testGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = testGui

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Текст
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "✅ NeoHax Тест\n\nUI должен быть виден!\n\nЕсли не видно:\n1. Проверьте исполнитель\n2. Нажмите F9 (Консоль)\n3. Ищите в CoreGui"
label.TextColor3 = Color3.fromRGB(0, 255, 140)
label.TextSize = 18
label.Font = Enum.Font.GothamBold
label.TextWrapped = true
label.Parent = frame

print("UI создан!")
print("Имя GUI:", testGui.Name)
print("Родитель:", testGui.Parent and testGui.Parent.Name or "Нет родителя")

-- 2. Тест через StarterGui (альтернативный метод)
task.wait(1)
print("\n=== ТЕСТ 2: Через StarterGui ===")

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "NeoHax Test",
    Text = "Если видите это - UI работает!",
    Duration = 10,
    Icon = "rbxassetid://4483345998"
})

print("Уведомление отправлено")

-- 3. Проверка видимости через F9
print("\n=== КАК ПРОВЕРИТЬ ===")
print("1. Нажмите F9 чтобы открыть Developer Console")
print("2. Найдите 'Explorer' вкладку")
print("3. Раскройте CoreGui")
print("4. Ищите TestGUI_ или NeoHax")

-- 4. Аварийный метод если не видно
print("\n=== АВАРИЙНЫЙ МЕТОД ===")
local emergencyGui = Instance.new("ScreenGui")
emergencyGui.Name = "EMERGENCY_GUI"
emergencyGui.Parent = CoreGui
emergencyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
emergencyGui.DisplayOrder = 99999

local emergencyFrame = Instance.new("Frame")
emergencyFrame.Size = UDim2.new(1, 0, 0, 50)
emergencyFrame.Position = UDim2.new(0, 0, 0, 0)
emergencyFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
emergencyFrame.BorderSizePixel = 0
emergencyFrame.Parent = emergencyGui

local emergencyText = Instance.new("TextLabel")
emergencyText.Size = UDim2.new(1, 0, 1, 0)
emergencyText.BackgroundTransparency = 1
emergencyText.Text = "⚠️ NEOHAX UI АКТИВЕН ⚠️ Нажмите F9 -> Explorer -> CoreGui"
emergencyText.TextColor3 = Color3.fromRGB(255, 255, 255)
emergencyText.TextSize = 16
emergencyText.Font = Enum.Font.GothamBold
emergencyText.Parent = emergencyFrame

print("Красная плашка создана сверху экрана")

-- 5. Проверка через Heartbeat
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    -- Подсвечиваем UI если он существует
    if testGui and testGui.Parent then
        frame.BackgroundColor3 = Color3.fromRGB(
            math.sin(tick() * 2) * 0.1 + 0.3,
            math.sin(tick() * 3) * 0.1 + 0.3,
            math.sin(tick() * 4) * 0.1 + 0.4
        )
    end
end)

print("\n=== ИНФОРМАЦИЯ ===")
print("Исполнитель должен поддерживать:")
print("- Instance.new()")
print("- CoreGui как родитель")
print("- ResetOnSpawn = false")
print("- ZIndexBehavior = Global")

-- 6. Тест нажатий (опционально)
emergencyFrame.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    print("Клик! UI видимый:", frame.Visible)
end)

print("\n=== ТЕСТ ЗАВЕРШЕН ===")
print("Если ничего не видно:")
print("1. Исполнитель может блокировать UI")
print("2. Попробуйте другой executor (Synapse, KRNL, Fluxus)")
print("3. Проверьте античит игры")
