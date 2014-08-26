/mob/living/simple_animal/hostile/dalek
	name = "bronze dalek"
	desc = "Within the programme narrative, Daleks are an extraterrestrial race of cyborgs created by the scientist Davros during the final years of a thousand-year war against the Thals."
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 500
	health = 500


	ranged = 1
	minimum_distance = 5
	icon_state = "bronze"
	icon_dead = "bronze"
	speak_chance = 20
	turns_per_move = 5
	speed = 2
	projectiletype = /obj/item/projectile/beam/xray/dalek

	//Daleks aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "kick"

	factions = list("dalek")

/mob/living/simple_animal/hostile/dalek/FindTarget()
	. = ..()
	if(.)
		speak = list("Exterminate!","EXTERMINATE!","EX-TER-MINATE!")
		playsound(src.loc, 'sound/voice/exterm.ogg', 100, 1)

/mob/living/simple_animal/hostile/dalek/gold
	name = "gold dalek"
	icon_state = "gold"
	icon_dead = "gold"
/mob/living/simple_animal/hostile/dalek/black
	name = "black dalek"
	icon_state = "black"
	icon_dead = "black"
/mob/living/simple_animal/hostile/dalek/red
	name = "red dalek"
	icon_state = "red"
	icon_dead = "red"