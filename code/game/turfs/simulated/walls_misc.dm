/turf/simulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon_state = "cult"
	walltype = "cult"

/turf/simulated/wall/rust
	name = "rusted wall"
	desc = "A rusted metal wall."
	icon_state = "arust"
	walltype = "arust"
	hardness = 45

/turf/simulated/wall/r_wall/rust
	name = "rusted reinforced wall"
	desc = "A huge chunk of rusted reinforced metal."
	icon_state = "rrust"
	walltype = "rrust"
	hardness = 15

turf/simulated/ladder_wall
	name = "wall and ladder"
	desc = "Ladder to other room."
	icon_state = "ladder_wall"
	icon = 'icons/turf/walls.dmi'
	density = 1
	opacity = 1


turf/simulated/illuminator_wall
	name = "wall"
	desc = "A metal wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "window_wall"
	opacity = 0
	density = 1


/turf/simulated/ladder_wall/attack_hand(mob/user as mob)
	var/mob/O = usr
	for (var/mob/V in viewers(usr))
		V.show_message("[usr] залезает на [src].", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		sleep(30)
		return
