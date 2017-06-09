minetest.register_craftitem("inventorybags:yarn", {
	description = "Yarn",
	inventory_image = "inventorybags_yarn.png",
})

minetest.register_craftitem("inventorybags:fabric", {
	description = "Fabric",
	inventory_image = "inventorybags_fabric.png",
})

minetest.register_craftitem("inventorybags:upgrade_base", {
	description = "Upgrade Base",
	inventory_image = "inventorybags_upgrade_base.png",
	groups = {inventorybags_upgrade = 1}
})

minetest.register_craftitem("inventorybags:item_filter", {
	description = "Item Filter",
	inventory_image = "inventorybags_item_filter.png",
})

minetest.register_craftitem("inventorybags:item_puller", {
	description = "Item Puller",
	inventory_image = "inventorybags_item_puller.png",
})

minetest.register_craftitem("inventorybags:inventory_connecter", {
	description = "Inventory Connecter",
	inventory_image = "inventorybags_inventory_connecter.png",
})
