/obj/machinery/blinds
	name = "Blinds"
	icon = 'rapid_pdoor.dmi'
	icon_state = "blinds0"
	density = 0
	opacity = 0
	var/id = null

/obj/machinery/blinds/proc/close()
	flick("blindsc1", src)
	src.icon_state = "blinds1"
	if (!src.opacity)
		src.opacity = 1
	return

/obj/machinery/blinds/proc/open()
	flick("blindsc0", src)
	src.icon_state = "blinds0"
	sleep(6)
	src.opacity = 0
	return 1
