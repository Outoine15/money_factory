fn setup(mod_info){
    import "money_factory/script/Money" as Money;

    import "money_factory/script/manual_seller" as manualBuyer;
    import "money_facotry/script/manual_buyer" as manualSeller;

    Money::define(mod_info);

    manualBuyer::define(mod_info);
    manualSeller::define(mod_info);
}