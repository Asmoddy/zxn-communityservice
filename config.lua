Config = {}

Config.SQL = "mysql" -- "mysql" or "ghmattimysql"

Config.ServiceExtensionOnEscape			= 8

Config.ServiceLocation				= {x =  -442.18, y = 6017.37, z = 31.69, h = 315.0}

Config.ReleaseLocation				= {x = 426.14, y = -978.44, z = 30.71, h = 90.0}

Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(-445.21, 6024.12, 31.49) },
	{ type = "cleaning", coords = vector3(-429.74, 6027.09, 31.49) },
	{ type = "cleaning", coords = vector3(-435.96, 6023.48, 31.49) },
	{ type = "cleaning", coords = vector3(-434.62, 6013.04, 31.49) },
	{ type = "cleaning", coords = vector3(-429.98, 6008.11, 31.49) },
	{ type = "cleaning", coords = vector3(-424.08, 6001.75, 31.49) },
	{ type = "cleaning", coords = vector3(-438.47, 6030.11, 31.34) },
	{ type = "cleaning", coords = vector3(-445.86, 6034.24, 31.34) },
	{ type = "cleaning", coords = vector3(-445.31, 6040.75, 31.34) },
	{ type = "cleaning", coords = vector3(-453.23, 6033.84, 31.34) },
	{ type = "gardening", coords = vector3(-428.85, 6020.84, 31.65) },
	{ type = "gardening", coords = vector3(-431.57, 6016.27, 31.62) },
	{ type = "gardening", coords = vector3(-426.80, 6016.04, 31.66) },
	{ type = "gardening", coords = vector3(-427.70, 6011.71, 31.62) },
	{ type = "gardening", coords = vector3(-424.48, 6009.52, 31.63) },
	{ type = "gardening", coords = vector3(-423.50, 6006.38, 31.57) }
}

Config.Uniforms = {
	['male'] = {
		outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 345, texture = 0},
			['arms']    = {item = 63, texture = 0},
			['pants']   = {item = 27, texture = 2},
			['shoes']   = {item = 5, texture = 0},
		}
	},
	['female'] = {
	 	outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 141, texture = 2},
			['arms']    = {item = 83, texture = 0},
			['pants']   = {item = 3, texture = 15},
			['shoes']   = {item = 16, texture = 0},
	 	}
	},
}
