-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...

SLASH_MAGIERRP1 = "/mrp"
SLASH_MAGIERRP2 = "/magierrp"

local function Notify(message)
    print("|cff69ccffMagierRP:|r " .. tostring(message))
end
addon.Notify = Notify

local function ShowHelp()
    Notify("Befehle (auch /magierrp):")
    Notify("/mrp | /mrp help - diese Hilfe")
    Notify("/mrp status - Einstellungen anzeigen")
    Notify("/mrp list [all|racial] - Zauberschluessel anzeigen")
    Notify("/mrp <SCHLUESSEL> - RP-Text ausgeben, z.B. FIREBALL")
    Notify("/mrp ambient - einmaligen Ambient-Text versuchen")
    Notify("/mrp chance 0-100 | /mrp cooldown 0-3600")
    Notify("/mrp racial 0-100 - Chance auf volkstypische Texte")
    Notify("/mrp language deDE|enUS|frFR")
    Notify("/mrp channel SAY|YELL|PARTY|RAID|INSTANCE_CHAT|AUTO")
    Notify("/mrp debug - Zustand und Textdaten pruefen")
    Notify("Mit *...* markierte Texte erscheinen als /me-Emote.")
end

local function ValidInteger(argument, maximum)
    if not argument:match("^%d+$") then return nil end
    local number = tonumber(argument)
    if not number or number < 0 or number > maximum or number % 1 ~= 0 then return nil end
    return number
end

local languages = { dede = "deDE", de = "deDE", enus = "enUS", en = "enUS", frfr = "frFR", fr = "frFR" }
local channels = { SAY=true, YELL=true, PARTY=true, RAID=true, INSTANCE_CHAT=true, AUTO=true }

local function SetNumber(argument, setting, maximum, title, usage)
    if argument == "" then
        Notify(title .. ": " .. tostring(addon.db[setting]))
        return
    end
    local number = ValidInteger(argument, maximum)
    if number == nil then
        Notify("Benutzung: /mrp " .. usage)
        return
    end
    addon.db[setting] = number
    Notify(title .. ": " .. tostring(number))
end

local function SetLanguage(argument)
    if argument == "" then Notify("Ausgabesprache: " .. tostring(addon.db.outputLanguage)); return end
    local language = languages[argument:lower()]
    if not language or not addon.availableLocales or not addon.availableLocales[language] then
        Notify("Benutzung: /mrp language deDE|enUS|frFR")
        return
    end
    addon.db.outputLanguage = language
    Notify("Ausgabesprache: " .. language)
end

local function SetChannel(argument)
    if argument == "" then Notify("Sprachkanal: " .. tostring(addon.db.chatChannel or "SAY")); return end
    local channel = argument:upper()
    if not channels[channel] then
        Notify("Benutzung: /mrp channel SAY|YELL|PARTY|RAID|INSTANCE_CHAT|AUTO")
        return
    end
    addon.db.chatChannel = channel
    Notify("Sprachkanal: " .. channel .. " (Emotes bleiben /me)")
end

local function GetKeys(mode)
    local keys, found = {}, {}
    local function Add(key)
        if type(key) == "string" and not found[key] then
            found[key] = true
            keys[#keys+1] = key
        end
    end
    -- In the generated mage addon, spellKeys is an explicit catalog.
    if mode ~= "racial" then
        for _, key in ipairs(addon.spellKeys or {}) do Add(key) end
    end
    -- Keep extra text keys visible when maintained directly with RP Text Studio.
    for _, locale in ipairs({addon.db.outputLanguage or "deDE", "deDE"}) do
        local data = addon.localeData and addon.localeData[locale]
        if type(data) == "table" then
            if mode ~= "racial" then
                for _, name in ipairs({"texts", "Texts"}) do
                    local pool = data[name]
                    if type(pool) == "table" then
                        for key in pairs(pool) do Add(key) end
                    end
                end
            end
            if mode == "racial" then
                local race = addon.NormalizeRace and addon.NormalizeRace(select(2, UnitRace("player"))) or select(2, UnitRace("player"))
                for _, name in ipairs({"racial", "Racial"}) do
                    local pool = data[name]
                    if type(pool) == "table" and type(pool[race]) == "table" then
                        for key in pairs(pool[race]) do Add(key) end
                    end
                end
            end
        end
    end
    table.sort(keys)
    return keys
end

local function ShowList(argument)
    local mode = argument:lower()
    if mode ~= "" and mode ~= "all" and mode ~= "racial" then
        Notify("Benutzung: /mrp list [all|racial]")
        return
    end
    local keys = GetKeys(mode)
    Notify("Zauberschluessel (" .. (mode == "" and "aktuell" or mode) .. "): " .. #keys)
    if #keys == 0 then Notify("Keine passenden Schluessel gefunden."); return end
    -- Avoid flooding WoW chat on large catalogs: split into small batches.
    for index = 1, #keys, 8 do
        local batch = {}
        for j = index, math.min(index + 7, #keys) do batch[#batch+1] = keys[j] end
        Notify(table.concat(batch, ", "))
    end
end

local function ShowStatus()
    local db = addon.db
    Notify("Status: " .. (addon.ready and "bereit" or "nicht initialisiert"))
    Notify("Textchance: " .. tostring(db.textChance) .. "% | Cooldown: " .. tostring(db.cooldown) .. "s")
    Notify("Sprache: " .. tostring(db.outputLanguage) .. " | Kanal: " .. tostring(db.chatChannel or "SAY"))
    Notify("Volkstypische Texte: " .. tostring(db.racialTextChance) .. "%")
    Notify("Ambient: manuell mit /mrp ambient")
end

local function ShowDebug()
    local race = select(2, UnitRace("player"))
    local class = select(2, UnitClass("player"))
    Notify("Debug: Klasse=" .. tostring(class) .. ", Rasse=" .. tostring(race))
    Notify("API=" .. type(_G.MagierRP) .. ", DB=" .. type(addon.db) ..
        ", bereit=" .. tostring(addon.ready))
    Notify("Katalogschluessel: " .. tostring(#(addon.spellKeys or {})) ..
        ", Sprache=" .. tostring(addon.db.outputLanguage))
end

SlashCmdList["MAGIERRP"] = function(message)
    local input = (message or ""):match("^%s*(.-)%s*$")
    local action, argument = input:match("^(%S+)%s*(.-)%s*$")
    action = action and action:lower() or "help"
    argument = argument or ""
    if not addon.ready or type(addon.db) ~= "table" then
        Notify("Noch nicht initialisiert. Bitte nach dem Login erneut versuchen.")
        return
    end
    if action == "help" or action == "?" then ShowHelp()
    elseif action == "status" then ShowStatus()
    elseif action == "list" then ShowList(argument)
    elseif action == "debug" then ShowDebug()
    elseif action == "chance" then SetNumber(argument,"textChance",100,"Textchance","chance <0-100>")
    elseif action == "cooldown" then SetNumber(argument,"cooldown",3600,"Cooldown","cooldown <0-3600>")
    elseif action == "racial" then SetNumber(argument,"racialTextChance",100,"Volkstypische Texte","racial <0-100>")
    elseif action == "language" then SetLanguage(argument)
    elseif action == "channel" then SetChannel(argument)
    elseif action == "ambient" then
        if argument ~= "" and argument:lower() ~= "test" then
            Notify("Benutzung: /mrp ambient [test]")
        elseif not addon.TryAmbient(nil, true) then
            Notify("Kein Ambient-Text ausgegeben (Chance, Cooldown oder Charakterklasse pruefen).")
        end
    else
        local key = input:upper()
        local known = false
        for _, catalogKey in ipairs(GetKeys("all")) do
            if catalogKey == key then known = true; break end
        end
        if not known then
            Notify("Unbekannter Befehl/Zauberschluessel: " .. key .. ". /mrp help")
        elseif not addon.TryText(key) then
            Notify("Keine Ausgabe fuer " .. key .. " (Chance, Cooldown, Textdaten oder Klasse pruefen).")
        end
    end
end
