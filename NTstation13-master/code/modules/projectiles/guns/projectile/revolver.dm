/obj/item/weapon/gun/projectile/revolver
	desc = "A classic revolver. Uses .357 ammo"
	name = "revolver"
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder

/obj/item/weapon/gun/projectile/revolver/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round(1)
	return

/obj/item/weapon/gun/projectile/revolver/process_chamber()
	return ..(0, 1)

/obj/item/weapon/gun/projectile/revolver/attackby(var/obj/item/A as obj, mob/user as mob)
	var/num_loaded = magazine.attackby(A, user, 1)
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] shell\s into \the [src].</span>"
		A.update_icon()
		update_icon()
		chamber_round()

/*
/obj/item/weapon/gun/projectile/revolver/attack_self(mob/living/user as mob)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src].</span>"
	else
		user << "<span class='notice'>[src] is empty.</span>"

*/

/obj/item/weapon/gun/projectile/revolver/get_ammo(var/countchambered = 0, var/countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/weapon/gun/projectile/revolver/examine()
	..()
	usr << "[get_ammo(0,0)] of those are live rounds."

/obj/item/weapon/gun/projectile/revolver/detective
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-special rounds."
	name = "revolver"
	icon_state = "detective"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38


/obj/item/weapon/gun/projectile/revolver/detective/special_check(var/mob/living/carbon/human/M)
	if(magazine.caliber == initial(magazine.caliber))
		return 1
	if(prob(70 - (magazine.ammo_count() * 10)))	//minimum probability of 10, maximum of 60
		M << "<span class='danger'>[src] blows up in your face!</span>"
		M.take_organ_damage(0,20)
		M.drop_item()
		qdel(src)
		return 0
	return 1

/obj/item/weapon/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun."

	var/mob/M = usr
	var/input = stripped_input(M,"What do you want to name the gun?", ,"", MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/revolver/detective/verb/reskin_gun()
	set name = "Reskin gun"
	set category = "Object"
	set desc = "Click to reskin your gun."

	var/mob/M = usr
	var/list/options = list()
	options["The Original"] = "detective"
	options["Leopard Spots"] = "detective_leopard"
	options["Black Panther"] = "detective_panther"
	options["Gold Trim"] = "detective_gold"
	options["The Peacemaker"] = "detective_peacemaker"
	var/choice = input(M,"What do you want to skin the gun to?","Reskin Gun") in options

	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		M << "Your gun is now skinned as [choice]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/revolver/detective/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/weapon/screwdriver))
		if(magazine.caliber == "38")
			user << "<span class='notice'>You begin to reinforce the barrel of [src].</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//you know the drill
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30))
				if(magazine.ammo_count())
					user << "<span class='notice'>You can't modify it!</span>"
					return
				magazine.caliber = "357"
				desc = "The barrel and chamber assembly seems to have been modified."
				user << "<span class='warning'>You reinforce the barrel of [src]! Now it will fire .357 rounds.</span>"
		else
			user << "<span class='notice'>You begin to revert the modifications to [src].</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//and again
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30))
				if(magazine.ammo_count())
					user << "<span class='notice'>You can't modify it!</span>"
					return
				magazine.caliber = "38"
				desc = initial(desc)
				user << "<span class='warning'>You remove the modifications on [src]! Now it will fire .38 rounds.</span>"




/obj/item/weapon/gun/projectile/revolver/mateba
	name = "mateba"
	desc = "A retro high-powered revolver typically used by officers of the New Russia military. Uses .357 ammo."
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"

// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/weapon/gun/projectile/revolver/russian
	name = "Russian Revolver"
	desc = "A Russian-made revolver. Uses .357 ammo. It has a single slot in its chamber for a bullet."
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = 0

/obj/item/weapon/gun/projectile/revolver/russian/New()
	..()
	Spin()
	update_icon()

/obj/item/weapon/gun/projectile/revolver/russian/proc/Spin()
	chambered = null
	var/random = rand(1, magazine.max_ammo)
	if(random <= get_ammo(0,0))
		chamber_round()
	spun = 1

/obj/item/weapon/gun/projectile/revolver/russian/attackby(var/obj/item/A as obj, mob/user as mob)
	var/num_loaded = ..()
	if(num_loaded)
		user.visible_message("<span class='warning'>[user] loads a single bullet into the revolver and spins the chamber.</span>", "<span class='warning'>You load a single bullet into the chamber and spin it.</span>")
	else
		user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
	if(get_ammo() > 0)
		Spin()
	update_icon()
	A.update_icon()
	return

/obj/item/weapon/gun/projectile/revolver/russian/attack_self(mob/user as mob)
	if(!spun && get_ammo(0,0))
		user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
		Spin()
	else
		var/num_unloaded = 0
		while (get_ammo() > 0)
			var/obj/item/ammo_casing/CB
			CB = magazine.get_round()
			chambered = null
			CB.loc = get_turf(src.loc)
			CB.update_icon()
			num_unloaded++
		if (num_unloaded)
			user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src]!</span>"
		else
			user << "<span class='notice'>[src] is empty.</span>"

/obj/item/weapon/gun/projectile/revolver/russian/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(!spun && get_ammo(0,0))
		user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
		Spin()
	..()
	spun = 0

/obj/item/weapon/gun/projectile/revolver/russian/attack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj)
	if(!spun && get_ammo(0,0))
		user.visible_message("<span class='warning'>[user] spins the chamber of the revolver.</span>", "<span class='warning'>You spin the revolver's chamber.</span>")
		Spin()
		return


	if(target == user)
		if(!chambered)
			user.visible_message("\red *click*", "\red *click*")
			return

		if(isliving(target) && isliving(user))
			var/obj/item/organ/limb/affecting = user.zone_sel.selecting
			if(affecting == "head")
				var/obj/item/ammo_casing/AC = chambered
				if(AC.fire(user, user))
					user.apply_damage(300, BRUTE, affecting)
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[user.name] fires [src] at \his head!</span>", "<span class='danger'>You fire [src] at your head!</span>", "You hear a [istype(AC.BB, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")
					return
				else
					user.visible_message("\red *click*", "\red *click*")
					return
	..()


//fortune!

/obj/item/weapon/gun/projectile/revolver/steam/reaver

	desc = "A reaver"
	name = "reaver"
	icon_state = "revolver_coin"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38


/obj/item/weapon/gun/projectile/revolver/steam/suicide

	desc = "A suicide"
	name = "suicide"
	icon_state = "suicide"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/suicide

/obj/item/weapon/gun/projectile/revolver/steam/striker

	desc = "A striker"
	name = "striker"
	icon_state = "striker"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/striker


/obj/item/weapon/gun/projectile/revolver/twohanded
	var/wielded = 0
	firebale = 0

/obj/item/weapon/gun/projectile/revolver/twohanded/proc/unwield()
	wielded = 0
	name = "[initial(name)]"
	update_icon()

/obj/item/weapon/gun/projectile/revolver/twohanded/proc/wield()
	wielded = 1
	name = "[initial(name)] (Wielded)"
	update_icon()

/obj/item/weapon/gun/projectile/revolver/twohanded/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return	unwield()

/obj/item/weapon/gun/projectile/revolver/twohanded/update_icon()
	return

/obj/item/weapon/gun/projectile/revolver/twohanded/pickup(mob/user)
	unwield()

/obj/item/weapon/gun/projectile/revolver/twohanded/attack_self(mob/user as mob)
	if( istype(user,/mob/living/carbon/monkey) )
		user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
		return

	..()
	if(wielded) //Trying to unwield it
		unwield()
		firebale = 0
		user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"

		var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		return

	else //Trying to wield it
		if(user.get_inactive_hand())
			user << "<span class='warning'>“воя втора€ рука должна быть пустой</span>"
			return
		wield()
		firebale = 1
		user << "<span class='notice'>“ы хватаешь [initial(name)] двумя руками .</span>"

		var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]"
		user.put_in_inactive_hand(O)
		return



/obj/item/weapon/gun/projectile/twohanded/revolver/attack_self(mob/user as mob)
	var/num_unloaded = 0
	if (num_unloaded)
		user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src]!</span>"
	else
		user << "<span class='notice'>[src] is empty.</span>"


//BIG GUN BY DERVEN

/obj/item/weapon/gun/projectile/revolver/twohanded/crusher
	desc = "A big gun, baby"
	name = "crusher"
	icon_state = "crusher"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/crusher

/obj/item/weapon/gun/projectile/revolver/twohanded/sheriff
	desc = "Silverstone 2799"
	name = "sheriff"
	icon_state = "sheriff"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/sheriff

