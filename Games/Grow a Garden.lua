-- Добавляем функцию аима с телепортацией и стрельбой из Laser Gun
local function EnableAimAssist()
    if BlazixHub.Connections.AimAssist then
        BlazixHub.Connections.AimAssist:Disconnect()
    end
    
    BlazixHub.Connections.AimAssist = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.AimAssist and BlazixHub.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(BlazixHub.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and localRoot then
                    -- Телепортация сверху/снизу от цели
                    local teleportPosition = targetRoot.Position + Vector3.new(
                        math.random(-5, 5),
                        math.random(10, 15), -- сверху
                        math.random(-5, 5)
                    )
                    
                    localRoot.CFrame = CFrame.new(teleportPosition, targetRoot.Position)
                    
                    -- Поиск Laser Gun во 2 слоте инвентаря
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        -- Ищем оружие с названием "Laser gun" или похожим
                        local laserGun = nil
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and (
                                tool.Name:lower():find("laser") or 
                                tool.Name:lower():find("gun") or
                                tool.Name:lower():find("weapon")
                            ) then
                                laserGun = tool
                                break
                            end
                        end
                        
                        -- Если нашли оружие, экипируем и стреляем
                        if laserGun then
                            -- Экипировка оружия
                            laserGun.Parent = LocalPlayer.Character
                            
                            -- Стрельба
                            spawn(function()
                                for i = 1, 3 do -- 3 выстрела
                                    if laserGun:FindFirstChild("Fire") then
                                        laserGun.Fire:FireServer(targetRoot.Position)
                                    elseif laserGun:FindFirstChild("Shoot") then
                                        laserGun.Shoot:FireServer(targetRoot.Position)
                                    elseif laserGun:FindFirstChild("Activate") then
                                        laserGun.Activate:FireServer()
                                    end
                                    task.wait(0.2)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
end

-- Функция для поиска и автоматического использования любого оружия
local function EnableAutoShoot()
    if BlazixHub.Connections.AutoShoot then
        BlazixHub.Connections.AutoShoot:Disconnect()
    end
    
    BlazixHub.Connections.AutoShoot = RunService.Heartbeat:Connect(function()
        if BlazixHub.Enabled.AutoShoot and BlazixHub.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(BlazixHub.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot then
                    -- Автоматическая стрельба из любого оружия
                    local character = LocalPlayer.Character
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") then
                            -- Пытаемся стрелять разными методами
                            pcall(function()
                                if tool:FindFirstChild("Fire") then
                                    tool.Fire:FireServer(targetRoot.Position)
                                end
                            end)
                            
                            pcall(function()
                                if tool:FindFirstChild("Shoot") then
                                    tool.Shoot:FireServer(targetRoot.Position)
                                end
                            end)
                            
                            pcall(function()
                                if tool:FindFirstChild("Activate") then
                                    tool.Activate:FireServer()
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
end

-- Функция телепорта вокруг игрока с стрельбой
local function TeleportAndShoot()
    if not BlazixHub.SelectedPlayer then return end
    
    local targetPlayer = Players:FindFirstChild(BlazixHub.SelectedPlayer)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            -- Телепортация в разные позиции вокруг игрока
            local positions = {
                targetRoot.Position + Vector3.new(5, 5, 0),   -- Справа сверху
                targetRoot.Position + Vector3.new(-5, 5, 0),  -- Слева сверху
                targetRoot.Position + Vector3.new(0, 10, 5),  -- Сверху спереди
                targetRoot.Position + Vector3.new(0, 10, -5)  -- Сверху сзади
            }
            
            for _, pos in ipairs(positions) do
                localRoot.CFrame = CFrame.new(pos, targetRoot.Position)
                task.wait(0.3)
                
                -- Авто-стрельба после телепортации
                local character = LocalPlayer.Character
                for _, tool in ipairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(function()
                            if tool:FindFirstChild("Fire") then
                                tool.Fire:FireServer(targetRoot.Position)
                            elseif tool:FindFirstChild("Shoot") then
                                tool.Shoot:FireServer(targetRoot.Position)
                            elseif tool:FindFirstChild("Activate") then
                                tool.Activate:FireServer()
                            end
                        end)
                        break
                    end
                end
            end
        end
    end
end

-- Добавляем новые функции в UI (добавьте этот код в секцию создания UI)

-- Вкладка COMBAT - добавляем новые функции аима
CreateToggle("🎯 Aim Assist", "Auto teleport and shoot", "Combat", "AimAssist", function(state)
    BlazixHub.Enabled.AimAssist = state
    if state then
        EnableAimAssist()
    elseif BlazixHub.Connections.AimAssist then
        BlazixHub.Connections.AimAssist:Disconnect()
    end
end)

CreateToggle("🔫 Auto Shoot", "Auto shoot at target", "Combat", "AutoShoot", function(state)
    BlazixHub.Enabled.AutoShoot = state
    if state then
        EnableAutoShoot()
    elseif BlazixHub.Connections.AutoShoot then
        BlazixHub.Connections.AutoShoot:Disconnect()
    end
end)

CreateButton("🌀 Teleport & Shoot", "Teleport around target and shoot", "Combat", TeleportAndShoot, Colors.Accent)

-- Также обновляем функцию Player ESP чтобы показывать цель аима
local function UpdateESPForAim()
    if BlazixHub.Enabled.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    if player.Name == BlazixHub.SelectedPlayer then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Красный для цели
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Желтая обводка
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)  -- Зеленый для остальных
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
end

-- Обновляем выбор игрока чтобы обновлять ESP
local originalSelectPlayer = BlazixHub.SelectPlayer
BlazixHub.SelectPlayer = function(playerName)
    BlazixHub.SelectedPlayer = playerName
    UpdateESPForAim()
end

print("✅ Aim functions added successfully!")
print("🎯 Aim Assist - Teleports above/below and shoots")
print("🔫 Auto Shoot - Continuous shooting at target")  
print("🌀 Teleport & Shoot - Moves around target while shooting")
