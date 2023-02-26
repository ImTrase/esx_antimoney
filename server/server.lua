local ESX <const> = exports.es_extended:getSharedObject()

local function whitelisted(group)
    for i = 1, #cfg?.whitelisted_groups do
        local sel = cfg?.whitelisted_groups[i]

        if (group == sel) then
            return true
        end
    end

    return false
end

local flag_target = function(target, args)
    local todo = cfg?.flag:lower()

    discordlog(('```Account: %s | Amount: %s | Player: %s (ID: %s)```'):format(args?.label, args?.money, GetPlayerName(target), target))

    if (todo ~= 'kick' and todo ~= 'log' and todo ~= 'wipe') then
        print(('^1[ERROR]^0: Configuration isn\'t set up properly. The "cfg.flag" value isn\'t correct. Accepted values: kick, wipe, log. (Current Value: %s)'):format(todo))
    end

    if (todo == 'kick') then
        DropPlayer(target, 'Modded money detected.')
    end
end

local check_players = function()
    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        if (not whitelisted(xPlayer?.getGroup())) then
            local acc = xPlayer.getAccounts()

            for k, v in pairs(acc) do
                if (cfg?.max[v?.name]) then
                    if (v?.money >= cfg?.max[v?.name]) then
                        local msg = ('^3[WARNING]^0: ^1%s^0 had ^1$%s^0 (^1Account: %s^0)'):format(GetPlayerName(xPlayer?.source), v?.money, v?.label)
                        if (cfg?.flag:lower() ~= 'log') then xPlayer.setAccountMoney(v?.name, 0) end
                        Wait(1000)
                        flag_target(xPlayer?.source, v)
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while (true) do
        check_players()
        Wait(cfg.checkTime * 1000)
    end
end)

function discordlog(desc)
    if (not desc or type(desc) ~= 'string') then return end
    if (cfg?.webhook == '') then return end

    local embed = { 
        color = 1,
        title = 'Modded Money Detected',
        footer = { text = os.date("%B %d, %Y at %I:%M %p") },
        description = desc
    }

    PerformHttpRequest(cfg?.webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Trase#0001', 
        avatar_url = 'https://imgur.com/3igi3eC.png', 
        embeds = { embed } }), { ['Content-Type'] = 'application/json' 
    });
end
