-- =============================================================================
-- Warmask Localization - Spanish
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "Golpear algo",
    ["TARGET"] = "Objetivo",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "Cómo Funciona",
    ["SETTINGS_DESC_MAIN"] = "Muestra un icono de seguimiento cuando está equipada la Máscara del Cazador. Muestra una cuenta atrás de 60 segundos después de golpear un objetivo.",
    ["SETTINGS_DESC_STATES"] = "|c00FF00Listo|r - Golpea un objetivo para comenzar el seguimiento. El objetivo rastreado cambiará a lo que golpees.\n|cFF4D4DEnfriamiento|r (60s-50s) - Enfriamiento interno activo. Golpear NO cambiará el objetivo rastreado.\n|c00FF00Cuenta Atrás|r (49s-0s) - Listo para golpear un nuevo objetivo. Golpear actualizará el objetivo rastreado.",
    ["SETTINGS_DESC_TRACKING"] = "El nombre del objetivo rastreado se muestra junto al icono. La cuenta atrás se restablece a Listo cuando expira o termina el combate.",
    ["SETTINGS_HEADER_ICON"] = "Configuración del Icono",
    ["SETTINGS_LOCK_POSITION"] = "Bloquear Posición del Icono",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "Cuando está habilitado, el icono no se puede mover. Deshabilita para arrastrar el icono a una nueva posición.",
    ["SETTINGS_RESET_POSITION"] = "Restablecer Posición del Icono",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "Restablece el icono al centro de la pantalla.",
    ["SETTINGS_ICON_SCALE"] = "Escala del Icono",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "Ajusta el tamaño del icono. Rango: 50% a 200%.",
    ["SETTINGS_FONT_SCALE"] = "Escala de Fuente",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "Ajusta el tamaño del texto y el temporizador de cuenta atrás. Rango: 50% a 400%.",
    ["SETTINGS_FONT_FAMILY"] = "Familia de Fuente",
    ["SETTINGS_FONT_FAMILY_TOOLTIP"] = "Selecciona la familia de fuente a usar para el texto del complemento.",
    ["SETTINGS_FONT_FAMILY_SET"] = "Familia de fuente establecida en %s",
    ["SETTINGS_HIDE_OUT_OF_COMBAT"] = "Ocultar Icono Fuera de Combate",
    ["SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP"] = "Cuando está habilitado, el icono se ocultará cuando no estés en combate. El icono aparecerá automáticamente cuando entres en combate.",
    ["SETTINGS_ROLEPLAYING_MODE"] = "Modo de Rol",
    ["SETTINGS_ROLEPLAYING_MODE_TOOLTIP"] = "Cuando está habilitado, cambia 'Golpear algo' a 'Golpear, debes' para una experiencia de rol más inmersiva.",
    ["SETTINGS_HEADER_LINE"] = "Configuración de Línea",
    ["SETTINGS_ENABLE_LINE"] = "Habilitar Línea al Objetivo",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "Dibuja una línea desde tu personaje al objetivo marcado cuando lo miras.",
    ["SETTINGS_HEADER_DEBUG"] = "Configuración de Depuración",
    ["SETTINGS_ENABLE_DEBUG"] = "Habilitar Información de Depuración",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "Cuando está habilitado, muestra mensajes de depuración en el chat para la carga del complemento, detección de beneficios, eventos y detecciones de golpes con nombres de unidades.",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAACOMANDOS DE BARRA:|r\n/warmask - Alternar visibilidad de la UI\n/wmdebug - Mostrar información de depuración\n/wmtest - Probar detección de mítico\n/wmpos - Depuración de posición",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "Complemento inicializado - Versión %s",
    ["DEBUG_MODE_ENABLED"] = "Modo de depuración habilitado",
    ["DEBUG_MODE_DISABLED"] = "Modo de depuración deshabilitado",
    ["DEBUG_UI_CREATED"] = "UI creada",
    ["DEBUG_WARMASK_EQUIPPED"] = "Máscara del Cazador equipada",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "Máscara del Cazador desequipada",
    ["DEBUG_ADDON_LOADED"] = "Complemento cargado - Versión %s",
    ["DEBUG_ADDON_COMPLETE"] = "Inicialización del complemento completa",
    ["DEBUG_EVENTS_REGISTERED"] = "Eventos registrados: PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UI mostrada",
    ["SLASH_UI_HIDDEN"] = "UI oculta",
    ["SLASH_DEBUG_INFO"] = "Información de Depuración:",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "Mítico Máscara del Cazador Equipado: %s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "Beneficio Máscara del Cazador Activo: %s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UI Debe Mostrar: %s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UI Oculto: %s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "Cuenta Atrás Activa: %s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "Unidad Marcada: %s",
    ["SLASH_DEBUG_REMAINING"] = "Restante: %.1fs",
    ["SLASH_DEBUG_POSITION_SAVED"] = "Posición Guardada: x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "Posición Guardada: No establecida",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "Posición Actual de la Ventana: x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "Ventana Movible: %s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "Configuración de Bloqueo de Posición: %s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "Habilita el modo de depuración en la configuración para información detallada de detección",
    ["SLASH_TEST_MYTHIC"] = "Probando detección de mítico...",
    ["SLASH_TEST_HEAD_SLOT"] = "Objeto en ranura de cabeza: %s",
    ["SLASH_TEST_ITEM_LINK"] = "Enlace de objeto: %s",
    ["SLASH_TEST_IS_WARMASK"] = "Es Máscara del Cazador: %s",
    ["SLASH_TEST_LOOKING_FOR"] = "Buscando: '%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "Ranura de cabeza: Vacía",
    ["SLASH_POS_INFO"] = "Información de Posición:",
    ["SLASH_POS_ANCHOR"] = "Ancla Actual:",
    ["SLASH_POS_POINT"] = "Punto: %s",
    ["SLASH_POS_RELATIVE_TO"] = "Relativo A: %s",
    ["SLASH_POS_RELATIVE_POINT"] = "Punto Relativo: %s",
    ["SLASH_POS_OFFSET_X"] = "Desplazamiento X: %s",
    ["SLASH_POS_OFFSET_Y"] = "Desplazamiento Y: %s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "Ventana Oculto: %s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "Ventana Movible: %s",
    ["SLASH_POS_TEST_RESTORE"] = "Probando restauración de posición...",
    ["SLASH_POS_AFTER_RESTORE"] = "Después de restaurar - Desplazamiento X: %s, Y: %s",
    ["SLASH_POS_DIFFERENCE"] = "Diferencia: x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "Ventana principal: No creada",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0 no encontrado. Menú de configuración no disponible.",
    ["SETTINGS_POSITION_RESET"] = "Posición del icono restablecida al centro (guardada en SavedVariables)",
    ["SETTINGS_ICON_SCALE_SET"] = "Escala del icono establecida en %s%%",
    ["SETTINGS_FONT_SCALE_SET"] = "Escala de fuente establecida en %s%%",
}

WM.RegisterLanguage("es", strings)
return strings

