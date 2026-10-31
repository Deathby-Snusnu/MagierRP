"""Ensure optional RPChatMod language policy is respected for speech."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]

class LanguagePolicyContract(unittest.TestCase):
    def test_speech_uses_shared_resolver(self):
        chat = (ROOT / "core" / "Chat.lua").read_text(encoding="utf-8")
        self.assertIn("rpChat.GetChatLanguageID(channel)", chat)
        self.assertIn('channel == "SAY" or channel == "YELL"', chat)
        self.assertIn('type(rpChat.GetChatLanguageID) == "function"', chat)

    def test_optional_dependency(self):
        toc = (ROOT / "MagierRP.toc").read_text(encoding="utf-8")
        self.assertIn("## OptionalDeps: RPChatMod", toc)

if __name__ == "__main__":
    unittest.main()
