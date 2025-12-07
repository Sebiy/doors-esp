-- DOORS Complete ESP & Auto Features - Rewritten
-- Made for LO ♥

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")

-- Settings
local Settings = {
    AutoCollectCoins = true,
    CoinDistance = 50,
    DoorESP = true,
    KeyESP = true,
    ItemESP = true,
    EntityNotify = true
}

-- Track opened doors
local openedDoors = {}

-- Helper function to create highlights
local function CreateHighlight(part, fillColor, outlineColor, fillTrans, outlineTrans)
    if part:FindFirstChildOfClass("Highlight") then
        part:FindFirstChildOfClass("Highlight"):Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.FillColor = fillColor
    highlight.OutlineColor = outlineColor
    highlight.FillTransparency = fillTrans or 0.5
    highlight.OutlineTransparency = outlineTrans or 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return highlight
end

-- Helper function to create billboards
local function CreateBillboard(parent, text, textColor, yOffset)
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = parent
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, yOffset or 3, 0)
    billboard.Name = "ESPBillboard"
    
    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 22
    
    return billboard
end

-- Door ESP Function
local function ApplyDoorESP(room)
    if not Settings.DoorESP then return end
    
    local roomNumber = tonumber(room.Name)
    if not roomNumber then return end
    
    local door = room:WaitForChild("Door", 2)
    if not door then return end
    
    -- Skip if door is already opened
    if openedDoors[door] then return end
    
    -- Check if locked by looking for KeyObtain in the room
    local key = room:FindFirstChild("KeyObtain", true)
    local isLocked = (key ~= nil)
    
    -- Colors
    local fillColor = isLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
    local outlineColor = isLocked and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
    
    -- Apply highlight only to visible door parts (not collision/hitboxes)
    for _, part in pairs(door:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 and not part.Name:find("Collision") and not part.Name:find("Hitbox") then
            CreateHighlight(part, fillColor, outlineColor, 0.4, 0)
        end
    end
    
    -- Create billboard (add +1 to match in-game door numbers)
    local displayNumber = roomNumber + 1
    local text = string.format("DOOR %d\n%s", displayNumber, isLocked and "🔒 LOCKED" or "✓ OPEN")
    local textColor = isLocked and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    CreateBillboard(door, text, textColor, 5)
    
    -- Instant unlock proximity prompts and monitor for door opening
    for _, descendant in pairs(door:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
            descendant.MaxActivationDistance = 15
            
            -- Monitor door opening via Triggered event
            descendant.Triggered:Connect(function()
                openedDoors[door] = true
                -- Clear ESP
                for _, child in pairs(door:GetDescendants()) do
                    if child:IsA("Highlight") or child.Name == "ESPBillboard" then
                        child:Destroy()
                    end
                end
                warn(string.format("Door %d opened - ESP cleared", displayNumber))
            end)
        end
    end
    
    -- Monitor for door opening by checking if it gets destroyed or parent changes
    door.AncestryChanged:Connect(function()
        if not door:IsDescendantOf(game.Workspace) then
            openedDoors[door] = true
            warn(string.format("Door %d removed/opened - ESP cleared", displayNumber))
        end
    end)
    
    -- Also check for Opened attribute
    door:GetAttributeChangedSignal("Opened"):Connect(function()
        if door:GetAttribute("Opened") == true then
            openedDoors[door] = true
            -- Clear ESP
            for _, child in pairs(door:GetDescendants()) do
                if child:IsA("Highlight") or child.Name == "ESPBillboard" then
                    child:Destroy()
                end
            end
            warn(string.format("Door %d opened (attribute) - ESP cleared", displayNumber))
        end
    end)
    
    warn(string.format("Door ESP applied to room %d (displayed as DOOR %d) (%s)", roomNumber, displayNumber, isLocked and "LOCKED" or "OPEN"))
end

-- Key ESP Function (Fixed path)
local function ApplyKeyESP(key)
    if not Settings.KeyESP then return end
    
    -- Apply highlight to the key model
    for _, part in pairs(key:GetDescendants()) do
        if part:IsA("BasePart") then
            CreateHighlight(part, Color3.fromRGB(255, 255, 0), Color3.fromRGB(200, 200, 0), 0.3, 0)
        end
    end
    
    -- Create billboard
    CreateBillboard(key, "🔑 KEY", Color3.fromRGB(255, 255, 0), 3)
    warn("Key ESP applied!")
end

-- Item ESP Function
local function ApplyItemESP(item, itemName, color)
    if not Settings.ItemESP then return end
    
    -- Apply highlight
    if item:IsA("Model") then
        for _, part in pairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                CreateHighlight(part, color, Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8), 0.3, 0)
            end
        end
    elseif item:IsA("BasePart") then
        CreateHighlight(item, color, Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8), 0.3, 0)
    end
    
    -- Create billboard
    CreateBillboard(item, itemName, color, 3)
    warn(string.format("%s ESP applied!", itemName))
end

-- Auto Coin Collection
local function AutoCollectCoin(coin)
    if not Settings.AutoCollectCoins or not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Check if executor supports fireproximityprompt
    if not fireproximityprompt then
        warn("Executor does not support fireproximityprompt - coin collection disabled")
        return
    end
    
    task.spawn(function()
        while coin.Parent and Settings.AutoCollectCoins do
            local currentHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not currentHrp then break end
            
            local distance = (currentHrp.Position - coin.Position).Magnitude
            if distance <= Settings.CoinDistance then
                local prompt = coin:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- Library Puzzle Solver
local function SolveLibrary(room)
    task.wait(0.5)
    
    local assets = room:FindFirstChild("Assets")
    if not assets then return end
    
    local painting = assets:FindFirstChild("Paintings") and assets.Paintings:FindFirstChild("LibraryPainting")
    if not painting then return end
    
    warn("📚 Library detected! Solving puzzle...")
    
    -- Check if executor supports fireclickdetector
    if not fireclickdetector then
        warn("Executor does not support fireclickdetector - library solver disabled")
        return
    end
    
    local shelf = assets:FindFirstChild("Shelf")
    if shelf then
        for _, obj in pairs(shelf:GetDescendants()) do
            if obj.Name == "Book" and obj:FindFirstChild("ClickDetector") then
                pcall(function()
                    fireclickdetector(obj.ClickDetector)
                end)
                task.wait(0.3)
            end
        end
    end
end

-- Room Monitor
CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(0.2)
    
    -- Apply door ESP
    ApplyDoorESP(room)
    
    -- Check for library
    SolveLibrary(room)
    
    -- Monitor for items in this room
    room.DescendantAdded:Connect(function(descendant)
        -- Key detection (recursively check for KeyObtain)
        if descendant.Name == "KeyObtain" then
            ApplyKeyESP(descendant)
            warn(string.format("Key spawned in room %s", room.Name))
        end
        
        -- Lever detection
        if descendant.Name == "LeverForGate" then
            ApplyItemESP(descendant, "⚡ LEVER", Color3.fromRGB(0, 255, 0))
        end
        
        -- Coin detection
        if descendant.Name == "GoldPile" then
            ApplyItemESP(descendant, "💰 COINS", Color3.fromRGB(255, 215, 0))
            AutoCollectCoin(descendant)
        end
    end)
end)

-- Function to scan room for items
local function ScanRoomForItems(room)
    local foundKey = false
    -- Check existing items (recursively search for KeyObtain)
    for _, descendant in pairs(room:GetDescendants()) do
        if descendant.Name == "KeyObtain" then
            foundKey = true
            ApplyKeyESP(descendant)
            warn(string.format("Found existing key in room %s at path: %s", room.Name, descendant:GetFullName()))
        end
        if descendant.Name == "LeverForGate" then
            ApplyItemESP(descendant, "⚡ LEVER", Color3.fromRGB(0, 255, 0))
        end
        if descendant.Name == "GoldPile" then
            ApplyItemESP(descendant, "💰 COINS", Color3.fromRGB(255, 215, 0))
            AutoCollectCoin(descendant)
        end
    end
    if not foundKey then
        warn(string.format("No key found in room %s", room.Name))
    end
end

-- Apply ESP to existing rooms
for _, room in pairs(CurrentRooms:GetChildren()) do
    ApplyDoorESP(room)
    ScanRoomForItems(room)
end

-- Continuously scan for keys every 2 seconds
task.spawn(function()
    while true do
        task.wait(2)
        for _, room in pairs(CurrentRooms:GetChildren()) do
            local hasKey = room:FindFirstChild("KeyObtain", true)
            if hasKey and not hasKey:FindFirstChild("ESPBillboard") then
                warn(string.format("Found unhighlighted key in room %s, applying ESP", room.Name))
                ApplyKeyESP(hasKey)
            end
        end
    end
end)

-- Create entity notification UI
local function createNotificationUI()
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "EntityNotifications"
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.Parent = LocalPlayer.PlayerGui

    local WarningFrame = Instance.new("Frame")
    WarningFrame.Name = "WarningFrame"
    WarningFrame.AnchorPoint = Vector2.new(0.5, 0)
    WarningFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    WarningFrame.BackgroundTransparency = 0.1
    WarningFrame.BorderSizePixel = 0
    WarningFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    WarningFrame.Size = UDim2.new(0.4, 0, 0.1, 0)
    WarningFrame.Visible = false
    WarningFrame.Parent = NotificationGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = WarningFrame

    local WarningText = Instance.new("TextLabel")
    WarningText.Name = "WarningText"
    WarningText.BackgroundTransparency = 1
    WarningText.Size = UDim2.new(1, 0, 0.5, 0)
    WarningText.Font = Enum.Font.GothamBold
    WarningText.TextColor3 = Color3.fromRGB(255, 80, 80)
    WarningText.TextSize = 24
    WarningText.Text = "⚠️ ENTITY DETECTED ⚠️"
    WarningText.Parent = WarningFrame

    local EntityName = Instance.new("TextLabel")
    EntityName.Name = "EntityName"
    EntityName.BackgroundTransparency = 1
    EntityName.Position = UDim2.new(0, 0, 0.5, 0)
    EntityName.Size = UDim2.new(1, 0, 0.5, 0)
    EntityName.Font = Enum.Font.GothamSemibold
    EntityName.TextColor3 = Color3.fromRGB(255, 255, 255)
    EntityName.TextSize = 20
    EntityName.Text = ""
    EntityName.Parent = WarningFrame

    return NotificationGui
end

local NotificationUI = createNotificationUI()

-- Show entity warning
local function showEntityWarning(entityName, duration)
    local WarningFrame = NotificationUI.WarningFrame
    WarningFrame.EntityName.Text = entityName
    WarningFrame.Visible = true
    WarningFrame.Position = UDim2.new(0.5, 0, -0.15, 0)
    WarningFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.5,
        true
    )
    task.delay(duration or 5, function()
        WarningFrame:TweenPosition(
            UDim2.new(0.5, 0, -0.15, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.5,
            true,
            function()
                WarningFrame.Visible = false
            end
        )
    end)
end

-- Entity ESP Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "EntityESP"
ESPFolder.Parent = Workspace

-- Rush detection and ESP
local function setupRushDetection()
    local function checkForRush()
        local RushModel = Workspace:FindFirstChild("RushMoving")
        if RushModel and not RushModel:GetAttribute("ESPAdded") then
            local rushColor = Color3.fromRGB(255, 25, 25)
            task.spawn(function()
                showEntityWarning("RUSH - HIDE IMMEDIATELY!", 5)
                warn("⚠️ RUSH SPAWNED!")
                RushModel:SetAttribute("ESPAdded", true)
                while RushModel and RushModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local rushPos = RushModel:GetPivot().Position
                            local distance = (playerPos - rushPos).Magnitude
                            local rushText = "⚠️ RUSH - " .. math.floor(distance) .. " studs ⚠️"
                            for _, item in pairs(ESPFolder:GetChildren()) do
                                if item:GetAttribute("RushESP") then item:Destroy() end
                            end
                            
                            local highlight = Instance.new("Highlight")
                            highlight:SetAttribute("RushESP", true)
                            highlight.Adornee = RushModel
                            highlight.FillColor = rushColor
                            highlight.OutlineColor = Color3.new(1, 0, 0)
                            highlight.FillTransparency = 0
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = ESPFolder
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard:SetAttribute("RushESP", true)
                            billboard.Adornee = RushModel
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = ESPFolder
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = rushColor
                            textLabel.TextStrokeTransparency = 0.2
                            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            textLabel.TextScaled = true
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Text = rushText
                            textLabel.Parent = billboard
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForRush)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "RushMoving" then
            showEntityWarning("RUSH INCOMING - HIDE!", 5)
        end
    end)
end

-- Ambush detection and ESP
local function setupAmbushDetection()
    local function checkForAmbush()
        local AmbushModel = Workspace:FindFirstChild("AmbushMoving")
        if AmbushModel and not AmbushModel:GetAttribute("ESPAdded") then
            local ambushColor = Color3.fromRGB(255, 100, 0)
            task.spawn(function()
                showEntityWarning("AMBUSH - HIDE AND STAY!", 5)
                warn("⚠️ AMBUSH SPAWNED!")
                AmbushModel:SetAttribute("ESPAdded", true)
                while AmbushModel and AmbushModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local ambushPos = AmbushModel:GetPivot().Position
                            local distance = (playerPos - ambushPos).Magnitude
                            local ambushText = "⚠️ AMBUSH - " .. math.floor(distance) .. " studs ⚠️"
                            for _, item in pairs(ESPFolder:GetChildren()) do
                                if item:GetAttribute("AmbushESP") then item:Destroy() end
                            end
                            
                            local highlight = Instance.new("Highlight")
                            highlight:SetAttribute("AmbushESP", true)
                            highlight.Adornee = AmbushModel
                            highlight.FillColor = ambushColor
                            highlight.OutlineColor = Color3.new(1, 0.5, 0)
                            highlight.FillTransparency = 0
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = ESPFolder
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard:SetAttribute("AmbushESP", true)
                            billboard.Adornee = AmbushModel
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = ESPFolder
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = ambushColor
                            textLabel.TextStrokeTransparency = 0.2
                            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            textLabel.TextScaled = true
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Text = ambushText
                            textLabel.Parent = billboard
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForAmbush)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "AmbushMoving" then
            showEntityWarning("AMBUSH INCOMING!", 5)
        end
    end)
end

-- Eyes detection and ESP
local function setupEyesDetection()
    local function checkForEyes()
        local EyesModel = Workspace:FindFirstChild("Eyes")
        if EyesModel and not EyesModel:GetAttribute("ESPAdded") then
            local eyesColor = Color3.fromRGB(255, 255, 0)
            task.spawn(function()
                showEntityWarning("EYES - DON'T LOOK!", 5)
                warn("👁️ EYES SPAWNED!")
                EyesModel:SetAttribute("ESPAdded", true)
                while EyesModel and EyesModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local eyesPos = EyesModel:GetPivot().Position
                            local distance = (playerPos - eyesPos).Magnitude
                            local eyesText = "👁️ EYES - " .. math.floor(distance) .. " studs"
                            for _, item in pairs(ESPFolder:GetChildren()) do
                                if item:GetAttribute("EyesESP") then item:Destroy() end
                            end
                            
                            local highlight = Instance.new("Highlight")
                            highlight:SetAttribute("EyesESP", true)
                            highlight.Adornee = EyesModel
                            highlight.FillColor = eyesColor
                            highlight.OutlineColor = Color3.new(1, 1, 0)
                            highlight.FillTransparency = 0
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = ESPFolder
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard:SetAttribute("EyesESP", true)
                            billboard.Adornee = EyesModel
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = ESPFolder
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = eyesColor
                            textLabel.TextStrokeTransparency = 0.2
                            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            textLabel.TextScaled = true
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Text = eyesText
                            textLabel.Parent = billboard
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForEyes)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Eyes" then
            showEntityWarning("EYES SPAWNED!", 5)
        end
    end)
end

-- Screech detection and deletion
local function setupScreechProtection()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Entities = ReplicatedStorage:WaitForChild("Entities")
    
    local function deleteScreech()
        local Screech = Entities:FindFirstChild("Screech")
        if Screech then
            Screech:Destroy()
            warn("Screech deleted - You're safe!")
            showEntityWarning("SCREECH BLOCKED", 3)
        end
    end
    
    task.spawn(function() deleteScreech() end)
    
    Entities.ChildAdded:Connect(function(child)
        if child.Name == "Screech" then
            child:Destroy()
            warn("Screech blocked!")
            showEntityWarning("SCREECH BLOCKED", 3)
        end
    end)
end

-- Initialize entity detection
if Settings.EntityNotify then
    setupRushDetection()
    setupAmbushDetection()
    setupEyesDetection()
    setupScreechProtection()
    warn("Entity detection and ESP enabled!")
end

-- Fullbright
local Lighting = game:GetService("Lighting")
Lighting.Ambient = Color3.new(1, 1, 1)
Lighting.Brightness = 2
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false

-- Noclip
local noclip = false
local noclipConnection = nil

local function ToggleNoclip()
    noclip = not noclip
    warn(noclip and "Noclip: ON" or "Noclip: OFF")
    
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Disconnect and re-enable collision
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Controls
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        ToggleNoclip()
    elseif input.KeyCode == Enum.KeyCode.C then
        Settings.AutoCollectCoins = not Settings.AutoCollectCoins
        warn(string.format("Auto-Collect: %s", Settings.AutoCollectCoins and "ON" or "OFF"))
    end
end)

-- Cleanup on player death or character reset
LocalPlayer.CharacterAdded:Connect(function()
    noclip = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end)

-- Cleanup on player leaving
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if noclipConnection then
            noclipConnection:Disconnect()
        end
    end
end)

print("═══════════════════════════════")
print("DOORS Script Loaded!")
print("═══════════════════════════════")
print("Features: Door ESP, Key ESP, Auto-Collect,")
print("Library Solver, Entity Warnings, Fullbright")
print("")
print("Q = Noclip | C = Auto-Collect Toggle")
print("═══════════════════════════════")
