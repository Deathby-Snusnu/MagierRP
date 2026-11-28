-- SPDX-License-Identifier: CC-BY-SA-4.0
-- Additive, original mage spell and ambient voices; no event handlers.
local _, addon = ...
local root = addon.localeData.enUS
local function add(existing, texts)
    if type(existing) ~= "table" then return end
    for _, line in ipairs(texts) do
        local found = false
        for _, old in ipairs(existing) do if old == line then found = true; break end end
        if not found then existing[#existing + 1] = line end
    end
end
add(root.texts.ARCANE_BLAST.gruppe, { "The equation holds. The surrounding space may not.", "*pulls four glowing lines together until the air crackles under the strain.*" })
add(root.texts.ICE_LANCE.gruppe, { "A perfect shard of ice needs neither threat nor explanation.", "*turns a wrist and sends a narrow, glittering lance of frost forward.*" })
add(root.texts.POLYMORPH.gruppe, { "The transformation is temporary. The teasing may not be.", "*draws a tiny circle in the air and raises a questioning eyebrow.*" })
add(root.texts.PORTAL.gruppe, { "One at a time through the portal, please. The last group landed in a bookcase.", "*tests the edge of the shimmering passage with a cautious finger.*" })
add(root.texts.FIREBALL.gruppe, { "The burn curve is magnificent. The safety margin is not.", "*breathes upon a glowing rune that swells into a ball of fire.*" })
add(root.ambient.GNOME, { "My experiment is perfectly safe. I asked it twice.", "*quietly hides a smoking coil behind the wizard hat.*" })
add(root.ambient.HUMAN, { "A wise mage knows not only their power but also its limits.", "*arranges formulae carefully by difficulty and risk.*" })
add(root.ambient.BLOODELF, { "Even the smallest rune deserves flawless execution.", "*aligns a crystal until its light rests exactly at the center.*" })
