-- Speed Hub X - Universal Loader
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Games = {
    [7436755782] = "https://raw.githubusercontent.com/YOUR_USERNAME/Speed-Hub-X/main/Games/Grow%20a%20Garden.lua",
    [994732206] = "https://raw.githubusercontent.com/YOUR_USERNAME/Speed-Hub-X/main/Games/Blox%20Fruit.lua",
    [1268927906] = "https://raw.githubusercontent.com/YOUR_USERNAME/Speed-Hub-X/main/Games/Muscle%20Legends.lua",
    [3808081382] = "https://raw.githubusercontent.com/YOUR_USERNAME/Speed-Hub-X/main/Games/The%20Strongest%20Battleground.lua"
}

local function LoadGameScript(gameId)
    local gameUrl = Games[gameId]
    if not gameUrl then
        warn("Game not supported: " .. gameId)
        return false
    end
    
    local success, scriptData = pcall(function()
        return game:HttpGet(gameUrl)
    end)
    
    if success and scriptData then
        local loadedFunction = loadstring(scriptData)
        if loadedFunction then
            loadedFunction()
            print("✅ Speed Hub X loaded for game: " .. gameId)
            return true
        end
    end
    return false
end

-- Auto-load current game
local currentGameId = game.PlaceId
if Games[currentGameId] then
    LoadGameScript(currentGameId)
else
    -- Create game selector UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SpeedHubX_Selector"
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "SPEED HUB X - SELECT GAME"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    local GameList = Instance.new("ScrollingFrame")
    GameList.Size = UDim2.new(1, -20, 1, -70)
    GameList.Position = UDim2.new(0, 10, 0, 60)
    GameList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    GameList.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = GameList
    
    for gameId, gameUrl in pairs(Games) do
        local gameName = gameUrl:match("/([^/]+)%.lua") or "Unknown"
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.Text = gameName .. " (" .. gameId .. ")"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 12
        Button.Parent = GameList
        
        Button.MouseButton1Click:Connect(function()
            if LoadGameScript(gameId) then
                ScreenGui:Destroy()
            end
        end)
    end
end

return Games
