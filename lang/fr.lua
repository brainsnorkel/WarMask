-- =============================================================================
-- Warmask Localization - French
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "Frapper quelque chose",
    ["TARGET"] = "Cible",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "Comment ça fonctionne",
    ["SETTINGS_DESC_MAIN"] = "Affiche une icône de suivi lorsque le Masque du Chasseur est équipé. Affiche un compte à rebours de 60 secondes après avoir frappé une cible.",
    ["SETTINGS_DESC_STATES"] = "|c00FF00Prêt|r - Frappez une cible pour commencer le suivi. La cible suivie changera pour celle que vous frappez.\n|cFF4D4DRechargement|r (60s-50s) - Rechargement interne actif. Frapper ne changera PAS la cible suivie.\n|c00FF00Compte à rebours|r (49s-0s) - Prêt à frapper une nouvelle cible. Frapper mettra à jour la cible suivie.",
    ["SETTINGS_DESC_TRACKING"] = "Le nom de la cible suivie s'affiche à côté de l'icône. Le compte à rebours se réinitialise à Prêt lorsqu'il expire ou que le combat se termine.",
    ["SETTINGS_HEADER_ICON"] = "Paramètres de l'icône",
    ["SETTINGS_LOCK_POSITION"] = "Verrouiller la position de l'icône",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "Lorsqu'il est activé, l'icône ne peut pas être déplacée. Désactivez pour faire glisser l'icône vers une nouvelle position.",
    ["SETTINGS_RESET_POSITION"] = "Réinitialiser la position de l'icône",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "Réinitialise l'icône au centre de l'écran.",
    ["SETTINGS_ICON_SCALE"] = "Échelle de l'icône",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "Ajustez la taille de l'icône. Plage : 50% à 200%.",
    ["SETTINGS_FONT_SCALE"] = "Échelle de la police",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "Ajustez la taille du texte et du minuteur de compte à rebours. Plage : 50% à 400%.",
    ["SETTINGS_HEADER_LINE"] = "Paramètres de la ligne",
    ["SETTINGS_ENABLE_LINE"] = "Activer la ligne vers la cible",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "Trace une ligne de votre personnage vers la cible marquée lorsque vous la regardez.",
    ["SETTINGS_HEADER_DEBUG"] = "Paramètres de débogage",
    ["SETTINGS_ENABLE_DEBUG"] = "Activer les informations de débogage",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "Lorsqu'il est activé, affiche des messages de débogage dans le chat pour le chargement de l'addon, la détection de buff, les événements et les détections de coups avec les noms d'unités.",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAACOMMANDES SLASH :|r\n/warmask - Basculer la visibilité de l'UI\n/wmdebug - Afficher les informations de débogage\n/wmtest - Tester la détection mythique\n/wmpos - Débogage de position",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "Addon initialisé - Version %s",
    ["DEBUG_MODE_ENABLED"] = "Mode débogage activé",
    ["DEBUG_MODE_DISABLED"] = "Mode débogage désactivé",
    ["DEBUG_UI_CREATED"] = "UI créée",
    ["DEBUG_WARMASK_EQUIPPED"] = "Masque du Chasseur équipé",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "Masque du Chasseur retiré",
    ["DEBUG_ADDON_LOADED"] = "Addon chargé - Version %s",
    ["DEBUG_ADDON_COMPLETE"] = "Initialisation de l'addon terminée",
    ["DEBUG_EVENTS_REGISTERED"] = "Événements enregistrés : PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UI affichée",
    ["SLASH_UI_HIDDEN"] = "UI masquée",
    ["SLASH_DEBUG_INFO"] = "Informations de débogage :",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "Masque du Chasseur mythique équipé : %s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "Buff Masque du Chasseur actif : %s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UI devrait afficher : %s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UI masquée : %s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "Compte à rebours actif : %s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "Unité marquée : %s",
    ["SLASH_DEBUG_REMAINING"] = "Restant : %.1fs",
    ["SLASH_DEBUG_POSITION_SAVED"] = "Position enregistrée : x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "Position enregistrée : Non définie",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "Position actuelle de la fenêtre : x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "Fenêtre déplaçable : %s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "Paramètre de verrouillage de position : %s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "Activez le mode débogage dans les paramètres pour des informations de détection détaillées",
    ["SLASH_TEST_MYTHIC"] = "Test de détection mythique...",
    ["SLASH_TEST_HEAD_SLOT"] = "Objet dans l'emplacement de tête : %s",
    ["SLASH_TEST_ITEM_LINK"] = "Lien d'objet : %s",
    ["SLASH_TEST_IS_WARMASK"] = "Est Masque du Chasseur : %s",
    ["SLASH_TEST_LOOKING_FOR"] = "Recherche : '%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "Emplacement de tête : Vide",
    ["SLASH_POS_INFO"] = "Informations de position :",
    ["SLASH_POS_ANCHOR"] = "Ancre actuelle :",
    ["SLASH_POS_POINT"] = "Point : %s",
    ["SLASH_POS_RELATIVE_TO"] = "Relatif à : %s",
    ["SLASH_POS_RELATIVE_POINT"] = "Point relatif : %s",
    ["SLASH_POS_OFFSET_X"] = "Décalage X : %s",
    ["SLASH_POS_OFFSET_Y"] = "Décalage Y : %s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "Fenêtre masquée : %s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "Fenêtre déplaçable : %s",
    ["SLASH_POS_TEST_RESTORE"] = "Test de restauration de position...",
    ["SLASH_POS_AFTER_RESTORE"] = "Après restauration - Décalage X : %s, Y : %s",
    ["SLASH_POS_DIFFERENCE"] = "Différence : x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "Fenêtre principale : Non créée",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0 introuvable. Menu des paramètres indisponible.",
    ["SETTINGS_POSITION_RESET"] = "Position de l'icône réinitialisée au centre (enregistrée dans SavedVariables)",
    ["SETTINGS_ICON_SCALE_SET"] = "Échelle de l'icône définie à %s%%",
    ["SETTINGS_FONT_SCALE_SET"] = "Échelle de la police définie à %s%%",
}

WM.RegisterLanguage("fr", strings)
return strings

