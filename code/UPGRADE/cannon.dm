obj/machinery/power/emitter/cannon
	icon_state = "cannon"
	name = "cannon"
	var/bullet = 0
	var/fired = 0


obj/machinery/power/emitter/cannon/process()
	if(bullet == 0 & fired == 0)
		src.active = 0
	if(bullet == 1 & fired == 1)
		src.active = 1
		src.powered = 1

	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))
		src.last_shot = world.time
		if(src.shot_number < 3)
			src.fire_delay = 2
			src.shot_number ++
		else
			src.fire_delay = rand(20,100)
			src.shot_number = 0
		var/obj/item/projectile/meteor/A = new /obj/item/projectile/meteor( src.loc )
		playsound(src.loc, 'sound/weapons/Magnum.ogg', 25, 1)
		if(prob(35))
			var/datum/effect/effect/system/harmless_smoke_spread/s = new /datum/effect/effect/system/harmless_smoke_spread
			s.set_up(5, 1, src)
			s.start()
		A.dir = src.dir
		switch(dir)
			if(NORTH)
				A.yo = 20
				A.xo = 0
			if(EAST)
				A.yo = 0
				A.xo = 20
			if(WEST)
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
		A.process()	//TODO: C
		bullet = 0
		fired = 0

obj/machinery/power/emitter/cannon/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/weldingtool))
		fired = 1

	else if(istype(W, /obj/item/weapon/lighter/zippo))
		fired = 1

	else if(istype(W, /obj/item/weapon/lighter))
		fired = 1

	else if(istype(W, /obj/item/weapon/match))
		fired = 1

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		fired = 1

	else if(istype(W, /obj/item/device/assembly/igniter))
		fired = 1


	else if(istype(W, /obj/item/clothing/mask/cigarette))
		fired = 1



	else if(istype(W, /obj/item/candle))
		fired = 1

	else if(istype(W, /obj/item/weapon/cannon_bullet))
		bullet = 1
		qdel(W)
	return





/obj/item/weapon/cannon_bullet
	name = "cannon_bullet"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "bullet"

/obj/item/weapon/cannon_bullet/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/weapon/weldingtool))
		explosion(src.loc,-1,0,2, flame_range = 2)
		if(src)
			qdel(src)

		return

/obj/item/weapon/cannon_bullet/bullet_act()
	explosion(src.loc,-1,0,2, flame_range = 2)
	if(src)
		qdel(src)
