# beans-adminxp
Add on admin menu to add/remove XP in pickle_xp using Ox-Lib

-- Hope this helps some of yall. cheers.



-- Integrates with minor additions to pickle XP system

-- Pulls XP list directly from the config of pickle_xp

-- Requires Ox-Lib

-- Discord webhook for monitoring



-- Add the below directly to pickle_xp/server.lua

function GetXPCategories()
    return Config.Categories
end

exports('GetXPCategories', GetXPCategories)

lib.callback.register('pickle_xp:getCategories', function()
    return GetXPCategories()
end)



