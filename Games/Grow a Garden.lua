-- Speed Hub X - Grow a Garden
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuration (will be loaded from JSON)
local Config = {
    ["Auto Reclaimer Plants"] = true,
    ["Auto Buy All Seeds"] = true,
    ["Auto Sprinkler"] = true,
    ["Auto Claim Reward"] = true,
    ["Infinite Jump"] = true
}

-- Main Automation
local Automation = {
    Active = false,
    
    AutoFarm = function(self)
        while self.Active and Config["Auto Reclaimer Plants"] do
            local gardenPlot = workspace:FindFirstChild("GardenPlot")
            if gardenPlot then
                for _, plant in pairs(gardenPlot:GetChildren()) do
                    if plant:FindFirstChild("Ready") and plant.Ready.Value then
                        game:GetService("ReplicatedStorage").Events.HarvestPlant:FireServer(plant)
                    end
                end
            end
            task.wait(0.5)
        end
    end,
    
    Start = function(self)
        self.Active = true
        spawn(function() self:AutoFarm() end)
    end
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHubX_GrowAGarden"
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SPEED HUB X - GROW A GARDEN"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.Parent = MainFrame

-- Auto Farm Toggle
local AutoFarmBtn = Instance.new("TextButton")
AutoFarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoFarmBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
AutoFarmBtn.Text = "START AUTO FARM"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.TextSize = 12
AutoFarmBtn.Parent = MainFrame

AutoFarmBtn.MouseButton1Click:Connect(function()
    Automation:Start()
    AutoFarmBtn.Text = "AUTO FARM ACTIVE"
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end)

print("🌱 Speed Hub X - Grow a Garden Loaded!")
Automation:Start()
