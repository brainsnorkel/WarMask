-- =============================================================================
-- Warmask Localization System
-- =============================================================================

WarMask = WarMask or {}
local WM = WarMask

-- Language strings storage
local languageStrings = {}

-- Register a language's strings
function WM.RegisterLanguage(langCode, strings)
    languageStrings[langCode] = strings
end

-- Get the current game language
local function GetGameLanguage()
    local lang = GetCVar("language.2")
    -- Map ESO language codes to our file names
    local langMap = {
        ["en"] = "en",
        ["de"] = "de",
        ["fr"] = "fr",
        ["es"] = "es",
        ["zh"] = "zh",
        ["zhcn"] = "zh",  -- Simplified Chinese
        ["zhtw"] = "zh",  -- Traditional Chinese (fallback to simplified)
        ["ru"] = "ru",    -- Russian
        ["ja"] = "ja",    -- Japanese
    }
    return langMap[lang] or "en"
end

-- Initialize localization after all language files are loaded
local function InitializeLocalization()
    local lang = GetGameLanguage()
    WM.L = languageStrings[lang] or languageStrings["en"] or {}
end

-- Helper function to get localized string with optional formatting
function WM.GetString(key, ...)
    if not WM.L then
        InitializeLocalization()
    end
    local str = WM.L[key] or key
    if select("#", ...) > 0 then
        return string.format(str, ...)
    end
    return str
end

-- Short alias for convenience
function WM.LS(key, ...)
    return WM.GetString(key, ...)
end

-- Initialize after a short delay to ensure all language files are loaded
zo_callLater(function()
    InitializeLocalization()
end, 100)
