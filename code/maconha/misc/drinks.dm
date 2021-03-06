// ##################################################################################
// 							BRAZILIAN & MISC DRINKS
// ##################################################################################


// ------------------------ Guarana ------------------------
/obj/item/reagent_containers/food/drinks/soda_cans/guarana
	name = "Guaraná"
	desc = "Natural!"
	icon = 'icons/maconha/misc/drinks.dmi'
	icon_state = "guarana"
	list_reagents = list(/datum/reagent/consumable/space_cola = 30)
	foodtype = SUGAR

// ------------------------ Stalker ------------------------
/obj/item/reagent_containers/food/drinks/soda_cans/stalker
	name = "STALKER"
	desc = "Straight out of Chernobyl's Reactor!"
	icon = 'icons/maconha/misc/drinks.dmi'
	icon_state = "stalker"
	list_reagents = list(/datum/reagent/consumable/space_cola = 30)
	foodtype = SUGAR


// ------------------------ Corote ------------------------
/datum/reagent/consumable/ethanol/corote
	name = "Corote"
	description = "Brazilian!"
	color = "#ca9228"
	boozepwr = 50
	taste_description = "molasses"
	glass_icon_state = "whiskeyglass"
	glass_name = "glass of corote"
	glass_desc = "Welcome to Brazil, folks!."
	shot_glass_icon_state = "shotglassgold"
	pH = 5.0

/datum/reagent/consumable/ethanol/corote/uva
	name = "Grape Corote"
	description = "Brazilian!"
	color = "#5d0f6d"
	glass_name = "glass of grape corote"
	shot_glass_icon_state = "shotglassred"

/obj/item/reagent_containers/food/drinks/corote
	name = "Corote"
	desc = "The well known corote."
	icon = 'icons/maconha/misc/drinks.dmi'
	icon_state = "corote"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 10, /datum/reagent/consumable/ethanol/corote = 25, /datum/reagent/consumable/sugar = 5)
	foodtype = GRAIN | ALCOHOL
	custom_price = PRICE_PRETTY_CHEAP

/obj/item/reagent_containers/food/drinks/corote/uva
	name = "Grape Corote"
	desc = "The well known corote. With grape flavor"
	icon = 'icons/maconha/misc/drinks.dmi'
	icon_state = "corote-uva"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 10, /datum/reagent/consumable/ethanol/corote/uva = 25, /datum/reagent/consumable/sugar = 5)

