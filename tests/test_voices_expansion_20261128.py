"""Contracts for additive multilingual spell and ambient voice packs."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LANGS = ("deDE", "enUS", "frFR")
SPELLS = ["ARCANE_BLAST","ICE_LANCE","POLYMORPH","PORTAL","FIREBALL"]
RACES = ["GNOME","HUMAN","BLOODELF"]
VERSION = "0.1.4"

class ExpandedVoices(unittest.TestCase):
    def test_toc_load_order_and_version(self):
        toc = (ROOT / "MagierRP.toc").read_text(encoding="utf-8")
        self.assertIn("## Version: " + VERSION, toc)
        for lang in LANGS:
            ambient = f"locales\\{lang}\\Ambient.lua"
            expansion = f"locales\\{lang}\\VoicesExpansion.lua"
            self.assertIn(ambient, toc)
            self.assertIn(expansion, toc)
            self.assertLess(toc.index(ambient), toc.index(expansion))

    def test_spell_ambient_keys_and_safe_lines(self):
        for lang in LANGS:
            with self.subTest(lang=lang):
                directory = ROOT / "locales" / lang
                data = (directory / "VoicesExpansion.lua").read_text(encoding="utf-8")
                spells = (directory / "Texts.lua").read_text(encoding="utf-8")
                ambient = (directory / "Ambient.lua").read_text(encoding="utf-8")
                self.assertIn("local function add(existing, texts)", data)
                self.assertNotIn("SendChatMessage", data)
                self.assertNotIn("COMBAT_LOG_EVENT_UNFILTERED", data)
                for key in SPELLS:
                    self.assertRegex(spells, rf"\b{key}\s*=\s*\{{")
                    self.assertIn(f"add(root.texts.{key}.gruppe,", data)
                for race in RACES:
                    self.assertRegex(ambient, rf"\b{race}\s*=\s*\{{")
                    self.assertIn(f"add(root.ambient.{race},", data)
                lines = re.findall(r'"((?:\\.|[^"\\])*)"', data.split("-- Additive", 1)[-1])
                self.assertGreaterEqual(len(lines), 16)
                self.assertTrue(all("%s" not in line for line in lines))
                self.assertTrue(all(len(line.encode("utf-8")) <= 255 for line in lines))
                self.assertEqual(len(lines), len(set(lines)))

if __name__ == "__main__":
    unittest.main()
