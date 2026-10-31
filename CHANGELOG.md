## Unreleased

- Alle 67 Magier-Zauberschlüssel in deDE, enUS und frFR sprachlich überarbeitet: wiederholte Füllsätze entfernt, neue zauberspezifische Ansprachen und Emotes ergänzt.
- Rassespezifische Zauberstimmen für zehn Völker in den Bereichen Feuer, Frost und Arkane Magie erweitert, ohne Ambient-/Klassentexte anzufassen.
- Umfang der übersetzten Zauberpools an die deutsche Sammlung angeglichen, mit Tests und dokumentierten kreativen Quellen.

# Changelog

## Aktueller Quellstand

- Geteilte Lizenzierung wie bei den anderen RP-Text-AddOns eingeführt:
  MPL-2.0 für Code, CC BY-SA 4.0 für kreative Texte und Übersetzungen.
  Lizenzdateien, Rechtehinweise und SPDX-Kennzeichnungen ergänzt.
- Manuelle Zauber- und Ambient-Aufrufe, dreisprachige Textpools und
  rassenspezifische Zaubertexte sind im vorliegenden Quellcode enthalten.
- Die Lua-Testdatei prüft den TOC-Ladepfad und zentrale AddOn-Verträge in einer
  isolierten Mock-Umgebung; ein echter WoW-Clienttest bleibt erforderlich.
- Entwicklungsquellen unter `development/text_sources` enthalten ergänzende
  Zauber-, Rassen-, Ambient- und Sprachvarianten; sie werden nicht vom AddOn
  selbst geladen.
- Die TOC deklariert Version `0.1.0`. Eine gesicherte Zuordnung dieser
  Funktionen zu weiteren Releases ist nicht dokumentiert.

## GitHub-Hauptzweig nach lokalem Stand (2026-10-29)

Die folgenden gemergten PRs sind in GitHub `main` enthalten, aber nicht im
lokalen Quellstand dieses Arbeitsbaums. Sie sind daher nicht als Funktionen
des hier vorliegenden Codes ausgewiesen:

- PR #2 ergänzt die Konsole und erweiterte Slash-Befehle.
- PR #3 ergänzt Ambient-Einstellungen und Timer-Unterstützung für
  RPControlCenter.
- PR #4 zeigt den Hinweis für Nicht-Magier nur einmal beim Login.

## 0.1.0
- Initiales Grundgerüst.
