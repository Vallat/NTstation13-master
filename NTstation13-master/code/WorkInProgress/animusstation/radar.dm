/obj/item/weapon/radar
	name = "mind radar"
	icon = 'icons/obj/handradar.dmi'
	icon_state = "handradaroff"
	var/mob/seeker
	var/on = 0

	New()
		..()
		processing_objects.Add(src)

/obj/item/weapon/radar/process()
	if(!on)
		return
	if(!seeker)
		on = !on
		icon_state = "handradaroff"
		return
	ping()

/obj/item/weapon/radar/attack_self(var/mob/user)
	if(!on)
		seeker = user
		turn_on()
	else
		turn_off()
		seeker = null

/obj/item/weapon/radar/proc/ping()
	clear_screen()	//Here's no time for optimization!

	var/turf/T = get_turf(src)
	for(var/mob/living/L in range(T, 16))
		var/xdiff = (L.x - T.x) * 2 - 1
		var/ydiff = (L.y - T.y) * 2 - 1
		var/obj/screen/S = new
		S.name = "ping"
		S.icon = 'icons/misc/radar.dmi'
		if(issilicon(L))
			S.icon_state = "roboblip"
		else
			S.icon_state = "civblip"
		S.screen_loc = "NORTH - 1 : [ydiff], EAST - 1 : [xdiff]"
		seeker.client.screen += S

/obj/item/weapon/radar/proc/turn_on()
	if(!seeker)
		return
	if(!seeker.client)
		return
	if(on)
		return
	on = 1
	icon_state = "handradaron" //CAUSE HARDCODE WORK BETTER @:

	var/obj/screen/S = new
	S.name = "radar"
	S.icon = 'icons/misc/radar.dmi'
	S.icon_state = "radarSW"
	S.screen_loc = "NORTH - 2, EAST - 2"
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'icons/misc/radar.dmi'
	S.icon_state = "radarSE"
	S.screen_loc = "NORTH - 2, EAST - 1"
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'icons/misc/radar.dmi'
	S.icon_state = "radarNW"
	S.screen_loc = "NORTH - 1, EAST - 2"
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'icons/misc/radar.dmi'
	S.icon_state = "radarNE"
	S.screen_loc = "NORTH - 1, EAST - 1"
	S.layer = 20
	seeker.client.screen += S

/obj/item/weapon/radar/proc/turn_off()
	if(!seeker)
		return
	if(!seeker.client)
		return
	on = 0
	icon_state = "handradaroff"

	clear_screen()
	for(var/obj/screen/S in seeker.client.screen)
		if(S.name == "radar")
			seeker.client.screen -= S

/obj/item/weapon/radar/proc/clear_screen()
	if(!seeker || !seeker.client)
		return
	for(var/obj/screen/S in seeker.client.screen)
		if(S.name == "ping")
			seeker.client.screen -= S

/obj/item/weapon/radar/dropped(var/mob/M)
	turn_off()
	seeker = null

