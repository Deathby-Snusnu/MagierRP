local _, addon = ...
function addon.SendText(line)
    if type(line) ~= "string" or line == "" then return false end
    if line:sub(1,1) == "*" and line:sub(-1) == "*" then
        SendChatMessage(line:sub(2,-2), "EMOTE")
    else
        local channel = addon.db and addon.db.chatChannel or "SAY"
        if channel == "AUTO" then
            if IsInGroup and LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                channel = "INSTANCE_CHAT"
            elseif (IsInRaid and IsInRaid()) or (GetNumRaidMembers and GetNumRaidMembers() > 0) then
                channel = "RAID"
            elseif (IsInGroup and IsInGroup()) or (GetNumPartyMembers and GetNumPartyMembers() > 0) then
                channel = "PARTY"
            else
                channel = "SAY"
            end
        end
        SendChatMessage(line, channel)
    end
    return true
end
