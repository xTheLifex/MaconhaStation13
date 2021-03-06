// ##################################################################################
// 							  BRAZILIAN DRINKS VENDOR
// ##################################################################################

/obj/machinery/vending/brazilie
	name = "Brazilie"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/guarana = 30,
					/obj/item/reagent_containers/food/drinks/soda_cans/stalker = 12,
					/obj/item/reagent_containers/food/drinks/corote = 15,
					/obj/item/reagent_containers/food/drinks/corote/uva = 15)

	contraband = list(/obj/item/reagent_containers/food/drinks/soda_cans/guarana = 30,
					/obj/item/reagent_containers/food/drinks/soda_cans/stalker = 12,
					/obj/item/reagent_containers/food/drinks/corote = 15,
					/obj/item/reagent_containers/food/drinks/corote/uva = 15,
					/obj/item/reagent_containers/food/snacks/trakinas = 20)

	premium = list(/obj/item/reagent_containers/glass/bottle/ethanol = 4)

	product_slogans = "Naquela tardezinha sem o que fazer, vem pro bar!; Estamos todos no trabalho. Eis nosso lema; Junte-se ao Clube dos Canalhas!; Direto do bar 'Tô no trabalho'!"
	product_ads = "Ela é amiga da minha mulher...;Mas que nada!;Ela partiu... partiu...;Burguesinha burguesinha burguesinha...;Bolsonaro 3022!;Lula 3022!; Ciro 3022!; Não espere por um plebicito!; Ela te deixou, nós não!; Tô no trabalho!; Pois é.... pois é..."
	refill_canister = /obj/item/vending_refill/boozeomat
	default_price = PRICE_ALMOST_CHEAP
	extra_price = PRICE_EXPENSIVE
	payment_department = ACCOUNT_SRV
	cost_multiplier_per_dept = list(ACCOUNT_SRV = 0)
