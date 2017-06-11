local function drop_inv(inv, player, plistname)
	if plistname then
		local listname = plistname
		local size = inv:get_size(listname)
		if size then
			for i = 1, size, 1 do
				local stack = inv:get_stack(listname, i)
				if stack:get_name() ~="" then
					minetest.item_drop(stack, player, player:get_pos())
					inv:set_stack(listname, i, "")
				end
			end
		end
	else
		for listname, list in pairs(inv:get_lists()) do
			local size = inv:get_size(listname)
			if size then
				for i = 1, size, 1 do
					local stack = inv:get_stack(listname, i)
					if stack:get_name() ~="" then
						minetest.item_drop(stack, player, player:get_pos())
						inv:set_stack(listname, i, "")
					end
				end
			end
		end
	end
end

local function rbg_to_hex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or
			(alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

local function hex_to_rbg(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

local function open_spinning_wheel(user)
	local playername = user:get_player_name()
	local invname = "inventorybags_"..playername.."_spinning_wheel"
	local inv = minetest.get_inventory({type="player", name=playername})
	inv:set_size(invname.."_in", 1)
	inv:set_size(invname.."_out", 4)
		
	minetest.show_formspec(playername, invname,
		"size[8,7]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_player;"..invname.."_in;1,0.8;1,1;]" ..
		"item_image[1,0.8;1,1;wool:white]" ..
		"button[3,0.8;1,1;spin;Spin]" ..
		"list[current_player;"..invname.."_out;5,0.3;2,2;]" ..
		"list[current_player;main;0,2.85;8,1;]" ..
		"list[current_player;main;0,4.08;8,3;8]" ..
		"listring[current_player;"..invname.."_out]" ..
		"listring[current_player;main]" ..
		"listring[current_player;"..invname.."_in]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,2.85)
	)
end

minetest.register_craftitem("inventorybags:spinning_wheel", {
	description = "Spinning Wheel (right click to use)",
	inventory_image = "inventorybags_spinning_wheel.png",
	on_secondary_use = function(itemstack, user)
		return open_spinning_wheel(user)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		return open_spinning_wheel(placer)
	end,
})

local function open_loom(user)
	local playername = user:get_player_name()
	local invname = "inventorybags_"..playername.."_loom"
	local inv = minetest.get_inventory({type="player", name=playername})
	inv:set_size(invname.."_in", 2)
	inv:set_size(invname.."_out", 4)
	
	minetest.show_formspec(playername, invname,
		"size[8,7]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_player;"..invname.."_in;1,0.3;1,2;]" ..
		"item_image[1,0.3;1,1;inventorybags:yarn]" ..
		"item_image[1,1.3;1,1;inventorybags:yarn]" ..
		"button[3,0.8;1,1;weave;Weave]" ..
		"list[current_player;"..invname.."_out;5,0.3;2,2;]" ..
		"list[current_player;main;0,2.85;8,1;]" ..
		"list[current_player;main;0,4.08;8,3;8]" ..
		"listring[current_player;"..invname.."_out]" ..
		"listring[current_player;main]" ..
		"listring[current_player;"..invname.."_in]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,2.85)
	)
end

minetest.register_craftitem("inventorybags:loom", {
	description = "Loom (right click to use)",
	inventory_image = "inventorybags_loom.png",
	on_secondary_use = function(itemstack, user)
		return open_loom(user)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		return open_loom(placer)
	end,
})

local function open_bud(user)
	local playername = user:get_player_name()
	local invname = "inventorybags_"..playername.."_bud"
	local inv = minetest.get_inventory({type="player", name=playername})
	local setting_default = minetest.formspec_escape(user:get_attribute("inventorybags_setting_default")) or ""
	inv:set_size(invname.."_bag", 1)
	inv:set_size(invname.."_upgrade", 1)
	inv:set_size(invname.."_out", 1)
	minetest.show_formspec(playername, invname,
		"size[8,7]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"field[0.4,2.2;3.2,0;setting;Setting;"..setting_default.."]" ..
		"field_close_on_enter[setting;false]" ..
		"item_image[0.5,0.3;1,1;inventorybags:large_pouch]" ..
		"item_image[2,0.3;1,1;inventorybags:upgrade_base]" ..
		"button[3.5,0.3;1,1;upgrade;Upgrade]" ..
		"button[4.5,0.3;1.8,1;extract;Extract Upgrade]" ..
		"button[3.5,1.4;1,1;help;Help]" ..
		"button[4.5,1.4;1.8,1;setting_creator;Setting Creator]" ..
		"button[6.3,1.4;1.8,1;recover_setting;Recover Setting]" ..
		"list[current_player;"..invname.."_bag;0.5,0.3;1,1;]" ..
		"list[current_player;"..invname.."_upgrade;2,0.3;1,1;]" ..
		"list[current_player;"..invname.."_out;6.5,0.3;1,1;]" ..
		"list[current_player;main;0,2.85;8,1;]" ..
		"list[current_player;main;0,4.08;8,3;8]" ..
		"listring[current_player;"..invname.."_out]" ..
		"listring[current_player;main]" ..
		"listring[current_player;"..invname.."_bag]" ..
		"listring[current_player;main]" ..
		"listring[current_player;"..invname.."_upgrade]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,2.85)
	)
end

minetest.register_craftitem("inventorybags:bud", {
	description = "Bag Upgrade Device (right click to use)",
	inventory_image = "inventorybags_bud.png",
	on_secondary_use = function(itemstack, user)
		return open_bud(user)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		return open_bud(placer)
	end,
})

-- too lazy to make an api for one recipe :P
--inventorybags.spinning_wheel_recipes = {}
--inventorybags.loom_recipes = {}
if minetest.get_modpath("unified_inventory") then
	unified_inventory.register_craft_type("spinning", {
		description = "spinning",
		width = 1,
		height = 1,
	})
	unified_inventory.register_craft({
		type = "spinning",
		items = {"group:wool"},
		output = "inventorybags:yarn",
		width = 0,
	})
	unified_inventory.register_craft_type("weaving", {
		description = "weaving",
		width = 1,
		height = 2,
	})
	unified_inventory.register_craft({
		type = "weaving",
		items = {"inventorybags:yarn", "inventorybags:yarn"},
		output = "inventorybags:fabric",
		width = 0,
	})
end

local function set_crafting_output(inv)
	local input = {}
	input.method, input.width, input.items = "normal", 3, {}
	for i = 1, inv:get_size("recipe"), 1 do
		input.items[i] = inv:get_stack("recipe", i)
	end
	inv:set_stack("output", 1, minetest.get_craft_result(input).item)
end

local function show_setting_creator(player, setting_type, extra_table)
	local playername = player:get_player_name()
	local invname = "inventorybags_"..playername.."_bud_setting_creator"
	local inv = minetest.get_inventory({type="player", name=playername})
	local setting = player:get_attribute("inventorybags_setting_default")
	local setting_default = minetest.formspec_escape(setting) or ""
	if not extra_table then
		extra_table = {}
	end
	if setting_type == "color" then
		extra_table.preview = extra_table.preview or "black"
		extra_table.color_index = extra_table.color_index or "1"
		extra_table.red = extra_table.red or "0"
		extra_table.green = extra_table.green or "0"
		extra_table.blue = extra_table.blue or "0"
		extra_table.alpha = extra_table.alpha or "255"
		local colorss = "Named Colors:"
		for _, colort in pairs(inventorybags.named_colors) do
			colorss = colorss..","..colort.color..colort.name
		end
		local color_list = "textlist[0,0;7.5,2;color_list;"..colorss..";"..extra_table.color_index..";false]"
		minetest.show_formspec(playername, invname.."_color",
			"size[8,9]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			default.gui_slots ..
			"field[0.2,4.3;4.3,0;setting;Setting;"..setting_default.."]" ..
			"field_close_on_enter[setting;false]" ..
			"field[0.2,3.1;1.4,0;red;Red (0-255);"..extra_table.red.."]" ..
			"field_close_on_enter[red;false]" ..
			"field[1.6,3.1;1.4,0;green;Green (0-255);"..extra_table.green.."]" ..
			"field_close_on_enter[green;false]" ..
			"field[3.0,3.1;1.4,0;blue;Blue (0-255);"..extra_table.blue.."]" ..
			"field_close_on_enter[blue;false]" ..
			color_list ..
			"label[4.5,3.2;Preview:]"..
			"box[4.5,3.6;0.8,0.8;"..extra_table.preview.."]" ..
			"button[6,3.5;2,1;back;Back and Save]" ..
			"button[4.2,2.4;1.6,1;set_color;Set Color]" ..
			"button[6,2.4;2,1;random_color;Random Color]" ..
			"list[current_player;main;0,4.85;8,1;]" ..
			"list[current_player;main;0,6.08;8,3;8]" ..
			default.get_hotbar_bg(0,4.85)
		)
	elseif setting_type == "filter" then
		local finv = minetest.create_detached_inventory(invname.."_filter", {
			
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				inv:set_stack(to_list, to_index, inv:get_stack(from_list, from_index))
				inv:set_stack(from_list, from_index, "")
				return 0
			end,
			allow_put = function(inv, listname, index, stack, player)
				inv:set_stack(listname, index, stack:get_name())
				return 0
			end,
			allow_take = function(inv, listname, index, stack, player)
				inv:set_stack(listname, index, "")
				return 0
			end,
		}, playername)
		finv:set_size("whitelist", 4*1)
		finv:set_size("blacklist", 4*1)
		local setting_table = minetest.deserialize(setting) or {}
		local group_filter_whitelist_default = setting_table.group_filter_whitelist or ""
		local mod_filter_whitelist_default = setting_table.mod_filter_whitelist or ""
		local name_filter_whitelist_default = setting_table.name_filter_whitelist or ""
		local group_filter_blacklist_default = setting_table.group_filter_blacklist or ""
		local mod_filter_blacklist_default = setting_table.mod_filter_blacklist or ""
		local name_filter_blacklist_default = setting_table.name_filter_whitelist or ""
		if setting_table.whitelist_items and setting_table.whitelist_counter then
			for i, stack in pairs(setting_table.whitelist_items) do
				finv:set_stack("whitelist", i-setting_table.whitelist_counter+1, stack)
			end
		end
		if setting_table.blacklist_items and setting_table.blacklist_counter then
			for i, stack in pairs(setting_table.blacklist_items) do
				finv:set_stack("blacklist", i-setting_table.blacklist_counter+1, stack)
			end
		end
		minetest.show_formspec(playername, invname.."_filter",
			"size[12,11]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			default.gui_slots ..
			"label[0.2,0.1;Whitelist:          (An empty whitelist doesn't block any item)]"..
			"label[6.2,0.1;Blacklist:]"..
			"box[0,0;5.8,5.4;white]" ..
			"box[6,0;5.8,5.4;black]" ..
			"box[0.1,0.1;5.6,5.2;black]" ..
			"box[6.1,0.1;5.6,5.2;#6B6B6B]" ..
			"label[0.2,0.4;"..minetest.formspec_escape('comma separated lists for example: "moreblocks,default,technic"').."]"..
			"label[6.2,0.4;"..minetest.formspec_escape('comma separated lists for example: "tree,stone,sand,stick"').."]"..
			"field[0.5,1.3;5.6,1;group_filter_whitelist;Group Filter:;"..group_filter_whitelist_default.."]" ..
			"field[0.5,2.3;5.6,1;mod_filter_whitelist;Mod Filter:;"..mod_filter_whitelist_default.."]" ..
			"field[0.5,3.3;5.6,1;name_filter_whitelist;Name Filter:;"..name_filter_whitelist_default.."]" ..
			"field[6.5,1.3;5.6,1;group_filter_blacklist;Group Filter:;"..group_filter_blacklist_default.."]" ..
			"field[6.5,2.3;5.6,1;mod_filter_blacklist;Mod Filter:;"..mod_filter_blacklist_default.."]" ..
			"field[6.5,3.3;5.6,1;name_filter_blacklist;Name Filter:;"..name_filter_blacklist_default.."]" ..
			"field_close_on_enter[group_filter_whitelist;false]" ..
			"field_close_on_enter[mod_filter_whitelist;false]" ..
			"field_close_on_enter[name_filter_whitelist;false]" ..
			"field_close_on_enter[group_filter_blacklist;false]" ..
			"field_close_on_enter[mod_filter_blacklist;false]" ..
			"field_close_on_enter[name_filter_blacklist;false]" ..
			"label[0.24,3.8;Item Filter:]"..
			"label[6.24,3.8;Item Filter:]"..
			"list[detached:"..invname.."_filter;whitelist;1,4.3;4,1;]" ..
			"list[detached:"..invname.."_filter;blacklist;7,4.3;4,1;]" ..
			"listring[detached:"..invname.."_filter;blacklist]" ..
			"listring[current_player;main]" ..
			"listring[current_player;nothing]" ..
			"listring[detached:"..invname.."_filter;whitelist]" ..
			"listring[current_player;main]" ..
			"listring[current_player;nothing]" ..
			"button[0.2,4.3;0.8,1;back_whitelist;<--]" ..
			"button[5,4.3;0.8,1;next_whitelist;-->]" ..
			"button[6.2,4.3;0.8,1;back_blacklist;<--]" ..
			"button[11,4.3;0.8,1;next_blacklist;-->]" ..
			"field[2.2,6.3;6,0;setting;Setting;"..setting_default.."]" ..
			"field_close_on_enter[setting;false]" ..
			"button[8,5.5;2,1;back;Back and Save]" ..
			"list[current_player;main;2,6.85;8,1;]" ..
			"list[current_player;main;2,8.08;8,3;8]" ..
			default.get_hotbar_bg(2,6.85)
		)
	elseif setting_type == "crafting" then
		local craftinv = minetest.create_detached_inventory(invname.."_crafting", {
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				inv:set_stack(to_list, to_index, inv:get_stack(from_list, from_index))
				inv:set_stack(from_list, from_index, "")
				if from_list == "output" then
					inv:set_list("recipe", {})
				end
				set_crafting_output(inv)
				return 0
			end,
			allow_put = function(inv, listname, index, stack, player)
				inv:set_stack(listname, index, stack:get_name())
				set_crafting_output(inv)
				return 0
			end,
			allow_take = function(inv, listname, index, stack, player)
				inv:set_stack(listname, index, "")
				if listname == "output" then
					inv:set_list("recipe", {})
				end
				set_crafting_output(inv)
				return 0
			end,
		}, playername)
		craftinv:set_size("recipe", 3*3)
		craftinv:set_size("output", 1*1)
		local setting_table = minetest.deserialize(setting) or {}
		if setting_table.recipe_counter and setting_table.recipe_items[setting_table.recipe_counter] then
			for i, stack in pairs(setting_table.recipe_items[setting_table.recipe_counter]) do
				craftinv:set_stack("recipe", i, stack)
			end
		end
		set_crafting_output(craftinv)
		minetest.show_formspec(playername, invname.."_crafting",
			"size[8,9]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			default.gui_slots ..
			"field[0.2,4.3;6,0;setting;Setting;"..setting_default.."]" ..
			"field_close_on_enter[setting;false]" ..
			"button[6,3.5;2,1;back;Back and Save]" ..
			"button[0,0;1,4;back_craft;<--]" ..
			"button[7,0;1,4;next_craft;-->]" ..
			"listring[detached:"..invname.."_crafting;recipe]" ..
			"listring[current_player;main]" ..
			"listring[current_player;nothing]" ..
			"listring[detached:"..invname.."_crafting;output]" ..
			"listring[current_player;main]" ..
			"listring[current_player;nothing]" ..
			"image[4.5,1.3;1,1;gui_furnace_arrow_bg.png^[transformR270]" ..
			"list[detached:"..invname.."_crafting;recipe;1.5,0.3;3,3;]" ..
			"list[detached:"..invname.."_crafting;output;5.5,1.3;1,1;]" ..
			"list[current_player;main;0,4.85;8,1;]" ..
			"list[current_player;main;0,6.08;8,3;8]" ..
			default.get_hotbar_bg(0,4.85)
		)
	end
end

local function save_filter_formspec(fields, setting_table, player, finv, extra_table)
	extra_table = extra_table or {}
	
	setting_table.group_filter_whitelist = fields.group_filter_whitelist or ""
	setting_table.mod_filter_whitelist = fields.mod_filter_whitelist or ""
	setting_table.name_filter_whitelist = fields.name_filter_whitelist or ""
	setting_table.group_filter_blacklist = fields.group_filter_blacklist or ""
	setting_table.mod_filter_blacklist = fields.mod_filter_blacklist or ""
	setting_table.name_filter_blacklist = fields.name_filter_blacklist or ""

	local wcc = extra_table.whitelist_counter_change or 0
	local bcc = extra_table.blacklist_counter_change or 0
	for i = 1, finv:get_size("whitelist"), 1 do
		local stack_name = finv:get_stack("whitelist", i):get_name() 
		if stack_name ~= "" then
			setting_table.whitelist_items[i+setting_table.whitelist_counter-1-wcc] = stack_name
		else
			setting_table.whitelist_items[i+setting_table.whitelist_counter-1-wcc] = nil
		end
	end
	for i = 1, finv:get_size("blacklist"), 1 do
		local stack_name = finv:get_stack("blacklist", i):get_name()
		if stack_name ~= "" then
			setting_table.blacklist_items[i+setting_table.blacklist_counter-1-bcc] = stack_name
		else
			setting_table.blacklist_items[i+setting_table.blacklist_counter-1-bcc] = nil
		end
	end
	player:set_attribute("inventorybags_setting_default", minetest.serialize(setting_table))
end

local function save_crafting_formspec(fields, setting_table, player, craftinv, extra_table)
	extra_table = extra_table or {}
	local rcc = extra_table.recipe_counter_change or 0
	local tableindex = setting_table.recipe_counter-rcc
	if not setting_table.recipe_items[tableindex] then
		setting_table.recipe_items[tableindex] = {}
	end
	for i = 1, craftinv:get_size("recipe"), 1 do
		local stack_name = craftinv:get_stack("recipe", i):get_name()
		if stack_name ~= "" then
			setting_table.recipe_items[tableindex][i] = stack_name
		else
			setting_table.recipe_items[tableindex][i] = nil
		end
	end
	player:set_attribute("inventorybags_setting_default", minetest.serialize(setting_table))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local playername = player:get_player_name()
	local inv = player:get_inventory()
	
	local spininvname = "inventorybags_"..playername.."_spinning_wheel"
	local loominvname = "inventorybags_"..playername.."_loom"
	local budinvname = "inventorybags_"..playername.."_bud"
	if formname == spininvname then
		if fields.spin then
			minetest.sound_play("inventorybags_spinning_wheel", {gain = 0.8, object = player, max_hear_distance = 5})
			while minetest.get_item_group(inv:get_stack(spininvname.."_in", 1):get_name(), "wool") > 0 and 
					inv:room_for_item(spininvname.."_out", "inventorybags:yarn") do
				inv:remove_item(spininvname.."_in", inv:get_stack(spininvname.."_in", 1):get_name())
				inv:add_item(spininvname.."_out", "inventorybags:yarn")
			end
		end
		if fields.quit then
			drop_inv(inv, player, spininvname.."_in")
			drop_inv(inv, player, spininvname.."_out")
		end
	elseif formname == loominvname then
		if fields.weave then
			minetest.sound_play("inventorybags_loom", {gain = 0.5, object = player, max_hear_distance = 5})
			while inv:get_stack(loominvname.."_in", 1):get_name() == "inventorybags:yarn" and 
					inv:get_stack(loominvname.."_in", 2):get_name() == "inventorybags:yarn" and
					inv:room_for_item(loominvname.."_out", "inventorybags:fabric") do
				local stack1 = inv:get_stack(loominvname.."_in", 1)
				local stack2 = inv:get_stack(loominvname.."_in", 2)
				stack1:set_count(stack1:get_count()-1)
				stack2:set_count(stack2:get_count()-1)
				inv:set_stack(loominvname.."_in", 1, stack1)
				inv:set_stack(loominvname.."_in", 2, stack2)
				inv:add_item(loominvname.."_out", "inventorybags:fabric")
			end
		end
		if fields.quit then
			drop_inv(inv, player, loominvname.."_in")
			drop_inv(inv, player, loominvname.."_out")
		end
	elseif formname == budinvname then
		local bagstack = inv:get_stack(budinvname.."_bag", 1)
		local upgradestack = inv:get_stack(budinvname.."_upgrade", 1)
		if fields.setting_creator then
			local bud_recipe = inventorybags.bud_recipes[upgradestack:get_name()]
			if bud_recipe then
				if fields.setting then
					player:set_attribute("inventorybags_setting_default", fields.setting)
				end
				show_setting_creator(player,  bud_recipe.setting_type)
			end
		elseif fields.recover_setting then
			if bagstack ~= nil then
				local meta = bagstack:get_meta()
				local upgrade_history = meta:get_string("inventorybags_upgrade_history")
				local cpos = string.find(upgrade_history, ",")
				if cpos then
					local upgrade_name = string.sub(upgrade_history, 1, cpos-1)
					local bud_recipe = inventorybags.bud_recipes[upgrade_name]
					if bud_recipe and bud_recipe.setting_meta_name then
						player:set_attribute("inventorybags_setting_default", meta:get_string(bud_recipe.setting_meta_name))
						open_bud(player)
					end
				end
			end
		elseif fields.help then
			if fields.setting then
				player:set_attribute("inventorybags_setting_default", fields.setting)
			end
			minetest.show_formspec(playername, formname.."_help",
				"size[10,8]" ..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"textlist[0,0;10,8;helptext;".. inventorybags.upgrade_help_string ..";1;true]"
			)
		elseif fields.upgrade then
			if inv:is_empty(budinvname.."_out") and bagstack ~= nil and upgradestack ~= nil and
					bagstack:get_count() == 1 and
					minetest.get_item_group(bagstack:get_name(), "bag") > 0 and
					minetest.get_item_group(upgradestack:get_name(), "inventorybags_upgrade") > 0 then
				local meta = bagstack:get_meta()
				local bud_recipe = inventorybags.bud_recipes[upgradestack:get_name()]
				if bud_recipe and meta:get_string(bud_recipe.meta_name) ~= bud_recipe.meta_string then
					meta:set_string(bud_recipe.meta_name, bud_recipe.meta_string)
					meta:set_string("inventorybags_upgrade_history", upgradestack:get_name()..","..meta:get_string("inventorybags_upgrade_history"))
					if bud_recipe.setting_meta_name then
						meta:set_string(bud_recipe.setting_meta_name, fields.setting)
					end
					minetest.sound_play("inventorybags_bud_upgrade", {gain = 0.8, object = player, max_hear_distance = 5})
					upgradestack:set_count(upgradestack:get_count()-1)
					inv:set_stack(budinvname.."_bag", 1, "")
					inv:set_stack(budinvname.."_upgrade", 1, upgradestack)
					inv:set_stack(budinvname.."_out", 1, bagstack)
				end
			end
		elseif fields.extract then
			if inv:is_empty(budinvname.."_out") and 
					bagstack ~= nil and
					minetest.get_item_group(bagstack:get_name(), "bag") > 0	and 
					bagstack:get_count() == 1 then
				local meta = bagstack:get_meta()
				local upgrade_history = meta:get_string("inventorybags_upgrade_history")
				local cpos = string.find(upgrade_history, ",")
				if cpos then
					local upgrade_name = string.sub(upgrade_history, 1, cpos-1)
					local bud_recipe = inventorybags.bud_recipes[upgrade_name]
					if bud_recipe and inv:room_for_item(budinvname.."_upgrade", upgrade_name) then
						meta:set_string("inventorybags_upgrade_history", string.sub(upgrade_history, cpos+1))
						meta:set_string(bud_recipe.meta_name, "")
						if bud_recipe.setting_meta_name then
							meta:set_string(bud_recipe.setting_meta_name, "")
						end
						minetest.sound_play("inventorybags_bud_extract", {gain = 0.8, object = player, max_hear_distance = 5})
						inv:add_item(budinvname.."_upgrade", upgrade_name)
						inv:set_stack(budinvname.."_bag", 1, "")
						inv:set_stack(budinvname.."_out", 1, bagstack)
					end
				end
			end
		end
		if fields.quit then
			player:set_attribute("inventorybags_setting_default", "")
			drop_inv(inv, player, budinvname.."_bag")
			drop_inv(inv, player, budinvname.."_upgrade")
			drop_inv(inv, player, budinvname.."_out")
		end
	elseif formname == budinvname.."_help" then
		if fields.quit then
			minetest.after(0.1, open_bud, player)
		end
	elseif formname == budinvname.."_setting_creator_color" then
		if fields.color_list then
			local fieldstable = minetest.explode_textlist_event(fields.color_list)
			if fieldstable.type == "CHG" then
				if fieldstable.index ~= 1 then
					player:set_attribute("inventorybags_setting_default", inventorybags.named_colors[fieldstable.index-1].name)
					local r, g, b = hex_to_rbg(inventorybags.named_colors[fieldstable.index-1].color)
					show_setting_creator(player, "color", {color_index = fieldstable.index, red = r, green = g,
						blue = b, preview = inventorybags.named_colors[fieldstable.index-1].name})
				end
			end
		elseif fields.set_color then
			local r, g, b = tonumber(fields.red) or 0, tonumber(fields.green) or 0, tonumber(fields.blue) or 0
			if r > 255 then r = 255 end
			if g > 255 then g = 255 end
			if b > 255 then b = 255 end
			local colorhex = rbg_to_hex(r, g, b)
			if colorhex then
				player:set_attribute("inventorybags_setting_default", colorhex)
				show_setting_creator(player, "color", {red = r, green = g, blue = b, alpha = a, preview = colorhex})
			end
		elseif fields.random_color then
			local r, g, b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
			local colorhex = rbg_to_hex(r, g, b)
			player:set_attribute("inventorybags_setting_default", colorhex)
			show_setting_creator(player, "color", {red = r, green = g, blue = b, alpha = 255, preview = colorhex})
		elseif fields.back then
			if fields.setting then
				player:set_attribute("inventorybags_setting_default", fields.setting)
			end
			open_bud(player)
		end
		if fields.quit then
			minetest.after(0.1, open_bud, player)
		end
	elseif formname == budinvname.."_setting_creator_filter" then
		local finv = minetest.get_inventory({type="detached", name=budinvname.."_setting_creator_filter"})
		local setting_table = {}
		if fields.setting then 
			setting_table = minetest.deserialize(fields.setting) or {}
		end
		setting_table.whitelist_counter = setting_table.whitelist_counter or 1
		setting_table.blacklist_counter = setting_table.blacklist_counter or 1
		setting_table.blacklist_items = setting_table.blacklist_items or {}
		setting_table.whitelist_items = setting_table.whitelist_items or {}
		
		if fields.back_whitelist then
			if setting_table.whitelist_counter > 1 then
				setting_table.whitelist_counter = setting_table.whitelist_counter-1
				save_filter_formspec(fields, setting_table, player, finv, {whitelist_counter_change = -1})
			else
				save_filter_formspec(fields, setting_table, player, finv)
			end
			show_setting_creator(player, "filter", {})
		elseif fields.next_whitelist then
			setting_table.whitelist_counter = setting_table.whitelist_counter+1
			save_filter_formspec(fields, setting_table, player, finv, {whitelist_counter_change = 1})
			show_setting_creator(player, "filter", {})
		elseif fields.back_blacklist then
			if setting_table.blacklist_counter > 1 then
				setting_table.blacklist_counter = setting_table.blacklist_counter-1
				save_filter_formspec(fields, setting_table, player, finv, {blacklist_counter_change = -1})
			else
				save_filter_formspec(fields, setting_table, player, finv)
			end
			show_setting_creator(player, "filter", {})
		elseif fields.next_blacklist then
			setting_table.blacklist_counter = setting_table.blacklist_counter+1
			save_filter_formspec(fields, setting_table, player, finv, {blacklist_counter_change = 1})
			show_setting_creator(player, "filter", {})
		elseif fields.back then
			save_filter_formspec(fields, setting_table, player, finv)
			open_bud(player)
		end
		if fields.quit then
			minetest.after(0.1, open_bud, player)
		end
	elseif formname == budinvname.."_setting_creator_crafting" then
		local craftinv = minetest.get_inventory({type="detached", name=budinvname.."_setting_creator_crafting"})
		local setting_table = {}
		if fields.setting then 
			setting_table = minetest.deserialize(fields.setting) or {}
		end
		setting_table.recipe_counter = setting_table.recipe_counter or 1
		setting_table.recipe_items = setting_table.recipe_items or {}
		if fields.back_craft then
			if setting_table.recipe_counter > 1 then
				setting_table.recipe_counter = setting_table.recipe_counter-1
				save_crafting_formspec(fields, setting_table, player, craftinv, {recipe_counter_change = -1})
			else
				save_crafting_formspec(fields, setting_table, player, craftinv)
			end
			show_setting_creator(player, "crafting", {})
		elseif fields.next_craft then
			setting_table.recipe_counter = setting_table.recipe_counter+1
			save_crafting_formspec(fields, setting_table, player, craftinv, {recipe_counter_change = 1})
			show_setting_creator(player, "crafting", {})
		elseif fields.back then
			if fields.setting then
				player:set_attribute("inventorybags_setting_default", fields.setting)
				save_crafting_formspec(fields, setting_table, player, craftinv)
			end
			open_bud(player)
		end
		if fields.quit then
			minetest.after(0.1, open_bud, player)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	local playername = player:get_player_name()
	local spininvname = "inventorybags_"..playername.."_spinning_wheel"
	local loominvname = "inventorybags_"..playername.."_loom"
	local budinvname = "inventorybags_"..playername.."_bud"
	drop_inv(inv, player, spininvname.."_in")
	drop_inv(inv, player, spininvname.."_out")
	drop_inv(inv, player, loominvname.."_in")
	drop_inv(inv, player, loominvname.."_out")
	drop_inv(inv, player, budinvname.."_bag")
	drop_inv(inv, player, budinvname.."_upgrade")
	drop_inv(inv, player, budinvname.."_out")
end)
