-- =============================================================================
-- Warmask Localization - German
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "Etwas schlagen",
    ["TARGET"] = "Ziel",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "Wie es funktioniert",
    ["SETTINGS_DESC_MAIN"] = "Zeigt ein Verfolgungssymbol an, wenn die Jägermaske ausgerüstet ist. Zeigt einen 60-Sekunden-Countdown nach dem Schlagen eines Ziels.",
    ["SETTINGS_DESC_STATES"] = "|c00FF00Bereit|r - Schlagen Sie ein Ziel, um die Verfolgung zu starten. Das verfolgte Ziel ändert sich zu dem, was Sie schlagen.\n|cFF4D4DAbklingzeit|r (60s-50s) - Interne Abklingzeit aktiv. Schlagen ändert das verfolgte Ziel NICHT.\n|c00FF00Countdown|r (49s-0s) - Bereit, ein neues Ziel zu schlagen. Schlagen aktualisiert das verfolgte Ziel.",
    ["SETTINGS_DESC_TRACKING"] = "Der Name des verfolgten Ziels wird neben dem Symbol angezeigt. Der Countdown wird auf Bereit zurückgesetzt, wenn er abläuft oder der Kampf endet.",
    ["SETTINGS_HEADER_ICON"] = "Symbol-Einstellungen",
    ["SETTINGS_LOCK_POSITION"] = "Symbolposition sperren",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "Wenn aktiviert, kann das Symbol nicht bewegt werden. Deaktivieren Sie es, um das Symbol an eine neue Position zu ziehen.",
    ["SETTINGS_RESET_POSITION"] = "Symbolposition zurücksetzen",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "Setzt das Symbol auf die Bildschirmmitte zurück.",
    ["SETTINGS_ICON_SCALE"] = "Symbol-Skalierung",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "Passen Sie die Größe des Symbols an. Bereich: 50% bis 200%.",
    ["SETTINGS_FONT_SCALE"] = "Schriftgröße",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "Passen Sie die Größe des Textes und des Countdown-Timers an. Bereich: 50% bis 400%.",
    ["SETTINGS_FONT_FAMILY"] = "Schriftfamilie",
    ["SETTINGS_FONT_FAMILY_TOOLTIP"] = "Wählen Sie die Schriftfamilie für den Addon-Text.",
    ["SETTINGS_FONT_FAMILY_SET"] = "Schriftfamilie auf %s gesetzt",
    ["SETTINGS_HIDE_OUT_OF_COMBAT"] = "Symbol außerhalb des Kampfes ausblenden",
    ["SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP"] = "Wenn aktiviert, wird das Symbol ausgeblendet, wenn Sie sich nicht im Kampf befinden. Das Symbol erscheint automatisch, wenn Sie den Kampf betreten.",
    ["SETTINGS_ROLEPLAYING_MODE"] = "Rollenspiel-Modus",
    ["SETTINGS_ROLEPLAYING_MODE_TOOLTIP"] = "Wenn aktiviert, ändert sich 'Etwas schlagen' zu 'Schlagen, du musst' für ein immersiveres Rollenspiel-Erlebnis.",
    ["SETTINGS_HEADER_LINE"] = "Linien-Einstellungen",
    ["SETTINGS_ENABLE_LINE"] = "Linie zum Ziel aktivieren",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "Zeichnet eine Linie von Ihrem Charakter zum markierten Ziel, wenn Sie es ansehen.",
    ["SETTINGS_HEADER_DEBUG"] = "Debug-Einstellungen",
    ["SETTINGS_ENABLE_DEBUG"] = "Debug-Informationen aktivieren",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "Wenn aktiviert, werden Debug-Nachrichten im Chat für Addon-Laden, Buff-Erkennung, Ereignisse und Schlag-Erkennungen mit Einheitsnamen angezeigt.",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAASLASH-BEFEHLE:|r\n/warmask - UI-Sichtbarkeit umschalten\n/wmdebug - Debug-Informationen anzeigen\n/wmtest - Mythische Erkennung testen\n/wmpos - Positions-Debugging",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "Addon initialisiert - Version %s",
    ["DEBUG_MODE_ENABLED"] = "Debug-Modus aktiviert",
    ["DEBUG_MODE_DISABLED"] = "Debug-Modus deaktiviert",
    ["DEBUG_UI_CREATED"] = "UI erstellt",
    ["DEBUG_WARMASK_EQUIPPED"] = "Jägermaske ausgerüstet",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "Jägermaske abgelegt",
    ["DEBUG_ADDON_LOADED"] = "Addon geladen - Version %s",
    ["DEBUG_ADDON_COMPLETE"] = "Addon-Initialisierung abgeschlossen",
    ["DEBUG_EVENTS_REGISTERED"] = "Ereignisse registriert: PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UI angezeigt",
    ["SLASH_UI_HIDDEN"] = "UI ausgeblendet",
    ["SLASH_DEBUG_INFO"] = "Debug-Informationen:",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "Mythische Jägermaske Ausgerüstet: %s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "Jägermaske Buff Aktiv: %s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UI Sollte Anzeigen: %s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UI Ausgeblendet: %s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "Countdown Aktiv: %s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "Markierte Einheit: %s",
    ["SLASH_DEBUG_REMAINING"] = "Verbleibend: %.1fs",
    ["SLASH_DEBUG_POSITION_SAVED"] = "Gespeicherte Position: x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "Gespeicherte Position: Nicht gesetzt",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "Aktuelle Fensterposition: x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "Fenster Beweglich: %s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "Position Sperren Einstellung: %s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "Aktivieren Sie den Debug-Modus in den Einstellungen für detaillierte Erkennungsinformationen",
    ["SLASH_TEST_MYTHIC"] = "Mythische Erkennung testen...",
    ["SLASH_TEST_HEAD_SLOT"] = "Kopfplatz-Objekt: %s",
    ["SLASH_TEST_ITEM_LINK"] = "Objekt-Link: %s",
    ["SLASH_TEST_IS_WARMASK"] = "Ist Jägermaske: %s",
    ["SLASH_TEST_LOOKING_FOR"] = "Suche nach: '%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "Kopfplatz: Leer",
    ["SLASH_POS_INFO"] = "Positionsinformationen:",
    ["SLASH_POS_ANCHOR"] = "Aktueller Anker:",
    ["SLASH_POS_POINT"] = "Punkt: %s",
    ["SLASH_POS_RELATIVE_TO"] = "Relativ Zu: %s",
    ["SLASH_POS_RELATIVE_POINT"] = "Relativer Punkt: %s",
    ["SLASH_POS_OFFSET_X"] = "Offset X: %s",
    ["SLASH_POS_OFFSET_Y"] = "Offset Y: %s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "Fenster Ausgeblendet: %s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "Fenster Beweglich: %s",
    ["SLASH_POS_TEST_RESTORE"] = "Positionswiederherstellung testen...",
    ["SLASH_POS_AFTER_RESTORE"] = "Nach Wiederherstellung - Offset X: %s, Y: %s",
    ["SLASH_POS_DIFFERENCE"] = "Unterschied: x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "Hauptfenster: Nicht erstellt",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0 nicht gefunden. Einstellungsmenü nicht verfügbar.",
    ["SETTINGS_POSITION_RESET"] = "Symbolposition auf Mitte zurückgesetzt (in SavedVariables gespeichert)",
    ["SETTINGS_ICON_SCALE_SET"] = "Symbol-Skalierung auf %s%% gesetzt",
    ["SETTINGS_FONT_SCALE_SET"] = "Schriftgröße auf %s%% gesetzt",
}

WM.RegisterLanguage("de", strings)
return strings

