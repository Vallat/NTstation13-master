/obj/machinery/microwave
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0
	var/efficiency = 0


// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/machinery/microwave/New()
	create_reagents(100)
	if(!available_recipes)
		available_recipes = new
		for(var/type in (typesof(/datum/recipe) - /datum/recipe))
			available_recipes += new type
		acceptable_items = new
		acceptable_reagents = new
		for(var/datum/recipe/recipe in available_recipes)
			for(var/item in recipe.items)
				acceptable_items |= item
			for(var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if(recipe.items)
				max_n_of_items = max(max_n_of_items, recipe.items.len)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/microwave(null)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 2)
	RefreshParts()

/obj/machinery/microwave/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts)
		E += M.rating
	efficiency = E

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!broken && !dirty && !operating)
		if(default_deconstruction_screwdriver(user, "mw-o", "mw", O))
			return
		if(default_unfasten_wrench(user, O))
			return

	if(exchange_parts(user, O))
		return

	default_deconstruction_crowbar(O)

	if(src.broken > 0)
		if(src.broken == 2 && istype(O, /obj/item/weapon/wirecutters)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"\blue [user] starts to fix part of the [src].", \
				"\blue You start to fix part of [src]." \
			)
			if (do_after(user,20))
				user.visible_message( \
					"\blue [user] fixes part of [src].", \
					"\blue You have fixed part of [src]." \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && istype(O, /obj/item/weapon/weldingtool)) // If it's broken and they're doing the wrench
			user.visible_message( \
				"\blue [user] starts to fix part of [src].", \
				"\blue You start to fix part of [src]." \
			)
			if (do_after(user,20))
				user.visible_message( \
					"\blue [user] fixes [src].", \
					"\blue You have fixed [src]." \
				)
				src.icon_state = "mw"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				src.flags = OPENCONTAINER
				return 0 //to use some fuel
		else
			user << "\red It's broken!"
			return 1
	else if(istype(O, /obj/item/weapon/reagent_containers/spray/))
		var/obj/item/weapon/reagent_containers/spray/clean_spray = O
		if(clean_spray.reagents.has_reagent("cleaner",clean_spray.amount_per_transfer_from_this))
			clean_spray.reagents.remove_reagent("cleaner",clean_spray.amount_per_transfer_from_this,1)
			playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
			user.visible_message( \
				"\blue [user]  has cleaned  [src].", \
				"\blue You have cleaned [src]." \
			)
			src.dirty = 0 // It's clean!
			src.broken = 0 // just to be sure
			src.icon_state = "mw"
			src.flags = OPENCONTAINER
			src.updateUsrDialog()
			return 1 // Disables the after-attack so we don't spray the floor/user.
		else
			user << "\red You need more space cleaner!"
			return 1

	else if(istype(O, /obj/item/weapon/soap/)) // If they're trying to clean it then let them
		user.visible_message( \
			"\blue [user] starts to clean [src].", \
			"\blue You start to clean [src]." \
		)
		if (do_after(user,20))
			user.visible_message( \
				"\blue [user]  has cleaned  [src].", \
				"\blue You have cleaned [src]." \
			)
			src.dirty = 0 // It's clean!
			src.broken = 0 // just to be sure
			src.icon_state = "mw"
			src.flags = OPENCONTAINER
	else if(src.dirty==100) // [src] is all dirty so can't be used!
		user << "\red It's dirty!"
		return 1
	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			user << "\red This [src] is full of ingredients, you cannot put more."
			return 1
		if (istype(O,/obj/item/stack) && O:amount>1)
			new O.type (src)
			O:use(1)
			user.visible_message( \
				"\blue [user] has added one of [O] to \the [src].", \
				"\blue You add one of [O] to \the [src].")
		else
		//	user.unEquip(O)	//This just causes problems so far as I can tell. -Pete
			if(!user.drop_item())
				user << "<span class='notice'>\the [O] is stuck to your hand, you cannot put it in \the [src]</span>"
				return 0
			O.loc = src
			user.visible_message( \
				"\blue [user] has added \the [O] to \the [src].", \
				"\blue You add \the [O] to \the [src].")
	else if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				user << "\red Your [O] contains components unsuitable for cookery."
				return 1
		//G.reagents.trans_to(src,G.amount_per_transfer_from_this)
	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		user << "\red This is ridiculous. You can not fit \the [G.affecting] in this [src]."
		return 1
	else
		user << "\red You have no idea what you can cook with this [O]."
		return 1
	src.updateUsrDialog()

/obj/machinery/microwave/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/microwave/attack_ai(mob/user as mob)
	return 0

/obj/machinery/microwave/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/interact(mob/user as mob) // [src] Menu
	if(panel_open)
		return
	var/dat = "<div class='statusDisplay'>"
	if(src.broken > 0)
		dat += "ERROR: 09734014-A2379-D18746 --Bad memory<BR>Contact your operator or use command line to rebase memory ///git checkout {HEAD} -a commit pull --rebase push {*NEW HEAD*}</div>"    //Thats how all the git fiddling looks to me
	else if(src.operating)
		dat += "Microwaving in progress!<BR>Please wait...!</div>"
	else if(src.dirty==100)
		dat += "ERROR: >> 0 --Responce input zero<BR>Contact your operator of the device manifactor support.</div>"
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in contents)
			var/display_name = O.name
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/donkpocket))
				display_name = "Donk Pockets"
				items_measures[display_name] = "donk pocket"
				items_measures_p[display_name] = "donk pockets"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat"
			items_counts[display_name]++
		for (var/O in items_counts)
			var/N = items_counts[O]
			if (!(O in items_measures))
				dat += "[capitalize(O)]: [N] [lowertext(O)]\s<BR>"
			else
				if (N==1)
					dat += "[capitalize(O)]: [N] [items_measures[O]]<BR>"
				else
					dat += "[capitalize(O)]: [N] [items_measures_p[O]]<BR>"

		for (var/datum/reagent/R in reagents.reagent_list)
			var/display_name = R.name
			if (R.id == "capsaicin")
				display_name = "hot sauce"
			if (R.id == "frostoil")
				display_name = "cold sauce"
			dat += "[display_name]: [R.volume] unit\s<BR>"

		if (items_counts.len==0 && reagents.reagent_list.len==0)
			dat += "[src] is empty.</div>"
		else
			dat = "<h3>Ingredients:</h3>[dat]</div>"
		dat += "<A href='?src=\ref[src];action=cook'>Turn on</A>"
		dat += "<A href='?src=\ref[src];action=dispose'>Eject ingredients</A>"

	var/datum/browser/popup = new(user, "microwave", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return

/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.loc = src.loc
			return
		else if (has_extra_item())
			if (!wzhzhzh(4))
				abort()
				return
			broke()
			cooked = fail()
			cooked.loc = src.loc
			return
		else
			if (!wzhzhzh(10))
				abort()
				return
			stop()
			cooked = fail()
			cooked.loc = src.loc
			return
	else
		var/halftime = round(recipe.time/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.loc = src.loc
			return
		cooked = recipe.make_food(src)
		stop()
		if(cooked)
			cooked.loc = src.loc
		for(var/i=1,i<efficiency,i++)
			cooked = new cooked.type(loc)
		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num)
	for (var/i=1 to seconds)
		if (stat & (NOPOWER|BROKEN))
			return 0
		use_power(500)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if ( \
				!istype(O,/obj/item/weapon/reagent_containers/food) && \
				!istype(O, /obj/item/weapon/grown) \
			)
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_message("\blue [src] turns on.", "\blue You hear a microwave.")
	src.operating = 1
	src.icon_state = "mw1"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/stop()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/dispose()
	for (var/obj/O in contents)
		O.loc = src.loc
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	usr << "\blue You dispose of [src] contents."
	src.updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.visible_message("\red [src] gets covered in muck!")
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	src.flags = null //So you can't add condiments
	src.icon_state = "mwbloody" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/broke()
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	src.icon_state = "mwb" // Make it look all busted up and shit
	src.visible_message("\red [src] breaks!") //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	src.flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/fail()
	var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)
	if(src.operating)
		updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
	updateUsrDialog()
	return


/obj/machinery/microwave/blacksmith_machine
	name = "blacksmith_machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "lol"


/obj/machinery/microwave/blacksmith_machine/New()
	create_reagents(100)
	if(!available_recipes)
		available_recipes = new
		for(var/type in (typesof(/datum/steam) - /datum/steam))
			available_recipes += new type
		acceptable_items = new
		acceptable_reagents = new
		for(var/datum/recipe/recipe in available_recipes)
			for(var/item in recipe.items)
				acceptable_items |= item
			for(var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if(recipe.items)
				max_n_of_items = max(max_n_of_items, recipe.items.len)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/microwave(null)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/stack/cable_coil(null, 2)
	RefreshParts()


/obj/machinery/microwave/blacksmith_machine/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!broken && !dirty && !operating)
		if(default_deconstruction_screwdriver(user, "mw-o", "mw", O))
			return
		if(default_unfasten_wrench(user, O))
			return

	if(exchange_parts(user, O))
		return

	default_deconstruction_crowbar(O)

	if(src.broken > 0)
		if(src.broken == 2 && istype(O, /obj/item/weapon/wirecutters)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"\blue [user] starts to fix part of [src].", \
				"\blue You start to fix part of [src]." \
			)
			if (do_after(user,20))
				user.visible_message( \
					"\blue [user] fixes part of [src].", \
					"\blue You have fixed part of [src]." \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && istype(O, /obj/item/weapon/weldingtool)) // If it's broken and they're doing the wrench
			user.visible_message( \
				"\blue [user] starts to fix part of [src].", \
				"\blue You start to fix part of [src]." \
			)
			if (do_after(user,20))
				user.visible_message( \
					"\blue [user] fixes [src].", \
					"\blue You have fixed [src]." \
				)
				src.icon_state = "mw"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				src.flags = OPENCONTAINER
				return 0 //to use some fuel
		else
			user << "\red It's broken!"
			return 1
	else if(istype(O, /obj/item/weapon/reagent_containers/spray/))
		var/obj/item/weapon/reagent_containers/spray/clean_spray = O
		if(clean_spray.reagents.has_reagent("cleaner",clean_spray.amount_per_transfer_from_this))
			clean_spray.reagents.remove_reagent("cleaner",clean_spray.amount_per_transfer_from_this,1)
			playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
			user.visible_message( \
				"\blue [user]  has cleaned  [src].", \
				"\blue You have cleaned [src]." \
			)
			src.dirty = 0 // It's clean!
			src.broken = 0 // just to be sure
			src.icon_state = "mw"
			src.flags = OPENCONTAINER
			src.updateUsrDialog()
			return 1 // Disables the after-attack so we don't spray the floor/user.
		else
			user << "\red You need more space cleaner!"
			return 1

	else if(istype(O, /obj/item/weapon/soap/)) // If they're trying to clean it then let them
		user.visible_message( \
			"\blue [user] starts to clean [src].", \
			"\blue You start to clean [src]." \
		)
		if (do_after(user,20))
			user.visible_message( \
				"\blue [user]  has cleaned  [src].", \
				"\blue You have cleaned [src]." \
			)
			src.dirty = 0 // It's clean!
			src.broken = 0 // just to be sure
			src.icon_state = "mw"
			src.flags = OPENCONTAINER
	else if(src.dirty==100) // [src] is all dirty so can't be used!
		user << "\red It's dirty!"
		return 1
	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			user << "\red This [src] is full of ingredients, you cannot put more."
			return 1
		if (istype(O,/obj/item))
			new O.type (src)
			O:use(1)
			user.visible_message( \
				"\blue [user] has added one of [O] to \the [src].", \
				"\blue You add one of [O] to \the [src].")
		else
		//	user.unEquip(O)	//This just causes problems so far as I can tell. -Pete
			if(!user.drop_item())
				user << "<span class='notice'>\the [O] is stuck to your hand, you cannot put it in \the [src]</span>"
				return 0
			O.loc = src
			user.visible_message( \
				"\blue [user] has added \the [O] to \the [src].", \
				"\blue You add \the [O] to \the [src].")
	else if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/condiment) \
		)

		//G.reagents.trans_to(src,G.amount_per_transfer_from_this)
	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		user << "\red This is ridiculous. You can not fit \the [G.affecting] in this [src]."
		return 1
//	else
//		user << "\red You have no idea what you can cook with this [O]."
//		return 1
	src.updateUsrDialog()