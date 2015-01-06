/obj/machinery/mass_driver/portable
	name = "quick way"
	desc = "The finest in spring-loaded piston toy technology, now on a space station near you."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	anchored = 0
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	power = 1
	code = 1
	id = 1

	drive_range = 50

/obj/machinery/mass_driver/portable/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	anchored = 1
	drive()
	anchored = 0