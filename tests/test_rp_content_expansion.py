"""Verify manually triggered creative RP actions in all locales."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOCALES = ("deDE", "enUS", "frFR")
CLASS_KEYS = ["ARCANE_RESEARCH","LEYLINE_SENSE","WAND_MAINTENANCE","PORTAL_ETIQUETTE","REAGENT_PREPARATION","SPELLBOOK_STUDY"]
EXPECTED = 73
VERSION = "0.1.2"


class CreativeRpExpansion(unittest.TestCase):
    def test_version(self):
        toc = (ROOT / "MagierRP.toc").read_text(encoding="utf-8")
        self.assertIn("## Version: " + VERSION, toc)

    def test_locale_parity_and_creative_content(self):
        for lang in LOCALES:
            with self.subTest(lang=lang):
                source = (ROOT / "locales" / lang / "Texts.lua").read_text(encoding="utf-8")
                keys = re.findall(r"\b([A-Z][A-Z0-9_]*)\s*=\s*\{", source)
                self.assertEqual(len(set(keys)), EXPECTED)
                for key in CLASS_KEYS:
                    with self.subTest(locale=lang, key=key):
                        self.assertEqual(keys.count(key), 1)
                        start = source.index("    " + key + " = {")
                        tail = source[start:source.find("\n", start)]
                        self.assertIn("gruppe = {", tail)
                        self.assertIn("*", tail)
                self.assertNotIn("Neuer RP-Text", source)


if __name__ == "__main__":
    unittest.main()
