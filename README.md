# Warmask - Huntsman's Warmask Tracker

An Elder Scrolls Online addon that tracks Mark of Hircine applications from Huntsman's Warmask.

## Features

- Displays an icon (Mark of Hircine) when Huntsman's Warmask is equipped
- Shows "Bash something" when ready to track a target
- Tracks bash applications with a 60-second countdown
- Displays tracked target's name during countdown
- Color-coded status:
  - Red (60s-50s): Cooldown period - bashing will NOT change the tracked target
  - Green (49s-0s): Ready period - bashing will update the tracked target
- Visual alerts:
  - "Bash something" text flashes red/green when in combat (reminds you to bash)
  - Countdown timer flashes red/green when below 10 seconds (warns mark is expiring)
- Draws a line to marked target when looking at them (line color matches status)
- Configurable icon and font scaling (50%-200%)
- Configurable settings via LibAddonMenu-2.0
- Debug mode with detailed logging
- Automatically resets to ready state when countdown expires or combat ends

## Installation

1. Copy the `WarMask` folder to your ESO AddOns directory
2. Ensure LibAddonMenu-2.0 is installed
3. Enable the addon in-game

## Usage

- `/warmask` - Toggle UI visibility
- `/wmdebug` - Show debug information (equipment status, countdown state, position)
- `/wmtest` - Test mythic detection (shows head slot item info)
- `/wmpos` - Detailed position debugging and restore test

## Settings Panel

Access via ESO Settings → Add-ons → Warmask. The panel includes:

**How It Works** - Explains the addon functionality and color-coded states:
- **Ready** (green) - Bash a target to start tracking. The tracked target will change to whatever you bash.
- **Cooldown** (red, 60s-50s) - Internal cooldown active. Bashing will NOT change the tracked target.
- **Countdown** (green, 49s-0s) - Ready to bash a new target. Bashing will update the tracked target.

**Icon Settings:**
- Lock/unlock icon position for dragging
- Reset position to center
- Icon scale (50%-200%)
- Font scale (50%-200%)

**Line Settings:**
- Enable/disable line drawing to marked target

**Debug Settings:**
- Enable detailed debug messages in chat

## File Structure

```
WarMask/
├── WarMask.txt      # Addon manifest
├── WarMask.lua      # Main addon logic
├── Line.lua         # Line rendering system
├── Settings.lua     # LibAddonMenu settings panel
├── lang/            # Localization files
│   ├── Localization.lua  # Localization system
│   ├── en.lua       # English
│   ├── de.lua       # German
│   ├── es.lua       # Spanish
│   ├── fr.lua       # French
│   ├── ru.lua       # Russian
│   ├── ja.lua       # Japanese
│   └── zh.lua       # Chinese (Simplified)
└── README.md        # This file
```

## Localization

This addon supports multiple languages:
- English (en)
- German (de)
- Spanish (es)
- French (fr)
- Russian (ru)
- Japanese (ja)
- Chinese Simplified (zh)

**Note:** All non-English localizations are machine translations and may contain errors or awkward phrasing. If you notice any translation issues or have improvements, please submit a pull request with corrections. Native speakers are especially encouraged to review and improve the translations!

## Architecture (For LLM Continuation)

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `WARMASK_BUFF_ID` | 252050 | Player buff when Warmask is equipped |
| `MARK_OF_HIRCINE_ID` | 252048 | Ability ID for icon and debuff detection |
| `BASH_ABILITY_ID` | 21970 | Standard bash ability |
| `COUNTDOWN_DURATION` | 60 | Seconds for countdown timer |
| `INTERNAL_COOLDOWN` | 10 | Minimum seconds between mark applications |
| `WARMASK_ITEM_NAME` | "Huntsman's Warmask" | Mythic item name for equipment detection |

### State Variables

```lua
hasWarmaskBuff         -- boolean: warmask mythic is equipped
markedUnitId           -- number: unit ID of marked enemy
markedUnitName         -- string: display name of marked enemy
countdownEndTime       -- number: GetGameTimeSeconds() when countdown ends
isCountdownActive      -- boolean: countdown is running
isInCombat             -- boolean: player is in combat
flashVisible           -- boolean: ready text flash state (for color toggle)
countdownFlashVisible  -- boolean: countdown flash state (for color toggle)
countdownFlashActive   -- boolean: tracks if countdown flash timer is running
```

### Event Flow

1. **Equipment Detection**: `EVENT_INVENTORY_SINGLE_SLOT_UPDATE` filtered to `BAG_WORN`
   - When head slot changes → check if Huntsman's Warmask is equipped
   - Equipment check on player activation (`EVENT_PLAYER_ACTIVATED`)

2. **Buff Detection** (fallback): `EVENT_EFFECT_CHANGED` filtered to player
   - When `WARMASK_BUFF_ID` gained/faded → trigger status check

3. **Bash Detection**: `EVENT_COMBAT_EVENT` filtered to `BASH_ABILITY_ID`
   - Check `sourceType == COMBAT_UNIT_TYPE_PLAYER`
   - Accepts result types: `ACTION_RESULT_DAMAGE`, `ACTION_RESULT_BLOCKED_DAMAGE`, or miss (2)
   - Check internal cooldown (countdown must be ≤50s or inactive)
   - Start 60-second countdown with target name

4. **Line Rendering**: `EVENT_RETICLE_TARGET_CHANGED` + periodic update (50ms)
   - Check if `reticleover` name matches the bashed target name
   - If yes, draw line from player to target
   - Line color matches countdown status (red/green)

5. **Combat State**: `EVENT_PLAYER_COMBAT_STATE`
   - When combat ends → reset countdown, return to "Ready." state

### Key Functions

```lua
-- WarMask.lua
CheckWarmaskStatus()      -- Check equipment and show/hide UI
IsWarmaskEquipped()       -- Check if mythic is in head slot
HasWarmaskBuff()          -- Check if warmask buff is active (fallback)
StartCountdown(name, id)  -- Begin 60s countdown for target
UpdateCountdown()         -- Timer update (100ms interval)
WM.ApplyUIScaling()       -- Apply icon/font scale settings
StartReadyFlash()         -- Start "Bash something" text flash (in combat)
StopReadyFlash()          -- Stop ready text flash
StartCountdownFlash()     -- Start countdown flash (below 10s)
StopCountdownFlash()      -- Stop countdown flash

-- Line.lua
WM.CreateLineUI()         -- Initialize line rendering controls
WM.DrawLineToTarget()     -- Draw line to reticleover
WM.RemoveLine()           -- Hide line
GetViewCoordinates()      -- Convert world coords to screen coords

-- Settings.lua
WM.BuildMenu()            -- Create LibAddonMenu panel
```

### SavedVariables Structure

```lua
WarMaskSV = {
    position = { x = 0, y = 128 },   -- Icon offset from center
    lockPosition = true,              -- Prevent icon dragging
    enableLine = true,                -- Draw line to target
    cooldownColor = { 1, 0.3, 0.3, 1 },  -- RGBA red (60s to 50s cooldown)
    readyColor = { 0, 1, 0, 1 },         -- RGBA green (49s and lower)
    enableDebug = false,              -- Enable debug information in chat
    iconScale = 100,                  -- Icon scale percentage (50-200)
    fontScale = 100,                  -- Font scale percentage (50-200)
}
```

### Debug Mode

When enabled in settings, debug mode displays detailed information in chat:
- Addon loading and initialization
- Warmask equipment detection (equipped/unequipped)
- Warmask buff detection (gained/lost)
- All combat events with ability IDs and target names
- Bash detections with unit names and IDs
- Internal cooldown status
- Countdown start/finish events
- Combat state changes
- Position save/restore operations

## Known Limitations

1. **Line only works when targeting**: ESO doesn't provide world position for arbitrary unit IDs, only for unit tags. The line only displays when looking directly at the marked enemy (`reticleover`).

2. **Name-based matching**: The addon matches targets by name rather than unit ID, since ESO's API doesn't provide `GetUnitId()` for unit tags. Multiple enemies with identical names cannot be distinguished.

3. **Debuff detection**: The line drawing checks target name match rather than debuff presence, since other players can also apply Mark of Hircine.

4. **Unit ID tracking**: The addon tracks the bashed target by unit ID internally, but ESO may reuse unit IDs in some cases.

## Potential Improvements

- [ ] Add sound alert when countdown reaches 0
- [ ] Add option to show/hide outside combat
- [ ] Multiple target tracking (if warmask can mark multiple)
- [ ] Configurable color settings in the settings menu
- [ ] Integration with combat log for mark application confirmation

## Dependencies

- LibAddonMenu-2.0 (>= 41)

## Credits

- Author: @brainsnorkel
- Line rendering adapted from BetterGuard by TheMrPancake
- Coordinate conversion from CrutchAlerts (Kyzeragon) and OdySupportIcons (Lamierina7)
- Addon structure based on HuntsmanWarmaskReminder patterns

## API Version

101048 (Update 45)

## Changelog

### v1.2.0
- Added multi-language localization support (English, German, Spanish, French, Russian, Japanese, Chinese)
- Fixed icon position lock functionality
- Note: Non-English translations are machine-generated; pull requests for improvements welcome

### v1.1.0
- Increased max font scale to 400% with larger font options
- Changed pulse cycle to 2 seconds (1s each direction)
- Fixed font scale being backwards (H1 is largest, not H4)

### v1.0.0
- Initial release
- Equipment-based detection of Huntsman's Warmask in head slot
- 60-second countdown timer with target name display
- Color-coded status indicators (red for cooldown, green for ready)
- "Bash something" text flashing in combat when ready
- Countdown timer flashing below 10 seconds
- Line rendering to marked target when looking at them
- Configurable icon and font scaling (50%-200%)
- Settings panel via LibAddonMenu-2.0
- Slash commands: /warmask, /wmdebug, /wmtest, /wmpos
- Debug mode with detailed logging
