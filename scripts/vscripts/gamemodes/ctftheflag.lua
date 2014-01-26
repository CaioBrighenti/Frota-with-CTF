RegisterGamemode('ctftheflag', {
    -- Gamemode only has a gameplay component
    sort = GAMEMODE_PLAY,
 
        options = {killsScore = false,useScores = true,respawnDelay = 10 },
               
                voteOptions = {
        -- Score limit vote
        scoreLimit = {
            -- Range based
            s = VOTE_SORT_RANGE,
 
            -- Minimal possible value
            min = 1000,
 
            -- Maximal possible value
            max = 3000,
 
            -- Default vaule (if no one votes)
            def = 1500,
 
            -- Slider tick interval
            tick = 500,
 
            -- Slider step interval
            step = 250
        }
    },
 
    onGameStart = function(frota)
    print('running onGameStart')
    local heroWithFlag = nil
    local flag = CreateItem('item_capture_flag', nil, nil)
    local flag_drop = CreateItemOnPosition(Vec3(0,0,0))
    if flag_drop then
        flag_drop:SetContainedItem( flag )
    end
    print('finished onGameStart')
    end,
 
    onThink = function(frota, dt)
    print('thinking')
            local goodGuysBase = Entities:FindByName(nil, 'base_goodguys')
            local goodGuysBaseVec = goodGuysBase:GetOrigin()
            local badGuysBase = Entities:FindByName(nil, 'base_badguys')
            local badGuysBaseVec = badGuysBase:GetOrigin()
            local goodUnitsOnPoint = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, goodGuysBaseVec, null, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
            local badUnitsOnPoint = FindUnitsInRadius(DOTA_TEAM_BADGUYS, badGuysBaseVec, null, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)      
            local tableSize = 0
           
            for k,v in pairs(goodUnitsOnPoint) do
                tableSize = tableSize + 1
            end
     
            for i=1,tableSize do
                local hero = goodUnitsOnPoint[i]
                if hero then
                    for i=0,5 do
                        local item = hero:GetItemInSlot(i)
                        if item then
                            if item:GetAbilityName() == 'item_capture_flag' then
                               UTIL_RemoveImmediate(item)
                               hero:RemoveModifierByName('modifier_creep_slow')
                               hero:RemoveModifierByName('modifier_silence')
                               frota.scoreRadiant = frota.scoreRadiant + 1
                               frota:UpdateScoreData()
                               local flag = CreateItem('item_capture_flag', nil, nil)
                               local flag_drop = CreateItemOnPosition(Vec3(0,0,0))
                               if flag_drop then
                                   flag_drop:SetContainedItem( flag )
                               end
                            end
                        end
                    end
                end
            end
 
            tableSize = 0
 
            for k,v in pairs(badUnitsOnPoint) do
                tableSize = tableSize + 1
                print(k,v)
            end
     
            for i=1,tableSize do
                local hero = badUnitsOnPoint[i]
                if hero then
                    for i=0,5 do
                        local item = hero:GetItemInSlot(i)
                        if item then
                            if item:GetAbilityName() == 'item_capture_flag' then
                               UTIL_RemoveImmediate(item)
                               hero:RemoveModifierByName('modifier_creep_slow')
                               hero:RemoveModifierByName('modifier_silence')
                               heroWithFlag = nil
                               frota.scoreDire = frota.scoreDire + 1
                               frota:UpdateScoreData()
                               local flag = CreateItem('item_capture_flag', nil, nil)
                               local flag_drop = CreateItemOnPosition(Vec3(0,0,0))
                               if flag_drop then
                                   flag_drop:SetContainedItem( flag )
                               end
                            end
                        end
                    end
                end
            end
 
            if heroWithFlag then
                for i=0,5 do
                    local hero = heroWithFlag
                    local item = hero:GetItemInSlot(i)
                    if item then
                        if item:GetAbilityName() == 'item_capture_flag' then
                            hero:AddNewModifier(hero, nil, 'modifier_creep_slow' ,nil)
                            hero:AddNewModifier(hero, nil, 'modifier_silence' ,nil)
                            heroWithFlag = hero
                            break
                        else
                        hero:RemoveModifierByName('modifier_creep_slow')
                        hero:RemoveModifierByName('modifier_silence')
                        end
                    end
                end
            end
 
           
        print('finish thinking')
    end,
 
    dota_item_picked_up = function(frota, keys)
        local hero = Players:GetSelectedHeroEntity(keys.PlayerID)
        if hero then
            for i=0, 5 do
                local item = hero:GetItemInSlot(i)
                if item then
                    if item:GetAbilityName() == 'item_capture_flag' then
                        hero:AddNewModifier(hero, nil, 'modifier_creep_slow' ,nil)
                        hero:AddNewModifier(hero, nil, 'modifier_silence' ,nil)
                        heroWithFlag = hero
                        print('flag picked up')
                        break
                    end
                end
            end
        end
    end,
 
    })