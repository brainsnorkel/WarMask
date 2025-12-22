-- =============================================================================
-- Warmask Settings Menu (LibAddonMenu-2.0)
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


