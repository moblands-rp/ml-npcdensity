local QBCore = exports['qb-core']:GetCoreObject()
local currentPedDensity     = Config.DefaultPedDensity
local currentVehicleDensity = Config.DefaultVehicleDensity

-- ====================== DENSITY LOOP (every frame) ======================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Peds
        SetPedDensityMultiplierThisFrame(currentPedDensity)
        SetScenarioPedDensityMultiplierThisFrame(currentPedDensity, currentPedDensity)

        -- Vehicles (traffic + parked)
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
        if DoesEntityExist(veh) then
            -- Don't delete the car the player is currently sitting in
            if not IsPedInVehicle(playerPed, veh, false) then
                if #(playerCoords - GetEntityCoords(veh)) < Config.VehicleClearRadius then
                    if NetworkHasControlOfEntity(veh) or NetworkRequestControlOfEntity(veh) then
                        DeleteEntity(veh)
                    end
                end
            end
        end
    end
end

-- ====================== OPEN MENU ======================
RegisterNetEvent('ml-npcdensity:client:OpenMenu', function()
    local menu = {
        { header = Config.MenuHeader, isMenuHeader = true },

        -- === PED SECTION ===
        { header = "👤 Ped Density: " .. currentPedDensity, isMenuHeader = true },
        { header = "Peds: None (0.0)",      txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.0 } } },
        { header = "Peds: Very Low (0.2)",  txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.2 } } },
        { header = "Peds: Low (0.4)",       txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.4 } } },
        { header = "Peds: Medium (0.6)",    txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.6 } } },
        { header = "Peds: Normal (0.8)",    txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 0.8 } } },
        { header = "Peds: Default (1.0)",   txt = "", params = { event = 'ml-npcdensity:client:SetPedDensity',     args = { density = 1.0 } } },
        { header = "🔢 Custom Ped Density", txt = "0.0 - 2.0", params = { event = 'ml-npcdensity:client:CustomPedDensity' } },

        -- === VEHICLE SECTION ===
        { header = "🚗 Vehicle Density: " .. currentVehicleDensity, isMenuHeader = true },
        { header = "Vehicles: None (0.0)",      txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.0 } } },
        { header = "Vehicles: Very Low (0.2)",  txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.2 } } },
        { header = "Vehicles: Low (0.4)",       txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.4 } } },
        { header = "Vehicles: Medium (0.6)",    txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.6 } } },
        { header = "Vehicles: Normal (0.8)",    txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 0.8 } } },
        { header = "Vehicles: Default (1.0)",   txt = "", params = { event = 'ml-npcdensity:client:SetVehicleDensity', args = { density = 1.0 } } },
        { header = "🔢 Custom Vehicle Density", txt = "0.0 - 2.0", params = { event = 'ml-npcdensity:client:CustomVehicleDensity' } },
    }

    -- Clear buttons
    if Config.ManualClearPeds then
        table.insert(menu, { header = "🧹 Clear Nearby Peds Now", txt = "", params = { event = 'ml-npcdensity:client:ClearPeds' } })
    end
    if Config.ManualClearVehicles then
        table.insert(menu, { header = "🧹 Clear Nearby Vehicles Now", txt = "", params = { event = 'ml-npcdensity:client:ClearVehicles' } })
    end

    TriggerEvent('qb-menu:client:openMenu', menu)
end)

-- ====================== SET DENSITY ======================
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

-- ====================== CUSTOM INPUT ======================
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

-- ====================== MANUAL CLEARS ======================
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
    QBCore.Functions.Notify('ml-npcdensity loaded (Peds: '..currentPedDensity..' | Vehicles: '..currentVehicleDensity..')', 'primary')
end)