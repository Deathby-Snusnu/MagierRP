-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
SLASH_MAGIERRP1 = "/mrp"
SLASH_MAGIERRP2 = "/magierrp"
SlashCmdList["MAGIERRP"] = function(message)
    local key = (message or ""):match("^%s*(.-)%s*$"):upper()
    if key == "" or key == "HELP" then
        print("MagierRP: /mrp list | /mrp <SCHLUESSEL>")
        return
    end
    if key == "AMBIENT" then addon.TryAmbient(); return end
    if key == "LIST" then
        print("MagierRP Zauberschluessel:")
        for _, spell in ipairs(addon.spellKeys) do print("  " .. spell) end
        return
    end
    addon.TryText(key)
end
