"""Skipped RP output is not a chat error."""
from pathlib import Path
import unittest
ROOT = Path(__file__).resolve().parents[1]
class SilentOutputTests(unittest.TestCase):
    def test_commands_do_not_warn_when_chance_or_cooldown_skips(self):
        source = (ROOT / "core/Commands.lua").read_text(encoding="utf-8")
        self.assertNotIn('Notify("Keine Ausgabe fuer "', source)
        self.assertNotIn('Notify("Kein Ambient-Text ausgegeben', source)
        self.assertIn('addon.TryText(key)', source)
        self.assertIn('addon.TryAmbient(nil, true)', source)
        self.assertIn('Notify("Unbekannter Befehl/Zauberschluessel:', source)
if __name__ == "__main__":
    unittest.main()
