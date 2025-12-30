-- =============================================================================
-- Warmask Localization - English
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "Bash something",
    ["TARGET"] = "Target",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "How It Works",
    ["SETTINGS_DESC_MAIN"] = "Displays a tracking icon when Huntsman's Warmask is equipped. Shows a 60-second countdown after bashing a target.",
    ["SETTINGS_DESC_STATES"] = "|c00FF00Ready|r - Bash a target to start tracking. The tracked target will change to whatever you bash.\n|cFF4D4DCooldown|r (60s-50s) - Internal cooldown active. Bashing will NOT change the tracked target.\n|c00FF00Countdown|r (49s-0s) - Ready to bash a new target. Bashing will update the tracked target.",
    ["SETTINGS_DESC_TRACKING"] = "The tracked target's name is displayed next to the icon. Countdown resets to Ready when it expires or combat ends.",
    ["SETTINGS_HEADER_ICON"] = "Icon Settings",
    ["SETTINGS_LOCK_POSITION"] = "Lock Icon Position",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "When enabled, the icon cannot be moved. Disable to drag the icon to a new position.",
    ["SETTINGS_RESET_POSITION"] = "Reset Icon Position",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "Reset the icon to the center of the screen.",
    ["SETTINGS_ICON_SCALE"] = "Icon Scale",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "Adjust the size of the icon. Range: 50% to 200%.",
    ["SETTINGS_FONT_SCALE"] = "Font Scale",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "Adjust the size of the text and countdown timer. Range: 50% to 400%.",
    ["SETTINGS_FONT_FAMILY"] = "Font Family",
    ["SETTINGS_FONT_FAMILY_TOOLTIP"] = "Select the font family to use for the addon text.",
    ["SETTINGS_FONT_FAMILY_SET"] = "Font family set to %s",
    ["SETTINGS_HIDE_OUT_OF_COMBAT"] = "Hide Icon Out of Combat",
    ["SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP"] = "When enabled, the icon will be hidden when you are not in combat. The icon will automatically appear when you enter combat.",
    ["SETTINGS_ROLEPLAYING_MODE"] = "Roleplaying Mode",
    ["SETTINGS_ROLEPLAYING_MODE_TOOLTIP"] = "When enabled, changes 'Bash something' to 'Bash, thou must' for a more immersive roleplaying experience.",
    ["SETTINGS_HEADER_LINE"] = "Line Settings",
    ["SETTINGS_ENABLE_LINE"] = "Enable Line to Target",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "Draw a line from your character to the marked target when looking at them.",
    ["SETTINGS_HEADER_DEBUG"] = "Debug Settings",
    ["SETTINGS_ENABLE_DEBUG"] = "Enable Debug Information",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "When enabled, displays debug messages in chat for addon loading, buff detection, events, and bash detections with unit names.",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAASLASH COMMANDS:|r\n/warmask - Toggle UI visibility\n/wmdebug - Show debug info\n/wmtest - Test mythic detection\n/wmpos - Position debugging",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "Addon initialized - Version %s",
    ["DEBUG_MODE_ENABLED"] = "Debug mode enabled",
    ["DEBUG_MODE_DISABLED"] = "Debug mode disabled",
    ["DEBUG_UI_CREATED"] = "UI created",
    ["DEBUG_WARMASK_EQUIPPED"] = "Warmask equipped",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "Warmask unequipped",
    ["DEBUG_ADDON_LOADED"] = "Addon loaded - Version %s",
    ["DEBUG_ADDON_COMPLETE"] = "Addon initialization complete",
    ["DEBUG_EVENTS_REGISTERED"] = "Events registered: PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UI shown",
    ["SLASH_UI_HIDDEN"] = "UI hidden",
    ["SLASH_DEBUG_INFO"] = "Debug Info:",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "Warmask Mythic Equipped: %s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "Warmask Buff Active: %s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UI Should Show: %s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UI Hidden: %s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "Countdown Active: %s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "Marked Unit: %s",
    ["SLASH_DEBUG_REMAINING"] = "Remaining: %.1fs",
    ["SLASH_DEBUG_POSITION_SAVED"] = "Saved Position: x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "Saved Position: Not set",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "Current Window Position: x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "Window Movable: %s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "Lock Position Setting: %s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "Enable debug mode in settings for detailed detection info",
    ["SLASH_TEST_MYTHIC"] = "Testing mythic detection...",
    ["SLASH_TEST_HEAD_SLOT"] = "Head slot item: %s",
    ["SLASH_TEST_ITEM_LINK"] = "Item link: %s",
    ["SLASH_TEST_IS_WARMASK"] = "Is Warmask: %s",
    ["SLASH_TEST_LOOKING_FOR"] = "Looking for: '%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "Head slot: Empty",
    ["SLASH_POS_INFO"] = "Position Information:",
    ["SLASH_POS_ANCHOR"] = "Current Anchor:",
    ["SLASH_POS_POINT"] = "Point: %s",
    ["SLASH_POS_RELATIVE_TO"] = "Relative To: %s",
    ["SLASH_POS_RELATIVE_POINT"] = "Relative Point: %s",
    ["SLASH_POS_OFFSET_X"] = "Offset X: %s",
    ["SLASH_POS_OFFSET_Y"] = "Offset Y: %s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "Window Hidden: %s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "Window Movable: %s",
    ["SLASH_POS_TEST_RESTORE"] = "Testing position restore...",
    ["SLASH_POS_AFTER_RESTORE"] = "After restore - Offset X: %s, Y: %s",
    ["SLASH_POS_DIFFERENCE"] = "Difference: x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "Main window: Not created",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0 not found. Settings menu unavailable.",
    ["SETTINGS_POSITION_RESET"] = "Icon position reset to center (saved to SavedVariables)",
    ["SETTINGS_ICON_SCALE_SET"] = "Icon scale set to %s%%",
    ["SETTINGS_FONT_SCALE_SET"] = "Font scale set to %s%%",
}

WM.RegisterLanguage("en", strings)
return strings

