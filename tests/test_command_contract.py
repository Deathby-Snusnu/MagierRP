"""Static smoke checks for mage chat commands; requires no WoW runtime."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]

class CommandContractTests(unittest.TestCase):
    def test_commands(self):
        s = (ROOT / "core" / "Commands.lua").read_text(encoding="utf-8")
        for cmd in ("help", "status", "list", "debug", "chance", "cooldown",
                    "racial", "language", "channel", "ambient"):
            self.assertIn('action == "' + cmd + '"', s)
        self.assertIn('SLASH_MAGIERRP1 = "/mrp"', s)
        self.assertIn('SLASH_MAGIERRP2 = "/magierrp"', s)

    def test_channel_and_emote(self):
        chat = (ROOT / "core" / "Chat.lua").read_text(encoding="utf-8")
        self.assertIn('SendChatMessage(line:sub(2,-2), "EMOTE")', chat)
        self.assertIn('SendChatMessage(line, channel)', chat)

    def test_control_center_fields(self):
        settings = (ROOT / "config" / "Settings.lua").read_text(encoding="utf-8")
        for key in ("textChance", "outputLanguage", "chatChannel", "racialTextChance"):
            self.assertIn(key, settings)

if __name__ == "__main__":
    unittest.main()
