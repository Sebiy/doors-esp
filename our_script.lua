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
    DoorESPColor = Color3.fromRGB(168, 85, 247),
    DoorShowDistance = false,
    KeyESP = false,
    KeyESPColor = Color3.fromRGB(255, 255, 0),
    ItemESP = false,
    CoinESP = false,
    LeverESP = false,
    
    -- Entity Settings
    EntityNotify = false,
    EntityESP = false,
    RushESP = false,
    AmbushESP = false,
    EyesESP = false,
    ScreechProtection = false,
    
    -- Visual Settings
    Fullbright = false,
    FullbrightBrightness = 2,
    FogEnabled = false,
    
    -- Gameplay Settings
    Noclip = false,
    Speed = 16,
    AutoCollectCoins = false,
    CoinDistance = 50,
    InstantInteract = false
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
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = VesperGUI
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(168, 85, 247)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.5
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
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- Logo (Option 4 style)
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 140, 0, 35)
    LogoFrame.Position = UDim2.new(0, 15, 0, 8)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(26, 21, 53)
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = Header
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = LogoFrame
    
    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = Color3.fromRGB(168, 85, 247)
    LogoStroke.Thickness = 1
    LogoStroke.Transparency = 0.4
    LogoStroke.Parent = LogoFrame
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, -30, 1, 0)
    LogoText.Position = UDim2.new(0, 25, 0, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "vesper"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 16
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    LogoText.Parent = LogoFrame
    
    local LogoLua = Instance.new("TextLabel")
    LogoLua.Size = UDim2.new(0, 30, 1, 0)
    LogoLua.Position = UDim2.new(0, 73, 0, 0)
    LogoLua.BackgroundTransparency = 1
    LogoLua.Text = ".lua"
    LogoLua.TextColor3 = Color3.fromRGB(168, 85, 247)
    LogoLua.TextSize = 16
    LogoLua.Font = Enum.Font.GothamBold
    LogoLua.TextXAlignment = Enum.TextXAlignment.Left
    LogoLua.Parent = LogoFrame
    
    -- Star icon
    local StarIcon = Instance.new("TextLabel")
    StarIcon.Size = UDim2.new(0, 20, 0, 20)
    StarIcon.Position = UDim2.new(0, 5, 0.5, -10)
    StarIcon.BackgroundTransparency = 1
    StarIcon.Text = "⭐"
    StarIcon.TextColor3 = Color3.fromRGB(168, 85, 247)
    StarIcon.TextSize = 18
    StarIcon.Parent = LogoFrame
    
    -- Close Button
    -- vesper.lua Logo (Option 4 Style)
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 110, 0, 28)
    LogoFrame.Position = UDim2.new(1, -120, 0, 11)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = Header
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoFrame
    
    local LogoBorder = Instance.new("UIStroke")
    LogoBorder.Color = Color3.fromRGB(168, 85, 247)
    LogoBorder.Thickness = 1
    LogoBorder.Parent = LogoFrame
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, -25, 1, 0)
    LogoText.Position = UDim2.new(0, 25, 0, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "vesper.lua"
    LogoText.TextColor3 = Color3.fromRGB(168, 85, 247)
    LogoText.TextSize = 12
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextXAlignment = Enum.TextXAlignment.Center
    LogoText.Parent = LogoFrame
    
    local LogoIcon = Instance.new("TextLabel")
    LogoIcon.Size = UDim2.new(0, 20, 1, 0)
    LogoIcon.Position = UDim2.new(0, 5, 0, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Text = "⭐"
    LogoIcon.TextColor3 = Color3.fromRGB(168, 85, 247)
    LogoIcon.TextSize = 14
    LogoIcon.Font = Enum.Font.GothamBold
    LogoIcon.Parent = LogoFrame
    
    -- Close Button (Improved Design)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -37, 0, 10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = MainFrame
    CloseButton.ZIndex = 10
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local CloseBorder = Instance.new("UIStroke")
    CloseBorder.Color = Color3.fromRGB(80, 60, 100)
    CloseBorder.Thickness = 1
    CloseBorder.Parent = CloseButton
    
    -- Hover effects for close button
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 60, 80)
        }):Play()
        TweenService:Create(CloseBorder, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 100, 120)
        }):Play()
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 30, 55)
        }):Play()
        TweenService:Create(CloseBorder, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(80, 60, 100)
        }):Play()
        CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        VesperGUI.Enabled = false
        -- Re-lock cursor like the game does
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end)
    
    -- Tab System
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer
    
    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -150, 1, -65)
    ContentFrame.Position = UDim2.new(0, 140, 0, 60)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    -- Helper Functions
    local function CreateTab(name, icon, index)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = icon
        TabIcon.TextColor3 = Color3.fromRGB(168, 85, 247)
        TabIcon.TextSize = 16
        TabIcon.Parent = TabButton
        
        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -35, 1, 0)
        TabText.Position = UDim2.new(0, 30, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = name
        TabText.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabText.TextSize = 13
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton
        
        return TabButton
    end
    
    local function CreateToggle(parent, text, setting, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.BackgroundColor3 = Settings[setting] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 60)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
        ToggleBtnCorner.Parent = ToggleButton
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        ToggleIndicator.Position = Settings[setting] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Parent = ToggleButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = ToggleIndicator
        
        ToggleButton.MouseButton1Click:Connect(function()
            Settings[setting] = not Settings[setting]
            local newColor = Settings[setting] and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 60)
            local newPos = Settings[setting] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = newPos}):Play()
            
            if callback then callback(Settings[setting]) end
        end)
        
        return ToggleFrame
    end
    
    local function CreateSlider(parent, text, setting, min, max, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -20, 0, 50)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 60, 0, 20)
        ValueLabel.Position = UDim2.new(1, -65, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(Settings[setting])
        ValueLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
        ValueLabel.TextSize = 13
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -20, 0, 4)
        SliderBar.Position = UDim2.new(0, 10, 1, -15)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame
        
        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(1, 0)
        SliderBarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(1, 0, 1, 0)
        SliderButton.BackgroundTransparency = 1
        SliderButton.Text = ""
        SliderButton.Parent = SliderBar
        
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
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                Settings[setting] = value
                ValueLabel.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                if callback then callback(value) end
            end
        end)
        
        return SliderFrame
    end
    
    -- Tab Pages
    local Pages = {}
    
    local function CreatePage(name)
        local Page = Instance.new("Frame")
        Page.Name = name
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = ContentFrame
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.Parent = Page
        
        Pages[name] = Page
        return Page
    end
    
    -- Create Tabs
    local ESPTab = CreateTab("ESP", "👁️", 1)
    local EntitiesTab = CreateTab("Entities", "👻", 2)
    local VisualsTab = CreateTab("Visuals", "💡", 3)
    local GameplayTab = CreateTab("Gameplay", "⚙️", 4)
    
    -- Create Pages
    local ESPPage = CreatePage("ESP")
    local EntitiesPage = CreatePage("Entities")
    local VisualsPage = CreatePage("Visuals")
    local GameplayPage = CreatePage("Gameplay")
    
    -- ESP Page Content
    CreateToggle(ESPPage, "Door ESP", "DoorESP", function(val)
        Settings.DoorESP = val
    end)
    CreateToggle(ESPPage, "Show Distance", "DoorShowDistance")
    CreateToggle(ESPPage, "Key ESP", "KeyESP")
    CreateToggle(ESPPage, "Coin ESP", "CoinESP")
    CreateToggle(ESPPage, "Lever ESP", "LeverESP")
    CreateToggle(ESPPage, "Item ESP", "ItemESP")
    
    -- Entities Page Content
    CreateToggle(EntitiesPage, "Entity Notifications", "EntityNotify")
    CreateToggle(EntitiesPage, "Entity ESP", "EntityESP")
    CreateToggle(EntitiesPage, "Rush ESP", "RushESP")
    CreateToggle(EntitiesPage, "Ambush ESP", "AmbushESP")
    CreateToggle(EntitiesPage, "Eyes ESP", "EyesESP")
    CreateToggle(EntitiesPage, "Screech Protection", "ScreechProtection")
    
    -- Visuals Page Content
    CreateToggle(VisualsPage, "Fullbright", "Fullbright", function(val)
        local Lighting = game:GetService("Lighting")
        if val then
            Lighting.Brightness = Settings.FullbrightBrightness
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.FogEnd = 500
            Lighting.GlobalShadows = true
        end
    end)
    CreateSlider(VisualsPage, "Brightness", "FullbrightBrightness", 1, 5, function(val)
        if Settings.Fullbright then
            game:GetService("Lighting").Brightness = val
        end
    end)
    CreateToggle(VisualsPage, "Remove Fog", "FogEnabled", function(val)
        game:GetService("Lighting").FogEnd = val and 100000 or 500
    end)
    
    -- Gameplay Page Content
    CreateToggle(GameplayPage, "Noclip", "Noclip")
    CreateToggle(GameplayPage, "Auto Collect Coins", "AutoCollectCoins")
    CreateToggle(GameplayPage, "Instant Interact", "InstantInteract")
    CreateSlider(GameplayPage, "Walk Speed", "Speed", 16, 100)
    CreateSlider(GameplayPage, "Coin Distance", "CoinDistance", 10, 100)
    
    -- Update canvas size
    local function updateCanvasSize(page)
        local content = page.UIListLayout.AbsoluteContentSize
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, content.Y + 10)
    end
    
    for _, page in pairs(Pages) do
        page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            updateCanvasSize(page)
        end)
    end
    
    -- Tab Switching
    local currentTab = ESPPage
    local function switchTab(tab, page)
        for _, t in pairs({ESPTab, EntitiesTab, VisualsTab, GameplayTab}) do
            TweenService:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 20, 40)}):Play()
        end
        TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(168, 85, 247)}):Play()
        
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        page.Visible = true
        currentTab = page
        updateCanvasSize(page)
    end
    
    ESPTab.MouseButton1Click:Connect(function() switchTab(ESPTab, ESPPage) end)
    EntitiesTab.MouseButton1Click:Connect(function() switchTab(EntitiesTab, EntitiesPage) end)
    VisualsTab.MouseButton1Click:Connect(function() switchTab(VisualsTab, VisualsPage) end)
    GameplayTab.MouseButton1Click:Connect(function() switchTab(GameplayTab, GameplayPage) end)
    
    -- Default tab
    switchTab(ESPTab, ESPPage)
    
    -- Toggle GUI with Right Ctrl
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            VesperGUI.Enabled = not VesperGUI.Enabled
            
            -- Unlock/lock cursor based on GUI state
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
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200)
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
