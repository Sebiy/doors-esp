-- DOORS Complete ESP & Auto Features - Rewritten
-- Made for LO ♥

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")

-- Settings
local Settings = {
    -- ESP Settings
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
    
    -- Entity/Notifiers
    EntityNotify = false,
    NotifyInChat = false,
    NotificationSound = false,
    RushESP = false,
    AmbushESP = false,
    EyesESP = false,
    ScreechProtection = false,
    
    -- Miscellaneous
    InstantInteract = false,
    BreakVoid = false,
    NoCutscenes = false,
    DoorReach = false,
    
    -- Automation
    AutoPlayAgain = false,
    AutoLobby = false,
    AutoLibraryCode = false,
    AutoBreakerBox = false,
    
    -- Auras
    LeverValveAura = false,
    LootAura = false,
    AutoCollectBooks = false,
    LockedDoorAura = false,
    
    -- Movement
    NoclipBypassSpeed = 3,
    SpeedBoost = false,
    SpeedBypass = false,
    NoAcceleration = false,
    Fly = false,
    FlySpeed = 0.4,
    TeleportEnabled = false,
    TeleportDistance = 15,
    
    -- Character
    Noclip = false,
    EnableJump = true,
    InfiniteJump = false,
    ClosetExitFix = false,
    
    -- Camera/Visual
    FOV = 90,
    NoCameraShaking = false,
    Freecam = false,
    ThirdPerson = false,
    ThirdOffset = 0,
    ThirdHeight = 3,
    ThirdDistance = 10,
    ThirdSensitivity = 1,
    
    -- Lighting
    Fullbright = false,
    Brightness = 2,
    FogEnabled = false
}

--[[ 
    ╔═══════════════════════════════════════════════════════════╗
    ║                    VESPER.LUA GUI                         ║
    ║                  Modern Purple Theme                      ║
    ╚═══════════════════════════════════════════════════════════╝
]]



-- Load MSPaint Obsidian Library
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- Create Window
local Window = Library:CreateWindow({
    Title = "vesper.lua",
    Footer = "version: v1.0 | made with ♥",
    Icon = "rbxassetid://87962219786952", -- vesper.lua logo
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    AutoShow = true,
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab("Main", "home"),
    ESP = Window:AddTab("ESP", "eye"),
    Player = Window:AddTab("Player", "user"),
    Visuals = Window:AddTab("Visuals", "monitor"),
    Settings = Window:AddTab("UI Settings", "settings"),
}

-- ============================================
-- MAIN TAB
-- ============================================

local MiscGroup = Tabs.Main:AddLeftGroupbox("Miscellaneous", "wrench")

MiscGroup:AddToggle("InstantInteract", {
    Text = "Instant Proximity Prompt",
    Tooltip = "Instantly interact with prompts",
    Default = Settings.InstantInteract,
    Callback = function(Value)
        Settings.InstantInteract = Value
        -- Apply to all existing prompts
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                if Value then
                    prompt.HoldDuration = 0
                end
            end
        end
    end
})

MiscGroup:AddToggle("BreakVoid", {
    Text = "break ROBLOX Void",
    Tooltip = "Prevents void death",
    Default = Settings.BreakVoid,
    Callback = function(Value)
        Settings.BreakVoid = Value
        if Value then
            warn("Break Void enabled - you won't fall through the world")
        end
    end
})

MiscGroup:AddToggle("NoCutscenes", {
    Text = "No cutscenes",
    Tooltip = "Skips cutscenes",
    Default = Settings.NoCutscenes,
    Callback = function(Value)
        Settings.NoCutscenes = Value
        if Value then
            -- Disable camera cutscenes by setting camera CFrame instantly
            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraType = Enum.CameraType.Custom
            end
            warn("No Cutscenes enabled")
        end
    end
})

MiscGroup:AddToggle("DoorReach", {
    Text = "Door Reach",
    Tooltip = "Extended door interaction range",
    Default = Settings.DoorReach,
    Callback = function(Value)
        Settings.DoorReach = Value
        -- Apply to all existing door prompts
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
    Tooltip = "Automatically restarts the game",
    Default = Settings.AutoPlayAgain,
    Callback = function(Value)
        Settings.AutoPlayAgain = Value
    end
})

AutoGroup:AddToggle("AutoLobby", {
    Text = "Auto Lobby",
    Tooltip = "Automatically returns to lobby",
    Default = Settings.AutoLobby,
    Callback = function(Value)
        Settings.AutoLobby = Value
    end
})

AutoGroup:AddToggle("AutoLibraryCode", {
    Text = "Auto Library Code",
    Tooltip = "Automatically solves library puzzle",
    Default = Settings.AutoLibraryCode,
    Callback = function(Value)
        Settings.AutoLibraryCode = Value
    end
})

AutoGroup:AddToggle("AutoBreakerBox", {
    Text = "Auto Breaker Box",
    Tooltip = "Automatically solves breaker puzzle",
    Default = Settings.AutoBreakerBox,
    Callback = function(Value)
        Settings.AutoBreakerBox = Value
    end
})

local NotifyGroup = Tabs.Main:AddRightGroupbox("Notifiers", "bell")

NotifyGroup:AddToggle("NotificationSound", {
    Text = "Notification sound",
    Tooltip = "Plays sound on entity spawn",
    Default = Settings.NotificationSound,
    Callback = function(Value)
        Settings.NotificationSound = Value
    end
})

NotifyGroup:AddToggle("EntityNotify", {
    Text = "Notify Entities",
    Tooltip = "Shows entity warnings",
    Default = Settings.EntityNotify,
    Callback = function(Value)
        Settings.EntityNotify = Value
    end
})

NotifyGroup:AddToggle("NotifyInChat", {
    Text = "Notify in Chat",
    Tooltip = "Sends entity notifications to chat",
    Default = Settings.NotifyInChat,
    Callback = function(Value)
        Settings.NotifyInChat = Value
    end
})

NotifyGroup:AddDivider()

NotifyGroup:AddToggle("ScreechProtection", {
    Text = "Screech Protection",
    Tooltip = "Blocks Screech damage",
    Default = Settings.ScreechProtection,
    Callback = function(Value)
        Settings.ScreechProtection = Value
    end
})

local AuraGroup = Tabs.Main:AddRightGroupbox("Auras", "sparkles")

AuraGroup:AddToggle("LeverValveAura", {
    Text = "Lever/Valve Aura",
    Tooltip = "Automatically activates levers/valves",
    Default = Settings.LeverValveAura,
    Callback = function(Value)
        Settings.LeverValveAura = Value
    end
})

AuraGroup:AddToggle("LootAura", {
    Text = "Loot Aura",
    Tooltip = "Automatically collects loot",
    Default = Settings.LootAura,
    Callback = function(Value)
        Settings.LootAura = Value
    end
})

AuraGroup:AddToggle("AutoCollectBooks", {
    Text = "Auto Collect Books/Breaker",
    Tooltip = "Automatically collects books and breaker items",
    Default = Settings.AutoCollectBooks,
    Callback = function(Value)
        Settings.AutoCollectBooks = Value
    end
})

AuraGroup:AddToggle("LockedDoorAura", {
    Text = "Locked Door Aura",
    Tooltip = "Automatically opens locked doors",
    Default = Settings.LockedDoorAura,
    Callback = function(Value)
        Settings.LockedDoorAura = Value
    end
})

-- ============================================
-- ESP TAB
-- ============================================

local ESPGeneralGroup = Tabs.ESP:AddLeftGroupbox("ESP General", "scan")

ESPGeneralGroup:AddToggle("UseAdornments", {
    Text = "Use Adornments",
    Tooltip = "Uses adornment-based ESP",
    Default = Settings.UseAdornments,
    Callback = function(Value)
        Settings.UseAdornments = Value
    end
})

ESPGeneralGroup:AddToggle("RainbowESP", {
    Text = "Rainbow ESP Enabled",
    Tooltip = "Makes ESP colors cycle through rainbow",
    Default = Settings.RainbowESP,
    Callback = function(Value)
        Settings.RainbowESP = Value
    end
})

ESPGeneralGroup:AddDivider()

ESPGeneralGroup:AddToggle("EntityESP", {
    Text = "Entity ESP enabled",
    Default = Settings.EntityESP,
    Callback = function(Value)
        Settings.EntityESP = Value
    end
}):AddColorPicker("EntityESPColor", {
    Default = Settings.EntityESPColor,
    Title = "Entity ESP Color",
    Callback = function(Value)
        Settings.EntityESPColor = Value
    end
})

ESPGeneralGroup:AddToggle("PlayerESP", {
    Text = "Player ESP enabled",
    Default = Settings.PlayerESP,
    Callback = function(Value)
        Settings.PlayerESP = Value
    end
}):AddColorPicker("PlayerESPColor", {
    Default = Settings.PlayerESPColor,
    Title = "Player ESP Color",
    Callback = function(Value)
        Settings.PlayerESPColor = Value
    end
})

local ESPItemsGroup = Tabs.ESP:AddRightGroupbox("ESP Items", "package")

ESPItemsGroup:AddToggle("DoorESP", {
    Text = "Door ESP enabled",
    Default = Settings.DoorESP,
    Callback = function(Value)
        Settings.DoorESP = Value
        if Value then
            -- Apply ESP to all existing rooms when toggled ON
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    ApplyDoorESP(room)
                end)
            end
        else
            -- Clear all door ESP when toggled OFF
            for _, espData in pairs(ESPObjects.Doors) do
                if espData.highlight and espData.highlight.Parent then
                    espData.highlight:Destroy()
                end
                if espData.billboard and espData.billboard.Parent then
                    espData.billboard:Destroy()
                end
            end
            ESPObjects.Doors = {}
        end
    end
}):AddColorPicker("DoorESPColor", {
    Default = Settings.DoorESPColor,
    Title = "Door ESP Color",
    Callback = function(Value)
        Settings.DoorESPColor = Value
        -- Update all existing door ESP colors
        for _, espData in pairs(ESPObjects.Doors) do
            if espData.highlight and espData.highlight.Parent then
                espData.highlight.FillColor = Value
            end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then
                    label.TextColor3 = Value
                end
            end
        end
    end
})

ESPItemsGroup:AddToggle("ClosetESP", {
    Text = "Closet ESP enabled",
    Default = Settings.ClosetESP,
    Callback = function(Value)
        Settings.ClosetESP = Value
        if Value then
            -- Apply ESP to all existing closets
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    for _, descendant in pairs(room:GetDescendants()) do
                        if (descendant.Name == "Wardrobe" or descendant.Name:find("Closet")) and not descendant:FindFirstChild("ESPBillboard") then
                            ApplyItemESP(descendant, "🚪 CLOSET", Settings.ClosetESPColor, "Closets")
                        end
                    end
                end)
            end
        else
            -- Clear all closet ESP
            for _, espData in pairs(ESPObjects.Closets) do
                if espData.highlight and espData.highlight.Parent then espData.highlight:Destroy() end
                if espData.billboard and espData.billboard.Parent then espData.billboard:Destroy() end
            end
            ESPObjects.Closets = {}
        end
    end
}):AddColorPicker("ClosetESPColor", {
    Default = Settings.ClosetESPColor,
    Title = "Closet ESP Color",
    Callback = function(Value)
        Settings.ClosetESPColor = Value
        for _, espData in pairs(ESPObjects.Closets) do
            if espData.highlight and espData.highlight.Parent then espData.highlight.FillColor = Value end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = Value end
            end
        end
    end
})

ESPItemsGroup:AddToggle("ItemESP", {
    Text = "Item ESP enabled",
    Default = Settings.ItemESP,
    Callback = function(Value)
        Settings.ItemESP = Value
        if Value then
            -- Apply ESP to all existing items
            local itemNames = {"Lighter", "Flashlight", "Lockpick", "Vitamins", "Crucifix", "Candle", "Battery", "ElectricalRoomKey", "SkeletonKey"}
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    for _, descendant in pairs(room:GetDescendants()) do
                        for _, itemName in pairs(itemNames) do
                            if descendant.Name == itemName and not descendant:FindFirstChild("ESPBillboard") then
                                ApplyItemESP(descendant, "📦 " .. itemName:upper(), Settings.ItemESPColor, "Items")
                            end
                        end
                    end
                end)
            end
        else
            -- Clear all item ESP
            for _, espData in pairs(ESPObjects.Items) do
                if espData.highlight and espData.highlight.Parent then espData.highlight:Destroy() end
                if espData.billboard and espData.billboard.Parent then espData.billboard:Destroy() end
            end
            ESPObjects.Items = {}
        end
    end
}):AddColorPicker("ItemESPColor", {
    Default = Settings.ItemESPColor,
    Title = "Item ESP Color",
    Callback = function(Value)
        Settings.ItemESPColor = Value
        for _, espData in pairs(ESPObjects.Items) do
            if espData.highlight and espData.highlight.Parent then espData.highlight.FillColor = Value end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = Value end
            end
        end
    end
})

ESPItemsGroup:AddToggle("ObjectiveESP", {
    Text = "Objective ESP enabled",
    Default = Settings.ObjectiveESP,
    Callback = function(Value)
        Settings.ObjectiveESP = Value
        if Value then
            -- Apply ESP to all existing objectives
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    for _, descendant in pairs(room:GetDescendants()) do
                        if (descendant.Name == "LeverForGate" or descendant.Name:find("Lever") or descendant.Name:find("Valve") or descendant.Name == "MinesAnchor") and not descendant:FindFirstChild("ESPBillboard") then
                            local objName = descendant.Name:find("Lever") and "⚡ LEVER" or (descendant.Name:find("Valve") and "🔧 VALVE" or "🎯 OBJECTIVE")
                            ApplyItemESP(descendant, objName, Settings.ObjectiveESPColor, "Objectives")
                        end
                    end
                end)
            end
        else
            -- Clear all objective ESP
            for _, espData in pairs(ESPObjects.Objectives) do
                if espData.highlight and espData.highlight.Parent then espData.highlight:Destroy() end
                if espData.billboard and espData.billboard.Parent then espData.billboard:Destroy() end
            end
            ESPObjects.Objectives = {}
        end
    end
}):AddColorPicker("ObjectiveESPColor", {
    Default = Settings.ObjectiveESPColor,
    Title = "Objective ESP Color",
    Callback = function(Value)
        Settings.ObjectiveESPColor = Value
        for _, espData in pairs(ESPObjects.Objectives) do
            if espData.highlight and espData.highlight.Parent then espData.highlight.FillColor = Value end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = Value end
            end
        end
    end
})

ESPItemsGroup:AddToggle("GoldESP", {
    Text = "Gold ESP enabled",
    Default = Settings.GoldESP,
    Callback = function(Value)
        Settings.GoldESP = Value
        if Value then
            -- Apply ESP to all existing gold
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    for _, descendant in pairs(room:GetDescendants()) do
                        if (descendant.Name == "GoldPile" or descendant.Name:find("Gold")) and not descendant:FindFirstChild("ESPBillboard") then
                            ApplyItemESP(descendant, "💰 GOLD", Settings.GoldESPColor, "Gold")
                        end
                    end
                end)
            end
        else
            -- Clear all gold ESP
            for _, espData in pairs(ESPObjects.Gold) do
                if espData.highlight and espData.highlight.Parent then espData.highlight:Destroy() end
                if espData.billboard and espData.billboard.Parent then espData.billboard:Destroy() end
            end
            ESPObjects.Gold = {}
        end
    end
}):AddColorPicker("GoldESPColor", {
    Default = Settings.GoldESPColor,
    Title = "Gold ESP Color",
    Callback = function(Value)
        Settings.GoldESPColor = Value
        for _, espData in pairs(ESPObjects.Gold) do
            if espData.highlight and espData.highlight.Parent then espData.highlight.FillColor = Value end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then label.TextColor3 = Value end
            end
        end
    end
})

ESPItemsGroup:AddToggle("KeyESP", {
    Text = "Key ESP enabled",
    Default = Settings.KeyESP,
    Callback = function(Value)
        Settings.KeyESP = Value
        if Value then
            -- Apply ESP to all existing keys when toggled ON
            for _, room in pairs(CurrentRooms:GetChildren()) do
                task.spawn(function()
                    for _, descendant in pairs(room:GetDescendants()) do
                        if descendant.Name == "KeyObtain" and not descendant:FindFirstChild("ESPBillboard") then
                            ApplyKeyESP(descendant)
                        end
                    end
                end)
            end
        else
            -- Clear all key ESP when toggled OFF
            for _, espData in pairs(ESPObjects.Keys) do
                if espData.highlight and espData.highlight.Parent then
                    espData.highlight:Destroy()
                end
                if espData.billboard and espData.billboard.Parent then
                    espData.billboard:Destroy()
                end
            end
            ESPObjects.Keys = {}
        end
    end
}):AddColorPicker("KeyESPColor", {
    Default = Settings.KeyESPColor,
    Title = "Key ESP Color",
    Callback = function(Value)
        Settings.KeyESPColor = Value
        -- Update all existing key ESP colors
        for _, espData in pairs(ESPObjects.Keys) do
            if espData.highlight and espData.highlight.Parent then
                espData.highlight.FillColor = Value
            end
            if espData.billboard and espData.billboard.Parent then
                local label = espData.billboard:FindFirstChild("ESPLabel")
                if label then
                    label.TextColor3 = Value
                end
            end
        end
    end
})

-- ============================================
-- PLAYER TAB
-- ============================================

local MovementGroup = Tabs.Player:AddLeftGroupbox("Movement", "move")

MovementGroup:AddSlider("NoclipBypassSpeed", {
    Text = "Noclip Bypass Speed",
    Default = Settings.NoclipBypassSpeed,
    Min = 0,
    Max = 6,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.NoclipBypassSpeed = Value
    end
})

MovementGroup:AddToggle("SpeedBoost", {
    Text = "Speed Boost Enabled",
    Default = Settings.SpeedBoost,
    Callback = function(Value)
        Settings.SpeedBoost = Value
    end
})

MovementGroup:AddToggle("SpeedBypass", {
    Text = "Speed Bypass",
    Default = Settings.SpeedBypass,
    Callback = function(Value)
        Settings.SpeedBypass = Value
    end
})

MovementGroup:AddToggle("NoAcceleration", {
    Text = "No Acceleration",
    Default = Settings.NoAcceleration,
    Callback = function(Value)
        Settings.NoAcceleration = Value
    end
})

MovementGroup:AddDivider()

MovementGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = Settings.Fly,
    Callback = function(Value)
        Settings.Fly = Value
    end
})

MovementGroup:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = Settings.FlySpeed,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.FlySpeed = Value
    end
})

MovementGroup:AddDivider()

MovementGroup:AddToggle("TeleportEnabled", {
    Text = "teleport",
    Default = Settings.TeleportEnabled,
    Callback = function(Value)
        Settings.TeleportEnabled = Value
    end
})

MovementGroup:AddSlider("TeleportDistance", {
    Text = "teleport distance",
    Default = Settings.TeleportDistance,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.TeleportDistance = Value
    end
})

local CharacterGroup = Tabs.Player:AddRightGroupbox("Character", "user-check")

CharacterGroup:AddToggle("Noclip", {
    Text = "NoClip",
    Default = Settings.Noclip,
    Callback = function(Value)
        Settings.Noclip = Value
    end
})

CharacterGroup:AddToggle("EnableJump", {
    Text = "Enable jump",
    Default = Settings.EnableJump,
    Callback = function(Value)
        Settings.EnableJump = Value
    end
})

CharacterGroup:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = Settings.InfiniteJump,
    Callback = function(Value)
        Settings.InfiniteJump = Value
    end
})

CharacterGroup:AddToggle("ClosetExitFix", {
    Text = "Closet exit Fix",
    Default = Settings.ClosetExitFix,
    Callback = function(Value)
        Settings.ClosetExitFix = Value
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================

local CameraGroup = Tabs.Visuals:AddLeftGroupbox("Camera", "camera")

CameraGroup:AddSlider("FOV", {
    Text = "FOV",
    Default = Settings.FOV,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.FOV = Value
        workspace.CurrentCamera.FieldOfView = Value
    end
})

CameraGroup:AddToggle("NoCameraShaking", {
    Text = "No camera shaking",
    Default = Settings.NoCameraShaking,
    Callback = function(Value)
        Settings.NoCameraShaking = Value
    end
})

CameraGroup:AddToggle("Freecam", {
    Text = "Freecam",
    Default = Settings.Freecam,
    Callback = function(Value)
        Settings.Freecam = Value
    end
})

CameraGroup:AddDivider()

CameraGroup:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = Settings.ThirdPerson,
    Callback = function(Value)
        Settings.ThirdPerson = Value
    end
})

CameraGroup:AddSlider("ThirdOffset", {
    Text = "Third Offset",
    Default = Settings.ThirdOffset,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.ThirdOffset = Value
    end
})

CameraGroup:AddSlider("ThirdHeight", {
    Text = "Third Height",
    Default = Settings.ThirdHeight,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.ThirdHeight = Value
    end
})

CameraGroup:AddSlider("ThirdDistance", {
    Text = "Third Distance",
    Default = Settings.ThirdDistance,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.ThirdDistance = Value
    end
})

CameraGroup:AddSlider("ThirdSensitivity", {
    Text = "Third Sensitivity",
    Default = Settings.ThirdSensitivity,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.ThirdSensitivity = Value
    end
})

local LightingGroup = Tabs.Visuals:AddRightGroupbox("Lighting", "sun")

LightingGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = Settings.Fullbright,
    Callback = function(Value)
        Settings.Fullbright = Value
        local Lighting = game:GetService("Lighting")
        if Value then
            Lighting.Brightness = Settings.Brightness
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
        else
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.FogEnd = 500
        end
    end
})

LightingGroup:AddSlider("Brightness", {
    Text = "Brightness",
    Default = Settings.Brightness,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        Settings.Brightness = Value
        if Settings.Fullbright then
            game:GetService("Lighting").Brightness = Value
        end
    end
})

-- ============================================
-- UI SETTINGS TAB
-- ============================================

local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu", "settings")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- Setup theme and save managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})

ThemeManager:SetFolder("vesper")
SaveManager:SetFolder("vesper/DOORS")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- Notification on load
Library:Notify({
    Title = "vesper.lua loaded!",
    Description = "DOORS script ready | Press RightShift to toggle menu",
    Time = 5
})

-- GUI is already initialized by Obsidian library above
warn("vesper.lua loaded! Press RightShift to toggle menu")

-- Track opened doors
local openedDoors = {}

-- ESP Tracking Tables (for live color updates)
local ESPObjects = {
    Doors = {},
    Keys = {},
    Closets = {},
    Items = {},
    Objectives = {},
    Gold = {},
    Entities = {},
    Players = {}
}

-- Helper function to create highlights
local function CreateHighlight(part, fillColor, outlineColor, fillTrans, outlineTrans, espType)
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
    highlight.Name = "ESP_" .. (espType or "Generic")
    
    -- Track this highlight for live color updates
    if espType and ESPObjects[espType] then
        table.insert(ESPObjects[espType], {highlight = highlight, billboard = nil, parent = part})
    end
    
    return highlight
end

-- Helper function to create billboards
local function CreateBillboard(parent, text, textColor, yOffset, espType)
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
    label.Name = "ESPLabel"
    
    -- Track this billboard for live color updates
    if espType and ESPObjects[espType] then
        for _, entry in pairs(ESPObjects[espType]) do
            if entry.parent == parent and not entry.billboard then
                entry.billboard = billboard
                break
            end
        end
    end
    
    return billboard
end

-- Door ESP Function
local function ApplyDoorESP(room)
    local roomNumber = tonumber(room.Name)
    if not roomNumber then return end
    
    if not Settings.DoorESP then return end
    
    local door = room:WaitForChild("Door", 2)
    if not door then return end
    
    -- Skip if door is already opened
    if openedDoors[door] then return end
    
    -- Skip if already has ESP
    if door:FindFirstChild("ESPBillboard") then return end
    
    -- Check if locked by looking for KeyObtain in the room
    local key = room:FindFirstChild("KeyObtain", true)
    local isLocked = (key ~= nil)
    
    -- Colors
    local outlineColor = isLocked and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
    
    -- Apply highlight to the door MeshPart (Door.Door)
    local doorPart = door:FindFirstChild("Door")
    if doorPart then
        if doorPart:IsA("MeshPart") or (doorPart:IsA("BasePart") and doorPart.Transparency < 1) then
            CreateHighlight(doorPart, Settings.DoorESPColor or Color3.fromRGB(255, 255, 0), outlineColor, 0.4, 0, "Doors")
        end
    end
    
    -- Create billboard (add +1 to match in-game door numbers)
    local displayNumber = roomNumber + 1
    local text = string.format("DOOR %d\n%s", displayNumber, isLocked and "🔒 LOCKED" or "✓ OPEN")
    local textColor = Settings.DoorESPColor or Color3.fromRGB(255, 255, 0)
    CreateBillboard(door, text, textColor, 5, "Doors")
    
    -- Instant unlock proximity prompts and monitor for door opening
    for _, descendant in pairs(door:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            if Settings.InstantInteract then
                descendant.HoldDuration = 0
            end
            if Settings.DoorReach then
                descendant.MaxActivationDistance = 20
            end
            
            -- Monitor door opening via Triggered event
            descendant.Triggered:Connect(function()
                openedDoors[door] = true
                -- Clear ESP
                for _, child in pairs(door:GetDescendants()) do
                    if child:IsA("Highlight") or child.Name == "ESPBillboard" then
                        child:Destroy()
                    end
                end
                -- Remove from tracking
                for i, espData in ipairs(ESPObjects.Doors) do
                    if espData.parent == doorPart or espData.parent == door then
                        table.remove(ESPObjects.Doors, i)
                        break
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
    
    -- Skip if already has ESP
    if key:FindFirstChild("ESPBillboard") then return end
    
    -- Apply highlight to the key model
    for _, part in pairs(key:GetDescendants()) do
        if part:IsA("BasePart") then
            CreateHighlight(part, Settings.KeyESPColor or Color3.fromRGB(255, 255, 0), Color3.fromRGB(200, 200, 0), 0.3, 0, "Keys")
        end
    end
    
    -- Create billboard
    CreateBillboard(key, "🔑 KEY", Settings.KeyESPColor or Color3.fromRGB(255, 255, 0), 3, "Keys")
    
    -- Monitor for key collection (when destroyed or parented to player)
    key.AncestryChanged:Connect(function()
        if not key:IsDescendantOf(game.Workspace) then
            -- Remove from tracking when collected
            for i, espData in ipairs(ESPObjects.Keys) do
                if espData.parent == key or (espData.parent and espData.parent:IsDescendantOf(key)) then
                    table.remove(ESPObjects.Keys, i)
                    break
                end
            end
            warn("Key collected - ESP cleared")
        end
    end)
    
    warn("Key ESP applied!")
end

-- Item ESP Function (updated with tracking and proper ESP type detection)
local function ApplyItemESP(item, itemName, color, espType)
    -- Skip if already has ESP
    if item:FindFirstChild("ESPBillboard") then return end
    
    -- Determine ESP type based on item name if not provided
    if not espType then
        if itemName:find("KEY") or itemName:find("🔑") then
            espType = "Keys"
        elseif itemName:find("DOOR") then
            espType = "Doors"
        elseif itemName:find("CLOSET") or itemName:find("Wardrobe") then
            espType = "Closets"
        elseif itemName:find("LEVER") or itemName:find("VALVE") or itemName:find("PANEL") or itemName:find("BREAKER") then
            espType = "Objectives"
        elseif itemName:find("COIN") or itemName:find("GOLD") or itemName:find("💰") then
            espType = "Gold"
        else
            espType = "Items"
        end
    end
    
    -- Check if this ESP type is enabled
    local isEnabled = false
    if espType == "Keys" and Settings.KeyESP then isEnabled = true
    elseif espType == "Doors" and Settings.DoorESP then isEnabled = true
    elseif espType == "Closets" and Settings.ClosetESP then isEnabled = true
    elseif espType == "Objectives" and Settings.ObjectiveESP then isEnabled = true
    elseif espType == "Gold" and Settings.GoldESP then isEnabled = true
    elseif espType == "Items" and Settings.ItemESP then isEnabled = true
    end
    
    if not isEnabled then return end
    
    -- Apply highlight
    if item:IsA("Model") then
        for _, part in pairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                CreateHighlight(part, color, Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8), 0.3, 0, espType)
            end
        end
    elseif item:IsA("BasePart") then
        CreateHighlight(item, color, Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8), 0.3, 0, espType)
    end
    
    -- Create billboard
    CreateBillboard(item, itemName, color, 3, espType)
    
    -- Monitor for item collection/destruction
    item.AncestryChanged:Connect(function()
        if not item:IsDescendantOf(game.Workspace) then
            for i, espData in ipairs(ESPObjects[espType] or {}) do
                if espData.parent == item or (espData.parent and espData.parent:IsDescendantOf(item)) then
                    table.remove(ESPObjects[espType], i)
                    break
                end
            end
        end
    end)
    
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
    if Settings.AutoLibraryCode then
        SolveLibrary(room)
    end
    
    -- Monitor for items in this room
    room.DescendantAdded:Connect(function(descendant)
        -- Key detection
        if descendant.Name == "KeyObtain" then
            ApplyKeyESP(descendant)
            warn(string.format("Key spawned in room %s", room.Name))
        end
        
        -- Closet detection
        if (descendant.Name == "Wardrobe" or descendant.Name:find("Closet")) and Settings.ClosetESP then
            ApplyItemESP(descendant, "🚪 CLOSET", Settings.ClosetESPColor, "Closets")
        end
        
        -- Item detection
        local itemNames = {"Lighter", "Flashlight", "Lockpick", "Vitamins", "Crucifix", "Candle", "Battery", "ElectricalRoomKey", "SkeletonKey"}
        for _, itemName in pairs(itemNames) do
            if descendant.Name == itemName and Settings.ItemESP then
                ApplyItemESP(descendant, "📦 " .. itemName:upper(), Settings.ItemESPColor, "Items")
            end
        end
        
        -- Objective detection (Levers, Valves, etc)
        if (descendant.Name == "LeverForGate" or descendant.Name:find("Lever") or descendant.Name:find("Valve") or descendant.Name == "MinesAnchor") and Settings.ObjectiveESP then
            local objName = descendant.Name:find("Lever") and "⚡ LEVER" or (descendant.Name:find("Valve") and "🔧 VALVE" or "🎯 OBJECTIVE")
            ApplyItemESP(descendant, objName, Settings.ObjectiveESPColor, "Objectives")
        end
        
        -- Gold detection
        if (descendant.Name == "GoldPile" or descendant.Name:find("Gold")) and Settings.GoldESP then
            ApplyItemESP(descendant, "💰 GOLD", Settings.GoldESPColor, "Gold")
        end
    end)
end)

-- Function to scan room for items
local function ScanRoomForItems(room)
    for _, descendant in pairs(room:GetDescendants()) do
        -- Key detection
        if descendant.Name == "KeyObtain" and Settings.KeyESP then
            ApplyKeyESP(descendant)
        end
        
        -- Closet detection
        if (descendant.Name == "Wardrobe" or descendant.Name:find("Closet")) and Settings.ClosetESP then
            ApplyItemESP(descendant, "🚪 CLOSET", Settings.ClosetESPColor, "Closets")
        end
        
        -- Item detection
        local itemNames = {"Lighter", "Flashlight", "Lockpick", "Vitamins", "Crucifix", "Candle", "Battery", "ElectricalRoomKey", "SkeletonKey"}
        for _, itemName in pairs(itemNames) do
            if descendant.Name == itemName and Settings.ItemESP then
                ApplyItemESP(descendant, "📦 " .. itemName:upper(), Settings.ItemESPColor, "Items")
            end
        end
        
        -- Objective detection
        if (descendant.Name == "LeverForGate" or descendant.Name:find("Lever") or descendant.Name:find("Valve") or descendant.Name == "MinesAnchor") and Settings.ObjectiveESP then
            local objName = descendant.Name:find("Lever") and "⚡ LEVER" or (descendant.Name:find("Valve") and "🔧 VALVE" or "🎯 OBJECTIVE")
            ApplyItemESP(descendant, objName, Settings.ObjectiveESPColor, "Objectives")
        end
        
        -- Gold detection
        if (descendant.Name == "GoldPile" or descendant.Name:find("Gold")) and Settings.GoldESP then
            ApplyItemESP(descendant, "💰 GOLD", Settings.GoldESPColor, "Gold")
        end
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
        if Settings.KeyESP then
            for _, room in pairs(CurrentRooms:GetChildren()) do
                local hasKey = room:FindFirstChild("KeyObtain", true)
                if hasKey and not hasKey:FindFirstChild("ESPBillboard") then
                    warn(string.format("Found unhighlighted key in room %s, applying ESP", room.Name))
                    ApplyKeyESP(hasKey)
                end
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
    WarningFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    WarningFrame.BackgroundTransparency = 0
    WarningFrame.BorderSizePixel = 0
    WarningFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    WarningFrame.Size = UDim2.new(0, 400, 0, 80)
    WarningFrame.Visible = false
    WarningFrame.Parent = NotificationGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = WarningFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 50, 50)
    UIStroke.Thickness = 3
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = WarningFrame

    local WarningText = Instance.new("TextLabel")
    WarningText.Name = "WarningText"
    WarningText.BackgroundTransparency = 1
    WarningText.Position = UDim2.new(0, 0, 0, 5)
    WarningText.Size = UDim2.new(1, 0, 0, 30)
    WarningText.Font = Enum.Font.GothamBold
    WarningText.TextColor3 = Color3.fromRGB(255, 80, 80)
    WarningText.TextSize = 20
    WarningText.Text = "⚠️ ENTITY DETECTED ⚠️"
    WarningText.Parent = WarningFrame

    local EntityName = Instance.new("TextLabel")
    EntityName.Name = "EntityName"
    EntityName.BackgroundTransparency = 1
    EntityName.Position = UDim2.new(0, 0, 0, 35)
    EntityName.Size = UDim2.new(1, 0, 0, 40)
    EntityName.Font = Enum.Font.GothamBold
    EntityName.TextColor3 = Color3.fromRGB(255, 255, 255)
    EntityName.TextSize = 24
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
                if Settings.EntityNotify then
                    showEntityWarning("RUSH - HIDE IMMEDIATELY!", 5)
                end
                warn("⚠️ RUSH SPAWNED!")
                RushModel:SetAttribute("ESPAdded", true)
                
                if not Settings.EntityESP then return end
                
                local highlight = Instance.new("Highlight")
                highlight:SetAttribute("RushESP", true)
                highlight.Adornee = RushModel
                highlight.FillColor = rushColor
                highlight.OutlineColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = RushModel
                
                local billboard = Instance.new("BillboardGui")
                billboard:SetAttribute("RushESP", true)
                billboard.Adornee = RushModel
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = RushModel
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = rushColor
                textLabel.TextStrokeTransparency = 0.2
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard
                
                while RushModel and RushModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local rushPos = RushModel:GetPivot().Position
                            local distance = (playerPos - rushPos).Magnitude
                            textLabel.Text = "⚠️ RUSH - " .. math.floor(distance) .. " studs ⚠️"
                        end
                    end)
                    task.wait(0.1)
                end
                
                -- Clean up when Rush despawns
                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
                warn("Rush despawned - ESP cleaned up")
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForRush)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "RushMoving" and Settings.EntityNotify then
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
                if Settings.EntityNotify then
                    showEntityWarning("AMBUSH - HIDE AND STAY!", 5)
                end
                warn("⚠️ AMBUSH SPAWNED!")
                AmbushModel:SetAttribute("ESPAdded", true)
                
                if not Settings.EntityESP then return end
                
                local highlight = Instance.new("Highlight")
                highlight:SetAttribute("AmbushESP", true)
                highlight.Adornee = AmbushModel
                highlight.FillColor = ambushColor
                highlight.OutlineColor = Color3.new(1, 0.5, 0)
                highlight.FillTransparency = 0
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = AmbushModel
                
                local billboard = Instance.new("BillboardGui")
                billboard:SetAttribute("AmbushESP", true)
                billboard.Adornee = AmbushModel
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = AmbushModel
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = ambushColor
                textLabel.TextStrokeTransparency = 0.2
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard
                
                while AmbushModel and AmbushModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local ambushPos = AmbushModel:GetPivot().Position
                            local distance = (playerPos - ambushPos).Magnitude
                            textLabel.Text = "⚠️ AMBUSH - " .. math.floor(distance) .. " studs ⚠️"
                        end
                    end)
                    task.wait(0.1)
                end
                
                -- Clean up when Ambush despawns
                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
                warn("Ambush despawned - ESP cleaned up")
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForAmbush)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "AmbushMoving" and Settings.EntityNotify then
            showEntityWarning("AMBUSH INCOMING!", 5)
        end
    end)
end

-- Eyes detection and ESP (without notification since anti-eyes is active)
local function setupEyesDetection()
    local function checkForEyes()
        local EyesModel = Workspace:FindFirstChild("Eyes")
        if EyesModel and not EyesModel:GetAttribute("ESPAdded") then
            local eyesColor = Color3.fromRGB(255, 255, 0)
            task.spawn(function()
                warn("👁️ EYES SPAWNED (Damage disabled)")
                EyesModel:SetAttribute("ESPAdded", true)
                
                if not Settings.EntityESP then return end
                
                local highlight = Instance.new("Highlight")
                highlight:SetAttribute("EyesESP", true)
                highlight.Adornee = EyesModel
                highlight.FillColor = eyesColor
                highlight.OutlineColor = Color3.new(1, 1, 0)
                highlight.FillTransparency = 0
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = EyesModel
                
                local billboard = Instance.new("BillboardGui")
                billboard:SetAttribute("EyesESP", true)
                billboard.Adornee = EyesModel
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = EyesModel
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = eyesColor
                textLabel.TextStrokeTransparency = 0.2
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard
                
                while EyesModel and EyesModel.Parent do
                    pcall(function()
                        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                        if playerPos then
                            local eyesPos = EyesModel:GetPivot().Position
                            local distance = (playerPos - eyesPos).Magnitude
                            textLabel.Text = "👁️ EYES - " .. math.floor(distance) .. " studs (Safe)"
                        end
                    end)
                    task.wait(0.1)
                end
                
                -- Clean up when Eyes despawns
                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
                warn("Eyes despawned - ESP cleaned up")
            end)
        end
    end
    
    RunService.Heartbeat:Connect(checkForEyes)
    
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Eyes" and Settings.EntityNotify then
            showEntityWarning("EYES SPAWNED!", 5)
        end
    end)
end

-- Screech detection and deletion
local function setupScreechProtection()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Entities = ReplicatedStorage:WaitForChild("Entities")
    
    local function deleteScreech()
        if not Settings.ScreechProtection then return end
        local Screech = Entities:FindFirstChild("Screech")
        if Screech then
            Screech:Destroy()
            warn("Screech deleted - You're safe!")
            if Settings.EntityNotify then
                showEntityWarning("SCREECH BLOCKED", 3)
            end
        end
    end
    
    task.spawn(function() deleteScreech() end)
    
    Entities.ChildAdded:Connect(function(child)
        if child.Name == "Screech" and Settings.ScreechProtection then
            child:Destroy()
            warn("Screech blocked!")
            if Settings.EntityNotify then
                showEntityWarning("SCREECH BLOCKED", 3)
            end
        end
    end)
end

-- Predictive entity warning system
local function setupPredictiveWarnings()
    -- Monitor for flickering lights (Rush/Ambush warning)
    local function monitorLights()
        for _, room in pairs(CurrentRooms:GetChildren()) do
            local assets = room:FindFirstChild("Assets")
            if assets then
                -- Monitor light fixtures for flicker
                for _, descendant in pairs(assets:GetDescendants()) do
                    if descendant:IsA("Light") or descendant:IsA("PointLight") or descendant:IsA("SpotLight") then
                        descendant:GetPropertyChangedSignal("Enabled"):Connect(function()
                            if not descendant.Enabled then
                                showEntityWarning("⚡ LIGHTS FLICKERING - ENTITY APPROACHING!", 4)
                                warn("⚡ Light flicker detected - Entity incoming!")
                            end
                        end)
                    end
                end
            end
        end
    end
    
    -- Monitor new rooms for lights
    CurrentRooms.ChildAdded:Connect(function(room)
        task.wait(0.5)
        local assets = room:FindFirstChild("Assets")
        if assets then
            for _, descendant in pairs(assets:GetDescendants()) do
                if descendant:IsA("Light") or descendant:IsA("PointLight") or descendant:IsA("SpotLight") then
                    descendant:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if not descendant.Enabled then
                            showEntityWarning("⚡ LIGHTS FLICKERING - ENTITY APPROACHING!", 4)
                            warn("⚡ Light flicker detected - Entity incoming!")
                        end
                    end)
                end
            end
        end
    end)
    
    -- Monitor for RemoteEvents that might signal entity spawns
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    if ReplicatedStorage:FindFirstChild("RemotesFolder") then
        for _, remote in pairs(ReplicatedStorage.RemotesFolder:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function(...)
                    local args = {...}
                    -- Log RemoteEvent calls for debugging
                    pcall(function()
                        if typeof(args[1]) == "string" then
                            if args[1]:lower():find("rush") or args[1]:lower():find("ambush") then
                                warn("RemoteEvent detected:", remote.Name, unpack(args))
                            end
                        end
                    end)
                end)
            end
        end
    end
    
    monitorLights()
    warn("Predictive warnings enabled - monitoring lights and RemoteEvents!")
end

-- Global Proximity Prompt Monitoring
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        task.wait(0.1) -- Let it initialize
        if Settings.InstantInteract then
            descendant.HoldDuration = 0
        end
        -- Check if it's a door prompt for door reach
        local isDoor = descendant:FindFirstAncestorOfClass("Model") and descendant:FindFirstAncestorOfClass("Model").Name == "Door"
        if isDoor and Settings.DoorReach then
            descendant.MaxActivationDistance = 20
        end
    end
end)

-- Break Void Loop
RunService.Heartbeat:Connect(function()
    if Settings.BreakVoid and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < -200 then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 400, 0)
            warn("Prevented void fall!")
        end
    end
end)

-- Lever/Valve Aura System
RunService.Heartbeat:Connect(function()
    if not Settings.LeverValveAura or not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, room in pairs(CurrentRooms:GetChildren()) do
        for _, descendant in pairs(room:GetDescendants()) do
            if (descendant.Name:find("Lever") or descendant.Name:find("Valve")) and descendant:FindFirstChildOfClass("ProximityPrompt") then
                local distance = (hrp.Position - descendant:GetPivot().Position).Magnitude
                if distance <= 15 then
                    local prompt = descendant:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and fireproximityprompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

-- Loot Aura System
RunService.Heartbeat:Connect(function()
    if not Settings.LootAura or not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, room in pairs(CurrentRooms:GetChildren()) do
        for _, descendant in pairs(room:GetDescendants()) do
            if (descendant.Name == "DrawerContainer" or descendant.Name:find("Drawer") or descendant.Name == "ChestBox") and descendant:FindFirstChildOfClass("ProximityPrompt") then
                local distance = (hrp.Position - descendant:GetPivot().Position).Magnitude
                if distance <= 12 then
                    local prompt = descendant:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and fireproximityprompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

-- Auto Collect Books System
RunService.Heartbeat:Connect(function()
    if not Settings.AutoCollectBooks or not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, room in pairs(CurrentRooms:GetChildren()) do
        local assets = room:FindFirstChild("Assets")
        if assets then
            local shelf = assets:FindFirstChild("Shelf")
            if shelf then
                for _, obj in pairs(shelf:GetDescendants()) do
                    if obj.Name == "Book" and obj:FindFirstChild("ClickDetector") then
                        local distance = (hrp.Position - obj.Position).Magnitude
                        if distance <= 15 and fireclickdetector then
                            pcall(function()
                                fireclickdetector(obj.ClickDetector)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Locked Door Aura System
RunService.Heartbeat:Connect(function()
    if not Settings.LockedDoorAura or not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, room in pairs(CurrentRooms:GetChildren()) do
        local door = room:FindFirstChild("Door")
        if door then
            local lock = door:FindFirstChild("Lock")
            if lock then
                local prompt = lock:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    local distance = (hrp.Position - lock:GetPivot().Position).Magnitude
                    if distance <= 15 and fireproximityprompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

warn("Global systems initialized: Proximity monitoring, Break Void, Auras")

-- Initialize entity detection (always setup, but checks Settings dynamically)
setupRushDetection()
setupAmbushDetection()
setupEyesDetection()
setupScreechProtection()
setupPredictiveWarnings()
warn("Entity detection system initialized!")

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
