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

    // mod_info.add(
        // RecipeBuilder(
            // "manualBuyer:MoneyFactory",
            // "Sell resources for Money",
            // 0, //TODO check what theses do 
            // "MoneyIcon:MoneyFactory"
        // ).crafted_in()
    // )
}