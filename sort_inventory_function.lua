-- This function ( sort_inventory(inv) ) was taken form the technic_chests mod 
-- https://github.com/minetest-mods/technic/blob/master/technic_chests/register.lua
-- License:
-- Copyright (C) 2012-2014 Maciej Kasatkin (RealBadAngel)
-- Technic chests code is licensed under the GNU LGPLv2+.

function inventorybags.sort_inventory(inv)
	local inlist = inv:get_list("main")
 	local typecnt = {}
 	local typekeys = {}
 	for _, st in ipairs(inlist) do
 		if not st:is_empty() then
 			local n = st:get_name()
 			local w = st:get_wear()
 			local m = st:get_metadata()
 			local k = string.format("%s %05d %s", n, w, m)
 			if not typecnt[k] then
				typecnt[k] = {
					name = n,
					wear = w,
					metadata = m,
					stack_max = st:get_stack_max(),
					count = 0,
				}
				typecnt[k] = {st}
 				table.insert(typekeys, k)
			else
				table.insert(typecnt[k], st)
 			end
			typecnt[k].count = typecnt[k].count + st:get_count()
 		end
 	end
 	table.sort(typekeys)
	local outlist = {}
	inv:set_list("main", {})
 	for _, k in ipairs(typekeys) do
		local tc = typecnt[k]
		while tc.count > 0 do
			local c = math.min(tc.count, tc.stack_max)
			table.insert(outlist, ItemStack({
				name = tc.name,
				wear = tc.wear,
				metadata = tc.metadata,
				count = c,
			}))
			tc.count = tc.count - c
		for _, item in ipairs(typecnt[k]) do
			inv:add_item("main", item)
 		end
 	end
	if #outlist > #inlist then return end
	while #outlist < #inlist do
		table.insert(outlist, ItemStack(nil))
	end
	inv:set_list("main", outlist)
end
