fn setup(mod_info){
    // icons/textures:
    import "money_factory/scripts/icons" as icons;
    import "money_factory/scripts/textures" as textures;

    // trades:
    import "money_factory/scripts/trades" as trades;

    // items:
    import "money_factory/scripts/money" as Money;

    // manual blocs:
    import "money_factory/scripts/smol_general_store" as smolGeneralStore;

    // automatic blocs:
    import "money_factory/scripts/automatic_selling_point" as autoSellPoint;

    // icons/textures:
    icons::define(mod_info);
    textures::define(mod_info)

    // trades:
    trades::define(mod_info);

    // items:
    Money::define(mod_info);

    // blocs:
    smolGeneralStore::define(mod_info);
    autoSellPoint::define(mod_info)
}