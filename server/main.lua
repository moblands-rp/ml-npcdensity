local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand(Config.Command, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    if Config.AdminOnly and not QBCore.Functions.HasPermission(source, Config.AdminPermission) then
        TriggerClientEvent('QBCore:Notify', source, 'No permission!', 'error')
        return
    end

    TriggerClientEvent('ml-npcdensity:client:OpenMenu', source)
end, false)