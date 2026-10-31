-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
function addon.SendText(line)
    if type(line) ~= "string" or line == "" then return false end
    if line:sub(1,1) == "*" and line:sub(-1) == "*" then
        SendChatMessage(line:sub(2,-2), "EMOTE")
    else
        local channel = addon.db and addon.db.chatChannel or "SAY"
        local isAutoChannel = channel == "AUTO"
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
        local languageID
        if not isAutoChannel and (channel == "SAY" or channel == "YELL") then
            local rpChat = _G.RPChatMod
            if type(rpChat) == "table" and type(rpChat.GetChatLanguageID) == "function" then
                languageID = rpChat.GetChatLanguageID(channel)
            end
        end
        SendChatMessage(line, channel, languageID)
    end
    return true
end
