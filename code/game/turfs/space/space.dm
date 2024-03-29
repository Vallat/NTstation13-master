/turf/space
	icon = 'icons/turf/space.dmi'
	name = "sand"
	icon_state = "1"
	temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 6
	thermal_conductivity = 0.040
	heat_capacity = 10000
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD



turf/space/New()
	if(!istype(src, /turf/space/transit))
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/*
/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return
	..()
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

	if(ticker && ticker.mode)

		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(ticker.mode.name == "nuclear emergency")	return
		if(A.z > 6) return
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
			if(istype(A, /obj/effect/meteor))
				qdel(A)
				return

			var/mob/living/MM = null
			if(isliving(A))
				MM = A

			//Check for nuke disk
			var/nukedisk = A.CheckForNukeDisk()
			if(nukedisk)
				if(MM)
					if(MM.client && !MM.stat)
						MM << "<span class='warning'>Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is.</span>"
						if(MM.x <= TRANSITIONEDGE)
							MM.inertia_dir = 4
						else if(MM.x >= world.maxx -TRANSITIONEDGE)
							MM.inertia_dir = 8
						else if(MM.y <= TRANSITIONEDGE)
							MM.inertia_dir = 1
						else if(MM.y >= world.maxy -TRANSITIONEDGE)
							MM.inertia_dir = 2
					else
						qdel(nukedisk)//Make the disk respawn if it is on a clientless mob or corpse
				else
					qdel(nukedisk)//Make the disk respawn if it is floating on its own
				return

			var/move_to_z = src.z
			var/safety = 1
			var/obj/was_pulling = null

			//Check if it's a mob pulling an object. Have the object transition with the mob if it's not the nuke disk
			if(MM && MM.pulling)
				nukedisk = MM.pulling.CheckForNukeDisk()
				if(nukedisk)
					if(nukedisk == MM.pulling)
						MM.pulling = null
					else
						MM << "<span class='warning'>You think you saw something slip out of [MM.pulling], but you couldn't tell where it went...</span>"
					qdel(nukedisk)
				if(MM.pulling)
					was_pulling = MM.pulling //Store the object to transition later

			while(move_to_z == src.z)
				var/move_to_z_str = pickweight(accessable_z_levels)
				move_to_z = text2num(move_to_z_str)
				safety++
				if(safety > 10)
					break

			if(!move_to_z)
				return

			A.z = move_to_z

			if(src.x <= TRANSITIONEDGE)
				A.x = world.maxx - TRANSITIONEDGE - 2
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
				A.x = TRANSITIONEDGE + 1
				A.y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

			else if (src.y <= TRANSITIONEDGE)
				A.y = world.maxy - TRANSITIONEDGE -2
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
				A.y = TRANSITIONEDGE + 1
				A.x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

			spawn (0)
				if(was_pulling && MM) //Carry the object they were pulling with them when they transition
					was_pulling.loc = MM.loc
					MM.pulling = was_pulling
					was_pulling.pulledby = MM
				if ((A && A.loc))
					A.loc.Entered(A)

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/handle_slip()
	return

	*/
/turf/space/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/shovel))
		new /obj/effect/yamaept(src.loc)
		new /obj/item/weapon/ore/glass(src.loc)
		return

/obj/effect/yamaept
	icon = 'icons/effects/effects.dmi'
	icon_state = "yamaept"
	name = "pit"


/obj/effect/yamaept/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/weapon/grab))
		if(get_dist(src, user) < 2)
			var/obj/item/weapon/grab/G = I
			if(G.affecting.buckled)
				user << "<span class='notice'>[G.affecting] �������� � [G.affecting.buckled]!</span>"
				return
			if(G.state < GRAB_AGGRESSIVE)
				user << "<span class='notice'>���� ����� �������� ��� �������!</span>"
				return
			if(!G.confirm())
				return
			G.affecting.loc = src.loc
			G.affecting.Weaken(5)
			new /obj/effect/yamazakopat(src.loc)
			del(src)
			G.affecting.abandon_mob()
			del(G.affecting)
		qdel(I)
		return



/obj/effect/yamazakopat
	icon = 'icons/effects/effects.dmi'
	icon_state = "yamaept2"
	name = "mound"
