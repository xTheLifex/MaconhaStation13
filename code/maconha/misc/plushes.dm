// ################################################################################
// 								Generic Definition
// ################################################################################
/obj/item/toy/plush/speaking
	name = "Speaking plushie"
	desc = "It's a speaking plushie!"
	icon = 'icons/maconha/misc/plushes.dmi'
	icon_state = "life"
	item_state = "life"
	attack_verb = list("says")
	gender = MALE
	var/quote_ready = TRUE
	var/usequote = "Bark!"
	var/attackquote = "BARK!"
	var/quote_delay = 10

/obj/item/toy/plush/speaking/proc/ready_quote()
	quote_ready = TRUE

/obj/item/toy/plush/speaking/can_speak()
	return 1

/obj/item/toy/plush/speaking/proc/plush_speak(quote)
	if(quote_ready)
		say(quote)
		quote_ready = FALSE
		addtimer(CALLBACK(src, .proc/ready_quote), quote_delay)

/obj/item/toy/plush/speaking/attack_self(mob/user)
	. = ..()
	if (user)
		plush_speak(usequote)

/obj/item/toy/plush/speaking/attack(mob/living/M, mob/living/user, attackchain_flags, damage_multiplier)
	. = ..()
	if (user)
		plush_speak(attackquote)

// ################################################################################
// 									USER SPECIFIC
// ################################################################################

// ------------------------------- ALIYA WALKER -------------------------------
obj/item/toy/plush/speaking/aliya
	name = "Aliya Walker"
	desc = "It's Aliya Walker!"
	icon_state = "aliya"
	item_state = "aliya"
	usequote = "YAMETE KUDASAI"
	attackquote = "HIYAH!"
	gender = FEMALE

// ------------------------------ KINA COLDPLAY -------------------------------
obj/item/toy/plush/speaking/kina
	name = "Kina Coldplay"
	desc = "It's Kina Coldplay!"
	icon_state = "kina"
	item_state = "kina"
	usequote = "Vrod blyat!"
	attackquote = "Cheeki Breeki iv Damke!"
	gender = FEMALE

// ------------------------------- ENIGMA -------------------------------
obj/item/toy/plush/speaking/enigma
	name = "Enigma"
	desc = "A boy or a girl? HA! GAYY!"
	icon_state = "enigma"
	item_state = "enigma"
	usequote = "Quero café porra!"
	attackquote = "CAFÉEEEE"
	gender = NEUTER

// ------------------------------- LIFE -------------------------------
obj/item/toy/plush/speaking/life
	name = "TheLife"
	desc = "Coding is fun!"
	icon_state = "life"
	item_state = "life"
	usequote = "Bark!"
	attackquote = "BARK BARK!"
	attack_verb = list("barks", "woofs")
	gender = MALE
	squeak_override = list('modular_citadel/sound/voice/bark1.ogg'=1, 'modular_citadel/sound/voice/bark2.ogg'=1)

	var/list/spawns = list(/obj/item/reagent_containers/food/drinks/soda_cans/guarana,
					/obj/item/reagent_containers/food/drinks/soda_cans/stalker,
					/obj/item/reagent_containers/food/drinks/corote,
					/obj/item/reagent_containers/food/drinks/corote/uva,
					/obj/item/card/emag,
					/obj/item/reagent_containers/food/snacks/trakinas,
					/obj/item/gun/ballistic/automatic/pistol)


obj/item/toy/plush/speaking/life/plush_speak(quote)
	. = ..()
	if (prob(5))
		var/item = spawns[rand(1,length(spawns))]
		new item(src.loc)
	else
		if (prob(2))
			explosion(src.loc, 0, 0, 1, 3, 0)


// ------------------------------- SAMARA -------------------------------
obj/item/toy/plush/speaking/samara
	name = "Samara Larionova"
	desc = "Get out of here, stalker!"
	icon_state = "samara"
	item_state = "samara"
	usequote = "Cheeki breeki iv damke!"
	attackquote = "BLYAT PATSANI!"
	gender = FEMALE
	squeak_override = list('sound/weapons/shot.ogg'=1)

// ------------------------------- DRAGUNOV -------------------------------
obj/item/toy/plush/speaking/dragunov
	name = "Shannon Dragunov"
	desc = "Get out of here, stalker!"
	icon_state = "dragunov"
	item_state = "dragunov"
	usequote = "Cheeki breeki iv damke!"
	attackquote = "BLYAT PATSANI!"
	gender = FEMALE

// ------------------------------- SEC FURRY -------------------------------
obj/item/toy/plush/speaking/secfur
	name = "Security Officer"
	desc = "quote_delay-8, standing by."
	icon_state = "secfur"
	item_state = "secfur"
	usequote = "Yes sir!"
	attackquote = "Criminal scum!"
	gender = MALE

obj/item/toy/plush/speaking/secfur/attack_self(mob/user)
	// Overwrite original
	if (user)
		if (user.mind?.assigned_role in GLOB.security_positions)
			plush_speak("Standing by!")
		else if (user.mind?.assigned_role in GLOB.command_positions)
			plush_speak("Sir, yes sir!")
		else
			plush_speak("Criminal scum!")
			to_chat(user, "<span class='warning'>You try to pet the plushie, but recoil as it stuns you instead! OW!</span>")
			playsound(user, 'sound/weapons/genhit.ogg', 50, 1)
			var/mob/living/carbon/human/H = user
			if(!H)
				return //Type safety.
			H.apply_damage(5, BRUTE, pick(BODY_ZONE_CHEST, BODY_ZONE_HEAD))
			addtimer(CALLBACK(H, /mob/living/carbon/human.proc/dropItemToGround, src, TRUE), 1)
