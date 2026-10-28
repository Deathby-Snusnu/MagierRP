# Entwicklungsquellen der MagierRP-Texte

Diese vier Python-Dateien wurden aus dem bisherigen RP-Text-Studio-Generator
hierher übernommen, bevor der Generator entfernt wird:

- `magier_spell_catalog.py`: Zauberschlüssel und mehrsprachige Textpools
- `magier_ambient_catalog.py`: Volkstypische Ambient-Texte
- `magier_voice_banks.py`: Themenspezifische Zaubertexte
- `magier_racial_spell_voices.py`: Rassen- und schulabhängige Varianten

**Wichtig:** Dies sind Entwicklungsdaten, **keine vom WoW-Client direkt
geladenen Lua-Dateien**. Sie ändern das MagierRP-AddOn im Spiel noch nicht.
Die Übernahme in die tatsächlichen Lua-Textbibliotheken und die Runtime
muss separat erfolgen und getestet werden. Der Generator in RP Text Studio
wird nicht länger als Quelle für zukünftige AddOn-Entwicklung verwendet.

Das bisherige MagierRP-Repository und seine bestehenden Runtime-Dateien
bleiben unverändert.
