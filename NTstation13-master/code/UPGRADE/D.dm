/turf/unsimulated/wall/rock/attack_hand(mob/user as mob)
	var/mob/O = usr

	for (var/mob/V in viewers(usr))
		V.show_message("[usr] ползет по [src].", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		sleep(30)
		O.z += 1
		return


/turf/unsimulated/wall/rock
	name = "rock"
	icon_state = "rock_highchance"


/turf/space/k_k
	name = "pit"
	icon = 'icons/turf/pit.dmi'

/turf/space/k_k/attack_hand(mob/user as mob)
	var/mob/O = usr
	for (var/mob/V in viewers(usr))
		V.show_message("[usr] аккуратно ползет вниз.", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		O.z -= 1
		return

/turf/space/k_k/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red Ты куда-то упал"
	M.z -= 1
	M.adjustBruteLoss(60)
	M << "\red Это больно"
	M.resting = 1



