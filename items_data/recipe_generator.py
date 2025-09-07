	# // template sell point
	# mod_info.add(
	# 	RecipeBuilder(
	# 		"<item>Sell:MoneyFactory",
	# 		"Sell <item> for Money",
	# 		0,
	# 		"MoneyIcon:MoneyFactory"
	# 	).crafted_in("autoSellPoint:MoneyFactory")
    #     .with_input(WeakItemStack("<item>:VoxelEras", 1))
	# 	.with_output(WeakItemStack("Money:MoneyFactory", <itemvalue>))
	# );

	# // template store:
	# mod_info.add(
	# 	RecipeBuilder(
	# 		"smolGeneralStore:MoneyFactory",
	# 		"buy <item>", 
	# 		0,
	# 		"<item>Icon:VoxelEras"
	# 	).crafted_in("smolGeneralStore:MoneyFactory")
	# 	.with_input(WeakItemStack("Money:MoneyFactory", <itemvalue>))
	# 	.with_output(WeakItemStack("<item>:VoxelEras", 1))
	# );

item=""
itemvalue=0
# print(template)

import csv

def template_fill_sell_point(item,itemvalue):
    template='	mod_info.add(\n		RecipeBuilder(\n			"'+item+'Sell:MoneyFactory",\n			"Sell '+item+' for Money",\n			0,\n			"MoneyIcon:MoneyFactory"\n		).crafted_in("autoSellPoint:MoneyFactory")\n        .with_input(WeakItemStack("'+item+':VoxelEras", 1))\n		.with_output(WeakItemStack("Money:MoneyFactory", '+str(itemvalue)+'))\n	);\n'
    return template

def template_fill_store(item,itemvalue):
	template='	mod_info.add(\n		RecipeBuilder(\n	"smolGeneralStore:MoneyFactory",\n			"buy '+item+'",\n			0,\n			"'+item+'Icon:VoxelEras"\n		).crafted_in("smolGeneralStore:MoneyFactory")\n		.with_input(WeakItemStack("Money:MoneyFactory", '+str(itemvalue)+'))\n		.with_output(WeakItemStack("'+item+':VoxelEras", 1))\n	);\n'
	return template

with open("items_data.csv","r") as csv_items_data:
	items_data=csv.reader(csv_items_data)
	for row in items_data:
		item=row[0]
		itemvalue=row[1]
		sell_point_info=template_fill_sell_point(item,itemvalue)
		store_info=template_fill_store(item,itemvalue)
		print(sell_point_info)
		print(store_info)


