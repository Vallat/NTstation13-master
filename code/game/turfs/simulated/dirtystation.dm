//Janitors!  Janitors, janitors, janitors!  -Sayu


//Conspicuously not-recent versions of suspicious cleanables

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = "Looks like it's been here a while.  Eew."
	New()
		..()
		icon_state += "-old"

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Oh god, why didn't anyone clean this up?  It smells terrible."
	New()
		..()
		icon_state += "-old"
		dir = pick(1,2,4,8)

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."
	New()
		..()
		icon_state += "-old"

/obj/effect/decal/cleanable/robot_debris/old
	name = "dusty robot debris"
	desc = "Looks like nobody has touched this in a while."


//Making the station dirty, one tile at a time. Called by master controller's setup_objects

/turf/simulated/floor/proc/MakeDirty()
	if(prob(66))	//fastest possible exit 2/3 of the time
		return

	// These look weird if you make them dirty
	if(istype(src, /turf/simulated/floor/carpet) || istype(src, /turf/simulated/floor/grass) || istype(src, /turf/simulated/floor/beach) || istype(src, /turf/simulated/floor/plating/snow) || istype(src, /turf/simulated/floor/plating/ironsand))
		return

	if(locate(/obj/structure/grille) in contents)
		return

	var/area/A = loc

				//zero dirt

				//high dirt - 1/3
	if(istype(A, /area/mine))
		new /obj/effect/decal/cleanable/dirt(src)	//vanilla, but it works
		return


	if(prob(80))	//mid dirt  - 1/15
		return


	if(istype(A, /area/engine))
	 	//Blood, sweat, and oil.  Oh, and dirt.
		if(prob(3))
			new /obj/effect/decal/cleanable/blood/old(src)
		else
			if(prob(35))
				if(prob(4))
					new /obj/effect/decal/cleanable/robot_debris/old(src)
				else
					new /obj/effect/decal/cleanable/oil(src)
			else
				new /obj/effect/decal/cleanable/dirt(src)
		return