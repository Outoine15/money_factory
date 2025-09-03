fn setup(mod_info){
    import "money_factory/script/manual_seller" as manual_buyer;
    import "money_facotry/script/manual_buyer" as manual_seller;

    manual_buyer::define(mod_info);
    manual_seller::define(mod_info);
}