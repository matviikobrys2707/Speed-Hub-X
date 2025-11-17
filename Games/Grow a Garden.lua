-- BlazixHub - Mobile Version
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local Config = {
    ["Automation Plants"] = true,
    ["Automation Collection"] = true,
    ["Automation Sprinkler"] = true,
    ["Automation Eggs / Crate"] = true,
    ["Automation Sell"] = false,
    ["Automation Pets"] = false,
    ["Automation Shovel"] = false,
    ["Automation Favorite Plants"] = false,
    ["Infinite Jump"] = true,
    ["Auto Claim Reward"] = true
}

-- Main Automation System
local BlazixHub = {
    Automation = {
        Active = false,
        
        AutoFarm = function(self)
            while self.Active and Config["Automation Plants"] do
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
            while self.Active and Config["Automation Collection"] do
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
            while self.Active and Config["Automation Sprinkler"] do
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
            if Config["Automation Plants"] then spawn(function() self:AutoFarm() end) end
            if Config["Automation Collection"] then spawn(function() self:AutoPlant() end) end
            if Config["Automation Sprinkler"] then spawn(function() self:AutoWater() end) end
        end
    }
}

-- Create UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Open Menu Button (всегда видна на телефоне)
    local OpenMenuBtn = Instance.new("TextButton")
    OpenMenuBtn.Name = "OpenMenuBtn"
    OpenMenuBtn.Size = UDim2.new(0, 70, 0, 70)
    OpenMenuBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    OpenMenuBtn.BackgroundTransparency = 0.2
    OpenMenuBtn.Text = "📱\nBLAZIX"
    OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenMenuBtn.Font = Enum.Font.GothamBold
    OpenMenuBtn.TextSize = 12
    OpenMenuBtn.TextWrapped = true
    OpenMenuBtn.Visible = true
    OpenMenuBtn.Parent = ScreenGui

    -- Main Window (изначально скрыта)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)  -- Немного меньше для телефона
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false  -- Сначала скрыта
    MainFrame.Parent = ScreenGui

    -- Window Stroke
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 100, 255)
    Stroke.Thickness = 1
    Stroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -70, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "BlazixHub Mobile"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 14
    TitleLabel.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 2)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar

    -- Hide Button
    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Size = UDim2.new(0, 30, 0, 30)
    HideButton.Position = UDim2.new(1, -70, 0, 2)
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    HideButton.Text = "▼"
    HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.Font = Enum.Font.Gotham
    HideButton.TextSize = 14
    HideButton.Parent = TitleBar

    -- Main Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -35)
    ContentFrame.Position = UDim2.new(0, 0, 0, 35)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Left Navigation
    local NavFrame = Instance.new("Frame")
    NavFrame.Name = "Navigation"
    NavFrame.Size = UDim2.new(0, 130, 1, 0)  -- Уже для телефона
    NavFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NavFrame.BackgroundTransparency = 0.1
    NavFrame.BorderSizePixel = 0
    NavFrame.Parent = ContentFrame

    -- Right Content
    local RightFrame = Instance.new("Frame")
    RightFrame.Name = "RightContent"
    RightFrame.Size = UDim2.new(1, -130, 1, 0)
    RightFrame.Position = UDim2.new(0, 130, 0, 0)
    RightFrame.BackgroundTransparency = 1
    RightFrame.Parent = ContentFrame

    -- Navigation Items
    local navItems = {
        {"Main", "Main"},
        {"Auto", "Auto"},
        {"Settings", "Settings"}
    }

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = NavFrame

    -- Function to show content
    local function ShowContent(section)
        -- Clear previous content
        for _, child in pairs(RightFrame:GetChildren()) do
            child:Destroy()
        end

        if section == "Main" then
            CreateMainSection(RightFrame)
        elseif section == "Auto" then
            CreateAutomationSection(RightFrame)
        elseif section == "Settings" then
            CreateSettingsSection(RightFrame)
        end
    end

    -- Create navigation buttons
    for i, item in ipairs(navItems) do
        local NavButton = Instance.new("TextButton")
        NavButton.Name = item[1] .. "Btn"
        NavButton.Size = UDim2.new(1, 0, 0, 40)  -- Выше для удобства на телефоне
        NavButton.BackgroundColor3 = i == 1 and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
        NavButton.BackgroundTransparency = 0.1
        NavButton.Text = item[2]
        NavButton.TextColor3 = i == 1 and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
        NavButton.Font = Enum.Font.Gotham
        NavButton.TextSize = 12
        NavButton.Parent = NavFrame
        
        NavButton.MouseButton1Click:Connect(function()
            -- Update all buttons
            for _, btn in pairs(NavFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            -- Highlight active button
            NavButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            NavButton.TextColor3 = Color3.fromRGB(0, 150, 255)
            
            -- Show corresponding content
            ShowContent(item[1])
        end)
    end

    -- Create Main Section
    function CreateMainSection(parent)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = "🌱 Auto Farm"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 16
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = parent
        
        local options = {
            {"Auto Collect", "Collect plants automatically", "Automation Plants"},
            {"Auto Plant", "Plant seeds automatically", "Automation Collection"},
            {"Auto Water", "Water plants automatically", "Automation Sprinkler"},
            {"Auto Eggs", "Open eggs automatically", "Automation Eggs / Crate"}
        }
        
        for i, option in ipairs(options) do
            CreateToggle(option[1], option[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*50), function(state)
                Config[option[3]] = state
                if state then
                    BlazixHub.Automation:Start()
                end
            end, Config[option[3]])
        end
    end

    -- Create Automation Section
    function CreateAutomationSection(parent)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = "⚙️ Automation"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 16
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = parent
        
        local automationOptions = {
            {"Auto Sell", "Sell items automatically", "Automation Sell"},
            {"Auto Pets", "Manage pets automatically", "Automation Pets"},
            {"Auto Shovel", "Shovel plants automatically", "Automation Shovel"},
            {"Favorite Plants", "Auto favorite plants", "Automation Favorite Plants"}
        }
        
        for i, option in ipairs(automationOptions) do
            CreateToggle(option[1], option[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*50), function(state)
                Config[option[3]] = state
            end, Config[option[3]])
        end
    end

    -- Create Settings Section
    function CreateSettingsSection(parent)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = "🔧 Settings"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 16
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = parent
        
        local settings = {
            {"Infinite Jump", "Enable infinite jump", "Infinite Jump"},
            {"Auto Rewards", "Auto claim rewards", "Auto Claim Reward"}
        }
        
        for i, setting in ipairs(settings) do
            CreateToggle(setting[1], setting[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*50), function(state)
                Config[setting[3]] = state
            end, Config[setting[3]])
        end
        
        -- Status
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, -20, 0, 40)
        StatusLabel.Position = UDim2.new(0, 10, 0, 250)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "✅ BlazixHub Active"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusLabel.Font = Enum.Font.GothamBold
        StatusLabel.TextSize = 14
        StatusLabel.Parent = parent
    end

    -- Toggle Creation Function
    function CreateToggle(name, description, parent, position, callback, initialState)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 45)
        ToggleFrame.Position = position
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ToggleFrame.BackgroundTransparency = 0.1
        ToggleFrame.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 45, 0, 25)  -- Больше для телефона
        ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
        ToggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame
        
        local ToggleDot = Instance.new("Frame")
        ToggleDot.Size = UDim2.new(0, 20, 0, 20)  -- Больше для телефона
        ToggleDot.Position = initialState and UDim2.new(0, 23, 0, 2) or UDim2.new(0, 2, 0, 2)
        ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDot.Parent = ToggleButton
        
        ToggleButton.MouseButton1Click:Connect(function()
            local newState = not initialState
            ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
            ToggleDot.Position = newState and UDim2.new(0, 23, 0, 2) or UDim2.new(0, 2, 0, 2)
            initialState = newState
            callback(newState)
        end)
    end

    -- Button events
    OpenMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenMenuBtn.Visible = false
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        BlazixHub.Automation.Active = false
    end)
    
    HideButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenMenuBtn.Visible = true
    end)

    -- Show default content
    ShowContent("Main")

    ScreenGui.Parent = PlayerGui
    return ScreenGui
end

-- Initialize
local UI = CreateUI()
BlazixHub.Automation:Start()

print("📱 BlazixHub Mobile loaded successfully!")
print("📍 Tap the BLAZIX button to open menu")
print("🌱 Auto-farm started for Grow a Garden")

warn("Tap the BLUE BLAZIX button in top-left corner!")
