/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/proc/MakeSlippery(var/wet_setting = 1) // 1 = Water, 2 = Lube
	if(wet >= wet_setting)
		return
	wet = wet_setting
	if(wet_setting == 1)
		if(wet_overlay)
			overlays -= wet_overlay
			wet_overlay = null
		wet_overlay = image('icons/effects/water.dmi', src, "wet_floor_static")
		overlays += wet_overlay

	spawn(rand(790, 820)) // Purely so for visual effect
		if(!istype(src, /turf/simulated)) //Because turfs don't get deleted, they change, adapt, transform, evolve and deform. they are one and they are all.
			return
		if(wet > wet_setting) return
		wet = 0
		if(wet_overlay)
			overlays -= wet_overlay

/turf/simulated/Entered(atom/A, atom/OL)
	var/footstepsound
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return

	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)	return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M

			//clown shoes
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				if(H.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
						playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
					else
						M.footstep++
				else
					playsound(src, "clownstep", 20, 1)

			//shoes
			if(istype(src, /turf/simulated/floor/grass))
				footstepsound = "grassfootsteps"
			else if(istype(src, /turf/simulated/floor/beach/sand ||/turf/simulated/floor/plating/asteroid/airless))
				footstepsound = "sandfootsteps"
			else if(istype(src, /turf/simulated/floor/beach/water))
				footstepsound = "waterfootsteps"
//			else if(istype(src, /turf/simulated/floor/spacedome/concrete))
//				footstepsound = "concretefootsteps"
			else if(istype(src, /turf/simulated/floor/wood))
				footstepsound = "woodfootsteps"
			else if(istype(src, /turf/simulated/floor/carpet))
				footstepsound = "carpetfootsteps"
			else
				footstepsound = "erikafootsteps"


			if(istype(H.shoes, /obj/item/clothing/shoes))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
						playsound(src, footstepsound, 100, 1) // this will get annoying very fast.
					else
						M.footstep++
				else
					playsound(src, footstepsound, 20, 1)

		switch (src.wet)
			if(1) //wet floor
				if(!M.slip(4, 2, null, (NO_SLIP_WHEN_WALKING|STEP)))
					M.inertia_dir = 0
				return

			if(2) //lube
				M.slip(0, 10, null, (STEP|SLIDE|GALOSHES_DONT_HELP))


	..()