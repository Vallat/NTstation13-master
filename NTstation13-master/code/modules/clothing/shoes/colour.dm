/obj/item/clothing/shoes/sneakers

/obj/item/clothing/shoes/sneakers/black
	name = "black shoes"
	icon_state = "black"
	item_color = "black"
	desc = "A pair of classic black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

	redcoat
		item_color = "redcoat"	//Exists for washing machines. Is not different from black shoes in any way.

/obj/item/clothing/shoes/sneakers/brown
	name = "brown shoes"
	desc = "A pair of classy brown shoes."
	icon_state = "brown"
	item_color = "brown"

	captain
		item_color = "captain"	//Exists for washing machines. Is not different from brown shoes in any way.
	hop
		item_color = "hop"		//Exists for washing machines. Is not different from brown shoes in any way.
	ce
		item_color = "chief"		//Exists for washing machines. Is not different from brown shoes in any way.
	rd
		item_color = "director"	//Exists for washing machines. Is not different from brown shoes in any way.
	cmo
		item_color = "medical"	//Exists for washing machines. Is not different from brown shoes in any way.
	cmo
		item_color = "cargo"		//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/sneakers/blue
	name = "blue shoes"
	desc = "A pair of blue shoes."
	icon_state = "blue"
	item_color = "blue"

/obj/item/clothing/shoes/sneakers/green
	name = "green shoes"
	desc = "A pair of green shoes."
	icon_state = "green"
	item_color = "green"

/obj/item/clothing/shoes/sneakers/yellow
	name = "yellow shoes"
	desc = "A pair of yellow shoes."
	icon_state = "yellow"
	item_color = "yellow"

/obj/item/clothing/shoes/sneakers/purple
	name = "purple shoes"
	desc = "A pair of purple shoes."
	icon_state = "purple"
	item_color = "purple"

/obj/item/clothing/shoes/sneakers/brown
	name = "brown shoes"
	icon_state = "brown"
	item_color = "brown"

/obj/item/clothing/shoes/sneakers/red
	name = "red shoes"
	desc = "A pair of red shoes."
	icon_state = "red"
	item_color = "red"

/obj/item/clothing/shoes/sneakers/white
	name = "white shoes"
	desc = "A pair of sterile white shoes."
	icon_state = "white"
	permeability_coefficient = 0.01
	item_color = "white"

/obj/item/clothing/shoes/sneakers/rainbow
	name = "rainbow shoes"
	desc = "Very happy shoes!"
	icon_state = "rain_bow"
	item_color = "rainbow"

/obj/item/clothing/shoes/sneakers/orange
	name = "orange shoes"
	icon_state = "orange"
	item_color = "orange"

/obj/item/clothing/shoes/sneakers/orange/attack_self(mob/user as mob)
	if (src.chained)
		src.chained = null
		src.slowdown = SHOES_SLOWDOWN
		new /obj/item/weapon/handcuffs( user.loc )
		src.icon_state = "orange"
	return

/obj/item/clothing/shoes/sneakers/orange/attackby(H as obj, loc)
	..()
	if ((istype(H, /obj/item/weapon/handcuffs) && !( src.chained )))
		//H = null
		if (src.icon_state != "orange") return
		qdel(H)
		src.chained = 1
		src.slowdown = 15
		src.icon_state = "orange1"
	return

/obj/item/clothing/shoes/sneakers/orange/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/C = user
		if(C.shoes == src && src.chained == 1)
			user << "<span class='notice'>You need help taking these off!</span>"
			return
	..()