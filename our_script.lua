-- DOORS Complete ESP & Auto Features - CLEAN REWRITE
-- Made for LO

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")

-- ═══════════════════════════════════════════════════════════
-- WAVE EXECUTOR DEBUG SYSTEM
-- ═══════════════════════════════════════════════════════════

-- Initialize Wave Executor debug output
local WaveDebug = {}
local function setupWaveDebug()
    -- Test multiple Wave API methods
    local waveAvailable = false

    -- Method 1: Check for wave global
    if wave then
        waveAvailable = true
        WaveDebug.print = function(msg)
            if wave.print then
                wave.print("[VESPER] " .. tostring(msg))
            else
                print("[VESPER] " .. tostring(msg))
            end
        end

        WaveDebug.debug = function(msg)
            if wave.debug then
                wave.debug("[VESPER-DEBUG] " .. tostring(msg))
            else
                print("[VESPER-DEBUG] " .. tostring(msg))
            end
        end

        WaveDebug.info = function(msg)
            if wave.log and wave.log.info then
                wave.log.info("[VESPER-INFO] " .. tostring(msg))
            else
                print("[VESPER-INFO] " .. tostring(msg))
            end
        end

        WaveDebug.warn = function(msg)
            if wave.log and wave.log.warn then
                wave.log.warn("[VESPER-WARN] " .. tostring(msg))
            else
                warn("[VESPER-WARN] " .. tostring(msg))
            end
        end

        WaveDebug.error = function(msg)
            if wave.log and wave.log.error then
                wave.log.error("[VESPER-ERROR] " .. tostring(msg))
            else
                warn("[VESPER-ERROR] " .. tostring(msg))
            end
        end

        -- Try to enable console redirection
        if wave.console then
            pcall(function() wave.console.redirect(true) end)
            pcall(function() wave.console.timestamp(true) end)
        end

        WaveDebug.info("Wave Executor debug system initialized! API detected.")

    else
        -- Fallback to standard print
        waveAvailable = false
        WaveDebug = {
            print = function(msg) print("[VESPER] " .. tostring(msg)) end,
            debug = function(msg) print("[VESPER-DEBUG] " .. tostring(msg)) end,
            info = function(msg) print("[VESPER-INFO] " .. tostring(msg)) end,
            warn = function(msg) warn("[VESPER-WARN] " .. tostring(msg)) end,
            error = function(msg) warn("[VESPER-ERROR] " .. tostring(msg)) end
        }
        WaveDebug.info("Wave Executor API not found - using fallback debug system")
    end

    return waveAvailable
end

setupWaveDebug()

-- Settings
local Settings = {
    DoorESP = false,
    DoorESPColor = Color3.fromRGB(255, 255, 0),
    ClosetESP = false,
    ClosetESPColor = Color3.fromRGB(85, 130, 255),
    ItemESP = false,
    ItemESPColor = Color3.fromRGB(130, 200, 255),
    ObjectiveESP = false,
    ObjectiveESPColor = Color3.fromRGB(168, 85, 247),
    GoldESP = false,
    GoldESPColor = Color3.fromRGB(255, 215, 0),
    KeyESP = false,
    KeyESPColor = Color3.fromRGB(255, 255, 0),
    EntityESP = false,
    EntityESPColor = Color3.fromRGB(255, 50, 50),
    PlayerESP = false,
    PlayerESPColor = Color3.fromRGB(255, 255, 255),
    RainbowESP = false,
    UseAdornments = false,
    EntityNotify = false,
    NotifyInChat = false,
    NotificationSound = false,
    RushESP = false,
    AmbushESP = false,
    EyesESP = false,
    ScreechProtection = false,
    InstantInteract = false,
    BreakVoid = false,
    NoCutscenes = false,
    DoorReach = false,
    AutoPlayAgain = false,
    AutoLobby = false,
    AutoLibraryCode = false,
    AutoBreakerBox = false,
    LeverValveAura = false,
    LootAura = false,
    AutoCollectBooks = false,
    LockedDoorAura = false,
    NoclipBypassSpeed = 3,
    SpeedBoost = false,
    SpeedBypass = false,
    NoAcceleration = false,
    Fly = false,
    FlySpeed = 0.4,
    TeleportEnabled = false,
    TeleportDistance = 15,
    Noclip = false,
    EnableJump = true,
    InfiniteJump = false,
    ClosetExitFix = false,
    FOV = 90,
    NoCameraShaking = false,
    Freecam = false,
    ThirdPerson = false,
    ThirdOffset = 0,
    ThirdHeight = 3,
    ThirdDistance = 10,
    ThirdSensitivity = 1,
    Fullbright = false,
    Brightness = 2,
    FogEnabled = false
}

-- ═══════════════════════════════════════════════════════════
-- UNIFIED ESP SYSTEM - Clean implementation
-- ═══════════════════════════════════════════════════════════

local ESPRegistry = {} -- Tracks ALL ESP objects by instance
local OpenedDoors = {} -- Tracks opened doors
local CurrentPlayerRoom = nil -- Track player's current room

-- Rainbow ESP System
local RainbowESPEnabled = false
local RainbowConnection = nil
local RainbowHue = 0

-- Forward declarations for fullbright (defined later)
local ApplyFullbright, RestoreLighting

local function ClearESP(instance)
    if ESPRegistry[instance] then
        local data = ESPRegistry[instance]
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        if data.billboard then pcall(function() data.billboard:Destroy() end) end
        ESPRegistry[instance] = nil
    end
end

local function HasESP(instance)
    -- Direct ESP check
    if ESPRegistry[instance] ~= nil then return true end

    -- Check for existing billboard on this instance
    if instance:FindFirstChild("ESPBillboard") then return true end

    -- Check for ESP on top-level parent (for items with multiple parts)
    local topParent = instance
    while topParent.Parent and topParent.Parent ~= game do
        topParent = topParent.Parent
    end
    if ESPRegistry[topParent] then return true end
    if topParent:FindFirstChild("ESPBillboard") then return true end

    -- Special handling for Candles - check area duplicates
    if instance.Name:find("Candle") or instance.Name:find("candle") then
        for registeredInstance, _ in pairs(ESPRegistry) do
            if registeredInstance:FindFirstChild("ESPBillboard") then
                local label = registeredInstance:FindFirstChild("ESPBillboard"):FindFirstChild("ESPLabel")
                if label and (label.Text:find("CANDLE") or label.Text:find("Candle")) then
                    -- Check if it's in the same general area (within 15 studs)
                    local existingPos = registeredInstance:IsA("Model") and registeredInstance:GetPivot().Position or registeredInstance.Position
                    local currentPos = instance:IsA("Model") and instance:GetPivot().Position or instance.Position
                    if (existingPos - currentPos).Magnitude < 15 then
                        return true -- Skip, we already have a candle ESP nearby
                    end
                end
            end
        end
    end

    return false
end

local function ClearESPInRoom(roomName)
    local toRemove = {}
    for instance, data in pairs(ESPRegistry) do
        if data.roomName == roomName then
            table.insert(toRemove, instance)
        end
    end
    for _, instance in ipairs(toRemove) do
        ClearESP(instance)
    end
end

local function ApplyESP(instance, text, color, espType, roomName)
    if HasESP(instance) then return end
    
    -- Extra check: skip if already has billboard (prevents duplicates)
    if instance:FindFirstChild("ESPBillboard") then return end
    
    local highlight, billboard
    
    -- Create highlight - parent to MODEL/instance so it highlights all parts
    if instance:IsA("Model") then
        highlight = Instance.new("Highlight")
        highlight.Parent = instance
        highlight.Adornee = instance -- Highlight entire model
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    elseif instance:IsA("BasePart") then
        highlight = Instance.new("Highlight")
        highlight.Parent = instance
        highlight.Adornee = instance
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    
    -- Create billboard
    billboard = Instance.new("BillboardGui")
    billboard.Parent = instance
    billboard.Name = "ESPBillboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    
    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.Name = "ESPLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 22
    
    ESPRegistry[instance] = {
        highlight = highlight,
        billboard = billboard,
        espType = espType,
        color = color,
        roomName = roomName or "unknown"
    }
    
    -- Auto-cleanup when destroyed
    instance.AncestryChanged:Connect(function()
        if not instance:IsDescendantOf(game) then
            ClearESP(instance)
        end
    end)
    
    WaveDebug.debug(text .. " ESP applied!")
end

local function UpdateESPColor(espType, newColor)
    for instance, data in pairs(ESPRegistry) do
        if data.espType == espType then
            data.color = newColor
            if data.highlight then
                data.highlight.FillColor = newColor
                data.highlight.OutlineColor = Color3.new(newColor.R * 0.7, newColor.G * 0.7, newColor.B * 0.7)
            end
            if data.billboard then
                local label = data.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = newColor end
            end
        end
    end
end

-- Rainbow ESP System
local function hueToRGB(hue)
    local h = hue % 360
    local c = 1
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = 0

    local r, g, b
    if h < 60 then
        r, g, b = c, x, 0
    elseif h < 120 then
        r, g, b = x, c, 0
    elseif h < 180 then
        r, g, b = 0, c, x
    elseif h < 240 then
        r, g, b = 0, x, c
    elseif h < 300 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    return Color3.new(r + m, g + m, b + m)
end

local function updateRainbowESP()
    if not Settings.RainbowESP then
        if RainbowConnection then
            RainbowConnection:Disconnect()
            RainbowConnection = nil

            -- RESTORE ORIGINAL COLORS when rainbow is disabled
            WaveDebug.info("Restoring original ESP colors...")
            for instance, data in pairs(ESPRegistry) do
                if data.highlight then
                    data.highlight.FillColor = data.color
                    data.highlight.OutlineColor = Color3.new(data.color.R * 0.7, data.color.G * 0.7, data.color.B * 0.7)
                end
                if data.billboard then
                    local label = data.billboard:FindFirstChild("ESPLabel")
                    if label then label.TextColor3 = data.color end
                end
            end
            WaveDebug.info("Original ESP colors restored!")
        end
        return
    end

    if RainbowConnection then return end -- Already running

    RainbowConnection = RunService.Heartbeat:Connect(function()
        RainbowHue = (RainbowHue + 2) % 360
        local rainbowColor = hueToRGB(RainbowHue)

        for instance, data in pairs(ESPRegistry) do
            if data.highlight then
                data.highlight.FillColor = rainbowColor
                data.highlight.OutlineColor = Color3.new(rainbowColor.R * 0.7, rainbowColor.G * 0.7, rainbowColor.B * 0.7)
            end
            if data.billboard then
                local label = data.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = rainbowColor end
            end
        end
    end)

    WaveDebug.info("Rainbow ESP system activated!")
end

local function ClearAllESPOfType(espType)
    local toRemove = {}
    for instance, data in pairs(ESPRegistry) do
        if data.espType == espType then
            table.insert(toRemove, instance)
        end
    end
    for _, instance in ipairs(toRemove) do
        ClearESP(instance)
    end
end

-- ═══════════════════════════════════════════════════════════
-- ESP APPLICATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════

local function GetRoomName(instance)
    local current = instance
    while current and current.Parent do
        if current.Parent == CurrentRooms then
            return current.Name
        end
        current = current.Parent
    end
    return nil
end

local function ApplyDoorESP(room)
    if not Settings.DoorESP then return end

    local roomNum = tonumber(room.Name)
    if not roomNum then return end

    local door = room:FindFirstChild("Door")
    if not door then return end
    if OpenedDoors[door] and OpenedDoors[door].opened then return end

    local hasKey = room:FindFirstChild("KeyObtain", true) ~= nil
    local displayNum = roomNum + 1
    local text = string.format("DOOR %d\n%s", displayNum, hasKey and "LOCKED" or "OPEN")

    -- AGGRESSIVE DOOR ESP METHOD - Always find a target
    local doorTarget = nil
    local methodUsed = "none"

    -- Method 1: Main door part
    local doorPart = door:FindFirstChild("Door")
    if doorPart and doorPart:IsA("BasePart") then
        doorTarget = doorPart
        methodUsed = "main Door part"
    end

    -- Method 2: Door leaf/surface with different names
    if not doorTarget then
        local doorNames = {"DoorLeaf", "DoorSurface", "DoorMain", "DoorFrame", "DoorMesh"}
        for _, name in pairs(doorNames) do
            local part = door:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                doorTarget = part
                methodUsed = name
                break
            end
        end
    end

    -- Method 3: ANY visible part inside door (aggressive)
    if not doorTarget then
        for _, part in pairs(door:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.8 then -- More permissive
                doorTarget = part
                methodUsed = "any visible part"
                break
            end
        end
    end

    -- Method 4: Primary part
    if not doorTarget and door.PrimaryPart then
        doorTarget = door.PrimaryPart
        methodUsed = "PrimaryPart"
    end

    -- Method 5: Fallback to entire door model (last resort)
    if not doorTarget then
        doorTarget = door
        methodUsed = "entire door model"
    end

    -- ALWAYS apply ESP if we found a target
    if doorTarget and not HasESP(doorTarget) then
        ApplyESP(doorTarget, text, Settings.DoorESPColor, "Door", room.Name)
        OpenedDoors[door] = {opened = false, espTarget = doorTarget}
        WaveDebug.info("DOOR ESP APPLIED to room " .. room.Name .. " - Method: " .. methodUsed .. " - Target: " .. doorTarget.Name)
    else
        WaveDebug.error("NO TARGET FOUND for door in room " .. room.Name)
    end

    -- Monitor door opening
    for _, desc in pairs(door:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            if Settings.InstantInteract then desc.HoldDuration = 0 end
            if Settings.DoorReach then desc.MaxActivationDistance = 20 end

            desc.Triggered:Connect(function()
                if OpenedDoors[door] and OpenedDoors[door].espTarget then
                    ClearESP(OpenedDoors[door].espTarget)
                end
                OpenedDoors[door] = {opened = true, espTarget = nil}
                warn(string.format("Door %d opened - ESP cleared", displayNum))
            end)
        end
    end

    door:GetAttributeChangedSignal("Opened"):Connect(function()
        if door:GetAttribute("Opened") then
            if OpenedDoors[door] and OpenedDoors[door].espTarget then
                ClearESP(OpenedDoors[door].espTarget)
            end
            OpenedDoors[door] = {opened = true, espTarget = nil}
        end
    end)
end

local function ApplyKeyESP(key)
    if not Settings.KeyESP then return end
    if HasESP(key) then return end
    ApplyESP(key, "KEY", Settings.KeyESPColor, "Key", GetRoomName(key))
end

local function ApplyWardrobeESP(wardrobe)
    if not Settings.ClosetESP then return end
    if HasESP(wardrobe) then return end
    ApplyESP(wardrobe, "WARDROBE", Settings.ClosetESPColor, "Closet", GetRoomName(wardrobe))
end

local function ApplyObjectiveESP(obj, name)
    if not Settings.ObjectiveESP then return end
    if HasESP(obj) then return end
    ApplyESP(obj, name, Settings.ObjectiveESPColor, "Objective", GetRoomName(obj))
end

local function ApplyGoldESP(gold)
    if not Settings.GoldESP then return end
    if HasESP(gold) then return end
    ApplyESP(gold, "GOLD", Settings.GoldESPColor, "Gold", GetRoomName(gold))
end

local function ApplyItemESP(item, name)
    if not Settings.ItemESP then return end
    if HasESP(item) then return end
    
    -- Skip items inside furniture
    local parent = item.Parent
    if parent then
        local pname = parent.Name
        if pname == "Wardrobe" or pname == "Bookcase" or pname == "Cabinet" or pname == "Dresser" then
            return
        end
    end
    
    ApplyESP(item, name, Settings.ItemESPColor, "Item", GetRoomName(item))
end

-- ═══════════════════════════════════════════════════════════
-- ROOM SCANNER - Single unified scanner
-- ═══════════════════════════════════════════════════════════

local ItemNames = {"Lighter", "Flashlight", "Lockpick", "Vitamins", "Crucifix", "Candle", "Battery", "ElectricalRoomKey", "SkeletonKey", "Smoothie"}

local function ScanRoom(room)
    -- Door
    ApplyDoorESP(room)
    
    -- Scan descendants
    for _, desc in pairs(room:GetDescendants()) do
        local name = desc.Name
        
        -- Key
        if name == "KeyObtain" then
            ApplyKeyESP(desc)
        
        -- Wardrobe (only in Assets folder)
        elseif name == "Wardrobe" then
            local p = desc.Parent
            if p and (p.Name == "Assets" or p.Parent == CurrentRooms) then
                ApplyWardrobeESP(desc)
            end
        
        -- LeverForGate
        elseif name == "LeverForGate" then
            ApplyObjectiveESP(desc, "LEVER FOR GATE")
        
        -- Other levers/valves
        elseif name:find("Lever") then
            ApplyObjectiveESP(desc, "LEVER")
        elseif name:find("Valve") then
            ApplyObjectiveESP(desc, "VALVE")
        
        -- Library hint
        elseif name == "LibraryHintPaper" then
            ApplyObjectiveESP(desc, "LIBRARY HINT")
        
        -- Gold
        elseif name == "GoldPile" or (name:find("Gold") and desc:IsA("BasePart")) then
            ApplyGoldESP(desc)
        
        -- Items
        else
            for _, itemName in ipairs(ItemNames) do
                if name == itemName then
                    ApplyItemESP(desc, itemName:upper())
                    break
                end
            end
        end
    end
end

local function ScanAllRooms()
    for _, room in pairs(CurrentRooms:GetChildren()) do
        task.spawn(function()
            ScanRoom(room)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════
-- LOAD MSPaint UI
-- ═══════════════════════════════════════════════════════════

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "vesper.lua",
    Footer = "version: v2.0 | clean rewrite",
    Icon = "rbxassetid://87962219786952",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "home"),
    ESP = Window:AddTab("ESP", "eye"),
    Player = Window:AddTab("Player", "user"),
    Visuals = Window:AddTab("Visuals", "monitor"),
    Settings = Window:AddTab("UI Settings", "settings"),
}

-- ═══════════════════════════════════════════════════════════
-- MAIN TAB
-- ═══════════════════════════════════════════════════════════

local MiscGroup = Tabs.Main:AddLeftGroupbox("Miscellaneous", "wrench")

MiscGroup:AddToggle("InstantInteract", {
    Text = "Instant Proximity Prompt",
    Default = false,
    Callback = function(Value)
        Settings.InstantInteract = Value
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = Value and 0 or prompt:GetAttribute("OriginalHold") or 0.5
            end
        end
    end
})

MiscGroup:AddToggle("BreakVoid", {
    Text = "break ROBLOX Void",
    Default = false,
    Callback = function(Value) Settings.BreakVoid = Value end
})

MiscGroup:AddToggle("NoCutscenes", {
    Text = "No cutscenes",
    Default = false,
    Callback = function(Value) Settings.NoCutscenes = Value end
})

MiscGroup:AddToggle("DoorReach", {
    Text = "Door Reach",
    Default = false,
    Callback = function(Value)
        Settings.DoorReach = Value
        for _, room in pairs(CurrentRooms:GetChildren()) do
            local door = room:FindFirstChild("Door")
            if door then
                for _, prompt in pairs(door:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.MaxActivationDistance = Value and 20 or 10
                    end
                end
            end
        end
    end
})

local AutoGroup = Tabs.Main:AddLeftGroupbox("Automation", "zap")

AutoGroup:AddToggle("AutoPlayAgain", {
    Text = "Auto Play Again",
    Default = false,
    Callback = function(Value) Settings.AutoPlayAgain = Value end
})

AutoGroup:AddToggle("AutoLobby", {
    Text = "Auto Lobby",
    Default = false,
    Callback = function(Value) Settings.AutoLobby = Value end
})

AutoGroup:AddToggle("AutoLibraryCode", {
    Text = "Auto Library Code",
    Default = false,
    Callback = function(Value) Settings.AutoLibraryCode = Value end
})

AutoGroup:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false,
    Callback = function(Value) Settings.AutoBreakerBox = Value end
})

local NotifyGroup = Tabs.Main:AddRightGroupbox("Notifiers", "bell")

NotifyGroup:AddToggle("NotificationSound", {
    Text = "Notification sound",
    Default = false,
    Callback = function(Value) Settings.NotificationSound = Value end
})

NotifyGroup:AddToggle("EntityNotify", {
    Text = "Notify Entities",
    Default = false,
    Callback = function(Value) Settings.EntityNotify = Value end
})

NotifyGroup:AddToggle("NotifyInChat", {
    Text = "Notify in Chat",
    Default = false,
    Callback = function(Value) Settings.NotifyInChat = Value end
})

NotifyGroup:AddDivider()

NotifyGroup:AddToggle("ScreechProtection", {
    Text = "Screech/Eyes Protection",
    Default = false,
    Callback = function(Value) Settings.ScreechProtection = Value end
})

local AuraGroup = Tabs.Main:AddRightGroupbox("Auras", "sparkles")

AuraGroup:AddToggle("LeverValveAura", {
    Text = "Lever/Valve Aura",
    Default = false,
    Callback = function(Value) Settings.LeverValveAura = Value end
})

AuraGroup:AddToggle("LootAura", {
    Text = "Loot Aura",
    Default = false,
    Callback = function(Value) Settings.LootAura = Value end
})

AuraGroup:AddToggle("AutoCollectBooks", {
    Text = "Auto Collect Books/Breaker",
    Default = false,
    Callback = function(Value) Settings.AutoCollectBooks = Value end
})

AuraGroup:AddToggle("LockedDoorAura", {
    Text = "Locked Door Aura",
    Default = false,
    Callback = function(Value) Settings.LockedDoorAura = Value end
})

-- ═══════════════════════════════════════════════════════════
-- ESP TAB
-- ═══════════════════════════════════════════════════════════

local ESPGeneralGroup = Tabs.ESP:AddLeftGroupbox("ESP General", "scan")

ESPGeneralGroup:AddToggle("UseAdornments", {
    Text = "Use Adornments",
    Default = false,
    Callback = function(Value) Settings.UseAdornments = Value end
})

ESPGeneralGroup:AddToggle("RainbowESP", {
    Text = "Rainbow ESP Enabled",
    Default = false,
    Callback = function(Value)
        Settings.RainbowESP = Value
        updateRainbowESP()
        WaveDebug.info("Rainbow ESP toggled: " .. tostring(Value))
    end
})

ESPGeneralGroup:AddDivider()

ESPGeneralGroup:AddToggle("EntityESP", {
    Text = "Entity ESP enabled",
    Default = false,
    Callback = function(Value) Settings.EntityESP = Value end
}):AddColorPicker("EntityESPColor", {
    Default = Settings.EntityESPColor,
    Title = "Entity ESP Color",
    Callback = function(Value) Settings.EntityESPColor = Value end
})

ESPGeneralGroup:AddToggle("PlayerESP", {
    Text = "Player ESP enabled",
    Default = false,
    Callback = function(Value) Settings.PlayerESP = Value end
}):AddColorPicker("PlayerESPColor", {
    Default = Settings.PlayerESPColor,
    Title = "Player ESP Color",
    Callback = function(Value) Settings.PlayerESPColor = Value end
})

local ESPItemsGroup = Tabs.ESP:AddRightGroupbox("ESP Items", "package")

ESPItemsGroup:AddToggle("DoorESP", {
    Text = "Door ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.DoorESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Door") end
    end
}):AddColorPicker("DoorESPColor", {
    Default = Settings.DoorESPColor,
    Title = "Door ESP Color",
    Callback = function(Value)
        Settings.DoorESPColor = Value
        UpdateESPColor("Door", Value)
    end
})

ESPItemsGroup:AddToggle("ClosetESP", {
    Text = "Closet/Wardrobe ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.ClosetESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Closet") end
    end
}):AddColorPicker("ClosetESPColor", {
    Default = Settings.ClosetESPColor,
    Title = "Closet ESP Color",
    Callback = function(Value)
        Settings.ClosetESPColor = Value
        UpdateESPColor("Closet", Value)
    end
})

ESPItemsGroup:AddToggle("ItemESP", {
    Text = "Item ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.ItemESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Item") end
    end
}):AddColorPicker("ItemESPColor", {
    Default = Settings.ItemESPColor,
    Title = "Item ESP Color",
    Callback = function(Value)
        Settings.ItemESPColor = Value
        UpdateESPColor("Item", Value)
    end
})

ESPItemsGroup:AddToggle("ObjectiveESP", {
    Text = "Objective ESP (Levers/Valves)",
    Default = false,
    Callback = function(Value)
        Settings.ObjectiveESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Objective") end
    end
}):AddColorPicker("ObjectiveESPColor", {
    Default = Settings.ObjectiveESPColor,
    Title = "Objective ESP Color",
    Callback = function(Value)
        Settings.ObjectiveESPColor = Value
        UpdateESPColor("Objective", Value)
    end
})

ESPItemsGroup:AddToggle("GoldESP", {
    Text = "Gold ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.GoldESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Gold") end
    end
}):AddColorPicker("GoldESPColor", {
    Default = Settings.GoldESPColor,
    Title = "Gold ESP Color",
    Callback = function(Value)
        Settings.GoldESPColor = Value
        UpdateESPColor("Gold", Value)
    end
})

ESPItemsGroup:AddToggle("KeyESP", {
    Text = "Key ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.KeyESP = Value
        if Value then ScanAllRooms() else ClearAllESPOfType("Key") end
    end
}):AddColorPicker("KeyESPColor", {
    Default = Settings.KeyESPColor,
    Title = "Key ESP Color",
    Callback = function(Value)
        Settings.KeyESPColor = Value
        UpdateESPColor("Key", Value)
    end
})

-- ═══════════════════════════════════════════════════════════
-- PLAYER TAB
-- ═══════════════════════════════════════════════════════════

local MovementGroup = Tabs.Player:AddLeftGroupbox("Movement", "move")

MovementGroup:AddSlider("NoclipBypassSpeed", {
    Text = "Noclip Bypass Speed",
    Default = 3,
    Min = 0,
    Max = 6,
    Rounding = 0,
    Callback = function(Value) Settings.NoclipBypassSpeed = Value end
})

MovementGroup:AddToggle("SpeedBoost", {
    Text = "Speed Boost Enabled",
    Default = false,
    Callback = function(Value) Settings.SpeedBoost = Value end
})

MovementGroup:AddToggle("SpeedBypass", {
    Text = "Speed Bypass",
    Default = false,
    Callback = function(Value) Settings.SpeedBypass = Value end
})

MovementGroup:AddToggle("NoAcceleration", {
    Text = "No Acceleration",
    Default = false,
    Callback = function(Value) Settings.NoAcceleration = Value end
})

MovementGroup:AddDivider()

MovementGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(Value) Settings.Fly = Value end
})

MovementGroup:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 0.4,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value) Settings.FlySpeed = Value end
})

MovementGroup:AddDivider()

MovementGroup:AddToggle("TeleportEnabled", {
    Text = "teleport",
    Default = false,
    Callback = function(Value) Settings.TeleportEnabled = Value end
})

MovementGroup:AddSlider("TeleportDistance", {
    Text = "teleport distance",
    Default = 15,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Callback = function(Value) Settings.TeleportDistance = Value end
})

local CharacterGroup = Tabs.Player:AddRightGroupbox("Character", "user-check")

CharacterGroup:AddToggle("Noclip", {
    Text = "NoClip",
    Default = false,
    Callback = function(Value) Settings.Noclip = Value end
})

CharacterGroup:AddToggle("EnableJump", {
    Text = "Enable jump",
    Default = true,
    Callback = function(Value) Settings.EnableJump = Value end
})

CharacterGroup:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value) Settings.InfiniteJump = Value end
})

CharacterGroup:AddToggle("ClosetExitFix", {
    Text = "Closet exit Fix",
    Default = false,
    Callback = function(Value) Settings.ClosetExitFix = Value end
})

-- ═══════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═══════════════════════════════════════════════════════════

local CameraGroup = Tabs.Visuals:AddLeftGroupbox("Camera", "camera")

CameraGroup:AddSlider("FOV", {
    Text = "FOV",
    Default = 90,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        Settings.FOV = Value
        workspace.CurrentCamera.FieldOfView = Value
    end
})

CameraGroup:AddToggle("NoCameraShaking", {
    Text = "No camera shaking",
    Default = false,
    Callback = function(Value) Settings.NoCameraShaking = Value end
})

CameraGroup:AddToggle("Freecam", {
    Text = "Freecam",
    Default = false,
    Callback = function(Value) Settings.Freecam = Value end
})

CameraGroup:AddDivider()

CameraGroup:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = false,
    Callback = function(Value) Settings.ThirdPerson = Value end
})

CameraGroup:AddSlider("ThirdOffset", {
    Text = "Third Offset",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value) Settings.ThirdOffset = Value end
})

CameraGroup:AddSlider("ThirdHeight", {
    Text = "Third Height",
    Default = 3,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value) Settings.ThirdHeight = Value end
})

CameraGroup:AddSlider("ThirdDistance", {
    Text = "Third Distance",
    Default = 10,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Callback = function(Value) Settings.ThirdDistance = Value end
})

CameraGroup:AddSlider("ThirdSensitivity", {
    Text = "Third Sensitivity",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value) Settings.ThirdSensitivity = Value end
})

local LightingGroup = Tabs.Visuals:AddRightGroupbox("Lighting", "sun")

LightingGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        Settings.Fullbright = Value
        if Value then
            ApplyFullbright()
        else
            RestoreLighting()
        end
    end
})

LightingGroup:AddSlider("Brightness", {
    Text = "Brightness",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        Settings.Brightness = Value
        if Settings.Fullbright then
            game:GetService("Lighting").Brightness = Value
        end
    end
})

-- ═══════════════════════════════════════════════════════════
-- UI SETTINGS TAB
-- ═══════════════════════════════════════════════════════════

local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu", "settings")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value) Library.ShowCustomCursor = Value end
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("vesper")
SaveManager:SetFolder("vesper/DOORS")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify({
    Title = "vesper.lua loaded!",
    Description = "DOORS script v2.0 | Press RightShift to toggle",
    Time = 5
})

-- ═══════════════════════════════════════════════════════════
-- ROOM MONITORING
-- ═══════════════════════════════════════════════════════════

CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(0.3)
    ScanRoom(room)
end)

-- Clean up ESP when rooms are removed (player moves forward)
CurrentRooms.ChildRemoved:Connect(function(room)
    ClearESPInRoom(room.Name)
    warn("Room " .. room.Name .. " removed - ESP cleared")
end)

CurrentRooms.DescendantAdded:Connect(function(desc)
    task.wait(0.1)
    local name = desc.Name
    
    if name == "KeyObtain" then ApplyKeyESP(desc)
    elseif name == "Wardrobe" then
        local p = desc.Parent
        if p and (p.Name == "Assets" or p.Parent == CurrentRooms) then
            ApplyWardrobeESP(desc)
        end
    elseif name == "LeverForGate" then ApplyObjectiveESP(desc, "LEVER FOR GATE")
    elseif name:find("Lever") then ApplyObjectiveESP(desc, "LEVER")
    elseif name:find("Valve") then ApplyObjectiveESP(desc, "VALVE")
    elseif name == "LibraryHintPaper" then ApplyObjectiveESP(desc, "LIBRARY HINT")
    elseif name == "GoldPile" then ApplyGoldESP(desc)
    else
        for _, itemName in ipairs(ItemNames) do
            if name == itemName then
                ApplyItemESP(desc, itemName:upper())
                break
            end
        end
    end
end)

-- Initial scan after delay + continuous door check
task.spawn(function()
    task.wait(1.5)
    ScanAllRooms()
    WaveDebug.info("Initial room scan complete!")

    -- CONTINUOUS DOOR ESP CHECK - catch any missed doors
    while true do
        task.wait(2) -- Check every 2 seconds

        if Settings.DoorESP then
            local doorsChecked = 0
            local doorsFound = 0

            for _, room in pairs(CurrentRooms:GetChildren()) do
                if room:IsA("Model") then
                    doorsChecked = doorsChecked + 1

                    local door = room:FindFirstChild("Door")
                    if door then
                        doorsFound = doorsFound + 1

                        -- Check if this door already has ESP
                        local hasESP = false
                        for instance, data in pairs(ESPRegistry) do
                            if data.espType == "Door" and instance:IsDescendantOf(door) then
                                hasESP = true
                                break
                            end
                        end

                        -- Apply ESP if missing
                        if not hasESP then
                            WaveDebug.info("Found door without ESP in room " .. room.Name .. " - applying now")
                            ApplyDoorESP(room)
                        end
                    end
                end
            end

            if doorsChecked > 0 then
                WaveDebug.debug("Door ESP check: " .. doorsFound .. "/" .. doorsChecked .. " doors have ESP")
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ENTITY DETECTION (Rush, Ambush, Eyes, Screech)
-- ═══════════════════════════════════════════════════════════

local EntityTracked = {}
local LastEyesNotification = 0 -- Prevent notification spam

local function SetupEntityESP(entity, name, color)
    if EntityTracked[entity] then return end
    EntityTracked[entity] = true

    warn(name .. " SPAWNED!")

    if Settings.EntityNotify then
        Library:Notify({Title = name .. " DETECTED", Description = "Entity approaching - hide!", Time = 5})
    end

    -- Create ESP elements (always track, but only show if EntityESP enabled)
    local highlight = Instance.new("Highlight")
    highlight.Parent = entity
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = Settings.EntityESP

    local billboard = Instance.new("BillboardGui")
    billboard.Parent = entity
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = Settings.EntityESP

    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    task.spawn(function()
        local retryCount = 0
        local maxRetries = 50 -- Allow up to 5 seconds of retries

        while retryCount < maxRetries do
            pcall(function()
                -- Check if entity still exists and is parented
                if not entity or not entity.Parent then
                    retryCount = maxRetries -- Exit loop
                    return
                end

                -- Update visibility based on current setting
                highlight.Enabled = Settings.EntityESP
                billboard.Enabled = Settings.EntityESP

                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = entity:IsA("Model") and entity:GetPivot().Position or entity.Position
                    local dist = math.floor((hrp.Position - pos).Magnitude)
                    label.Text = name .. " - " .. dist .. " studs"
                end

                retryCount = 0 -- Reset retry count if successful
            end)

            -- If entity still exists, wait and continue
            if entity and entity.Parent then
                task.wait(0.1)
            else
                break
            end
        end

        -- Cleanup
        EntityTracked[entity] = nil
        warn(name .. " despawned or ESP ended")
    end)
end

-- Improved Entity Detection with spawn monitoring
local function setupEntityDetection()
    -- Rush detection with multiple fallbacks
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "RushMoving" then
            SetupEntityESP(child, "RUSH", Color3.fromRGB(255, 25, 25))
            warn("Rush spawned - ESP applied immediately")
        elseif child.Name == "AmbushMoving" then
            SetupEntityESP(child, "AMBUSH", Color3.fromRGB(255, 100, 0))
            warn("Ambush spawned - ESP applied immediately")
        end
    end)

    -- Continuous monitoring for entities that might be missed
    RunService.Heartbeat:Connect(function()
        -- Rush (check multiple possible names)
        local rush = Workspace:FindFirstChild("RushMoving")
        if rush then
            SetupEntityESP(rush, "RUSH", Color3.fromRGB(255, 25, 25))
        end

        -- Also check for alternative Rush names
        local rush2 = Workspace:FindFirstChild("Rush")
        if rush2 and rush2 ~= rush then
            SetupEntityESP(rush2, "RUSH", Color3.fromRGB(255, 25, 25))
        end

        -- Ambush
        local ambush = Workspace:FindFirstChild("AmbushMoving")
        if ambush then
            SetupEntityESP(ambush, "AMBUSH", Color3.fromRGB(255, 100, 0))
        end

        -- Eyes ESP is now handled by setupOriginalEyesDetection()
    end)
end

-- Initialize entity detection
setupEntityDetection()

-- Eyes spawn detection is handled by setupOriginalEyesDetection() function

-- MULTIPLE APPROACHES EYES PROTECTION SYSTEM - Try different methods
local EyesProtectionMethod = 1 -- Change this number to test different approaches
-- 1 = Remove eye details only
-- 2 = Complete destruction
-- 3 = Script removal + damage blocking
-- 4 = RemoteEvent blocking
-- 5 = Camera manipulation
-- 6 = Teleport away
-- 7 = Invincibility shield
-- 8 = All methods combined

local function setupEyesProtectionSystem()
    local eyesProcessed = false
    local originalCameraFOV = nil

    -- APPROACH 1: Remove eye details only (keeps entity visible)
    local function approach1_RemoveEyeDetails(eyes)
        warn("👁️ Approach 1: Removing eye details only")
        local eyeDetailParts = {"Eyeball", "Pupil", "Iris", "EyeL", "EyeR", "EyeMesh", "EyePart"}
        for _, partName in pairs(eyeDetailParts) do
            local part = eyes:FindFirstChild(partName, true)
            if part then
                part:Destroy()
            end
        end
    end

    -- APPROACH 2: Complete destruction
    local function approach2_CompleteDestruction(eyes)
        warn("👁️ Approach 2: Complete destruction")
        eyes:Destroy()
    end

    -- APPROACH 3: Script removal + damage blocking
    local function approach3_ScriptRemoval(eyes)
        warn("👁️ Approach 3: Script removal + damage blocking")
        -- Remove all scripts
        for _, script in pairs(eyes:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                script:Destroy()
            end
        end
        -- Disable damage parts
        for _, part in pairs(eyes:GetDescendants()) do
            if part.Name:find("Damage") or part.Name:find("Kill") or part.Name:find("Hurt") then
                part.CanTouch = false
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end

    -- APPROACH 4: RemoteEvent blocking
    local function approach4_RemoteEventBlocking()
        warn("👁️ Approach 4: RemoteEvent blocking")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage

        for _, remote in pairs(remotes:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                pcall(function()
                    local original = remote.OnClientEvent
                    remote.OnClientEvent = function(...)
                        local args = {...}
                        if type(args[1]) == "string" and (args[1]:lower():find("eyes") or args[1]:lower():find("damage")) then
                            return nil -- Block the event
                        end
                        return original:Fire(...)
                    end
                end)
            end
        end
    end

    -- APPROACH 5: Camera manipulation
    local function approach5_CameraManipulation(eyes)
        warn("👁️ Approach 5: Camera manipulation")
        local cam = workspace.CurrentCamera
        if cam and not originalCameraFOV then
            originalCameraFOV = cam.FieldOfView

            task.spawn(function()
                while eyes and eyes.Parent do
                    pcall(function()
                        -- Look away from Eyes
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local lookDir = (char.HumanoidRootPart.Position - eyes.Position).Unit
                            cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + lookDir)
                        end
                    end)
                    task.wait()
                end

                -- Restore camera
                if originalCameraFOV then
                    cam.FieldOfView = originalCameraFOV
                end
            end)
        end
    end

    -- APPROACH 6: Teleport away
    local function approach6_TeleportAway(eyes)
        warn("👁️ Approach 6: Teleport away")
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local eyesPos = eyes.Position
            local awayDir = (char.HumanoidRootPart.Position - eyesPos).Unit
            char.HumanoidRootPart.Position = eyesPos + awayDir * 100
        end
    end

    -- APPROACH 7: Invincibility shield
    local function approach7_InvincibilityShield()
        warn("👁️ Approach 7: Invincibility shield")
        task.spawn(function()
            while Workspace:FindFirstChild("Eyes") and LocalPlayer.Character do
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = 1000
                    hum.Health = 1000
                    hum.BreakJointsOnDeath = false
                end
                task.wait(0.1)
            end
        end)
    end

    -- APPROACH 8: All methods combined
    local function approach8_AllMethods(eyes)
        warn("👁️ Approach 8: ALL METHODS COMBINED")
        approach1_RemoveEyeDetails(eyes)
        approach3_ScriptRemoval(eyes)
        approach4_RemoteEventBlocking()
        approach5_CameraManipulation(eyes)
        approach7_InvincibilityShield()
    end

    -- Main protection function
    local function protectFromEyes()
        local eyes = Workspace:FindFirstChild("Eyes")
        if eyes and Settings.ScreechProtection and not eyesProcessed then
            eyesProcessed = true

            if Settings.EntityNotify then
                Library:Notify({Title = "👁️ EYES PROTECTION", Description = "Method " .. EyesProtectionMethod .. " activated", Time = 3})
            end

            -- Apply the selected approach
            if EyesProtectionMethod == 1 then
                approach1_RemoveEyeDetails(eyes)
            elseif EyesProtectionMethod == 2 then
                approach2_CompleteDestruction(eyes)
            elseif EyesProtectionMethod == 3 then
                approach3_ScriptRemoval(eyes)
            elseif EyesProtectionMethod == 4 then
                approach4_RemoteEventBlocking()
            elseif EyesProtectionMethod == 5 then
                approach5_CameraManipulation(eyes)
            elseif EyesProtectionMethod == 6 then
                approach6_TeleportAway(eyes)
            elseif EyesProtectionMethod == 7 then
                approach7_InvincibilityShield()
            elseif EyesProtectionMethod == 8 then
                approach8_AllMethods(eyes)
            end

            -- Reset after delay
            task.delay(3, function()
                eyesProcessed = false
            end)
        end
    end

    -- Monitoring
    task.spawn(function()
        while true do
            if Settings.ScreechProtection then
                protectFromEyes()
            end
            task.wait(0.3)
        end
    end)

    -- Spawn detection
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Eyes" and Settings.ScreechProtection then
            task.wait(0.1)
            protectFromEyes()
        end
    end)

    -- ESP (simple)
    local function checkForEyesESP()
        local EyesModel = Workspace:FindFirstChild("Eyes")
        if EyesModel and not EyesModel:GetAttribute("ESPAdded") and Settings.EntityESP then
            EyesModel:SetAttribute("ESPAdded", true)

            local highlight = Instance.new("Highlight")
            highlight.Parent = EyesModel
            highlight.FillColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineColor = Color3.new(1, 1, 0)
            highlight.FillTransparency = 0.3
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            local billboard = Instance.new("BillboardGui")
            billboard.Parent = EyesModel
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 5, 0)
            billboard.AlwaysOnTop = true

            local label = Instance.new("TextLabel")
            label.Parent = billboard
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 0)
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold

            task.spawn(function()
                while EyesModel and EyesModel.Parent do
                    pcall(function()
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = math.floor((hrp.Position - EyesModel.Position).Magnitude)
                            label.Text = "👁️ EYES - " .. dist .. " studs (Method " .. EyesProtectionMethod .. ")"
                        end
                    end)
                    task.wait(0.5)
                end

                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
            end)
        end
    end

    RunService.Heartbeat:Connect(checkForEyesESP)
end

-- Quick method switching system (press keys to change method)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Press number keys 1-8 to switch methods
    if input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Eight then
        local method = input.KeyCode.Value - Enum.KeyCode.One.Value + 1
        EyesProtectionMethod = method

        Library:Notify({
            Title = "👁️ EYES PROTECTION",
            Description = "Switched to Method " .. method .. ":\n" ..
                (method == 1 and "Remove eye details only" or
                 method == 2 and "Complete destruction" or
                 method == 3 and "Script removal + damage blocking" or
                 method == 4 and "RemoteEvent blocking" or
                 method == 5 and "Camera manipulation" or
                 method == 6 and "Teleport away" or
                 method == 7 and "Invincibility shield" or
                 method == 8 and "All methods combined"),
            Time = 3
        })
    end
end)

-- Initialize the Eyes protection system
setupEyesProtectionSystem()

-- Screech protection (safe check)
task.spawn(function()
    while true do
        task.wait(0.2)
        if Settings.ScreechProtection then
            pcall(function()
                local screech = Workspace:FindFirstChild("Screech", true)
                if screech then
                    screech:Destroy()
                    warn("Screech blocked!")
                    if Settings.EntityNotify then
                        Library:Notify({Title = "SCREECH BLOCKED", Description = "Screech removed", Time = 3})
                    end
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- GLOBAL SYSTEMS
-- ═══════════════════════════════════════════════════════════

-- Proximity prompt monitor
workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        task.wait(0.1)
        if Settings.InstantInteract then desc.HoldDuration = 0 end
        local isDoor = desc:FindFirstAncestorOfClass("Model") and desc:FindFirstAncestorOfClass("Model").Name == "Door"
        if isDoor and Settings.DoorReach then desc.MaxActivationDistance = 20 end
    end
end)

-- Break void
RunService.Heartbeat:Connect(function()
    if Settings.BreakVoid and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < -200 then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 400, 0)
            warn("Prevented void fall!")
        end
    end
end)

-- Fullbright system (store originals and apply once, not every frame)
local Lighting = game:GetService("Lighting")
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

ApplyFullbright = function()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = Settings.Brightness
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
end

RestoreLighting = function()
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.FogEnd = OriginalLighting.FogEnd
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
end

-- Only re-apply when game tries to change lighting (not every frame)
local lastFullbrightApply = 0
Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
    if Settings.Fullbright and tick() - lastFullbrightApply > 0.1 then
        lastFullbrightApply = tick()
        task.defer(ApplyFullbright)
    end
end)

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if Settings.Fullbright and tick() - lastFullbrightApply > 0.1 then
        lastFullbrightApply = tick()
        task.defer(ApplyFullbright)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- AURA SYSTEMS
-- ═══════════════════════════════════════════════════════════

task.spawn(function()
    while true do
        task.wait(0.4)
        if LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, room in pairs(CurrentRooms:GetChildren()) do
                    for _, desc in pairs(room:GetDescendants()) do
                        local prompt = desc:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            local targetPos = desc:IsA("Model") and desc:GetPivot().Position or (desc:IsA("BasePart") and desc.Position)
                            if targetPos then
                                local dist = (hrp.Position - targetPos).Magnitude
                                
                                -- Lever/Valve Aura
                                if Settings.LeverValveAura and (desc.Name:find("Lever") or desc.Name:find("Valve")) and dist <= 15 then
                                    if fireproximityprompt then pcall(function() fireproximityprompt(prompt) end) end
                                end
                                
                                -- Loot Aura
                                if Settings.LootAura and (desc.Name:find("Drawer") or desc.Name == "ChestBox" or desc.Name == "Smoothie") and dist <= 12 then
                                    if fireproximityprompt then pcall(function() fireproximityprompt(prompt) end) end
                                end
                                
                                -- Locked Door Aura
                                if Settings.LockedDoorAura and desc.Name == "Lock" and dist <= 15 then
                                    if fireproximityprompt then pcall(function() fireproximityprompt(prompt) end) end
                                end
                            end
                        end
                        
                        -- Auto books
                        if Settings.AutoCollectBooks and desc.Name == "Book" then
                            local cd = desc:FindFirstChild("ClickDetector")
                            if cd then
                                local dist = (hrp.Position - desc.Position).Magnitude
                                if dist <= 15 and fireclickdetector then
                                    pcall(function() fireclickdetector(cd) end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- NOCLIP
-- ═══════════════════════════════════════════════════════════

local noclip = false
local noclipConn

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        noclip = not noclip
        warn("Noclip:", noclip and "ON" or "OFF")
        if noclip then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    noclip = false
    if noclipConn then noclipConn:Disconnect() end
end)

-- ═══════════════════════════════════════════════════════════
-- MOVEMENT SYSTEMS - All Missing Features Implemented
-- ═══════════════════════════════════════════════════════════

-- Get references to DOORS movement system if available
local MainGame = LocalPlayer:FindFirstChild("PlayerScripts") and
                 LocalPlayer.PlayerScripts:FindFirstChild("MainGame")

-- Store original values
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalHipHeight = 0
local SpeedBoostConnection = nil

-- ═══════════════════════════════════════════════════════════
-- SPEED BOOST SYSTEM
-- ═══════════════════════════════════════════════════════════

local function UpdateSpeedBoost()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if Settings.SpeedBoost then
        local boostMultiplier = Settings.SpeedBypass and 2.5 or 1.8
        local targetSpeed = OriginalWalkSpeed * boostMultiplier

        if Settings.NoAcceleration then
            humanoid.WalkSpeed = targetSpeed
            humanoid.JumpPower = OriginalJumpPower * 1.5
        else
            -- Smooth speed transition
            local currentSpeed = humanoid.WalkSpeed
            local steps = 10
            local increment = (targetSpeed - currentSpeed) / steps

            for i = 1, steps do
                humanoid.WalkSpeed = currentSpeed + (increment * i)
                task.wait(0.05)
            end
        end
    else
        humanoid.WalkSpeed = OriginalWalkSpeed
        humanoid.JumpPower = OriginalJumpPower
    end
end

-- Update speed boost when character loads
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.1)
    OriginalWalkSpeed = char:WaitForChild("Humanoid").WalkSpeed
    OriginalJumpPower = char:WaitForChild("Humanoid").JumpPower
    UpdateSpeedBoost()
end)

-- ═══════════════════════════════════════════════════════════
-- FLY SYSTEM
-- ═══════════════════════════════════════════════════════════

local FlyVelocity = nil
local FlyEnabled = false
local FlyConnections = {}

local function ToggleFly()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    FlyEnabled = not FlyEnabled

    if FlyEnabled then
        -- Enable fly
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        -- Create body velocity for smooth flying
        FlyVelocity = Instance.new("BodyVelocity")
        FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyVelocity.Parent = rootPart

        -- Create body gyro for stability
        local FlyGyro = Instance.new("BodyGyro")
        FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyGyro.P = 10000
        FlyGyro.CFrame = workspace.CurrentCamera.CFrame
        FlyGyro.Parent = rootPart

        -- Gravity removal
        rootPart:FindFirstChildOfClass("BodyGyro").MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

        -- Flight controls
        local flyConn
        flyConn = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not LocalPlayer.Character or not LocalPlayer.Character.Parent then
                flyConn:Disconnect()
                return
            end

            local moveVector = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            local flySpeed = Settings.FlySpeed * 50

            -- WASD movement (camera-relative)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cam.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cam.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cam.CFrame.RightVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cam.CFrame.RightVector * flySpeed
            end

            -- Vertical movement
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, flySpeed, 0)
            end

            -- Speed boost with Shift
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector * 2
            end

            if FlyVelocity then
                FlyVelocity.Velocity = moveVector
            end

            if FlyGyro then
                FlyGyro.CFrame = cam.CFrame
            end
        end)

        table.insert(FlyConnections, flyConn)
        warn("Fly enabled! WASD/Space/Ctrl to move")

    else
        -- Disable fly
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        if FlyVelocity then
            FlyVelocity:Destroy()
            FlyVelocity = nil
        end

        local gyro = rootPart:FindFirstChildOfClass("BodyGyro")
        if gyro then gyro:Destroy() end

        -- Clean up connections
        for _, conn in pairs(FlyConnections) do
            if conn then conn:Disconnect() end
        end
        FlyConnections = {}

        warn("Fly disabled")
    end
end

-- ═══════════════════════════════════════════════════════════
-- TELEPORT SYSTEM
-- ═══════════════════════════════════════════════════════════

local TeleportTarget = nil
local TeleportBeam = nil

local function CreateTeleportBeam(targetPos)
    if TeleportBeam then TeleportBeam:Destroy() end

    TeleportBeam = Instance.new("Beam")
    TeleportBeam.Attachment0 = Instance.new("Attachment", LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
    TeleportBeam.Attachment1 = Instance.new("Attachment", workspace.Terrain or workspace)
    TeleportBeam.Attachment1.WorldPosition = targetPos
    TeleportBeam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    TeleportBeam.Width0 = 2
    TeleportBeam.Width1 = 2
    TeleportBeam.FaceCamera = true
    TeleportBeam.Transparency = NumberSequence.new(0, 0.8)
    TeleportBeam.Parent = workspace.CurrentCamera
end

local function TeleportTo(position)
    if not LocalPlayer.Character or not Settings.TeleportEnabled then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Create visual effect
    CreateTeleportBeam(position)

    -- Smooth teleport
    local startCFrame = rootPart.CFrame
    local endCFrame = CFrame.new(position)
    local duration = 0.2
    local startTime = tick()

    local conn
    conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.min(elapsed / duration, 1)

        -- Smooth interpolation
        rootPart.CFrame = startCFrame:Lerp(endCFrame, alpha)

        if alpha >= 1 then
            conn:Disconnect()
            if TeleportBeam then
                TeleportBeam:Destroy()
                TeleportBeam = nil
            end
        end
    end)
end

-- Teleport controls
UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not Settings.TeleportEnabled then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
        -- Alt + Click to teleport
        local mouseLocation = UserInputService:GetMouseLocation()
        local ray = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)

        if result then
            TeleportTo(result.Position + Vector3.new(0, 3, 0))
        end
    end

    -- Number keys for saved positions
    if input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Nine then
        local index = input.KeyCode.Value - Enum.KeyCode.One.Value + 1
        -- Could implement saved teleport positions here
    end
end)

-- ═══════════════════════════════════════════════════════════
-- FREECAM SYSTEM
-- ═══════════════════════════════════════════════════════════

local FreecamEnabled = false
local FreecamCamera = nil
local OriginalCamera = workspace.CurrentCamera
local FreecamCFrame = CFrame.new()
local FreecamVelocity = Vector3.new()

local function ToggleFreecam()
    FreecamEnabled = not FreecamEnabled

    if FreecamEnabled then
        -- Save original camera
        OriginalCamera = workspace.CurrentCamera.CameraSubject

        -- Set camera to freecam mode
        workspace.CurrentCamera.CameraSubject = nil
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

        -- Start at player position
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            FreecamCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end

        -- Freecam controls
        local freecamConn
        freecamConn = RunService.Heartbeat:Connect(function()
            if not FreecamEnabled then
                freecamConn:Disconnect()
                return
            end

            local cam = workspace.CurrentCamera
            local speed = 20
            local multiplier = 1

            -- Speed modifiers
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                multiplier = 3
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                multiplier = 0.5
            end

            local moveVector = Vector3.new(0, 0, 0)

            -- Movement
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cam.CFrame.LookVector * speed * multiplier
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cam.CFrame.LookVector * speed * multiplier
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cam.CFrame.RightVector * speed * multiplier
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cam.CFrame.RightVector * speed * multiplier
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, speed * multiplier, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                moveVector = moveVector - Vector3.new(0, speed * multiplier, 0)
            end

            -- Smooth movement
            FreecamVelocity = FreecamVelocity:Lerp(moveVector, 0.1)
            FreecamCFrame = FreecamCFrame + FreecamVelocity

            cam.CFrame = FreecamCFrame
        end)

        warn("Freecam enabled! WASD/Space/Alt to move")

    else
        -- Restore original camera
        workspace.CurrentCamera.CameraSubject = OriginalCamera
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

        -- Reset to player
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            workspace.CurrentCamera.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end

        warn("Freecam disabled")
    end
end

-- ═══════════════════════════════════════════════════════════
-- THIRD PERSON SYSTEM
-- ═══════════════════════════════════════════════════════════

local ThirdPersonEnabled = false
local OriginalCameraOffset = Vector3.new(0, 0, 0)
local ThirdPersonConnection = nil

local function UpdateThirdPerson()
    if not LocalPlayer.Character or not workspace.CurrentCamera then return end

    if Settings.ThirdPerson then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local offset = Vector3.new(Settings.ThirdOffset, 0, -Settings.ThirdDistance)
            local heightOffset = Vector3.new(0, Settings.ThirdHeight, 0)
            local cameraCFrame = rootPart.CFrame:ToWorldSpace(CFrame.new(offset + heightOffset))

            -- Look at player
            local lookAtCFrame = CFrame.new(cameraCFrame.Position, rootPart.Position + Vector3.new(0, Settings.ThirdHeight, 0))

            -- Apply smoothing
            local currentCamCFrame = workspace.CurrentCamera.CFrame
            local smoothness = 0.1 * Settings.ThirdSensitivity
            workspace.CurrentCamera.CFrame = currentCamCFrame:Lerp(lookAtCFrame, smoothness)
        end
    end
end

local function ToggleThirdPerson()
    ThirdPersonEnabled = Settings.ThirdPerson

    if ThirdPersonEnabled then
        -- Store original camera settings
        OriginalCameraOffset = workspace.CurrentCamera.CFrame.Position -
                              (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                               LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new())

        -- Start third person update loop
        ThirdPersonConnection = RunService.Heartbeat:Connect(UpdateThirdPerson)

        warn("Third person enabled")
    else
        -- Restore original camera
        if ThirdPersonConnection then
            ThirdPersonConnection:Disconnect()
            ThirdPersonConnection = nil
        end

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            workspace.CurrentCamera.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end

        warn("Third person disabled")
    end
end

-- ═══════════════════════════════════════════════════════════
-- INFINITE JUMP SYSTEM
-- ═══════════════════════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- MOVEMENT UPDATE LOOP
-- ═══════════════════════════════════════════════════════════

-- Main update loop for movement features
local MovementUpdateConnection
MovementUpdateConnection = RunService.Heartbeat:Connect(function()
    -- Speed boost updates
    if Settings.SpeedBoost then
        UpdateSpeedBoost()
    end

    -- No camera shaking
    if Settings.NoCameraShaking then
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            cam.CameraType = Enum.CameraType.Custom
        end
    end

    -- Enable/Disable movement features based on settings
    -- (These are toggled through the UI callbacks in the main script)
end)

-- Update movement features when settings change
local function UpdateMovementFeatures()
    -- Speed Boost
    UpdateSpeedBoost()

    -- Fly
    if Settings.Fly and not FlyEnabled then
        ToggleFly()
    elseif not Settings.Fly and FlyEnabled then
        ToggleFly()
    end

    -- Freecam
    if Settings.Freecam and not FreecamEnabled then
        ToggleFreecam()
    elseif not Settings.Freecam and FreecamEnabled then
        ToggleFreecam()
    end

    -- Third Person
    ToggleThirdPerson()
end

-- Hook into UI callbacks (these would be called from the main UI system)
_G.VesperUpdateMovement = UpdateMovementFeatures

-- Auto-update when settings change (polling)
task.spawn(function()
    while true do
        task.wait(0.5)

        local currentSpeedBoost = Settings.SpeedBoost
        local currentFly = Settings.Fly
        local currentFreecam = Settings.Freecam
        local currentThirdPerson = Settings.ThirdPerson
        local currentInfiniteJump = Settings.InfiniteJump

        task.wait(0.1) -- Small delay to prevent race conditions

        if currentSpeedBoost ~= Settings.SpeedBoost or
           currentFly ~= Settings.Fly or
           currentFreecam ~= Settings.Freecam or
           currentThirdPerson ~= Settings.ThirdPerson or
           currentInfiniteJump ~= Settings.InfiniteJump then
            _G.VesperUpdateMovement()
        end
    end
end)

WaveDebug.print("═══════════════════════════════")
WaveDebug.print("vesper.lua v2.0 - Enhanced Edition")
WaveDebug.print("═══════════════════════════════")
WaveDebug.print("✅ Wave Debug System: ACTIVE")
WaveDebug.print("✅ Rainbow ESP: IMPLEMENTED")
WaveDebug.print("✅ Entity Healing: ACTIVE")
WaveDebug.print("✅ Enhanced Door ESP: ACTIVE")
WaveDebug.print("Q = Noclip | RightShift = Menu")
WaveDebug.print("Alt+Click = Teleport | WASD = Movement")
WaveDebug.print("═══════════════════════════════")
WaveDebug.info("Script loaded successfully!")
