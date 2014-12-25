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