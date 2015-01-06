mob/living/carbon/human/proc/overload(usr as mob)
	var/mob/living/carbon/human/OK = usr
	if(weight > 8)
		OK.weakened = 1
		usr << "Ты перегружен"