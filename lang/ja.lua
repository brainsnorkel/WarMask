-- =============================================================================
-- Warmask Localization - Japanese
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

local strings = {
    -- UI Strings
    ["BASH_SOMETHING"] = "何かをバッシュ",
    ["TARGET"] = "ターゲット",
    
    -- Settings Menu
    ["SETTINGS_PANEL_NAME"] = "Warmask",
    ["SETTINGS_PANEL_DISPLAY"] = "|cFFD700Warmask|r",
    ["SETTINGS_HEADER_HOW_IT_WORKS"] = "動作方法",
    ["SETTINGS_DESC_MAIN"] = "ハンツマンのウォーマスクを装備しているときに追跡アイコンを表示します。ターゲットをバッシュした後、60秒のカウントダウンを表示します。",
    ["SETTINGS_DESC_STATES"] = "|c00FF00準備完了|r - ターゲットをバッシュして追跡を開始します。追跡対象は、バッシュしたターゲットに変更されます。\n|cFF4D4Dクールダウン|r (60秒-50秒) - 内部クールダウンがアクティブです。バッシュしても追跡対象は変更されません。\n|c00FF00カウントダウン|r (49秒-0秒) - 新しいターゲットをバッシュする準備ができています。バッシュすると追跡対象が更新されます。",
    ["SETTINGS_DESC_TRACKING"] = "追跡対象の名前がアイコンの横に表示されます。カウントダウンは期限切れまたは戦闘終了時に準備完了にリセットされます。",
    ["SETTINGS_HEADER_ICON"] = "アイコン設定",
    ["SETTINGS_LOCK_POSITION"] = "アイコン位置をロック",
    ["SETTINGS_LOCK_POSITION_TOOLTIP"] = "有効にすると、アイコンを移動できません。無効にすると、アイコンを新しい位置にドラッグできます。",
    ["SETTINGS_RESET_POSITION"] = "アイコン位置をリセット",
    ["SETTINGS_RESET_POSITION_TOOLTIP"] = "アイコンを画面の中央にリセットします。",
    ["SETTINGS_ICON_SCALE"] = "アイコンスケール",
    ["SETTINGS_ICON_SCALE_TOOLTIP"] = "アイコンサイズを調整します。範囲：50%から200%。",
    ["SETTINGS_FONT_SCALE"] = "フォントスケール",
    ["SETTINGS_FONT_SCALE_TOOLTIP"] = "テキストとカウントダウンタイマーのサイズを調整します。範囲：50%から400%。",
    ["SETTINGS_FONT_FAMILY"] = "フォントファミリー",
    ["SETTINGS_FONT_FAMILY_TOOLTIP"] = "アドオンテキストに使用するフォントファミリーを選択します。",
    ["SETTINGS_FONT_FAMILY_SET"] = "フォントファミリーが %s に設定されました",
    ["SETTINGS_HIDE_OUT_OF_COMBAT"] = "戦闘外でアイコンを非表示",
    ["SETTINGS_HIDE_OUT_OF_COMBAT_TOOLTIP"] = "有効にすると、戦闘中でないときにアイコンが非表示になります。戦闘に入るとアイコンが自動的に表示されます。",
    ["SETTINGS_ROLEPLAYING_MODE"] = "ロールプレイモード",
    ["SETTINGS_ROLEPLAYING_MODE_TOOLTIP"] = "有効にすると、'何かをバッシュ'が'バッシュせよ、汝は'に変更され、より没入感のあるロールプレイ体験ができます。",
    ["SETTINGS_HEADER_LINE"] = "ライン設定",
    ["SETTINGS_ENABLE_LINE"] = "ターゲットへのラインを有効化",
    ["SETTINGS_ENABLE_LINE_TOOLTIP"] = "マークされたターゲットを見ているとき、キャラクターからマークされたターゲットまで線を描画します。",
    ["SETTINGS_HEADER_DEBUG"] = "デバッグ設定",
    ["SETTINGS_ENABLE_DEBUG"] = "デバッグ情報を有効化",
    ["SETTINGS_ENABLE_DEBUG_TOOLTIP"] = "有効にすると、アドオンの読み込み、バフ検出、イベント、ユニット名を含むバッシュ検出のデバッグメッセージをチャットに表示します。",
    ["SETTINGS_SLASH_COMMANDS"] = "|cAAAAAAスラッシュコマンド：|r\n/warmask - UIの表示/非表示を切り替え\n/wmdebug - デバッグ情報を表示\n/wmtest - 神話アイテム検出をテスト\n/wmpos - 位置デバッグ",
    
    -- Debug Messages
    ["DEBUG_ADDON_INITIALIZED"] = "アドオンが初期化されました - バージョン %s",
    ["DEBUG_MODE_ENABLED"] = "デバッグモードが有効になりました",
    ["DEBUG_MODE_DISABLED"] = "デバッグモードが無効になりました",
    ["DEBUG_UI_CREATED"] = "UIが作成されました",
    ["DEBUG_WARMASK_EQUIPPED"] = "ウォーマスクが装備されました",
    ["DEBUG_WARMASK_UNEQUIPPED"] = "ウォーマスクが外されました",
    ["DEBUG_ADDON_LOADED"] = "アドオンが読み込まれました - バージョン %s",
    ["DEBUG_ADDON_COMPLETE"] = "アドオンの初期化が完了しました",
    ["DEBUG_EVENTS_REGISTERED"] = "イベントが登録されました：PLAYER_ACTIVATED, INVENTORY_SINGLE_SLOT_UPDATE, EFFECT_CHANGED, COMBAT_EVENT, PLAYER_COMBAT_STATE, RETICLE_TARGET_CHANGED",
    
    -- Slash Commands
    ["SLASH_UI_SHOWN"] = "UIが表示されました",
    ["SLASH_UI_HIDDEN"] = "UIが非表示になりました",
    ["SLASH_DEBUG_INFO"] = "デバッグ情報：",
    ["SLASH_DEBUG_WARMASK_EQUIPPED"] = "神話ウォーマスクが装備されています：%s",
    ["SLASH_DEBUG_WARMASK_BUFF"] = "ウォーマスクバフがアクティブ：%s",
    ["SLASH_DEBUG_UI_SHOULD_SHOW"] = "UIを表示する必要があります：%s",
    ["SLASH_DEBUG_UI_HIDDEN"] = "UIが非表示：%s",
    ["SLASH_DEBUG_COUNTDOWN_ACTIVE"] = "カウントダウンがアクティブ：%s",
    ["SLASH_DEBUG_MARKED_UNIT"] = "マークされたユニット：%s",
    ["SLASH_DEBUG_REMAINING"] = "残り：%.1f秒",
    ["SLASH_DEBUG_POSITION_SAVED"] = "保存された位置：x=%s, y=%s",
    ["SLASH_DEBUG_POSITION_NOT_SET"] = "保存された位置：設定されていません",
    ["SLASH_DEBUG_POSITION_CURRENT"] = "現在のウィンドウ位置：x=%s, y=%s",
    ["SLASH_DEBUG_WINDOW_MOVABLE"] = "ウィンドウが移動可能：%s",
    ["SLASH_DEBUG_LOCK_POSITION"] = "位置ロック設定：%s",
    ["SLASH_DEBUG_ENABLE_DEBUG"] = "詳細な検出情報については、設定でデバッグモードを有効にしてください",
    ["SLASH_TEST_MYTHIC"] = "神話アイテム検出をテスト中...",
    ["SLASH_TEST_HEAD_SLOT"] = "頭スロットのアイテム：%s",
    ["SLASH_TEST_ITEM_LINK"] = "アイテムリンク：%s",
    ["SLASH_TEST_IS_WARMASK"] = "ウォーマスクです：%s",
    ["SLASH_TEST_LOOKING_FOR"] = "検索中：'%s'",
    ["SLASH_TEST_HEAD_EMPTY"] = "頭スロット：空",
    ["SLASH_POS_INFO"] = "位置情報：",
    ["SLASH_POS_ANCHOR"] = "現在のアンカー：",
    ["SLASH_POS_POINT"] = "ポイント：%s",
    ["SLASH_POS_RELATIVE_TO"] = "相対：%s",
    ["SLASH_POS_RELATIVE_POINT"] = "相対ポイント：%s",
    ["SLASH_POS_OFFSET_X"] = "オフセットX：%s",
    ["SLASH_POS_OFFSET_Y"] = "オフセットY：%s",
    ["SLASH_POS_WINDOW_HIDDEN"] = "ウィンドウが非表示：%s",
    ["SLASH_POS_WINDOW_MOVABLE"] = "ウィンドウが移動可能：%s",
    ["SLASH_POS_TEST_RESTORE"] = "位置の復元をテスト中...",
    ["SLASH_POS_AFTER_RESTORE"] = "復元後 - オフセットX：%s, Y：%s",
    ["SLASH_POS_DIFFERENCE"] = "差：x=%.3f, y=%.3f",
    ["SLASH_POS_WINDOW_NOT_CREATED"] = "メインウィンドウ：作成されていません",
    
    -- Settings Messages
    ["SETTINGS_LAM_NOT_FOUND"] = "LibAddonMenu-2.0が見つかりません。設定メニューは利用できません。",
    ["SETTINGS_POSITION_RESET"] = "アイコン位置が中央にリセットされました（SavedVariablesに保存されました）",
    ["SETTINGS_ICON_SCALE_SET"] = "アイコンスケールが %s%% に設定されました",
    ["SETTINGS_FONT_SCALE_SET"] = "フォントスケールが %s%% に設定されました",
}

WM.RegisterLanguage("ja", strings)
return strings

