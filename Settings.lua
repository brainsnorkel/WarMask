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
        d("[Warmask] LibAddonMenu-2.0 not found. Settings menu unavailable.")
        return
    end
    
    local panel = {
        type = "panel",
        name = "Warmask",
        displayName = "|cFFD700Warmask|r",
        author = "@brainsnorkel",
        version = WM.version,
        registerForRefresh = true,
    }
    
    LAM:RegisterAddonPanel(WM.name .. "Menu", panel)
    
    local options = {
        -- Help Text Header
        {
            type = "header",
            name = "How It Works",
        },
        {
            type = "description",
            text = "Displays a tracking icon when Huntsman's Warmask is equipped. Shows a 60-second countdown after bashing a target.",
            width = "full",
        },
        {
            type = "description",
            text = "|c00FF00Ready|r - Bash a target to start tracking. The tracked target will change to whatever you bash.\n|cFF4D4DCooldown|r (60s-50s) - Internal cooldown active. Bashing will NOT change the tracked target.\n|c00FF00Countdown|r (49s-0s) - Ready to bash a new target. Bashing will update the tracked target.",
            width = "full",
        },
        {
            type = "description",
            text = "The tracked target's name is displayed next to the icon. Countdown resets to Ready when it expires or combat ends.",
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
            name = "Icon Settings",
        },
        {
            type = "checkbox",
            name = "Lock Icon Position",
            tooltip = "When enabled, the icon cannot be moved. Disable to drag the icon to a new position.",
            getFunc = function() return WM.savedVars.lockPosition end,
            setFunc = function(value)
                WM.savedVars.lockPosition = value
            end,
            width = "full",
        },
        {
            type = "button",
            name = "Reset Icon Position",
            tooltip = "Reset the icon to the center of the screen.",
            func = function()
                WM.savedVars.position = { x = 0, y = 128 }
                -- Update window position immediately
                local win = WINDOW_MANAGER:GetControlByName(WM.name .. "Window")
                if win then
                    win:ClearAnchors()
                    win:SetAnchor(CENTER, GuiRoot, CENTER, 0, 128)
                    -- SavedVariables are automatically saved
                    d("[Warmask] Icon position reset to center (saved to SavedVariables)")
                end
            end,
            width = "half",
        },
        {
            type = "slider",
            name = "Icon Scale",
            tooltip = "Adjust the size of the icon. Range: 50% to 200%.",
            min = 50,
            max = 200,
            step = 5,
            getFunc = function() return WM.savedVars.iconScale or 100 end,
            setFunc = function(value)
                WM.savedVars.iconScale = value
                WM.ApplyUIScaling()
                d("[Warmask] Icon scale set to " .. value .. "%")
            end,
            width = "full",
        },
        {
            type = "slider",
            name = "Font Scale",
            tooltip = "Adjust the size of the text and countdown timer. Range: 50% to 200%.",
            min = 50,
            max = 200,
            step = 5,
            getFunc = function() return WM.savedVars.fontScale or 100 end,
            setFunc = function(value)
                WM.savedVars.fontScale = value
                WM.ApplyUIScaling()
                d("[Warmask] Font scale set to " .. value .. "%")
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
            name = "Line Settings",
        },
        {
            type = "checkbox",
            name = "Enable Line to Target",
            tooltip = "Draw a line from your character to the marked target when looking at them.",
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
            name = "Debug Settings",
        },
        {
            type = "checkbox",
            name = "Enable Debug Information",
            tooltip = "When enabled, displays debug messages in chat for addon loading, buff detection, events, and bash detections with unit names.",
            getFunc = function() return WM.savedVars.enableDebug end,
            setFunc = function(value)
                WM.savedVars.enableDebug = value
                if value then
                    d("[Warmask] Debug mode enabled")
                else
                    d("[Warmask] Debug mode disabled")
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
            text = "|cAAAAAASLASH COMMANDS:|r\n/warmask - Toggle UI visibility\n/wmdebug - Show debug info\n/wmtest - Test mythic detection\n/wmpos - Position debugging",
            width = "full",
        },
    }
    
    LAM:RegisterOptionControls(WM.name .. "Menu", options)
end


