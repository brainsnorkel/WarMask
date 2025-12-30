-- =============================================================================
-- Warmask Settings Menu (LibAddonMenu-2.0)
-- Author: @brainsnorkel
-- Year: 2025
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask
local LAM = LibAddonMenu2

-- =============================================================================
-- MENU CONSTRUCTION
-- =============================================================================
function WM.BuildMenu()
    if not LAM then
        d("[Warmask] " .. (WM.LS and WM.LS("SETTINGS_LAM_NOT_FOUND") or "LibAddonMenu-2.0 not found. Settings menu unavailable."))
        return
    end
    
    local panel = {
        type = "panel",
        name = "Warmask",
        displayName = WM.LS and WM.LS("SETTINGS_PANEL_DISPLAY") or "|cFFD700Warmask|r",
        author = "@brainsnorkel",
        version = WM.version,
        registerForRefresh = true,
    }
    
    LAM:RegisterAddonPanel(WM.name .. "Menu", panel)
    
    local options = {
        -- Help Text Header
        {
            type = "header",
            name = WM.LS and WM.LS("SETTINGS_HEADER_HOW_IT_WORKS") or "How It Works",
        },
        {
            type = "description",
            text = WM.LS and WM.LS("SETTINGS_DESC_MAIN") or "Displays a tracking icon when Huntsman's Warmask is equipped. Shows a 60-second countdown after bashing a target.",
            width = "full",
        },
        {
            type = "description",
            text = WM.LS and WM.LS("SETTINGS_DESC_STATES") or "|c00FF00Ready|r - Bash a target to start tracking. The tracked target will change to whatever you bash.\n|cFF4D4DCooldown|r (60s-50s) - Internal cooldown active. Bashing will NOT change the tracked target.\n|c00FF00Countdown|r (49s-0s) - Ready to bash a new target. Bashing will update the tracked target.",
            width = "full",
        },
        {
            type = "description",
            text = WM.LS and WM.LS("SETTINGS_DESC_TRACKING") or "The tracked target's name is displayed next to the icon. Countdown resets to Ready when it expires or combat ends.",
            width = "full",
        },
        
        -- Divider
        {
            type = "divider",
            alpha = 0.5,
        },
        
        -- Position Settings
        {
            type = "header",
            name = WM.LS and WM.LS("SETTINGS_HEADER_ICON") or "Icon Settings",
        },
        {
            type = "checkbox",
            name = WM.LS and WM.LS("SETTINGS_LOCK_POSITION") or "Lock Icon Position",
            tooltip = WM.LS and WM.LS("SETTINGS_LOCK_POSITION_TOOLTIP") or "When enabled, the icon cannot be moved. Disable to drag the icon to a new position.",
            getFunc = function() return WM.savedVars.lockPosition end,
            setFunc = function(value)
                WM.savedVars.lockPosition = value
                -- Immediately update the window's movable state
                if WM.UpdateLockState then
                    WM.UpdateLockState()
                end
                -- When unlocking position, disable hideIconOutOfCombat so icon can be moved
                if not value then
                    WM.savedVars.hideIconOutOfCombat = false
                    -- Show the icon if warmask is equipped
                    local win = WINDOW_MANAGER:GetControlByName(WM.name .. "Window")
                    if win then
                        -- Check if warmask is equipped
                        local isEquipped = false
                        if WM.IsWarmaskEquipped and type(WM.IsWarmaskEquipped) == "function" then
                            local success, result = pcall(WM.IsWarmaskEquipped)
                            if success then
                                isEquipped = result
                            end
                        end
                        if isEquipped then
                            win:SetHidden(false)
                        end
                    end
                end
            end,
            width = "full",
        },
        {
            type = "checkbox",
            name = WM.LS and WM.LS("SETTINGS_HIDE_OUT_OF_COMBAT") or "Hide Icon Out of Combat",
            tooltip = WM.LS and WM.LS("SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP") or "When enabled, the icon will be hidden when you are not in combat. The icon will automatically appear when you enter combat.",
            getFunc = function() return WM.savedVars.hideIconOutOfCombat or false end,
            setFunc = function(value)
                WM.savedVars.hideIconOutOfCombat = value
                -- Immediately update UI visibility based on combat state
                local win = WINDOW_MANAGER:GetControlByName(WM.name .. "Window")
                if not win then return end
                
                -- Check if warmask is equipped
                local isEquipped = false
                if WM.IsWarmaskEquipped and type(WM.IsWarmaskEquipped) == "function" then
                    local success, result = pcall(WM.IsWarmaskEquipped)
                    if success then
                        isEquipped = result
                    end
                end
                
                if not isEquipped then
                    -- Warmask not equipped, hide icon
                    win:SetHidden(true)
                    return
                end
                
                -- Warmask is equipped, check setting and combat state
                if value then
                    -- Setting enabled - hide if out of combat, show if in combat
                    if IsUnitInCombat("player") then
                        win:SetHidden(false)
                    else
                        win:SetHidden(true)
                    end
                else
                    -- Setting disabled - always show
                    win:SetHidden(false)
                end
            end,
            width = "full",
        },
        {
            type = "button",
            name = WM.LS and WM.LS("SETTINGS_RESET_POSITION") or "Reset Icon Position",
            tooltip = WM.LS and WM.LS("SETTINGS_RESET_POSITION_TOOLTIP") or "Reset the icon to the center of the screen.",
            func = function()
                WM.savedVars.position = { x = 0, y = 128 }
                -- Update window position immediately
                local win = WINDOW_MANAGER:GetControlByName(WM.name .. "Window")
                if win then
                    win:ClearAnchors()
                    win:SetAnchor(CENTER, GuiRoot, CENTER, 0, 128)
                    -- SavedVariables are automatically saved
                    d("[Warmask] " .. (WM.LS and WM.LS("SETTINGS_POSITION_RESET") or "Icon position reset to center (saved to SavedVariables)"))
                end
            end,
            width = "half",
        },
        {
            type = "slider",
            name = WM.LS and WM.LS("SETTINGS_ICON_SCALE") or "Icon Scale",
            tooltip = WM.LS and WM.LS("SETTINGS_ICON_SCALE_TOOLTIP") or "Adjust the size of the icon. Range: 50% to 200%.",
            min = 50,
            max = 200,
            step = 5,
            getFunc = function() return WM.savedVars.iconScale or 100 end,
            setFunc = function(value)
                WM.savedVars.iconScale = value
                WM.ApplyUIScaling()
                d("[Warmask] " .. (WM.LS and WM.LS("SETTINGS_ICON_SCALE_SET", value) or ("Icon scale set to " .. value .. "%")))
            end,
            width = "full",
        },
        {
            type = "slider",
            name = WM.LS and WM.LS("SETTINGS_FONT_SCALE") or "Font Scale",
            tooltip = WM.LS and WM.LS("SETTINGS_FONT_SCALE_TOOLTIP") or "Adjust the size of the text and countdown timer. Range: 50% to 400%.",
            min = 50,
            max = 400,
            step = 10,
            getFunc = function() return WM.savedVars.fontScale or 100 end,
            setFunc = function(value)
                WM.savedVars.fontScale = value
                WM.ApplyUIScaling()
                d("[Warmask] " .. (WM.LS and WM.LS("SETTINGS_FONT_SCALE_SET", value) or ("Font scale set to " .. value .. "%")))
            end,
            width = "full",
        },
        {
            type = "dropdown",
            name = WM.LS and WM.LS("SETTINGS_FONT_FAMILY") or "Font Family",
            tooltip = WM.LS and WM.LS("SETTINGS_FONT_FAMILY_TOOLTIP") or "Select the font family to use for the addon text.",
            choices = {"Univers67", "ProseAntiquePSMT"},
            choicesValues = {"Univers67", "ProseAntiquePSMT"},
            getFunc = function() return WM.savedVars.fontFamily or "Univers67" end,
            setFunc = function(value)
                WM.savedVars.fontFamily = value
                WM.ApplyUIScaling()
                d("[Warmask] " .. (WM.LS and WM.LS("SETTINGS_FONT_FAMILY_SET", value) or ("Font family set to " .. value)))
            end,
            width = "full",
        },
        {
            type = "checkbox",
            name = WM.LS and WM.LS("SETTINGS_ROLEPLAYING_MODE") or "Roleplaying Mode",
            tooltip = WM.LS and WM.LS("SETTINGS_ROLEPLAYING_MODE_TOOLTIP") or "When enabled, changes 'Bash something' to 'Bash, thou must' for a more immersive roleplaying experience.",
            getFunc = function() return WM.savedVars.roleplayingMode or false end,
            setFunc = function(value)
                WM.savedVars.roleplayingMode = value
                -- Update the status text immediately if warmask is equipped and in ready state
                if WM.UpdateReadyText then
                    WM.UpdateReadyText()
                end
            end,
            width = "full",
        },
        
        -- Divider
        {
            type = "divider",
            alpha = 0.5,
        },
        
        -- Line Settings
        {
            type = "header",
            name = WM.LS and WM.LS("SETTINGS_HEADER_LINE") or "Line Settings",
        },
        {
            type = "checkbox",
            name = WM.LS and WM.LS("SETTINGS_ENABLE_LINE") or "Enable Line to Target",
            tooltip = WM.LS and WM.LS("SETTINGS_ENABLE_LINE_TOOLTIP") or "Draw a line from your character to the marked target when looking at them.",
            getFunc = function() return WM.savedVars.enableLine end,
            setFunc = function(value)
                WM.savedVars.enableLine = value
                if not value then
                    WM.RemoveLine()
                end
            end,
            width = "full",
        },
        
        -- Divider
        {
            type = "divider",
            alpha = 0.5,
        },
        
        -- Debug Settings
        {
            type = "header",
            name = WM.LS and WM.LS("SETTINGS_HEADER_DEBUG") or "Debug Settings",
        },
        {
            type = "checkbox",
            name = WM.LS and WM.LS("SETTINGS_ENABLE_DEBUG") or "Enable Debug Information",
            tooltip = WM.LS and WM.LS("SETTINGS_ENABLE_DEBUG_TOOLTIP") or "When enabled, displays debug messages in chat for addon loading, buff detection, events, and bash detections with unit names.",
            getFunc = function() return WM.savedVars.enableDebug end,
            setFunc = function(value)
                WM.savedVars.enableDebug = value
                if value then
                    d("[Warmask] " .. (WM.LS and WM.LS("DEBUG_MODE_ENABLED") or "Debug mode enabled"))
                else
                    d("[Warmask] " .. (WM.LS and WM.LS("DEBUG_MODE_DISABLED") or "Debug mode disabled"))
                end
            end,
            width = "full",
        },
        
        -- Divider
        {
            type = "divider",
            alpha = 0.5,
        },
        
        -- Info
        {
            type = "description",
            text = WM.LS and WM.LS("SETTINGS_SLASH_COMMANDS") or "|cAAAAAASLASH COMMANDS:|r\n/warmask - Toggle UI visibility\n/wmdebug - Show debug info\n/wmtest - Test mythic detection\n/wmpos - Position debugging",
            width = "full",
        },
    }
    
    LAM:RegisterOptionControls(WM.name .. "Menu", options)
    
    
end

-- =============================================================================
-- FONT PREVIEW
-- =============================================================================
function WM.CreateFontPreview()
    -- Find the settings panel
    local settingsWindow = WINDOW_MANAGER:GetControlByName("LAMAddonSettings")
    if not settingsWindow then return end
    
    -- Search for the custom control in the current panel
    local container = nil
    local function SearchChildren(parent, depth)
        if depth > 10 then return nil end  -- Prevent infinite recursion
        if not parent then return nil end
        
        local numChildren = parent:GetNumChildren()
        for i = 1, numChildren do
            local child = parent:GetChild(i)
            if child then
                local name = child:GetName()
                if name and (string.find(name, "FontPreview") or string.find(name, "WM_FontPreview")) then
                    return child
                end
                -- Recursively search children
                local found = SearchChildren(child, depth + 1)
                if found then return found end
            end
        end
        return nil
    end
    
    container = SearchChildren(settingsWindow, 0)
    
    if not container then return end
    
    -- Clear any existing previews
    container:RemoveAllChildren()
    
    -- Create preview labels
    local previewText = "Bash something"
    
    -- Label for "Univers67:"
    local univHeader = WINDOW_MANAGER:CreateControl(nil, container, CT_LABEL)
    univHeader:SetFont("ZoFontGame")
    univHeader:SetAnchor(TOPLEFT, container, TOPLEFT, 10, 5)
    univHeader:SetText("|cFFFFFFUnivers67:|r")
    univHeader:SetColor(1, 1, 1, 1)
    univHeader:SetDimensions(200, 25)
    
    -- Univers67 preview
    local univLabel = WINDOW_MANAGER:CreateControl(nil, container, CT_LABEL)
    univLabel:SetFont("esoui/common/fonts/Univers67.slug|32|soft-shadow-thick")
    univLabel:SetAnchor(TOPLEFT, container, TOPLEFT, 10, 30)
    univLabel:SetText(previewText)
    univLabel:SetColor(1, 1, 1, 1)
    univLabel:SetDimensions(container:GetWidth() - 20, 30)
    
    -- Label for "ProseAntiquePSMT:"
    local proseHeader = WINDOW_MANAGER:CreateControl(nil, container, CT_LABEL)
    proseHeader:SetFont("ZoFontGame")
    proseHeader:SetAnchor(TOPLEFT, container, TOPLEFT, 10, 65)
    proseHeader:SetText("|cFFFFFFProseAntiquePSMT:|r")
    proseHeader:SetColor(1, 1, 1, 1)
    proseHeader:SetDimensions(200, 25)
    
    -- ProseAntiquePSMT preview
    local proseLabel = WINDOW_MANAGER:CreateControl(nil, container, CT_LABEL)
    proseLabel:SetFont("esoui/common/fonts/ProseAntiquePSMT.slug|32|soft-shadow-thick")
    proseLabel:SetAnchor(TOPLEFT, container, TOPLEFT, 10, 90)
    proseLabel:SetText(previewText)
    proseLabel:SetColor(1, 1, 1, 1)
    proseLabel:SetDimensions(container:GetWidth() - 20, 30)
    
    -- Set container height to fit all previews
    container:SetHeight(125)
end

-- =============================================================================
-- WARMASK STATUS DISPLAY
-- =============================================================================
function WM.CreateWarmaskStatusDisplay()
    -- Silently return if function doesn't exist or if there's an error
    if not WM or not WINDOW_MANAGER then return end
    
    -- Use pcall to prevent errors from breaking the settings panel
    local success, err = pcall(function()
        -- Find the settings panel
        local settingsWindow = WINDOW_MANAGER:GetControlByName("LAMAddonSettings")
        if not settingsWindow then return end
        
        -- Search for the custom control in the current panel
        local container = nil
        local function SearchChildren(parent, depth)
            if depth > 15 then return nil end  -- Increased depth limit
            if not parent then return nil end
            
            local numChildren = parent:GetNumChildren()
            for i = 1, numChildren do
                local child = parent:GetChild(i)
                if child then
                    local name = child:GetName()
                    if name and (string.find(name, "WarmaskStatus") or string.find(name, "WM_WarmaskStatus")) then
                        return child
                    end
                    local found = SearchChildren(child, depth + 1)
                    if found then return found end
                end
            end
            return nil
        end
        
        container = SearchChildren(settingsWindow, 0)
        
        if not container then 
            -- Control not found yet, try again later
            return 
        end
        
        -- Clear any existing content
        container:RemoveAllChildren()
        
        -- Check warmask equipped status safely
        local isEquipped = false
        if WM.IsWarmaskEquipped and type(WM.IsWarmaskEquipped) == "function" then
            local success, result = pcall(WM.IsWarmaskEquipped)
            if success then
                isEquipped = result
            end
        end
        
        -- Create status label
        local statusLabel = WINDOW_MANAGER:CreateControl(nil, container, CT_LABEL)
        if not statusLabel then return end
        
        statusLabel:SetFont("ZoFontGame")
        statusLabel:SetAnchor(TOPLEFT, container, TOPLEFT, 10, 5)
        
        if isEquipped then
            statusLabel:SetText("|c00FF00Warmask Status: EQUIPPED|r")
        else
            statusLabel:SetText("|cFF4D4DWarmask Status: NOT EQUIPPED|r")
        end
        
        statusLabel:SetColor(1, 1, 1, 1)
        local containerWidth = container:GetWidth()
        if containerWidth and containerWidth > 0 then
            statusLabel:SetDimensions(containerWidth - 20, 25)
        else
            statusLabel:SetDimensions(300, 25)
        end
        statusLabel:SetHeight(25)
        
        -- Set container height
        container:SetHeight(30)
    end)
    
    -- Don't log errors to avoid spam - just silently fail
    -- if not success and err then
    --     d("[Warmask] Error creating warmask status display: " .. tostring(err))
    -- end
end





