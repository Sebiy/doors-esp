-- DOORS Complete ESP & Auto Features - CLEAN REWRITE
-- Made for LO ♥
-- Enhanced with Wave Console Integration - FIXED VERSION

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")
local Lighting = game:GetService("Lighting")

-- ═══════════════════════════════════════════════════════════
-- WAVE CONSOLE INTEGRATION - Using official Wave functions
-- ═══════════════════════════════════════════════════════════

-- Initialize Wave console immediately
rconsolecreate()
rconsolename("vesper.lua v2.1 - Wave Console - " .. os.date("%Y-%m-%d %H:%M:%S"))

-- Console header
rconsoleprint("@@LIGHT_BLUE@@")
rconsoleprint("╔════════════════════════════════════════════════════════╗\n")
rconsoleprint("@@CYAN@@")
rconsoleprint("│                 vesper.lua v2.1 - Wave Edition                │\n")
rconsoleprint("│            DOORS Script with Official Wave Functions          │\n")
rconsoleprint("@@LIGHT_BLUE@@")
rconsoleprint("╚════════════════════════════════════════════════════════╝\n")
rconsoleprint("@@WHITE@@")

-- Simple debug functions using Wave
local function debugPrint(message, level)
    level = level or "INFO"
    if level == "ERROR" then
        rconsoleerr("@@RED@@[ERROR] @@WHITE@@" .. tostring(message) .. "\n")
    elseif level == "WARN" then
        rconsolewarn("@@YELLOW@@[WARN] @@WHITE@@" .. tostring(message) .. "\n")
    elseif level == "DEBUG" then
        rconsoledebug("@@LIGHT_BLUE@@[DEBUG] @@WHITE@@" .. tostring(message) .. "\n")
    else
        rconsoleprint("@@WHITE@@" .. tostring(message) .. "\n")
    end
end

-- Test console immediately
debugPrint("Wave Console initialized!", "INFO")
debugPrint("Using official Wave rconsole functions", "INFO")

-- Show system info
local success, hwid = pcall(gethwid)
if success then
    debugPrint("HWID: " .. hwid, "INFO")
end

local success2, fps = pcall(getfpscap)
if success2 then
    debugPrint("FPS Cap: " .. tostring(fps), "INFO")
end

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

-- Fullbright system - FIXED
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    ClockTime = Lighting.ClockTime,
    GeographicLatitude = Lighting.GeographicLatitude,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    ExposureCompensation = Lighting.ExposureCompensation
}

local function ApplyFullbright()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 12
        Lighting.GeographicLatitude = 0
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.ExposureCompensation = 1
        debugPrint("Fullbright applied", "DEBUG")
    end
end

local function RestoreLighting()
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.FogEnd = OriginalLighting.FogEnd
    Lighting.FogStart = OriginalLighting.FogStart or 50
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.ClockTime = OriginalLighting.ClockTime or 14
    Lighting.GeographicLatitude = OriginalLighting.GeographicLatitude or 50
    Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale or 1
    Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale or 1
    Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation or 0
    debugPrint("Lighting restored", "DEBUG")
end

-- Continuous fullbright application
task.spawn(function()
    while true do
        if Settings.Fullbright then
            ApplyFullbright()
        end
        task.wait(0.5)
    end
end)

-- ESP Functions
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
    debugPrint("Cleared ESP in room: " .. roomName, "DEBUG")
end

local function ApplyESP(instance, text, color, espType, roomName)
    if HasESP(instance) then return end

    -- Distance check - FIXED
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local pos = instance:IsA("Model") and instance:GetPivot().Position or instance.Position
        local dist = (hrp.Position - pos).Magnitude
        -- Only apply ESP if within reasonable distance (1000 studs)
        if dist > 1000 then
            return
        end
    end

    local highlight, billboard

    -- Create highlight
    if instance:IsA("Model") then
        highlight = Instance.new("Highlight")
        highlight.Parent = instance
        highlight.Adornee = instance
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
        roomName = roomName or "unknown",
        createdAt = tick() -- Track when ESP was created
    }

    -- Auto-cleanup when destroyed
    instance.AncestryChanged:Connect(function()
        if not instance:IsDescendantOf(game) then
            ClearESP(instance)
        end
    end)

    debugPrint(text .. " ESP applied!", "DEBUG")
end

-- Update ESP with distance checking
local function UpdateESPWithDistance()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local toRemove = {}
    local currentTime = tick()

    for instance, data in pairs(ESPRegistry) do
        local pos = instance:IsA("Model") and instance:GetPivot().Position or instance.Position
        local dist = (hrp.Position - pos).Magnitude

        -- Remove ESP if too far or too old
        if dist > 1000 or (currentTime - data.createdAt > 30) then
            table.insert(toRemove, instance)
        end
    end

    for _, instance in ipairs(toRemove) do
        ClearESP(instance)
    end
end

-- Clean up ESP every 5 seconds
task.spawn(function()
    while true do
        UpdateESPWithDistance()
        task.wait(5)
    end
end)

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
    Footer = "version: v2.1 | latest obsidian-ui v0.12.0 | Wave Console Edition",
    Icon = "rbxassetid://87962219786952",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    AutoShow = true,
    Config = {
        SaveSettings = true,
        SaveKeybinds = true,
        NoKeybindNotification = false,
        KeybindSound = true
    }
})

local Tabs = {
    Main = Window:AddTab("Main", "home"),
    ESP = Window:AddTab("ESP", "eye"),
    Player = Window:AddTab("Player", "user"),
    Visuals = Window:AddTab("Visuals", "monitor"),
    Settings = Window:AddTab("UI Settings", "settings"),
    Exploits = Window:AddTab("Exploits", "shield"),
    Teleport = Window:AddTab("Teleport", "map"),
    Combat = Window:AddTab("Combat", "sword"),
}

-- ═══════════════════════════════════════════════════════════
-- VISUALS TAB - Fullbright Fix
-- ═══════════════════════════════════════════════════════════

local LightingGroup = Tabs.Visuals:AddRightGroupbox("Lighting", "sun")

LightingGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        Settings.Fullbright = Value
        if Value then
            ApplyFullbright()
            debugPrint("Fullbright enabled", "INFO")
        else
            RestoreLighting()
            debugPrint("Fullbright disabled", "INFO")
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
            Lighting.Brightness = Value
        end
    end
})

-- Test Wave Console button
local TestGroup = Tabs.Main:AddRightGroupbox("Wave Console", "terminal")

TestGroup:AddButton({
    Text = "Test Wave Console",
    Callback = function()
        debugPrint("Test message from vesper.lua!", "INFO")
        rconsoleprint("@@GREEN@@This is green text!\n")
        rconsolewarn("@@YELLOW@@This is a warning!\n")
        rconsoleerr("@@RED@@This is an error!\n")
        rconsoledebug("@@LIGHT_BLUE@@This is debug text!\n")
        Library:Notify({Title = "Wave Console Test", Description = "Check Wave console for messages", Time = 3})
    end
})

TestGroup:AddButton({
    Text = "Clear Console",
    Callback = function()
        rconsoleclear()
        debugPrint("Console cleared", "INFO")
    end
})

-- ═══════════════════════════════════════════════════════════
-- ESP TAB - ESP Controls
-- ═══════════════════════════════════════════════════════════

local ESPItemsGroup = Tabs.ESP:AddRightGroupbox("ESP Items", "package")

ESPItemsGroup:AddToggle("DoorESP", {
    Text = "Door ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.DoorESP = Value
        debugPrint("Door ESP: " .. tostring(Value), "INFO")
        if Value then
            ScanAllRooms()
        else
            ClearAllESPOfType("Door")
        end
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
        debugPrint("Closet ESP: " .. tostring(Value), "INFO")
    end
}):AddColorPicker("ClosetESPColor", {
    Default = Settings.ClosetESPColor,
    Title = "Closet ESP Color",
    Callback = function(Value)
        Settings.ClosetESPColor = Value
        UpdateESPColor("Closet", Value)
    end
})

ESPItemsGroup:AddToggle("ObjectiveESP", {
    Text = "Objective ESP (Levers/Valves)",
    Default = false,
    Callback = function(Value)
        Settings.ObjectiveESP = Value
        debugPrint("Objective ESP: " .. tostring(Value), "INFO")
    end
}):AddColorPicker("ObjectiveESPColor", {
    Default = Settings.ObjectiveESPColor,
    Title = "Objective ESP Color",
    Callback = function(Value)
        Settings.ObjectiveESPColor = Value
        UpdateESPColor("Objective", Value)
    end
})

-- Helper functions
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

local function getCurrentRoom()
    local rooms = CurrentRooms:GetChildren()
    if #rooms == 0 then return nil end

    -- Find the highest numbered room
    local highestRoom = nil
    local highestNum = -1

    for _, room in pairs(rooms) do
        local num = tonumber(room.Name)
        if num and num > highestNum then
            highestNum = num
            highestRoom = room
        end
    end

    return highestRoom
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

    -- Apply ESP to main door part
    local doorPart = door:FindFirstChild("Door")
    if doorPart and not HasESP(doorPart) then
        ApplyESP(doorPart, text, Settings.DoorESPColor, "Door", room.Name)
        OpenedDoors[door] = {opened = false, espTarget = doorPart}
        debugPrint("Door ESP applied to room " .. room.Name, "INFO")
    end
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

-- ESP Scanning
local ItemNames = {"Lighter", "Flashlight", "Lockpick", "Vitamins", "Crucifix", "Candle", "Battery"}

local function ScanRoom(room)
    ApplyDoorESP(room)

    for _, desc in pairs(room:GetDescendants()) do
        local name = desc.Name

        if name == "Wardrobe" then
            local p = desc.Parent
            if p and (p.Name == "Assets" or p.Parent == CurrentRooms) then
                ApplyWardrobeESP(desc)
            end
        elseif name == "LeverForGate" then
            ApplyObjectiveESP(desc, "LEVER FOR GATE")
        elseif name:find("Lever") then
            ApplyObjectiveESP(desc, "LEVER")
        elseif name:find("Valve") then
            ApplyObjectiveESP(desc, "VALVE")
        else
            for _, itemName in ipairs(ItemNames) do
                if name == itemName then
                    if Settings.ItemESP then
                        ApplyESP(desc, itemName:upper(), Settings.ItemESPColor, "Item", GetRoomName(desc))
                    end
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

-- Room monitoring
CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(0.3)
    ScanRoom(room)
end)

CurrentRooms.ChildRemoved:Connect(function(room)
    ClearESPInRoom(room.Name)
    debugPrint("Room " .. room.Name .. " removed - ESP cleared", "INFO")
end)

-- Initial scan
task.wait(1.5)
ScanAllRooms()
debugPrint("Initial room scan complete!", "INFO")

-- ═══════════════════════════════════════════════════════════
-- FINAL CONSOLE OUTPUT
-- ═══════════════════════════════════════════════════════════

debugPrint("═════════════════════════════════════════════════════════", "INFO")
debugPrint("vesper.lua v2.1 - Wave Console Edition - FULLY LOADED", "INFO")
debugPrint("═════════════════════════════════════════════════════════", "INFO")
debugPrint("✅ Wave Console: ACTIVE", "INFO")
debugPrint("✅ Obsidian UI: LOADED", "INFO")
debugPrint("✅ ESP System: READY", "INFO")
debugPrint("Press RightShift to toggle menu", "INFO")
debugPrint("═════════════════════════════════════════════════════════", "INFO")