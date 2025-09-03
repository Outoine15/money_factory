fn setup(mod_info){
    import "money_factory/scripts/money" as Money;

    // import "money_factory/scripts/manual_seller" as manualBuyer;
    // import "money_facotry/scripts/manual_buyer" as manualSeller;
 
    Money::define(mod_info);

    // manualBuyer::define(mod_info);
    // manualSeller::define(mod_info);
}