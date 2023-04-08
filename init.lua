local modpath = minetest.get_modpath("inventorybags")

inventorybags = {}
if minetest.get_modpath("mcl_core") then
    inventorybags.game = "mcl"
	inventorybags.gui_bg = mcl_vars.gui_bg_color
	inventorybags.gui_bg_img = mcl_vars.gui_bg_img
	inventorybags.gui_slots = mcl_vars.gui_slots
	inventorybags.get_hotbar_bg = function(x,y)
        return mcl_formspec.get_itemslot_bg(x,y,8,1)
    end
    inventorybags.width = 9
else
    for index, mod in ipairs({"default", "wool", "farming", "stairs", "dye", "bucket"}) do
        if not minetest.get_modpath(mod) then
            error("ERROR: Cannot use inventory bags without either MineClone 2 or the following mods:\n[default, wool, farming, stairs, dye, bucket]"..
            "Mod '"..mod.."' not found.")
        end
    end
    inventorybags.game = "mtg"
	inventorybags.gui_bg = default.gui_bg
	inventorybags.gui_bg_img = default.gui_bg_img
	inventorybags.gui_slots = default.gui_slots
	inventorybags.get_hotbar_bg = default.get_hotbar_bg
    inventorybags.width = 8
end

function inventorybags.inventory_formspec(y)
	local formspec = ""
	if inventorybags.game == "mtg" then
		formspec = "list[current_player;main;0,"..y..";"..inventorybags.width..",1;]" ..
		"list[current_player;main;0,"..(y+1.23)..";"..inventorybags.width..",3;"..inventorybags.width.."]"..
		inventorybags.get_hotbar_bg(0, y)
	else
		formspec = "list[current_player;main;0,"..y..";"..inventorybags.width..",3;"..inventorybags.width.."]"..
		mcl_formspec.get_itemslot_bg(0,y,inventorybags.width,3)..
		"list[current_player;main;0,"..(y+3.23)..";"..inventorybags.width..",1;]"..
		mcl_formspec.get_itemslot_bg(0,y+3.23,inventorybags.width,1)
	end	
	return formspec
end

dofile(modpath .. "/globaltables.lua")
dofile(modpath .. "/craftitems.lua")
dofile(modpath .. "/bags.lua")
dofile(modpath .. "/devices.lua")
dofile(modpath .. "/sort_inventory_function.lua")
dofile(modpath .. "/upgrades.lua")
dofile(modpath .. "/crafting.lua")
