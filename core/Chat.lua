local _, addon = ...
function addon.SendText(line)
    if type(line) ~= "string" or line == "" then return false end
    if line:sub(1,1) == "*" and line:sub(-1) == "*" then
        SendChatMessage(line:sub(2,-2), "EMOTE")
    else
        SendChatMessage(line, "SAY")
    end
    return true
end
