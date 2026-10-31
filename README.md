# Magier RP

MagierRP ist ein eigenständiges WoW-Rollenspiel-AddOn für die Klasse `MAGE`.
Es bietet manuell aufgerufene Zauber- und Ambient-Texte in `deDE`, `enUS`
und `frFR`. Die TOC deklariert Version `0.1.0`, Interface `16001` und die
charakterbezogene SavedVariable `MagierRP_CharacterDB`.

## Installation

Vorhandene AddOn- und `WTF`-Ordner sichern. Im WoW-Client unter
`Interface\AddOns\MagierRP` die `MagierRP.toc`, `MagierRP.lua` sowie die
Ordner `config`, `core` und `locales` aus dem Quellprojekt bereitstellen.
Die TOC und alle darin aufgeführten Dateien müssen erhalten bleiben.
Git-Verwaltung, Entwicklungsquellen und Tests gehören nicht in den Spielordner.
Danach WoW neu starten und das AddOn aktivieren.

Im Quellprojekt der Sammlung erzeugt der folgende Befehl ein Laufzeit-ZIP
mit Lizenzhinweisen:

```powershell
.\tools\Package-AddOns.ps1 -AddonName MagierRP
```

Das gemeinsame Installationsskript unterstützt ebenfalls
`-AddonName MagierRP` und eine Vorschau mit `-WhatIf`. RP Text Studio führt
MagierRP in seinem eigenen AddOn-Katalog; dessen Installation verwendet eine
separate Vorschau und Bestätigung.

## Befehle und Makros

| Befehl | Funktion |
| --- | --- |
| `/mrp` oder `/mrp help` | Kurzhilfe anzeigen |
| `/mrp list` | Die fest definierte Liste der Zauberschlüssel anzeigen |
| `/mrp <schlüssel>` | Einen RP-Zaubertext versuchen |
| `/mrp ambient` | Einen Ambient-Text manuell versuchen |

`/magierrp` ist ein Alias für `/mrp`. Slash-Eingaben werden auf
Großbuchstaben normalisiert. `list racial`, `list all` sowie eigene
Slash-Befehle für Chance, Cooldown, Sprache oder Kanal sind nicht
implementiert. Die Liste stammt aus `spellKeys` und wird nicht dynamisch
aus neu angelegten Textpools erweitert.

Ein Makro kann einen Zauber und den Textaufruf verbinden:

```text
#showtooltip Feuerball
/cast Feuerball
/mrp fireball
```

Zaubernamen an den Client anpassen. Der Textaufruf prüft keinen Zaubererfolg.
Als direkte API ist `/run MagierRP.TryText("FIREBALL")` möglich; der
Schlüssel muss zur Schreibweise der Textdaten passen. `TryText` liefert bei
abgeschlossenem lokalem Chat-Aufruf `true`, bei abgelehnter Ausgabe `false`.
Vor dem Login wird der Aufruf abgelehnt. Nur Magier können Texte senden.

## Einstellungen und Textauswahl

Die Standardwerte in `config\Settings.lua` werden pro Charakter in
`MagierRP_CharacterDB` ergänzt:

| Feld | Standard | Bedeutung |
| --- | --- | --- |
| `textChance` | `100` | Wahrscheinlichkeit für einen Textversuch, 0 bis 100 |
| `cooldown` | `0` | Wartezeit zwischen erfolgreichen lokalen Chat-Aufrufen in Sekunden |
| `outputLanguage` | `deDE` | Textsprache `deDE`, `enUS` oder `frFR`; sonst wird Deutsch verwendet |
| `racialTextChance` | `40` | Wahrscheinlichkeit für einen vorhandenen rassenspezifischen Zaubertext, 0 bis 100 |

Das optionale RP Control Center kann Textchance, Textsprache und die
Wahrscheinlichkeit für volkstypische Zaubertexte ändern. MagierRP bietet
keine eigene Kanalauswahl: normale Texte gehen an `SAY`, beidseitig mit
`*` markierte Texte an `EMOTE`. Die Textsprache ist nicht die WoW-Volkssprache.

Ein passender Rassenpool kann den allgemeinen Zauberpool ersetzen.
`%s` wird durch den aufgelösten Namen ersetzt; bei bestimmten unterstützenden
Zaubern wird ein freundliches Ziel oder der eigene Charakter verwendet.
Ein `%%` im Text wird zu einem Prozentzeichen. Die genauen Zielregeln stehen
in `core\Text.lua`.

`/mrp ambient` wählt einen rassenbezogenen oder neutralen Ambient-Pool und
versucht die Ausgabe sofort. Es gibt keinen Ambient-Timer und keine
Intervall- oder Kampf-Einstellungen. Textchance und Cooldown gelten auch
für diesen Aufruf.

## Kompatibilität und Tests

Interface `16001` belegt für sich keine Client-Kompatibilität. Der Versand
verwendet die globale Funktion `SendChatMessage`; das aktuelle Chatmodul
prüft Texte nicht auf die 255-Byte-Grenze, Zeilenumbrüche oder
Chatformatierungszeichen. Eigene Texte deshalb vor der Nutzung prüfen.
Ein lokaler Chat-Aufruf bestätigt keine serverseitige Zustellung.

`tests\test_addon.lua` lädt die TOC in eine isolierte Mock-Umgebung und prüft
Ladeliste, Login, gespeicherte Einstellungen, Sprach- und Zielauflösung,
Rassenpools, Klassenbeschränkung, Chance, Cooldown, Chatkanäle und Slash-Befehle.
Der Test läuft mit Lua 5.1 oder 5.4; `tools\Test-AddOns.ps1` nimmt ihn auf,
wenn das separate MagierRP-Quellverzeichnis vorhanden ist. Das AddOn bleibt
außerhalb der Sammlungskonsistenzprüfung. Ein Test im gewünschten WoW-Client
bleibt zusätzlich erforderlich.

## Lizenz

MagierRP verwendet dieselbe geteilte Lizenzierung wie die anderen
RP-Text-AddOns: **MPL-2.0** für Programmcode, **CC BY-SA 4.0** für kreative
RP-Texte und Übersetzungen. Die SPDX-Kennzeichnungen und Bestandteilhinweise
in den Dateien legen die Zuordnung fest.

Siehe [LICENSE](LICENSE), [LICENSE-CODE](LICENSE-CODE),
[LICENSE-TEXTS](LICENSE-TEXTS), [Lizenzzuordnung](LICENSING.md) und
[Rechte-/Markenhinweise](NOTICE). Bei einer Weitergabe die entsprechenden
Lizenz- und Namensnennungspflichten beachten.
