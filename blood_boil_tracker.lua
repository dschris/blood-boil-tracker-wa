-- Blood Boil Tracker WeakAura
-- Trigger: COMBAT_LOG_EVENT_UNFILTERED, PLAYER_TARGET_CHANGED, NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED

function(allstates, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = CombatLogGetCurrentEventInfo()
        
        -- Blood Plague application/removal tracking
        if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REMOVED") and spellName == "Blood Plague" then
            allstates[destGUID] = {
                changed = true,
                show = true,
                progressType = "timed",
                duration = 24,
                expirationTime = GetTime() + (subevent == "SPELL_AURA_APPLIED" and 24 or 0),
                hasPlague = subevent == "SPELL_AURA_APPLIED",
                unit = destGUID,
                name = destName
            }
            return true
        end
    end
    
    -- Update states when nameplates change
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        local guid = UnitGUID(unit)
        if guid then
            local hasPlague = false
            for i=1, 40 do
                local name = UnitDebuff(unit, i)
                if name == "Blood Plague" then
                    hasPlague = true
                    break
                end
            end
            
            allstates[guid] = {
                changed = true,
                show = true,
                progressType = "timed",
                duration = 24,
                expirationTime = GetTime() + (hasPlague and 24 or 0),
                hasPlague = hasPlague,
                unit = guid,
                name = UnitName(unit)
            }
            return true
        end
    end
    
    if event == "NAME_PLATE_UNIT_REMOVED" then
        local unit = ...
        local guid = UnitGUID(unit)
        if guid and allstates[guid] then
            allstates[guid].show = false
            allstates[guid].changed = true
            return true
        end
    end
    
    return false
end

-- Custom Variables
{
    missingCount = "number",
    totalEnemies = "number"
}

-- Trigger 2 (Every Frame)
function()
    local missing = 0
    local total = 0
    
    for unit in WA_IterateGroupMembers() do
        if UnitExists(unit .. "target") and UnitCanAttack("player", unit .. "target") then
            total = total + 1
            local hasPlague = false
            for i=1, 40 do
                local name = UnitDebuff(unit .. "target", i)
                if name == "Blood Plague" then
                    hasPlague = true
                    break
                end
            end
            if not hasPlague then
                missing = missing + 1
            end
        end
    end
    
    WeakAuras.GetRegion(aura_env.id).missingCount = missing
    WeakAuras.GetRegion(aura_env.id).totalEnemies = total
    
    return missing > 0
end

-- Display Text
function()
    local missing = WeakAuras.GetRegion(aura_env.id).missingCount or 0
    local total = WeakAuras.GetRegion(aura_env.id).totalEnemies or 0
    
    if missing > 0 then
        return string.format("|cffff0000%d|r/%d\nMissing Blood Plague!", missing, total)
    else
        return string.format("%d/%d\nAll Enemies Plagued", missing, total)
    end
end

-- Custom Animations
{
    -- Glow animation when enemies are missing the debuff
    animation = {
        type = "custom",
        duration = 0.5,
        use_alpha = true,
        alpha = 0.3,
        use_scale = true,
        scalex = 1.2,
        scaley = 1.2,
        loop = true
    }
}

-- Load Conditions
{
    class = "DEATHKNIGHT",
    spec = 1, -- Blood spec
    combat = true
}