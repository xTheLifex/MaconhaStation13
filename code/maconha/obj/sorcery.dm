// ##################################################################################
// 							        CHAPLAIN SORCERY
// ##################################################################################

// WORK IN PROGRESS - FILL DESCRIPTION AND DETAILS LATER








// ##################################################################################
// 							        HOLY ALTAR
// ##################################################################################

obj/structure/sorcery_altar
	name = "sorcery altar"
	desc = "An multi purpose altar designed for."
	icon = 'icons/maconha/obj/sorcery.dmi'
	icon_state = "altar-empty"
	var/obj/item/cloth
	var/obj/item/candle
	var/active = FALSE // Altar is currently active
	var/inuse = FALSE // Altar is currenty in-use
	var/linked = FALSE // Linking with chaplain's deity for special powers.
	var/deity = null

obj/structure/sorcery_altar/attackby(obj/item/I, mob/living/user, params)
	var/holy = HAS_TRAIT(user, TRAIT_HOLY)

	if (inuse)
		to_chat(user, "[holy ? SPAN_NOTICE("It's not a good idea to do this while the altar is being used.") : SPAN_NOTICE("You try to put [I] on the altar, but it's repelled with a strong spiritual energy!")]")
		update_icon_state()
		return

	if (istype(I, /obj/item/stack/tile/carpet))
		if (!cloth)
			if (user.transferItemToLoc(I, src))
				cloth = I
				to_chat(user, SPAN_NOTICE("You put the [I] on the altar table."))
		else
			to_chat(user, SPAN_NOTICE("There already is a carpet on the altar table"))
		update_icon_state()
		return


	if (istype(I, /obj/item/candle))
		if (cloth)
			if (!candle)
				if (user.transferItemToLoc(I, src))
					candle = I
					to_chat(user, SPAN_NOTICE("You put the [I] on the altar table."))
			else
				to_chat(user, SPAN_NOTICE("There already is a candle on the table!"))
		else
			to_chat(user, "[holy ? SPAN_NOTICE("You must cover the altar in something first!") : SPAN_NOTICE("Something is missing...")]")
		update_icon_state()
		return

	if (istype(I, /obj/item/storage/book/bible))
		if (cloth && candle)
			// Placing / Using bible
			if (linked)
				if (isLinkedWith(I))
					if (spiritual_energy < 1000)
						if (I.timing_out)
							to_chat(user, "[holy ? SPAN_NOTICE("The holy book is still regaining power") : "You approach the book to the altar, but nothing happens."]")
						else
							to_chat(user, "[holy ? SPAN_NOTICE("You channel energy from the book to the altar") : SPAN_NOTICE("You approach the book to the altar, and you feel a large burst of energy flowing from it.")]"))
							playsound(src, pick('sound/magic/Blind.ogg', 'sound/magic/Charge.ogg', 'sound/magic/powerup.ogg', 'sound/magic/powerdown.ogg'))
							spiritual_energy = 1000
							I.timing_out = TRUE
							spawn(1 MINUTE)
								I.timing_out = FALSE
								playsound(I, 'sound/magic/blink.ogg', 80)
					else
						to_chat(user, "[holy ? SPAN_NOTICE("The altar is already full of energy") : SPAN_NOTICE("You approach the book to the altar, but nothing happens.")]"))
				else
					if (I.deity == deity)
						link_with(I, user)
						to_chat(user, "[holy ? SPAN_NOTICE("The book is now linked to this altar") : SPAN_NOTICE("You approach the book to the altar, but nothing happens.")]"))
					else
						to_chat(user, "[holy ? SPAN_NOTICE("HERESY! HERESY!") : SPAN_NOTICE("You approach the book to the altar, but nothing happens.")]"))
			else
				link_with(I, user)
				to_chat(user, "[holy ? SPAN_NOTICE("The book is now linked to this altar") : SPAN_NOTICE("You approach the book to the altar, but nothing happens.")]"))
		else
			to_chat(user, "[holy ? SPAN_NOTICE("You must place candles first!") : SPAN_NOTICE("Something is missing...")]"))
		update_icon_state()
		return


obj/structure/sorcery_altar/update_icon_state()
	. = ..()
	var/state = initial(icon_state)

	if (cloth)
		state = "altar-cloth"
	if (candle)
		state = "altar-doublecandle"
	if (active)
		state = "altar-power"

	icon_state = state

obj/structure/sorcery_altar/attack_hand(mob/user, act_intent, attackchain_flags)
	. = ..()
	var/holy = HAS_TRAIT(user, TRAIT_HOLY)
	if (!active) // If the altar is not being used
		// Remove candles
		if (candle)
			if (!user.get_active_held_item())
				user.put_in_hands(candle)
				candle = null
				to_chat(user, SPAN_NOTICE("You remove the candle from the altar"))
			return
		// Remove Carpet
		if (cloth)
			if (!user.get_active_held_item())
				user.put_in_hands(cloth)
				cloth = null
				to_chat(user, SPAN_NOTICE("You remove the carpet from the altar table"))
				icon_state = initial(icon_state)
			return
	else
		// Touched the altar while in use... that's not good!
		if (holy)
			to_chat(user, SPAN_WARNING("You cannot modify the altar while it's being used!"))
		else
			if (prob(40))
				to_chat(user, SPAN_WARNING("You touch the altar and uncontrolled spiritual energy flows through your body!"))
				electrocute_mob(user, null, src)

/// Links this altar to a bible
obj/structure/sorcery_altar/proc/link_with(/obj/item/storage/book/bible/B, mob/living/user)
	if (B)
		if (!linked)
			to_chat(user, SPAN_NOTICE("You link the altar to your deity and holy book."))
			linked = TRUE
			deity = B.deity
			B.linked_altar = src
		else
			to_chat(user, SPAN_NOTICE("You link the altar to your holy book."))
			B.linked_altar = src


/// Returns true if this altar is linked to the specified holy book
obj/structure/sorcery_altar/proc/isLinkedWith(/obj/item/storage/book/bible/B)
	if(B)
		if (B.deity == deity)
			if (B.linked_altar == src)
				return TRUE
	return FALSE

/// Returns (string) the energy type of this altar
obj/structure/sorcery_altar/proc/get_energy_type()
	if (linked)
		if (deity == "Hades")
			return "blue"
		if (deity == "Karion")
			return "red"
	return "gray"

// ##################################################################################
// 							        SORCERY FORGE
// ##################################################################################
// Currently just a random ass forge that does nothing but spill out random metal
// from sheets.

obj/structure/sorcery_forge
	name = "sorcery forge"
	desc = "A mystical forge that works on spiritual energy"
	icon = 'icons/maconha/obj/sorcery.dmi'
	icon_state = "forge-off"
	var/linked_altar
	var/linked = FALSE
	var/spiritual_energy = 0 // Max: 1000
	var/crystal_energy = 0 // Max: 50
	var/timing_out = FALSE
	var/min_cost = 125
	var/max_cost = 500

obj/structure/sorcery_forge/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	var/holy = HAS_TRAIT(user, TRAIT_HOLY)

	if (istype(I, /obj/item/storage/book/bible))
		if (!linked)
			if (holy)
				linked_altar = I.linked_altar
				to_chat(user, SPAN_NOTICE("You link the forge to the altar."))
			else
				to_chat(user, SPAN_NOTICE("You touch the forge with the book, but nothing happens."))
		update_icon_state()
		return

	if (istype(I, /obj/item/stack/sheet))
		if (!timing_out && linked)
			var/cost = rand(min_cost, max_cost)
			if (spiritual_energy >= min_cost)
				spiritual_energy - min_cost
				var/obj/item/stack/sheet/S = I
				S.use(1)
				var/result = pick(/obj/item/stack/sheet/plasteel, /obj/item/stack/sheet/plastic, /obj/item/stack/sheet/bluespace_crystal, /obj/item/stack/sheet/bronze, /obj/item/stack/sheet/leather, /obj/item/stack/sheet/metal, /obj/item/stack/sheet/lessergem,
				/obj/item/stack/sheet/pizza, /obj/item/stack/sheet/titaniumglass)
				playsound(src, pick('sound/items/welder.ogg', 'sound/items/Welder2.ogg'), 75, 1)
				timing_out = TRUE
				spawn(10 SECONDS)
					timing_out = FALSE
					new result(src)
			else
				to_chat(user, SPAN_NOTICE("The forge lacks the power to do so!")
		update_icon_state()
		return

obj/structure/sorcery_forge/update_icon_state()
	. = ..()
	var/state = "forge-off"
	if (linked && spiritual_energy >= min_cost)
		state = "forge"
		if (linked_altar)
			var/ET = linked_altar.get_energy_type()
			if (ET != "gray")
				state = "[state]-[ET]"
		else
			linked = FALSE
	icon_state = state


obj/structure/sorcery_forge/proc/consume(amount)
	if (linked)
		if (linked_altar)

