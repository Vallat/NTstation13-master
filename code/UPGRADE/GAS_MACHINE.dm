/obj/machinery/microwave/gasmicrowave
	name = "gas-cooker"
	var/active = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/K = 8

/obj/machinery/microwave/gasmicrowave/attack_hand(mob/user as mob)
	if(active == 1)
		user.set_machine(src)
		interact(user)
	if(active == 0)
		return


/obj/machinery/microwave/gasmicrowave/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/tank/plasma))
		qdel(W)
		active = 1
		sleep(300)
		active = 0
		new /obj/item/weapon/tank/plasma/empty(loc)
	if(istype(W, /obj/item/weapon/tank/plasma/empty))
		user << "Эта канистра пуста"
		return


//GUBBUAAAR

/obj/machinery/power/gibber
	name = "gibber_generator"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40
	var/power_gen = 15000
	var/power_output = 2


/obj/machinery/power/gibber/autogibber
	var/turf/input_plate

	New()
		..()
		spawn(5)
			for(var/i in cardinal)
				var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
				if(input_obj)
					if(isturf(input_obj.loc))
						input_plate = input_obj.loc
						qdel(input_obj)
						break

			if(!input_plate)
				diary << "a [src] didn't find an input plate."
				return

	Bumped(var/atom/A)
		if(!input_plate) return

		if(ismob(A))
			var/mob/M = A

			if(M.loc == input_plate
			)
				M.loc = src
				M.gib()


/obj/machinery/power/gibber/New()
	..()
	src.overlays += image('icons/obj/kitchen.dmi', "grjam")

/obj/machinery/power/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		src.overlays += image('icons/obj/kitchen.dmi', "grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/power/gibber/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/power/gibber/container_resist()
	src.go_out()
	return

/obj/machinery/power/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "\red It's locked and running"
		return
	else
		src.startgibbing(user)

/obj/machinery/power/gibber/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if(src.occupant)
		user << "\red The gibber is full, empty it first!"
		return
	if(default_unfasten_wrench(user, G))
		return

	if (!( istype(G, /obj/item/weapon/grab)) || !(istype(G.affecting, /mob/living/carbon/human)))
		user << "\red This item is not suitable for the gibber!"
		return
	if(G.affecting.abiotic(1))
		user << "\red Subject may not have abiotic items on."
		return

	user.visible_message("\red [user] starts to put [G.affecting] into the gibber!")
	src.add_fingerprint(user)
	if(do_after(user, 30) && G && G.affecting && !occupant)
		user.visible_message("\red [user] stuffs [G.affecting] into the gibber!")
		var/mob/M = G.affecting
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		qdel(G)
		update_icon()


/obj/machinery/power/gibber/verb/eject()
	set category = "Object"
	set name = "empty gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/power/gibber/proc/go_out()
	if (!src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	update_icon()
	return

/obj/machinery/power/gibber/initialize()
	..()
	if(anchored == 1)
		connect_to_network()

/obj/machinery/power/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("\red You hear a loud metallic grinding sound.")
		return
	if(anchored && powernet)
		add_avail(power_gen * power_output)
	visible_message("\red You hear a loud squelchy grinding sound.")
	src.operating = 1
	update_icon()
	var/sourcename = src.occupant.real_name
	var/sourcejob = src.occupant.job
	var/sourcenutriment = src.occupant.nutrition / 15
	var/sourcetotalreagents = src.occupant.reagents.total_volume
	var/totalslabs = 3

	var/obj/item/weapon/reagent_containers/food/snacks/meat/human/allmeat[totalslabs]
	for (var/i=1 to totalslabs)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/human/newmeat = new
		newmeat.name = sourcename + newmeat.name
		newmeat.subjectname = sourcename
		newmeat.subjectjob = sourcejob
		newmeat.reagents.add_reagent ("nutriment", sourcenutriment / totalslabs) // Thehehe. Fat guys go first
		src.occupant.reagents.trans_to (newmeat, round (sourcetotalreagents / totalslabs, 1)) // Transfer all the reagents from the
		allmeat[i] = newmeat

	add_logs(user, occupant, "gibbed")
	src.occupant.death(1)
	src.occupant.ghostize()
	qdel(src.occupant)
	spawn(src.gibtime)
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/i=1 to totalslabs)
			var/obj/item/meatslab = allmeat[i]
			var/turf/Tx = locate(src.x - i, src.y, src.z)
			meatslab.loc = src.loc
			meatslab.throw_at(Tx,i,3)
			if (!Tx.density)
				new /obj/effect/decal/cleanable/blood/gibs(Tx,i)
		src.operating = 0
		update_icon()