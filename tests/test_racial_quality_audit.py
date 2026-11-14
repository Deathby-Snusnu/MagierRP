"""Regression audit for loaded, one-line racial spell voice pools.

Run: python -m unittest discover -s tests -p "test_*.py"
The historical duplicate ceilings protect existing content from getting worse.
They are NOT quality targets: future editorial PRs should lower them.
"""
from collections import Counter
from pathlib import Path
import json
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
LOCALES = ("deDE", "enUS", "frFR")
RACE = re.compile(r"^    ([A-Z][A-Z0-9_]+) = \\{$", re.M)
ENTRY = re.compile(r"^        ([A-Z][A-Z0-9_]+) = \\{ (.*?) \\},?$", re.M)
QUOTED = re.compile(r'"(?:\\\\.|[^"\\\\])*"')
EXPECTED_ENTRIES = 670
SPELLS_PER_RACE = 67
DUPLICATE_CEILINGS = {"deDE": 589, "enUS": 603, "frFR": 603}  # Historical baseline


def inspect_racial_catalog(locale):
    source = (ROOT / "locales" / locale / "Racial.lua").read_text(encoding="utf-8")
    headers = list(RACE.finditer(source))
    keys_by_race = {}
    dialogue = []
    for i, header in enumerate(headers):
        end = headers[i + 1].start() if i + 1 < len(headers) else len(source)
        race = header.group(1)
        entries = ENTRY.findall(source[header.end():end])
        keys_by_race[race] = [key for key, _ in entries]
        for key, text_group in entries:
            strings = [json.loads(match.group()) for match in QUOTED.finditer(text_group)]
            dialogue.extend((race, key, value) for value in strings)
    duplicates = sum(count - 1 for count in Counter(value for _, _, value in dialogue).values() if count > 1)
    return keys_by_race, dialogue, duplicates


class RacialQualityAudit(unittest.TestCase):
    def test_race_and_spell_coverage(self):
        expected_races = None
        expected_spells = None
        for locale in LOCALES:
            with self.subTest(locale=locale):
                pools, _, _ = inspect_racial_catalog(locale)
                self.assertEqual(len(pools), 10)
                self.assertEqual(sum(len(keys) for keys in pools.values()), EXPECTED_ENTRIES)
                for race, keys in pools.items():
                    self.assertEqual(len(keys), SPELLS_PER_RACE, race)
                    self.assertEqual(len(set(keys)), SPELLS_PER_RACE, race)
                    if expected_spells is None:
                        expected_spells = set(keys)
                    self.assertEqual(set(keys), expected_spells, race)
                if expected_races is None:
                    expected_races = set(pools)
                self.assertEqual(set(pools), expected_races)

    def test_safe_text_contract(self):
        for locale in LOCALES:
            with self.subTest(locale=locale):
                _, lines, _ = inspect_racial_catalog(locale)
                self.assertGreater(len(lines), 0)
                for race, spell, text in lines:
                    with self.subTest(race=race, spell=spell):
                        self.assertTrue(text.strip())
                        self.assertNotIn("%s", text, "Racial texts must work without a target name")
                        self.assertNotIn("\\n", text)
                        self.assertNotIn("\\r", text)
                        self.assertNotIn("|", text, "Avoid WoW chat escape sequences")
                        self.assertLessEqual(len(text.encode("utf-8")), 255)
                        self.assertEqual(text.startswith("*"), text.endswith("*"))
                        if text.startswith("*"):
                            self.assertEqual(text.count("*"), 2)

    def test_duplicate_regression(self):
        for locale, ceiling in DUPLICATE_CEILINGS.items():
            with self.subTest(locale=locale):
                _, _, duplicates = inspect_racial_catalog(locale)
                self.assertLessEqual(
                    duplicates, ceiling,
                    f"{locale}: {duplicates} repeated dialogue occurrences; "
                    f"baseline ceiling {ceiling}. Lower the ceiling after editorial cleanup."
                )


if __name__ == "__main__":
    unittest.main()
