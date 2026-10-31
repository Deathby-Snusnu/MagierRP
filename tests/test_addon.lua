-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Source-only regression tests; run with Lua 5.1 or 5.4 from the addon folder.
local scriptPath = (arg and arg[0] or "tests/test_addon.lua"):gsub("\\", "/")
local root = scriptPath:match("^(.*)tests/test_addon%.lua$") or "./"

local function equal(actual, expected, label)
    assert(actual == expected, (label or "value") .. ": expected " ..
        tostring(expected) .. ", got " .. tostring(actual))
end

local function contains(value, fragment, label)
    assert(type(value) == "string" and value:find(fragment, 1, true),
        (label or "text") .. ": expected " .. tostring(value) ..
        " to contain " .. tostring(fragment))
end

local function loadInEnvironment(path, environment)
    local chunk, err
    if setfenv then
        chunk, err = loadfile(path)
        assert(chunk, err)
        setfenv(chunk, environment)
    else
        chunk, err = loadfile(path, "t", environment)
        assert(chunk, err)
    end
    return chunk
end

local function newAddon(savedDatabase)
    local state = {
        class = "MAGE",
        race = "GNOME",
        target = "Anduin",
        player = "Aegwynn",
        canAssist = true,
        canAttack = true,
        now = 100,
        roll = 1,
        choice = 1,
        sent = {},
        messages = {},
        frames = {},
        loaded = {},
    }
    local environment = {
        assert = assert,
        error = error,
        ipairs = ipairs,
        next = next,
        pairs = pairs,
        pcall = pcall,
        select = select,
        setmetatable = setmetatable,
        string = string,
        table = table,
        tonumber = tonumber,
        tostring = tostring,
        type = type,
        math = {},
    }
    for key, value in pairs(math) do
        environment.math[key] = value
    end
    environment.math.random = function(limit)
        if limit == 100 then return state.roll end
        if limit then return math.min(state.choice, limit) end
        return 0.5
    end
    environment._G = environment
    environment.SlashCmdList = {}
    environment.MagierRP_CharacterDB = savedDatabase
    environment.print = function(message)
        state.messages[#state.messages + 1] = tostring(message)
    end
    environment.UnitClass = function() return "Mage", state.class end
    environment.UnitRace = function() return "Gnome", state.race end
    environment.UnitExists = function(unit)
        return unit == "target" and state.target ~= nil
    end
    environment.UnitCanAssist = function(_, unit)
        return unit == "target" and state.canAssist
    end
    environment.UnitCanAttack = function(_, unit)
        return unit == "target" and state.canAttack
    end
    environment.UnitIsUnit = function(a, b)
        return a == "target" and b == "player" and state.target == state.player
    end
    environment.UnitName = function(unit)
        if unit == "player" then return state.player end
        return state.target
    end
    environment.GetTime = function() return state.now end
    environment.SendChatMessage = function(text, channel)
        state.sent[#state.sent + 1] = { text = text, channel = channel }
    end
    environment.CreateFrame = function()
        local frame = { events = {}, scripts = {} }
        function frame:RegisterEvent(event) self.events[event] = true end
        function frame:SetScript(event, callback) self.scripts[event] = callback end
        state.frames[#state.frames + 1] = frame
        return frame
    end

    local namespace = {}
    local toc = assert(io.open(root .. "MagierRP.toc", "r"))
    for line in toc:lines() do
        line = line:match("^%s*(.-)%s*$")
        if line ~= "" and line:sub(1, 1) ~= "#" then
            local path = line:gsub("\\", "/")
            state.loaded[#state.loaded + 1] = path
            loadInEnvironment(root .. path, environment)("MagierRP", namespace)
        end
    end
    toc:close()

    function state.login()
        for _, frame in ipairs(state.frames) do
            if frame.events.PLAYER_LOGIN then
                frame.scripts.OnEvent(frame, "PLAYER_LOGIN")
            end
        end
    end
    function state.command(message)
        environment.SlashCmdList.MAGIERRP(message)
    end
    return environment, namespace, state
end

local tests = {}
local function test(name, callback)
    tests[#tests + 1] = { name = name, callback = callback }
end

test("TOC loads the private addon and login initializes saved variables", function()
    local env, app, state = newAddon()
    equal(state.loaded[1], "config/Settings.lua")
    equal(state.loaded[#state.loaded], "MagierRP.lua")
    equal(env.MagierRP, app)
    equal(app.ready, false)
    equal(app.TryText("FIREBALL"), false)
    state.login()
    equal(app.ready, true)
    equal(env.MagierRP_CharacterDB.textChance, 100)
    equal(env.MagierRP_CharacterDB.cooldown, 0)
    equal(env.MagierRP_CharacterDB.outputLanguage, "deDE")
    equal(env.MagierRP_CharacterDB.racialTextChance, 40)
end)

test("saved settings are preserved and invalid racial chance is clamped", function()
    local db = {
        textChance = 35,
        cooldown = 7,
        outputLanguage = "frFR",
        racialTextChance = 150,
        custom = "preserved",
    }
    local env, _, state = newAddon(db)
    state.login()
    equal(env.MagierRP_CharacterDB, db)
    equal(db.textChance, 35)
    equal(db.cooldown, 7)
    equal(db.outputLanguage, "frFR")
    equal(db.racialTextChance, 100)
    equal(db.custom, "preserved")
end)

test("localized text resolves targets and falls back for unavailable languages", function()
    local _, app, state = newAddon()
    state.login()
    app.db.racialTextChance = 0
    app.db.outputLanguage = "enUS"
    contains(app.BuildText("FIREBALL"), "Anduin", "English target text")
    app.db.outputLanguage = "missing"
    contains(app.BuildText("FIREBALL"), "Anduin", "German fallback target text")
    state.canAssist = false
    assert(not app.BuildText("ARCANE_INTELLECT"):find("Anduin", 1, true), "self buff leaked selected enemy")
    assert(not app.BuildText("ARCANE_INTELLECT"):find("Aegwynn", 1, true), "self buff named caster")
    state.canAssist = true
    contains(app.BuildText("ARCANE_INTELLECT"), "Anduin", "real friendly target")
end)

test("self, armor, conjure and area spells do not mention a selected opponent", function()
    local _, app, state = newAddon()
    state.login()
    app.db.racialTextChance = 0
    state.canAssist = false
    state.canAttack = true
    local untargeted = {
        "ICE_BARRIER", "ICE_BLOCK", "FROST_ARMOR", "ICE_ARMOR", "MAGE_ARMOR",
        "FIRE_WARD", "FROST_WARD", "MANA_SHIELD", "ARCANE_POWER",
        "ARCANE_BRILLIANCE", "EVOCATION", "BLINK", "COLD_SNAP",
        "CONJURE_FOOD", "CONJURE_WATER", "CREATE_MANA_GEM",
        "CONJURE_MANA_RUBY", "PORTAL_STORMWIND", "TELEPORT_IRONFORGE",
        "FROST_NOVA", "BLIZZARD", "FLAMESTRIKE",
    }
    for _, key in ipairs(untargeted) do
        local line = app.BuildText(key)
        assert(type(line) == "string", "missing " .. key)
        assert(not line:find("Anduin", 1, true), key .. " leaked selected target")
        assert(not line:find("Aegwynn", 1, true), key .. " named caster")
    end
    state.canAttack = false
    local line = app.BuildText("ICE_LANCE")
    assert(not line:find("Anduin", 1, true), "hostile-only spell used friendly selection")
end)

test("racial spell pools are selected at the configured chance", function()
    local _, app, state = newAddon()
    state.login()
    app.db.outputLanguage = "deDE"
    app.db.racialTextChance = 100
    state.race = "GNOME"
    equal(app.BuildText("FIREBALL"), app.localeData.deDE.racial.GNOME.FIREBALL[1])
end)

test("slash aliases, class restriction, chance, and cooldown are enforced", function()
    local env, app, state = newAddon()
    equal(env.SLASH_MAGIERRP1, "/mrp")
    equal(env.SLASH_MAGIERRP2, "/magierrp")
    equal(app.TryText("FIREBALL"), false)
    state.login()
    state.command("list")
    contains(table.concat(state.messages, "\n"), "Zauberschluessel")
    app.db.textChance = 0
    equal(app.TryText("FIREBALL"), false)
    equal(#state.sent, 0)
    app.db.textChance = 100
    app.db.cooldown = 10
    equal(app.TryText("FIREBALL"), true)
    equal(app.TryText("FIREBALL"), false)
    state.now = 110
    equal(app.TryText("FIREBALL"), true)
    state.class = "PRIEST"
    equal(app.TryText("FIREBALL"), false)
    -- Ignored classes must not emit warning spam.
    equal(app.TryText("FIREBALL"), false)
end)

test("manual ambient and emotes use the intended chat channels", function()
    local _, app, state = newAddon()
    state.login()
    app.db.textChance = 100
    app.db.cooldown = 0
    state.command("ambient")
    equal(state.sent[1].channel, "SAY")
    app.BuildText = function() return "*hebt die Hand.*" end
    equal(app.TryText("FIREBALL"), true)
    equal(state.sent[2].channel, "EMOTE")
    equal(state.sent[2].text, "hebt die Hand.")
end)

for _, item in ipairs(tests) do
    local ok, err = pcall(item.callback)
    if not ok then
        io.stderr:write("FAIL: " .. item.name .. "\n" .. tostring(err) .. "\n")
        os.exit(1)
    end
end

print("MagierRP: " .. #tests .. " source-only tests passed")
