obj/item/weapon/hair_cutter
	name = "hair_cutter"
	icon = 'hair_master.dmi'
	icon_state = "hair_cutter"

obj/item/weapon/face_hair_cutter
	name = "face_hair_cutter"
	icon = 'hair_master.dmi'
	icon_state = "face_hair_cutter"

obj/item/weapon/face_hair_cutter/attack(mob/living/carbon/human/H, mob/user)
	if(ishuman(H))

		var/userloc = H.loc
		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.facial_hair_style = new_style
				H.update_hair()
		else
			H.facial_hair_style = "Shaved"
			H.update_hair()


obj/item/weapon/hair_cutter/attack(mob/living/carbon/human/H, mob/user)
	if(ishuman(H))

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.hair_style = new_style
				H.update_hair()


