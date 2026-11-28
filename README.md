## 0.1.4: Mehrsprachige Zauber- und Ambient-Stimmen (Entwurf)

In der nächsten Entwicklungsstufe der RP-AddOn-Familie ergänzt `locales/<Sprache>/VoicesExpansion.lua` die bestehenden Textpools **additiv** in `deDE`, `enUS` und `frFR`. Die neue Datei wird erst nach `Texts.lua` und `Ambient.lua` geladen, damit die Tabellen bereits existieren. Eigene Textänderungen bleiben erhalten.

- Fünf Kernfähigkeiten: `ARCANE_BLAST`, `ICE_LANCE`, `POLYMORPH`, `PORTAL`, `FIREBALL`. Je Fähigkeit kommen eine gesprochene Variante und eine beschreibende `*...*`-Geste pro Sprache hinzu.
- Drei charakteristische Volk-Ambient-Pools: Gnome, Menschen, Blutelfen. Je Volk eine neue gesprochene Variante und ein `*...*`-Emote pro Sprache.
- Insgesamt 16 neue Originalzeilen pro Sprache beziehungsweise 48 über die drei Sprachfassungen.
- Keine neuen Event-Listener, keine automatischen Buff-Danksagungen, keine geschützten WoW-UI-Funktionen. Die bestehende Entscheidung über `/say` und `/me` bleibt beim jeweiligen Klassen-AddOn.
- Test: `tests/test_voices_expansion_20261128.py` prüft Schlüssel, Laden, Rassen, Sprachparität und Textlängen. Vor Ingame-Veröffentlichung CI und praktische Tests ausführen.

**Versionspflege:** Die TOC ist für diese Entwicklung auf `0.1.4` gestellt. Dies ist noch kein Release; RPTextStudio und RPAddOns müssen beim späteren Merge/Update die neuen Dateien und diese Version berücksichtigen.

## Version 0.1.3: kreative MusicRP-Texte und RPTextStudio-Updates

Acht neue, selbst verfasste, musikalisch inspirierte Sprech-/Emote-Paare in **deDE**, **enUS** und **frFR**. Songtitel und Künstler dienen ausschließlich als interne Inspirationsmetadaten; die Chat-Ausgabe verwendet keine übernommenen Lyrics. Die normalen Text-, Rassen- und Ambient-Pools bleiben erhalten, MusicRP ist **standardmäßig deaktiviert**:

```text
/mrp music on
/mrp music chance 15
/mrp music status
/mrp music off
```

Der normale Textchance-/Cooldown-Filter bleibt wirksam. Die Version ist in `MagierRP.toc` von **0.1.2** auf **0.1.3** erhöht, die neue `music/MusicRP.lua` steht in der TOC-Ladeliste. **RPTextStudio:** Im Entwicklungskanal wird eine neuere numerische TOC-Version auf `main` erst *nach dem Merge* erkannt. Für den stabilen Kanal ist zusätzlich ein **GitHub-Release mit Tag `v0.1.3`** erforderlich, dessen enthaltene TOC ebenfalls `0.1.3` ausweist. Ein Pull Request allein aktualisiert keinen Release; vor dem Merge/Release die Tests kontrollieren. Lokale Änderungen vor der Update-Installation sichern und die Installationsvorschau beachten.

# Magier RP

## Neue freie RP-Aktionen (0.1.2)

Diese sechs manuellen Textaktionen ergänzen das bestehende Zauberbuch,
stehen aber **nicht für trainierbare WoW-Fähigkeiten**:
- `ARCANE_RESEARCH`
- `LEYLINE_SENSE`
- `WAND_MAINTENANCE`
- `PORTAL_ETIQUETTE`
- `REAGENT_PREPARATION`
- `SPELLBOOK_STUDY`

Jeder Schlüssel hat eigenständige gesprochene Texte und /me-Handlungen
in Deutsch, Englisch und Französisch. Alte RP-Makros, persönliche
Texte und gespeicherte Einstellungen bleiben unverändert.


MagierRP ist ein eigenständiges WoW-Rollenspiel-AddOn für die Klasse `MAGE`.
Es bietet manuell aufgerufene Zauber- und Ambient-Texte in `deDE`, `enUS`
und `frFR`. Die TOC deklariert Version `0.1.3`, Interface `16001` und die
charakterbezogene SavedVariable `MagierRP_CharacterDB`.

## Installation

Vorhandene AddOn- und `WTF`-Ordner sichern. Im WoW-Client unter
`Interface\AddOns\MagierRP` die `MagierRP.toc`, `MagierRP.lua` sowie die
Ordner `config`, `core`, `locales` und `music` aus dem Quellprojekt bereitstellen.
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
