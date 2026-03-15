Config = Config or {}

-- ====================== MAIN SETTINGS ======================
Config.DefaultDensity   = 0.5     -- 0.0 = no NPCs, 1.0 = GTA default, 2.0 = double
Config.Command          = 'npcdensity'   -- Change command name here (e.g. 'mldensity')
Config.AdminOnly        = true    -- false = every player can use the menu
Config.AdminPermission  = 'admin' -- 'god', 'mod', etc. (must exist in qb-core)

-- ====================== MENU TEXTS ======================
Config.MenuHeader       = "🎮 NPC Density Menu"
Config.NotifyPrefix     = "NPC Density"