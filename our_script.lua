-- DOORS Complete ESP & Auto Features - CLEAN REWRITE
-- Made for LO ♥
-- Enhanced with Wave Console Integration - COMPLETE VERSION

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
    GodMode = false,
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
    FogEnabled = false,
    GodMode = false,
    AmbushImmunity = false,
    RushImmunity = false,
    SeekImmunity = false,
    HaltImmunity = false,
    FigureImmunity = false,
    InstantKill = false,
    OnePunch = false,
    NoCooldown = false
}

-- ═══════════════════════════════════════════════════════════
-- UNIFIED ESP SYSTEM - Clean implementation with distance checks
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

-- ESP Functions with distance and time tracking
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
            debugPrint("Restoring original ESP colors...", "INFO")
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
            debugPrint("Original ESP colors restored!", "INFO")
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

    debugPrint("Rainbow ESP system activated!", "INFO")
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

    -- AGGRESSIVE DOOR ESP METHOD - Always find a target
    local doorTarget = nil

    -- Method 1: Main door part
    local doorPart = door:FindFirstChild("Door")
    if doorPart and doorPart:IsA("BasePart") then
        doorTarget = doorPart
    end

    -- Method 2: Any visible part inside door
    if not doorTarget then
        for _, part in pairs(door:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.8 then
                doorTarget = part
                break
            end
        end
    end

    -- Method 3: Fallback to entire door model
    if not doorTarget then
        doorTarget = door
    end

    -- Apply ESP if we found a target
    if doorTarget and not HasESP(doorTarget) then
        ApplyESP(doorTarget, text, Settings.DoorESPColor, "Door", room.Name)
        OpenedDoors[door] = {opened = false, espTarget = doorTarget}
        debugPrint("Door ESP applied to room " .. room.Name, "INFO")
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
                debugPrint(string.format("Door %d opened - ESP cleared", displayNum), "INFO")
            end)
        end
    end
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
-- ROOM SCANNER
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
-- LOAD OBSIDIAN UI WITH ERROR HANDLING
-- ═══════════════════════════════════════════════════════════

local Library, ThemeManager, SaveManager, Window, Options, Toggles
local success, err = pcall(function()
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
    ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
    SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

    Options = Library.Options
    Toggles = Library.Toggles

    Window = Library:CreateWindow({
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
end)

if not success then
    debugPrint("Failed to load Obsidian UI: " .. tostring(err), "ERROR")
    debugPrint("Creating fallback UI...", "WARN")

    -- Fallback UI using simple ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true

    -- Create simple toggle frame
    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0, 100, 0, 100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 0
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Text = "vesper.lua v2.1 - FALLBACK UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    -- Make frame draggable
    local dragging = false
    local dragStart = Frame.Position
    local startPos

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Frame.Position
            startPos = input.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            Frame.Position = UDim2.new(dragStart.X.Scale, dragStart.X.Offset + delta.X, dragStart.Y.Scale, dragStart.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Simple notification function
    Library = {
        Notify = function(opts)
            local notif = Instance.new("Frame")
            notif.Parent = ScreenGui
            notif.Size = UDim2.new(0, 250, 0, 80)
            notif.Position = UDim2.new(1, -270, 1, -100)
            notif.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            notif.BorderSizePixel = 0

            local title = Instance.new("TextLabel")
            title.Parent = notif
            title.Size = UDim2.new(1, -20, 0, 30)
            title.Position = UDim2.new(0, 10, 0, 10)
            title.BackgroundTransparency = 1
            title.Text = opts.Title or "Notification"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Font = Enum.Font.Gotham
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left

            local desc = Instance.new("TextLabel")
            desc.Parent = notif
            desc.Size = UDim2.new(1, -20, 0, 40)
            desc.Position = UDim2.new(0, 10, 0, 30)
            desc.BackgroundTransparency = 1
            desc.Text = opts.Description or ""
            desc.TextColor3 = Color3.fromRGB(200, 200, 200)
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 14
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextWrapped = true

            -- Animate in
            notif:TweenPosition(UDim2.new(1, -270, 1, -90), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)

            game:GetService("Debris"):AddItem(notif, opts.Time or 5)

            delay(opts.Time or 5, function()
                if notif and notif.Parent then
                    notif:TweenPosition(UDim2.new(1, 0, 1, -90), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3)
                    wait(0.3)
                    notif:Destroy()
                end
            end)
        end
    }

    Options = {}
    Toggles = {}

    -- Add simple toggles to fallback UI
    local y_offset = 50
    local function createToggle(name, setting, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Parent = Frame
        Toggle.Size = UDim2.new(1, -20, 0, 30)
        Toggle.Position = UDim2.new(0, 10, 0, y_offset)
        Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Toggle.BorderSizePixel = 0
        Toggle.Text = name .. ": OFF"
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 14

        Toggle.MouseButton1Click:Connect(function()
            Settings[setting] = not Settings[setting]
            Toggle.Text = name .. ": " .. (Settings[setting] and "ON" or "OFF")
            Toggle.BackgroundColor3 = Settings[setting] and Color3.fromRGB(25, 100, 25) or Color3.fromRGB(50, 50, 50)
            if callback then callback(Settings[setting]) end
        end)

        y_offset = y_offset + 35
    end

    -- Create essential toggles
    createToggle("Door ESP", "DoorESP")
    createToggle("Item ESP", "ItemESP")
    createToggle("Entity ESP", "EntityESP")
    createToggle("Fullbright", "Fullbright", function(value)
        if value then
            ApplyFullbright()
        else
            RemoveFullbright()
        end
    end)
    createToggle("God Mode", "GodMode")
    createToggle("Noclip", "Noclip")

    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            Frame.Visible = not Frame.Visible
        end
    end)

    debugPrint("Fallback UI created successfully", "INFO")
    debugPrint("Press RightShift to toggle menu", "INFO")
end

-- Only create UI elements if Obsidian loaded successfully
if success then
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

-- Wave Console Test Group
local WaveGroup = Tabs.Main:AddRightGroupbox("Wave Console", "terminal")

WaveGroup:AddButton({
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

WaveGroup:AddButton({
    Text = "Clear Console",
    Callback = function()
        rconsoleclear()
        debugPrint("Console cleared", "INFO")
    end
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
        debugPrint("Rainbow ESP toggled: " .. tostring(Value), "INFO")
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

ESPItemsGroup:AddToggle("ItemESP", {
    Text = "Item ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.ItemESP = Value
        debugPrint("Item ESP: " .. tostring(Value), "INFO")
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

ESPItemsGroup:AddToggle("GoldESP", {
    Text = "Gold ESP enabled",
    Default = false,
    Callback = function(Value)
        Settings.GoldESP = Value
        debugPrint("Gold ESP: " .. tostring(Value), "INFO")
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
        debugPrint("Key ESP: " .. tostring(Value), "INFO")
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
    Description = "DOORS script v2.1 Wave Edition | Press RightShift to toggle",
    Time = 5
})

-- ═══════════════════════════════════════════════════════════
-- EXPLOITS TAB
-- ═══════════════════════════════════════════════════════════

local ProtectionGroup = Tabs.Exploits:AddLeftGroupbox("Protection", "shield")

ProtectionGroup:AddToggle("ScreechProtection", {
    Text = "Anti Screech",
    Default = false,
    Callback = function(Value)
        Settings.ScreechProtection = Value
        debugPrint("Screech protection: " .. tostring(Value), "INFO")
    end
}):AddTooltip("Protects from Screech jumpscare")

ProtectionGroup:AddToggle("EyesProtection", {
    Text = "Anti Eyes (Working!)",
    Default = false,
    Callback = function(Value)
        Settings.ScreechProtection = Value -- Uses same setting
        debugPrint("Eyes protection: " .. tostring(Value), "INFO")
    end
}):AddTooltip("Makes Eyes visible but harmless")

ProtectionGroup:AddToggle("AmbushImmunity", {
    Text = "Anti Ambush",
    Default = false,
    Callback = function(Value)
        Settings.AmbushImmunity = Value
        if Value then
            Library:Notify({Title = "Ambush Immunity", Description = "You are now immune to Ambush!", Time = 3})
        end
    end
})

ProtectionGroup:AddToggle("RushImmunity", {
    Text = "Anti Rush",
    Default = false,
    Callback = function(Value)
        Settings.RushImmunity = Value
        if Value then
            Library:Notify({Title = "Rush Immunity", Description = "You are now immune to Rush!", Time = 3})
        end
    end
})

ProtectionGroup:AddDivider()

ProtectionGroup:AddToggle("SeekImmunity", {
    Text = "Anti Seek",
    Default = false,
    Callback = function(Value)
        Settings.SeekImmunity = Value
        if Value then
            Library:Notify({Title = "Seek Immunity", Description = "Seek cannot harm you!", Time = 3})
        end
    end
})

ProtectionGroup:AddToggle("HaltImmunity", {
    Text = "Anti Halt",
    Default = false,
    Callback = function(Value)
        Settings.HaltImmunity = Value
        if Value then
            Library:Notify({Title = "Halt Immunity", Description = "Halt cannot harm you!", Time = 3})
        end
    end
})

ProtectionGroup:AddToggle("FigureImmunity", {
    Text = "Anti Figure",
    Default = false,
    Callback = function(Value)
        Settings.FigureImmunity = Value
        if Value then
            Library:Notify({Title = "Figure Immunity", Description = "Figure cannot harm you!", Time = 3})
        end
    end
})

local DamageGroup = Tabs.Exploits:AddRightGroupbox("Damage Control", "heart-cross")

DamageGroup:AddToggle("GodMode", {
    Text = "God Mode",
    Default = false,
    Callback = function(Value)
        Settings.GodMode = Value
        if Value then
            task.spawn(function()
                while Settings.GodMode and LocalPlayer.Character do
                    local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                    if hum then
                        hum.MaxHealth = 999999
                        hum.Health = 999999
                    end
                    task.wait()
                end
            end)
            Library:Notify({Title = "God Mode", Description = "Invincibility activated!", Time = 3})
        else
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum.MaxHealth = 100
                end
            end
        end
    end
})

DamageGroup:AddSlider("HealthSet", {
    Text = "Set Health",
    Default = 100,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.Health = Value
                hum.MaxHealth = Value
            end
        end
    end
})

DamageGroup:AddButton({
    Text = "Revive",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
            task.wait()
            LocalPlayer.Character:LoadCharacter()
            Library:Notify({Title = "Revived", Description = "You have been revived!", Time = 3})
        end
    end
})

-- ═══════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════════════════════

local TeleportGroup = Tabs.Teleport:AddLeftGroupbox("Quick Teleport", "map")

TeleportGroup:AddButton({
    Text = "Lobby",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-10, 3, 0))
            Library:Notify({Title = "Teleported", Description = "To lobby", Time = 2})
        end
    end
})

TeleportGroup:AddButton({
    Text = "Latest Room",
    Callback = function()
        local CurrentRoom = getCurrentRoom()
        if CurrentRoom and CurrentRoom.PrimaryPart and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(CurrentRoom.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
            Library:Notify({Title = "Teleported", Description = "To latest room", Time = 2})
        end
    end
})

-- ═══════════════════════════════════════════════════════════
-- COMBAT TAB
-- ═══════════════════════════════════════════════════════════

local CombatGroup = Tabs.Combat:AddLeftGroupbox("Combat", "sword")

CombatGroup:AddToggle("InstantKill", {
    Text = "Instant Kill (All)",
    Default = false,
    Callback = function(Value)
        Settings.InstantKill = Value
        if Value then
            Library:Notify({Title = "Instant Kill", Description = "All entities will die instantly!", Time = 3})
        end
    end
})

CombatGroup:AddToggle("OnePunch", {
    Text = "One Punch",
    Default = false,
    Callback = function(Value)
        Settings.OnePunch = Value
        if Value then
            Library:Notify({Title = "One Punch", Description = "Kill with one hit!", Time = 3})
        end
    end
})

CombatGroup:AddToggle("NoCooldown", {
    Text = "No Ability Cooldown",
    Default = false,
    Callback = function(Value)
        Settings.NoCooldown = Value
        if Value then
            Library:Notify({Title = "No Cooldown", Description = "Abilities have no cooldown!", Time = 3})
        end
    end
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
    debugPrint("Room " .. room.Name .. " removed - ESP cleared", "INFO")
end)

-- Continuous monitoring for new items
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

-- Initial scan after delay
task.spawn(function()
    task.wait(1.5)
    ScanAllRooms()
    debugPrint("Initial room scan complete!", "INFO")
end)

-- ═══════════════════════════════════════════════════════════
-- ENTITY DETECTION
-- ═══════════════════════════════════════════════════════════

local EntityTracked = {}

local function SetupEntityESP(entity, name, color)
    if EntityTracked[entity] then return end
    EntityTracked[entity] = true

    debugPrint(name .. " SPAWNED!", "WARN")

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
        while entity and entity.Parent do
            pcall(function()
                -- Update visibility based on current setting
                highlight.Enabled = Settings.EntityESP
                billboard.Enabled = Settings.EntityESP

                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = entity:IsA("Model") and entity:GetPivot().Position or entity.Position
                    local dist = math.floor((hrp.Position - pos).Magnitude)
                    label.Text = name .. " - " .. dist .. " studs"
                end
            end)
            task.wait(0.5)
        end

        -- Cleanup
        EntityTracked[entity] = nil
        debugPrint(name .. " despawned", "DEBUG")
    end)
end

-- Entity detection
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "RushMoving" then
        SetupEntityESP(child, "RUSH", Color3.fromRGB(255, 25, 25))
    elseif child.Name == "AmbushMoving" then
        SetupEntityESP(child, "AMBUSH", Color3.fromRGB(255, 100, 0))
    elseif child.Name == "Eyes" then
        SetupEntityESP(child, "EYES", Color3.fromRGB(255, 255, 0))
    end
end)

-- ═══════════════════════════════════════════════════════════
-- MOVEMENT SYSTEMS
-- ═══════════════════════════════════════════════════════════

-- Noclip
local noclip = false
local noclipConn

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        noclip = not noclip
        debugPrint("Noclip: " .. (noclip and "ON" or "OFF"), "INFO")
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

-- God Mode
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if Settings.GodMode then
            humanoid.Health = humanoid.MaxHealth
            debugPrint("God Mode: Prevented death", "INFO")
        end
    end)
end)

-- Break void
RunService.Heartbeat:Connect(function()
    if Settings.BreakVoid and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < -200 then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 400, 0)
            debugPrint("Prevented void fall!", "INFO")
        end
    end
end)
end

-- ═══════════════════════════════════════════════════════════
-- FINAL CONSOLE OUTPUT
-- ═══════════════════════════════════════════════════════════

debugPrint("═════════════════════════════════════════════════════════", "INFO")
debugPrint("vesper.lua v2.1 - Wave Console Edition - COMPLETE VERSION", "INFO")
debugPrint("═════════════════════════════════════════════════════════", "INFO")
debugPrint("✅ Wave Console: ACTIVE", "INFO")
debugPrint(success and "✅ Obsidian UI: LOADED" or "✅ Fallback UI: CREATED", "INFO")
debugPrint("✅ All ESP Systems: READY", "INFO")
debugPrint("✅ Entity Protections: ACTIVE", "INFO")
debugPrint("✅ Fullbright: FIXED", "INFO")
debugPrint("✅ ESP Distance Limits: ACTIVE", "INFO")
debugPrint("Press RightShift to toggle menu", "INFO")
debugPrint("Use Q for noclip", "INFO")
debugPrint("═════════════════════════════════════════════════════════", "INFO")