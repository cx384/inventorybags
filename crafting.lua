minetest.log(inventory_bags.game)

local items = {
	steel_ingot = {mtg = "default:steel_ingot", mcl = "mcl_core:iron_ingot"},
	gold_ingot = {mtg = "default:gold_ingot", mcl = "mcl_core:gold_ingot"},
	obsidian_glass = {mtg = "default:obsidian_glass", mcl = "mcl_amethyst:tinted_glass"},
	mese_lamp = {mtg = "default:meselamp", mcl = "mesecons_lightstone:lightstone_off"},
	mese_crystal = {mtg = "default:mese_crystal", mcl = "mesecons_torch:redstoneblock"},
	mese_crystal_fragment = {mtg = "default:mese_crystal_fragment", mcl = "mesecons:redstone"},
	paper = {mtg = "default:paper", mcl = "mcl_core:paper"},
	cyan_dye = {mtg = "dye:cyan", mcl = "mcl_dye:cyan"},
	magenta_dye = {mtg = "dye:magenta", mcl = "mcl_dye:magenta"},
	yellow_dye = {mtg = "dye:yellow", mcl = "mcl_dye:yellow"},
	black_dye = {mtg = "dye:black", mcl = "mcl_dye:black"},
	white_dye = {mtg = "dye:white", mcl = "mcl_dye:white"},
	red_dye = {mtg = "dye:red", mcl = "mcl_dye:red"},
	green_dye = {mtg = "dye:green", mcl = "mcl_dye:green"},
	blue_dye = {mtg = "dye:blue", mcl = "mcl_dye:blue"},
	steel_ladder = {mtg = "default:steel_ladder", mcl = "mcl_core:lapis"},
	lava_bucket = {mtg = "bucket:bucket_lava", mcl = "mcl_buckets:bucket_lava"},
	empty_bucket = {mtg = "bucket:bucket_empty", mcl = "mcl_buckets:bucket_lava"},
	bronze_ingot = {mtg = "default:bronze_ingot", mcl = "mcl_copper:copper_ingot"},
	gunpowder = {mtg = "tnt:gunpowder", mcl = "mcl_mobitems:gunpowder"},
	tnt = {mtg = "tnt:tnt", mcl = "mcl_tnt:tnt"},
	steel_block = {mtg = "default:steelblock", mcl = "mcl_core:ironblock"},
	gold_block = {mtg = "default:goldblock", mcl = "mcl_core:goldblock"},
	diamond_block = {mtg = "default:diamondblock", mcl = "mcl_core:diamondblock"},
	chest = {mtg = "default:chest", mcl = "mcl_chests:chest"},
	diamond = {mtg = "default:diamond", mcl = "mcl_core:diamond"},
	mese_block = {mtg = "default:mese", mcl = "mcl_core:lapisblock"},
	ender_chest = {mtg = "xdecor:enderchest", mcl = "mcl_chests:ender_chest"},
	red_wool = {mtg = "wool:red", mcl = "mcl_wool:red"},
	white_wool = {mtg = "wool:white", mcl = "mcl_wool:red"},
}

-- Craftitem / Misc

minetest.register_craft({
	output = 'inventorybags:item_filter',
	recipe = {
		{items.steel_ingot[inventory_bags.game], 'group:stick', items.steel_ingot[inventory_bags.game]},
		{'group:stick', 'inventorybags:fabric', 'group:stick'},
		{items.steel_ingot[inventory_bags.game], 'group:stick', items.steel_ingot[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:item_puller',
	recipe = {
		{items.steel_ingot[inventory_bags.game], items.gold_ingot[inventory_bags.game], items.steel_ingot[inventory_bags.game]},
		{items.obsidian_glass[inventory_bags.game], 'inventorybags:item_filter', items.obsidian_glass[inventory_bags.game]},
		{items.obsidian_glass[inventory_bags.game], '', items.obsidian_glass[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:inventory_connecter',
	recipe = {
		{'inventorybags:fabric', 'inventorybags:fabric', 'inventorybags:fabric'},
		{'inventorybags:item_puller', items.mese_crystal[inventory_bags.game], 'inventorybags:item_puller'},
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
		{'group:stick', items.mese_lamp[inventory_bags.game], ''},
		{'group:stick', 'inventorybags:upgrade_base', ''},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

-- Upgrades

minetest.register_craft({
	output = 'inventorybags:upgrade_base',
	recipe = {
		{'inventorybags:yarn', 'group:stick', 'inventorybags:yarn'},
		{'group:stick', items.mese_crystal_fragment[inventory_bags.game], 'group:stick'},
		{'inventorybags:yarn', 'group:stick', 'inventorybags:yarn'},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:rename_upgrade",
	recipe = {"inventorybags:upgrade_base", items.paper[inventory_bags.game]},
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:coloring_upgrade",
	recipe = {"inventorybags:upgrade_base", items.cyan_dye[inventory_bags.game], items.magenta_dye[inventory_bags.game], items.yellow_dye[inventory_bags.game], items.black_dye[inventory_bags.game], items.white_dye[inventory_bags.game]},
})

minetest.register_craft({
	type = "shapeless",
	output = "inventorybags:coloring_upgrade",
	recipe = {"inventorybags:upgrade_base", items.red_dye[inventory_bags.game], items.green_dye[inventory_bags.game], items.blue_dye[inventory_bags.game], items.black_dye[inventory_bags.game], items.white_dye[inventory_bags.game]},
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
		{items.steel_ingot[inventory_bags.game], 'inventorybags:upgrade_base', items.steel_ingot[inventory_bags.game]},
		{items.steel_ingot[inventory_bags.game], 'inventorybags:item_puller', items.steel_ingot[inventory_bags.game]},
		{items.obsidian_glass[inventory_bags.game], '', items.obsidian_glass[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:advanced_collecting_upgrade',
	recipe = {
		{items.steel_ingot[inventory_bags.game], 'inventorybags:collecting_upgrade', items.steel_ingot[inventory_bags.game]},
		{items.steel_ingot[inventory_bags.game], 'inventorybags:item_puller', items.steel_ingot[inventory_bags.game]},
		{items.obsidian_glass[inventory_bags.game], '', items.obsidian_glass[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:sorting_upgrade',
	recipe = {
		{'', 'inventorybags:upgrade_base', ''},
		{items.steel_ladder[inventory_bags.game], items.steel_ladder[inventory_bags.game], items.steel_ladder[inventory_bags.game]},
		{'group:wool', 'inventorybags:item_filter', 'group:wool'},
	}
})

minetest.register_craft({
	output = 'inventorybags:autocrafting_upgrade',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{items.steel_ingot[inventory_bags.game], items.mese_crystal[inventory_bags.game], items.steel_ingot[inventory_bags.game]},
		{items.steel_ingot[inventory_bags.game], 'inventorybags:upgrade_base', items.steel_ingot[inventory_bags.game]},
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
		{items.steel_ingot[inventory_bags.game], 'inventorybags:upgrade_base', items.steel_ingot[inventory_bags.game]},
		{items.steel_ingot[inventory_bags.game], 'inventorybags:item_puller', items.steel_ingot[inventory_bags.game]},
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
		{'', '', items.steel_ingot[inventory_bags.game]},
		{'inventorybags:upgrade_base', items.steel_ingot[inventory_bags.game], items.paper[inventory_bags.game]},
		{'', '', items.steel_ingot[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:refilling_upgrade',
	recipe = {
		{items.bronze_ingot[inventory_bags.game], 'inventorybags:item_puller', items.bronze_ingot[inventory_bags.game]},
		{items.bronze_ingot[inventory_bags.game], 'inventorybags:upgrade_base', items.bronze_ingot[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:closing_sound_upgrade',
	recipe = {
		{items.steel_ingot[inventory_bags.game], '', ''},
		{items.paper[inventory_bags.game], items.steel_ingot[inventory_bags.game], 'inventorybags:upgrade_base'},
		{items.steel_ingot[inventory_bags.game], '', ''},
	}
})

if minetest.registered_items["inventorybags:explosion_upgrade"] or inventory_bags.game == "mcl" then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:explosion_upgrade',
		recipe = {"inventorybags:upgrade_base", items.gunpowder[inventory_bags.game], items.tnt[inventory_bags.game]},
	})
end

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_1',
	recipe = {
		{items.steel_block[inventory_bags.game], 'inventorybags:large_pouch', items.steel_block[inventory_bags.game]},
		{'inventorybags:large_pouch', 'inventorybags:upgrade_base', 'inventorybags:large_pouch'},
		{items.steel_block[inventory_bags.game], 'inventorybags:large_pouch', items.steel_block[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_2',
	recipe = {
		{items.gold_block[inventory_bags.game], 'inventorybags:large_pouch', items.gold_block[inventory_bags.game]},
		{'inventorybags:large_pouch', 'inventorybags:storage_upgrade_tier_1', 'inventorybags:large_pouch'},
		{items.gold_block[inventory_bags.game], 'inventorybags:large_pouch', items.gold_block[inventory_bags.game]},
	}
})

minetest.register_craft({
	output = 'inventorybags:storage_upgrade_tier_3',
	recipe = {
		{items.diamond_block[inventory_bags.game], 'inventorybags:large_pouch', items.diamond_block[inventory_bags.game]},
		{'inventorybags:large_pouch', 'inventorybags:storage_upgrade_tier_2', 'inventorybags:large_pouch'},
		{items.diamond_block[inventory_bags.game], 'inventorybags:large_pouch', items.diamond_block[inventory_bags.game]},
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
		{items.steel_ingot[inventory_bags.game], items.steel_ingot[inventory_bags.game], items.steel_ingot[inventory_bags.game]},
		{'inventorybags:large_pouch', 'inventorybags:fabric', 'inventorybags:large_pouch'},
		{items.steel_ingot[inventory_bags.game], items.steel_ingot[inventory_bags.game], items.steel_ingot[inventory_bags.game]},
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
		{'inventorybags:large_pouch', items.chest[inventory_bags.game], 'inventorybags:large_pouch'},
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
		{items.paper[inventory_bags.game], '', items.paper[inventory_bags.game]},
		{items.paper[inventory_bags.game], items.paper[inventory_bags.game], items.paper[inventory_bags.game]},
		{items.paper[inventory_bags.game], items.paper[inventory_bags.game], items.paper[inventory_bags.game]},
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

if minetest.settings:get_bool("inventorybags_enable_item_teleportation_bag", false) then
	minetest.register_craft({
		output = 'inventorybags:item_teleportation_bag',
		recipe = {
			{items.diamond[inventory_bags.game], 'inventorybags:large_pouch', items.diamond[inventory_bags.game]},
			{items.diamond[inventory_bags.game], 'inventorybags:inventory_connecter', items.diamond[inventory_bags.game]},
			{items.diamond[inventory_bags.game], items.mese_block[inventory_bags.game], items.diamond[inventory_bags.game]},
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

if minetest.get_modpath("xdecor") or inventory_bags.game == "mcl" then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:ender_bag',
		recipe = {"inventorybags:large_pouch", "inventorybags:inventory_connecter", items.ender_chest[inventory_bags.game]},
	})
end

if minetest.get_modpath("more_chests") then
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:wifi_bag',
		recipe = {"inventorybags:large_pouch","inventorybags:inventory_connecter", "more_chests:wifi"},
	})
end

if minetest.get_modpath("beds") or inventory_bags.game == "mcl" then
	minetest.register_craft({
		output = 'inventorybags:sleeping_bag',
		recipe = {
			{items.red_wool[inventory_bags.game], items.red_wool[inventory_bags.game], items.white_wool[inventory_bags.game]},
			{"", "inventorybags:large_pouch", ""}
		},
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = 'inventorybags:sleeping_bag',
		recipe = {"inventorybags:large_pouch", "group:bed"},
	})
end
if not minetest.settings:get_bool("inventorybags_disable_bag_of_winds", false) and inventory_bags.game ~= "mcl" then
	minetest.register_craft({
		output = 'inventorybags:bag_of_winds_closed',
		recipe = {
			{items.gold_block[inventory_bags.game], "inventorybags:large_pouch", items.gold_block[inventory_bags.game]},
			{items.diamond_block[inventory_bags.game], items.mese_block[inventory_bags.game], items.diamond_block[inventory_bags.game]},
			{items.diamond_block[inventory_bags.game], items.mese_block[inventory_bags.game], items.diamond_block[inventory_bags.game]}
		},
	})
end
