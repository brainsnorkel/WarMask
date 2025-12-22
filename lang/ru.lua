-- =============================================================================
-- Warmask Localization - Russian
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "Ударьте цель",
    ["TARGET"] = "Цель",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "Как это работает",
    ["SETTINGS_DESC_MAIN"] = "Отображает иконку отслеживания, когда экипирована Маска Охотника. Показывает 60-секундный обратный отсчет после удара по цели.",
    ["SETTINGS_DESC_STATES"] = "|c00FF00Готово|r - Ударьте цель, чтобы начать отслеживание. Отслеживаемая цель изменится на ту, которую вы ударите.\n|cFF4D4DПерезарядка|r (60с-50с) - Активна внутренняя перезарядка. Удар НЕ изменит отслеживаемую цель.\n|c00FF00Обратный отсчет|r (49с-0с) - Готово ударить новую цель. Удар обновит отслеживаемую цель.",
    ["SETTINGS_DESC_TRACKING"] = "Имя отслеживаемой цели отображается рядом с иконкой. Обратный отсчет сбрасывается в состояние Готово, когда истекает или заканчивается бой.",
    ["SETTINGS_HEADER_ICON"] = "Настройки иконки",
    ["SETTINGS_LOCK_POSITION"] = "Заблокировать позицию иконки",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "Когда включено, иконку нельзя перемещать. Отключите, чтобы перетащить иконку в новую позицию.",
    ["SETTINGS_RESET_POSITION"] = "Сбросить позицию иконки",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "Сбросить иконку в центр экрана.",
    ["SETTINGS_ICON_SCALE"] = "Масштаб иконки",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "Настройте размер иконки. Диапазон: от 50% до 200%.",
    ["SETTINGS_FONT_SCALE"] = "Масштаб шрифта",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "Настройте размер текста и таймера обратного отсчета. Диапазон: от 50% до 400%.",
    ["SETTINGS_HEADER_LINE"] = "Настройки линии",
    ["SETTINGS_ENABLE_LINE"] = "Включить линию к цели",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "Рисует линию от вашего персонажа к отмеченной цели, когда вы смотрите на неё.",
    ["SETTINGS_HEADER_DEBUG"] = "Настройки отладки",
    ["SETTINGS_ENABLE_DEBUG"] = "Включить информацию отладки",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "Когда включено, отображает сообщения отладки в чате для загрузки аддона, обнаружения баффов, событий и обнаружения ударов с именами юнитов.",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAAКОМАНДЫ СЛЭША:|r\n/warmask - Переключить видимость интерфейса\n/wmdebug - Показать информацию отладки\n/wmtest - Тест обнаружения мифического предмета\n/wmpos - Отладка позиции",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "Аддон инициализирован - Версия %s",
    ["DEBUG_MODE_ENABLED"] = "Режим отладки включен",
    ["DEBUG_MODE_DISABLED"] = "Режим отладки выключен",
    ["DEBUG_UI_CREATED"] = "Интерфейс создан",
    ["DEBUG_WARMASK_EQUIPPED"] = "Маска Охотника экипирована",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "Маска Охотника снята",
    ["DEBUG_ADDON_LOADED"] = "Аддон загружен - Версия %s",
    ["DEBUG_ADDON_COMPLETE"] = "Инициализация аддона завершена",
    ["DEBUG_EVENTS_REGISTERED"] = "События зарегистрированы: PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "Интерфейс показан",
    ["SLASH_UI_HIDDEN"] = "Интерфейс скрыт",
    ["SLASH_DEBUG_INFO"] = "Информация отладки:",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "Мифическая Маска Охотника экипирована: %s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "Бафф Маски Охотника активен: %s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "Интерфейс должен показываться: %s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "Интерфейс скрыт: %s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "Обратный отсчет активен: %s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "Отмеченный юнит: %s",
    ["SLASH_DEBUG_REMAINING"] = "Осталось: %.1fс",
    ["SLASH_DEBUG_POSITION_SAVED"] = "Сохраненная позиция: x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "Сохраненная позиция: Не установлена",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "Текущая позиция окна: x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "Окно перемещаемое: %s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "Настройка блокировки позиции: %s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "Включите режим отладки в настройках для подробной информации об обнаружении",
    ["SLASH_TEST_MYTHIC"] = "Тестирование обнаружения мифического предмета...",
    ["SLASH_TEST_HEAD_SLOT"] = "Предмет в слоте головы: %s",
    ["SLASH_TEST_ITEM_LINK"] = "Ссылка на предмет: %s",
    ["SLASH_TEST_IS_WARMASK"] = "Это Маска Охотника: %s",
    ["SLASH_TEST_LOOKING_FOR"] = "Ищем: '%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "Слот головы: Пуст",
    ["SLASH_POS_INFO"] = "Информация о позиции:",
    ["SLASH_POS_ANCHOR"] = "Текущая привязка:",
    ["SLASH_POS_POINT"] = "Точка: %s",
    ["SLASH_POS_RELATIVE_TO"] = "Относительно: %s",
    ["SLASH_POS_RELATIVE_POINT"] = "Относительная точка: %s",
    ["SLASH_POS_OFFSET_X"] = "Смещение X: %s",
    ["SLASH_POS_OFFSET_Y"] = "Смещение Y: %s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "Окно скрыто: %s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "Окно перемещаемое: %s",
    ["SLASH_POS_TEST_RESTORE"] = "Тестирование восстановления позиции...",
    ["SLASH_POS_AFTER_RESTORE"] = "После восстановления - Смещение X: %s, Y: %s",
    ["SLASH_POS_DIFFERENCE"] = "Разница: x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "Главное окно: Не создано",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0 не найден. Меню настроек недоступно.",
    ["SETTINGS_POSITION_RESET"] = "Позиция иконки сброшена в центр (сохранено в SavedVariables)",
    ["SETTINGS_ICON_SCALE_SET"] = "Масштаб иконки установлен на %s%%",
    ["SETTINGS_FONT_SCALE_SET"] = "Масштаб шрифта установлен на %s%%",
}

WM.RegisterLanguage("ru", strings)
return strings

