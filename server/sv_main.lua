local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject')
AddEventHandler('QBCore:Server:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

local function releaseFromCommunityService(target)
	local src = target
	local ply = QBCore.Functions.GetPlayer(src)
	local citizenid = ply.PlayerData.citizenid
	
    if Config.SQL == "ghmattimysql" then
        exports['ghmattimysql']:execute('SELECT * FROM communityservice WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid
        }, function(result)
            if result[1] then
                exports['ghmattimysql']:execute('DELETE from communityservice WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid
                })
                TriggerClientEvent("QBCore:Notify", tonumber(target), Lang:t('notify.community_service_finished'), "success", 5000)
            end
        end)
    elseif Config.SQL == "mysql" then
        MySQL.query('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] then
                MySQL.update('DELETE from communityservice WHERE citizenid = ?', {citizenid})
                TriggerClientEvent("QBCore:Notify", tonumber(target), Lang:t('notify.community_service_finished'), "success", 5000)
            end
        end)
    end

	TriggerClientEvent('zxn-communityservice:client:finishCommunityService', target)
    TriggerClientEvent("fivem-appearance:client:reloadSkin", target)
end

RegisterServerEvent('zxn-communityservice:server:endCommunityServiceCommand')
AddEventHandler('zxn-communityservice:server:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

-- unjail after time served
RegisterServerEvent('zxn-communityservice:server:finishCommunityService')
AddEventHandler('zxn-communityservice:server:finishCommunityService', function()
	releaseFromCommunityService(source)
end)

RegisterServerEvent('zxn-communityservice:server:completeService')
AddEventHandler('zxn-communityservice:server:completeService', function()
	local src = source
	local ply = QBCore.Functions.GetPlayer(src)
	local citizenid = ply.PlayerData.citizenid

    if Config.SQL == "ghmattimysql" then
        exports['ghmattimysql']:execute('SELECT * FROM communityservice WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid
        }, function(result)
            if result[1] then
                exports['ghmattimysql']:execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid
                })
            else
                print ("[communityservice] :: Problem matching player citizenid in database to reduce actions.")
            end
        end)
    elseif Config.SQL == "mysql" then
        MySQL.query('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] then
                MySQL.update('UPDATE communityservice SET actions_remaining = ? WHERE citizenid = ?', {tonumber(result[1].actions_remaining) - 1, citizenid})
            else
                print ("[communityservice] :: Problem matching player citizenid in database to reduce actions.")
            end
        end)
    end
end)

RegisterServerEvent('zxn-communityservice:server:extendService')
AddEventHandler('zxn-communityservice:server:extendService', function()
	local src = source
	local ply = QBCore.Functions.GetPlayer(src)
	local citizenid = ply.PlayerData.citizenid

    if Config.SQL == "ghmattimysql" then
        exports['ghmattimysql']:execute('SELECT * FROM communityservice WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid
        }, function(result)
    
            if result[1] then
                exports['ghmattimysql']:execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid,
                    ['@extension_value'] = Config.ServiceExtensionOnEscape
                })
            else
                print ("[communityservice] :: Problem matching player citizenid in database to reduce actions.")
            end
        end)
    elseif Config.SQL == "mysql" then
        MySQL.query('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] then
                MySQL.update('UPDATE communityservice SET actions_remaining = ? WHERE citizenid = ?', {tonumber(result[1].actions_remaining) + Config.ServiceExtensionOnEscape, citizenid})
            else
                print ("[communityservice] :: Problem matching player citizenid in database to reduce actions.")
            end
        end)
    end
end)

RegisterServerEvent('zxn-communityservice:server:sendToCommunityService')
AddEventHandler('zxn-communityservice:server:sendToCommunityService', function(target, actions_count)

	local ply = QBCore.Functions.GetPlayer(target)
	local citizenid = ply.PlayerData.citizenid

    if Config.SQL == "ghmattimysql" then
        exports['ghmattimysql']:execute('SELECT * FROM communityservice WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid
        }, function(result)
            if result[1] then
                exports['ghmattimysql']:execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE citizenid = @citizenid', {
                    ['@citizenid'] = citizenid,
                    ['@actions_remaining'] = actions_count
                })
            else
                exports['ghmattimysql']:execute('INSERT INTO communityservice (citizenid, actions_remaining) VALUES (@citizenid, @actions_remaining)', {
                    ['@citizenid'] = citizenid,
                    ['@actions_remaining'] = actions_count
                })
            end
        end)
    elseif Config.SQL == "mysql" then
        MySQL.query('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] then
                MySQL.update('UPDATE communityservice SET actions_remaining = ? WHERE citizenid = ?', {actions_count, citizenid})
            else
                MySQL.insert('INSERT INTO communityservice (citizenid, actions_remaining) VALUES (:citizenid, :actions_remaining) ON DUPLICATE KEY UPDATE actions_remaining = :actions_remaining', {
                    citizenid = citizenid,
                    actions_remaining = actions_count
                })
            end
        end)
    end
    TriggerClientEvent('zxn-communityservice:client:inCommunityService', target, actions_count)
    TriggerClientEvent('QBCore:Notify', target, 'You have been sentenced to '..actions_count..' month(s) of community service')
end)

RegisterServerEvent('zxn-communityservice:server:checkIfSentenced')
AddEventHandler('zxn-communityservice:server:checkIfSentenced', function()
	local src = source
	local ply = QBCore.Functions.GetPlayer(src)
	local citizenid = ply.PlayerData.citizenid

    if Config.SQL == "ghmattimysql" then
        exports['ghmattimysql']:execute('SELECT * FROM communityservice WHERE citizenid = @citizenid', {
            ['@citizenid'] = identifier
        }, function(result)
            if result[1] ~= nil and result[1].actions_remaining > 0 then
                TriggerClientEvent('zxn-communityservice:client:inCommunityService', src, tonumber(result[1].actions_remaining))
            end
        end)
    elseif Config.SQL == "mysql" then
        MySQL.query('SELECT * FROM communityservice WHERE citizenid = ?', {citizenid}, function(result)
            if result[1] ~= nil and result[1].actions_remaining > 0 then
                TriggerClientEvent('zxn-communityservice:client:inCommunityService', src, tonumber(result[1].actions_remaining))
            end
        end)
    end
end)

QBCore.Commands.Add("endcomserv", "Cancel a player community service", {{name="id", help="Oyuncu ID"}}, true, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local target = tonumber(args[1])
	local tPlayer = QBCore.Functions.GetPlayer(target)
	if tPlayer then
		releaseFromCommunityService(target)
		TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.community_service_canceled', {playerId = target}))
	else
		TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.no_player'), "error")
	end
end)

QBCore.Commands.Add("pcomserv", "Put a player into community service (Police Only)", {{name="id", help="Player ID"}, {name="count", help="Community Service mount"}}, true, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local target = tonumber(args[1])
    local amount = tonumber(args[2])
	if xPlayer.PlayerData.job.name == "police" then
		local tPlayer = QBCore.Functions.GetPlayer(target)
		if tPlayer then
			TriggerEvent('zxn-communityservice:server:sendToCommunityService', target, amount)
			TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.send_to_community_service'))
		else
			TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.no_player'), "error")
		end
    else
        TriggerClientEvent("QBCore:Notify", src, 'You are not a police officer!', "error")
    end
end)

QBCore.Commands.Add("comserv", "Put a player into community service (Admin Only)", {{name="id", help="Player ID"}, {name="count", help="Community Service mount"}}, true, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    local src = source
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    if QBCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
        local tPlayer = QBCore.Functions.GetPlayer(target)
        if tPlayer then
            TriggerEvent('zxn-communityservice:server:sendToCommunityService', target, amount)
            TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.send_to_community_service'))
        else
            TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.no_player'), "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", src, 'You don\'t have permissions to do this!', "error")
    end
end)
