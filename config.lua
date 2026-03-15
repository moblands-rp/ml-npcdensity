Config = Config or {}

-- ====================== MAIN SETTINGS ======================
Config.DefaultPedDensity     = 0.5
Config.DefaultVehicleDensity = 0.5

Config.Command               = 'npcdensity'
Config.AdminOnly             = true
Config.AdminPermission       = 'admin'

-- ====================== MENU TEXTS ======================
Config.MenuHeader            = "🎮 NPC & Vehicle Density Menu"
Config.NotifyPrefix          = "Density"

-- ====================== UI SWITCH (THIS IS WHAT YOU WANT) ======================
Config.UseOxLib              = true      -- ← CHANGE THIS TO false if you want the old qb-menu look
Config.OxMenuPosition        = 'top-right'  -- options: 'top-left', 'top-right', 'bottom-left', 'bottom-right'

-- ====================== CLEAR OPTIONS ======================
Config.AutoClearPedsOnChange     = true
Config.AutoClearVehiclesOnChange = true
Config.PedClearRadius            = 150.0
Config.VehicleClearRadius        = 150.0
Config.ManualClearPeds           = true
Config.ManualClearVehicles       = true