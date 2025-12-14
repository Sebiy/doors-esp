-- ══════════════════════════════════════════════════════════════════════════
-- WORKING EYES PROTECTION SYSTEM - FINAL VERSION THAT WORKS!
-- Save this file - this is the solution that makes Eyes visible but harmless
-- Date: 2025-01-14
-- Status: ✅ WORKING - Eyes visible but no damage
-- ══════════════════════════════════════════════════════════════════════════

-- COMPREHENSIVE EYES PROTECTION - Block ALL damage methods
local function setupComprehensiveEyesProtection()
    local protected = false
    local originalMethods = {}

    -- Method 1: Hook ALL raycasting functions
    local function hookRaycasting()
        originalMethods.Raycast = workspace.Raycast
        originalMethods.FindPartOnRay = workspace.FindPartOnRay
        originalMethods.FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
        originalMethods.RaycastWithParams = workspace.RaycastWithParams or function() end

        -- Hook workspace.Raycast
        workspace.Raycast = function(origin, direction, raycastParams, extras)
            local result = originalMethods.Raycast(origin, direction, raycastParams, extras)

            if Settings.ScreechProtection and result then
                local hitPart = result.Instance
                if hitPart and (hitPart.Name == "Eyes" or hitPart.Name == "Core" or
                   hitPart:IsDescendantOf(workspace:FindFirstChild("Eyes"))) then
                    WaveDebug.debug("Blocked Eyes raycast to " .. hitPart.Name)
                    return nil
                end
            end
            return result
        end

        -- Hook FindPartOnRay
        workspace.FindPartOnRay = function(ray, ignoreDescendantsInstance, terrainCellsAreCubes, ignoreWater)
            local result = originalMethods.FindPartOnRay(ray, ignoreDescendantsInstance, terrainCellsAreCubes, ignoreWater)

            if Settings.ScreechProtection and result then
                if result.Instance and (result.Instance.Name == "Eyes" or result.Instance.Name == "Core" or
                   result.Instance:IsDescendantOf(workspace:FindFirstChild("Eyes"))) then
                    WaveDebug.debug("Blocked Eyes FindPartOnRay")
                    return nil
                end
            end
            return result
        end

        -- Hook FindPartOnRayWithIgnoreList
        workspace.FindPartOnRayWithIgnoreList = function(ray, ignoreDescendantsInstances, terrainCellsAreCubes)
            local result = originalMethods.FindPartOnRayWithIgnoreList(ray, ignoreDescendantsInstances, terrainCellsAreCubes)

            if Settings.ScreechProtection and result then
                if result.Instance and (result.Instance.Name == "Eyes" or result.Instance.Name == "Core" or
                   result.Instance:IsDescendantOf(workspace:FindFirstChild("Eyes"))) then
                    WaveDebug.debug("Blocked Eyes FindPartOnRayWithIgnoreList")
                    return nil
                end
            end
            return result
        end
    end

    -- Method 2: Destroy/disable Eyes components
    local function disableEyesComponents(eyes)
        if not eyes then return end

        -- Disable Core part
        local core = eyes:FindFirstChild("Core")
        if core then
            -- Make Core completely non-interactive
            core.CanCollide = false
            core.CanTouch = false
            core.Anchored = true

            -- Disable any scripts in Core
            for _, child in pairs(core:GetDescendants()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    child:Destroy()
                end
            end

            -- Disable EyesParticle
            local particle = core:FindFirstChild("Attachment") and core.Attachment:FindFirstChild("EyesParticle")
            if particle then
                particle.Enabled = false
                particle:Emit(0)
            end
        end

        -- Disable all scripts in entire Eyes model
        for _, script in pairs(eyes:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                script:Destroy()
            end
        end
    end

    -- Method 3: Create protective barrier
    local function createProtectiveBarrier(eyes)
        if not eyes or not LocalPlayer.Character then return end

        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Create multiple invisible parts
        for i = 1, 5 do
            local barrier = Instance.new("Part")
            barrier.Name = "EyesBarrier_" .. i
            barrier.Size = Vector3.new(10, 20, 1)
            barrier.Material = Enum.Material.ForceField
            barrier.Transparency = 1
            barrier.CanCollide = true
            barrier.Anchored = true
            barrier.Position = eyes.Position

            -- Calculate angle
            local angle = (math.pi * 2 / 5) * i
            local offset = Vector3.new(math.cos(angle) * 8, 0, math.sin(angle) * 8)
            barrier.CFrame = CFrame.new(eyes.Position + offset, eyes.Position)
            barrier.Parent = workspace

            task.delay(0.5, function()
                if barrier then barrier:Destroy() end
            end)
        end
    end

    -- Method 4: Override ALL damage methods
    local function overrideDamageMethods()
        if not LocalPlayer.Character then return end

        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            -- Override TakeDamage
            originalMethods.TakeDamage = hum.TakeDamage
            hum.TakeDamage = function(self, amount)
                if Settings.ScreechProtection and workspace:FindFirstChild("Eyes") then
                    WaveDebug.debug("Blocked " .. amount .. " damage from Eyes!")
                    return
                end
                return originalMethods.TakeDamage(self, amount)
            end

            -- Override Health property
            originalMethods.Health = hum.Health
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if Settings.ScreechProtection and workspace:FindFirstChild("Eyes") and hum.Health < originalMethods.Health then
                    WaveDebug.debug("Restored health from Eyes damage!")
                    hum.Health = originalMethods.Health
                end
            end)

            -- Set health to maximum
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end

    -- Main protection function
    local function protectFromEyes()
        local eyes = Workspace:FindFirstChild("Eyes")
        if eyes and Settings.ScreechProtection and not protected then
            protected = true

            warn("👁️ EYES DETECTED - ACTIVATING COMPREHENSIVE PROTECTION!")

            if Settings.EntityNotify then
                Library:Notify({Title = "👁️ ULTIMATE EYES PROTECTION", Description = "All damage methods blocked!", Time = 3})
            end

            -- Apply all protection methods
            hookRaycasting()
            disableEyesComponents(eyes)
            overrideDamageMethods()

            -- Continuous protection
            task.spawn(function()
                while eyes and eyes.Parent and Settings.ScreechProtection do
                    -- Re-disable components periodically
                    disableEyesComponents(eyes)
                    createProtectiveBarrier(eyes)

                    -- Ensure health stays full
                    if LocalPlayer.Character then
                        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                        if hum and hum.Health < 100 then
                            hum.Health = 100
                        end
                    end

                    task.wait(0.1)
                end
                protected = false
            end)
        end
    end

    -- Monitor for Eyes
    task.spawn(function()
        while true do
            protectFromEyes()
            task.wait(0.1)
        end
    end)

    -- Spawn detection
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Eyes" and Settings.ScreechProtection then
            task.wait(0.01) -- Immediate protection
            protectFromEyes()
        end
    end)

    -- ESP
    local function checkForEyesESP()
        local EyesModel = Workspace:FindFirstChild("Eyes")
        if EyesModel and not EyesModel:GetAttribute("ESPAdded") and Settings.EntityESP then
            EyesModel:SetAttribute("ESPAdded", true)

            local highlight = Instance.new("Highlight")
            highlight.Parent = EyesModel
            highlight.FillColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineColor = Color3.new(1, 1, 0)
            highlight.FillTransparency = 0.2
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
                            label.Text = "👁️ EYES - " .. dist .. " studs (100% Protected)"
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

-- Initialize comprehensive Eyes protection
setupComprehensiveEyesProtection()