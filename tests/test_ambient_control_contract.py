"""Static checks of RPControlCenter's MagierRP ambient settings contract."""
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

class AmbientContractTests(unittest.TestCase):
    def test_settings_and_functions(self):
        settings = (ROOT / "config/Settings.lua").read_text(encoding="utf-8")
        ambient = (ROOT / "core/Ambient.lua").read_text(encoding="utf-8")
        runtime = (ROOT / "MagierRP.lua").read_text(encoding="utf-8")
        commands = (ROOT / "core/Commands.lua").read_text(encoding="utf-8")
        for key in ("ambientEnabled", "ambientInCombat", "ambientChance",
                    "ambientMinInterval", "ambientMaxInterval"):
            self.assertIn(key, settings)
        self.assertIn("function addon.ResetAmbientTimer()", ambient)
        self.assertIn("function addon.TryAmbient(_, force)", runtime)
        self.assertIn('elseif not addon.TryAmbient(nil, true) then', commands)
        self.assertIn("addon.ResetAmbientTimer()", runtime)
        self.assertIn("current ~= generation", ambient)

if __name__ == "__main__":
    unittest.main()
