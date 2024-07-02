local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if _G.TacizV2Loaded then
    warn("Taciz V2 zaten yüklü!")
    return
end
_G.TacizV2Loaded = true

-- UI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 300)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
}
Gradient.Rotation = 90
Gradient.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.Text = "Taciz V2"
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
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -90)
ContentFrame.Position = UDim2.new(0, 0, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local pages = {}

local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.25, -2, 1, 0)
    TabButton.Position = UDim2.new(0.25 * (#pages), 1, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.Parent = TabFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -10)
    Page.Position = UDim2.new(0, 10, 0, 5)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
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

-- Sayfaları oluşturma
local ESPPage = createTab("ESP")
local AimbotPage = createTab("Aimbot")
local PlayerPage = createTab("Oyuncu")
local AuthorPage = createTab("Author")

-- Toggle fonksiyonu
local function createToggle(parent, text, posY, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 0, 35)
    Toggle.Position = UDim2.new(0, 10, 0, posY)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 16
    Toggle.Font = Enum.Font.GothamSemibold
    Toggle.Text = text .. ": OFF"
    Toggle.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Toggle

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = text .. ": " .. (enabled and "ON" or "OFF")
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)
        callback(enabled)
    end)

    return Toggle
end

-- ESP ayarları
local espEnabled = false
local boxEspEnabled = false
local nameEspEnabled = false
local teamCheckEnabled = false
local teamColor = Color3.new(0, 1, 0)
local enemyColor = Color3.new(1, 0, 0)

createToggle(ESPPage, "ESP Etkin", 10, function(enabled)
    espEnabled = enabled
end)

createToggle(ESPPage, "Kutu ESP", 55, function(enabled)
    boxEspEnabled = enabled
end)

createToggle(ESPPage, "İsim ESP", 100, function(enabled)
    nameEspEnabled = enabled
end)

createToggle(ESPPage, "Takım Kontrolü", 145, function(enabled)
    teamCheckEnabled = enabled
end)

-- Aimbot ayarları
local aimbot = false
local max_player_distance = 800
local distance = 5
local current_player = nil
local teamCheck = false
local autoSwitch = true

local AimbotToggle = createToggle(AimbotPage, "Aimbot", 10, function(enabled)
    aimbot = enabled
end)

local TeamCheckToggle = createToggle(AimbotPage, "Takım Kontrolü", 55, function(enabled)
    teamCheck = enabled
end)

local AutoSwitchToggle = createToggle(AimbotPage, "Otomatik Geçiş", 100, function(enabled)
    autoSwitch = enabled
end)

local DistanceSlider = Instance.new("TextBox")
DistanceSlider.Size = UDim2.new(1, -20, 0, 35)
DistanceSlider.Position = UDim2.new(0, 10, 0, 145)
DistanceSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DistanceSlider.TextColor3 = Color3.new(1, 1, 1)
DistanceSlider.TextSize = 16
DistanceSlider.Font = Enum.Font.GothamSemibold
DistanceSlider.Text = "Mesafe: " .. distance
DistanceSlider.Parent = AimbotPage

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 5)
Corner.Parent = DistanceSlider

DistanceSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newDistance = tonumber(DistanceSlider.Text:match("%d+"))
        if newDistance then
            distance = math.clamp(newDistance, 1, 20)
            DistanceSlider.Text = "Mesafe: " .. distance
        end
    end
end)

-- Oyuncu takip etme özelliği
local followEnabled = false
local targetPlayer = nil

local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(1, -20, 0, 35)
PlayerInput.Position = UDim2.new(0, 10, 0, 10)
PlayerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerInput.TextColor3 = Color3.new(1, 1, 1)
PlayerInput.TextSize = 16
PlayerInput.Font = Enum.Font.GothamSemibold
PlayerInput.PlaceholderText = "Oyuncu adı"
PlayerInput.Text = ""
PlayerInput.Parent = PlayerPage

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 5)
Corner.Parent = PlayerInput

local FollowButton = Instance.new("TextButton")
FollowButton.Size = UDim2.new(1, -20, 0, 35)
FollowButton.Position = UDim2.new(0, 10, 0, 55)
FollowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FollowButton.TextColor3 = Color3.new(1, 1, 1)
FollowButton.TextSize = 16
FollowButton.Font = Enum.Font.GothamSemibold
FollowButton.Text = "Takip Et"
FollowButton.Parent = PlayerPage

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 5)
Corner.Parent = FollowButton

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, -20, 0, 35)
TeleportButton.Position = UDim2.new(0, 10, 0, 100)
TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.TextSize = 16
TeleportButton.Font = Enum.Font.GothamSemibold
TeleportButton.Text = "Işınlan"
TeleportButton.Parent = PlayerPage

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 5)
Corner.Parent = TeleportButton

local TeleportStatus = Instance.new("TextLabel")
TeleportStatus.Size = UDim2.new(1, -20, 0, 35)
TeleportStatus.Position = UDim2.new(0, 10, 0, 145)
TeleportStatus.BackgroundTransparency = 1
TeleportStatus.TextColor3 = Color3.new(1, 1, 1)
TeleportStatus.TextSize = 16
TeleportStatus.Font = Enum.Font.GothamSemibold
TeleportStatus.Text = ""
TeleportStatus.Parent = PlayerPage

FollowButton.MouseButton1Click:Connect(function()
    local playerName = PlayerInput.Text
    targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer then
        followEnabled = not followEnabled
        FollowButton.Text = followEnabled and "Takibi Durdur" or "Takip Et"
        FollowButton.BackgroundColor3 = followEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)
    else
        warn("Oyuncu bulunamadı: " .. playerName)
    end
end)

TeleportButton.MouseButton1Click:Connect(function()
    local playerName = PlayerInput.Text
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local playerRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and playerRoot then
            TeleportButton.Text = "Işınlanıyor..."
            TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            TeleportStatus.Text = "Işınlanmaya 3 saniye..."
            
            for i = 3, 1, -1 do
                TeleportStatus.Text = "Işınlanmaya " .. i .. " saniye..."
                wait(1)
            end
            
            playerRoot.CFrame = targetRoot.CFrame
            TeleportButton.Text = "Işınlan"
            TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TeleportStatus.Text = "Işınlanma tamamlandı!"
            wait(2)
            TeleportStatus.Text = ""
        end
    else
        warn("Oyuncu bulunamadı veya karakteri yok: " .. playerName)
        TeleportStatus.Text = "Oyuncu bulunamadı!"
        wait(2)
        TeleportStatus.Text = ""
    end
end)

-- Author sayfası içeriği
local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(1, -20, 0, 35)
AuthorLabel.Position = UDim2.new(0, 10, 0, 10)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.TextColor3 = Color3.new(1, 1, 1)
AuthorLabel.TextSize = 20
AuthorLabel.Font = Enum.Font.GothamSemibold
AuthorLabel.Text = "Author: SpeX & Halitcim"
AuthorLabel.Parent = AuthorPage

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

    espItems[player] = esp
end

local function updateESP()
    for player, esp in pairs(espItems) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            local isVisible = onScreen and espEnabled
            esp.box.Visible = isVisible and boxEspEnabled
            esp.name.Visible = isVisible and nameEspEnabled
            
            if isVisible then
                local color = (teamCheckEnabled and player.Team == game.Players.LocalPlayer.Team) and teamColor or enemyColor
                esp.box.Color = color
                esp.name.Color = color
                
                local topLeft = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-3, 3, 0)).Position)
                local topRight = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(3, 3, 0)).Position)
                local bottomLeft = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-3, -3, 0)).Position)
                local bottomRight = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(3, -3, 0)).Position)

                esp.box.PointA = Vector2.new(topLeft.X, topLeft.Y)
                esp.box.PointB = Vector2.new(topRight.X, topRight.Y)
                esp.box.PointC = Vector2.new(bottomRight.X, bottomRight.Y)
                esp.box.PointD = Vector2.new(bottomLeft.X, bottomLeft.Y)

                esp.name.Position = Vector2.new(pos.X, topLeft.Y - 20)
                esp.name.Text = player.Name
            end
        else
            esp.box.Visible = false
            esp.name.Visible = false
        end
    end
end

-- Aimbot fonksiyonu
local function updateAimbot()
    if not aimbot then 
        current_player = nil
        return 
    end

    local local_player = game.Players.LocalPlayer
    local local_character = local_player.Character

    if not local_character then return end

    local local_root = local_character:FindFirstChild("HumanoidRootPart")
    if not local_root then return end

    if current_player == nil or (autoSwitch and current_player:FindFirstChild("Humanoid") and current_player.Humanoid.Health <= 0) then
        local closest_distance = math.huge
        local closest_player = nil

        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= local_player then
                local character = player.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")

                    if root and humanoid and humanoid.Health > 0 and root.Position.Z <= 3500 then
                        if teamCheck and player.Team == local_player.Team then
                            continue
                        end

                        local player_distance = (root.Position - local_root.Position).Magnitude
                        if player_distance <= max_player_distance and player_distance < closest_distance then
                            closest_distance = player_distance
                            closest_player = character
                        end
                    end
                end
            end
        end

        current_player = closest_player
    end

    if current_player then
        local enemy_root = current_player:FindFirstChild("HumanoidRootPart")
        if enemy_root then
            local target_position = enemy_root.Position + (local_root.Position - enemy_root.Position).Unit * distance

            local camera = game.Workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, enemy_root.Position)
            local_root.CFrame = CFrame.new(target_position, enemy_root.Position)
        end
    end
end

-- Oyuncu takip etme fonksiyonu
local function followPlayer()
    if followEnabled and targetPlayer and targetPlayer.Character and game.Players.LocalPlayer.Character then
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local playerRoot = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local playerHumanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if targetRoot and playerRoot and playerHumanoid then
            local direction = (targetRoot.Position - playerRoot.Position).Unit
            local targetPosition = targetRoot.Position - direction * 5
            playerHumanoid:MoveTo(targetPosition)
        end
    end
end

-- Ana döngü
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
    
    updateAimbot()
    followPlayer()
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

-- F3 tuşu ile menüyü açıp kapatma
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F3 then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Başlangıçta ilk sayfayı görünür yapma
if #pages > 0 then
    pages[1].Visible = true
end

print("Taciz V2 başarıyla yüklendi!")