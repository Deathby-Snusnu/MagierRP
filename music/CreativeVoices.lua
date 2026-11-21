-- SPDX-License-Identifier: CC-BY-SA-4.0
-- Individually authored general RP dialogue and emotes, not song quotations.
local _, addon = ...
local entries = {
    FIREBALL = { deDE = { "Das ist keine Fackel. Das ist ein Argument mit Temperatur.", "*prüft mit hochgezogener Augenbraue den Tanz der Flammen.*" }, enUS = { "This is not a torch. It is an argument with a temperature.", "*raises an eyebrow at the dancing flames.*" }, frFR = { "Ce n'est pas une torche. C'est un argument brûlant.", "*hausse un sourcil devant la danse des flammes.*" } },
    FROSTBOLT = { deDE = { "Manche Gespräche verlangen einen kühleren Ton.", "*zeichnet eine scharfkantige Schneeflocke in die Luft.*" }, enUS = { "Some discussions call for a cooler tone.", "*draws a sharp-edged snowflake in the air.*" }, frFR = { "Certaines discussions demandent un ton plus froid.", "*trace un flocon aux arêtes tranchantes dans l'air.*" } },
    ARCANE_MISSILES = { deDE = { "Sechs Berechnungen. Fünf Widersprüche. Ein ausgezeichnetes Ergebnis.", "*schickt eine Folge glitzernder Runen auf ihre Reise.*" }, enUS = { "Six calculations. Five contradictions. An excellent outcome.", "*sets a cascade of glowing runes in motion.*" }, frFR = { "Six calculs. Cinq contradictions. Un résultat magnifique.", "*déclenche une cascade de runes étincelantes.*" } },
    POLYMORPH = { deDE = { "Die Theorie ist bezaubernd. Das Versuchstier weniger.", "*notiert die Körpermaße eines unerwarteten Wiederkäuers.*" }, enUS = { "The theory is delightful. The test subject less so.", "*jots down the dimensions of an unexpected ruminant.*" }, frFR = { "La théorie est charmante. Le sujet d'essai, moins.", "*note les dimensions d'un ruminant inattendu.*" } },
    BLINK = { deDE = { "Ich bleibe nicht stehen, nur weil die Welt darauf besteht.", "*faltet die Entfernung zwischen zwei Schritten zusammen.*" }, enUS = { "I will not stand still just because the world insists.", "*folds the distance between two steps.*" }, frFR = { "Je ne vais pas m'arrêter parce que le monde insiste.", "*replie la distance entre deux pas.*" } },
    ARCANE_BLAST = { deDE = { "Ein universeller Grundsatz: Mehr Energie schafft neue Probleme.", "*beobachtet nervös, wie die Runenkanten zu leuchten beginnen.*" }, enUS = { "A universal rule: More energy creates new problems.", "*watches nervously as rune edges start to glow.*" }, frFR = { "Une loi universelle : plus d'énergie crée de nouveaux problèmes.", "*regarde nerveusement les runes se mettre à luire.*" } },
    PORTAL = { deDE = { "Für Durchgänge hafte ich. Für Ankunftsorte nur bedingt.", "*kontrolliert die andere Seite durch einen winzigen Spalt.*" }, enUS = { "I guarantee the doorway. The destination is another matter.", "*peeks through a tiny gap to inspect the other side.*" }, frFR = { "Je garantis la porte. Pour la destination, c'est autre chose.", "*jette un regard à travers une étroite ouverture.*" } },
}
for key, translations in pairs(entries) do
    for _, language in ipairs({"deDE","enUS","frFR"}) do
        local locale = addon.localeData and addon.localeData[language]
        local source = locale and locale.texts and locale.texts[key]
        local pool = source and source.gruppe
        if type(pool) == "table" then
            for _, line in ipairs(translations[language]) do
                local exists = false
                for _, previous in ipairs(pool) do
                    if previous == line then exists = true; break end
                end
                if not exists then pool[#pool+1] = line end
            end
        end
    end
end
