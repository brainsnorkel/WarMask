-- =============================================================================
-- Warmask - Huntsman's Warmask Mark of Hircine Tracker
-- =============================================================================
--[[
    Addon Name:     Warmask
    Description:    Tracks Mark of Hircine applications from Huntsman's Warmask
    Version:        1.4.0
    Author:         @brainsnorkel
    Year:           2025
    
    Shows an icon when Warmask buff is active. When you bash an enemy,
    displays the target name with a 60-second countdown.
--]]

-- =============================================================================
-- ADDON NAMESPACE
-- =============================================================================
WarMask = WarMask or {}
local WM = WarMask

WM.name = "WarMask"  -- Must match folder name for addon loading
WM.version = "1.4.0"

-- Localization is loaded via lang/Localization.lua and lang/*.lua files
-- WM.LS() function is available after localization files are loaded

-- =============================================================================
-- CONSTANTS
-- =============================================================================
local WARMASK_BUFF_ID = 252050          -- Huntsman's Warmask equipped buff
local MARK_OF_HIRCINE_ID = 252048       -- Mark of Hircine ability (for icon)
local BASH_ABILITY_ID = 21970           -- Bash ability ID
local COUNTDOWN_DURATION = 60           -- seconds
local INTERNAL_COOLDOWN = 10            -- seconds (ignore bash if countdown > 50s)
local WARMASK_ITEM_NAME = "Huntsman's Warmask"  -- Mythic item name for equipment detection
local WARMASK_ITEM_ID = 223189

local EM = EVENT_MANAGER
local WM_WINDOW = WINDOW_MANAGER

-- =============================================================================
-- DEFAULT SETTINGS
-- =============================================================================
WM.defaults = {
    position = { x = 0, y = 128 },
    lockPosition = true,
    enableLine = true,
    cooldownColor = { 1, 0.3, 0.3, 1 },  -- RGBA red (60s to 50s cooldown period)
    readyColor = { 0, 1, 0, 1 },  -- RGBA green (49s and lower, ready for new bash)
    enableDebug = false,  -- Debug information flag
    iconScale = 100,  -- Icon scale percentage (100 = 100%)
    fontScale = 100,  -- Font scale percentage (100 = 100%)
    fontFamily = "Univers67",  -- Font family: "Univers67" or "ProseAntiquePSMT"
    hideIconOutOfCombat = false,  -- Hide icon when not in combat
    roleplayingMode = false,  -- Use roleplaying text ("Bash, thou must" instead of "Bash something")
}

-- =============================================================================
-- STATE VARIABLES
-- =============================================================================
local savedVars = nil
local hasWarmaskBuff = false
local markedUnitId = nil
local markedUnitName = nil
local countdownEndTime = 0
local isCountdownActive = false

-- UI Controls
local mainWindow = nil
local iconTexture = nil
local statusLabel = nil
local countdownLabel = nil  -- Label on icon for countdown timer

-- Pulse state
local isInCombat = false
local countdownFlashActive = false  -- Track if countdown pulse is already running

-- =============================================================================
-- DEBUG
-- =============================================================================
local function Debug(msg)
    if savedVars and savedVars.enableDebug then
        -- Always show equipped/unequipped messages, but only show other debug when Warmask is equipped
        if string.find(msg, "Warmask equipped") or string.find(msg, "Warmask unequipped") or hasWarmaskBuff then
            d("[Warmask] " .. msg)
        end
    end
end

-- =============================================================================
-- CHAT LOGGING (similar to WizardsWardrobe format)
-- =============================================================================
function WM.Log(message, color)
    if not message then return end
    color = color or "FFFFFF"  -- Default to white
    -- Format: |c18bed8[|c65d3b0W|cb2e789M|cfffc61]|r|c[color] message|r
    -- Using similar color scheme to WizardsWardrobe but with WM prefix
    local formattedMessage = string.format("|cFFD700[|cFFA500W|r|cFFD700M|r]|r|c%s %s|r", color, message)
    CHAT_ROUTER:AddSystemMessage(formattedMessage)
end

-- =============================================================================
-- TEXT HELPERS
-- =============================================================================
local function GetBashText()
    if savedVars and savedVars.roleplayingMode then
        return "Bash, thou must"
    else
        -- Use fallback if WM.LS is not available yet
        if WM.LS and type(WM.LS) == "function" then
            local success, result = pcall(function() return WM.LS("BASH_SOMETHING") end)
            if success and result then
                return result
            end
        end
        -- Fallback to default text
        return "Bash something"
    end
end

-- =============================================================================
-- FONT HELPER
-- =============================================================================
-- Get font string based on font family and size
local function GetFontString(fontSize, fontFamily)
    if not fontFamily then
        fontFamily = (savedVars and savedVars.fontFamily) or "Univers67"
    end
    local fontPath = string.format("esoui/common/fonts/%s.slug|%d|soft-shadow-thick", fontFamily, fontSize)
    return fontPath
end

-- =============================================================================
-- UI CREATION
-- =============================================================================
local function CreateUI()
    -- Main container window
    mainWindow = WM_WINDOW:CreateTopLevelWindow(WM.name .. "Window")
    mainWindow:SetDimensions(140, 80)
    mainWindow:SetDrawTier(DT_HIGH)
    mainWindow:SetClampedToScreen(true)
    mainWindow:SetMouseEnabled(true)
    -- Set initial movable state based on lock setting
    if savedVars then
        mainWindow:SetMovable(not savedVars.lockPosition)
    else
        mainWindow:SetMovable(true)  -- Default to movable if savedVars not loaded yet
    end
    mainWindow:SetHidden(true)
    
    -- Position from saved vars (ensure defaults exist)
    if not savedVars.position then
        savedVars.position = { x = 0, y = 128 }
    end
    if not savedVars.position.x then
        savedVars.position.x = 0
    end
    if not savedVars.position.y then
        savedVars.position.y = 128
    end
    
    -- Restore saved position
    mainWindow:ClearAnchors()
    mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x, savedVars.position.y)
    
    -- Verify the position was set correctly
    local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
    Debug(string.format("Icon position restored: saved=(%f, %f), actual=(%s, %s)", 
        savedVars.position.x, savedVars.position.y, 
        offsetX or "nil", offsetY or "nil"))
    
    -- If position doesn't match, try setting it again
    if offsetX and offsetY then
        if math.abs(offsetX - savedVars.position.x) > 0.1 or math.abs(offsetY - savedVars.position.y) > 0.1 then
            d(string.format("[Warmask] Position mismatch! Saved: (%f, %f), Actual: (%f, %f). Re-setting...", 
                savedVars.position.x, savedVars.position.y, offsetX, offsetY))
            mainWindow:ClearAnchors()
            mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x, savedVars.position.y)
        end
    end
    
    -- Save position when moved
    mainWindow:SetHandler("OnMoveStop", function(control)
        if not savedVars then 
            d("[Warmask] ERROR: savedVars is nil when trying to save position")
            return 
        end
        
        -- Calculate position from screen coordinates (GetAnchor() offset is unreliable)
        -- This method calculates the center offset from screen center, which matches
        -- how we set the anchor with CENTER, GuiRoot, CENTER, offsetX, offsetY
        local screenWidth, screenHeight = GuiRoot:GetDimensions()
        local left, top = control:GetLeft(), control:GetTop()
        local width, height = control:GetDimensions()
        
        -- Calculate center position relative to screen center
        local finalX, finalY
        if left and top and width and height and screenWidth and screenHeight then
            finalX = left + (width / 2) - (screenWidth / 2)
            finalY = top + (height / 2) - (screenHeight / 2)
            
            if savedVars.enableDebug then
                d("[Warmask] Position Debug:")
                d("  GetLeft: " .. left .. ", GetTop: " .. top)
                d("  Dimensions: " .. width .. "x" .. height)
                d("  Screen: " .. screenWidth .. "x" .. screenHeight)
                d("  Calculated center offset: x=" .. string.format("%.2f", finalX) .. ", y=" .. string.format("%.2f", finalY))
            end
        else
            -- Fallback: keep existing position if we can't calculate
            d("[Warmask] WARNING: Could not calculate position, keeping existing")
            if savedVars.position then
                finalX = savedVars.position.x or 0
                finalY = savedVars.position.y or 128
            else
                finalX = 0
                finalY = 128
            end
        end
        
        if not savedVars.position then
            savedVars.position = {}
        end
        savedVars.position.x = finalX
        savedVars.position.y = finalY
        
        -- Always show message when position is saved
        d("[Warmask] Position saved: x=" .. math.floor(finalX) .. ", y=" .. math.floor(finalY))
        Debug("Icon position saved to SavedVariables: " .. finalX .. ", " .. finalY)
    end)
    
    -- Icon texture (Mark of Hircine icon)
    iconTexture = WM_WINDOW:CreateControl(WM.name .. "Icon", mainWindow, CT_TEXTURE)
    iconTexture:SetAnchor(LEFT, mainWindow, LEFT, 0, 0)
    iconTexture:SetDimensions(64, 64)
    iconTexture:SetTexture(GetAbilityIcon(MARK_OF_HIRCINE_ID))
    
    -- Countdown label on icon
    countdownLabel = WM_WINDOW:CreateControl(WM.name .. "CountdownLabel", iconTexture, CT_LABEL)
    local defaultFont = savedVars and savedVars.fontFamily or "Univers67"
    countdownLabel:SetFont(GetFontString(54, defaultFont))
    countdownLabel:SetAnchor(CENTER, iconTexture, CENTER, 0, 0)
    countdownLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    countdownLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    countdownLabel:SetColor(1, 1, 1, 1)
    countdownLabel:SetText("")
    countdownLabel:SetHidden(true)
    
    -- Status text label (for unit name or status)
    statusLabel = WM_WINDOW:CreateControl(WM.name .. "Label", mainWindow, CT_LABEL)
    statusLabel:SetFont(GetFontString(54, defaultFont))
    statusLabel:SetAnchor(LEFT, iconTexture, RIGHT, 8, 0)
    statusLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    statusLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    statusLabel:SetColor(1, 1, 1, 1)
    statusLabel:SetText(GetBashText())
    
    -- Apply scaling after all controls are created
    WM.ApplyUIScaling()
    
    Debug(WM.LS("DEBUG_UI_CREATED"))
end

-- =============================================================================
-- UI SCALING
-- =============================================================================
function WM.ApplyUIScaling()
    if not savedVars then return end
    
    -- Ensure scale values exist
    if not savedVars.iconScale then savedVars.iconScale = 100 end
    if not savedVars.fontScale then savedVars.fontScale = 100 end
    if not savedVars.fontFamily then savedVars.fontFamily = "Univers67" end
    
    local iconScale = savedVars.iconScale / 100
    local fontScale = savedVars.fontScale / 100
    
    -- Base dimensions
    local baseIconSize = 64
    local iconSize = baseIconSize * iconScale
    
    -- Update icon size
    if iconTexture then
        iconTexture:SetDimensions(iconSize, iconSize)
    end
    
    -- Calculate font from font scale
    local fontSize
    if fontScale >= 3.0 then
        fontSize = 54      -- 300%+ (largest)
    elseif fontScale >= 2.0 then
        fontSize = 48       -- 200-299%
    elseif fontScale >= 1.5 then
        fontSize = 42        -- 150-199%
    elseif fontScale >= 1.0 then
        fontSize = 36        -- 100-149%
    elseif fontScale >= 0.7 then
        fontSize = 30        -- 70-99%
    else
        fontSize = 24        -- Below 70% (smallest)
    end
    
    -- Update countdown label font
    if countdownLabel then
        countdownLabel:SetFont(GetFontString(fontSize * 2, savedVars.fontFamily))
    end
    
    -- Update status label font
    if statusLabel then
        statusLabel:SetFont(GetFontString(fontSize * 2, savedVars.fontFamily))
    end
    
    -- Update main window size to accommodate scaled icon
    if mainWindow then
        local windowWidth = math.max(140, iconSize + 80)
        local windowHeight = math.max(80, iconSize)
        mainWindow:SetDimensions(windowWidth, windowHeight)
    end
    
    Debug(string.format("UI scaling applied: Icon=%.0f%%, Font=%.0f%%", savedVars.iconScale, savedVars.fontScale))
end

-- =============================================================================
-- UI VISIBILITY
-- =============================================================================
-- Function to update lock state (can be called from settings)
function WM.UpdateLockState()
    if mainWindow and savedVars then
        -- If locked, window is not movable
        -- If unlocked, window is movable
        mainWindow:SetMovable(not savedVars.lockPosition)
    end
end

local function ShowUI()
    if mainWindow then
        -- Check if we should hide when out of combat
        if savedVars and savedVars.hideIconOutOfCombat and not isInCombat then
            mainWindow:SetHidden(true)
            return
        end
        
        mainWindow:SetHidden(false)
        -- Respect lock setting
        WM.UpdateLockState()
        
        -- Ensure position is maintained when showing UI
        if savedVars and savedVars.position then
            -- Try to verify and restore position, but don't let errors prevent UI from showing
            local success, err = pcall(function()
                local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
                if point then
                    -- If position doesn't match saved position, restore it
                    if not offsetX or not offsetY or 
                       math.abs(offsetX - savedVars.position.x) > 1 or 
                       math.abs(offsetY - savedVars.position.y) > 1 then
                        mainWindow:ClearAnchors()
                        mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x, savedVars.position.y)
                        Debug("Position restored in ShowUI: " .. savedVars.position.x .. ", " .. savedVars.position.y)
                    end
                else
                    -- If GetAnchor fails, just set the position
                    mainWindow:ClearAnchors()
                    mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x or 0, savedVars.position.y or 128)
                    Debug("Position set in ShowUI (GetAnchor failed): " .. (savedVars.position.x or 0) .. ", " .. (savedVars.position.y or 128))
                end
            end)
            if not success then
                -- If there's an error, just set the position without checking
                mainWindow:ClearAnchors()
                mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x or 0, savedVars.position.y or 128)
                Debug("Position set in ShowUI (error occurred): " .. (savedVars.position.x or 0) .. ", " .. (savedVars.position.y or 128))
            end
        end
    end
end

local function HideUI()
    if mainWindow then
        mainWindow:SetHidden(true)
    end
end

local function UpdateStatusText(text, r, g, b)
    if statusLabel then
        -- Force update by setting text twice to ensure it refreshes
        statusLabel:SetText(text or "")
        statusLabel:SetColor(r or 1, g or 1, b or 1, 1)
        statusLabel:SetHidden(false)
        statusLabel:SetAlpha(1)
        -- Set text again to force refresh
        statusLabel:SetText(text or "")
    end
end

local function UpdateCountdownOnIcon(time, r, g, b)
    if countdownLabel then
        if time and time > 0 then
            local timeText = string.format("%.0f", time)
            countdownLabel:SetText(timeText)
            countdownLabel:SetColor(r or 1, g or 1, b or 1, 1)
            countdownLabel:SetHidden(false)
            -- Force redraw to ensure visibility
            countdownLabel:SetAlpha(1)
        else
            countdownLabel:SetText("")
            countdownLabel:SetHidden(true)
        end
    end
end

-- =============================================================================
-- COLOR INTERPOLATION HELPER
-- =============================================================================
local function LerpColor(colorA, colorB, t)
    -- t ranges from 0 to 1, returns interpolated color
    return {
        colorA[1] + (colorB[1] - colorA[1]) * t,
        colorA[2] + (colorB[2] - colorA[2]) * t,
        colorA[3] + (colorB[3] - colorA[3]) * t,
        colorA[4] + (colorB[4] - colorA[4]) * t
    }
end

-- =============================================================================
-- READY TEXT PULSE
-- =============================================================================
local readyPulseStartTime = 0

local function UpdateReadyPulse()
    -- Only pulse when: in combat, warmask equipped, not in countdown
    if not isInCombat or not hasWarmaskBuff or isCountdownActive then
        -- Stop pulsing, set to ready color
        EM:UnregisterForUpdate(WM.name .. "ReadyFlash")
        if statusLabel then
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            statusLabel:SetColor(readyColor[1], readyColor[2], readyColor[3], 1)
        end
        return
    end
    
    -- Calculate pulse position (0 to 1 to 0 over 2 second cycle)
    local elapsed = GetGameTimeSeconds() - readyPulseStartTime
    local cycleTime = 2.0  -- 2 seconds for full cycle (1s each direction)
    local t = (elapsed % cycleTime) / cycleTime  -- 0 to 1
    -- Convert to ping-pong (0 to 1 to 0)
    local pulseT = t < 0.5 and (t * 2) or (2 - t * 2)
    
    -- Interpolate between ready and cooldown colors
    local readyColor = savedVars.readyColor or {0, 1, 0, 1}
    local cooldownColor = savedVars.cooldownColor or {1, 0.3, 0.3, 1}
    local color = LerpColor(readyColor, cooldownColor, pulseT)
    
    if statusLabel then
        statusLabel:SetColor(color[1], color[2], color[3], 1)
    end
end

local function StartReadyFlash()
    -- Only start if conditions are met
    if isInCombat and hasWarmaskBuff and not isCountdownActive then
        readyPulseStartTime = GetGameTimeSeconds()
        EM:UnregisterForUpdate(WM.name .. "ReadyFlash")
        EM:RegisterForUpdate(WM.name .. "ReadyFlash", 50, UpdateReadyPulse)
    end
end

local function StopReadyFlash()
    EM:UnregisterForUpdate(WM.name .. "ReadyFlash")
    if statusLabel then
        local readyColor = savedVars.readyColor or {0, 1, 0, 1}
        statusLabel:SetColor(readyColor[1], readyColor[2], readyColor[3], 1)
    end
end

-- =============================================================================
-- COUNTDOWN PULSE (below 10s) - pulses target name
-- =============================================================================
local countdownPulseStartTime = 0

local function UpdateCountdownPulse()
    if not isCountdownActive then
        EM:UnregisterForUpdate(WM.name .. "CountdownFlash")
        countdownFlashActive = false
        return
    end
    
    local remaining = countdownEndTime - GetGameTimeSeconds()
    
    -- Only pulse when below 10 seconds
    if remaining >= 10 or remaining <= 0 then
        EM:UnregisterForUpdate(WM.name .. "CountdownFlash")
        countdownFlashActive = false
        -- Reset to ready color
        if statusLabel then
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            statusLabel:SetColor(readyColor[1], readyColor[2], readyColor[3], 1)
        end
        return
    end
    
    -- Calculate pulse position (0 to 1 to 0 over 2 second cycle)
    local elapsed = GetGameTimeSeconds() - countdownPulseStartTime
    local cycleTime = 2.0  -- 2 seconds for full cycle (1s each direction)
    local t = (elapsed % cycleTime) / cycleTime  -- 0 to 1
    -- Convert to ping-pong (0 to 1 to 0)
    local pulseT = t < 0.5 and (t * 2) or (2 - t * 2)
    
    -- Interpolate between ready and cooldown colors
    local readyColor = savedVars.readyColor or {0, 1, 0, 1}
    local cooldownColor = savedVars.cooldownColor or {1, 0.3, 0.3, 1}
    local color = LerpColor(readyColor, cooldownColor, pulseT)
    
    if statusLabel then
        statusLabel:SetColor(color[1], color[2], color[3], 1)
    end
end

local function StartCountdownFlash()
    -- Only start if not already running
    if countdownFlashActive then return end
    
    countdownFlashActive = true
    countdownPulseStartTime = GetGameTimeSeconds()
    EM:UnregisterForUpdate(WM.name .. "CountdownFlash")
    EM:RegisterForUpdate(WM.name .. "CountdownFlash", 50, UpdateCountdownPulse)
end

local function StopCountdownFlash()
    EM:UnregisterForUpdate(WM.name .. "CountdownFlash")
    countdownFlashActive = false
    -- Reset to ready color
    if statusLabel and isCountdownActive then
        local readyColor = savedVars.readyColor or {0, 1, 0, 1}
        statusLabel:SetColor(readyColor[1], readyColor[2], readyColor[3], 1)
    end
end

-- =============================================================================
-- EQUIPMENT DETECTION
-- =============================================================================
local function IsWarmaskEquipped()
    -- Huntsman's Warmask is a mythic item that only goes in the head slot
    local itemLink = GetItemLink(BAG_WORN, EQUIP_SLOT_HEAD, LINK_STYLE_DEFAULT)
    if itemLink and itemLink ~= "" then
        local itemName = GetItemLinkName(itemLink)
        local itemId = GetItemLinkItemId(itemLink)
        if itemId then
            if savedVars and savedVars.enableDebug and itemName then
                Debug("Head slot item: " .. itemName)
            end
            
            if itemId == WARMASK_ITEM_ID then
                Debug("Huntsman's Warmask mythic detected in head slot")
                return true
            end
        end
    end
    
    if savedVars and savedVars.enableDebug then
        Debug("Huntsman's Warmask not found in head slot")
    end
    return false
end

-- =============================================================================
-- BUFF DETECTION (for fallback/verification)
-- =============================================================================
local function HasWarmaskBuff()
    for i = 1, GetNumBuffs("player") do
        local _, _, _, _, _, _, _, _, _, _, abilityId = GetUnitBuffInfo("player", i)
        if abilityId == WARMASK_BUFF_ID then
            return true
        end
    end
    return false
end

local function CheckWarmaskStatus()
    local hadEquipped = hasWarmaskBuff
    
    -- Check if mythic is equipped in head slot
    local isMythicEquipped = IsWarmaskEquipped()
    
    -- Set status based only on equipment detection
    hasWarmaskBuff = isMythicEquipped
    
    if hasWarmaskBuff then
        if not hadEquipped then
            Debug(WM.LS("DEBUG_WARMASK_EQUIPPED"))
            WM.Log("Warmask equipped", "00FF00")  -- Green color
        end
        ShowUI()
        if not isCountdownActive then
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            UpdateStatusText(GetBashText(), readyColor[1], readyColor[2], readyColor[3])
            UpdateCountdownOnIcon(0)  -- Hide countdown on icon
        end
    else
        if hadEquipped then
            Debug(WM.LS("DEBUG_WARMASK_UNEQUIPPED"))
            WM.Log("Warmask un-equipped")  -- Default color
        end
        HideUI()
        -- Reset state when mythic is unequipped
        isCountdownActive = false
        markedUnitId = nil
        markedUnitName = nil
        WM.RemoveLine()
    end
    
    return hasWarmaskBuff
end

-- =============================================================================
-- COUNTDOWN TIMER
-- =============================================================================
local function UpdateCountdown()
    if not isCountdownActive then
        EM:UnregisterForUpdate(WM.name .. "Countdown")
        return
    end
    
    local remaining = countdownEndTime - GetGameTimeSeconds()
    
    if remaining <= 0 then
        -- Countdown finished
        isCountdownActive = false
        markedUnitId = nil
        markedUnitName = nil
        EM:UnregisterForUpdate(WM.name .. "Countdown")
        EM:UnregisterForUpdate(WM.name .. "LineUpdate")
        StopCountdownFlash()
        WM.RemoveLine()
        
        -- Clear countdown from icon
        UpdateCountdownOnIcon(0)
        
        if hasWarmaskBuff then
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            UpdateStatusText(GetBashText(), readyColor[1], readyColor[2], readyColor[3])
            
            -- Start flashing again if still in combat
            if isInCombat then
                StartReadyFlash()
            end
        end
        return
    end
    
    -- Start countdown flash when below 10 seconds
    if remaining < 10 then
        StartCountdownFlash()
    else
        StopCountdownFlash()
    end
    
    -- Update unit name in status label with color based on remaining time
    local displayName = markedUnitName or WM.LS("TARGET")
    local cooldownColor = savedVars.cooldownColor or {1, 0.3, 0.3, 1}
    local readyColor = savedVars.readyColor or {0, 1, 0, 1}
    
    if remaining > 50 then
        -- Cooldown period (60s to 50s)
        UpdateStatusText(displayName, cooldownColor[1], cooldownColor[2], cooldownColor[3])
        UpdateCountdownOnIcon(remaining, cooldownColor[1], cooldownColor[2], cooldownColor[3])
    else
        -- Ready period (49s and lower)
        -- Only update status text color if not in flash mode (below 10s)
        if remaining >= 10 then
            UpdateStatusText(displayName, readyColor[1], readyColor[2], readyColor[3])
        else
            -- Just update the text, flash handles the color
            if statusLabel then
                statusLabel:SetText(displayName)
            end
        end
        UpdateCountdownOnIcon(remaining, readyColor[1], readyColor[2], readyColor[3])
    end
end

local function StartCountdown(unitName, unitId)
    -- Stop ready flash when countdown starts
    StopReadyFlash()
    
    -- Unregister any existing countdown update first
    EM:UnregisterForUpdate(WM.name .. "Countdown")
    EM:UnregisterForUpdate(WM.name .. "LineUpdate")
    
    markedUnitName = zo_strformat("<<1>>", unitName)
    markedUnitId = unitId
    countdownEndTime = GetGameTimeSeconds() + COUNTDOWN_DURATION
    isCountdownActive = true
    
    -- Ensure UI is visible and shown
    if hasWarmaskBuff then
        ShowUI()
        -- Force UI to be visible
        if mainWindow then
            mainWindow:SetHidden(false)
        end
    end
    
    -- Calculate initial remaining time and update immediately
    local remaining = countdownEndTime - GetGameTimeSeconds()
    local cooldownColor = savedVars.cooldownColor or {1, 0.3, 0.3, 1}
    local readyColor = savedVars.readyColor or {0, 1, 0, 1}
    
    -- Update status text and countdown with appropriate color immediately
    -- When starting from ready state, remaining will be 60s (cooldown period)
    if remaining > 50 then
        -- Cooldown period (60s to 50s)
        UpdateStatusText(markedUnitName, cooldownColor[1], cooldownColor[2], cooldownColor[3])
        UpdateCountdownOnIcon(remaining, cooldownColor[1], cooldownColor[2], cooldownColor[3])
    else
        -- Ready period (49s and lower)
        UpdateStatusText(markedUnitName, readyColor[1], readyColor[2], readyColor[3])
        UpdateCountdownOnIcon(remaining, readyColor[1], readyColor[2], readyColor[3])
    end
    
    -- Force status label to be visible and updated - explicitly set text multiple times
    if statusLabel then
        -- Set text directly to ensure it updates immediately
        statusLabel:SetText(markedUnitName)
        statusLabel:SetColor(cooldownColor[1], cooldownColor[2], cooldownColor[3], 1)
        statusLabel:SetHidden(false)
        statusLabel:SetAlpha(1)
        -- Force update by setting text again
        statusLabel:SetText(markedUnitName)
    end
    
    -- Force countdown label to be visible
    if countdownLabel then
        countdownLabel:SetHidden(false)
    end
    
    -- Force one more immediate update to ensure target name is displayed correctly
    -- This ensures the text updates even if UpdateCountdown hasn't run yet
    zo_callLater(function()
        if isCountdownActive and markedUnitName then
            local remaining = countdownEndTime - GetGameTimeSeconds()
            local cooldownColor = savedVars.cooldownColor or {1, 0.3, 0.3, 1}
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            if remaining > 50 then
                UpdateStatusText(markedUnitName, cooldownColor[1], cooldownColor[2], cooldownColor[3])
            else
                UpdateStatusText(markedUnitName, readyColor[1], readyColor[2], readyColor[3])
            end
            -- Also set directly one more time
            if statusLabel then
                statusLabel:SetText(markedUnitName)
            end
        end
    end, 10)
    
    -- Register update for continuous countdown
    EM:RegisterForUpdate(WM.name .. "Countdown", 100, UpdateCountdown)
    
    -- Call UpdateCountdown immediately to sync everything
    UpdateCountdown()
    
    -- Register update for line drawing (more frequent updates for smoother line)
    if savedVars.enableLine then
        EM:RegisterForUpdate(WM.name .. "LineUpdate", 50, function()
            if isCountdownActive and DoesUnitExist("reticleover") then
                -- Check if target has mark debuff
                local targetHasMark = false
                for i = 1, GetNumBuffs("reticleover") do
                    local _, _, _, _, _, _, _, _, _, _, abilityId = GetUnitBuffInfo("reticleover", i)
                    if abilityId == MARK_OF_HIRCINE_ID then
                        targetHasMark = true
                        break
                    end
                end
                if targetHasMark then
                    WM.DrawLineToTarget()
                else
                    WM.RemoveLine()
                end
            else
                WM.RemoveLine()
            end
        end)
    end
    
    -- Call UpdateCountdown immediately to sync everything
    UpdateCountdown()
    
    -- Also call with small delay to catch any timing issues
    zo_callLater(function()
        UpdateCountdown()
    end, 50)
end

-- =============================================================================
-- BASH DETECTION
-- =============================================================================
-- EVENT_COMBAT_EVENT parameters:
-- (eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType,
--  sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType,
--  log, sourceUnitId, targetUnitId, abilityId)
local function OnCombatEvent(_, result, isError, _, _, _, sourceName, sourceType, targetName, targetType, _, _, _, _, sourceUnitId, targetUnitId, abilityId)
    -- Debug: Log all bash ability events (only when Warmask equipped and debug enabled)
    if savedVars and savedVars.enableDebug and hasWarmaskBuff then
        d(string.format("[Warmask] Bash event received - abilityId: %s, result: %s, sourceType: %s, target: %s", 
            tostring(abilityId), tostring(result), tostring(sourceType), targetName or "unknown"))
    end
    
    -- Re-check Warmask status if not set (handles race condition where bash happens before status is checked)
    if not hasWarmaskBuff then
        CheckWarmaskStatus()
        -- If still not equipped after re-check, ignore this bash
        if not hasWarmaskBuff then
            if savedVars and savedVars.enableDebug then
                d("[Warmask] Bash event ignored - Warmask not equipped")
            end
            return
        end
    end
    
    -- Check if this is a successful bash from the player
    if sourceType ~= COMBAT_UNIT_TYPE_PLAYER then
        if savedVars and savedVars.enableDebug and hasWarmaskBuff then
            d(string.format("[Warmask] Bash event ignored - not from player (sourceType: %s)", tostring(sourceType)))
        end
        return
    end
    -- Accept multiple result types for bashes:
    -- ACTION_RESULT_DAMAGE (1) - successful bash
    -- ACTION_RESULT_BLOCKED_DAMAGE (2151) - blocked bash  
    -- ACTION_RESULT_MISS (2) - missed bash (may still apply mark in some cases)
    -- We'll accept damage, blocked, and miss as valid bash attempts
    local isAcceptedResult = (result == ACTION_RESULT_DAMAGE) or (result == ACTION_RESULT_BLOCKED_DAMAGE) or (result == 2)
    if not isAcceptedResult then
        if savedVars and savedVars.enableDebug and hasWarmaskBuff then
            d(string.format("[Warmask] Bash event ignored - result type not accepted (result: %s, accepted: 1, 2, or 2151)", 
                tostring(result)))
        end
        return
    end
    
    -- Now we know it's a bash - check cooldown and log
    -- Allow if ready state (no countdown) OR 10+ seconds have passed since last bash
    local canStartCountdown = true
    local targetDisplayName = targetName or "unknown"
    local formattedTargetName = targetName and zo_strformat("<<1>>", targetName) or targetDisplayName
    local reason = nil
    
    if isCountdownActive then
        local remaining = countdownEndTime - GetGameTimeSeconds()
        
        -- Only allow if 10+ seconds have passed (countdown <= 50 seconds remaining)
        if remaining > (COUNTDOWN_DURATION - INTERNAL_COOLDOWN) then
            -- Less than 10 seconds have passed, ignore this bash
            reason = string.format("cooldown active (%.1fs remaining, need 10s)", remaining)
            canStartCountdown = false
        end
    end
    
    if canStartCountdown then
        -- Check if unit changed
        local unitChanged = true
        if markedUnitName then
            unitChanged = (formattedTargetName ~= markedUnitName)
        end
        
        if unitChanged then
            Debug(string.format("Bash registered - unit changed: '%s' -> '%s'", 
                markedUnitName or "none", formattedTargetName))
        else
            Debug(string.format("Bash registered - same unit: '%s' (countdown restarted)", formattedTargetName))
        end
        
        StartCountdown(targetName, targetUnitId)
    else
        -- Bash not registered - show why
        Debug(string.format("Bash NOT registered for '%s' - %s", targetDisplayName, reason or "unknown reason"))
    end
end

-- =============================================================================
-- TARGET CHANGE - LINE DRAWING
-- =============================================================================
local function OnReticleTargetChanged()
    if not savedVars.enableLine then
        WM.RemoveLine()
        return
    end
    
    if not isCountdownActive or not markedUnitId then
        WM.RemoveLine()
        return
    end
    
    if not DoesUnitExist("reticleover") then
        WM.RemoveLine()
        return
    end
    
    -- Get the reticle target's name to compare with the marked target
    -- Name matching is the primary identifier since we can't get unit ID from unit tags
    local reticleTargetName = GetUnitDisplayName("reticleover")
    if not reticleTargetName or reticleTargetName == "" then
        reticleTargetName = GetUnitName("reticleover")
    end
    local formattedReticleName = reticleTargetName and zo_strformat("<<1>>", reticleTargetName) or nil
    
    -- Check if the reticle target name matches the marked target name
    -- This is the primary check - we track by name, so name must match
    local nameMatches = formattedReticleName and markedUnitName and formattedReticleName == markedUnitName
    
    if nameMatches then
        -- Name matches, draw the line
        -- Note: We can't verify unit ID match since GetUnitId doesn't exist,
        -- so if there are multiple enemies with the same name, we can't distinguish them.
        -- The debuff check is unreliable since others can apply it too.
        WM.DrawLineToTarget()
    else
        -- Name doesn't match, don't draw line
        WM.RemoveLine()
    end
end

-- =============================================================================
-- EFFECT CHANGED - BUFF TRACKING
-- =============================================================================
local function OnEffectChanged(_, changeType, _, _, unitTag, _, _, _, _, _, _, _, _, _, abilityId)
    if unitTag ~= "player" then return end
    if abilityId ~= WARMASK_BUFF_ID then return end
    
    -- Only log Warmask buff changes (not all effect changes)
    if changeType == EFFECT_RESULT_GAINED then
        CheckWarmaskStatus()
    elseif changeType == EFFECT_RESULT_FADED then
        CheckWarmaskStatus()
    end
end

-- =============================================================================
-- COMBAT STATE
-- =============================================================================
local function OnCombatState(_, inCombat)
    isInCombat = inCombat
    
    if inCombat then
        CheckWarmaskStatus()
        -- Start flashing if in ready state
        if hasWarmaskBuff and not isCountdownActive then
            StartReadyFlash()
        end
    else
        -- Stop flashing when leaving combat
        StopReadyFlash()
        
        -- Stop countdown and return to ready state when combat ends
        if isCountdownActive then
            isCountdownActive = false
            markedUnitId = nil
            markedUnitName = nil
            EM:UnregisterForUpdate(WM.name .. "Countdown")
            EM:UnregisterForUpdate(WM.name .. "LineUpdate")
            WM.RemoveLine()
            UpdateCountdownOnIcon(0)
            
            if hasWarmaskBuff then
                local readyColor = savedVars.readyColor or {0, 1, 0, 1}
                UpdateStatusText(GetBashText(), readyColor[1], readyColor[2], readyColor[3])
            end
        end
        
        -- Check if we should hide icon when out of combat
        if savedVars and savedVars.hideIconOutOfCombat and hasWarmaskBuff then
            HideUI()
        else
            CheckWarmaskStatus()
        end
    end
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================
function WM.Initialize()
    -- Load saved variables
    savedVars = ZO_SavedVars:NewAccountWide("WarMaskSV", 1, nil, WM.defaults)
    WM.savedVars = savedVars
    
    -- Initialize combat state
    isInCombat = IsUnitInCombat("player")
    
    -- Debug: Addon initialized
    if savedVars.enableDebug then
        d("[Warmask] " .. WM.LS("DEBUG_ADDON_INITIALIZED", WM.version))
        d("[Warmask] " .. WM.LS("DEBUG_MODE_ENABLED"))
    end
    
    -- Create UI
    CreateUI()
    
    -- Register events
    -- Player activated - fires when player is fully loaded (login, zone change, etc.)
    -- This ensures we check equipment after login/zone changes
    EM:RegisterForEvent(WM.name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, function()
        -- Delay slightly to ensure equipment is fully loaded
        zo_callLater(function()
            CheckWarmaskStatus()
        end, 100)
    end)
    
    -- Equipment change event to detect when set is equipped/unequipped
    EM:RegisterForEvent(WM.name .. "Equipment", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(_, bagId, slotIndex)
        if bagId == BAG_WORN then
            CheckWarmaskStatus()
        end
    end)
    
    -- Keep effect changed for additional verification (optional)
    EM:RegisterForEvent(WM.name, EVENT_EFFECT_CHANGED, OnEffectChanged)
    EM:AddFilterForEvent(WM.name, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, "player")
    
    EM:RegisterForEvent(WM.name .. "Combat", EVENT_COMBAT_EVENT, OnCombatEvent)
    EM:AddFilterForEvent(WM.name .. "Combat", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, BASH_ABILITY_ID)
    
    EM:RegisterForEvent(WM.name .. "CombatState", EVENT_PLAYER_COMBAT_STATE, OnCombatState)
    EM:RegisterForEvent(WM.name .. "Target", EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged)
    
    -- Debug: Events registered
    Debug(WM.LS("DEBUG_EVENTS_REGISTERED"))
    
    -- Initial check (this will show/hide UI based on Warmask detection)
    CheckWarmaskStatus()
    
    -- Build settings menu
    WM.BuildMenu()
    
    -- Create line rendering system
    WM.CreateLineUI()
    
    -- Expose countdown state to Line.lua for color determination
    WM.isCountdownActive = function() return isCountdownActive end
    WM.countdownEndTime = function() return countdownEndTime end
    WM.markedUnitId = function() return markedUnitId end
    -- Expose warmask equipped status for settings panel
    WM.IsWarmaskEquipped = IsWarmaskEquipped
    -- Expose function to update ready text (for roleplaying mode changes)
    WM.UpdateReadyText = function()
        if hasWarmaskBuff and not isCountdownActive and statusLabel then
            local readyColor = savedVars.readyColor or {0, 1, 0, 1}
            UpdateStatusText(GetBashText(), readyColor[1], readyColor[2], readyColor[3])
        end
    end
    
    -- Re-check Warmask status after a short delay (equipment might not be loaded yet)
    zo_callLater(function()
        CheckWarmaskStatus()
        -- Ensure position is maintained even if UI was hidden
        if mainWindow and savedVars and savedVars.position then
            local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
            if not offsetX or not offsetY or 
               math.abs(offsetX - savedVars.position.x) > 1 or 
               math.abs(offsetY - savedVars.position.y) > 1 then
                mainWindow:ClearAnchors()
                mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x, savedVars.position.y)
                Debug("Position restored after delayed check: " .. savedVars.position.x .. ", " .. savedVars.position.y)
            end
        end
    end, 500)
    
    -- Debug: Show final state
    if savedVars.enableDebug then
        d("[Warmask] Initialization complete - UI visible: " .. tostring(mainWindow and not mainWindow:IsHidden() or false))
        if mainWindow then
            local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
            d("[Warmask] Window position after init: x=" .. (offsetX or "nil") .. ", y=" .. (offsetY or "nil"))
        end
    end
    
    Debug(WM.LS("DEBUG_ADDON_COMPLETE"))
end

local function OnAddOnLoaded(_, addonName)
    if addonName ~= WM.name then return end
    EM:UnregisterForEvent(WM.name, EVENT_ADD_ON_LOADED)
    WM.Initialize()
    
    -- Debug: Addon loaded
    if savedVars and savedVars.enableDebug then
        d("[Warmask] " .. WM.LS("DEBUG_ADDON_LOADED", WM.version))
    end
end

EM:RegisterForEvent(WM.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

-- =============================================================================
-- SLASH COMMANDS
-- =============================================================================
SLASH_COMMANDS["/warmask"] = function()
    if mainWindow then
        local isHidden = mainWindow:IsHidden()
        mainWindow:SetHidden(not isHidden)
        d("[Warmask] UI " .. (isHidden and WM.LS("SLASH_UI_SHOWN") or WM.LS("SLASH_UI_HIDDEN")))
    end
end

SLASH_COMMANDS["/wmdebug"] = function()
    d("[Warmask] " .. WM.LS("SLASH_DEBUG_INFO"))
    d("  " .. WM.LS("SLASH_DEBUG_WARMASK_EQUIPPED", tostring(IsWarmaskEquipped())))
    d("  " .. WM.LS("SLASH_DEBUG_WARMASK_BUFF", tostring(HasWarmaskBuff())))
    d("  " .. WM.LS("SLASH_DEBUG_UI_SHOULD_SHOW", tostring(hasWarmaskBuff)))
    d("  " .. WM.LS("SLASH_DEBUG_UI_HIDDEN", tostring(mainWindow and mainWindow:IsHidden() or "nil")))
    d("  " .. WM.LS("SLASH_DEBUG_COUNTDOWN_ACTIVE", tostring(isCountdownActive)))
    d("  " .. WM.LS("SLASH_DEBUG_MARKED_UNIT", tostring(markedUnitName)))
    if isCountdownActive then
        d("  " .. WM.LS("SLASH_DEBUG_REMAINING", countdownEndTime - GetGameTimeSeconds()))
    end
    if savedVars and savedVars.position then
        d("  " .. WM.LS("SLASH_DEBUG_POSITION_SAVED", savedVars.position.x, savedVars.position.y))
    else
        d("  " .. WM.LS("SLASH_DEBUG_POSITION_NOT_SET"))
    end
    if mainWindow then
        local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
        d("  " .. WM.LS("SLASH_DEBUG_POSITION_CURRENT", offsetX or "nil", offsetY or "nil"))
        d("  " .. WM.LS("SLASH_DEBUG_WINDOW_MOVABLE", tostring(mainWindow:IsMovable())))
        d("  " .. WM.LS("SLASH_DEBUG_LOCK_POSITION", tostring(savedVars and savedVars.lockPosition or "nil")))
    end
    d("  " .. WM.LS("SLASH_DEBUG_ENABLE_DEBUG"))
end

SLASH_COMMANDS["/wmtest"] = function()
    d("[Warmask] " .. WM.LS("SLASH_TEST_MYTHIC"))
    local itemLink = GetItemLink(BAG_WORN, EQUIP_SLOT_HEAD)
    if itemLink and itemLink ~= "" then
        local itemName = GetItemLinkName(itemLink)
        d("  " .. WM.LS("SLASH_TEST_HEAD_SLOT", itemName or "Unknown"))
        d("  " .. WM.LS("SLASH_TEST_ITEM_LINK", itemLink))
        
        local isWarmask = IsWarmaskEquipped()
        d("  " .. WM.LS("SLASH_TEST_IS_WARMASK", tostring(isWarmask)))
        d("  " .. WM.LS("SLASH_TEST_LOOKING_FOR", WARMASK_ITEM_NAME))
    else
        d("  " .. WM.LS("SLASH_TEST_HEAD_EMPTY"))
    end
end

SLASH_COMMANDS["/wmpos"] = function()
    d("[Warmask] " .. WM.LS("SLASH_POS_INFO"))
    if savedVars and savedVars.position then
        d("  " .. WM.LS("SLASH_DEBUG_POSITION_SAVED", savedVars.position.x, savedVars.position.y))
    else
        d("  " .. WM.LS("SLASH_DEBUG_POSITION_NOT_SET"))
    end
    if mainWindow then
        local point, relativeTo, relativePoint, offsetX, offsetY = mainWindow:GetAnchor()
        d("  " .. WM.LS("SLASH_POS_ANCHOR"))
        d("    " .. WM.LS("SLASH_POS_POINT", tostring(point)))
        d("    " .. WM.LS("SLASH_POS_RELATIVE_TO", tostring(relativeTo)))
        d("    " .. WM.LS("SLASH_POS_RELATIVE_POINT", tostring(relativePoint)))
        d("    " .. WM.LS("SLASH_POS_OFFSET_X", offsetX or "nil"))
        d("    " .. WM.LS("SLASH_POS_OFFSET_Y", offsetY or "nil"))
        d("  " .. WM.LS("SLASH_POS_WINDOW_HIDDEN", tostring(mainWindow:IsHidden())))
        d("  " .. WM.LS("SLASH_POS_WINDOW_MOVABLE", tostring(mainWindow:IsMovable())))
        
        -- Test setting position
        if savedVars and savedVars.position then
            d("  " .. WM.LS("SLASH_POS_TEST_RESTORE"))
            mainWindow:ClearAnchors()
            mainWindow:SetAnchor(CENTER, GuiRoot, CENTER, savedVars.position.x, savedVars.position.y)
            local point2, relativeTo2, relativePoint2, offsetX2, offsetY2 = mainWindow:GetAnchor()
            d("  " .. WM.LS("SLASH_POS_AFTER_RESTORE", offsetX2 or "nil", offsetY2 or "nil"))
            if offsetX2 and offsetY2 then
                local diffX = math.abs(offsetX2 - savedVars.position.x)
                local diffY = math.abs(offsetY2 - savedVars.position.y)
                d("  " .. WM.LS("SLASH_POS_DIFFERENCE", diffX, diffY))
            end
        end
    else
        d("  " .. WM.LS("SLASH_POS_WINDOW_NOT_CREATED"))
    end
end





