"""Regression guard for MagierRP slash command registration syntax."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "core" / "Commands.lua"

class MagierCommandsTest(unittest.TestCase):
    def test_slash_handler_closes_both_else_and_function(self):
        code = COMMANDS.read_text(encoding="utf-8").rstrip()
        self.assertIn('SLASH_MAGIERRP1 = "/mrp"', code)
        self.assertIn('SLASH_MAGIERRP2 = "/magierrp"', code)
        self.assertIn('SlashCmdList["MAGIERRP"] = function(message)', code)
        self.assertTrue(code.endswith("    end\\nend".replace("\\n", "\n")))

if __name__ == "__main__":
    unittest.main()
