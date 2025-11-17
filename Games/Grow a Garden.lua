-- BlazixHub - Grow a Garden
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local Config = {
    ["Auto Reclaimer Plants"] = true,
    ["Auto Buy All Seeds"] = true,
    ["Auto Sprinkler"] = true,
    ["Auto Claim Reward"] = true,
    ["Infinite Jump"] = true,
    ["Auto Plant Evo Seed"] = false,
    ["Auto Give Corrupt to Kitsune"] = true,
    ["Auto Submit All Fruit"] = true,
    ["Auto Submit All Plant"] = true
}

-- Main Automation System
local BlazixHub = {
    Automation = {
        Active = false,
        
        AutoFarm = function(self)
            while self.Active and Config["Auto Reclaimer Plants"] do
                local gardenPlot = workspace:FindFirstChild("GardenPlot")
                if gardenPlot then
                    for _, plant in pairs(gardenPlot:GetChildren()) do
                        if plant:FindFirstChild("Ready") and plant.Ready.Value == true then
                            game:GetService("ReplicatedStorage").Events.HarvestPlant:FireServer(plant)
                        end
                    end
                end
                task.wait(0.5)
            end
        end,
        
        AutoPlant = function(self)
            while self.Active and Config["Auto Buy All Seeds"] do
                local gardenPlot = workspace:FindFirstChild("GardenPlot")
                if gardenPlot then
                    for _, plot in pairs(gardenPlot:GetChildren()) do
                        if not plot:FindFirstChild("Plant") then
                            game:GetService("ReplicatedStorage").Events.PlantSeed:FireServer(plot, "BasicSeed")
                        end
                    end
                end
                task.wait(1)
            end
        end,
        
        AutoWater = function(self)
            while self.Active and Config["Auto Sprinkler"] do
                local gardenPlot = workspace:FindFirstChild("GardenPlot")
                if gardenPlot then
                    for _, plant in pairs(gardenPlot:GetChildren()) do
                        if plant:FindFirstChild("WaterLevel") then
                            game:GetService("ReplicatedStorage").Events.WaterPlant:FireServer(plant)
                        end
                    end
                end
                task.wait(2)
            end
        end,
        
        Start = function(self)
            self.Active = true
            spawn(function() self:AutoFarm() end)
            spawn(function() self:AutoPlant() end)
            spawn(function() self:AutoWater() end)
        end,
        
        Stop = function(self)
            self.Active = false
        end
    },
    
    UI = {}
}

-- Create Main UI
function BlazixHub.UI:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 450, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Window Stroke
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 100, 255)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "BLAZIX HUB"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 16
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBlack
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    
    -- Hide Button
    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Size = UDim2.new(0, 30, 0, 30)
    HideButton.Position = UDim2.new(1, -70, 0, 5)
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    HideButton.Text = "_"
    HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.Font = Enum.Font.GothamBlack
    HideButton.TextSize = 14
    HideButton.Parent = TitleBar
    
    -- Toggle Menu Button (появляется когда скрыто)
    local ToggleMenuBtn = Instance.new("TextButton")
    ToggleMenuBtn.Name = "ToggleMenuBtn"
    ToggleMenuBtn.Size = UDim2.new(0, 60, 0, 60)
    ToggleMenuBtn.Position = UDim2.new(1, -70, 0, 20)
    ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    ToggleMenuBtn.Text = "BLAZIX"
    ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleMenuBtn.Font = Enum.Font.GothamBlack
    ToggleMenuBtn.TextSize = 10
    ToggleMenuBtn.Visible = false
    ToggleMenuBtn.Parent = ScreenGui
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Create tabs content
    self:CreateHomeTab(ContentFrame)
    self:CreateAutomationTab(ContentFrame)
    self:CreateSettingsTab(ContentFrame)
    
    -- Button events
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        BlazixHub.Automation:Stop()
    end)
    
    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleMenuBtn.Visible = true
    end)
    
    ToggleMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleMenuBtn.Visible = false
    end)
    
    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

-- Home Tab
function BlazixHub.UI:CreateHomeTab(parent)
    local Tab = Instance.new("Frame")
    Tab.Name = "HomeTab"
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = true
    Tab.Parent = parent
    
    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Size = UDim2.new(1, 0, 0, 60)
    WelcomeLabel.Position = UDim2.new(0, 0, 0, 20)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "WELCOME TO BLAZIX HUB"
    WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeLabel.Font = Enum.Font.GothamBlack
    WelcomeLabel.TextSize = 20
    WelcomeLabel.Parent = Tab
    
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(0.9, 0, 0, 100)
    StatusFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    StatusFrame.Parent = Tab
    
    local StatusTitle = Instance.new("TextLabel")
    StatusTitle.Size = UDim2.new(1, 0, 0, 30)
    StatusTitle.Position = UDim2.new(0, 0, 0, 0)
    StatusTitle.BackgroundTransparency = 1
    StatusTitle.Text = "SYSTEM STATUS"
    StatusTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    StatusTitle.Font = Enum.Font.GothamBold
    StatusTitle.TextSize = 14
    StatusTitle.Parent = StatusFrame
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0, 0, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "● ACTIVE"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 16
    StatusLabel.Parent = StatusFrame
    
    local QuickStart = Instance.new("TextButton")
    QuickStart.Size = UDim2.new(0.8, 0, 0, 50)
    QuickStart.Position = UDim2.new(0.1, 0, 0.6, 0)
    QuickStart.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    QuickStart.Text = "START AUTO FARM"
    QuickStart.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuickStart.Font = Enum.Font.GothamBold
    QuickStart.TextSize = 14
    QuickStart.Parent = Tab
    
    QuickStart.MouseButton1Click:Connect(function()
        BlazixHub.Automation:Start()
        QuickStart.Text = "AUTO FARM ACTIVE"
        QuickStart.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
end

-- Automation Tab
function BlazixHub.UI:CreateAutomationTab(parent)
    local Tab = Instance.new("Frame")
    Tab.Name = "AutomationTab"
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    Tab.Parent = parent
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "AUTOMATION SETTINGS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.Parent = Tab
    
    -- Automation Toggles
    local automationOptions = {
        {"Auto Reclaimer Plants", "Automatically harvest plants"},
        {"Auto Buy All Seeds", "Auto plant seeds in empty plots"},
        {"Auto Sprinkler", "Auto water plants"},
        {"Auto Claim Reward", "Auto claim rewards"},
        {"Auto Submit All Fruit", "Auto submit fruits"},
        {"Auto Submit All Plant", "Auto submit plants"},
        {"Auto Give Corrupt to Kitsune", "Auto give corrupt plants"},
        {"Auto Plant Evo Seed", "Auto plant evolution seeds"}
    }
    
    for i, option in ipairs(automationOptions) do
        self:CreateToggle(option[1], option[2], Tab, UDim2.new(0.05, 0, 0.1 + (i-1)*0.1, 0), function(state)
            Config[option[1]] = state
        end)
    end
end

-- Settings Tab
function BlazixHub.UI:CreateSettingsTab(parent)
    local Tab = Instance.new("Frame")
    Tab.Name = "SettingsTab"
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    Tab.Parent = parent
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "SETTINGS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.Parent = Tab
    
    -- Tab Buttons
    local tabButtons = {
        {"HomeTab", "HOME"},
        {"AutomationTab", "AUTO"},
        {"SettingsTab", "SETTINGS"}
    }
    
    for i, tab in ipairs(tabButtons) do
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tab[1] .. "Btn"
        TabBtn.Size = UDim2.new(0.3, -5, 0, 30)
        TabBtn.Position = UDim2.new((i-1)*0.33, 5, 0.1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.Text = tab[2]
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.Parent = Tab
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("Frame") and child.Name:match("Tab$") then
                    child.Visible = (child.Name == tab[1])
                end
            end
        end)
    end
end

-- Toggle Creation Function
function BlazixHub.UI:CreateToggle(name, description, parent, position, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 50)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0.6, 0)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    if description ~= "" then
        local Desc = Instance.new("TextLabel")
        Desc.Size = UDim2.new(0.7, 0, 0.4, 0)
        Desc.Position = UDim2.new(0, 10, 0.6, 0)
        Desc.BackgroundTransparency = 1
        Desc.Text = description
        Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 10
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.Parent = ToggleFrame
    end
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = Config[name] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Size = UDim2.new(0, 16, 0, 16)
    ToggleDot.Position = Config[name] and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleDot.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config[name] = not Config[name]
        ToggleButton.BackgroundColor3 = Config[name] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        ToggleDot.Position = Config[name] and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        callback(Config[name])
    end)
end

-- Initialize BlazixHub
local UI = BlazixHub.UI:Create()
BlazixHub.Automation:Start()

print("🚀 BlazixHub loaded successfully!")
print("📌 Features: Auto Farm, Auto Plant, Auto Water")
print("🎮 Game: Grow a Garden")

return BlazixHub
