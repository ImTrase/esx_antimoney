-- If you use ESX legacy, you can load this through the manifest or use an export, I reccommend you do so, it's faster.
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function checkWhitelisted(target)
    if (not target) then return end

    local xPlayer = ESX.GetPlayerFromId(target)
    if (not xPlayer) then return end

    for i = 1, #cfg?.whitelisted_groups do
        local sel = cfg?.whitelisted_groups[i]

        if (xPlayer.getGroup() == sel) then
            return true
        end
    end

    return false
end

local function checkAllPlayers()
    for i = 1, #GetPlayers() do
        local player = GetPlayers()[i]
        if (not checkWhitelisted(player)) then
            local xPlayer = ESX.GetPlayerFromId(player)
            if (xPlayer) then
                local accounts = xPlayer.getAccounts()
                for i2 = 1, #accounts do
                    local sel = accounts[i2]
                    local account = {
                        money = tonumber(sel.money),
                        label = sel.label,
                        name = sel.name
                    } 

                    if (account.money >= cfg?.maxMoney) then
                        local reason = ('%s (Id - %s) had $%s (%s), there money has been reset.'):format(xPlayer.getName(), xPlayer.source, account.money, account.label)
                        print(('^1%s'):format(reason)
                        xPlayer.removeAccountMoney(account.name, account.money)
                        discordlog(reason)
                        DropPlayer(player, 'Modded Money Detected')
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while (true) do
        checkAllPlayers()
        Wait(cfg?.checkTime * 1000)
    end
end)

function discordlog(desc)
    if (not desc or type(desc) ~= 'string') then return end

    local embed = {
        ["author"] = {
            ["name"] = 'Trase#0001',
            ["url"] = 'https://trase.dev/',
            ["icon_url"] = 'https://i.imgur.com/i4v7thW.png'
        },
        ["color"] = '1',
        ["title"] = 'Modded Money Detected',
        ["footer"] = {
            ["text"] = os.date("%B %d, %Y at %I:%M %p")
        },
        ['description'] = desc
    }

    PerformHttpRequest(cfg?.webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Trase#0001', 
        avatar_url = 'https://i.imgur.com/i4v7thW.png', 
        embeds = { embed } }), { ['Content-Type'] = 'application/json' 
    });
end