local QBCore = exports['qb-core']:GetCoreObject()
local currentDensity = Config.DefaultDensity

-- ====================== MAIN DENSITY LOOP ======================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPedDensityMultiplierThisFrame(currentDensity)
        SetScenarioPedDensityMultiplierThisFrame(currentDensity, currentDensity)
    end
end)

-- ====================== CLEAR NEARBY NPCS FUNCTION ======================
local function ClearNearbyPeds()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local peds = GetGamePool('CPed')

    for _, ped in ipairs(peds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) and DoesEntityExist(ped) then
            local pedCoords = GetEntityCoords(ped)
            if #(playerCoords - pedCoords) < Config.ClearRadius then
                if NetworkHasControlOfEntity(ped) or NetworkRequestControlOfEntity(ped) then
                    DeleteEntity(ped)
                end
            end
        end
    end
end

-- ====================== OPEN MENU ======================
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

    if Config.ManualClearOption then
        table.insert(menu, {
            header = "🧹 Clear Nearby NPCs Now",
            txt = "Instantly remove visible NPCs",
            params = { event = 'ml-npcdensity:client:ClearPeds' }
        })
    end

    TriggerEvent('qb-menu:client:openMenu', menu)
end)

-- ====================== SET DENSITY ======================
RegisterNetEvent('ml-npcdensity:client:SetDensity', function(data)
    currentDensity = data.density
    
    if Config.AutoClearOnChange then
        ClearNearbyPeds()
    end

    QBCore.Functions.Notify(Config.NotifyPrefix .. ' set to: ' .. currentDensity, 'success')
end)

-- ====================== CUSTOM INPUT ======================
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
            if Config.AutoClearOnChange then ClearNearbyPeds() end
            QBCore.Functions.Notify(Config.NotifyPrefix .. ' set to: ' .. currentDensity, 'success')
        else
            QBCore.Functions.Notify('Invalid value (0.0 - 2.0)', 'error')
        end
    end
end)

-- ====================== MANUAL CLEAR ======================
RegisterNetEvent('ml-npcdensity:client:ClearPeds', function()
    ClearNearbyPeds()
    QBCore.Functions.Notify('Nearby NPCs cleared!', 'success')
end)

-- ====================== RESOURCE START ======================
AddEventHandler('onClientResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    currentDensity = Config.DefaultDensity
    QBCore.Functions.Notify('ml-npcdensity loaded (default: ' .. currentDensity .. ')', 'primary')
end)