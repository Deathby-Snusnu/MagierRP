-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 Hannes Weichselbaum
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local _, addon = ...
function addon.CooldownReady() return GetTime() >= (addon.nextTextTime or 0) end
function addon.StartCooldown() addon.nextTextTime = GetTime() + addon.db.cooldown end
