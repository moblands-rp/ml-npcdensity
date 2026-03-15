local QBCore = exports['qb-core']:GetCoreObject()
local currentDensity = Config.DefaultDensity

-- Main loop - applies density every frame
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPedDensityMultiplierThisFrame(currentDensity)
        SetScenarioPedDensityMultiplierThisFrame(currentDensity, currentDensity)
    end
end)

-- Open menu
RegisterNetEvent('ml-npcdensity:client:OpenMenu', function()
    local menu = {
        { header = Config.MenuHeader, isMenuHeader = true },
        { header = "Current: " .. currentDensity, isMenuHeader = true },
        { header = "None (0.0)",       txt = "No NPCs", params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 0.0 } } },
        { header = "Very Low (0.2)",   txt = "",        params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 0.2 } } },
        { header = "Low (0.4)",        txt = "",        params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 0.4 } } },
        { header = "Medium (0.6)",     txt = "",        params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 0.6 } } },
        { header = "Normal (0.8)",     txt = "",        params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 0.8 } } },
        { header = "Default GTA (1.0)",txt = "",        params = { event = 'ml-npcdensity:client:SetDensity', args = { density = 1.0 } } },
        { header = "🔢 Custom Value",  txt = "0.0 - 2.0", params = { event = 'ml-npcdensity:client:CustomDensity' } },
    }

    TriggerEvent('qb-menu:client:openMenu', menu)
end)

RegisterNetEvent('ml-npcdensity:client:SetDensity', function(data)
    currentDensity = data.density
    QBCore.Functions.Notify(Config.NotifyPrefix .. ' set to: ' .. currentDensity, 'success')
end)

RegisterNetEvent('ml-npcdensity:client:CustomDensity', function()
    local input = exports['qb-input']:ShowInput({
        header = "Custom NPC Density",
        submitText = "Apply",
        inputs = {
            { type = 'number', isRequired = true, name = 'density', text = '0.0 - 2.0', default = tostring(currentDensity) }
        }
    })

    if input and input.density then
        local val = tonumber(input.density)
        if val and val >= 0.0 and val <= 2.0 then
            currentDensity = val
            QBCore.Functions.Notify(Config.NotifyPrefix .. ' set to: ' .. currentDensity, 'success')
        else
            QBCore.Functions.Notify('Invalid value (0.0 - 2.0)', 'error')
        end
    end
end)

-- Resource start
AddEventHandler('onClientResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    currentDensity = Config.DefaultDensity
    QBCore.Functions.Notify('ml-npcdensity loaded (default: ' .. currentDensity .. ')', 'primary')
end)