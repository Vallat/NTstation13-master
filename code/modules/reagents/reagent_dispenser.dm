/obj/effect/effect
	//name = "Dispenser"
	//desc = "..."
	//icon = 'icons/obj/objects.dmi'
	//icon_state = "watertank"
	//density = 1
	//anchored = 0
	//pressure_resistance = 2*ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

/obj/effect/effect/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

/obj/effect/effect/blob_act()
	if(prob(50))
		qdel(src)

//obj/effect/effect/attackby(obj/item/weapon/W as obj, mob/user as mob)
//	return

/obj/effect/effect/New()
	create_reagents(1000)
	if (!possible_transfer_amounts)
		src.verbs -= /obj/effect/effect/verb/set_APTFT
	..()

/obj/effect/effect/examine()
	set src in view()
	..()
	if (!(usr in view(2)) && usr!=src.loc) return
	usr << "\blue It contains:"
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			usr << "\blue [R.volume] units of [R.name]"
	else
		usr << "\blue Nothing."

/obj/effect/effect/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

//Dispensers
/obj/effect/effect/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/effect/effect/watertankA
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/machines/artillery.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",10000)


/obj/effect/effect/watertankB
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "tanker_head"
	density = 1
	anchored = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",100000)


/obj/effect/effect/watertank/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/effect/goodwater(src.loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/effect/goodwater(src.loc)
				qdel(src)
				return
		else
	return

/obj/effect/effect/watertank/blob_act()
	if(prob(50))
		new /obj/effect/effect/water(src.loc)
		qdel(src)

/obj/effect/effect/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	density = 1
	anchored = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("fuel",1000)

/obj/effect/effect/fueltankA
	name = "fueltank"
	desc = "A fueltank"
	icon = 'icons/obj/machines/artillery.dmi'
	icon_state = "weldtank"
	density = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("fuel",10000)


/obj/effect/effect/ntank
	name = "neurotoxintank"
	desc = "A neurotoxin"
	icon = 'icons/obj/objects.dmi'
	icon_state = "ntank"
	density = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("neurotoxin",1000)



/obj/effect/effect/stank
	name = "stimulanttank"
	desc = "A stimulant"
	icon = 'icons/obj/objects.dmi'
	icon_state = "stank"
	density = 1
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("hyperzine", 300)
		reagents.add_reagent("ethylredoxrazine", 300)
		reagents.add_reagent("coffee", 300)

/obj/effect/effect/fueltank/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(istype(Proj ,/obj/item/projectile/beam)||istype(Proj,/obj/item/projectile/bullet))
		message_admins("[key_name_admin(Proj.firer)] triggered a fueltank explosion.")
		log_game("[key_name(Proj.firer)] triggered a fueltank explosion.")
		explosion(src.loc,-1,0,2, flame_range = 2)


/obj/effect/effect/fueltank/blob_act()
	explosion(src.loc,0,1,5,7,10, flame_range = 5)


/obj/effect/effect/fueltank/ex_act()
	explosion(src.loc,-1,0,2, flame_range = 2)
	if(src)
		qdel(src)


/obj/effect/effect/fueltank/fire_act()
	blob_act() //saving a few lines of copypasta


/obj/effect/effect/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	New()
		..()
		reagents.add_reagent("condensedcapsaicin",1000)


/obj/effect/effect/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink"
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	var/cups = 50
	New()
		..()
		reagents.add_reagent("water",500)

/obj/effect/effect/water_cooler/attack_hand(var/mob/living/carbon/human/user)
	if((!istype(user)) || (user.stat))
		return
	if(cups <= 0)
		user << "<span class='danger'>What? No cups?"
		return
	cups--
	user.put_in_hands(new /obj/item/weapon/reagent_containers/food/drinks/sillycup)
	user.visible_message("<span class='notice'>[user] gets a cup from [src].","<span class='notice'>You get a cup from [src].")

/obj/effect/effect/water_cooler/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/paper))
		user.drop_item()
		qdel(I)
		cups++
		return
	else
		..()

/obj/effect/effect/fakedoor
	icon = 'icons/obj/objects.dmi'
	icon_state = "door"

/obj/effect/effect/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	density = 1
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("beer",1000)

/obj/effect/effect/beerkeg/blob_act()
	explosion(src.loc,0,3,5,7,10)


/obj/effect/effect/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1

	New()
		..()
		reagents.add_reagent("virusfood", 1000)