-- BlazixHub - Compact UI Version
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
    },
    
    UI = {}
}

-- Create Compact UI
function BlazixHub.UI:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazixHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)  -- Шире и компактнее
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1  -- Полупрозрачное
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Window Stroke
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 100, 255)
    Stroke.Thickness = 1
    Stroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "BlazixHub | dscard.org/blazixhub"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 12
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.TextSize = 12
    CloseButton.Parent = TitleBar
    
    -- Main Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Left Navigation
    local NavFrame = Instance.new("Frame")
    NavFrame.Name = "Navigation"
    NavFrame.Size = UDim2.new(0, 150, 1, 0)
    NavFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NavFrame.BackgroundTransparency = 0.1
    NavFrame.BorderSizePixel = 0
    NavFrame.Parent = ContentFrame
    
    -- Right Content
    local RightFrame = Instance.new("Frame")
    RightFrame.Name = "RightContent"
    RightFrame.Size = UDim2.new(1, -150, 1, 0)
    RightFrame.Position = UDim2.new(0, 150, 0, 0)
    RightFrame.BackgroundTransparency = 1
    RightFrame.Parent = ContentFrame
    
    -- Create navigation and content
    self:CreateNavigation(NavFrame, RightFrame)
    self:CreateMainContent(RightFrame)
    
    -- Button events
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        BlazixHub.Automation.Active = false
    end)
    
    -- Toggle Menu Button
    local ToggleMenuBtn = Instance.new("TextButton")
    ToggleMenuBtn.Name = "ToggleMenuBtn"
    ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleMenuBtn.Position = UDim2.new(1, -60, 0, 20)
    ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    ToggleMenuBtn.BackgroundTransparency = 0.1
    ToggleMenuBtn.Text = "BH"
    ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleMenuBtn.Font = Enum.Font.GothamBold
    ToggleMenuBtn.TextSize = 12
    ToggleMenuBtn.Visible = false
    ToggleMenuBtn.Parent = ScreenGui
    
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

-- Navigation Items
function BlazixHub.UI:CreateNavigation(navFrame, contentFrame)
    local navItems = {
        {"Main", "Main"},
        {"Automatically", "Automatically"},
        {"Inventory", "Inventory"},
        {"Shop", "Shop"},
        {"Webhook", "Webhook"},
        {"Misc", "Misc"},
        {"Settings", "Settings"},
        {"Settings.UI", "Settings.UI"}
    }
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = navFrame
    
    for i, item in ipairs(navItems) do
        local NavButton = Instance.new("TextButton")
        NavButton.Name = item[1] .. "Btn"
        NavButton.Size = UDim2.new(1, 0, 0, 35)
        NavButton.BackgroundColor3 = i == 1 and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
        NavButton.BackgroundTransparency = 0.1
        NavButton.Text = item[2]
        NavButton.TextColor3 = i == 1 and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
        NavButton.Font = Enum.Font.Gotham
        NavButton.TextSize = 11
        NavButton.Parent = navFrame
        
        NavButton.MouseButton1Click:Connect(function()
            -- Update all buttons
            for _, btn in pairs(navFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            -- Highlight active button
            NavButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            NavButton.TextColor3 = Color3.fromRGB(0, 150, 255)
            
            -- Show corresponding content
            self:ShowContent(item[1], contentFrame)
        end)
    end
end

-- Show Content Based on Navigation
function BlazixHub.UI:ShowContent(section, contentFrame)
    -- Clear previous content
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    if section == "Main" then
        self:CreateMainSection(contentFrame)
    elseif section == "Automatically" then
        self:CreateAutomationSection(contentFrame)
    elseif section == "Settings" then
        self:CreateSettingsSection(contentFrame)
    else
        -- Default content for other sections
        local Placeholder = Instance.new("TextLabel")
        Placeholder.Size = UDim2.new(1, 0, 1, 0)
        Placeholder.BackgroundTransparency = 1
        Placeholder.Text = section .. " Section\n(Coming Soon)"
        Placeholder.TextColor3 = Color3.fromRGB(150, 150, 150)
        Placeholder.Font = Enum.Font.Gotham
        Placeholder.TextSize = 14
        Placeholder.Parent = contentFrame
    end
end

-- Main Section Content
function BlazixHub.UI:CreateMainSection(parent)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Automation Plants"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = parent
    
    local options = {
        {"Automation Collection", "Auto collect plants and fruits"},
        {"Automation Sprinkler", "Auto water plants"},
        {"Automation Eggs / Crate", "Auto open eggs and crates"},
        {"Automation Sell", "Auto sell items"},
        {"Automation Pets", "Auto manage pets"},
        {"Automation Shovel", "Auto shovel plants"},
        {"Automation Favorite Plants", "Auto favorite plants"}
    }
    
    for i, option in ipairs(options) do
        self:CreateExpandableToggle(option[1], option[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*45), function(state)
            Config[option[1]] = state
        end)
    end
end

-- Automation Section
function BlazixHub.UI:CreateAutomationSection(parent)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Automation Settings"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = parent
    
    local automationOptions = {
        {"Auto Farm Plants", "Automatically harvest ready plants", "Automation Plants"},
        {"Auto Plant Seeds", "Plant seeds in empty plots", "Automation Collection"},
        {"Auto Water Plants", "Keep plants watered", "Automation Sprinkler"},
        {"Auto Open Eggs", "Open eggs automatically", "Automation Eggs / Crate"},
        {"Auto Sell Items", "Sell items automatically", "Automation Sell"}
    }
    
    for i, option in ipairs(automationOptions) do
        self:CreateExpandableToggle(option[1], option[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*45), function(state)
            Config[option[3]] = state
            if state then
                BlazixHub.Automation:Start()
            end
        end, Config[option[3]])
    end
end

-- Settings Section
function BlazixHub.UI:CreateSettingsSection(parent)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Settings"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = parent
    
    local settings = {
        {"Infinite Jump", "Enable infinite jump ability"},
        {"Auto Claim Reward", "Auto claim daily rewards"},
        {"UI Transparency", "Adjust UI transparency"}
    }
    
    for i, setting in ipairs(settings) do
        self:CreateExpandableToggle(setting[1], setting[2], parent, UDim2.new(0, 10, 0, 50 + (i-1)*45), function(state)
            Config[setting[1]] = state
        end, Config[setting[1]])
    end
end

-- Expandable Toggle Function
function BlazixHub.UI:CreateExpandableToggle(name, description, parent, position, callback, initialState)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
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
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Size = UDim2.new(0, 16, 0, 16)
    ToggleDot.Position = initialState and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleDot.Parent = ToggleButton
    
    -- Expandable Description
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -20, 0, 0)
    DescriptionLabel.Position = UDim2.new(0, 10, 1, 5)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Text = description
    DescriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextSize = 10
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.Visible = false
    DescriptionLabel.Parent = ToggleFrame
    
    local isExpanded = false
    
    local function toggleExpand()
        isExpanded = not isExpanded
        if isExpanded then
            ToggleFrame.Size = UDim2.new(1, -20, 0, 80)
            DescriptionLabel.Visible = true
        else
            ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
            DescriptionLabel.Visible = false
        end
    end
    
    -- Click on label to expand
    Label.MouseButton1Click:Connect(toggleExpand)
    
    -- Click on toggle to switch state
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not (initialState or false)
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        ToggleDot.Position = newState and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        initialState = newState
        callback(newState)
    end)
end

-- Default Main Content
function BlazixHub.UI:CreateMainContent(parent)
    self:CreateMainSection(parent)
end

-- Initialize BlazixHub
local UI = BlazixHub.UI:Create()
BlazixHub.Automation:Start()

print("🚀 BlazixHub Compact UI loaded!")
print("📌 Drag title bar to move window")
print("🎮 Auto-farm started for Grow a Garden")

return BlazixHub
