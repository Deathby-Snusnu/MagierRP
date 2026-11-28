-- SPDX-License-Identifier: CC-BY-SA-4.0
-- Additive, original mage spell and ambient voices; no event handlers.
local _, addon = ...
local root = addon.localeData.frFR
local function add(existing, texts)
    if type(existing) ~= "table" then return end
    for _, line in ipairs(texts) do
        local found = false
        for _, old in ipairs(existing) do if old == line then found = true; break end end
        if not found then existing[#existing + 1] = line end
    end
end
add(root.texts.ARCANE_BLAST.gruppe, { "L'équation tient bon. L'espace autour, peut-être pas.", "*réunit quatre traits lumineux jusqu'à faire crépiter l'air sous la tension.*" })
add(root.texts.ICE_LANCE.gruppe, { "Un cristal de glace parfait n'a besoin ni de menace ni d'explication.", "*tourne le poignet et projette une fine lance de givre scintillante.*" })
add(root.texts.POLYMORPH.gruppe, { "La transformation est provisoire. Les moqueries le seront moins.", "*trace un petit cercle dans l'air et arque un sourcil interrogateur.*" })
add(root.texts.PORTAL.gruppe, { "Une personne à la fois dans le portail. Le dernier groupe a fini dans une bibliothèque.", "*teste du doigt le bord du passage scintillant avec prudence.*" })
add(root.texts.FIREBALL.gruppe, { "La courbe de combustion est superbe. La marge de sécurité, moins.", "*souffle sur une rune rougeoyante qui grossit en boule de feu.*" })
add(root.ambient.GNOME, { "Mon expérience est parfaitement sûre. Je lui ai posé la question deux fois.", "*cache discrètement une bobine fumante derrière son chapeau.*" })
add(root.ambient.HUMAN, { "Un mage avisé connaît son pouvoir et ses limites.", "*classe ses formules par difficulté et par risque.*" })
add(root.ambient.BLOODELF, { "Même la plus petite rune mérite une exécution parfaite.", "*aligne un cristal jusqu'à centrer exactement sa lumière.*" })
