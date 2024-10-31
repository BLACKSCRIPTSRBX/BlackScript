-- Функция для полета с управлением джойстиком
local function enableFlight()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    local flying = false
    local speed = 50  -- Скорость полета

    -- Управление полетом через джойстик
    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local moveDirection = character.Humanoid.MoveDirection
            character.HumanoidRootPart.Velocity = moveDirection * speed + Vector3.new(0, 1, 0) * speed
        end
    end)

    -- Функция для включения/выключения полета
    return function()
        flying = not flying
        if flying then
            humanoid.PlatformStand = true
        else
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Функция для бессмертия
local function enableGodMode()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local godModeEnabled = false

    local function toggleGodMode()
        godModeEnabled = not godModeEnabled
        if godModeEnabled then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.HealthChanged:Connect(function(health)
                if godModeEnabled and health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        else
            humanoid.MaxHealth = 100  -- Вернем стандартное здоровье
            humanoid.Health = humanoid.MaxHealth
        end
    end

    return toggleGodMode
end

-- Функция для невидимости
local function enableInvisibility()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local invisible = false
    
    local function toggleInvisibility()
        invisible = not invisible
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = invisible and 1 or 0  -- Сделать части тела прозрачными
            elseif part:IsA("Humanoid") and part:FindFirstChild("Head"):FindFirstChild("Nametag") then
                part:FindFirstChild("Head"):FindFirstChild("Nametag").Enabled = not invisible  -- Скрыть никнейм
            end
        end
    end

    return toggleInvisibility
end

-- Включаем функции и создаем кнопки
local flightToggle = enableFlight()
local godModeToggle = enableGodMode()
local invisibilityToggle = enableInvisibility()

-- Интерфейс панели
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Кнопка для открытия панели
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 50)
openButton.Position = UDim2.new(0.5, -50, 0.9, 0)
openButton.Text = "Открыть панель"
openButton.Parent = ScreenGui

-- Панель с кнопками
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 250)
panel.Position = UDim2.new(0.5, -150, 0.5, -125)
panel.Visible = false
panel.Parent = ScreenGui
-- Кнопка для включения/выключения невидимости
local invisibilityButton = Instance.new("TextButton")
invisibilityButton.Size = UDim2.new(0, 200, 0, 50)
invisibilityButton.Position = UDim2.new(0.5, -100, 0.7, 0)
invisibilityButton.Text = "Включить Невидимость"
invisibilityButton.Parent = panel

-- Подключение кнопок
openButton.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

flyButton.MouseButton1Click:Connect(function()
    flightToggle()
    if flyButton.Text == "Включить Полет" then
        flyButton.Text = "Выключить Полет"
    else
        flyButton.Text = "Включить Полет"
    end
end)

godModeButton.MouseButton1Click:Connect(function()
    godModeToggle()
    if godModeButton.Text == "Включить Бессмертие" then
        godModeButton.Text = "Выключить Бессмертие"
    else
        godModeButton.Text = "Включить Бессмертие"
    end
end)

invisibilityButton.MouseButton1Click:Connect(function()
    invisibilityToggle()
    if invisibilityButton.Text == "Включить Невидимость" then
        invisibilityButton.Text = "Выключить Невидимость"
    else
        invisibilityButton.Text = "Включить Невидимость"
    end
end)

-- Кнопка для включения/выключения полета
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.1, 0)
flyButton.Text = "Включить Полет"
flyButton.Parent = panel

-- Кнопка для включения/выключения бессмертия
local godModeButton = Instance.new("TextButton")
godModeButton.Size = UDim2.new(0, 200, 0, 50)
godModeButton.Position = UDim2.new(0.5, -100, 0.4, 0)
godModeButton.Text = "Включить Бессмертие"
godModeButton.Parent = panel
