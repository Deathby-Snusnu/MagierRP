"""Check translated spell and racial catalogs without requiring a WoW client."""
from collections import Counter
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
LOCALES = ("deDE", "enUS", "frFR")
ENTRY = re.compile(
    r'^    ([A-Z][A-Z0-9_]+) = \{ name = "[^"]+", ziel = \{ (.*?) \}, '
    r'gruppe = \{ (.*?) \} \},?$', re.M
)
RACE = re.compile(r'^    ([A-Z_]+) = \{$', re.M)
RACE_ENTRY = re.compile(r'^        ([A-Z][A-Z0-9_]+) = \{ (.*?) \},?$', re.M)
QUOTED = re.compile(r'"(?:\\.|[^"\\])*"')

class SpellTextCatalogTests(unittest.TestCase):
    def test_complete_spell_keys_and_race_coverage(self):
        reference = None
        for lang in LOCALES:
            with self.subTest(locale=lang):
                base = ROOT / "locales" / lang
                text = (base / "Texts.lua").read_text(encoding="utf-8")
                racial = (base / "Racial.lua").read_text(encoding="utf-8")
                entries = list(ENTRY.finditer(text))
                keys = {m.group(1) for m in entries}
                self.assertEqual(len(entries), 67)
                if reference is None:
                    reference = keys
                self.assertEqual(keys, reference)
                for spell in entries:
                    self.assertGreaterEqual(len(QUOTED.findall(spell.group(3))), 2)
                    self.assertNotIn("%s", spell.group(3),
                        "Group/self text must not mention a selected target")
                races = RACE.findall(racial)
                self.assertEqual(len(races), 10)
                race_spells = RACE_ENTRY.findall(racial)
                self.assertEqual(len(race_spells), len(keys) * len(races))
                self.assertEqual(Counter(k for k, _ in race_spells),
                                 Counter({k: len(races) for k in keys}))
                for key, items in race_spells:
                    self.assertGreaterEqual(len(QUOTED.findall(items)), 3,
                        f"{lang} {key} should have multiple racial variants")

    def test_generic_placeholder_phrases_removed(self):
        unwanted = (
            "Ihr werdet noch von dieser Formel hören",
            "you will hear of this formula",
            "entendrez parler de cette formule",
        )
        for lang in LOCALES:
            with self.subTest(locale=lang):
                src = (ROOT / "locales" / lang / "Texts.lua").read_text(encoding="utf-8").lower()
                for phrase in unwanted:
                    self.assertNotIn(phrase.lower(), src)

if __name__ == "__main__":
    unittest.main()
