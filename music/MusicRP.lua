-- SPDX-License-Identifier: CC-BY-SA-4.0
-- Original spoken lines and emotes; song titles are internal inspiration metadata.
local _, addon = ...
addon.musicRP = { deDE = {}, enUS = {}, frFR = {} }
addon.musicRPReferences = {}
addon.musicRPReferences.FIREBALL = { artist = "Metallica", song = "Fuel" }
addon.musicRP.deDE.FIREBALL = { "Feuer ist keine Lösung. Es ist eine sehr überzeugende Hypothese.", "*prüft drei Ventile und entfacht eine gefährlich helle Flamme.*" }
addon.musicRP.enUS.FIREBALL = { "Fire is not a solution. It is a compelling hypothesis.", "*checks three valves and ignites an alarmingly bright flame.*" }
addon.musicRP.frFR.FIREBALL = { "Le feu n'est pas une solution. C'est une hypothèse convaincante.", "*vérifie trois valves et allume une flamme inquiétante.*" }
addon.musicRPReferences.ARCANE_BLAST = { artist = "Pink Floyd", song = "Time" }
addon.musicRP.deDE.ARCANE_BLAST = { "Zeit ist relativ. Mein Experiment hingegen ist dringend.", "*vergleicht zwei Uhren, die beide rückwärts laufen.*" }
addon.musicRP.enUS.ARCANE_BLAST = { "Time is relative. My experiment is urgent.", "*compares two clocks that both run backward.*" }
addon.musicRP.frFR.ARCANE_BLAST = { "Le temps est relatif. Mon expérience est urgente.", "*compare deux horloges qui tournent à l'envers.*" }
addon.musicRPReferences.POLYMORPH = { artist = "Eurythmics", song = "Sweet Dreams (Are Made of This)" }
addon.musicRP.deDE.POLYMORPH = { "Jeder träumt von etwas. Dieses Wesen demnächst von Klee.", "*zählt vier Hufe und nickt zufrieden.*" }
addon.musicRP.enUS.POLYMORPH = { "Everyone dreams of something. This one will dream of clover.", "*counts four hooves and nods with satisfaction.*" }
addon.musicRP.frFR.POLYMORPH = { "Tout le monde rêve de quelque chose. Celui-ci rêvera de trèfle.", "*compte quatre sabots et hoche la tête.*" }
addon.musicRPReferences.ICE_BLOCK = { artist = "Alphaville", song = "Forever Young" }
addon.musicRP.deDE.ICE_BLOCK = { "Wer die Zeit anhalten will, muss sehr kalt denken.", "*steht reglos in kristallklarem Eis und blinzelt einmal.*" }
addon.musicRP.enUS.ICE_BLOCK = { "To stop time, one must think very cold thoughts.", "*stands inside clear ice and blinks once.*" }
addon.musicRP.frFR.ICE_BLOCK = { "Pour arrêter le temps, il faut penser très froid.", "*reste immobile dans la glace et cligne des yeux.*" }
addon.musicRPReferences.BLINK = { artist = "Knorkator", song = "Wir werden alle sterben" }
addon.musicRP.deDE.BLINK = { "Ich bin gleich wieder da! Hoffentlich am richtigen Ort.", "*verschwindet in einem Knall und hinterlässt einen einsamen Stiefelabdruck.*" }
addon.musicRP.enUS.BLINK = { "I will be right back! Hopefully in the right place.", "*vanishes with a pop, leaving one lonely boot print.*" }
addon.musicRP.frFR.BLINK = { "Je reviens ! Espérons au bon endroit.", "*disparaît dans un bruit sec en laissant une trace de botte.*" }
addon.musicRPReferences.PYROBLAST = { artist = "Rammstein", song = "Sonne" }
addon.musicRP.deDE.PYROBLAST = { "Ich wollte nur Licht. Nun haben wir eine kleine Sonne.", "*zieht eine glühende Kugel aus einem instabilen Runenkreis.*" }
addon.musicRP.enUS.PYROBLAST = { "I only wanted light. Now we have a small sun.", "*pulls a burning orb from an unstable rune circle.*" }
addon.musicRP.frFR.PYROBLAST = { "Je voulais juste de la lumière. Voici un petit soleil.", "*tire une sphère brûlante d'un cercle de runes instable.*" }
addon.musicRPReferences.ARCANE_INTELLECT = { artist = "Pink Floyd", song = "Another Brick in the Wall" }
addon.musicRP.deDE.ARCANE_INTELLECT = { "Wissen ist keine Mauer. Es sollte Türen öffnen.", "*sortiert lose Gedanken zu einem leuchtenden geometrischen Muster.*" }
addon.musicRP.enUS.ARCANE_INTELLECT = { "Knowledge is not a wall. It should open doors.", "*sorts loose thoughts into a glowing geometric pattern.*" }
addon.musicRP.frFR.ARCANE_INTELLECT = { "Le savoir n'est pas un mur. Il devrait ouvrir des portes.", "*ordonne des pensées en un motif géométrique lumineux.*" }
addon.musicRPReferences.PORTAL = { artist = "U2", song = "Where the Streets Have No Name" }
addon.musicRP.deDE.PORTAL = { "Jenseits dieses Kreises wartet ein Weg ohne Namen.", "*prüft die Portalränder und zeichnet ein Fragezeichen in die Luft.*" }
addon.musicRP.enUS.PORTAL = { "Beyond this circle is a road without a name.", "*checks the portal edges and draws a question mark in the air.*" }
addon.musicRP.frFR.PORTAL = { "Au-delà de ce cercle, une route sans nom vous attend.", "*vérifie les bords du portail et trace un point d'interrogation.*" }

function addon.ChooseMusicText(key)
    local db = addon.db
    if not db or not db.musicEnabled or (db.musicChance or 0) <= 0 then return nil end
    if math.random(100) > db.musicChance then return nil end
    local language = db.outputLanguage or "deDE"
    local texts = addon.musicRP[language] and addon.musicRP[language][key]
    if not texts then texts = addon.musicRP.deDE[key] end
    if type(texts) ~= "table" or #texts == 0 then return nil end
    return texts[math.random(#texts)]
end
