-- Craftitem / Misc

minetest.register_craft({
	output = 'inventorybags:item_filter',
	recipe = {
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'group:stick', 'inventorybags:fabric', 'group:stick'},
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'inventorybags:item_puller',
	recipe = {
		{'default:steel_ingot', 'default:gold_ingot', 'default:steel_ingot'},
		{'default:obsidian_glass', 'inventorybags:item_filter', 'default:obsidian_glass'},
		{'default:obsidian_glass', '', 'default:obsidian_glass'},
	}
})

minetest.register_craft({
	output = 'inventorybags:inventory_connecter',
	recipe = {
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:fabric'},
		{'inventorybags:item_puller', 'default:mese_crystal', 'inventorybags:item_puller'},
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:fabric'},
	}
})

-- Devices

minetest.register_craft({
	output = 'inventorybags:spinning_wheel',
	recipe = {
		{'group:stick', 'group:stick', 'group:wool'},
		{'group:stick', 'group:stick', ''},
		{'group:wood', 'group:wood', 'group:slab'},
	}
})

minetest.register_craft({
	output = 'inventorybags:loom',
	recipe = {
		{'group:stick', 'inventorybags:yarn', 'group:stick'},
		{'group:stick', 'inventorybags:yarn', 'group:stick'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft({
	output = 'inventorybags:bud',
	recipe = {
		{'group:stick', 'default:meselamp', ''},
		{'group:stick', 'inventorybags:upgrade_base', ''},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

-- Upgrades

minetest.register_craft({
	output = 'inventorybags:upgrade_base',
	recipe = {
		{'inventorybags:yarn', 'group:stick', 'inventorybags:yarn'},
		{'group:stick', 'default:mese_crystal_fragment', 'group:stick'},
		{'inventorybags:yarn', 'group:stick', 'inventorybags:yarn'},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:rename_upgrade",
	recipe = {"inventorybags:upgrade_base", "default:paper"},
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:coloring_upgrade",
	recipe = {"inventorybags:upgrade_base", "dye:cyan", "dye:magenta", "dye:yellow", "dye:black", "dye:white"},
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:coloring_upgrade",
	recipe = {"inventorybags:upgrade_base", "dye:red", "dye:green", "dye:blue", "dye:black", "dye:white"},
})

if minetest.get_modpath("node_texture_modifier") then
	minetest.register_craft({
		type = "shapeless",
		output = "inventorybags:coloring_upgrade",
		recipe = {"inventorybags:upgrade_base", "node_texture_modifier:dye_mixture"},
	})
end

minetest.register_craft({
	output = 'inventorybags:collecting_upgrade',
	recipe = {
		{'default:steel_ingot', 'inventorybags:upgrade_base', 'default:steel_ingot'},
		{'default:steel_ingot', 'inventorybags:item_puller', 'default:steel_ingot'},
		{'default:obsidian_glass', '', 'default:obsidian_glass'},
	}
})

minetest.register_craft({
	output = 'inventorybags:advanced_collecting_upgrade',
	recipe = {
		{'default:steel_ingot', 'inventorybags:collecting_upgrade', 'default:steel_ingot'},
		{'default:steel_ingot', 'inventorybags:item_puller', 'default:steel_ingot'},
		{'default:obsidian_glass', '', 'default:obsidian_glass'},
	}
})

minetest.register_craft({
	output = 'inventorybags:sorting_upgrade',
	recipe = {
		{'', 'inventorybags:upgrade_base', ''},
		{'default:ladder_steel', 'default:ladder_steel', 'default:ladder_steel'},
		{'group:wool', 'inventorybags:item_filter', 'group:wool'},
	}
})

minetest.register_craft({
	output = 'inventorybags:autocrafting_upgrade',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'default:steel_ingot', 'default:mese_crystal', 'default:steel_ingot'},
		{'default:steel_ingot', 'inventorybags:upgrade_base', 'default:steel_ingot'},
	}
})

if minetest.get_modpath("pipeworks") then
	minetest.register_craft({
			type = "shapeless",
			output = 'inventorybags:autocrafting_upgrade',
			recipe = {"inventorybags:upgrade_base", "pipeworks:autocrafter",},
		})
end


minetest.register_craft({
	output = 'inventorybags:dumping_upgrade',
	recipe = {
		{'default:steel_ingot', 'inventorybags:upgrade_base', 'default:steel_ingot'},
		{'default:steel_ingot', 'inventorybags:item_puller', 'default:steel_ingot'},
		{'group:stone', 'bucket:bucket_lava', 'group:stone'},
	},
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

minetest.register_craft({
	output = 'inventorybags:opening_sound_upgrade',
	recipe = {
		{'inventorybags:closing_sound_upgrade'},
	}
})

minetest.register_craft({
	output = 'inventorybags:closing_sound_upgrade',
	recipe = {
		{'inventorybags:opening_sound_upgrade'},
	}
})

minetest.register_craft({
	output = 'inventorybags:opening_sound_upgrade',
	recipe = {
		{'', '', 'default:steel_ingot'},
		{'inventorybags:upgrade_base', 'default:steel_ingot', 'default:paper'},
		{'', '', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'inventorybags:refilling_upgrade',
	recipe = {
		{'default:bronze_ingot', 'inventorybags:item_puller', 'default:bronze_ingot'},
		{'default:bronze_ingot', 'inventorybags:upgrade_base', 'default:bronze_ingot'},
	}
})

minetest.register_craft({
	output = 'inventorybags:closing_sound_upgrade',
	recipe = {
		{'default:steel_ingot', '', ''},
		{'default:paper', 'default:steel_ingot', 'inventorybags:upgrade_base'},
		{'default:steel_ingot', '', ''},
	}
})

if minetest.registered_items["inventorybags:explosion_upgrade"] then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:explosion_upgrade',
		recipe = {"inventorybags:upgrade_base", "tnt:gunpowder", "tnt:tnt"},
	})
end

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_1',
	recipe = {
		{'default:steelblock', 'inventorybags:large_pouch', 'default:steelblock'},
		{'inventorybags:large_pouch', 'inventorybags:upgrade_base', 'inventorybags:large_pouch'},
		{'default:steelblock', 'inventorybags:large_pouch', 'default:steelblock'},
	}
})

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_2',
	recipe = {
		{'default:goldblock', 'inventorybags:large_pouch', 'default:goldblock'},
		{'inventorybags:large_pouch', 'inventorybags:storage_upgrade_tier_1', 'inventorybags:large_pouch'},
		{'default:goldblock', 'inventorybags:large_pouch', 'default:goldblock'},
	}
})

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_3',
	recipe = {
		{'default:diamondblock', 'inventorybags:large_pouch', 'default:diamondblock'},
		{'inventorybags:large_pouch', 'inventorybags:storage_upgrade_tier_2', 'inventorybags:large_pouch'},
		{'default:diamondblock', 'inventorybags:large_pouch', 'default:diamondblock'},
	}
})

-- Bags

-- 3 wool
minetest.register_craft({
	output = 'inventorybags:tiny_pouch',
	recipe = {
		{'inventorybags:yarn'},
		{'inventorybags:fabric'},
	},
})

-- 15 wool
minetest.register_craft({
	output = 'inventorybags:small_pouch',
	recipe = {
		{'', 'inventorybags:yarn', ''},
		{'inventorybags:fabric', 'inventorybags:tiny_pouch', 'inventorybags:fabric'},
		{'inventorybags:fabric', 'inventorybags:tiny_pouch', 'inventorybags:fabric'},
	},
})

minetest.register_craft({
	output = 'inventorybags:small_pouch',
	recipe = {
		{'inventorybags:yarn', 'inventorybags:yarn', 'inventorybags:yarn'},
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:fabric'},
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:fabric'},
	},
})

-- 39 wool
minetest.register_craft({
	output = 'inventorybags:medium_pouch',
	recipe = {
		{'', 'inventorybags:yarn', ''},
		{'inventorybags:fabric', 'inventorybags:small_pouch', 'inventorybags:fabric'},
		{'inventorybags:fabric', 'inventorybags:small_pouch', 'inventorybags:fabric'},
	},
})

-- 87 wool
minetest.register_craft({
	output = 'inventorybags:large_pouch',
	recipe = {
		{'', 'inventorybags:yarn', ''},
		{'inventorybags:fabric', 'inventorybags:medium_pouch', 'inventorybags:fabric'},
		{'inventorybags:fabric', 'inventorybags:medium_pouch', 'inventorybags:fabric'},
	},
})

minetest.register_craft({
	output = 'inventorybags:backpack',
	recipe = {
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:yarn'},
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:yarn'},
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:yarn'},
	},
})

minetest.register_craft({
	output = 'inventorybags:suitcase',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'inventorybags:large_pouch', 'inventorybags:fabric', 'inventorybags:large_pouch'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	},
})

minetest.register_craft({
	output = 'inventorybags:bag_on_a_stick',
	recipe = {
		{'', '', 'group:stick'},
		{'', 'group:stick', 'inventorybags:large_pouch'},
		{'group:stick', '', 'inventorybags:large_pouch'},
	},
})

minetest.register_craft({
	output = 'inventorybags:belt_bag',
	recipe = {
		{'inventorybags:yarn', 'inventorybags:large_pouch', 'inventorybags:yarn'},
		{'inventorybags:yarn', 'inventorybags:fabric', 'inventorybags:yarn'},
		{'inventorybags:yarn', 'inventorybags:large_pouch', 'inventorybags:yarn'},
	},
})

minetest.register_craft({
	output = 'inventorybags:hand_bag',
	recipe = {
		{'inventorybags:yarn', '', 'inventorybags:yarn'},
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:fabric'},
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:fabric'},
	},
})

minetest.register_craft({
	output = 'inventorybags:chest_bag',
	recipe = {
		{'inventorybags:yarn', '', 'inventorybags:yarn'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'inventorybags:large_pouch', 'default:chest', 'inventorybags:large_pouch'},
	},
})

minetest.register_craft({
	output = 'inventorybags:satchel',
	recipe = {
		{'inventorybags:yarn', 'inventorybags:yarn', 'inventorybags:yarn'},
		{'inventorybags:yarn', '', 'inventorybags:yarn'},
		{'inventorybags:large_pouch', 'inventorybags:fabric', 'inventorybags:large_pouch'},
	},
})

minetest.register_craft({
	output = 'inventorybags:paper_bag',
	recipe = {
		{'default:paper', '', 'default:paper'},
		{'default:paper', 'default:paper', 'default:paper'},
		{'default:paper', 'default:paper', 'default:paper'},
	},
})

if minetest.registered_items["homedecor:plastic_sheeting"] then
	minetest.register_craft({
		output = 'inventorybags:plastic_bag',
		recipe = {
			{'homedecor:plastic_sheeting', '', 'homedecor:plastic_sheeting'},
			{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
			{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		},
	})
end

-- 395 wool
minetest.register_craft({
	output = 'inventorybags:bag_transporting_bag',
	recipe = {
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:fabric'},
		{'inventorybags:large_pouch', 'inventorybags:small_pouch', 'inventorybags:large_pouch'},
		{'inventorybags:fabric', 'inventorybags:large_pouch', 'inventorybags:fabric'},
	},
})

if minetest.setting_getbool("inventorybags_enable_item_teleportation_bag") then
	minetest.register_craft({
		output = 'inventorybags:item_teleportation_bag',
		recipe = {
			{'default:diamond', 'inventorybags:large_pouch', 'default:diamond'},
			{'default:diamond', 'inventorybags:inventory_connecter', 'default:diamond'},
			{'default:diamond', 'default:mese', 'default:diamond'},
		},
	})
	if minetest.get_modpath("pipeworks") then
		minetest.register_craft({
			type = "shapeless",
			output = 'inventorybags:item_teleportation_bag',
			recipe = {"inventorybags:large_pouch", "inventorybags:inventory_connecter", "pipeworks:teleport_tube_1"},
		})
	end
end

if minetest.get_modpath("xdecor") then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:ender_bag',
		recipe = {"inventorybags:large_pouch", "inventorybags:inventory_connecter", "xdecor:enderchest"},
	})
end

if minetest.get_modpath("more_chests") then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:wifi_bag',
		recipe = {"inventorybags:large_pouch","inventorybags:inventory_connecter", "more_chests:wifi"},
	})
end

if minetest.get_modpath("beds") then
	minetest.register_craft({
		output = 'inventorybags:sleeping_bag',
		recipe = {
			{"wool:red", "wool:red", "wool:white"},
			{"", "inventorybags:large_pouch", ""}
		},
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:sleeping_bag',
		recipe = {"inventorybags:large_pouch", "group:bed"},
	})
end
if not minetest.setting_getbool("inventorybags_dialable_bag_of_winds") then
	minetest.register_craft({
		output = 'inventorybags:bag_of_winds_closed',
		recipe = {
			{"default:goldblock", "inventorybags:large_pouch", "default:goldblock"},
			{"default:diamondblock", "default:mese", "default:diamondblock"},
			{"default:diamondblock", "default:mese", "default:diamondblock"}
		},
	})
end
