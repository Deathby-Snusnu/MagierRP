# Entwicklungsquellen der MagierRP-Texte

Diese vier Python-Dateien wurden aus dem bisherigen RP-Text-Studio-Generator
als Entwicklungsquellen übernommen:

- `magier_spell_catalog.py`: Zauberschlüssel und mehrsprachige Textpools
- `magier_ambient_catalog.py`: Volkstypische Ambient-Texte
- `magier_voice_banks.py`: Themenspezifische Zaubertexte
- `magier_racial_spell_voices.py`: Rassen- und schulabhängige Varianten

**Wichtig:** Dies sind Entwicklungsdaten, **keine vom WoW-Client direkt
geladenen Lua-Dateien**. Änderungen an ihnen ändern die Runtime nicht
automatisch. Die geladenen Lua-Sprachdateien enthalten bereits Textpools,
darunter auch Texte, die in diesen Entwicklungsquellen vorkommen. Welche
Bestände vollständig übernommen wurden, ist hier nicht belegt. Weitere
Übernahmen in die Lua-Dateien müssen separat geprüft und getestet werden.
RP Text Studio erzeugt keine neuen AddOn-Quellcodeprojekte.

## Ausbau der Zaubertexte (deDE, enUS, frFR)

Die Laufzeitdateien `locales/{deDE,enUS,frFR}/Texts.lua` und
`locales/{deDE,enUS,frFR}/Racial.lua` enthalten die neu überarbeiteten
Texte für sämtliche 67 Magier-Zauberschlüssel und zehn Völker.

- `spell_revisions.tsv`: pro Zauber neu formulierte gesprochene Texte,
  zielbezogene Texte (falls relevant) und `*...*`-Emotes in drei Sprachen.
- `racial_spell_revisions.tsv`: zusätzliche, vom Volk und von der
  Zauberschule abhängige Magierstimmen in allen drei Sprachen.
- `translated_theme_expansions.tsv`: ergänzende übersetzte Zaubertexte,
  damit die Sprachfassungen vergleichbar umfangreich sind.
- `translated_target_variants.tsv`: zusätzliche englische und französische
  zielbezogene Texte für zehn Zauber.

**Die Lua-Dateien sind der aktuelle Laufzeitstand.** Die beiden TSV-Dateien
dokumentieren die neuen Formulierungen, sind aber selbst nicht vom WoW-Client
geladen. Ältere Python-Kataloge darunter können noch Formulierungen aus der
Zeit vor der Überarbeitung enthalten. Ein erneutes Generieren allein aus
diesen alten Quellen würde die Runtime-Texte zurücksetzen; für weitere
Arbeiten die aktuellen Lua-Pools als Ausgangsbasis verwenden.

Geändert wurden nur Zaubertextpools und rassespezifische Zauberstimmen.
Die allgemeinen Ambient- und Klassen-/Charakterdialoge blieben unangetastet.

## Lizenz

Die kreativen Textdaten und Übersetzungen stehen unter CC BY-SA 4.0.
Python-Auswahl- und Zusammenstellungslogik steht unter MPL-2.0.
Gemischte Dateien kennzeichnen beide Bestandteile mit
`MPL-2.0 AND CC-BY-SA-4.0`; dies ist keine Wahl zwischen zwei Lizenzen.
Details und Rechtstexte: [Lizenzzuordnung](../../LICENSING.md).

## Hinweis zu MagierRP 0.1.1

Die Runtime-Dateien `locales/{deDE,enUS,frFR}/{Texts,Racial}.lua` wurden
redaktionell erweitert. **Die hier abgelegten historischen Python-Vorlagen
sind nicht vollständig synchronisiert.** Ein erneutes Generieren aus diesen
Vorlagen würde die neuen Inhalte möglicherweise überschreiben. Für die
Laufzeit und Bearbeitung mit RPTextStudio sind die Lua-Sprachdateien maßgeblich.
