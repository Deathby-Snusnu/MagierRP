local _, addon = ...
SLASH_MAGIERRP1 = "/mrp"
SLASH_MAGIERRP2 = "/magierrp"
SlashCmdList["MAGIERRP"] = function(message)
    local key = (message or ""):match("^%s*(.-)%s*$"):upper()
    if key == "" or key == "HELP" then
        print("MagierRP: /mrp list | /mrp <SCHLUESSEL>")
        return
    end
    if key == "AMBIENT" then addon.TryAmbient(); return end
    if key == "LIST" then
        print("MagierRP Zauberschluessel:")
        for _, spell in ipairs(addon.spellKeys) do print("  " .. spell) end
        return
    end
    addon.TryText(key)
end
