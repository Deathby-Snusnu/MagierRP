-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
-- Only explicitly targeted spells may name the selected unit. Many mage
-- spells are self-casts or area effects even when an unrelated target exists.
local friendlyTarget = {
    ARCANE_INTELLECT=true, SLOW_FALL=true, REMOVE_LESSER_CURSE=true,
    DAMPEN_MAGIC=true, AMPLIFY_MAGIC=true,
}
local hostileTarget = {
    FIREBALL=true, FROSTBOLT=true, ARCANE_MISSILES=true, FIRE_BLAST=true,
    PYROBLAST=true, SCORCH=true, COUNTERSPELL=true, POLYMORPH=true,
    ARCANE_BLAST=true, ARCANE_WRATH=true, FROSTFIRE_BOLT=true,
    FELFIRE=true, ICE_LANCE=true, FROST_BLAST=true, POLYMORPH_COW=true,
    DETECT_MAGIC=true,
}
local function SelectedTarget(key)
    if not UnitExists("target") then return nil end
    if friendlyTarget[key] then
        if not UnitCanAssist("player", "target") then return nil end
        -- A self-buff must never speak an unrelated selected unit's name.
        local name = UnitName("target")
        if type(UnitIsUnit) == "function" then
            if UnitIsUnit("target", "player") then return nil end
        elseif name == UnitName("player") then
            return nil
        end
        return name
    end
    if hostileTarget[key] then
        if type(UnitCanAttack) == "function" and not UnitCanAttack("player", "target") then
            return nil
        end
        return UnitName("target")
    end
    return nil
end
function addon.BuildText(key)
    local lang = addon.db.outputLanguage
    if not addon.availableLocales[lang] then lang = "deDE" end
    local entries = addon.localeData[lang] and addon.localeData[lang].texts
    local entry = (entries and entries[key]) or (addon.localeData.deDE.texts and addon.localeData.deDE.texts[key])
    if type(entry) ~= "table" then return nil end
    local target = SelectedTarget(key)
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
