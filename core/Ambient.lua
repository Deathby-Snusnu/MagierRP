-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
