"""Regression checks for mage spell dialogue, all translations and racial spell pools."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOCALES = ("deDE", "enUS", "frFR")
RACES = ("GNOME", "HUMAN", "HIGH_ELF", "BLOODELF", "NIGHTELF",
         "UNDEAD", "TROLL", "ORC", "DRAENEI", "DWARF")
ENTRY = re.compile(
    r'^    ([A-Z][A-Z0-9_]+) = \{ name = "(?:\\.|[^"\\])*", '
    r'ziel = \{ (.*?) \}, gruppe = \{ (.*?) \} \},$', re.M
)
RACIAL = re.compile(r'^        ([A-Z][A-Z0-9_]+) = \{ (.*?) \},$', re.M)
TEXT = re.compile(r'"(?:\\.|[^"\\])*"')
STALE = (
    "Ihr werdet noch von dieser Formel hören",
    "Die arkane Theorie sieht das jedenfalls so vor",
    "die Magie nimmt Gestalt an",
    "you will remember this formula",
    "At least, that is what the arcane theory predicts",
    "Arcane forces shape ",
    "vous vous souviendrez de cette formule",
    "Du moins, c'est ce que prévoit la théorie des arcanes",
    "Les arcanes façonnent ",
)

def source(name):
    return (ROOT / "development" / "text_sources" / name).read_text(encoding="utf-8")

def revision_rows(name, fields):
    lines = [line for line in source(name).splitlines()
             if line and not line.startswith("#")]
    rows = [line.split("|") for line in lines]
    assert all(len(row) == fields for row in rows)
    return rows

class SpellRevisionTests(unittest.TestCase):
    def test_every_spell_key_translated_and_runtime_loaded(self):
        revised = {row[0]: row for row in revision_rows("spell_revisions.tsv", 10)}
        self.assertEqual(len(revised), 67)
        group_counts = {"deDE": 399, "enUS": 334, "frFR": 334}
        for lang, offset in (("deDE", 1), ("enUS", 4), ("frFR", 7)):
            with self.subTest(locale=lang):
                runtime = (ROOT / "locales" / lang / "Texts.lua").read_text(encoding="utf-8")
                actual = {key: (target, group) for key, target, group in ENTRY.findall(runtime)}
                self.assertEqual(set(actual), set(revised))
                self.assertFalse(any(phrase in runtime for phrase in STALE))
                target_count = sum(len(TEXT.findall(target)) for target, _ in actual.values())
                group_count = sum(len(TEXT.findall(group)) for _, group in actual.values())
                self.assertEqual(target_count, 95)
                self.assertEqual(group_count, group_counts[lang])
                for key, row in revised.items():
                    target, group = actual[key]
                    self.assertIn(row[offset + 1], group)
                    self.assertIn(row[offset + 2], group)
                    self.assertTrue(row[offset + 2].startswith("*"))
                    self.assertTrue(row[offset + 2].endswith("*"))
                    if row[offset] != "-" and TEXT.findall(target):
                        self.assertIn(row[offset], target)

    def test_every_race_and_spell_has_translated_voice(self):
        voices = {row[0] + "/" + row[1]: row
                  for row in revision_rows("racial_spell_revisions.tsv", 8)}
        self.assertEqual(len(voices), 30)
        for race in RACES:
            for school in ("FIRE", "FROST", "ARCANE"):
                self.assertIn(race + "/" + school, voices)
        for lang, offset in (("deDE", 2), ("enUS", 4), ("frFR", 6)):
            with self.subTest(locale=lang):
                runtime = (ROOT / "locales" / lang / "Racial.lua").read_text(encoding="utf-8")
                rows = RACIAL.findall(runtime)
                self.assertEqual(len(rows), 670)
                self.assertEqual(len(set(key for key, _ in rows)), 67)
                for voice in voices.values():
                    self.assertIn(voice[offset], runtime)
                    self.assertIn(voice[offset + 1], runtime)

    def test_translated_variants_are_in_runtime_pools(self):
        targets = revision_rows("translated_target_variants.tsv", 3)
        self.assertEqual(len(targets), 10)
        for lang, target_offset in (("enUS", 1), ("frFR", 2)):
            runtime = (ROOT / "locales" / lang / "Texts.lua").read_text(encoding="utf-8")
            entries = {key: target for key, target, _ in ENTRY.findall(runtime)}
            for key, english, french in targets:
                self.assertIn(english if lang == "enUS" else french, entries[key])

    def test_only_spell_text_files_were_targeted(self):
        self.assertEqual(len(revision_rows("spell_revisions.tsv", 10)), 67)
        self.assertEqual(len(revision_rows("racial_spell_revisions.tsv", 8)), 30)

if __name__ == "__main__":
    unittest.main()
