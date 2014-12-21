/obj/machinery/microscope
	name = "Microscope"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "umm0"
	var/energy = 0
	var/max_energy = 3
	var/list/dispensable_reagents = list()
	var/beaker = null
	var/obj/item/weapon/cell/cell = null
	var/state = 0 // 1 on / 2 off/  3 open off / 4 open on
	var/on = 0
	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	attackby(var/obj/item/weapon/reagent_containers/glass/beaker/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass/beaker))
			return

		if(src.beaker)
			user << "The machine is already loaded!"
			return
		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the [B.name] to the machine!"
//		if(istype(B, /obj/item/weapon/reagent_containers/glass/beaker/petri))
//			user << "\blue The [B.name] falls out of the machine!"
//			B.loc = src.loc
//			beaker = null
//			return
		icon_state = "umm1"

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)

		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return
		usr.machine = src
		if(!beaker) return
		var/datum/reagents/R = beaker:reagents
		if(R.reagent_list.len < 1)
			user << "The dish is empty"
			beaker:loc = src.loc
			beaker = null
			icon_state = "umm0"

		for(var/datum/reagent/G in R.reagent_list)
			if(prob(85))
				user << "\blue Seems to be [G.name]."
				sleep(12)
				beaker:loc = src.loc
				beaker = null
				icon_state = "umm0"
			else
				user << "\red You have failed to identify the chemical."
				sleep(12)
				beaker:loc = src.loc
				beaker = null
				icon_state = "umm0"
