fn define(mod_info){
    mod_info.add(TextureBuilder(
        "MoneyIcon:MoneyFactory",
        "money_factory/assets/MoneyIcon/MoneyIcon.png"
    ));
    
    mod_info.add(ItemBuilder(
        "Money:MoneyFactory",
        "Money",
        "The first curency. Can be traded for valuables recources.",
        "MoneyIcon:MoneyFactory"
    ));

    // trades:
	mod_info.add(
		RecipeBuilder(
			"OakLogSell:MoneyFactory",
			"Sell OakLog for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("OakLog:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"DirtSell:MoneyFactory",
			"Sell Dirt for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("Dirt:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"CoalSell:MoneyFactory",
			"Sell Coal for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("Coal:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"IronOreSell:MoneyFactory",
			"Sell IronOre for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("IronOre:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"TinOreSell:MoneyFactory",
			"Sell TinOre for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("TinOre:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"CopperOreSell:MoneyFactory",
			"Sell CopperOre for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("CopperOre:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 1))
	);

	mod_info.add(
		RecipeBuilder(
			"CopperIngotSell:MoneyFactory",
			"Sell CopperIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("CopperIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"TinIngotSell:MoneyFactory",
			"Sell TinIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("TinIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"BronzeIngotSell:MoneyFactory",
			"Sell BronzeIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("BronzeIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"PigIronIngotSell:MoneyFactory",
			"Sell PigIronIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("PigIronIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"CoalDustSell:MoneyFactory",
			"Sell CoalDust for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("CoalDust:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"CharcoalSell:MoneyFactory",
			"Sell Charcoal for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("Charcoal:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 2))
	);

	mod_info.add(
		RecipeBuilder(
			"CharcoalDustSell:MoneyFactory",
			"Sell CharcoalDust for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("CharcoalDust:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 3))
	);

	mod_info.add(
		RecipeBuilder(
			"WroughtIronIngotSell:MoneyFactory",
			"Sell WroughtIronIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("WroughtIronIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 3))
	);

	mod_info.add(
		RecipeBuilder(
			"CarbonSteelIngotSell:MoneyFactory",
			"Sell CarbonSteelIngot for Money",
			0,
			"MoneyIcon:MoneyFactory"
		).crafted_in("autoSellPoint:MoneyFactory")
        .with_input(WeakItemStack("CarbonSteelIngot:VoxelEras", 1))
		.with_output(WeakItemStack("Money:MoneyFactory", 3))
	);


//separate
	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreOakLog:MoneyFactory",
			"buy OakLog",
			0,
			"OakLogIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("OakLog:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreDirt:MoneyFactory",
			"buy Dirt",
			1,
			"DirtIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("Dirt:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCoal:MoneyFactory",
			"buy Coal",
			2,
			"CoalIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("Coal:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreIronOre:MoneyFactory",
			"buy IronOre",
			3,
			"IronOreIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("IronOre:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreTinOre:MoneyFactory",
			"buy TinOre",
			4,
			"TinOreIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("TinOre:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCopperOre:MoneyFactory",
			"buy CopperOre",
			5,
			"CopperOreIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 1))
		.with_output(WeakItemStack("CopperOre:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCopperIngot:MoneyFactory",
			"buy CopperIngot",
			6,
			"CopperIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("CopperIngot:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreTinIngot:MoneyFactory",
			"buy TinIngot",
			7,
			"TinIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("TinIngot:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreBronzeIngot:MoneyFactory",
			"buy BronzeIngot",
			8,
			"BronzeIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("BronzeIngot:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStorePigIronIngot:MoneyFactory",
			"buy PigIronIngot",
			9,
			"PigIronIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("PigIronIngot:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCoalDust:MoneyFactory",
			"buy CoalDust",
			10,
			"CoalDustIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("CoalDust:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCharcoal:MoneyFactory",
			"buy Charcoal",
			11,
			"CharcoalIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("Charcoal:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCharcoalDust:MoneyFactory",
			"buy CharcoalDust",
			12,
			"CharcoalDustIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 3))
		.with_output(WeakItemStack("CharcoalDust:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreWroughtIronIngot:MoneyFactory",
			"buy WroughtIronIngot",
			13,
			"WroughtIronIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 3))
		.with_output(WeakItemStack("WroughtIronIngot:VoxelEras", 1))
	);

	mod_info.add(
		RecipeBuilder(
	"smolGeneralStoreCarbonSteelIngot:MoneyFactory",
			"buy CarbonSteelIngot",
			14,
			"CarbonSteelIngotIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 3))
		.with_output(WeakItemStack("CarbonSteelIngot:VoxelEras", 1))
	);
}