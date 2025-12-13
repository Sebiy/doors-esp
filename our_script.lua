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
    return ESPRegistry[instance] ~= nil
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
    
    warn(text .. " ESP applied!")
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

    -- FIX: Enhanced door detection for multiple door types and updates
    local doorTargets = {} -- Store multiple targets for better coverage

    -- Method 1: Try to find the main "Door" part
    local doorPart = door:FindFirstChild("Door")
    if doorPart and doorPart:IsA("BasePart") and doorPart.Transparency < 1 then
        table.insert(doorTargets, doorPart)
    end

    -- Method 2: Find parts with door-like names
    local doorNames = {"Door", "DoorLeaf", "DoorMain", "DoorSurface", "DoorMesh", "DoorPart"}
    for _, name in pairs(doorNames) do
        local parts = door:GetDescendants()
        for _, part in pairs(parts) do
            if part:IsA("BasePart") and part.Name:find(name) and part.Transparency < 1 then
                table.insert(doorTargets, part)
            end
        end
    end

    -- Method 3: Find all substantial visible parts (not too small)
    if #doorTargets == 0 then
        for _, part in pairs(door:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 then
                local partSize = part.Size.X * part.Size.Y * part.Size.Z
                -- Only include parts that are reasonably sized (avoid tiny hardware)
                if partSize > 0.1 then
                    table.insert(doorTargets, part)
                end
            end
        end
    end

    -- Method 4: Fallback to entire door model if no parts found
    if #doorTargets == 0 then
        table.insert(doorTargets, door)
    end

    -- Apply ESP to all valid targets found
    local appliedTargets = {}
    for _, target in pairs(doorTargets) do
        if not HasESP(target) then
            ApplyESP(target, text, Settings.DoorESPColor, "Door", room.Name)
            table.insert(appliedTargets, target)
        end
    end

    -- Store references for cleanup
    if #appliedTargets > 0 then
        OpenedDoors[door] = {
            opened = false,
            espTargets = appliedTargets
        }
    end

    -- Monitor door opening
    for _, desc in pairs(door:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            if Settings.InstantInteract then desc.HoldDuration = 0 end
            if Settings.DoorReach then desc.MaxActivationDistance = 20 end

            desc.Triggered:Connect(function()
                if OpenedDoors[door] and OpenedDoors[door].espTargets then
                    for _, target in pairs(OpenedDoors[door].espTargets) do
                        ClearESP(target)
                    end
                end
                OpenedDoors[door] = {opened = true, espTargets = {}}
                warn(string.format("Door %d opened - ESP cleared", displayNum))
            end)
        end
    end

    door:GetAttributeChangedSignal("Opened"):Connect(function()
        if door:GetAttribute("Opened") then
            if OpenedDoors[door] and OpenedDoors[door].espTargets then
                for _, target in pairs(OpenedDoors[door].espTargets) do
                    ClearESP(target)
                end
            end
            OpenedDoors[door] = {opened = true, espTargets = {}}
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
    Callback = function(Value) Settings.RainbowESP = Value end
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

-- Initial scan after delay
task.spawn(function()
    task.wait(1.5)
    ScanAllRooms()
    warn("Initial room scan complete!")
end)

-- ═══════════════════════════════════════════════════════════
-- ENTITY DETECTION (Rush, Ambush, Eyes, Screech)
-- ═══════════════════════════════════════════════════════════

local EntityTracked = {}

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
            task.wait(0.1)
        end
        EntityTracked[entity] = nil
        warn(name .. " despawned")
    end)
end

-- Entity monitors
RunService.Heartbeat:Connect(function()
    -- Rush
    local rush = Workspace:FindFirstChild("RushMoving")
    if rush then SetupEntityESP(rush, "RUSH", Color3.fromRGB(255, 25, 25)) end
    
    -- Ambush
    local ambush = Workspace:FindFirstChild("AmbushMoving")
    if ambush then SetupEntityESP(ambush, "AMBUSH", Color3.fromRGB(255, 100, 0)) end
    
    -- Eyes (destroy if protection enabled)
    local eyes = Workspace:FindFirstChild("Eyes")
    if eyes then
        if Settings.ScreechProtection then
            pcall(function() eyes:Destroy() end)
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.Health = hum.MaxHealth end
            end
        else
            SetupEntityESP(eyes, "EYES", Color3.fromRGB(255, 255, 0))
        end
    end
end)

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

print("═══════════════════════════════")
print("vesper.lua v2.0 - Clean Rewrite")
print("═══════════════════════════════")
print("Q = Noclip | RightShift = Menu")
print("Alt+Click = Teleport | WASD = Movement")
print("═══════════════════════════════")
warn("Script loaded successfully!")
