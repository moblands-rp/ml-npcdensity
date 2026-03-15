local QBCore = exports['qb-core']:GetCoreObject()
local currentPedDensity     = Config.DefaultPedDensity
local currentVehicleDensity = Config.DefaultVehicleDensity

-- ====================== CHECK FOR ox_lib ======================
local useOxLib = Config.UseOxLib and lib ~= nil

-- ====================== DENSITY LOOP ======================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPedDensityMultiplierThisFrame(currentPedDensity)
        SetScenarioPedDensityMultiplierThisFrame(currentPedDensity, currentPedDensity)
        SetVehicleDensityMultiplierThisFrame(currentVehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(currentVehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(currentVehicleDensity)
    end
end)

-- ====================== CLEAR FUNCTIONS ======================
local function ClearNearbyPeds()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) and DoesEntityExist(ped) then
            if #(playerCoords - GetEntityCoords(ped)) < Config.PedClearRadius then
                if NetworkHasControlOfEntity(ped) or NetworkRequestControlOfEntity(ped) then
                    DeleteEntity(ped)
                end
            end
        end
    end
end

local function ClearNearbyVehicles()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    for _, veh in ipairs(vehicles) do
        if DoesEntityExist(veh) and not IsPedInVehicle(playerPed, veh, false) then
            if #(playerCoords - GetEntityCoords(veh)) < Config.VehicleClearRadius then
                if NetworkHasControlOfEntity(veh) or NetworkRequestControlOfEntity(veh) then
                    DeleteEntity(veh)
                end
            end
        end
    end
end

-- ====================== OPEN MENU ======================
RegisterNetEvent('ml-npcdensity:client:OpenMenu', function()
    if useOxLib then
        -- ====================== MODERN ox_lib MENU ======================
        local options = {
            { title = '👤 Ped Density: ' .. currentPedDensity, disabled = true },

            { title = 'None (0.0)',       description = 'No pedestrians', icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 0.0 }) end },
            { title = 'Very Low (0.2)',   description = '',               icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 0.2 }) end },
            { title = 'Low (0.4)',        description = '',               icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 0.4 }) end },
            { title = 'Medium (0.6)',     description = '',               icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 0.6 }) end },
            { title = 'Normal (0.8)',     description = '',               icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 0.8 }) end },
            { title = 'Default (1.0)',    description = '',               icon = 'user', onSelect = function() TriggerEvent('ml-npcdensity:client:SetPedDensity', { density = 1.0 }) end },
            { title = '🔢 Custom Ped Density', description = '0.0 - 2.0', icon = 'pen',  onSelect = function() TriggerEvent('ml-npcdensity:client:CustomPedDensity') end },

            { title = '🚗 Vehicle Density: ' .. currentVehicleDensity, disabled = true },

            { title = 'None (0.0)',       description = 'No traffic',     icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 0.0 }) end },
            { title = 'Very Low (0.2)',   description = '',               icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 0.2 }) end },
            { title = 'Low (0.4)',        description = '',               icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 0.4 }) end },
            { title = 'Medium (0.6)',     description = '',               icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 0.6 }) end },
            { title = 'Normal (0.8)',     description = '',               icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 0.8 }) end },
            { title = 'Default (1.0)',    description = '',               icon = 'car', onSelect = function() TriggerEvent('ml-npcdensity:client:SetVehicleDensity', { density = 1.0 }) end },
            { title = '🔢 Custom Vehicle Density', description = '0.0 - 2.0', icon = 'pen', onSelect = function() TriggerEvent('ml-npcdensity:client:CustomVehicleDensity') end },
        }

        if Config.ManualClearPeds then
            table.insert(options, { title = '🧹 Clear Nearby Peds Now', icon = 'broom', onSelect = function() TriggerEvent('ml-npcdensity:client:ClearPeds') end })
        end
        if Config.ManualClearVehicles then
            table.insert(options, { title = '🧹 Clear Nearby Vehicles Now', icon = 'broom', onSelect = function() TriggerEvent('ml-npcdensity:client:ClearVehicles') end })
        end

        lib.registerContext({
            id = 'ml_npcdensity_menu',
            title = Config.MenuHeader,
            position = Config.OxMenuPosition,
            options = options
        })
        lib.showContext('ml_npcdensity_menu')

    else
        -- ====================== CLASSIC qb-menu (fallback) ======================
        if Config.UseOxLib then
            QBCore.Functions.Notify('ox_lib not found! Using qb-menu instead. Install ox_lib or set UseOxLib = false', 'error')
        end

        local menu = {
            { header = Config.MenuHeader, isMenuHeader = true },

            { header = "👤 Ped Density: " .. currentPedDensity, isMenuHeader = true },
            { header = "Peds: None (0.0)",       txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.0 } } },
            { header = "Peds: Very Low (0.2)",   txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.2 } } },
            { header = "Peds: Low (0.4)",        txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.4 } } },
            { header = "Peds: Medium (0.6)",     txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.6 } } },
            { header = "Peds: Normal (0.8)",     txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.8 } } },
            { header = "Peds: Default (1.0)",    txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 1.0 } } },
            { header = "🔢 Custom Ped Density",  txt = "0.0 - 2.0", params = { event = 'ml-npcdensity:client:CustomPedDensity' } },

            { header = "🚗 Vehicle Density: " .. currentVehicleDensity, isMenuHeader = true },
            { header = "Vehicles: None (0.0)",       txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.0 } } },
            { header = "Vehicles: Very Low (0.2)",   txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.2 } } },
            { header = "Vehicles: Low (0.4)",        txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.4 } } },
            { header = "Vehicles: Medium (0.6)",     txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.6 } } },
            { header = "Vehicles: Normal (0.8)",     txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.8 } } },
            { header = "Vehicles: Default (1.0)",    txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 1.0 } } },
            { header = "🔢 Custom Vehicle Density",  txt = "0.0 - 2.0", params = { event = 'ml-npcdensity:client:CustomVehicleDensity' } },
        }

        if Config.ManualClearPeds then
            table.insert(menu, { header = "🧹 Clear Nearby Peds Now", txt = "", params = { event = 'ml-npcdensity:client:ClearPeds' } })
        end
        if Config.ManualClearVehicles then
            table.insert(menu, { header = "🧹 Clear Nearby Vehicles Now", txt = "", params = { event = 'ml-npcdensity:client:ClearVehicles' } })
        end

        TriggerEvent('qb-menu:client:openMenu', menu)
    end
end)

-- ====================== DENSITY & CLEAR EVENTS (unchanged) ======================
RegisterNetEvent('ml-npcdensity:client:SetPedDensity', function(data)
    currentPedDensity = data.density
    if Config.AutoClearPedsOnChange then ClearNearbyPeds() end
    QBCore.Functions.Notify(Config.NotifyPrefix .. ' (Peds) set to: ' .. currentPedDensity, 'success')
end)

RegisterNetEvent('ml-npcdensity:client:SetVehicleDensity', function(data)
    currentVehicleDensity = data.density
    if Config.AutoClearVehiclesOnChange then ClearNearbyVehicles() end
    QBCore.Functions.Notify(Config.NotifyPrefix .. ' (Vehicles) set to: ' .. currentVehicleDensity, 'success')
end)

RegisterNetEvent('ml-npcdensity:client:CustomPedDensity', function()
    local input = exports['qb-input']:ShowInput({
        header = "Custom Ped Density",
        submitText = "Apply",
        inputs = {{ type = 'number', isRequired = true, name = 'density', text = '0.0 - 2.0', default = tostring(currentPedDensity) }}
    })
    if input and input.density then
        local val = tonumber(input.density)
        if val and val >= 0.0 and val <= 2.0 then
            currentPedDensity = val
            if Config.AutoClearPedsOnChange then ClearNearbyPeds() end
            QBCore.Functions.Notify(Config.NotifyPrefix .. ' (Peds) set to: ' .. currentPedDensity, 'success')
        else
            QBCore.Functions.Notify('Invalid value (0.0 - 2.0)', 'error')
        end
    end
end)

RegisterNetEvent('ml-npcdensity:client:CustomVehicleDensity', function()
    local input = exports['qb-input']:ShowInput({
        header = "Custom Vehicle Density",
        submitText = "Apply",
        inputs = {{ type = 'number', isRequired = true, name = 'density', text = '0.0 - 2.0', default = tostring(currentVehicleDensity) }}
    })
    if input and input.density then
        local val = tonumber(input.density)
        if val and val >= 0.0 and val <= 2.0 then
            currentVehicleDensity = val
            if Config.AutoClearVehiclesOnChange then ClearNearbyVehicles() end
            QBCore.Functions.Notify(Config.NotifyPrefix .. ' (Vehicles) set to: ' .. currentVehicleDensity, 'success')
        else
            QBCore.Functions.Notify('Invalid value (0.0 - 2.0)', 'error')
        end
    end
end)

RegisterNetEvent('ml-npcdensity:client:ClearPeds', function()
    ClearNearbyPeds()
    QBCore.Functions.Notify('Nearby peds cleared!', 'success')
end)

RegisterNetEvent('ml-npcdensity:client:ClearVehicles', function()
    ClearNearbyVehicles()
    QBCore.Functions.Notify('Nearby vehicles cleared!', 'success')
end)

-- ====================== RESOURCE START ======================
AddEventHandler('onClientResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    currentPedDensity     = Config.DefaultPedDensity
    currentVehicleDensity = Config.DefaultVehicleDensity

    local uiType = useOxLib and 'ox_lib' or (Config.UseOxLib and 'qb-menu (ox_lib missing)' or 'qb-menu')
    QBCore.Functions.Notify('ml-npcdensity loaded (' .. uiType .. ' | Peds: '..currentPedDensity..' | Vehicles: '..currentVehicleDensity..')', 'primary')
end)