//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "Kitty!!"
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows", "mews")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	species = /mob/living/simple_animal/cat
	childtype = /mob/living/simple_animal/cat/kitten
	meat_type = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

/mob/living/simple_animal/cat/steamcat
	name = "steam_cat"
	desc = "Kitty and steam technology!!"
	icon_state = "cat2_steam"
	icon_living = "cat2_steam"
	icon_dead = "cat2_steam_dead"
	gender = MALE
	speak = list("Meow! pssss... *hoooonk*", "*Bzzzzz-pssssss* MEOW!", "Hello, buddy", "HSSSSS *hooonk*")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows", "mews")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 5
	turns_per_move = 0.0001
	see_in_dark = 6
	species = /mob/living/simple_animal/cat
	childtype = /mob/living/simple_animal/cat/kitten
	meat_type = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/Runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target

/mob/living/simple_animal/cat/Runtime/Life()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat)
					M.splat()
					emote("splats \the [M]")
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	make_babies()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)

/mob/living/simple_animal/cat/Proc
	name = "Proc"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER

/mob/living/simple_animal/cat/say(var/message)

	if (length(message) >= 2)
		if (copytext(message, 1, 3) == ":a")
			message = copytext(message, 3)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
			if (stat == 2)
				return say_dead(message)
			else
				alien_talk(message)
		else
			if (copytext(message, 1, 2) != "*" && !stat)
				playsound(loc, "meaw", 25, 1, 1)//So aliens can hiss while they hiss yo/N
			return ..(message)
