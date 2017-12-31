
local function register_upgrade(data)

	minetest.register_craftitem(data.name, {
		description = data.description,
		inventory_image = data.inventory_image,
		groups = {inventorybags_upgrade = 1}
	})
	if not data.meta_string then
		data.meta_string = "true"
	end
	local setting = ""
	if not data.help_setting then
		setting = "#7bff00Setting:,Irrelevant"
	else
		setting = "#7bff00Setting:," .. data.help_setting
	end
	
	inventorybags.bud_recipes[data.name] = {
		name = data.name, 
		meta_name = data.meta_name,
		meta_string = data.meta_string,
		setting_meta_name = data.setting_meta_name,
		setting_type = data.setting_type
	}
		
	inventorybags.upgrade_help_string = 
		inventorybags.upgrade_help_string .."," ..
		"#ffa500" .. data.description .. ": ,".. data.help .. "," ..
		setting .. ","
end

local function string_list_to_table(setstring)
	local new_table = {}
	local notstop = true
	while notstop do
		local numstring = string.find(setstring, ",")
		if numstring then
			table.insert(new_table, string.sub(setstring, 1, numstring-1))
			setstring = string.sub(setstring, numstring+1)
		else
			table.insert(new_table, setstring)
			notstop = false
		end
	end
	return new_table
end

local function get_omodname(stackname)
	return string.sub(stackname, 1, string.find(stackname, ":")-1)
end

local function get_oname(stackname)
	return string.sub(stackname, string.find(stackname, ":")+1)
end

local function table_contains(v, t)
	for _, i in pairs(t) do
		if i == v then
			return true
		end
	end
	return false
end

local function match_filter(filter_table, stackname)
	if stackname == "" or not stackname then
		return false
	end
	
	-- blacklist
	local blacklist_match = 0
	if type(filter_table.blacklist_items) == "table" and table.maxn(filter_table.blacklist_items) ~= 0 then
		if table_contains(stackname, filter_table.blacklist_items) then
			blacklist_match = blacklist_match + 1
		end
	end
	if type(filter_table.group_filter_blacklist) == "string" and filter_table.group_filter_blacklist ~= "" then
		for _, group in pairs(string_list_to_table(filter_table.group_filter_blacklist)) do
			if minetest.get_item_group(stackname, group) > 0 then
				blacklist_match = blacklist_match + 1
			end
		end
	end
	if type(filter_table.mod_filter_blacklist) == "string" and filter_table.mod_filter_blacklist ~= "" then
		if table_contains(get_omodname(stackname), string_list_to_table(filter_table.mod_filter_blacklist)) then
			blacklist_match = blacklist_match + 1
		end
	end
	if type(filter_table.name_filter_blacklist) == "string" and filter_table.name_filter_blacklist ~= "" then
		for _, text in pairs(string_list_to_table(filter_table.name_filter_blacklist)) do
			if string.find(get_oname(stackname),text) then
				blacklist_match = blacklist_match + 1
			end
		end
	end
	
	-- whitelist
	local whitelist_match = 0
	local whitelist_exist = false
	if type(filter_table.whitelist_items) == "table" and table.maxn(filter_table.whitelist_items) ~= 0 then
		whitelist_exist = true
		if table_contains(stackname, filter_table.whitelist_items) then
			whitelist_match = whitelist_match + 1
		end
	end
	if type(filter_table.group_filter_whitelist) == "string" and filter_table.group_filter_whitelist ~= "" then
		whitelist_exist = true
		for _, group in pairs(string_list_to_table(filter_table.group_filter_whitelist)) do
			if minetest.get_item_group(stackname, group) > 0 then
				whitelist_match = whitelist_match + 1
			end
		end
	end
	if type(filter_table.mod_filter_whitelist) == "string" and filter_table.mod_filter_whitelist ~= "" then
		whitelist_exist = true
		if table_contains(get_omodname(stackname), string_list_to_table(filter_table.mod_filter_whitelist)) then
			whitelist_match = whitelist_match + 1
		end
	end
	if type(filter_table.name_filter_whitelist) == "string" and filter_table.name_filter_whitelist ~= "" then
		whitelist_exist = true
		for _, text in pairs(string_list_to_table(filter_table.name_filter_whitelist)) do
			if string.find(get_oname(stackname),text) then
				whitelist_match = whitelist_match + 1
			end
		end
	end
	
	if blacklist_match > 0 or (whitelist_exist and whitelist_match == 0) then
		return false
	else
		return true
	end
end

-- Rename Upgrade

register_upgrade({
	name = "inventorybags:rename_upgrade",
	description = "Rename Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_rename_upgrade.png",
	meta_name = "inventorybags_rename_upgrade",
	help = "Renames your bag.",
	setting_meta_name = "description",
	help_setting = 'The new name of your bag. ( Example: "The best bag in the world" )' 
})


-- Coloring Upgrade

register_upgrade({
	name = "inventorybags:coloring_upgrade",
	description = "Coloring Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_coloring_upgrade.png",
	meta_name = "inventorybags_coloring_upgrade",
	help = "Colors your bag.",
	setting_meta_name = "color",
	setting_type = "color",
	help_setting = 'The color of your bag. ( You can use the setting creator. )'
})

-- Storage Upgrades

register_upgrade({
	name = "inventorybags:storage_upgrade_tier_1",
	description = "Storage Upgrade Tier 1",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_storage_upgrade_tier_1.png",
	meta_name = "inventorybags_storage_upgrade_tier_1",
	help = "Increases the inventory height and width by at least one.",
})

register_upgrade({
	name = "inventorybags:storage_upgrade_tier_2",
	description = "Storage Upgrade Tier 2",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_storage_upgrade_tier_2.png",
	meta_name = "inventorybags_storage_upgrade_tier_2",
	help = "Increases the inventory height and width by at least one. ( You have to install all tiers. )",
})

register_upgrade({
	name = "inventorybags:storage_upgrade_tier_3",
	description = "Storage Upgrade Tier 3",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_storage_upgrade_tier_3.png",
	meta_name = "inventorybags_storage_upgrade_tier_3",
	help = "Increases the inventory height and width by at least one. ( You have to install all tiers. )",
})

local function increase_bag_size(width, height, bwidth, bheight)
	if bwidth > bheight then
		local wdh = bwidth / bheight
		height = height + 1
		width = bwidth + math.floor((height - bheight) * wdh)
	else
		local hdw = bheight / bwidth
		width = width + 1
		height = bheight + math.floor((width - bwidth) * hdw)
	end
	return width, height
end

local old_before_open_bag = inventorybags.before_open_bag
function inventorybags.before_open_bag(itemstack, user, width, height, sound)
	local meta = itemstack:get_meta()
	local bwidth, bheight = width, height
	if meta:get_string("inventorybags_storage_upgrade_tier_1") == "true" then
		width, height = increase_bag_size(width, height, bwidth, bheight)
	end
	if meta:get_string("inventorybags_storage_upgrade_tier_2") == "true" then
		width, height = increase_bag_size(width, height, bwidth, bheight)
	end
	if meta:get_string("inventorybags_storage_upgrade_tier_3") == "true" then
		width, height = increase_bag_size(width, height, bwidth, bheight)
	end
	return old_before_open_bag(itemstack, user, width, height, sound)
end

-- Collecting Upgrades

register_upgrade({
	name = "inventorybags:collecting_upgrade",
	description = "Collecting Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_collecting_upgrade.png",
	meta_name = "inventorybags_collecting_upgrade",
	help = "Puts node drops into your bag.",
	setting_meta_name = "inventorybags_collecting_filter",
	setting_type = "filter",
	help_setting = 'A filter string ( use the setting creator ).'
})

register_upgrade({
	name = "inventorybags:advanced_collecting_upgrade",
	description = "Advanced Collecting Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_advanced_collecting_upgrade.png",
	meta_name = "inventorybags_advanced_collecting_upgrade",
	help = "Puts all items into your bag.",
	setting_meta_name = "inventorybags_advanced_collecting_filter",
	setting_type = "filter",
	help_setting = 'A filter string ( use the setting creator ).'
})

local old_on_open_bag = inventorybags.on_open_bag
function inventorybags.on_open_bag(bagstack, baginv, player)
	local meta = bagstack:get_meta()
	local inv = player:get_inventory()
	local size = inv:get_size("main")
	if meta:get_string("inventorybags_advanced_collecting_upgrade") == "true" then
		for k = 1, size, 1 do
			local astack = inv:get_stack("main", k)
			if astack and minetest.get_item_group(astack:get_name(), "bag") == 0 then
				local fadd_item = true
				local filter_table = minetest.deserialize(meta:get_string("inventorybags_advanced_collecting_filter"))
				if filter_table then
					if not match_filter(filter_table, astack:get_name()) then
						fadd_item = false
					end
				end
				if fadd_item == true then
					if inv:room_for_item("main", astack) then
						inv:remove_item("main", astack)
						baginv:add_item("main", astack)
					end
				end
			end
		end
	end
	return old_on_open_bag(bagstack, baginv, player)
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger then
		return
	end
	local inv = digger:get_inventory()
	if not inv then
		return
	end
	local drops = minetest.get_node_drops(oldnode.name, digger:get_wielded_item():get_name())
	local size = inv:get_size("main")
	local done_coll = false
	local done_acoll = false
	for i = 1, size, 1 do
		local stack = inv:get_stack("main", i)
		local meta = stack:get_meta()
		if minetest.get_item_group(stack:get_name(), "bag") > 0 then
			if meta:get_string("inventorybags_collecting_upgrade") == "true" and not done_coll then
				for drn, drop in pairs(drops) do
					if inv:contains_item("main", drop) and minetest.get_item_group(drop, "bag") == 0 then
						local fadd_item = true
						local filter_table = minetest.deserialize(meta:get_string("inventorybags_collecting_filter"))
						if filter_table then
							if not match_filter(filter_table, drop) then
								fadd_item = false
							end
						end
						if fadd_item == true then
							local newstack = inventorybags.bag_inv_add_item(stack, drop)
							if newstack then
								inv:remove_item("main", drop)
								inv:set_stack("main", i, newstack)
								done_coll = true
							end
						end
					end
				end
			end
			if meta:get_string("inventorybags_advanced_collecting_upgrade") == "true" and not done_acoll then
				for k = 1, size, 1 do
					local astack = inv:get_stack("main", k)
					if astack and minetest.get_item_group(astack:get_name(), "bag") == 0 then
						local fadd_item = true
						local filter_table = minetest.deserialize(meta:get_string("inventorybags_advanced_collecting_filter"))
						if filter_table then
							if not match_filter(filter_table, astack:get_name()) then
								fadd_item = false
							end
						end
						if fadd_item == true then
							local newstack = inventorybags.bag_inv_add_item(stack, astack)
							if newstack then
								inv:remove_item("main", astack)
								inv:set_stack("main", i, newstack)
								done_acoll = true
							end
						end
					end
				end
			end
		end
	end
end)

-- Sorting Upgrade

register_upgrade({
	name = "inventorybags:sorting_upgrade",
	description = "Sorting Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_sorting_upgrade.png",
	meta_name = "inventorybags_sorting_upgrade",
	help = "Sorts all items in your bag."
})

local old_on_open_bag = inventorybags.on_open_bag
function inventorybags.on_open_bag(bagstack, baginv, player)
	local meta = bagstack:get_meta()
	if meta:get_string("inventorybags_sorting_upgrade") == "true" then
		inventorybags.sort_inventory(baginv)
	end
	return old_on_open_bag(bagstack, baginv, player)
end

-- Dumping Upgrade

register_upgrade({
	name = "inventorybags:dumping_upgrade",
	description = "Dumping Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_dumping_upgrade.png",
	meta_name = "inventorybags_dumping_upgrade",
	help = "Destroys every item in your bag.",
	setting_meta_name = "inventorybags_dumping_filter",
	setting_type = "filter",
	help_setting = 'A filter string ( use the setting creator ).'
})

local old_on_change_bag_inv = inventorybags.on_change_bag_inv
function inventorybags.on_change_bag_inv(bagstack, baginv)
	local meta = bagstack:get_meta()
	if meta:get_string("inventorybags_dumping_upgrade") == "true" then
		local size = baginv:get_size("main")
		local filter_table = minetest.deserialize(meta:get_string("inventorybags_dumping_filter"))
		if filter_table then
			for i = 1, size, 1 do
				local stack = baginv:get_stack("main", i)
				if match_filter(filter_table, stack:get_name()) then
					baginv:set_stack("main", i, "")
				end
			end
		else
			for i = 1, size, 1 do
				baginv:set_stack("main", i, "")
			end
		end
	end
	return old_on_change_bag_inv(bagstack, baginv)
end

-- Sound Upgrades

register_upgrade({
	name = "inventorybags:opening_sound_upgrade",
	description = "Opening Sound Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_sound_upgrade.png",
	meta_name = "inventorybags_opening_sound_upgrade",
	help = "Plays a sound when you are opening your bag.",
	setting_meta_name = "inventorybags_opening_sound",
	help_setting = 'The name of a sound. ( Examples: "inventorybags_open_zipper" "default_break_glass" "tnt_explode" )'
})

local old_before_open_bag = inventorybags.before_open_bag
function inventorybags.before_open_bag(itemstack, user, width, height, sound)
	local meta = itemstack:get_meta()
	if meta:get_string("inventorybags_opening_sound_upgrade") == "true" then
		sound = meta:get_string("inventorybags_opening_sound")
	end
	return old_before_open_bag(itemstack, user, width, height, sound)
end

register_upgrade({
	name = "inventorybags:closing_sound_upgrade",
	description = "Closing Sound Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^(inventorybags_sound_upgrade.png^[transform2)",
	meta_name = "inventorybags_closing_sound_upgrade",
	help = "Plays a sound when you are closing your bag.",
	setting_meta_name = "inventorybags_closing_sound",
	help_setting = 'The name of a sound. ( Examples: "inventorybags_close_zipper" "default_dig_metal" "player_damage" )'
})

local old_on_close_bag = inventorybags.on_close_bag
function inventorybags.on_close_bag(player, fields, name, formname, sound)
	local inv = player:get_inventory()
	local size = inv:get_size("main")
	local bagstacki = nil
	for i = 1, size, 1 do
		local stack = inv:get_stack("main", i)
		local meta = stack:get_meta()
		if stack:get_name() == name and meta:get_string("inventorybags_bag_identity") == formname then
			bagstacki = i
			break
		end
	end
	if bagstacki then
		local itemstack = inv:get_stack("main", bagstacki)
		local meta = itemstack:get_meta()
		if meta:get_string("inventorybags_closing_sound_upgrade") == "true" then
			sound = meta:get_string("inventorybags_closing_sound")
		end
	end
	return old_on_close_bag(player, fields, name, formname, sound)
end

-- Autocrafting Upgrade

register_upgrade({
	name = "inventorybags:autocrafting_upgrade",
	description = "Autocrafting Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_autocrafting_upgrade.png",
	meta_name = "inventorybags_autocrafting_upgrade",
	help = "Crafts items automatically.",
	setting_meta_name = "inventorybags_autocrafting_recipes",
	setting_type = "crafting",
	help_setting = 'A list of crafting recipes ( use the setting creator ).'
})

local function make_max_crafting(inv, recipes)
	local size = inv:get_size("main")
	local inv_table = {}
	for i = 1, size, 1 do
		local stack = inv:get_stack("main", i)
		local stack_name = stack:get_name()
		local stack_count = stack:get_count()
		if stack_count > 0 then
			if inv_table[stack_name] then
				inv_table[stack_name] = inv_table[stack_name] + stack_count
			else
				inv_table[stack_name] = stack_count
			end
		end
	end
	local recipes_table = {} 
	for j, recipe in pairs(recipes) do
		local craft_result = minetest.get_craft_result({items = recipe, method = "normal", width = 3}).item
		if craft_result:get_count() > 0 then
			recipes_table[j] = {}
			for k, citem in pairs(recipe) do
				if citem ~= "" then
					if recipes_table[j][citem] then
						recipes_table[j][citem] = recipes_table[j][citem] + 1
					else
						recipes_table[j][citem] = 1
					end
				end
			end
		end
	end
	local rcounter = 1
	local nrecipes = #recipes_table
	while nrecipes > 0 do
		if rcounter > nrecipes then
			rcounter = 1
		end
		local recipe = recipes_table[nrecipes]
		local craft_results = minetest.get_craft_result({items = recipes[nrecipes], method = "normal", width = 3})
		local stop_sequence = false
		if not inv:room_for_item("main", craft_results.item) then
			stop_sequence = true
		elseif craft_results.replacements then
			for _, replacement in pairs(craft_results.replacements) do
				if not inv:room_for_item("main", replacement) then
					stop_sequence = true
				end
			end
		end
		if not stop_sequence then
			for citem, count in pairs(recipe) do
				if not( inv_table[citem] and inv_table[citem] >= count ) then
					stop_sequence = true
				end
			end
		end
		if not stop_sequence then
			for citem, count in pairs(recipe) do
				inv_table[citem] = inv_table[citem] - count
				inv:remove_item("main", {name = citem, count = count})
			end
			inv:add_item("main", craft_results.item)
			for _, replacement in pairs(craft_results.replacements) do
				inv:add_item("main", replacement)
			end
		else
			recipes_table[nrecipes] = nil
			nrecipes = nrecipes -1
		end
		rcounter = rcounter+1
	end
end

local old_on_change_bag_inv = inventorybags.on_change_bag_inv
function inventorybags.on_change_bag_inv(bagstack, baginv)
	local meta = bagstack:get_meta()
	if meta:get_string("inventorybags_autocrafting_upgrade") == "true" then
		local setting_table = minetest.deserialize(meta:get_string("inventorybags_autocrafting_recipes"))
		if setting_table then
			local recipes = setting_table.recipe_items
			if recipes then
				make_max_crafting(baginv, recipes)
			end
		end
	end
	return old_on_change_bag_inv(bagstack, baginv)
end

-- Refilling Upgrade

register_upgrade({
	name = "inventorybags:refilling_upgrade",
	description = "Refilling Upgrade",
	inventory_image = "inventorybags_upgrade_base.png^inventorybags_refilling_upgrade.png",
	meta_name = "inventorybags_refilling_upgrade",
	help = "Automatically refills your stack on placing.",
})

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not placer then
		return
	end
	local inv = placer:get_inventory()
	if not inv then
		return
	end
	local size = inv:get_size("main")
	for i = 1, size, 1 do
		local bagstack = inv:get_stack("main", i)
		local meta = bagstack:get_meta()
		if minetest.get_item_group(bagstack:get_name(), "bag") > 0 and
				meta:get_string("inventorybags_refilling_upgrade") == "true"  then
			local free_space = itemstack:get_free_space()
			local rem_bagstack = nil
			if free_space > 0 then
				rem_bagstack = inventorybags.bag_inv_remove_item(bagstack, itemstack:peek_item(1))
				if rem_bagstack then
					itemstack:set_count(itemstack:get_count()+1)
					free_space = itemstack:get_free_space()
				end	
			end
			while free_space > 0 and rem_bagstack do
				bagstack = rem_bagstack
				itemstack:set_count(itemstack:get_count()+1)
				free_space = itemstack:get_free_space()
				rem_bagstack = inventorybags.bag_inv_remove_item(bagstack, itemstack:peek_item(1))
			end
			inv:set_stack("main", i, bagstack)
		end
	end
end)

-- Explosion Upgrade

local enable_tnt = minetest.settings:get_bool("enable_tnt")
if enable_tnt == nil then
	enable_tnt = minetest.is_singleplayer()
end

if minetest.get_modpath("tnt") and enable_tnt then

	register_upgrade({
		name = "inventorybags:explosion_upgrade",
		description = "Explosion Upgrade",
		inventory_image = "inventorybags_upgrade_base.png^inventorybags_explosion_upgrade.png",
		meta_name = "inventorybags_explosion_upgrade",
		help = "If you drop your bag it explodes after some time. ( You will lose the bag. ),"..
			"You can also hold sneak and left click to blast the bag instantly.,"..
			"The explosion radius depends on how much TNT do you have in your bag.",
		setting_meta_name = "inventorybags_explosion_upgrade_time",
		help_setting = 'The time before the bag explodes in seconds (1-30). (default 4)'
	})
	
	local old_on_drop_bag = inventorybags.on_drop_bag
	function inventorybags.on_drop_bag(itemstack, dropper, pos)
		local meta = itemstack:get_meta()
		if meta:get_string("inventorybags_explosion_upgrade") == "true" then
			local dtime = tonumber(meta:get_string("inventorybags_explosion_upgrade_time")) or 4
			if dtime > 30 then
				dtime = 30
			end
			local itemname = itemstack:get_name()
			local color = meta:get_string("color") or ""
			if color ~= "" and string.len(color) == 7 and string.sub(color,1,1) == "#" then
				color = "^[multiply:"..color
			else
				color = ""
			end
			local def = {}
			local tnt_radius = tonumber(minetest.settings:get("tnt_radius") or 3)
			local n = 0  --n >= 1
			local old_itemstack = itemstack
			while old_itemstack do
				n = n + 1
				old_itemstack = inventorybags.bag_inv_remove_item(itemstack, "tnt:tnt")
			end
			itemstack:take_item()
			def.radius = tnt_radius*(n^(1/3))
			def.damage_radius = def.radius * 2
			minetest.sound_play("tnt_ignite", {pos = pos})
			minetest.after(dtime, tnt.boom, pos, def)
			minetest.add_particle({
				pos = pos,
				expirationtime = dtime,
				size = def.radius * 2,
				collisiondetection = false,
				vertical = false,
				texture = minetest.registered_items[itemname].inventory_image..color,
			})
			return itemstack, dropper, pos
		end
		return old_on_drop_bag(itemstack, dropper, pos)
	end
	
	local old_on_use_bag = inventorybags.on_use_bag
	function inventorybags.on_use_bag(itemstack, user, pointed_thing)
		local meta = itemstack:get_meta()
		if meta:get_string("inventorybags_explosion_upgrade") == "true" and user:get_player_control().sneak == true then
			local pos = user:get_pos()
			local def = {}
			local tnt_radius = tonumber(minetest.settings:get("tnt_radius") or 3)
			local n = 0  --n >= 1
			local old_itemstack = itemstack
			while old_itemstack do
				n = n + 1
				old_itemstack = inventorybags.bag_inv_remove_item(itemstack, "tnt:tnt")
			end
			itemstack:take_item()
			def.radius = tnt_radius*(n^(1/3))
			def.damage_radius = def.radius * 2
			tnt.boom(pos, def)
			return itemstack, dropper, pos
		end
		return old_on_use_bag(itemstack, user, pointed_thing)
	end
end

