local function getSkillList()
    local skills = {}
    local categories = lib.callback.await('pickle_xp:getCategories', false)
    for skill, data in pairs(categories) do
        table.insert(skills, {
            label = data.label or skill,
            value = skill
        })
    end

    return skills
end

local function getPlayerList()
    local players = {}

    for _, playerId in pairs(GetActivePlayers()) do
        local serverId = GetPlayerServerId(playerId)
        local name = GetPlayerName(playerId)
        table.insert(players, {
            label = ('[%s] %s'):format(serverId, name),
            value = serverId
        })
    end

    return players
end

RegisterCommand("managexp", function()
    lib.callback('admin:CheckPermission', false, function(isAllowed)
        if not isAllowed then
            lib.notify({ type = 'error', description = 'You are not authorized to use this command.' })
            return
        end

        local playerInput = lib.inputDialog('Select Player and Skill', {
            {
                type = 'select',
                label = 'Player',
                options = getPlayerList()
            },
            {
                type = 'select',
                label = 'Skill',
                options = getSkillList()
            },
            {
                type = 'number',
                label = 'XP Amount',
                required = true
            },
            {
                type = 'select',
                label = 'Action',
                options = {
                    { label = 'Add XP', value = 'add' },
                    { label = 'Remove XP', value = 'remove' }
                }
            }
        })

        if not playerInput then return end

        local targetId = playerInput[1]
        local skill = playerInput[2]
        local amount = tonumber(playerInput[3])
        local action = playerInput[4]

        TriggerServerEvent("admin:ManageXP", targetId, skill, amount, action)
    end)
end, false)

