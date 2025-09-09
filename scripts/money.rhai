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
}