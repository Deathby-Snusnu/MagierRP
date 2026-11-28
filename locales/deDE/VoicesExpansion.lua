-- SPDX-License-Identifier: CC-BY-SA-4.0
-- Additive, original mage spell and ambient voices; no event handlers.
local _, addon = ...
local root = addon.localeData.deDE
local function add(existing, texts)
    if type(existing) ~= "table" then return end
    for _, line in ipairs(texts) do
        local found = false
        for _, old in ipairs(existing) do if old == line then found = true; break end end
        if not found then existing[#existing + 1] = line end
    end
end
add(root.texts.ARCANE_BLAST.gruppe, { "Die Gleichung ist stabil. Nur der Raum daneben nicht.", "*zieht vier leuchtende Linien zusammen, bis die Luft unter ihrer Spannung knistert.*" })
add(root.texts.ICE_LANCE.gruppe, { "Ein sauberer Eiskristall braucht weder Drohung noch Erklärung.", "*dreht die Hand und schleudert eine schmale, funkelnde Frostspitze fort.*" })
add(root.texts.POLYMORPH.gruppe, { "Die Verwandlung ist vorübergehend. Der Spott vermutlich nicht.", "*zeichnet einen winzigen Kreis in die Luft und hebt prüfend eine Augenbraue.*" })
add(root.texts.PORTAL.gruppe, { "Bitte nur einzeln durch das Portal. Die letzte Gruppe endete im Bücherregal.", "*prüft den Rand des schimmernden Durchgangs mit einem vorsichtigen Finger.*" })
add(root.texts.FIREBALL.gruppe, { "Die Brennkurve ist wunderschön. Die Sicherheitsabstände leider nicht.", "*bläst auf eine glimmende Rune, die augenblicklich zu einer Feuerkugel wächst.*" })
add(root.ambient.GNOME, { "Meine Versuchsanordnung ist sicher. Ich habe sie zweimal gefragt.", "*schiebt eine rauchende Spule unauffällig hinter den Zauberhut.*" })
add(root.ambient.HUMAN, { "Ein kluger Magier kennt nicht nur seine Macht, sondern auch ihre Grenzen.", "*ordnet die Formeln sorgfältig nach Schwierigkeit und Risiko.*" })
add(root.ambient.BLOODELF, { "Selbst eine kleine Rune verdient eine makellose Ausführung.", "*richtet einen Kristall aus, bis sein Licht genau in der Mitte ruht.*" })
