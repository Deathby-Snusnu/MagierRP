-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
_G.MagierRP = addon
addon.spellKeys = { "FIREBALL", "FROSTBOLT", "ARCANE_MISSILES", "FIRE_BLAST", "PYROBLAST", "FLAMESTRIKE", "SCORCH", "BLIZZARD", "FROST_NOVA", "CONE_OF_COLD", "ICE_BARRIER", "ICE_BLOCK", "ARCANE_EXPLOSION", "COUNTERSPELL", "POLYMORPH", "BLINK", "SLOW_FALL", "EVOCATION", "ARCANE_INTELLECT", "ARCANE_BRILLIANCE", "MANA_SHIELD", "CONJURE_FOOD", "CONJURE_WATER", "CREATE_MANA_GEM", "PORTAL", "TELEPORT", "REMOVE_LESSER_CURSE", "DETECT_MAGIC", "DAMPEN_MAGIC", "AMPLIFY_MAGIC", "FROST_ARMOR", "ICE_ARMOR", "MAGE_ARMOR", "FIRE_WARD", "FROST_WARD", "ARCANE_BLAST", "ARCANE_WRATH", "ARCANE_POWER", "PRESENCE_OF_MIND", "BLAST_WAVE", "COMBUSTION", "FROSTFIRE_BOLT", "FELFIRE", "ICE_LANCE", "FROST_BLAST", "COLD_SNAP", "CONJURE_MANA_AGATE", "CONJURE_MANA_JADE", "CONJURE_MANA_CITRINE", "CONJURE_MANA_RUBY", "POLYMORPH_COW", "COMPREHEND_SCROLL", "STUDY", "TELEPORT_STORMWIND", "PORTAL_STORMWIND", "TELEPORT_IRONFORGE", "PORTAL_IRONFORGE", "TELEPORT_DARNASSUS", "PORTAL_DARNASSUS", "TELEPORT_DALARAN", "PORTAL_DALARAN", "TELEPORT_ORGRIMMAR", "PORTAL_ORGRIMMAR", "TELEPORT_UNDERCITY", "PORTAL_UNDERCITY", "TELEPORT_THUNDER_BLUFF", "PORTAL_THUNDER_BLUFF" }
addon.ready = false
function addon.TryAmbient(_, force)
    if force == nil then force = true end
    if not addon.ready or not addon.CooldownReady() then return false end
    if not force and not addon.db.ambientEnabled then return false end
    if not addon.db.ambientInCombat and UnitAffectingCombat and UnitAffectingCombat("player") then return false end
    local _, class = UnitClass("player")
    if class ~= "MAGE" then return false end
    if not force and math.random(100) > addon.db.ambientChance then return false end
    if math.random(100) > addon.db.textChance then return false end
    if not addon.SendText(addon.AmbientText()) then return false end
    addon.StartCooldown(); return true
end
function addon.TryText(key)
    if not addon.ready then return false end
    local _, class = UnitClass("player")
    if class ~= "MAGE" then return false end
    if not addon.CooldownReady() then return false end
    if math.random(100) > addon.db.textChance then return false end
    local line = addon.BuildText(key)
    if not line or not addon.SendText(line) then return false end
    addon.StartCooldown()
    return true
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    addon.InitializeDatabase()
    addon.ready = true
    local _, class = UnitClass("player")
    print("|cff69ccffMagierRP 0.1.0 geladen.|r /mrp help fuer Befehle.")
    if class ~= "MAGE" then
        print("|cff69ccffMagierRP:|r Kein Magier. Einstellungen verfuegbar, RP-Ausgabe deaktiviert.")
    end
    if addon.ResetAmbientTimer then addon.ResetAmbientTimer() end
end)
