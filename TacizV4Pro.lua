local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

if _G.TacizV4Loaded then
    warn("Taciz V4 zaten yüklü!")
    return
end
_G.TacizV4Loaded = true

-- UI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 400)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI bileşenleri oluşturma fonksiyonları
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function createGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }
    gradient.Rotation = 90
    gradient.Parent = parent
    return gradient
end

-- UI bileşenlerini oluştur
createCorner(MainFrame)
createGradient(MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 32
Title.Font = Enum.Font.GothamBold
Title.Text = "Taciz V4"
Title.Parent = MainFrame

-- RGB efekti için fonksiyon
local function rgbEffect(obj)
    local i = 0
    RunService.RenderStepped:Connect(function()
        i = (i + 0.001) % 1
        obj.TextColor3 = Color3.fromHSV(i, 1, 1)
    end)
end

rgbEffect(Title)

-- Tab ve içerik oluşturma fonksiyonları
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0.25, 0, 1, -60)
TabFrame.Position = UDim2.new(0, 0, 0, 60)
TabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabFrame.Parent = MainFrame
createCorner(TabFrame)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.75, 0, 1, -60)
ContentFrame.Position = UDim2.new(0.25, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local pages = {}

local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Position = UDim2.new(0, 5, 0, 45 * (#pages))
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.TextSize = 18
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.Parent = TabFrame
    createCorner(TabButton)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -10)
    Page.Position = UDim2.new(0, 10, 0, 5)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 6
    Page.Visible = false
    Page.Parent = ContentFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do
            p.Visible = false
        end
        Page.Visible = true
    end)

    table.insert(pages, Page)
    return Page
end

-- Sayfaları oluştur
local ESPPage = createTab("ESP")
local AimbotPage = createTab("Aimbot")
local PlayerPage = createTab("Oyuncu")
local MiscPage = createTab("Özellikler")
local AuthorPage = createTab("Author")

-- Toggle fonksiyonu
local function createToggle(parent, text, posY, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 0, 40)
    Toggle.Position = UDim2.new(0, 10, 0, posY)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 18
    Toggle.Font = Enum.Font.GothamSemibold
    Toggle.Text = text .. ": OFF"
    Toggle.Parent = parent
    createCorner(Toggle)

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = text .. ": " .. (enabled and "ON" or "OFF")
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)

    return Toggle
end

-- Slider fonksiyonu
local function createSlider(parent, text, posY, minValue, maxValue, defaultValue, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -20, 0, 60)
    Slider.Position = UDim2.new(0, 10, 0, posY)
    Slider.BackgroundTransparency = 1
    Slider.Parent = parent

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = text .. ": " .. defaultValue
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamSemibold
    Title.Parent = Slider

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 5)
    SliderBar.Position = UDim2.new(0, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Parent = Slider
    createCorner(SliderBar, 5)

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 15, 0, 25)
    SliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7.5, 0, -10)
    SliderButton.Text = ""
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Parent = SliderBar
    createCorner(SliderButton, 15)

    local Value = Instance.new("TextBox")
    Value.Size = UDim2.new(0, 60, 0, 25)
    Value.Position = UDim2.new(1, -60, 0, 35)
    Value.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Value.TextColor3 = Color3.new(1, 1, 1)
    Value.TextSize = 16
    Value.Font = Enum.Font.GothamSemibold
    Value.Text = tostring(defaultValue)
    Value.Parent = Slider
    createCorner(Value)

    local dragging = false

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBar.AbsolutePosition.X
            local sliderWidth = SliderBar.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * relativePos)
            
            SliderButton.Position = UDim2.new(relativePos, -7.5, 0, -10)
            Title.Text = text .. ": " .. value
            Value.Text = tostring(value)
            callback(value)
        end
    end)

    Value.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local inputValue = tonumber(Value.Text)
            if inputValue then
                local clampedValue = math.clamp(inputValue, minValue, maxValue)
                local relativePos = (clampedValue - minValue) / (maxValue - minValue)
                SliderButton.Position = UDim2.new(relativePos, -7.5, 0, -10)
                Title.Text = text .. ": " .. clampedValue
                Value.Text = tostring(clampedValue)
                callback(clampedValue)
            else
                Value.Text = tostring(defaultValue)
            end
        end
    end)

    return Slider
end

-- ESP ayarları
local espEnabled = false
local boxEspEnabled = false
local nameEspEnabled = false
local healthBarEnabled = false
local teamCheckEnabled = false
local antenEnabled = false
local teamColor = Color3.new(0, 1, 0)
local enemyColor = Color3.new(1, 0, 0)
local renderDistance = 1000

createToggle(ESPPage, "ESP Etkin", 10, function(enabled)
    espEnabled = enabled
end)

createToggle(ESPPage, "Kutu ESP", 60, function(enabled)
    boxEspEnabled = enabled
end)

createToggle(ESPPage, "İsim ESP", 110, function(enabled)
    nameEspEnabled = enabled
end)

createToggle(ESPPage, "Can Barı ESP", 160, function(enabled)
    healthBarEnabled = enabled
end)

createToggle(ESPPage, "Takım Kontrolü", 210, function(enabled)
    teamCheckEnabled = enabled
end)

createToggle(ESPPage, "Anten ESP", 260, function(enabled)
    antenEnabled = enabled
end)

createSlider(ESPPage, "Render Mesafesi", 310, 100, 2000, 1000, function(value)
    renderDistance = value
end)

-- Aimbot ve Auto Shot ayarları
local aimbot = false
local autoShot = false
local aimbotKey = Enum.KeyCode.X
local teamCheck = false
local autoSwitch = true
local aimbotDistance = 1000
local targetPlayerName = ""

local AimbotToggle = createToggle(AimbotPage, "Aimbot", 10, function(enabled)
    aimbot = enabled
end)

local AutoShotToggle = createToggle(AimbotPage, "Auto Shot", 60, function(enabled)
    autoShot = enabled
end)

createToggle(AimbotPage, "Takım Kontrolü", 110, function(enabled)
    teamCheck = enabled
end)

createToggle(AimbotPage, "Otomatik Geçiş", 160, function(enabled)
    autoSwitch = enabled
end)

createSlider(AimbotPage, "Aimbot Mesafesi", 210, 10, 2000, 1000, function(value)
    aimbotDistance = value
end)

local TargetPlayerInput = Instance.new("TextBox")
TargetPlayerInput.Size = UDim2.new(1, -20, 0, 40)
TargetPlayerInput.Position = UDim2.new(0, 10, 0, 280)
TargetPlayerInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TargetPlayerInput.TextColor3 = Color3.new(1, 1, 1)
TargetPlayerInput.TextSize = 18
TargetPlayerInput.Font = Enum.Font.GothamSemibold
TargetPlayerInput.PlaceholderText = "Hedef Oyuncu Adı"
TargetPlayerInput.Text = ""
TargetPlayerInput.Parent = AimbotPage
createCorner(TargetPlayerInput)

TargetPlayerInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        targetPlayerName = TargetPlayerInput.Text
    end
end)

local AimbotKeyLabel = Instance.new("TextLabel")
AimbotKeyLabel.Size = UDim2.new(1, -20, 0, 40)
AimbotKeyLabel.Position = UDim2.new(0, 10, 0, 330)
AimbotKeyLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotKeyLabel.TextColor3 = Color3.new(1, 1, 1)
AimbotKeyLabel.TextSize = 18
AimbotKeyLabel.Font = Enum.Font.GothamSemibold
AimbotKeyLabel.Text = "Aimbot Tuşu: " .. aimbotKey.Name
AimbotKeyLabel.Parent = AimbotPage
createCorner(AimbotKeyLabel)

local AimbotKeyButton = Instance.new("TextButton")
AimbotKeyButton.Size = UDim2.new(1, -20, 0, 40)
AimbotKeyButton.Position = UDim2.new(0, 10, 0, 380)
AimbotKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotKeyButton.TextColor3 = Color3.new(1, 1, 1)
AimbotKeyButton.TextSize = 18
AimbotKeyButton.Font = Enum.Font.GothamSemibold
AimbotKeyButton.Text = "Aimbot Tuşunu Değiştir"
AimbotKeyButton.Parent = AimbotPage
createCorner(AimbotKeyButton)

AimbotKeyButton.MouseButton1Click:Connect(function()
    AimbotKeyButton.Text = "Tuşa basın..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            aimbotKey = input.KeyCode
            AimbotKeyLabel.Text = "Aimbot Tuşu: " .. aimbotKey.Name
            AimbotKeyButton.Text = "Aimbot Tuşunu Değiştir"
            connection:Disconnect()
        end
    end)
end)

-- Mevlana Modu (güncellenmiş versiyon)
local mevlanaEnabled = false
local mevlanaSpeed = 10

createToggle(AimbotPage, "Mevlana Modu", 430, function(enabled)
    mevlanaEnabled = enabled
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if enabled then
        -- Mevlana modu aktif
        RunService:BindToRenderStep("MevlanaSpin", Enum.RenderPriority.Character.Value, function(dt)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(mevlanaSpeed), 0)
        end)
    else
        -- Mevlana modu deaktif
        RunService:UnbindFromRenderStep("MevlanaSpin")
    end
end)

createSlider(AimbotPage, "Mevlana Hızı", 480, 1, 1000, 10, function(value)
    mevlanaSpeed = value
end)

-- Oyuncu sayfası
local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(1, -20, 0, 40)
PlayerInput.Position = UDim2.new(0, 10, 0, 10)
PlayerInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerInput.TextColor3 = Color3.new(1, 1, 1)
PlayerInput.TextSize = 18
PlayerInput.Font = Enum.Font.GothamSemibold
PlayerInput.PlaceholderText = "Oyuncu Adı"
PlayerInput.Text = ""
PlayerInput.Parent = PlayerPage
createCorner(PlayerInput)

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, -20, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0, 60)
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.TextSize = 18
TeleportButton.Font = Enum.Font.GothamSemibold
TeleportButton.Text = "Işınlan"
TeleportButton.Parent = PlayerPage
createCorner(TeleportButton)

local CountdownLabel = Instance.new("TextLabel")
CountdownLabel.Size = UDim2.new(1, -20, 0, 40)
CountdownLabel.Position = UDim2.new(0, 10, 0, 110)
CountdownLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CountdownLabel.TextColor3 = Color3.new(1, 1, 1)
CountdownLabel.TextSize = 18
CountdownLabel.Font = Enum.Font.GothamSemibold
CountdownLabel.Text = ""
CountdownLabel.Parent = PlayerPage
createCorner(CountdownLabel)

TeleportButton.MouseButton1Click:Connect(function()
    local playerName = PlayerInput.Text
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer then
        TeleportButton.Text = "Işınlanıyor..."
        for i = 3, 1, -1 do
            CountdownLabel.Text = "Işınlanmaya " .. i .. " saniye"
            wait(1)
        end
        CountdownLabel.Text = "Işınlanıyor!"
        local targetChar = targetPlayer.Character
        if targetChar then
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(targetRoot.CFrame)
                wait(0.5)
                CountdownLabel.Text = "Işınlanma tamamlandı!"
            else
                CountdownLabel.Text = "Hedef oyuncunun karakteri bulunamadı!"
            end
        else
            CountdownLabel.Text = "Hedef oyuncunun karakteri bulunamadı!"
        end
    else
        CountdownLabel.Text = "Oyuncu bulunamadı!"
    end
    TeleportButton.Text = "Işınlan"
    wait(2)
    CountdownLabel.Text = ""
end)

-- Özellikler sayfası
-- Duvardan Mermi Geçirme
local wallbangEnabled = false

createToggle(MiscPage, "Duvardan Mermi Geçirme", 10, function(enabled)
    wallbangEnabled = enabled
    if enabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Sınırsız Zıplama
local infiniteJumpEnabled = false

createToggle(MiscPage, "Sınırsız Zıplama", 60, function(enabled)
    infiniteJumpEnabled = enabled
end)

-- Uçma
local flyEnabled = false
local flySpeed = 50

createToggle(MiscPage, "Uçma", 110, function(enabled)
    flyEnabled = enabled
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    if enabled then
        local flyPart = Instance.new("BodyVelocity")
        flyPart.Parent = rootPart
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        RunService.RenderStepped:Connect(function()
            if flyEnabled then
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector

                local movement = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    movement = movement + lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    movement = movement - lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    movement = movement - rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    movement = movement + rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    movement = movement + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    movement = movement - Vector3.new(0, 1, 0)
                end

                flyPart.Velocity = movement.Unit * flySpeed
            else
                flyPart:Destroy()
            end
        end)
    end
end)

createSlider(MiscPage, "Uçma Hızı", 160, 1, 200, 50, function(value)
    flySpeed = value
end)

-- Gökkuşağı Karakter
local rainbowCharacterEnabled = false

createToggle(MiscPage, "Gökkuşağı Karakter", 220, function(enabled)
    rainbowCharacterEnabled = enabled
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    while rainbowCharacterEnabled do
        for i = 0, 1, 0.01 do
            if not rainbowCharacterEnabled then break end
            local color = Color3.fromHSV(i, 1, 1)
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
            wait(0.1)
        end
    end
end)

-- Hızlanma ve Zıplama Çarpanları
local speedMultiplier = 1
local jumpMultiplier = 1

createSlider(MiscPage, "Hız Çarpanı", 270, 1, 10, 1, function(value)
    speedMultiplier = value
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16 * speedMultiplier
end)

createSlider(MiscPage, "Zıplama Çarpanı", 330, 1, 10, 1, function(value)
    jumpMultiplier = value
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.JumpPower = 50 * jumpMultiplier
end)

-- İsim ve Kullanıcı Adı Gizleme
local hideNameEnabled = false

createToggle(MiscPage, "İsim ve Kullanıcı Adı Gizle", 390, function(enabled)
    hideNameEnabled = enabled
    local player = game.Players.LocalPlayer
    
    if enabled then
        -- İsmi ve kullanıcı adını gizle
        player.Name = ""
        player.DisplayName = ""
        if player.Character then
            if player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.DisplayName = ""
            end
        end
    else
        -- İsmi ve kullanıcı adını geri getir
        player.Name = player.UserId
        player.DisplayName = player.UserId
        if player.Character then
            if player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.DisplayName = player.DisplayName
            end
        end
    end
end)

-- Saniye başına mermi atışı hızı
local fireRateMultiplier = 1

createSlider(MiscPage, "Ateş Hızı Çarpanı", 450, 1, 10, 1, function(value)
    fireRateMultiplier = value
end)

-- Fast Reload
local fastReloadEnabled = false

createToggle(MiscPage, "Hızlı Şarjör Değiştirme", 510, function(enabled)
    fastReloadEnabled = enabled
end)

-- Author sayfası
local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(1, -20, 0, 40)
AuthorLabel.Position = UDim2.new(0, 10, 0, 10)
AuthorLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AuthorLabel.TextColor3 = Color3.new(1, 1, 1)
AuthorLabel.TextSize = 18
AuthorLabel.Font = Enum.Font.GothamSemibold
AuthorLabel.Text = "Authors: SpeX & Halitullah"
AuthorLabel.Parent = AuthorPage
createCorner(AuthorLabel)

-- ESP fonksiyonları
local espItems = {}

local function createESPItem(player)
    local esp = {}
    
    esp.box = Drawing.new("Quad")
    esp.box.Thickness = 2
    esp.box.Filled = false
    esp.box.Transparency = 1
    esp.box.Color = Color3.new(1, 0, 0)

    esp.name = Drawing.new("Text")
    esp.name.Size = 20
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = Color3.new(1, 1, 1)

    esp.healthBar = Drawing.new("Line")
    esp.healthBar.Thickness = 2
    esp.healthBar.Transparency = 1

    esp.anten = Drawing.new("Line")
    esp.anten.Thickness = 1
    esp.anten.Transparency = 1
    esp.anten.Color = Color3.new(1, 1, 1)

    espItems[player] = esp
end

local function updateESP()
    for player, esp in pairs(espItems) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            local isVisible = onScreen and espEnabled and distance <= renderDistance
            
            esp.box.Visible = isVisible and boxEspEnabled
            esp.name.Visible = isVisible and nameEspEnabled
            esp.healthBar.Visible = isVisible and healthBarEnabled
            esp.anten.Visible = isVisible and antenEnabled
            
            if isVisible then
                local isSameTeam = teamCheckEnabled and player.Team == game.Players.LocalPlayer.Team
                local color = isSameTeam and teamColor or enemyColor
                esp.box.Color = color
                esp.name.Color = color
                esp.anten.Color = color
                
                local topLeft = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-3, 3, 0)).Position)
                local topRight = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(3, 3, 0)).Position)
                local bottomLeft = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-3, -3, 0)).Position)
                local bottomRight = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(3, -3, 0)).Position)

                esp.box.PointA = Vector2.new(topLeft.X, topLeft.Y)
                esp.box.PointB = Vector2.new(topRight.X, topRight.Y)
                esp.box.PointC = Vector2.new(bottomRight.X, bottomRight.Y)
                esp.box.PointD = Vector2.new(bottomLeft.X, bottomLeft.Y)

                esp.name.Position = Vector2.new(pos.X, topLeft.Y - 20)
                esp.name.Text = player.Name .. " [" .. math.floor(distance) .. "m]"

                esp.anten.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                esp.anten.To = Vector2.new(pos.X, pos.Y)

                if humanoid then
                    local health = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    local healthPercent = health / maxHealth

                    esp.healthBar.From = Vector2.new(bottomLeft.X - 5, bottomLeft.Y)
                    esp.healthBar.To = Vector2.new(bottomLeft.X - 5, bottomLeft.Y - (bottomLeft.Y - topLeft.Y) * healthPercent)
                    esp.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                end
            end
        else
            esp.box.Visible = false
            esp.name.Visible = false
            esp.healthBar.Visible = false
            esp.anten.Visible = false
        end
    end
end

-- Aimbot ve Auto Shot fonksiyonu
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).magnitude
            if distance < shortestDistance and distance <= aimbotDistance and (not teamCheck or player.Team ~= game.Players.LocalPlayer.Team) then
                if targetPlayerName == "" or player.Name:lower() == targetPlayerName:lower() then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function updateAimbot()
    if not aimbot then return end

    local closestPlayer = getClosestPlayer()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local head = closestPlayer.Character.Head
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
    end
end

local function updateAutoShot()
    if not autoShot then return end

    local closestPlayer = getClosestPlayer()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local head = closestPlayer.Character.Head
        local args = {
            [1] = head.Position
        }
        game:GetService("ReplicatedStorage").Events.Fire:FireServer(unpack(args))
    end
end

-- Düz mermi atma fonksiyonu
local function straightShot(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local shootingPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        if shootingPart then
            local direction = (targetPosition - shootingPart.Position).Unit
            local args = {
                [1] = shootingPart.Position,
                [2] = direction
            }
            game:GetService("ReplicatedStorage").Events.Fire:FireServer(unpack(args))
        end
    end
end

-- Ana döngü
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
    
    if aimbot then
        updateAimbot()
    end

    if autoShot then
        updateAutoShot()
    end
end)

-- Yeni oyuncular için ESP oluşturma
Players.PlayerAdded:Connect(function(player)
    createESPItem(player)
end)

-- Oyuncular oyundan çıktığında ESP'yi temizleme
Players.PlayerRemoving:Connect(function(player)
    if espItems[player] then
        for _, drawing in pairs(espItems[player]) do
            drawing:Remove()
        end
        espItems[player] = nil
    end
end)

-- Mevcut oyuncular için ESP oluşturma
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        createESPItem(player)
    end
end

-- Sınırsız Zıplama için UserInputService bağlantısı
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- F3 tuşu ile menüyü açıp kapatma ve Aimbot tuşu kontrolü
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F3 then
            ScreenGui.Enabled = not ScreenGui.Enabled
        elseif input.KeyCode == aimbotKey then
            aimbot = not aimbot
            AimbotToggle.Text = "Aimbot: " .. (aimbot and "ON" or "OFF")
            AimbotToggle.BackgroundColor3 = aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 50)
        end
    end
end)

-- Başlangıçta ilk sayfayı görünür yapma
if #pages > 0 then
    pages[1].Visible = true
end

-- Karakter yeniden doğduğunda ayarları yeniden uygula
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if wallbangEnabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if mevlanaEnabled then
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        RunService:BindToRenderStep("MevlanaSpin", Enum.RenderPriority.Character.Value, function(dt)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(mevlanaSpeed), 0)
        end)
    end

    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16 * speedMultiplier
    humanoid.JumpPower = 50 * jumpMultiplier
end)

-- Workspace'e yeni nesneler eklendiğinde duvardan mermi geçirme özelliğini uygula
workspace.DescendantAdded:Connect(function(descendant)
    if wallbangEnabled and descendant:IsA("BasePart") then
        descendant.CanCollide = false
    end
end)

-- Düz mermi atma için mouse tıklama olayını dinle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = game.Players.LocalPlayer:GetMouse()
        local targetPosition = mouse.Hit.Position
        straightShot(targetPosition)
    end
end)

-- Ateş hızı ve hızlı şarjör değiştirme için olay dinleyicisi
local function onFired(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("Configuration") then
        local config = tool.Configuration
        if config:FindFirstChild("ReloadTime") and fastReloadEnabled then
            config.ReloadTime.Value = config.ReloadTime.Value / 2
        end
        if config:FindFirstChild("ShotCooldown") then
            config.ShotCooldown.Value = config.ShotCooldown.Value / fireRateMultiplier
        end
    end
end

game.Players.LocalPlayer.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        child.Activated:Connect(function()
            onFired(child)
        end)
    end
end)

print("Taciz V4 başarıyla yüklendi!")