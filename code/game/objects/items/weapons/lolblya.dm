/obj/item/weapon/tank/air
	force = 5.0
	throwforce = 5.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	m_amt = 700
	g_amt = 50
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/construction_cost = list("metal"=750,"glass"=75)
	var/construction_time=100

/obj/item/weapon/tank/air/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/tank/air/crap
	maxcharge = 500
	g_amt = 40
	//rating = 2

/obj/item/weapon/tank/air/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/tank/air/secborg
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	g_amt = 40
	//rating = 2.5

/obj/item/weapon/tank/air/secborg/empty/New()
	..()
	charge = 0

/obj/item/weapon/tank/air/high
	maxcharge = 10000
	g_amt = 60
	//rating = 3

/obj/item/weapon/tank/air/high/empty/New()
	..()
	charge = 0

/obj/item/weapon/tank/air/super
	maxcharge = 20000
	g_amt = 70
	construction_cost = list("metal"=750,"glass"=100)
	//rating = 4