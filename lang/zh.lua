-- =============================================================================
-- Warmask Localization - Chinese (Simplified)
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "猛击目标",
    ["TARGET"] = "目标",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "工作原理",
    ["SETTINGS_DESC_MAIN"] = "当装备猎人暖面罩时显示追踪图标。猛击目标后显示60秒倒计时。",
    ["SETTINGS_DESC_STATES"] = "|c00FF00就绪|r - 猛击目标开始追踪。追踪目标将更改为您猛击的目标。\n|cFF4D4D冷却|r (60秒-50秒) - 内部冷却激活。猛击不会改变追踪目标。\n|c00FF00倒计时|r (49秒-0秒) - 可以猛击新目标。猛击将更新追踪目标。",
    ["SETTINGS_DESC_TRACKING"] = "追踪目标的名称显示在图标旁边。倒计时在到期或战斗结束时重置为就绪状态。",
    ["SETTINGS_HEADER_ICON"] = "图标设置",
    ["SETTINGS_LOCK_POSITION"] = "锁定图标位置",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "启用后，图标无法移动。禁用可拖动图标到新位置。",
    ["SETTINGS_RESET_POSITION"] = "重置图标位置",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "将图标重置到屏幕中心。",
    ["SETTINGS_ICON_SCALE"] = "图标缩放",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "调整图标大小。范围：50%到200%。",
    ["SETTINGS_FONT_SCALE"] = "字体缩放",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "调整文本和倒计时计时器的大小。范围：50%到400%。",
    ["SETTINGS_FONT_FAMILY"] = "字体系列",
    ["SETTINGS_FONT_FAMILY_TOOLTIP"] = "选择插件文本使用的字体系列。",
    ["SETTINGS_FONT_FAMILY_SET"] = "字体系列设置为 %s",
    ["SETTINGS_HIDE_OUT_OF_COMBAT"] = "非战斗时隐藏图标",
    ["SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP"] = "启用后，当您不在战斗中时图标将被隐藏。进入战斗时图标将自动出现。",
    ["SETTINGS_ROLEPLAYING_MODE"] = "角色扮演模式",
    ["SETTINGS_ROLEPLAYING_MODE_TOOLTIP"] = "启用后，将'猛击目标'更改为'汝须猛击'，以获得更沉浸的角色扮演体验。",
    ["SETTINGS_HEADER_LINE"] = "线条设置",
    ["SETTINGS_ENABLE_LINE"] = "启用到目标的线条",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "当看向标记目标时，从角色到标记目标绘制一条线。",
    ["SETTINGS_HEADER_DEBUG"] = "调试设置",
    ["SETTINGS_ENABLE_DEBUG"] = "启用调试信息",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "启用后，在聊天中显示加载、增益检测、事件和猛击检测的调试消息。",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAA斜杠命令：|r\n/warmask - 切换UI可见性\n/wmdebug - 显示调试信息\n/wmtest - 测试神话检测\n/wmpos - 位置调试",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "插件已初始化 - 版本 %s",
    ["DEBUG_MODE_ENABLED"] = "调试模式已启用",
    ["DEBUG_MODE_DISABLED"] = "调试模式已禁用",
    ["DEBUG_UI_CREATED"] = "UI已创建",
    ["DEBUG_WARMASK_EQUIPPED"] = "暖面罩已装备",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "暖面罩已卸下",
    ["DEBUG_ADDON_LOADED"] = "插件已加载 - 版本 %s",
    ["DEBUG_ADDON_COMPLETE"] = "插件初始化完成",
    ["DEBUG_EVENTS_REGISTERED"] = "事件已注册：PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UI已显示",
    ["SLASH_UI_HIDDEN"] = "UI已隐藏",
    ["SLASH_DEBUG_INFO"] = "调试信息：",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "暖面罩神话已装备：%s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "暖面罩增益激活：%s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UI应显示：%s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UI已隐藏：%s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "倒计时激活：%s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "标记单位：%s",
    ["SLASH_DEBUG_REMAINING"] = "剩余：%.1f秒",
    ["SLASH_DEBUG_POSITION_SAVED"] = "保存的位置：x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "保存的位置：未设置",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "当前窗口位置：x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "窗口可移动：%s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "锁定位置设置：%s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "在设置中启用调试模式以获取详细检测信息",
    ["SLASH_TEST_MYTHIC"] = "测试神话检测...",
    ["SLASH_TEST_HEAD_SLOT"] = "头部槽位物品：%s",
    ["SLASH_TEST_ITEM_LINK"] = "物品链接：%s",
    ["SLASH_TEST_IS_WARMASK"] = "是暖面罩：%s",
    ["SLASH_TEST_LOOKING_FOR"] = "查找：'%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "头部槽位：空",
    ["SLASH_POS_INFO"] = "位置信息：",
    ["SLASH_POS_ANCHOR"] = "当前锚点：",
    ["SLASH_POS_POINT"] = "点：%s",
    ["SLASH_POS_RELATIVE_TO"] = "相对到：%s",
    ["SLASH_POS_RELATIVE_POINT"] = "相对点：%s",
    ["SLASH_POS_OFFSET_X"] = "偏移X：%s",
    ["SLASH_POS_OFFSET_Y"] = "偏移Y：%s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "窗口已隐藏：%s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "窗口可移动：%s",
    ["SLASH_POS_TEST_RESTORE"] = "测试位置恢复...",
    ["SLASH_POS_AFTER_RESTORE"] = "恢复后 - 偏移X：%s, Y：%s",
    ["SLASH_POS_DIFFERENCE"] = "差异：x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "主窗口：未创建",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "未找到LibAddonMenu-2.0。设置菜单不可用。",
    ["SETTINGS_POSITION_RESET"] = "图标位置已重置到中心（已保存到SavedVariables）",
    ["SETTINGS_ICON_SCALE_SET"] = "图标缩放设置为 %s%%",
    ["SETTINGS_FONT_SCALE_SET"] = "字体缩放设置为 %s%%",
}

WM.RegisterLanguage("zh", strings)
return strings

