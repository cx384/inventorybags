
local function get_formspec(name, width, height)
	local sizewidth = 8
	local txpos = (sizewidth-width)/2
	if width >= 8 then
		sizewidth = width
		txpos = 0
	end
	local bag_formspec =
		"size[".. sizewidth ..",".. height+5 .."]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[detached:"..name..";main;".. txpos ..",0;".. width ..",".. height ..";]"..
		"list[current_player;main;".. (sizewidth-8)/2 ..",".. height+0.85 ..";8,1;]" ..
		"list[current_player;main;".. (sizewidth-8)/2 ..",".. height+2.08 ..";8,3;8]" ..
		"listring[detached:"..name..";main]"..
		"listring[current_player;main]" ..
		default.get_hotbar_bg((sizewidth-8)/2,height+0.85)
	return bag_formspec
end

local function inv_to_table(inv)
	local t = {}
	for listname, list in pairs(inv:get_lists()) do
		local size = inv:get_size(listname)
		if size then
			t[listname] = {}
			for i = 1, size, 1 do
				t[listname][i] = inv:get_stack(listname, i):to_table()
			end
		end
	end
	return t
end

local function table_to_inv(inv, t)
	for listname, list in pairs(t) do
		for i, stack in pairs(list) do
			inv:set_stack(listname, i, stack)
		end
	end
end

-- functions to handle upgrades (can be overridden)

-- called on bag_inv_add_item, bag_inv_remove_item and save_bag_inv_itemstack (called on on_move, on_put and on_take)
function inventorybags.on_change_bag_inv(bagstack, baginv)
	return bagstack, baginv
end

-- called on open bag
function inventorybags.on_open_bag(bagstack, baginv, player)
	return bagstack, baginv, player
end

-- called on close bag
function inventorybags.on_close_bag(player, fields, name, formname, sound)
	return player, fields, name, formname, sound
end

-- called before open bag
function inventorybags.before_open_bag(itemstack, user, width, height, sound)
	return itemstack, user, width, height, sound
end

-- called on use bag
function inventorybags.on_use_bag(itemstack, user, pointed_thing)
	return itemstack, user, pointed_thing
end

-- called on drop bag
function inventorybags.on_drop_bag(itemstack, dropper, pos)
	minetest.item_drop(itemstack, dropper, pos)
	return itemstack, dropper, pos
end


local function save_bag_inv_itemstack(inv, stack)
	stack, inv = inventorybags.on_change_bag_inv(stack, inv)
	local meta = stack:get_meta()
	meta:set_string("inventorybags_inv_content", minetest.serialize(inv_to_table(inv)))
	return stack
end

local function save_bag_inv(inv, player)
	local playerinv = minetest.get_inventory{type="player", name=player:get_player_name()}
	local bag_id = inv:get_location().name
	local listname = "main"
	local size = playerinv:get_size(listname)
	for i = 1, size, 1 do
		local stack = playerinv:get_stack(listname, i)
		local meta = stack:get_meta()
		if meta:get_string("inventorybags_bag_identity") == bag_id then
			stack = save_bag_inv_itemstack(inv, stack)
			playerinv:set_stack(listname, i, stack)
		end
	end
end

local mod_storage = minetest.get_mod_storage()
local function create_invname(itemstack)
	local counter = mod_storage:get_int("counter", value) or 0
	counter = counter + 1
	mod_storage:set_int("counter", counter)
	return itemstack:get_name().."_C_"..counter
end

local function stack_to_player_inv(stack, player)
	local payerinv = player:get_inventory()
	if payerinv:room_for_item("main", stack) then
		payerinv:add_item("main", stack)
	else
		minetest.item_drop(stack, player, player:get_pos())
	end
end

local function open_bag(itemstack, user, width, height, sound)
	itemstack, user, width, height, sound = inventorybags.before_open_bag(itemstack, user, width, height, sound) 
	local allow_bag_input = false
	if minetest.get_item_group(itemstack:get_name(), "bag_bag") > 0 then
		allow_bag_input = true
	end
	local meta = itemstack:get_meta()
	local playername = user:get_player_name()
	local invname = meta:get_string("inventorybags_bag_identity")
	
	-- bag identity
	if invname == "" then
		local item_count = itemstack:get_count()
		if item_count > 1 then
			local newitemstack = itemstack:take_item(item_count-1)
			minetest.after(0.01, stack_to_player_inv, newitemstack, user)
		end
		invname = create_invname(itemstack)
		meta:set_string("inventorybags_bag_identity", invname)
	end
	
	meta:set_int("inventorybags_width", width)
	meta:set_int("inventorybags_height", height)
	
	local inv = minetest.create_detached_inventory(invname, {
		allow_put = function(inv, listname, index, stack, player)
			if allow_bag_input then
				if minetest.get_item_group(stack:get_name(), "bag_bag") > 0 then
					return 0
				end
			else
				if minetest.get_item_group(stack:get_name(), "bag") > 0 then
					return 0
				end
			end
			return stack:get_count()
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			save_bag_inv(inv, player)
		end,
		on_put = function(inv, listname, index, stack, player)
			save_bag_inv(inv, player)
		end,
		on_take = function(inv, listname, index, stack, player)
			-- fix swap bug
			local size = inv:get_size(listname)
			for i = 1, size, 1 do
				local stack = inv:get_stack(listname, i)
				local remove_stack = false
				if allow_bag_input then
					if minetest.get_item_group(stack:get_name(), "bag_bag") > 0 then
						remove_stack = true
					end
				else
					if minetest.get_item_group(stack:get_name(), "bag") > 0 then
						remove_stack = true
					end
				end
				if remove_stack == true then
					inv:set_stack(listname, i, "")
					local playerinv = player:get_inventory()
					if playerinv:room_for_item("main", stack) then
						playerinv:add_item("main", stack)
					else
						minetest.item_drop(save_bag_inv_itemstack(inv, stack), player, player:get_pos())
						minetest.close_formspec(player:get_player_name(), inv:get_location().name)
					end
				end
			end
			save_bag_inv(inv, player)
		end,
	}, playername)
	inv:set_size("main", width*height)
	local invmetastring = meta:get_string("inventorybags_inv_content")
	if invmetastring ~= "" then
		table_to_inv(inv, minetest.deserialize(invmetastring))
		
		itemstack, inv, user = inventorybags.on_open_bag(itemstack, inv, user)
		save_bag_inv_itemstack(inv, itemstack)
	end
	
	if sound then
		minetest.sound_play(sound, {gain = 0.8, object = user, max_hear_distance = 5})
	end
	minetest.show_formspec(playername, invname, get_formspec(invname, width, height))
	return itemstack
end

function inventorybags.bag_inv_add_item(bagstack, itemstack)
	local meta = bagstack:get_meta()
	local invname = meta:get_string("inventorybags_bag_identity")
	if not invname then
		return false
	end
	local inv = minetest.create_detached_inventory(invname, {})
	local width = meta:get_int("inventorybags_width")
	local height = meta:get_int("inventorybags_height")
	inv:set_size("main", width*height)
	local invmetastring = meta:get_string("inventorybags_inv_content")
	if invmetastring ~= "" then
		table_to_inv(inv, minetest.deserialize(invmetastring))
		
		bagstack, inv = inventorybags.on_change_bag_inv(bagstack, inv)
	end
	if inv:room_for_item("main", itemstack) then
		inv:add_item("main", itemstack)
		return save_bag_inv_itemstack(inv, bagstack)
	end
	return false
end

function inventorybags.bag_inv_remove_item(bagstack, itemstack)
	local meta = bagstack:get_meta()
	local invname = meta:get_string("inventorybags_bag_identity")
	if not invname then
		return false
	end
	local inv = minetest.create_detached_inventory(invname, {})
	local width = meta:get_int("inventorybags_width")
	local height = meta:get_int("inventorybags_height")
	inv:set_size("main", width*height)
	local invmetastring = meta:get_string("inventorybags_inv_content")
	if invmetastring ~= "" then
		table_to_inv(inv, minetest.deserialize(invmetastring))
		
		bagstack, inv = inventorybags.on_change_bag_inv(bagstack, inv)
	end
	if inv:contains_item("main", itemstack) then
		inv:remove_item("main", itemstack)
		return save_bag_inv_itemstack(inv, bagstack)
	end
	return false
end

function inventorybags.register_bag(name, bagtable)
	minetest.register_craftitem(name, {
		description = bagtable.description,
		inventory_image = bagtable.inventory_image,
		groups = {bag = 1},
		
		on_secondary_use = function(itemstack, user)
			return open_bag(itemstack, user, bagtable.width, bagtable.height, bagtable.sound_open)
		end,
		on_place = function(itemstack, placer, pointed_thing)
			return open_bag(itemstack, placer, bagtable.width, bagtable.height, bagtable.sound_open)
		end,
		on_use = function(itemstack, user, pointed_thing)
			return inventorybags.on_use_bag(itemstack, user, pointed_thing)
		end,
		on_drop = function(itemstack, dropper, pos)
			return inventorybags.on_drop_bag(itemstack, dropper, pos)
		end
	})
	
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local nisformn = string.find(formname, name.."_C_")
		if nisformn == 1 then
			if fields.quit then
				player, fields, name, formname, sound = inventorybags.on_close_bag(player, fields, name, formname, bagtable.sound_close)
				if bagtable.sound_close then
					minetest.sound_play(sound, {gain = 0.8, object = player, max_hear_distance = 5})
				end
			end
		end
		return
	end)
end

inventorybags.register_bag("inventorybags:tiny_pouch", { 
	description = "Tiny Pouch",
	inventory_image = "inventorybags_tiny_pouch.png",
	width = 1,
	height = 1,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:small_pouch", { 
	description = "Small Pouch",
	inventory_image = "inventorybags_small_pouch.png",
	width = 2,
	height = 2,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:medium_pouch", { 
	description = "Medium Pouch",
	inventory_image = "inventorybags_medium_pouch.png",
	width = 3,
	height = 3,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:large_pouch", { 
	description = "Large Pouch",
	inventory_image = "inventorybags_large_pouch.png",
	width = 4,
	height = 4,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})


inventorybags.register_bag("inventorybags:backpack", { 
	description = "Backpack",
	inventory_image = "inventorybags_backpack.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:suitcase", { 
	description = "Suitcase",
	inventory_image = "inventorybags_suitcase.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_suitcase",
	sound_close = "inventorybags_open_suitcase"
})

inventorybags.register_bag("inventorybags:bag_on_a_stick", { 
	description = "Bag on a Stick",
	inventory_image = "inventorybags_bag_on_a_stick.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:belt_bag", { 
	description = "Belt Bag",
	inventory_image = "inventorybags_belt_bag.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_zipper",
	sound_close = "inventorybags_close_zipper"
})

inventorybags.register_bag("inventorybags:chest_bag", { 
	description = "Chest Bag",
	inventory_image = "inventorybags_chest_bag.png",
	width = 8,
	height = 4,
	sound_open = "default_chest_open",
	sound_close = "default_chest_close"
})

inventorybags.register_bag("inventorybags:hand_bag", { 
	description = "Hand Bag",
	inventory_image = "inventorybags_hand_bag.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:satchel", { 
	description = "Satchel",
	inventory_image = "inventorybags_satchel.png",
	width = 8,
	height = 4,
	sound_open = "inventorybags_open_bag",
	sound_close = "inventorybags_close_bag"
})

inventorybags.register_bag("inventorybags:paper_bag", { 
	description = "Paper Bag",
	inventory_image = "inventorybags_paper_bag.png",
	width = 2,
	height = 3,
	sound_open = "inventorybags_open_plastic_bag",
	sound_close = "inventorybags_close_plastic_bag"
})

if minetest.registered_items["homedecor:plastic_sheeting"] then
	inventorybags.register_bag("inventorybags:plastic_bag", { 
		description = "Plastic Bag",
		inventory_image = "inventorybags_plastic_bag.png",
		width = 2,
		height = 3,
		sound_open = "inventorybags_open_plastic_bag",
		sound_close = "inventorybags_close_plastic_bag"
	})
end

-- special bags

minetest.register_craftitem("inventorybags:bag_transporting_bag", {
	description = "Bag Transporting Bag",
	inventory_image = "inventorybags_bag_transporting_bag.png",
	groups = {bag = 1, bag_bag = 1},
	
	on_secondary_use = function(itemstack, user)
		return open_bag(itemstack, user, 2, 2, "inventorybags_open_bag")
	end,
	on_place = function(itemstack, placer, pointed_thing)
		return open_bag(itemstack, placer, 2, 2, "inventorybags_open_bag")
	end,
	on_use = function(itemstack, user, pointed_thing)
		return inventorybags.on_use_bag(itemstack, user, pointed_thing)
	end,
	on_drop = function(itemstack, dropper, pos)
		return inventorybags.on_drop_bag(itemstack, dropper, pos)
	end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local nisformn = string.find(formname, "inventorybags:bag_transporting_bag_C_")
	if nisformn == 1 then
		if fields.quit then
			player, fields, name, formname, sound = inventorybags.on_close_bag(player, fields, name, formname, "inventorybags_close_bag")
			minetest.sound_play(sound, {gain = 0.8, object = player, max_hear_distance = 5})
		end
	end
	return
end)

if minetest.setting_getbool("inventorybags_enable_item_teleportation_bag") then

	local function open_teleport_bag_inv(itemstack, placer, pointed_thing)
		local location = minetest.deserialize(itemstack:get_meta():get_string("inventorybags_formspec_location"))
		if location then
			minetest.sound_play("inventorybags_open_teleportation_bag", {gain = 0.8, object = placer, max_hear_distance = 5})
			local node = minetest.get_node(location)
			-- load the area
			local vmie, vmae = VoxelManip():read_from_map(location, location)
			if not node then
				minetest.chat_send_player(placer:get_player_name(), "Error: area not loaded")
				return itemstack
			end
			local rkfunction = minetest.registered_nodes[node.name].on_rightclick
			if rkfunction then
				rkfunction(location, node, placer, itemstack, pointed_thing)
			else
				local nodemeta = minetest.get_meta(location)
				local formspec = nodemeta:get_string("formspec")
				if formspec then
					-- set inv locations 
					local textbnc = string.find(formspec, "context;")
					while textbnc and string.sub(formspec, textbnc-5, textbnc-1) == "list[" do
						formspec = string.sub(formspec, 1, textbnc-1).."nodemeta:"..
							location.x..","..location.y..","..location.z..string.sub(formspec, textbnc+7)
						textbnc = string.find(formspec, "context;")
					end
					-- deprecated but still used
					local textbnd = string.find(formspec, "current_name;")
					while textbnd and string.sub(formspec, textbnd-5, textbnd-1) == "list[" do
						formspec = string.sub(formspec, 1, textbnd-1).."nodemeta:"..
							location.x..","..location.y..","..location.z..string.sub(formspec, textbnd+12)
						textbnd = string.find(formspec, "current_name;")
					end
					minetest.show_formspec(placer:get_player_name(), "inventorybags:item_teleportation_bag", formspec)
				end
			end
		end
		return itemstack
	end
	
	minetest.register_craftitem("inventorybags:item_teleportation_bag", {
		description = "Item Teleportation Bag",
		inventory_image = "inventorybags_item_teleportation_bag.png",
		groups = {bag = 1},
		
		on_use = function(itemstack, user, pointed_thing)
			if user:get_player_control().sneak == true then
				if pointed_thing and pointed_thing.type == "node" then
					itemstack:get_meta():set_string("inventorybags_formspec_location", minetest.serialize(pointed_thing.under))
					minetest.chat_send_player(user:get_player_name(), "Item Teleportation Bag target set to: "..
						pointed_thing.under.x..", "..pointed_thing.under.y..", "..pointed_thing.under.z..
						" ("..minetest.get_node(pointed_thing.under).name..")"
					)
				end
			else
				minetest.chat_send_player(user:get_player_name(), "Hold sneak and left click to set the target of your Item Teleportation Bag")
			end
			return itemstack
		end,
		
		on_secondary_use = function(itemstack, user, pointed_thing)
			return open_teleport_bag_inv(itemstack, user, pointed_thing)
		end,
		
		on_place = function(itemstack, placer, pointed_thing)
			return open_teleport_bag_inv(itemstack, placer, pointed_thing)
		end,
	})
	
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local nisformn = string.find(formname, "inventorybags:item_teleportation_bag")
		if nisformn == 1 then
			if fields.quit then
				minetest.sound_play("inventorybags_close_teleportation_bag", {gain = 0.8, object = player, max_hear_distance = 5})
			end
		end
		return
	end)
end

if minetest.get_modpath("xdecor") then
	minetest.register_craftitem("inventorybags:ender_bag", {
		description = "Ender Bag",
		inventory_image = "inventorybags_ender_bag.png",
		groups = {bag = 1},
		
		on_secondary_use = function(itemstack, user)
			minetest.sound_play("inventorybags_open_teleportation_bag", {gain = 0.8, object = user, max_hear_distance = 5})
			minetest.show_formspec(user:get_player_name(), "inventorybags:ender_bag",
				"size[8,9]" ..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;enderchest;0,0.3;8,4;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;enderchest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85)
			)
			return itemstack
		end,
		on_place = function(itemstack, placer, pointed_thing)
			minetest.sound_play("inventorybags_open_teleportation_bag", {gain = 0.8, object = placer, max_hear_distance = 5})
			minetest.show_formspec(placer:get_player_name(), "inventorybags:ender_bag",
				"size[8,9]" ..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;enderchest;0,0.3;8,4;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;enderchest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85)
			)
			return itemstack
		end
	})
	
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local nisformn = string.find(formname, "inventorybags:ender_bag")
		if nisformn == 1 then
			if fields.quit then
				minetest.sound_play("inventorybags_close_teleportation_bag", {gain = 0.8, object = player, max_hear_distance = 5})
			end
		end
		return
	end)
end

if minetest.get_modpath("more_chests") then
	minetest.register_craftitem("inventorybags:wifi_bag", {
		description = "Wifi Bag",
		inventory_image = "inventorybags_wifi_bag.png",
		groups = {bag = 1},
		
		on_secondary_use = function(itemstack, user)
			minetest.sound_play("inventorybags_open_teleportation_bag", {gain = 0.8, object = user, max_hear_distance = 5})
			minetest.show_formspec(user:get_player_name(), "inventorybags:wifi_bag",
				"size[8,9]" ..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;more_chests:wifi;0,0.3;8,4;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;more_chests:wifi]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85)
			)
			return itemstack
		end,
		on_place = function(itemstack, placer, pointed_thing)
			minetest.sound_play("inventorybags_open_teleportation_bag", {gain = 0.8, object = placer, max_hear_distance = 5})
			minetest.show_formspec(placer:get_player_name(), "inventorybags:wifi_bag",
				"size[8,9]" ..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;more_chests:wifi;0,0.3;8,4;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;more_chests:wifi]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85)
			)
			return itemstack
		end
	})
	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local nisformn = string.find(formname, "inventorybags:wifi_bag")
		if nisformn == 1 then
			if fields.quit then
				minetest.sound_play("inventorybags_close_teleportation_bag", {gain = 0.8, object = player, max_hear_distance = 5})
			end
		end
		return
	end)
end

if minetest.get_modpath("beds") then
	minetest.register_craftitem("inventorybags:sleeping_bag", {
		description = "Sleeping Bag",
		inventory_image = "inventorybags_sleeping_bag.png",
		groups = {bag = 1},
		
		on_secondary_use = function(itemstack, user)
			minetest.sound_play("inventorybags_sleeping", {gain = 1, object = user, max_hear_distance = 5})
			beds.on_rightclick(user:get_pos(), user)
		end,
		on_place = function(itemstack, placer, pointed_thing)
			minetest.sound_play("inventorybags_sleeping", {gain = 1, object = placer, max_hear_distance = 5})
			beds.on_rightclick(placer:get_pos(), placer)
		end
	})
end

if not minetest.setting_getbool("inventorybags_dialable_bag_of_winds") then

	local gravity_change = -1.5

	local function set_physics_normal(player)
		local physics = player:get_physics_override()
		physics.gravity = 1
		player:set_physics_override(physics)
	end
	
	local function set_physics_normal_inv_check(player, extratable)
		if player:get_wielded_item():get_name() == "inventorybags:bag_of_winds_opened" then
			minetest.after(1, set_physics_normal_inv_check, player, extratable)
		else
			set_physics_normal(player)
			minetest.sound_stop(extratable.handle)
			local inv = player:get_inventory()
			local lostbag = false
			while inv:contains_item("main", "inventorybags:bag_of_winds_opened") do
				lostbag = true
				local itemstack = inv:remove_item("main", "inventorybags:bag_of_winds_opened")
				itemstack:set_name("inventorybags:bag_of_winds_closed")
				minetest.item_drop(itemstack, player, player:get_pos())
			end
			while inv:contains_item("craft", "inventorybags:bag_of_winds_opened") do
				lostbag = true
				local itemstack = inv:remove_item("craft", "inventorybags:bag_of_winds_opened")
				itemstack:set_name("inventorybags:bag_of_winds_closed")
				minetest.item_drop(itemstack, player, player:get_pos())
			end
			if lostbag then
				minetest.chat_send_player(player:get_player_name(), "You lost your Bag of Winds.")
			end
		end
	end
	
	local function set_new_physics(player, itemstack)
		local physics = player:get_physics_override()
		local extratable = {}
		extratable.handle = minetest.sound_play("inventorybags_wind", {gain = 1, object = player, max_hear_distance = 5, loop = true})
		physics.gravity = 1*gravity_change+physics.gravity
		player:set_physics_override(physics)
		minetest.after(1, set_physics_normal_inv_check, player, extratable)
	end

	local function open_bag_of_winds(player, itemstack)
		local meta = itemstack:get_meta()
		set_new_physics(player, itemstack)
		itemstack:set_name("inventorybags:bag_of_winds_opened")
		return itemstack
	end
	
	local function close_bag_of_winds(player, itemstack)
		set_physics_normal(player)
		itemstack:set_name("inventorybags:bag_of_winds_closed")
		return itemstack
	end
	
	minetest.register_craftitem("inventorybags:bag_of_winds_closed", {
		description = "Bag of Winds",
		inventory_image = "inventorybags_bag_of_winds_closed.png",
		groups = {bag = 1},
		on_secondary_use = function(itemstack, user, pointed_thing)
			itemstack = open_bag_of_winds(user, itemstack)
			return itemstack
		end,
		on_place = function(itemstack, placer, pointed_thing)
			itemstack = open_bag_of_winds(placer, itemstack)
			return itemstack
		end,
	})
	
	minetest.register_craftitem("inventorybags:bag_of_winds_opened", {
		description = "Bag of Winds",
		inventory_image = "inventorybags_bag_of_winds_opened.png",
		groups = {bag = 1, not_in_creative_inventory = 1},
		on_secondary_use = function(itemstack, user, pointed_thing)
			itemstack = close_bag_of_winds(user, itemstack)
			return itemstack
		end,
		on_place = function(itemstack, placer, pointed_thing)
			itemstack = close_bag_of_winds(placer, itemstack)
			return itemstack
		end,
		on_drop = function(itemstack, dropper, pos)
			itemstack:set_name("inventorybags:bag_of_winds_closed")
			minetest.item_drop(itemstack, dropper, pos)
			return itemstack
		end
	})
end


