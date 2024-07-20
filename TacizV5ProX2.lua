local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

if _G.TV5L then return end
_G.TV5L = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 900, 0, 550)
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
end

CreateCorner(MainFrame)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 40)
TitleLabel.Position = UDim2.new(0, 20, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 24
TitleLabel.Text = "Taciz V5 Pro X2"
TitleLabel.Parent = MainFrame

local function RainbowText(object)
    local t = 0
    RunService.RenderStepped:Connect(function(delta)
        t = t + delta
        local r = math.sin(t * 2) * 0.5 + 0.5
        local g = math.sin(t * 2 + 2) * 0.5 + 0.5
        local b = math.sin(t * 2 + 4) * 0.5 + 0.5
        object.TextColor3 = Color3.new(r, g, b)
    end)
end

RainbowText(TitleLabel)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -40, 0, 10)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame
CreateCorner(MinimizeButton, 5)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function CreateCategory(name)
    local category = Instance.new("ScrollingFrame")
    category.Size = UDim2.new(0.25, -10, 1, 0)
    category.BackgroundTransparency = 1
    category.ScrollBarThickness = 6
    category.Parent = ContentFrame

    local categoryLabel = Instance.new("TextLabel")
    categoryLabel.Size = UDim2.new(1, 0, 0, 30)
    categoryLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    categoryLabel.TextColor3 = Color3.new(1, 1, 1)
    categoryLabel.TextSize = 18
    categoryLabel.Font = Enum.Font.GothamBold
    categoryLabel.Text = name
    categoryLabel.Parent = category
    CreateCorner(categoryLabel)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = category
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    return category
end

local function CreateToggle(parent, text, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextSize = 16
    toggle.Font = Enum.Font.GothamSemibold
    toggle.Text = text
    toggle.Parent = parent
    CreateCorner(toggle)

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 40, 120)
        callback(enabled)
    end)

    return toggle
end

local function CreateSlider(parent, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -10, 0, 50)
    slider.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    slider.Parent = parent
    CreateCorner(slider)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 16
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 5)
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    sliderBar.Parent = slider
    CreateCorner(sliderBar, 2)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 20)
    knob.Position = UDim2.new((default - min) / (max - min), -5, 0, -7.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = sliderBar
    CreateCorner(knob, 2)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.Text = tostring(default)
    valueLabel.Parent = slider

    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBar.AbsolutePosition
            local sliderSize = sliderBar.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            knob.Position = UDim2.new(relativeX, -5, 0, -7.5)
            local value = math.floor(min + (max - min) * relativeX)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)

    return slider
end

local function CreateKeybind(parent, text, default, callback)
    local keybind = Instance.new("Frame")
    keybind.Size = UDim2.new(1, -10, 0, 30)
    keybind.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    keybind.Parent = parent
    CreateCorner(keybind)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 16
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = keybind

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 80, 1, -10)
    keyLabel.Position = UDim2.new(1, -90, 0, 5)
    keyLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    keyLabel.TextColor3 = Color3.new(1, 1, 1)
    keyLabel.TextSize = 14
    keyLabel.Font = Enum.Font.GothamSemibold
    keyLabel.Text = default.Name
    keyLabel.Parent = keybind
    CreateCorner(keyLabel)

    local currentKey = default
    local listening = false

    keyLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            listening = true
            keyLabel.Text = "..."
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            keyLabel.Text = currentKey.Name
            listening = false
            callback(currentKey)
        end
    end)

    return keybind
end

local ESPEnabled, NameESPEnabled, HealthESPEnabled, TeamCheck = false, false, false, false
local TeamColor, EnemyColor = Color3.new(0, 1, 0), Color3.new(1, 0, 0)

local AimbotEnabled = false
local AimbotKey = Enum.KeyCode.X
local AimbotRange = 1000
local AimbotTeamCheck = false
local RageAimbotEnabled = false
local AutoShootEnabled = false

local HitSoundEnabled = false
local HitSound = Instance.new("Sound")
HitSound.SoundId = "rbxassetid://705502934"
HitSound.Volume = 1
HitSound.Parent = game:GetService("SoundService")

local ESPCategory = CreateCategory("ESP")
local AimbotCategory = CreateCategory("Aimbot")
local MiscCategory = CreateCategory("Misc")
local AuthorCategory = CreateCategory("Fun")

ESPCategory.Position = UDim2.new(0, 0, 0, 0)
AimbotCategory.Position = UDim2.new(0.25, 0, 0, 0)
MiscCategory.Position = UDim2.new(0.5, 0, 0, 0)
AuthorCategory.Position = UDim2.new(0.75, 0, 0, 0)

CreateToggle(ESPCategory, "ESP", function(enabled) ESPEnabled = enabled end)
CreateToggle(ESPCategory, "İsim ESP", function(enabled) NameESPEnabled = enabled end)
CreateToggle(ESPCategory, "Can Barı ESP", function(enabled) HealthESPEnabled = enabled end)
CreateToggle(ESPCategory, "Takım Kontrolü", function(enabled) TeamCheck = enabled end)

CreateToggle(AimbotCategory, "Aimbot", function(enabled) AimbotEnabled = enabled end)
CreateKeybind(AimbotCategory, "Aimbot Tuşu", AimbotKey, function(key) AimbotKey = key end)
CreateSlider(AimbotCategory, "Aimbot Menzili", 100, 5000, AimbotRange, function(value) AimbotRange = value end)
CreateToggle(AimbotCategory, "Aimbot Takım Kontrolü", function(enabled) AimbotTeamCheck = enabled end)
CreateToggle(AimbotCategory, "Rage Aimbot", function(enabled) RageAimbotEnabled = enabled end)
CreateToggle(AimbotCategory, "Auto Shoot", function(enabled) AutoShootEnabled = enabled end)

CreateToggle(MiscCategory, "Hit Sound", function(enabled) HitSoundEnabled = enabled end)

local StraightBulletEnabled = false
CreateToggle(MiscCategory, "Düz Mermi Gitme", function(enabled)
    StraightBulletEnabled = enabled
    if game.ReplicatedStorage:FindFirstChild("Bullet") then
        local originalBullet = game.ReplicatedStorage.Bullet:Clone()
        game.ReplicatedStorage.Bullet.Trajectory = function(...)
            if StraightBulletEnabled then
                return Vector3.new(0, 0, -1)
            else
                return originalBullet.Trajectory(...)
            end
        end
    end
end)

local InfiniteJumpEnabled = false
CreateToggle(MiscCategory, "Sınırsız Zıplama", function(enabled) InfiniteJumpEnabled = enabled end)

local NightModeEnabled = false
local OriginalSky = Lighting:GetChildren()[1]:Clone()
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalBrightness = Lighting.Brightness

local function SetNightMode(enabled)
    if enabled then
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0.05, 0.05, 0.05)
        Lighting.Brightness = 0.1
        Lighting:GetChildren()[1]:Destroy()
        local newSky = Instance.new("Sky")
        newSky.SkyboxBk = "rbxassetid://12064107"
        newSky.SkyboxDn = "rbxassetid://12064152"
        newSky.SkyboxFt = "rbxassetid://12064121"
        newSky.SkyboxLf = "rbxassetid://12063984"
        newSky.SkyboxRt = "rbxassetid://12064115"
        newSky.SkyboxUp = "rbxassetid://12064131"
        newSky.Parent = Lighting
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        Lighting.Brightness = OriginalBrightness
        Lighting:GetChildren()[1]:Destroy()
        OriginalSky:Clone().Parent = Lighting
    end
end

CreateToggle(MiscCategory, "Night Mode", function(enabled)
    NightModeEnabled = enabled
    SetNightMode(enabled)
end)

local SpeedHackEnabled = false
local SpeedMultiplier = 2

local function SafeUpdateSpeed()
    local player = Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if SpeedHackEnabled then
                humanoid.WalkSpeed = 16 * SpeedMultiplier
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
end

CreateToggle(MiscCategory, "Speed Hack", function(enabled)
    SpeedHackEnabled = enabled
    SafeUpdateSpeed()
end)

CreateSlider(MiscCategory, "Speed Multiplier", 1, 10, 2, function(value)
    SpeedMultiplier = value
    if SpeedHackEnabled then SafeUpdateSpeed() end
end)

local AutoDodgeEnabled = false
CreateToggle(MiscCategory, "Auto Dodge", function(enabled)
    AutoDodgeEnabled = enabled
end)

local TeleportEnabled = false
local TeleportTarget = ""
CreateToggle(MiscCategory, "Teleport", function(enabled)
    TeleportEnabled = enabled
end)

local TeleportInput = Instance.new("TextBox")
TeleportInput.Size = UDim2.new(1, -10, 0, 30)
TeleportInput.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
TeleportInput.TextColor3 = Color3.new(1, 1, 1)
TeleportInput.TextSize = 14
TeleportInput.Font = Enum.Font.GothamSemibold
TeleportInput.Text = "Enter player name"
TeleportInput.Parent = MiscCategory
CreateCorner(TeleportInput)

TeleportInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        TeleportTarget = TeleportInput.Text
        if TeleportEnabled then
            local targetPlayer = Players:FindFirstChild(TeleportTarget)
            if targetPlayer and targetPlayer.Character then
                local countdown = 4
                while countdown > 0 do
                    TeleportInput.Text = "Teleporting in " .. countdown
                    wait(1)
                    countdown = countdown - 1
                end
                Players.LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.PrimaryPart.CFrame)
                TeleportInput.Text = "Teleported to " .. TeleportTarget
            else
                TeleportInput.Text = "Player not found"
            end
        end
    end
end)

local RapidFireEnabled = false
CreateToggle(MiscCategory, "Rapid Fire", function(enabled)
    RapidFireEnabled = enabled
end)


local ESPItems = {}

local function CreateESPItem(player)
    local espItem = {
        box = Drawing.new("Quad"),
        name = Drawing.new("Text"),
        healthBar = Drawing.new("Line")
    }
    
    espItem.box.Thickness = 2
    espItem.box.Filled = false
    espItem.box.Transparency = 1
    espItem.box.Color = Color3.new(1, 0, 0)

    espItem.name.Size = 20
    espItem.name.Center = true
    espItem.name.Outline = true
    espItem.name.Color = Color3.new(1, 1, 1)

    espItem.healthBar.Thickness = 2
    espItem.healthBar.Transparency = 1

    ESPItems[player] = espItem
end

local function UpdateESP()
    for player, espItem in pairs(ESPItems) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            local isVisible = onScreen and ESPEnabled
            
            espItem.box.Visible = isVisible
            espItem.name.Visible = isVisible and NameESPEnabled
            espItem.healthBar.Visible = isVisible and HealthESPEnabled
            
            if isVisible then
                local isSameTeam = TeamCheck and player.Team == Players.LocalPlayer.Team
                local color = isSameTeam and TeamColor or EnemyColor
                espItem.box.Color = color
                espItem.name.Color = color
                
                local function ToScreen(vector)
                    local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(vector)
                    return Vector2.new(screenPoint.X, screenPoint.Y)
                end
                
                local size = Vector3.new(4, 5, 2)
                local cf = rootPart.CFrame
                
                local topLeft, topRight, bottomLeft, bottomRight = cf * CFrame.new(-size.X, size.Y, -size.Z), cf * CFrame.new(size.X, size.Y, -size.Z), cf * CFrame.new(-size.X, -size.Y, -size.Z), cf * CFrame.new(size.X, -size.Y, -size.Z)
                
                espItem.box.PointA, espItem.box.PointB, espItem.box.PointC, espItem.box.PointD = ToScreen(topLeft.Position), ToScreen(topRight.Position), ToScreen(bottomRight.Position), ToScreen(bottomLeft.Position)

                espItem.name.Position = Vector2.new(screenPos.X, ToScreen(topLeft.Position).Y - 20)
                espItem.name.Text = player.Name

                if humanoid then
                    local health = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    local healthPercentage = health / maxHealth

                    espItem.healthBar.From = ToScreen(bottomLeft.Position) - Vector2.new(5, 0)
                    espItem.healthBar.To = espItem.healthBar.From + Vector2.new(0, -5 * healthPercentage)
                    espItem.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercentage), 255 * healthPercentage, 0)
                end
            end
        else
            espItem.box.Visible = false
            espItem.name.Visible = false
            espItem.healthBar.Visible = false
        end
    end
end

local function PlayHitSound()
    if HitSoundEnabled then HitSound:Play() end
end

local AimbotTarget = nil
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = Players.LocalPlayer
    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if localRoot then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if not AimbotTeamCheck or player.Team ~= localPlayer.Team then
                    local root = player.Character.HumanoidRootPart
                    local _, onScreen = workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        local distance = (root.Position - localRoot.Position).Magnitude
                        if distance < shortestDistance and distance <= AimbotRange then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function UpdateAimbot()
    if AimbotEnabled and (UserInputService:IsKeyDown(AimbotKey) or RageAimbotEnabled) then
        AimbotTarget = GetClosestPlayer()
    else
        AimbotTarget = nil
    end
    
    if AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("Head") then
        local head = AimbotTarget.Character.Head
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
        
        if AutoShootEnabled then
            local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Shoot") then
                tool.Shoot:FireServer(head.Position)
            end
        end
    end
end

local function UpdateCharacter(character)
    if character then
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.HipHeight = 2
            humanoid.JumpPower = 50
            humanoid.WalkSpeed = 16

            humanoid.Died:Connect(function()
                wait(3)
                local newCharacter = Players.LocalPlayer.CharacterAdded:Wait()
                UpdateCharacter(newCharacter)
            end)
        end
    end
end


local function AutoDodge()
    if AutoDodgeEnabled and Players.LocalPlayer.Character then
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local rootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, object in pairs(workspace:GetDescendants()) do
                    if object:IsA("BasePart") and object.Name == "Bullet" then
                        local distance = (object.Position - rootPart.Position).Magnitude
                        if distance < 10 then
                            local dodgeDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
                            humanoid:MoveTo(rootPart.Position + dodgeDirection * 5)
                            wait(0.1) -- Add a small delay to prevent constant dodging
                            break
                        end
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    SafeUpdateSpeed()
    if ESPEnabled then UpdateESP() end
    UpdateAimbot()
    AutoDodge()
    
    if RapidFireEnabled then
        local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Shoot") then
            tool.Shoot:FireServer(workspace.CurrentCamera.CFrame.LookVector * 1000)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.Space and InfiniteJumpEnabled then
            local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

Players.PlayerAdded:Connect(CreateESPItem)

Players.PlayerRemoving:Connect(function(player)
    if ESPItems[player] then
        for _, drawing in pairs(ESPItems[player]) do drawing:Remove() end
        ESPItems[player] = nil
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then CreateESPItem(player) end
end

local function HookDamageEvent()
    local damageEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DamageEvent")
    if damageEvent then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if self == damageEvent and method == "FireServer" then PlayHitSound() end
            
            return oldNamecall(self, ...)
        end)
    end
end

HookDamageEvent()

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 900, 0, 60)
        MinimizeButton.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 900, 0, 550)
        MinimizeButton.Text = "-"
    end
end)

Players.LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

if Players.LocalPlayer.Character then
    UpdateCharacter(Players.LocalPlayer.Character)
end

-- Aimbot improvements
local function UpdateAimbotTarget()
    local mousePosition = UserInputService:GetMouseLocation()
    local closestDistance = math.huge
    local closestPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not AimbotTeamCheck or player.Team ~= Players.LocalPlayer.Team then
                local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(mousePosition.X, mousePosition.Y) - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    if distance < closestDistance and distance <= AimbotRange then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Update the UpdateAimbot function
local function UpdateAimbot()
    if AimbotEnabled and (UserInputService:IsKeyDown(AimbotKey) or RageAimbotEnabled) then
        AimbotTarget = UpdateAimbotTarget()
    else
        AimbotTarget = nil
    end
    
    if AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("Head") then
        local head = AimbotTarget.Character.Head
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
        
        if AutoShootEnabled then
            local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Shoot") then
                tool.Shoot:FireServer(head.Position)
            end
        end
    end
end

-- Improve Auto Dodge
local function AutoDodge()
    if AutoDodgeEnabled and Players.LocalPlayer.Character then
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart then
            for _, object in pairs(workspace:GetDescendants()) do
                if object:IsA("BasePart") and (object.Name == "Bullet" or object.Name == "Projectile") then
                    local distance = (object.Position - rootPart.Position).Magnitude
                    if distance < 15 then
                        local dodgeDirection = (rootPart.Position - object.Position).Unit
                        humanoid:MoveTo(rootPart.Position + dodgeDirection * 10)
                        wait(0.2)
                        break
                    end
                end
            end
        end
    end
end

-- Update the main loop
RunService.Heartbeat:Connect(function()
    SafeUpdateSpeed()
    if ESPEnabled then UpdateESP() end
    UpdateAimbot()
    AutoDodge()
    
    if RapidFireEnabled then
        local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Shoot") then
            tool.Shoot:FireServer(workspace.CurrentCamera.CFrame.LookVector * 1000)
        end
    end
end)

-- God Mode
local GodModeEnabled = false
CreateToggle(MiscCategory, "God Mode", function(enabled)
    GodModeEnabled = enabled
    if enabled then
        local function onCharacterAdded(character)
            wait(0.5)
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.MaxHealth = math.huge
                character.Humanoid.Health = math.huge
            end
        end
        
        if Players.LocalPlayer.Character then
            onCharacterAdded(Players.LocalPlayer.Character)
        end
        Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    else
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
            Players.LocalPlayer.Character.Humanoid.Health = 100
        end
    end
end)

-- Noclip
local NoclipEnabled = false
CreateToggle(MiscCategory, "Noclip", function(enabled)
    NoclipEnabled = enabled
    
    local function updateNoclip()
        if Players.LocalPlayer.Character then
            for _, part in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not NoclipEnabled
                end
            end
        end
    end
    
    RunService.Stepped:Connect(updateNoclip)
end)


-- Anti-Kick
local AntiKickEnabled = false
CreateToggle(MiscCategory, "Anti-Kick", function(enabled)
    AntiKickEnabled = enabled
    if enabled then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" and AntiKickEnabled then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- Silent Walk
local SilentWalkEnabled = false
CreateToggle(AuthorCategory, "Silent Walk", function(enabled)
    SilentWalkEnabled = enabled
    if enabled then
        local function silentWalk()
            if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = Players.LocalPlayer.Character.Humanoid
                humanoid.Running:Connect(function(speed)
                    if speed > 0 then
                        humanoid.WalkSpeed = 0
                    end
                end)
            end
        end
        silentWalk()
        Players.LocalPlayer.CharacterAdded:Connect(silentWalk)
    else
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Anti-Aim Resolver
local AntiAimResolverEnabled = false
CreateToggle(AimbotCategory, "Anti-Aim Resolver", function(enabled)
    AntiAimResolverEnabled = enabled
    if enabled then
        RunService.RenderStepped:Connect(function()
            if AntiAimResolverEnabled and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = Players.LocalPlayer.Character.HumanoidRootPart
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(math.random(-10, 10)), 0)
            end
        end)
    end
end)

local PingSpooferEnabled = false
CreateToggle(AuthorCategory, "Ping Spoofer", function(enabled)
    PingSpooferEnabled = enabled
    if enabled then
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if PingSpooferEnabled and key == "Ping" and self ~= Players.LocalPlayer then
                return math.random(200, 1000)
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
end)

local SilentAimbotEnabled = false
CreateToggle(AimbotCategory, "Silent Aimbot", function(enabled)
    SilentAimbotEnabled = enabled
end)

local function GetSilentAimbotTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = Players.LocalPlayer
    local localCharacter = localPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if localRoot then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if not AimbotTeamCheck or player.Team ~= localPlayer.Team then
                    local root = player.Character.HumanoidRootPart
                    local _, onScreen = workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        local distance = (root.Position - localRoot.Position).Magnitude
                        if distance < shortestDistance and distance <= AimbotRange then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if SilentAimbotEnabled and method == "FireServer" and self.Name == "Shoot" then
        local target = GetSilentAimbotTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[1] = target.Character.Head.Position
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

-- Taciz Etme Özelliği
local TacizEnabled = false
local TacizTarget = nil
local TacizDistance = 5 -- Varsayılan mesafe

local TacizPlayerInput = Instance.new("TextBox")
TacizPlayerInput.Size = UDim2.new(1, -10, 0, 30)
TacizPlayerInput.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
TacizPlayerInput.TextColor3 = Color3.new(1, 1, 1)
TacizPlayerInput.TextSize = 14
TacizPlayerInput.Font = Enum.Font.GothamSemibold
TacizPlayerInput.Text = "Taciz edilecek oyuncu adı"
TacizPlayerInput.Parent = MiscCategory
CreateCorner(TacizPlayerInput)

local TacizToggle = CreateToggle(MiscCategory, "Taciz Et", function(enabled)
    TacizEnabled = enabled
    if enabled then
        local targetName = TacizPlayerInput.Text
        TacizTarget = Players:FindFirstChild(targetName)
        if not TacizTarget then
            TacizPlayerInput.Text = "Oyuncu bulunamadı"
            TacizEnabled = false
        end
    else
        TacizTarget = nil
    end
end)

local TacizDistanceSlider = CreateSlider(MiscCategory, "Taciz Mesafesi", 1, 10, 5, function(value)
    TacizDistance = value
end)

RunService.Heartbeat:Connect(function()
    if TacizEnabled and TacizTarget and TacizTarget.Character and Players.LocalPlayer.Character then
        local targetRoot = TacizTarget.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            local targetCFrame = targetRoot.CFrame
            local direction = (targetRoot.Position - localRoot.Position).Unit
            local newPosition = targetRoot.Position - direction * TacizDistance
            
            localRoot.CFrame = CFrame.new(newPosition, targetRoot.Position)
            
            -- Hedef oyuncunun hareketlerini taklit et
            local targetHumanoid = TacizTarget.Character:FindFirstChildOfClass("Humanoid")
            local localHumanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            if targetHumanoid and localHumanoid then
                localHumanoid.Jump = targetHumanoid.Jump
                localHumanoid:Move(targetHumanoid.MoveDirection, false)
            end
        end
    end
end)


local AutoDoorOpenEnabled = false
CreateToggle(AuthorCategory, "Otomatik Kapı Açma", function(enabled)
    AutoDoorOpenEnabled = enabled
    while AutoDoorOpenEnabled do
        local character = Players.LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Door") and (v.Position - humanoidRootPart.Position).Magnitude <= 10 then
                        v:Activate()
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- 25. Otomatik Mermi Doldurma
local AutoReloadEnabled = false
CreateToggle(AuthorCategory, "Otomatik Mermi Doldurma", function(enabled)
    AutoReloadEnabled = enabled
    while AutoReloadEnabled do
        local character = Players.LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") and tool:FindFirstChild("MaxAmmo") then
                if tool.Ammo.Value < tool.MaxAmmo.Value then
                    tool.Reload:FireServer()
                end
            end
        end
        wait(0.5)
    end
end)



-- 2. Duvar Yürüme
local WallWalkEnabled = false
CreateToggle(AuthorCategory, "Duvar Yürüme", function(enabled)
    WallWalkEnabled = enabled
    if enabled then
        workspace.Gravity = 0
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    else
        workspace.Gravity = 196.2
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end)

-- 3. Görünmezlik
local InvisibilityEnabled = false
CreateToggle(AuthorCategory, "Görünmezlik", function(enabled)
    InvisibilityEnabled = enabled
    if enabled then
        local character = Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
        end
    else
        local character = Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
    end
end)

-- 4. Otomatik Respawn
local AutoRespawnEnabled = false
CreateToggle(AuthorCategory, "Otomatik Respawn", function(enabled)
    AutoRespawnEnabled = enabled
    if enabled then
        Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
            if AutoRespawnEnabled then
                wait(1)
                Players.LocalPlayer:LoadCharacter()
            end
        end)
    end
end)

-- 5. Karakter Boyutu Değiştirme
local CharacterScaleSlider = CreateSlider(MiscCategory, "Karakter Boyutu", 0.5, 3, 1, function(value)
    local character = Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * (value / character:WaitForChild("Humanoid").RootPart.Size.Y)
            end
        end
        character:WaitForChild("Humanoid").RootPart.Size = Vector3.new(2 * value, 2 * value, 1 * value)
    end
end)

-- 6. Hızlı Yeniden Doğma
local QuickRespawnButton = Instance.new("TextButton")
QuickRespawnButton.Size = UDim2.new(1, -10, 0, 30)
QuickRespawnButton.Position = UDim2.new(0, 5, 0, CharacterScaleSlider.Position.Y.Offset + 35)
QuickRespawnButton.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
QuickRespawnButton.TextColor3 = Color3.new(1, 1, 1)
QuickRespawnButton.TextSize = 14
QuickRespawnButton.Font = Enum.Font.GothamSemibold
QuickRespawnButton.Text = "Hızlı Yeniden Doğ"
QuickRespawnButton.Parent = MiscCategory
CreateCorner(QuickRespawnButton)

QuickRespawnButton.MouseButton1Click:Connect(function()
    Players.LocalPlayer.Character:BreakJoints()
    Players.LocalPlayer:LoadCharacter()
end)

-- 7. Düşük Yer Çekimi
local LowGravityEnabled = false
CreateToggle(AuthorCategory, "Düşük Yer Çekimi", function(enabled)
    LowGravityEnabled = enabled
    if enabled then
        workspace.Gravity = 50
    else
        workspace.Gravity = 196.2
    end
end)

-- 8. Otomatik Zıplama
local AutoJumpEnabled = false
CreateToggle(AuthorCategory, "Otomatik Zıplama", function(enabled)
    AutoJumpEnabled = enabled
    while AutoJumpEnabled do
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            Players.LocalPlayer.Character.Humanoid.Jump = true
        end
        wait(0.1)
    end
end)

-- 9. Karakter Işık Efekti
local CharacterLightEnabled = false
local CharacterLight = nil
CreateToggle(AuthorCategory, "Karakter Işığı", function(enabled)
    CharacterLightEnabled = enabled
    if enabled then
        CharacterLight = Instance.new("PointLight")
        CharacterLight.Brightness = 1
        CharacterLight.Range = 16
        CharacterLight.Parent = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    else
        if CharacterLight then
            CharacterLight:Destroy()
            CharacterLight = nil
        end
    end
end)


-- 14. Karakter Hız Göstergesi
local SpeedIndicatorEnabled = false
local SpeedIndicator = nil
CreateToggle(AuthorCategory, "Hız Göstergesi", function(enabled)
    SpeedIndicatorEnabled = enabled
    if enabled then
        SpeedIndicator = Instance.new("TextLabel")
        SpeedIndicator.Size = UDim2.new(0, 150, 0, 25)
        SpeedIndicator.Position = UDim2.new(0.5, -75, 0.9, 0)
        SpeedIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
        SpeedIndicator.BackgroundTransparency = 0.5
        SpeedIndicator.TextColor3 = Color3.new(1, 1, 1)
        SpeedIndicator.Font = Enum.Font.SourceSansBold
        SpeedIndicator.TextSize = 14
        SpeedIndicator.Parent = ScreenGui
        
        RunService.RenderStepped:Connect(function()
            if SpeedIndicatorEnabled and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local velocity = Players.LocalPlayer.Character.HumanoidRootPart.Velocity
                local speed = math.floor(velocity.Magnitude)
                SpeedIndicator.Text = "Hız: " .. speed .. " studs/s"
            end
        end)
    else
        if SpeedIndicator then
            SpeedIndicator:Destroy()
            SpeedIndicator = nil
        end
    end
end)


-- 26. Rastgele Dans
local RandomDanceEnabled = false
CreateToggle(AuthorCategory, "Rastgele Dans", function(enabled)
    RandomDanceEnabled = enabled
    while RandomDanceEnabled do
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            local animations = {"27789359", "30196114", "28488254", "30196181", "27789253"}
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. animations[math.random(1, #animations)]
            local track = Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
            track:Play()
            wait(track.Length)
        end
        wait(1)
    end
end)

-- 27. Parti Modu
local PartyModeEnabled = false
local OriginalLighting = {}
CreateToggle(AuthorCategory, "Parti Modu", function(enabled)
    PartyModeEnabled = enabled
    if enabled then
        OriginalLighting = {
            Ambient = Lighting.Ambient,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
            ColorShift_Top = Lighting.ColorShift_Top
        }
        while PartyModeEnabled do
            Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
            Lighting.ColorShift_Bottom = Color3.new(math.random(), math.random(), math.random())
            Lighting.ColorShift_Top = Color3.new(math.random(), math.random(), math.random())
            wait(0.1)
        end
    else
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
        Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
    end
end)

-- 28. Çığlık Modu
local ScreamModeEnabled = false
CreateToggle(AuthorCategory, "Çığlık Modu", function(enabled)
    ScreamModeEnabled = enabled
    while ScreamModeEnabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local args = {
                    [1] = "Ahhhhhhh!",
                    [2] = "All"
                }
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
            end
        end
        wait(5)
    end
end)

-- 29. Karakter Karıştırıcı
local CharacterScramblerEnabled = false
CreateToggle(AuthorCategory, "Karakter Karıştırıcı", function(enabled)
    CharacterScramblerEnabled = enabled
    while CharacterScramblerEnabled do
        if Players.LocalPlayer.Character then
            for _, part in pairs(Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CFrame = part.CFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)))
                end
            end
        end
        wait(0.1)
    end
end)

-- 30. Sahte Lag
local FakeLagEnabled = false
CreateToggle(AuthorCategory, "Sahte Lag", function(enabled)
    FakeLagEnabled = enabled
    while FakeLagEnabled do
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = Players.LocalPlayer.Character.HumanoidRootPart.Position
            wait(0.2)
            if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos)
            end
        end
        wait(0.5)
    end
end)

-- 31. Konfeti Yağmuru
local ConfetiRainEnabled = false
CreateToggle(AuthorCategory, "Konfeti Yağmuru", function(enabled)
    ConfetiRainEnabled = enabled
    while ConfetiRainEnabled do
        local confeti = Instance.new("Part")
        confeti.Size = Vector3.new(0.1, 0.1, 0.1)
        confeti.Position = Players.LocalPlayer.Character.Head.Position + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
        confeti.Anchored = false
        confeti.CanCollide = false
        confeti.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        confeti.Parent = workspace
        game:GetService("Debris"):AddItem(confeti, 2)
        wait(0.05)
    end
end)

-- 32. Kedi Sesi Modu
local CatSoundModeEnabled = false
local CatSound = Instance.new("Sound")
CatSound.SoundId = "rbxassetid://9086208486" -- Kedi miyavlama sesi
CatSound.Volume = 1
CatSound.Parent = game:GetService("SoundService")

CreateToggle(AuthorCategory, "Kedi Sesi Modu", function(enabled)
    CatSoundModeEnabled = enabled
    while CatSoundModeEnabled do
        CatSound:Play()
        wait(math.random(3, 10))
    end
end)

-- 33. Zıplayan Metin
local BouncingTextEnabled = false
local BouncingText = nil
CreateToggle(AuthorCategory, "Zıplayan Metin", function(enabled)
    BouncingTextEnabled = enabled
    if enabled then
        BouncingText = Instance.new("TextLabel")
        BouncingText.Size = UDim2.new(0, 200, 0, 50)
        BouncingText.Position = UDim2.new(0.5, -100, 0.5, -25)
        BouncingText.BackgroundTransparency = 1
        BouncingText.TextColor3 = Color3.new(1, 1, 1)
        BouncingText.Font = Enum.Font.GothamBold
        BouncingText.TextSize = 24
        BouncingText.Text = "Zıplıyorum!"
        BouncingText.Parent = ScreenGui

        local function animateText()
            while BouncingTextEnabled do
                for i = 1, 10 do
                    BouncingText.Position = BouncingText.Position + UDim2.new(0, 0, 0, -1)
                    wait(0.05)
                end
                for i = 1, 10 do
                    BouncingText.Position = BouncingText.Position + UDim2.new(0, 0, 0, 1)
                    wait(0.05)
                end
            end
        end
        coroutine.wrap(animateText)()
    else
        if BouncingText then
            BouncingText:Destroy()
            BouncingText = nil
        end
    end
end)

-- 34. Rastgele Teleport
local RandomTeleportEnabled = false
CreateToggle(AuthorCategory, "Rastgele Teleport", function(enabled)
    RandomTeleportEnabled = enabled
    while RandomTeleportEnabled do
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
            if randomPlayer ~= Players.LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            end
        end
        wait(5)
    end
end)

-- 35. Dönme Modu
local SpinModeEnabled = false
CreateToggle(AuthorCategory, "Dönme Modu", function(enabled)
    SpinModeEnabled = enabled
    while SpinModeEnabled do
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
        wait(0.01)
    end
end)


print("Taciz V5 Pro X2 başarıyla yüklendi!")