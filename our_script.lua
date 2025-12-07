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


local function CreateGUI()
    local VesperGUI = Instance.new("ScreenGui")
    VesperGUI.Name = "VesperGUI"
    VesperGUI.ResetOnSpawn = false
    VesperGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (850x550 for better layout)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 850, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = VesperGUI
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(50, 50, 50)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame
    
    -- Drag functionality
    local dragging, dragInput, dragStart, startPos
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Header Bar
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    -- Logo
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(0, 150, 1, 0)
    LogoText.Position = UDim2.new(0, 70, 0, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "⭐ vesper.lua"
    LogoText.TextColor3 = Color3.fromRGB(168, 85, 247)
    LogoText.TextSize = 18
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    LogoText.Parent = Header
    
    -- Search Bar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(0, 350, 0, 35)
    SearchBox.Position = UDim2.new(0, 280, 0.5, -17)
    SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchBox.PlaceholderText = "Search"
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    SearchBox.TextSize = 14
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = Header
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox
    
    -- Search Icon
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Size = UDim2.new(0, 25, 1, 0)
    SearchIcon.Position = UDim2.new(0, 5, 0, 0)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Text = "🔍"
    SearchIcon.TextColor3 = Color3.fromRGB(100, 100, 100)
    SearchIcon.TextSize = 16
    SearchIcon.Parent = SearchBox
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 60, 80)
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        VesperGUI.Enabled = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end)
    
    -- LEFT SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 200, 1, -110)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar
    
    -- MAIN CONTENT AREA
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -225, 1, -110)
    ContentArea.Position = UDim2.new(0, 215, 0, 70)
    ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea
    
    -- BOTTOM STATUS BAR
    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(1, -20, 0, 30)
    StatusBar.Position = UDim2.new(0, 10, 1, -35)
    StatusBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = MainFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusBar
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -10, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "version: vesper.lua v1.0 | game: DOORS | made with ♥"
    StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
    StatusText.TextSize = 11
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    -- ============================================
    -- HELPER FUNCTIONS
    -- ============================================
    
    local function CreateSidebarButton(name, icon)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Text = ""
        Button.BorderSizePixel = 0
        Button.Parent = Sidebar
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Button
        
        return Button, Label
    end
    
    local function CreateSection(parent, title)
        local Section = Instance.new("Frame")
        Section.Size = UDim2.new(0.48, 0, 0, 0)
        Section.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Section.BorderSizePixel = 0
        Section.Parent = parent
        Section.AutomaticSize = Enum.AutomaticSize.Y
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = Section
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextSize = 15
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Parent = Section
        
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -10, 0, 0)
        Container.Position = UDim2.new(0, 5, 0, 35)
        Container.BackgroundTransparency = 1
        Container.Parent = Section
        Container.AutomaticSize = Enum.AutomaticSize.Y
        
        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 5)
        List.Parent = Container
        
        return Section, Container
    end
    
    local function CreateToggle(parent, text, setting, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, 0, 0, 30)
        Toggle.BackgroundTransparency = 1
        Toggle.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Toggle
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 35, 0, 18)
        Button.Position = UDim2.new(1, -40, 0.5, -9)
        Button.BackgroundColor3 = Settings[setting] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 50)
        Button.Text = ""
        Button.BorderSizePixel = 0
        Button.Parent = Toggle
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = Button
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 14, 0, 14)
        Indicator.Position = Settings[setting] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Button
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        Button.MouseButton1Click:Connect(function()
            Settings[setting] = not Settings[setting]
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Settings[setting] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 50)
            }):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {
                Position = Settings[setting] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            }):Play()
            if callback then callback(Settings[setting]) end
        end)
        
        return Toggle
    end
    
    local function CreateSlider(parent, text, setting, min, max, suffix, callback)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, 0, 0, 45)
        Slider.BackgroundTransparency = 1
        Slider.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 0, 18)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Slider
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 50, 0, 18)
        ValueLabel.Position = UDim2.new(1, -50, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(Settings[setting]) .. (suffix or "")
        ValueLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
        ValueLabel.TextSize = 12
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider
        
        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, 0, 0, 6)
        Bar.Position = UDim2.new(0, 0, 1, -10)
        Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Bar.BorderSizePixel = 0
        Bar.Parent = Slider
        
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = Bar
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = Bar
        
        local dragging = false
        
        Button.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos + 0.5)
                Settings[setting] = value
                ValueLabel.Text = tostring(value) .. (suffix or "")
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                if callback then callback(value) end
            end
        end)
        
        return Slider
    end
    
    local function CreateColorPicker(parent, text, setting)
        local Picker = Instance.new("Frame")
        Picker.Size = UDim2.new(1, 0, 0, 30)
        Picker.BackgroundTransparency = 1
        Picker.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Picker
        
        local ColorBox = Instance.new("Frame")
        ColorBox.Size = UDim2.new(0, 25, 0, 25)
        ColorBox.Position = UDim2.new(1, -30, 0.5, -12.5)
        ColorBox.BackgroundColor3 = Settings[setting]
        ColorBox.BorderSizePixel = 0
        ColorBox.Parent = Picker
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 4)
        BoxCorner.Parent = ColorBox
        
        return Picker
    end
    
    -- ============================================
    -- CREATE PAGES
    -- ============================================
    
    local Pages = {}
    
    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.Parent = ContentArea
        
        local Grid = Instance.new("UIGridLayout")
        Grid.CellSize = UDim2.new(0.48, 0, 0, 0)
        Grid.CellPadding = UDim2.new(0.02, 0, 0, 10)
        Grid.Parent = Page
        
        Pages[name] = Page
        return Page
    end
    
    -- Create sidebar navigation
    local MainBtn, MainLabel = CreateSidebarButton("Main", "")
    local PlayerBtn, PlayerLabel = CreateSidebarButton("Player", "")
    local VisualsBtn, VisualsLabel = CreateSidebarButton("Visuals", "")
    local MiscBtn, MiscLabel = CreateSidebarButton("Misc", "")
    
    -- Create pages
    local MainPage = CreatePage("Main")
    local PlayerPage = CreatePage("Player")
    local VisualsPage = CreatePage("Visuals")
    local MiscPage = CreatePage("Misc")
    
    -- ============================================
    -- MAIN PAGE CONTENT
    -- ============================================
    
    local MiscSection, MiscContainer = CreateSection(MainPage, "Miscellaneous")
    CreateToggle(MiscContainer, "Instant Proximity Prompt", "InstantInteract")
    CreateToggle(MiscContainer, "break ROBLOX Void", "BreakVoid")
    CreateToggle(MiscContainer, "No cutscenes", "NoCutscenes")
    CreateToggle(MiscContainer, "Door Reach", "DoorReach")
    
    local AutoSection, AutoContainer = CreateSection(MainPage, "Automation")
    CreateToggle(AutoContainer, "Auto Play Again", "AutoPlayAgain")
    CreateToggle(AutoContainer, "Auto Lobby", "AutoLobby")
    CreateToggle(AutoContainer, "Auto Library Code", "AutoLibraryCode")
    CreateToggle(AutoContainer, "Auto Breaker Box", "AutoBreakerBox")
    
    local NotifySection, NotifyContainer = CreateSection(MainPage, "Notifiers")
    CreateToggle(NotifyContainer, "Notification sound", "NotificationSound")
    CreateToggle(NotifyContainer, "Notify Entities", "EntityNotify")
    CreateToggle(NotifyContainer, "Notify in Chat", "NotifyInChat")
    
    local AuraSection, AuraContainer = CreateSection(MainPage, "Auras")
    CreateToggle(AuraContainer, "Lever/Valve Aura", "LeverValveAura")
    CreateToggle(AuraContainer, "Loot Aura", "LootAura")
    CreateToggle(AuraContainer, "Auto Collect Books/Breaker", "AutoCollectBooks")
    CreateToggle(AuraContainer, "Locked Door Aura", "LockedDoorAura")
    
    -- ============================================
    -- PLAYER PAGE CONTENT
    -- ============================================
    
    local MovementSection, MovementContainer = CreateSection(PlayerPage, "Movement")
    CreateSlider(MovementContainer, "Noclip Bypass Speed", "NoclipBypassSpeed", 0, 6, "/6")
    CreateToggle(MovementContainer, "Speed Boost Enabled", "SpeedBoost")
    CreateToggle(MovementContainer, "Speed Bypass", "SpeedBypass")
    CreateToggle(MovementContainer, "No Acceleration", "NoAcceleration")
    CreateToggle(MovementContainer, "Fly", "Fly")
    CreateSlider(MovementContainer, "Fly Speed", "FlySpeed", 0, 5, "/5")
    CreateToggle(MovementContainer, "teleport", "TeleportEnabled")
    CreateSlider(MovementContainer, "teleport distance", "TeleportDistance", 1, 25, "/25")
    
    local CharacterSection, CharacterContainer = CreateSection(PlayerPage, "Character")
    CreateToggle(CharacterContainer, "NoClip", "Noclip")
    CreateToggle(CharacterContainer, "Enable jump", "EnableJump")
    CreateToggle(CharacterContainer, "Infinite Jump", "InfiniteJump")
    CreateToggle(CharacterContainer, "Closet exit Fix", "ClosetExitFix")
    
    -- ============================================
    -- VISUALS PAGE CONTENT
    -- ============================================
    
    local CameraSection, CameraContainer = CreateSection(VisualsPage, "Camera")
    CreateSlider(CameraContainer, "FOV", "FOV", 30, 120, "/120")
    CreateToggle(CameraContainer, "No camera shaking", "NoCameraShaking")
    CreateToggle(CameraContainer, "Freecam", "Freecam")
    CreateToggle(CameraContainer, "Third Person", "ThirdPerson")
    CreateSlider(CameraContainer, "Third Offset", "ThirdOffset", 0, 10, "/10")
    CreateSlider(CameraContainer, "Third Height", "ThirdHeight", 0, 10, "/10")
    CreateSlider(CameraContainer, "Third Distance", "ThirdDistance", 5, 20, "/20")
    CreateSlider(CameraContainer, "Third Sensitivity", "ThirdSensitivity", 1, 10, "/10")
    
    local LightingSection, LightingContainer = CreateSection(VisualsPage, "Lighting")
    CreateToggle(LightingContainer, "Fullbright", "Fullbright", function(val)
        local Lighting = game:GetService("Lighting")
        if val then
            Lighting.Brightness = Settings.Brightness
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
        else
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.FogEnd = 500
        end
    end)
    CreateSlider(LightingContainer, "Brightness", "Brightness", 1, 10, "/10", function(val)
        if Settings.Fullbright then
            game:GetService("Lighting").Brightness = val
        end
    end)
    
    local ESPSection, ESPContainer = CreateSection(VisualsPage, "ESP Settings")
    CreateToggle(ESPContainer, "Use Adornments", "UseAdornments")
    CreateToggle(ESPContainer, "Rainbow ESP Enabled", "RainbowESP")
    CreateToggle(ESPContainer, "Entity ESP enabled", "EntityESP")
    CreateColorPicker(ESPContainer, "Entity ESP color", "EntityESPColor")
    CreateToggle(ESPContainer, "Player ESP enabled", "PlayerESP")
    CreateColorPicker(ESPContainer, "Player ESP color", "PlayerESPColor")
    CreateToggle(ESPContainer, "Door ESP enabled", "DoorESP")
    CreateColorPicker(ESPContainer, "Door ESP color", "DoorESPColor")
    CreateToggle(ESPContainer, "Closet ESP enabled", "ClosetESP")
    CreateColorPicker(ESPContainer, "Closet ESP color", "ClosetESPColor")
    CreateToggle(ESPContainer, "Item ESP enabled", "ItemESP")
    CreateColorPicker(ESPContainer, "Item ESP color", "ItemESPColor")
    CreateToggle(ESPContainer, "Objective ESP enabled", "ObjectiveESP")
    CreateColorPicker(ESPContainer, "Objective ESP color", "ObjectiveESPColor")
    CreateToggle(ESPContainer, "Gold ESP enabled", "GoldESP")
    CreateColorPicker(ESPContainer, "Gold ESP color", "GoldESPColor")
    
    -- ============================================
    -- MISC PAGE (placeholder)
    -- ============================================
    
    local PlaceholderSection, PlaceholderContainer = CreateSection(MiscPage, "Coming Soon")
    local PlaceholderText = Instance.new("TextLabel")
    PlaceholderText.Size = UDim2.new(1, 0, 0, 50)
    PlaceholderText.BackgroundTransparency = 1
    PlaceholderText.Text = "More features coming soon!"
    PlaceholderText.TextColor3 = Color3.fromRGB(150, 150, 150)
    PlaceholderText.TextSize = 14
    PlaceholderText.Font = Enum.Font.Gotham
    PlaceholderText.Parent = PlaceholderContainer
    
    -- ============================================
    -- TAB SWITCHING
    -- ============================================
    
    local currentPage = MainPage
    
    local function SwitchPage(button, label, page)
        -- Deselect all
        for _, btn in pairs({MainBtn, PlayerBtn, VisualsBtn, MiscBtn}) do
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end
        for _, lbl in pairs({MainLabel, PlayerLabel, VisualsLabel, MiscLabel}) do
            lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        
        -- Select current
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(168, 85, 247)}):Play()
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Hide all pages
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        
        page.Visible = true
        currentPage = page
        
        -- Update canvas size
        task.wait(0.1)
        page.CanvasSize = UDim2.new(0, 0, 0, page.UIGridLayout.AbsoluteContentSize.Y + 10)
    end
    
    MainBtn.MouseButton1Click:Connect(function() SwitchPage(MainBtn, MainLabel, MainPage) end)
    PlayerBtn.MouseButton1Click:Connect(function() SwitchPage(PlayerBtn, PlayerLabel, PlayerPage) end)
    VisualsBtn.MouseButton1Click:Connect(function() SwitchPage(VisualsBtn, VisualsLabel, VisualsPage) end)
    MiscBtn.MouseButton1Click:Connect(function() SwitchPage(MiscBtn, MiscLabel, MiscPage) end)
    
    -- Default page
    SwitchPage(MainBtn, MainLabel, MainPage)
    
    -- Update canvas sizes
    for _, page in pairs(Pages) do
        page.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, page.UIGridLayout.AbsoluteContentSize.Y + 10)
        end)
    end
    
    -- Toggle GUI with Right Ctrl
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            VesperGUI.Enabled = not VesperGUI.Enabled
            
            if VesperGUI.Enabled then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        end
    end)
    
    -- Animate GUI in
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    VesperGUI.Parent = LocalPlayer.PlayerGui
    
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 850, 0, 550),
        Position = UDim2.new(0.5, -425, 0.5, -275)
    }):Play()
    
    return VesperGUI
end


-- Initialize GUI
local GUI = CreateGUI()
warn("vesper.lua GUI loaded! Press Right Ctrl to toggle")

-- Update old Settings references
Settings.EntityNotify = Settings.EntityNotify
Settings.DoorESP = Settings.DoorESP
Settings.KeyESP = Settings.KeyESP
Settings.ItemESP = Settings.ItemESP

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
    
    -- Apply highlight only to the main visible door part
    local doorPart = door:FindFirstChild("Door")
    if doorPart and doorPart:IsA("BasePart") and doorPart.Transparency < 1 then
        CreateHighlight(doorPart, fillColor, outlineColor, 0.4, 0)
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
                showEntityWarning("RUSH - HIDE IMMEDIATELY!", 5)
                warn("⚠️ RUSH SPAWNED!")
                RushModel:SetAttribute("ESPAdded", true)
                
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
        if child.Name == "AmbushMoving" then
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

-- Initialize entity detection
if Settings.EntityNotify then
    setupRushDetection()
    setupAmbushDetection()
    setupEyesDetection()
    setupScreechProtection()
    setupPredictiveWarnings()
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
