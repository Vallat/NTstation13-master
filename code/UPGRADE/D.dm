/turf/unsimulated/wall/rock/attack_hand(mob/user as mob)
	var/mob/O = usr

	for (var/mob/V in viewers(usr))
		V.show_message("[usr] ������ �� [src].", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		sleep(30)
		O.z += 1
		return

/turf/unsimulated/wall/rock/attack_hand(mob/user as mob)
	var/mob/O = usr

	for (var/mob/V in viewers(usr))
		V.show_message("[usr] ������ �� [src].", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		sleep(30)
		O.z += 1
		return

/turf/unsimulated/wall/rock/ultra
	name = "rock"
	icon_state = "rock_up"

/turf/unsimulated/wall/rock/ultra/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/O = usr

	for (var/mob/V in viewers(usr))
		V.show_message("[usr] ������ �� [src].", 3)
	if(rand(0,160) < O.speak_chance)
		if(do_after(usr, 20))
			O.client.perspective = EYE_PERSPECTIVE
			O.client.eye = src
			O.loc = src
			O.z += 1
			return
	else
		if(do_after(usr, 20))
			if(src.x + 1 == O.x)
				for (var/mob/V in viewers(usr))
					V.show_message("[usr] ������!", 3)
				O.x -= 1
				O.emote("scream")
				O.adjustBruteLoss(rand(0,200))
			if(src.x - 1 == O.x)
				for (var/mob/V in viewers(usr))
					V.show_message("[usr] ������!", 3)
				O.x += 1
				O.emote("scream")
				O.adjustBruteLoss(rand(0,200))
			if(src.y - 1 == O.y)
				for (var/mob/V in viewers(usr))
					V.show_message("[usr] ������!", 3)
				O.y += 1
				O.emote("scream")
				O.adjustBruteLoss(rand(0,200))
			if(src.y + 1 == O.y)
				for (var/mob/V in viewers(usr))
					V.show_message("[usr] ������!", 3)
				O.y -= 1
				O.emote("scream")
				O.adjustBruteLoss(rand(0,200))
			return

/turf/unsimulated/wall/rock
	name = "rock"
	icon_state = "rock_highchance"


/turf/space/k_k
	name = "pit"
	icon = 'icons/turf/pit.dmi'

/turf/space/k_k/rock
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock_super"

/turf/space/k_k/attack_hand(mob/user as mob)
	var/mob/O = usr
	for (var/mob/V in viewers(usr))
		V.show_message("[usr] ��������� ������ ����.", 3)
	if(do_after(usr, 20))
		O.client.perspective = EYE_PERSPECTIVE
		O.client.eye = src
		O.loc = src
		O.z -= 1
		return

mob/
	var/itch = 0
	var/drought = 0

/turf/space/Entered(mob/living/carbon/human/M as mob )
	..()
	M.drought += 1
	if(!M.shoes)
		M.itch += 1
	if(!M.wear_mask)
		if(rand(0,300) < M.speak_chance)
			M << "# ����� ������ �� ������� ��� �����"
		M.drought += 1


/turf/space/k_k/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red �� ����-�� ����"
	M.z -= 1
	M.adjustBruteLoss(60)
	M << "\red ��� ������"
	M.resting = 1

/turf/space/k_K_K

/turf/space/k_K_K/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red �� ������� � ������ ������"
	M.z -= 1
	M.y += 80


/turf/space/k_K_K_back/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red �� ������� � ������ ������"
	M.z += 1
	M.y += 80


/turf/space/k_K_K_UPBACK/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red �� ������� � ������ ������"
	M.z -= 1
	M.y -= 80

/turf/space/k_K_K_back_back/Enter(mob/living/carbon/human/M as mob )
	..()
	M << "\red �� ������� � ������ ������"
	M.z += 1
	M.y -= 80
