Config = Config or {}

-- ====================== MAIN SETTINGS ======================
Config.DefaultDensity   = 0.5     -- 0.0 = no NPCs, 1.0 = GTA default, 2.0 = double
Config.Command          = 'npcdensity'   -- Change command name here
Config.AdminOnly        = true
Config.AdminPermission  = 'admin'

-- ====================== MENU TEXTS ======================
Config.MenuHeader       = "🎮 NPC Density Menu"
Config.NotifyPrefix     = "NPC Density"

-- ====================== CLEAR OPTIONS (NEW) ======================
Config.AutoClearOnChange = true      -- Automatically delete nearby NPCs when you change density (recommended)
Config.ClearRadius       = 150.0     -- How far to clear NPCs (150 = good balance, lower = less lag)
Config.ManualClearOption = true      -- Show "Clear Nearby NPCs Now" button in menu