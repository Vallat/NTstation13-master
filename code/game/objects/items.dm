

mob
	var //variables!
		obj/item //typecasting the variable!
		money = 10000
		limit = 10
		weight = 0
	Stat()
		statpanel("Pack") // naming the statpanel
		//stat("Money",money) // showing money value
		//stat("Weight Limit", limit) //shows the Capsule's weight limit
		stat("Weight Used", weight) ///shows the capsule's used weight
		//stat("--Weight--","--Item--") // seperator
		for(var/obj/A in contents)
			stat("[A.weight]",A)



			//the user's inventory
	//	if(captarget&&(captarget in src)) //used for checking if the capsule, to open the tab.
	//		statpanel("Capsule")
	//		stat(captarget) //shows the capsule
	//		stat("Weight Limit", captarget.limit) //shows the Capsule's weight limit
	//		stat("Weight Used", captarget.weight) ///shows the capsule's used weight
	//		stat("--Weight--","--Contained Item--") // seperator
	//		for(var/obj/x in captarget) //shows the contents of the capsule
	//			stat("[x.weight]",x) // here too

obj
	var/weight = 1 //we define the weight var! bigger items should get a higher weight, see below
//	MouseDrop(turf/loca) // used for removing the item from the capsule
		//if((loca in view(4))&&!(loca in usr)&&(isturf(loca))//&(src in usr.captarget)) // checking to see if the item is in the contents of the capsule, and if the location is within range
		//	src.loc = loca // setting the location
			//usr.captarget.weight -= src.weight // subtracting the weight
		//	view() << "[usr] threw a capsule at the ground, releasing the [src]." // text output
	MouseDown() //setting the mouse icon while dragging.
		if(istype(src,/obj/item)&&(src in usr)) src.mouse_drag_pointer = src //setting the capsule as mouse's icon while dragging
		//else if(src in usr.captarget) src.mouse_drag_pointer = src // setting the item in capsule while being dragged out
		else src.mouse_drag_pointer = null
	Item
		verb
			Get() // used to pick up the item
				set src in oview(1)
				if((src.weight + usr.weight) <= usr.limit)
					src.Move(usr) //pickin it up!
					usr << "You picked up \a [src]"
					usr.weight += src.weight

				else usr << "This object is too heavy, try dropping some others before picking this one up!!"
			Drop() //used to put the item down
				set src in usr
				src.Move(usr.loc) //puttin it down!
				usr << "You've dropped \a [src]"
				usr.weight -= src.weight

		/*	MouseDrop(obj/A) //here's where we drag the capsule over to another item, and drop it there. that's how we get the item in the capsule.
				if(istype(A,/obj)&&src!=A&&(A in view(4))&&(src in usr)) // some checks which should be obvious
					if((src.weight+A.weight) <= src.limit) // more checks, to see if the limit is not gone over
						if(!istype(A,/obj/item)) //checking to see if the capsule...is not being put in another capsule!
							if(ismob(A))
								var/mob/X = A.loc
								X.weight =- A.weight
							A.Move(src) //setting the location of the capsule
							src.weight+=A.weight //setting the new weight of the capsule
							view() << "[usr] throws \a [src] at [A], succesfully containing it.." // text output
						else
							usr << "Immpossible Action!" //if the capsule is put into another capsule, this is outputted.
							return
					else usr << "This capsule is full, upgrade it further to allow more items to be keep within it." // says the capsule is not big enough
			verb/Upgrade(Z as num) //verb to upgrade capsule limit
				set desc="Upgrade the Capsule's capacity by using your Zennie (100 monies = 1 limit)"
				if(Z <= usr.money) // checking to see if you have enough money
					var/upgrade=(Z/100) //cince one-hundred monies = 1+ weight increase, we do this, divide the amount of money put in, by 100.
					usr << "You upgrade the capsule's Capacity by [upgrade]."
					src.limit+=upgrade //we upgrade it!
					usr.money -= Z // we take away your money!
	// random items!

*/

/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	var/item_state = null
	var/item_state_icon = null
	var/hitsound = null
	var/throwhitsound = null
	var/w_class = 3.0
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	pass_flags = PASSTABLE
	pressure_resistance = 5
	var/obj/item/master = null

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	//If this is set, The item will make an action button on the player's HUD when picked up.
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/item_color = null
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
	var/reflect_chance = 0 //This var dictates what % of a time an object will reflect an energy based weapon's shot

/obj/item/device
	icon = 'icons/obj/device.dmi'

/obj/item/Destroy()
	if(ismob(loc))
		var/mob/m = loc
		m.unEquip(src, 1)
	return ..()

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

/obj/item/blob_act()
	qdel(src)

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/obj/item/examine()
	set src in view()

	var/size
	switch(src.w_class)
		if(1.0)
			size = "tiny"
		if(2.0)
			size = "small"
		if(3.0)
			size = "normal-sized"
		if(4.0)
			size = "bulky"
		if(5.0)
			size = "huge"
		if(6.0)
			size = "gigantic"
		else
	//if ((CLUMSY in usr.mutations) && prob(50)) t = "funny-looking"

	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src]"
	if(src.blood_DNA)
		f_name = "a bloody [name]"

	var/determiner
	var/pronoun
	if(src.gender == PLURAL)
		determiner = "These are"
		pronoun = "They are"
	else
		determiner = "This is"
		pronoun = "It is"

	usr << "\icon[src][determiner] [f_name]. [pronoun] a [size] item." //e.g. These are some gloves. They are a small item. or This is a toolbox. It is a bulky item.

	if(src.desc)
		usr << src.desc
	return

/obj/item/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		//If the item is in a storage item, take it out
		var/obj/item/weapon/storage/S = src.loc
		S.remove_from_storage(src)

	src.throwing = 0
	if (loc == user)
		if(!user.unEquip(src))
			return
	else
		if(isliving(loc))
			return
	pickup(user)
	add_fingerprint(user)
	user.put_in_active_hand(src)
	return


/obj/item/attack_paw(mob/user as mob)

	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		if(!user.unEquip(src))
			return
	else
		if(istype(src.loc, /mob/living))
			return
		src.pickup(user)

	user.put_in_active_hand(src)
	return


/obj/item/attack_alien(mob/user as mob)
	var/mob/living/carbon/alien/A = user

	if(!A.has_fine_manipulation || w_class >= 4)
		if(src in A.contents) // To stop Aliens having items stuck in their pockets
			A.unEquip(src)
		user << "Your claws aren't capable of such fine manipulation."
		return
	attack_paw(A)

/obj/item/attack_ai(mob/user as mob)
	if (istype(src.loc, /obj/item/weapon/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user)) return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect multiple items on a tile and we clicked on a valid one.
				if(isturf(src.loc))
					var/list/rejections = list()
					var/success = 0
					var/failure = 0

					for(var/obj/item/I in src.loc)
						if(S.collection_mode == 2 && !istype(I,src.type)) // We're only picking up items of the target type
							failure = 1
							continue
						if(I.type in rejections) // To limit bag spamming: any given type only complains once
							continue
						if(!S.can_be_inserted(I))	// Note can_be_inserted still makes noise when the answer is no
							rejections += I.type	// therefore full bags are still a little spammy
							failure = 1
							continue

						success = 1
						S.handle_item_insertion(I, 1)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
					if(success && !failure)
						user << "<span class='notice'>You put everything in [S].</span>"
					else if(success)
						user << "<span class='notice'>You put some things in [S].</span>"
					else
						user << "<span class='notice'>You fail to pick anything up with [S].</span>"

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src)

	return

// afterattack() and attack() prototypes moved to _onclick/item_attack.dm for consistency

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/dropped(mob/user as mob)
	..()

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/weapon/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/weapon/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(mob/user, slot)
	return

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(!M)
		return 0

	return M.can_equip(src, slot, disable_warning)


/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return

	if(ishuman(usr) || ismonkey(usr))
		if(usr.get_active_hand() == null)
			usr.UnarmedAttack(src) // Let me know if this has any problems -Giacom | Actually let me know now.  -Sayu
		/*
		if(usr.get_active_hand() == null)
			src.attack_hand(usr)
		else
			usr << "\red You already have something in your hand."
		*/
	else
		usr << "<span class='notice'>This mob type can't use this verb.</span>"

//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'action_button_name'.
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	if(src in usr)
		attack_self(usr)


/obj/item/proc/IsShield()
	return 0

/obj/item/proc/IsReflect(var/def_zone) //This proc determines if and at what% an object will reflect energy projectiles if it's in l_hand,r_hand or wear_suit
	if(prob(reflect_chance))
		return 1

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H) && ( \
			(H.head && H.head.flags & HEADCOVERSEYES) || \
			(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
			(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove that mask/helmet/glasses first."
		return

	var/mob/living/carbon/monkey/Mo = M
	if(istype(Mo) && ( \
			(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove that mask/helmet/glasses first."
		return

	if(istype(M, /mob/living/carbon/alien) || istype(M, /mob/living/carbon/slime))//Aliens don't have eyes./N     slimes also don't have eyes!
		user << "\red You cannot locate any eyes on this creature!"
		return

	add_logs(user, M, "attacked", object="[src.name]", addition="(INTENT: [uppertext(user.a_intent)])")

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/
	if(M != user)
		for(var/mob/O in (viewers(M) - user - M))
			O.show_message("\red [M] has been stabbed in the eye with [src] by [user].", 1)
		M << "\red [user] stabs you in the eye with [src]!"
		user << "\red You stab [M] in the eye with [src]!"
	else
		user.visible_message( \
			"\red [user] has stabbed themself with [src]!", \
			"\red You stab yourself in the eyes with [src]!" \
		)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/U = M
		var/obj/item/organ/limb/affecting = U.get_organ("head")
		if(affecting.take_damage(7))
			U.update_damage_overlays(0)

	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	M.eye_stat += rand(2,4)
	if (M.eye_stat >= 10)
		M.eye_blurry += 15+(0.1*M.eye_blurry)
		M.disabilities |= NEARSIGHTED
		if(M.stat != 2)
			M << "\red Your eyes start to bleed profusely!"
		if(prob(50))
			if(M.stat != 2)
				M << "\red You drop what you're holding and clutch at your eyes!"
				M.drop_item()
			M.eye_blurry += 10
			M.Paralyse(1)
			M.Weaken(4)
		if (prob(M.eye_stat - 10 + 1))
			if(M.stat != 2)
				M << "\red You go blind!"
			M.sdisabilities |= BLIND
	return


/obj/item/proc/heartstab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	var/random
	if(H != user)
		for(var/mob/O in (viewers(H) - user - H))
			O.show_message("\red � ������ [H] [user] �������� ������� [src].", 1)
		H << "\red [user] �������� ������� � ���� ������ [src]!"
		user << "\red �� ��������� ������� [src] � ������ [H]!"
	if(istype(H, /mob/living/carbon/human))
		random = pick(1,0,0,0,0)
		if(random == 1)
			H.adjustOxyLoss(60)
			H.failed_last_breath = 1
		if(random == 0)
			return


/obj/item/clean_blood()
	. = ..()
	if(.)
		if(initial(icon) && initial(icon_state))
			var/index = blood_splatter_index()
			var/icon/blood_splatter_icon = blood_splatter_icons[index]
			if(blood_splatter_icon)
				overlays -= blood_splatter_icon


var/list/onmob_icons = list(
	"r_hand" = 'icons/mob/items_righthand.dmi',
	"l_hand" = 'icons/mob/items_lefthand.dmi',
	"back" = 'icons/mob/back.dmi',
	"mask" = 'icons/mob/mask.dmi',
	"suit" = 'icons/mob/suit.dmi',
	"belt" = 'icons/mob/belt.dmi',
	"head" = 'icons/mob/head.dmi',
	"s_store" = 'icons/mob/belt_mirror.dmi',
	"shoes" = 'icons/mob/feet.dmi',
	"ears" = 'icons/mob/ears.dmi',
	"eyes" = 'icons/mob/eyes.dmi',
	"hands" = 'icons/mob/hands.dmi',
	"uniform" = 'icons/mob/uniform.dmi')

/obj/item/proc/get_onmob_icon(var/icon_name, var/layer = 0)
	var/icon = onmob_icons[icon_name]
	var/t_state = icon_state
	var/image/overlay

	if((icon_name in list("r_hand", "l_hand", "belt", "s_store", "hands")) && item_state)
		t_state = item_state

	if(icon_name == "uniform")
		if(item_color)
			t_state = item_color
		if(!item_state_icon)
			t_state += "_s"

	if(item_state_icon)
		icon = item_state_icon
		t_state += "_" + icon_name

	if(layer)
		overlay = image(icon = icon, icon_state = t_state, layer = layer)
	else
		overlay = image(icon = icon, icon_state = t_state)

	overlay.color = color
	overlay.alpha = alpha

	return overlay