fn setup(mod_info){
    // items:
    import "money_factory/scripts/money" as Money;

    // manual blocs:
    import "money_factory/scripts/smolGeneralStore" as smolGeneralStore;

    // automatic blocs:
    import "money_factory/scripts/automatic_selling_point" as autoSellPoint;

    
    // items:
    Money::define(mod_info);

    // blocs:
    smolGeneralStore::define(mod_info);
    autoSellPoint::define(mod_info)
}