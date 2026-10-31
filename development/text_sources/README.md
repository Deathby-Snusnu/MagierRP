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

## Lizenz

Die kreativen Textdaten und Übersetzungen stehen unter CC BY-SA 4.0.
Python-Auswahl- und Zusammenstellungslogik steht unter MPL-2.0.
Gemischte Dateien kennzeichnen beide Bestandteile mit
`MPL-2.0 AND CC-BY-SA-4.0`; dies ist keine Wahl zwischen zwei Lizenzen.
Details und Rechtstexte: [Lizenzzuordnung](../../LICENSING.md).
