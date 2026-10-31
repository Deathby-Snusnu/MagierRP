-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
local friendly = { ARCANE_INTELLECT=true, ARCANE_BRILLIANCE=true, SLOW_FALL=true, REMOVE_LESSER_CURSE=true, DAMPEN_MAGIC=true, AMPLIFY_MAGIC=true }
local selfOnly = { ICE_BARRIER=true, ICE_BLOCK=true, BLINK=true, EVOCATION=true, MANA_SHIELD=true, CONJURE_FOOD=true, CONJURE_WATER=true, CREATE_MANA_GEM=true, PORTAL=true, TELEPORT=true }
function addon.BuildText(key)
    local lang = addon.db.outputLanguage
    if not addon.availableLocales[lang] then lang = "deDE" end
    local entries = addon.localeData[lang] and addon.localeData[lang].texts
    local entry = (entries and entries[key]) or (addon.localeData.deDE.texts and addon.localeData.deDE.texts[key])
    if type(entry) ~= "table" then return nil end
    local target = nil
    if friendly[key] then
        target = UnitExists("target") and UnitCanAssist("player", "target") and UnitName("target") or UnitName("player")
    elseif not selfOnly[key] and UnitExists("target") then
        target = UnitName("target")
    end
    local pool = target and entry.ziel or entry.gruppe
    -- Give a known race its own voice on some casts; fall back to spell pool.
    local _, race = UnitRace("player")
    race = addon.NormalizeRace(race)
    local racial = addon.localeData[lang] and addon.localeData[lang].racial
    local racePool = racial and racial[race] and racial[race][key]
    if type(racePool) == "table" and #racePool > 0 and math.random(100) <= (addon.db.racialTextChance or 40) then
        pool = racePool
    end
    if type(pool) ~= "table" or #pool == 0 then pool = entry.gruppe end
    if type(pool) ~= "table" or #pool == 0 then return nil end
    return pool[math.random(#pool)]:gsub("%%([%%s])", function(token)
        return token == "%" and "%" or (target or "")
    end)
end
