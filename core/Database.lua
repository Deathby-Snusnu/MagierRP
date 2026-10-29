local _, addon = ...
function addon.InitializeDatabase()
    if type(MagierRP_CharacterDB) ~= "table" then MagierRP_CharacterDB = {} end
    addon.db = MagierRP_CharacterDB
    for key, value in pairs(addon.defaults) do if addon.db[key] == nil then addon.db[key] = value end end
    if type(addon.db.textChance) ~= "number" or addon.db.textChance < 0 or addon.db.textChance > 100 then addon.db.textChance = 100 end
    if type(addon.db.cooldown) ~= "number" or addon.db.cooldown < 0 then addon.db.cooldown = 0 end
    if type(addon.db.racialTextChance) ~= "number" then addon.db.racialTextChance = 40 end
    addon.db.racialTextChance = math.max(0, math.min(100, addon.db.racialTextChance))
    for _, key in ipairs({"ambientEnabled", "ambientInCombat"}) do
        if type(addon.db[key]) ~= "boolean" then addon.db[key] = addon.defaults[key] end
    end
    if type(addon.db.ambientChance) ~= "number" or addon.db.ambientChance < 0 or addon.db.ambientChance > 100 then addon.db.ambientChance = 30 end
    for _, key in ipairs({"ambientMinInterval", "ambientMaxInterval"}) do
        local v = addon.db[key]
        if type(v) ~= "number" or v ~= math.floor(v) or v < 30 or v > 7200 then addon.db[key] = addon.defaults[key] end
    end
    if addon.db.ambientMaxInterval < addon.db.ambientMinInterval then addon.db.ambientMaxInterval = addon.db.ambientMinInterval end
    local channels = {SAY=true,YELL=true,PARTY=true,RAID=true,INSTANCE_CHAT=true,AUTO=true}
    if not channels[addon.db.chatChannel] then addon.db.chatChannel = "SAY" end
end
function addon.NormalizeRace(race)
    race = (race or ""):upper()
    if race == "SCOURGE" then return "UNDEAD" end
    if race == "HIGHELF" then return "HIGH_ELF" end
    return race
end
