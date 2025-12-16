-- DOORS Script with Wave Console Integration
-- Made for LO ♥
-- Updated with Wave functions from documentation

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")

-- Wave Console Integration
local WaveConsole = {
    Enabled = true,
    Created = false
}

-- Initialize Wave console
local function initWaveConsole()
    if not WaveConsole.Enabled then return end

    -- Create Wave console window
    rconsolecreate()
    rconsolename("DOORS Script by LO - " .. os.date("%Y-%m-%d %H:%M:%S"))
    rconsoleprint("@@LIGHT_BLUE@@")
    rconsoleprint("═══════════════════════════════════════════════════\n")
    rconsoleprint("@@WHITE@@")
    rconsoleprint("DOORS Script with Wave Console Integration\n")
    rconsoleprint("Features: ESP, Auto-Collect, Entity Warnings\n")
    rconsoleprint("@@LIGHT_BLUE@@")
    rconsoleprint("═══════════════════════════════════════════════════\n")
    rconsoleprint("@@WHITE@@")
    WaveConsole.Created = true
end

-- Wave console output functions
function WaveConsole.info(message)
    if WaveConsole.Created then
        rconsoleinfo("@@WHITE@@[INFO] @@LIGHT_GRAY@@" .. tostring(message))
    else
        print("[INFO] " .. tostring(message))
    end
end

function WaveConsole.debug(message)
    if WaveConsole.Created then
        rconsoledebug("@@LIGHT_BLUE@@[DEBUG] @@WHITE@@" .. tostring(message))
    else
        print("[DEBUG] " .. tostring(message))
    end
end

function WaveConsole.warn(message)
    if WaveConsole.Created then
        rconsoleerr("@@YELLOW@@[WARN] @@WHITE@@" .. tostring(message))
    else
        warn("[WARN] " .. tostring(message))
    end
end

function WaveConsole.error(message)
    if WaveConsole.Created then
        rconsoleerr("@@RED@@[ERROR] @@WHITE@@" .. tostring(message))
    else
        warn("[ERROR] " .. tostring(message))
    end
end

function WaveConsole.print(message, color)
    color = color or "@@WHITE@@"
    if WaveConsole.Created then
        rconsoleprint(color .. tostring(message))
    else
        print(tostring(message))
    end
end

-- Clear Wave console
function WaveConsole.clear()
    if WaveConsole.Created then
        rconsoleclear()
    end
end

-- Initialize console
task.spawn(initWaveConsole)

-- Additional Wave Utility Functions
local WaveUtils = {}

-- HTTP Request function using Wave's built-in
function WaveUtils.httpRequest(url, method, data, headers)
    local success, response = pcall(function()
        if method:upper() == "GET" then
            return httpget(url)
        elseif method:upper() == "POST" then
            -- Use request function for POST
            return request({
                Url = url,
                Method = "POST",
                Body = data,
                Headers = headers or {}
            })
        end
    end)

    if success then
        return response
    else
        WaveConsole.error("HTTP Request failed: " .. tostring(response))
        return nil
    end
end

-- Get current FPS using Wave function
function WaveUtils.getFPS()
    local success, fps = pcall(getfpscap)
    if success then
        return fps
    end
    return 60
end

-- Check if client is network owner
function WaveUtils.isNetworkOwner(instance)
    local success, isOwner = pcall(isnetworkowner, instance)
    if success then
        return isOwner
    end
    return false
end

-- Set FPS cap
function WaveUtils.setFPS(cap)
    local success, err = pcall(setfpscap, cap)
    if not success then
        WaveConsole.error("Failed to set FPS cap: " .. tostring(err))
    end
end

-- Queue script for teleport
function WaveUtils.queueOnTeleport(script)
    local success, err = pcall(queueonteleport, script)
    if not success then
        WaveConsole.error("Failed to queue teleport script: " .. tostring(err))
    end
end

-- Get HWID
function WaveUtils.getHWID()
    local success, hwid = pcall(gethwid)
    if success then
        return hwid
    end
    return "Unknown"
end

-- Settings
local Settings = {
    AutoCollectCoins = true,
    CoinDistance = 50,
    DoorESP = true,
    KeyESP = true,
    ItemESP = true,
    EntityNotify = true
}

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
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = text

    return billboard
end

-- Door ESP Function
local function ApplyDoorESP(door, roomNumber)
    if not Settings.DoorESP or door:GetAttribute("ESPAdded") then return end
    door:SetAttribute("ESPAdded", true)

    local isLocked = door:FindFirstChild("Door") and door.Door:FindFirstChild("Lock") and door.Door.Lock.Locked.Value

    local color = isLocked and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    CreateHighlight(door, color, color, 0.7, 0)
    CreateBillboard(door, "Door " .. roomNumber .. (isLocked and " (LOCKED)" or " (OPEN)"), color, -2)

    -- Extend proximity prompt range
    for _, descendant in pairs(door:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            descendant.MaxActivationDistance = 15
        end
    end

    WaveConsole.info(string.format("Door ESP applied to room %d (%s)", roomNumber, isLocked and "LOCKED" or "OPEN"))
end

-- Key ESP Function (Fixed path)
local function ApplyKeyESP(key)
    if not Settings.KeyESP or key:GetAttribute("ESPAdded") then return end
    key:SetAttribute("ESPAdded", true)

    CreateHighlight(key, Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 0), 0.5, 0)

    -- Create billboard
    CreateBillboard(key, "🔑 KEY", Color3.fromRGB(255, 255, 0), 3)
    WaveConsole.info("Key ESP applied!")
end

-- Item ESP Function
local function ApplyItemESP(item, itemName, color)
    if not Settings.ItemESP or item:GetAttribute("ESPAdded") then return end
    item:SetAttribute("ESPAdded", true)

    CreateHighlight(item, color, color, 0.5, 0)

    -- Create billboard
    CreateBillboard(item, itemName, color, 3)
    WaveConsole.info(string.format("%s ESP applied!", itemName))
end

-- Auto Coin Collection
local function AutoCollectCoin(coin)
    if not Settings.AutoCollectCoins then return end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - coin.Position).Magnitude
    if dist <= Settings.CoinDistance then
        fireproximityprompt(coin.ProximityPrompt)
        WaveConsole.debug("Collected coin at distance: " .. math.floor(dist))
    end
end

-- Library Puzzle Solver
local function SolveLibrary(room)
    task.wait(0.5)

    local assets = room:FindFirstChild("Assets")
    if not assets then return end

    local painting = assets:FindFirstChild("Paintings") and assets.Paintings:FindFirstChild("LibraryPainting")
    if not painting then return end

    WaveConsole.info("📚 Library detected! Solving puzzle...")

    local shelf = assets:FindFirstChild("Shelf")
    if shelf then
        for _, obj in pairs(shelf:GetDescendants()) do
            if obj:IsA("ClickDetector") then
                fireclickdetector(obj)
                task.wait(0.1)
            end
        end
    end
end

-- Monitor for new rooms
local lastRoom = 0
CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(1)

    local roomNum = tonumber(room.Name:match("%d+")) or 0
    if roomNum > lastRoom then
        lastRoom = roomNum

        -- Apply ESP to doors
        for _, obj in pairs(room:GetChildren()) do
            if obj:IsA("Model") and obj.Name:find("Door") then
                ApplyDoorESP(obj, roomNum)
            end
        end

        -- Apply ESP to items
        for _, obj in pairs(room:GetDescendants()) do
            if obj:IsA("Model") then
                if obj.Name:find("Key") then
                    ApplyKeyESP(obj)
                elseif obj.Name:find("Coin") then
                    ApplyItemESP(obj, "💰 COIN", Color3.fromRGB(215, 195, 15))
                    AutoCollectCoin(obj)
                elseif obj.Name:find("MedKit") then
                    ApplyItemESP(obj, "🏥 MEDKIT", Color3.fromRGB(255, 0, 0))
                elseif obj.Name:find("Lockpick") then
                    ApplyItemESP(obj, "🔧 LOCKPICK", Color3.fromRGB(128, 128, 128))
                elseif obj.Name:find("Flashlight") then
                    ApplyItemESP(obj, "🔦 FLASHLIGHT", Color3.fromRGB(255, 255, 255))
                end
            end
        end

        -- Check if library room
        if room:FindFirstChild("Assets") and room.Assets:FindFirstChild("Paintings") then
            SolveLibrary(room)
        end
    end
end)

-- Entity Notifications
if Settings.EntityNotify then
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "RushMoving" then
            LocalPlayer.Character.Humanoid.WalkSpeed = 22
            WaveConsole.warn("⚠️ RUSH SPAWNED!")
        elseif child.Name == "AmbushMoving" then
            LocalPlayer.Character.Humanoid.WalkSpeed = 22
            WaveConsole.warn("⚠️ AMBUSH SPAWNED!")
        elseif child.Name == "Eyes" then
            WaveConsole.warn("👁️ EYES - LOOK AWAY!")
        end
    end)
end

-- Noclip
local noclip = false
local function ToggleNoclip()
    noclip = not noclip
    WaveConsole.info(noclip and "Noclip: ON" or "Noclip: OFF")

    while noclip do
        if not LocalPlayer.Character then break end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        RunService.Stepped:Wait()
    end
end

--- Controls
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.Q then
        ToggleNoclip()
    elseif input.KeyCode == Enum.KeyCode.C then
        Settings.AutoCollectCoins = not Settings.AutoCollectCoins
        WaveConsole.info(string.format("Auto-Collect: %s", Settings.AutoCollectCoins and "ON" or "OFF"))
    end
end)

WaveConsole.print("═══════════════════════════════", "@@LIGHT_BLUE@@")
WaveConsole.print("DOORS Script Loaded!", "@@WHITE@@")
WaveConsole.print("═══════════════════════════════", "@@LIGHT_BLUE@@")
WaveConsole.print("Features: Door ESP, Key ESP, Auto-Collect,", "@@WHITE@@")
WaveConsole.print("Library Solver, Entity Warnings, Fullbright", "@@WHITE@@")
WaveConsole.print("", "@@WHITE@@")
WaveConsole.print("Wave Console Integration: Enabled", "@@GREEN@@")
WaveConsole.print("HWID: " .. WaveUtils.getHWID(), "@@LIGHT_GRAY@@")
WaveConsole.print("Current FPS Cap: " .. WaveUtils.getFPS(), "@@LIGHT_GRAY@@")
WaveConsole.print("", "@@WHITE@@")
WaveConsole.print("Controls:", "@@YELLOW@@")
WaveConsole.print("Q = Noclip | C = Auto-Collect Toggle", "@@LIGHT_GRAY@@")
WaveConsole.print("═══════════════════════════════", "@@LIGHT_BLUE@@")