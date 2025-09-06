	# // template
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

item=""
itemvalue=0
# print(template)

import csv

def template_fill(item,itemvalue):
    template='	mod_info.add(\n		RecipeBuilder(\n			"'+item+'Sell:MoneyFactory",\n			"Sell '+item+' for Money",\n			0,\n			"MoneyIcon:MoneyFactory"\n		).crafted_in("autoSellPoint:MoneyFactory")\n        .with_input(WeakItemStack("'+item+':VoxelEras", 1))\n		.with_output(WeakItemStack("Money:MoneyFactory", '+str(itemvalue)+'))\n	);'
    return template


with open("items_data.csv","r") as csv_items_data:
    items_data=csv.reader(csv_items_data)
    for row in items_data:
        item=row[0]
        itemvalue=row[1]
        trade_info=template_fill(item,itemvalue)
        print(trade_info)


