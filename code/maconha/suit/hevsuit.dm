// ##################################################################################
// 									H.E.V SUIT
// ##################################################################################


#define HEV_SUIT_TRAIT "hev-suit"

// ------------------------------------ SUIT ------------------------------------
/obj/item/clothing/suit/armor/hev
	name = "H.E.V. Suit Mark V"
	desc = "A technological advancement in the fields of... everything! May or may not protect you against bullets."
	icon = 'icons/maconha/suit/hevsuit.dmi'
	icon_state = "suit"
	item_state = "suit-icon"
	strip_delay = 50
	body_parts_covered = CHEST|ARMS|LEGS
	armor = list("melee" = 80, "bullet" = 80, "laser" = 80,"energy" = 65, "bomb" = 50, "bio" = 50, "rad" = 100, "fire" = 95, "acid" = 100)
	resistance_flags = LAVA_PROOF | ACID_PROOF
	// Other parts references
	var/obj/item/clothing/head/helmet/hev/h_helmet
	var/obj/item/clothing/shoes/hev/h_shoes
	var/obj/item/clothing/gloves/hev/h_gloves

	var/mob/living/carbon/human/affecting = null
	var/obj/item/stock_parts/cell/cell

/obj/item/clothing/suit/armor/hev/get_cell()
	return cell


/obj/item/clothing/suit/armor/hev/Initialize()
	. = ..()

	cell = new/obj/item/stock_parts/cell/high
	cell.charge = 9000
	cell.name = "black power cell"
	cell.icon_state = "bscell"

/obj/item/clothing/suit/armor/hev/proc/terminate()
	qdel(h_helmet)
	qdel(h_gloves)
	qdel(h_shoes)
	qdel(src)

/obj/item/clothing/suit/armor/hev/proc/lock_suit(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	if(!istype(H.head, /obj/item/clothing/head/helmet/hev))
		to_chat(H, "<span class='userdanger'>ERROR</span>: 100113 UNABLE TO LOCATE HEAD GEAR\nABORTING...")
		return FALSE
	if(!istype(H.shoes, /obj/item/clothing/shoes/hev))
		to_chat(H, "<span class='userdanger'>ERROR</span>: 122011 UNABLE TO LOCATE FOOT GEAR\nABORTING...")
		return FALSE
	if(!istype(H.gloves, /obj/item/clothing/gloves/hev))
		to_chat(H, "<span class='userdanger'>ERROR</span>: 110223 UNABLE TO LOCATE HAND GEAR\nABORTING...")
		return FALSE
	affecting = H
	ADD_TRAIT(src, TRAIT_NODROP, HEV_SUIT_TRAIT)
	slowdown = 0
	h_helmet = H.head
	ADD_TRAIT(h_helmet, TRAIT_NODROP, HEV_SUIT_TRAIT)
	h_shoes = H.shoes
	ADD_TRAIT(h_shoes, TRAIT_NODROP, HEV_SUIT_TRAIT)
	h_shoes.slowdown--
	h_gloves = H.gloves
	ADD_TRAIT(h_gloves, TRAIT_NODROP, HEV_SUIT_TRAIT)
	return TRUE

/obj/item/clothing/suit/armor/hev/proc/unlock_suit()
	affecting = null
	REMOVE_TRAIT(src, TRAIT_NODROP, HEV_SUIT_TRAIT)
	slowdown = 1
	if(h_helmet)//Should be attached, might not be attached.
		REMOVE_TRAIT(h_helmet, TRAIT_NODROP, HEV_SUIT_TRAIT)
	if(h_shoes)
		REMOVE_TRAIT(h_shoes, TRAIT_NODROP, HEV_SUIT_TRAIT)
		h_shoes.slowdown++
	if(h_gloves)
		REMOVE_TRAIT(h_gloves, TRAIT_NODROP, HEV_SUIT_TRAIT)

// ------------------------------------ HELMET ------------------------------------

/obj/item/clothing/head/helmet/hev
	name = "H.E.V Helmet"
	desc = "An HEV Helmet, part of the HEV suit."
	armor = list("melee" = 80, "bullet" = 80, "laser" = 80,"energy" = 65, "bomb" = 50, "bio" = 50, "rad" = 100, "fire" = 95, "acid" = 100)
	icon = 'icons/maconha/suit/hevsuit.dmi'
	icon_state = "helmet"
	item_state = "helmet-icon"
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	strip_delay = 80


// ------------------------------------ SHOES ------------------------------------

/obj/item/clothing/shoes/hev
	name = "HEV Shoes"
	desc = "Part of HEV suit."
	icon_state = "suit"
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 80, "bullet" = 80, "laser" = 80,"energy" = 65, "bomb" = 50, "bio" = 50, "rad" = 100, "fire" = 95, "acid" = 100)
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

// ------------------------------------ GLOVES ------------------------------------
/obj/item/clothing/gloves/hev
	name = "HEV Gloves"
	desc = "These nano-enhanced gloves insulate from electricity and provide fire resistance."
	icon_state = "suit"
	item_state = "suit"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 120
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
