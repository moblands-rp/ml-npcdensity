Config = Config or {}

-- ====================== MAIN SETTINGS ======================
Config.DefaultPedDensity     = 0.5     -- Pedestrians only
Config.DefaultVehicleDensity = 0.5     -- Cars, trucks, parked vehicles

Config.Command              = 'npcdensity'   -- Change to 'mldensity' if you want
Config.AdminOnly            = true
Config.AdminPermission      = 'admin'

-- ====================== MENU TEXTS ======================
Config.MenuHeader           = "🎮 NPC & Vehicle Density Menu"
Config.NotifyPrefix         = "Density"

-- ====================== CLEAR OPTIONS ======================
Config.AutoClearPedsOnChange     = true      -- Auto delete nearby peds when changing ped density
Config.AutoClearVehiclesOnChange = true      -- Auto delete nearby vehicles when changing vehicle density

Config.PedClearRadius            = 150.0     -- Radius for peds
Config.VehicleClearRadius        = 150.0     -- Radius for vehicles

Config.ManualClearPeds           = true      -- Show "Clear Peds Now" button
Config.ManualClearVehicles       = true      -- Show "Clear Vehicles Now" button