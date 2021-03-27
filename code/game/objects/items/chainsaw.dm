
// CHAINSAW
/obj/item/chainsaw
	name = "chainsaw"
	desc = "A versatile power tool. Useful for limbing trees and delimbing humans."
	icon_state = "chainsaw_off"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 13
	var/force_on = 24
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	custom_materials = list(/datum/material/iron=13000)
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = "swing_hit"
	sharpness = SHARP_EDGED
	actions_types = list(/datum/action/item_action/startchainsaw)
	tool_behaviour = TOOL_SAW
	toolspeed = 0.5
	var/on = FALSE
	var/wielded = FALSE // track wielded status on item

/obj/item/chainsaw/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/chainsaw/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 100, 0, 'sound/weapons/chainsawhit.ogg', TRUE)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	AddElement(/datum/element/update_icon_updates_onmob)

/// triggered on wield of two handed item
/obj/item/chainsaw/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/chainsaw/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE

/obj/item/chainsaw/suicide_act(mob/living/carbon/user)
	if(on)
		user.visible_message("<span class='suicide'>[user] begins to tear [user.p_their()] head off with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
		if(myhead)
			myhead.dismember()
	else
		user.visible_message("<span class='suicide'>[user] smashes [src] into [user.p_their()] neck, destroying [user.p_their()] esophagus! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		playsound(src, 'sound/weapons/genhit1.ogg', 100, 1)
	return(BRUTELOSS)

/obj/item/chainsaw/attack_self(mob/user)
	on = !on
	to_chat(user, "As you pull the starting cord dangling from [src], [on ? "it begins to whirr." : "the chain stops moving."]")
	force = on ? force_on : initial(force)
	throwforce = on ? force_on : force
	update_icon()
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = on

	if(on)
		hitsound = 'sound/weapons/chainsawhit.ogg'
	else
		hitsound = "swing_hit"

/obj/item/chainsaw/update_icon_state()
	icon_state = "chainsaw_[on ? "on" : "off"]"

/obj/item/chainsaw/doomslayer
	name = "THE GREAT COMMUNICATOR"
	desc = "<span class='warning'>VRRRRRRR!!!</span>"
	armour_penetration = 100
	force_on = 30

/obj/item/chainsaw/doomslayer/check_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	block_return[BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE] = 100
	return ..()

/obj/item/chainsaw/doomslayer/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(attack_type & ATTACK_TYPE_PROJECTILE)
		owner.visible_message("<span class='danger'>Ranged attacks just make [owner] angrier!</span>")
		playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
		return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return ..()


/obj/item/chainsaw/doomslayer/cyborg
	name = "High Frequency Energy Chainsaw"
	armour_penetration = 100
	force = 15
	force_on = 35

/obj/item/chainsaw/doomslayer/cyborg/attack_self(mob/user)
	on = !on
	to_chat(user, "You [on ? "engage" : "disengage"] the [src] systems. [on ? "It begins to whirr." : "The chain stops moving."]")
	force = on ? force_on : initial(force)
	throwforce = on ? force_on : force
	update_icon()
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = on

	if(on)
		hitsound = 'sound/weapons/chainsawhit.ogg'
	else
		hitsound = "swing_hit"

/obj/item/chainsaw/doomslayer/cyborg/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	var/turf/closed/wall/W = O
	var/obj/A = O

	if (on)
		if (W && istype(W, /turf/closed/wall))
			to_chat(user, SPAN_NOTICE("You begin slicing through the [W]"))
			do_sparks(rand(1,2), TRUE, W)
			playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
			if (src.use_tool(W, user, 30, volume=100))
				to_chat(user, SPAN_NOTICE("You slice through the [W]"))
				do_sparks(rand(1,2), TRUE, W)
				playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
				W.dismantle_wall()
				return
		else
			if (A && istype(A, /obj))
				to_chat(user, SPAN_NOTICE("You begin slicing the [A]"))
				do_sparks(rand(1,2), TRUE, A)
				playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
				if (src.use_tool(A, user, 30, volume=100))
					to_chat(user, SPAN_NOTICE("You slice the [A]"))
					do_sparks(rand(1,2), TRUE, A)
					playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
					//explosion(A, 1, 0, 1, 1, 0, 0, 0, 0, 0)
					qdel(A)
					return



/obj/item/chainsaw/doomslayer/cyborg/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	. = ..()
	playsound(src, 'sound/weapons/ZapBang.ogg', 55, 1)

/obj/item/chainsaw/doomslayer/cyborg/on_wield(obj/item/source, mob/user)
	return

/obj/item/chainsaw/doomslayer/cyborg/on_unwield(obj/item/source, mob/user)
	return

/obj/item/chainsaw/doomslayer/cyborg/suicide_act(mob/living/carbon/user)
	to_chat(user, SPAN_WARNING("Your systems prevent you from doing that!"))
	return
