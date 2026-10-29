local _, addon = ...
function addon.AmbientText()
    local lang = addon.db.outputLanguage
    if not addon.availableLocales[lang] then lang = "deDE" end
    local data = addon.localeData[lang].ambient or addon.localeData.deDE.ambient
    local _, race = UnitRace("player")
    race = addon.NormalizeRace(race)
    local pool = data[race] or data.NEUTRAL
    if type(pool) ~= "table" or #pool == 0 then pool = data.NEUTRAL end
    return pool[math.random(#pool)]
end

-- Zeitgesteuerte Ambient-Ausgaben mit Abbruch alter Timer nach Einstellungswechsel.
local generation = 0
function addon.ResetAmbientTimer()
    generation = generation + 1
    local current = generation
    if not addon.ready or not addon.db or not addon.db.ambientEnabled then return end
    if not C_Timer or type(C_Timer.After) ~= "function" then return end
    local min = math.floor(addon.db.ambientMinInterval or 120)
    local max = math.floor(addon.db.ambientMaxInterval or 300)
    if min < 30 then min = 30 end
    if max < min then max = min end
    local function Schedule()
        local delay = math.random(min, max)
        C_Timer.After(delay, function()
            if current ~= generation or not addon.db.ambientEnabled then return end
            if addon.TryAmbient then addon.TryAmbient(nil, false) end
            if current == generation and addon.db.ambientEnabled then Schedule() end
        end)
    end
    Schedule()
end
