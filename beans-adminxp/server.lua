local DiscordWebhook = "https://discord.com/api/webhooks/..." -- replace this with your actual webhook URL



lib.callback.register('admin:CheckPermission', function(source)
    return IsPlayerAceAllowed(source, "command")
end)

local function SendToDiscord(title, description, color)
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color or 5814783, -- default: blue
            ["footer"] = {
                ["text"] = "XP Admin Log"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(DiscordWebhook, function() end, "POST", json.encode({
        username = "XP Admin Log",
        embeds = embed,
        avatar_url = "" -- optional
    }), {
        ["Content-Type"] = "application/json"
    })
end

RegisterNetEvent("admin:ManageXP", function(targetId, skill, amount, action)
    local src = source
    if not IsPlayerAceAllowed(src, "command") then
        print(("[XP Admin] Player %s tried to use XP menu without permission."):format(src))
        DropPlayer(src, "Unauthorized XP command usage.")
        return
    end

    local categories = exports['pickle_xp']:GetXPCategories()
    if not categories[skill] then
        print(("[XP Admin] Invalid skill '%s' submitted by %s."):format(skill, src))
        return
    end

    if action == "add" then
        exports['pickle_xp']:AddPlayerXP(targetId, skill, amount)

        local targetName = GetPlayerName(targetId) or "Unknown"
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = ("Gave %d XP in %s to [%s] %s"):format(amount, skill, targetId, targetName)
        })

-- pickles already notifies the player that it added it but in case you have changed that.
--[[         TriggerClientEvent('ox_lib:notify', targetId, {
            type = 'success',
            description = ("You received %d XP in %s."):format(amount, skill)
        }) ]]

        SendToDiscord("XP Added",
            ("Admin [%s] gave %d XP in **%s** to [%s]"):format(src, amount, skill, targetId),
            3066993)

    elseif action == "remove" then
        exports['pickle_xp']:RemovePlayerXP(targetId, skill, amount)

        local targetName = GetPlayerName(targetId) or "Unknown"
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = ("Removed %d XP in %s to [%s] %s"):format(amount, skill, targetId, targetName)
        })

-- pickles already notifies the player that it added it but in case you have changed that.

--[[         TriggerClientEvent('ox_lib:notify', targetId, {
            type = 'error',
            description = ("You lost %d XP in %s."):format(amount, skill)
        }) ]]

        SendToDiscord("XP Removed",
            ("Admin [%s] removed %d XP in **%s** from [%s]"):format(src, amount, skill, targetId),
            15158332)
    end
end)



