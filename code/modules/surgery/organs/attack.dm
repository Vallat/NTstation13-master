////bay 12 ORGAN SYSTEM
////////////////////////////
////////////////////////////////////////
///////////////////
//////////////

/////////////////
//ORGAN DEFINES//
/////////////////
#define ORGAN_CUT_AWAY 1
#define ORGAN_GAUZED 2
#define ORGAN_ATTACHABLE 4
#define ORGAN_BLEEDING 8
#define ORGAN_BANDAGED 16
#define ORGAN_BROKEN 32
#define ORGAN_DESTROYED 64
#define ORGAN_ROBOT 128
#define ORGAN_SPLINTED 256
#define SALVED 512
/////////////////
//ORGAN DEFINES//
/////////////////

#define CUT 		"cut"
#define BRUISE		"bruise"
#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"tox"
#define OXY			"oxy"
#define CLONE		"clone"
#define HALLOSS		"halloss"

#define HEAD			1
#define UPPER_TORSO		2
#define LOWER_TORSO		4
#define LEG_LEFT		8
#define LEG_RIGHT		16
#define LEGS			24
#define FOOT_LEFT		32
#define FOOT_RIGHT		64
#define FEET			96
#define ARM_LEFT		128
#define ARM_RIGHT		256
#define ARMS			384
#define HAND_LEFT		512
#define HAND_RIGHT		1024
#define HANDS			1536
#define FULL_BODY		2047



///////////////////////////////
//CONTAINS: ORGANS AND WOUNDS//
///////////////////////////////

/datum/organ
	var/name = "organ"
	var/mob/living/carbon/human/owner = null

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
								      // links chemical IDs to number of ticks for which they'll stay in the blood


	proc/process()
		return 0

	proc/receive_chem(chemical as obj)
		return 0

/datum/autopsy_data
	var/weapon = null
	var/pretend_weapon = null
	var/damage = 0
	var/hits = 0
	var/time_inflicted = 0

	proc/copy()
		var/datum/autopsy_data/W = new()
		W.weapon = weapon
		W.pretend_weapon = pretend_weapon
		W.damage = damage
		W.hits = hits
		W.time_inflicted = time_inflicted
		return W

/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = ""

	// amount of damage this wound causes
	var/damage = 0

	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// one of CUT, BRUISE, BURN
	var/damage_type = CUT

	// whether this wound needs a bandage/salve to heal at all
	var/needs_treatment = 0

	// is the wound bandaged?
	var/tmp/bandaged = 0
	// is the wound salved?
	var/tmp/salved = 0
	// is the wound disinfected?
	var/tmp/disinfected = 0
	var/tmp/created = 0

	// number of wounds of this type
	var/tmp/amount = 1

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()
	New(var/damage)

		created = world.time

		// reading from a list("stage" = damage) is pretty difficult, so build two separate
		// lists from them instead
		for(var/V in stages)
			desc_list += V
			damage_list += stages[V]

		src.damage = damage

		// initialize with the first stage
		next_stage()

		// this will ensure the size of the wound matches the damage
		src.heal_damage(0)

	// returns 1 if there's a next stage, 0 otherwise
	proc/next_stage()
		if(current_stage + 1 > src.desc_list.len)
			return 0

		current_stage++

		src.min_damage = damage_list[current_stage]
		src.desc = desc_list[current_stage]
		return 1

	// returns 1 if the wound has started healing
	proc/started_healing()
		return (current_stage > 1)

	// checks whether the wound has been appropriately treated
	// always returns 1 for wounds that don't need to be treated
	proc/is_treated()
		if(!needs_treatment) return 1

		if(damage_type == BRUISE || damage_type == CUT)
			return bandaged
		else if(damage_type == BURN)
			return salved

	// heal the given amount of damage, and if the given amount of damage was more
	// than what needed to be healed, return how much heal was left
	proc/heal_damage(amount)
		var/healed_damage = min(src.damage, amount)
		amount -= healed_damage
		src.damage -= healed_damage

		while(src.damage / src.amount < damage_list[current_stage] && current_stage < src.desc_list.len)
			current_stage++
		desc = desc_list[current_stage]

		// return amount of healing still leftover, can be used for other wounds
		return amount

	// opens the wound again
	proc/open_wound()
		if(current_stage > 1)
			// e.g. current_stage is 2, then reset it to 0 and do next_stage(), bringing it to 1
			src.current_stage -= 2
			next_stage()
			src.damage = src.min_damage + 5

/** CUTS **/
/datum/wound/cut
	// link wound descriptions to amounts of damage
	stages = list("cut" = 5, "healing cut" = 2, "small scab" = 0)

/datum/wound/deep_cut
	stages = list("deep cut" = 15, "clotted cut" = 8, "scab" = 2, "fresh skin" = 0)

/datum/wound/flesh_wound
	stages = list("flesh wound" = 25, "blood soaked clot" = 15, "large scab" = 5, "fresh skin" = 0)

/datum/wound/gaping_wound
	stages = list("gaping wound" = 50, "large blood soaked clot" = 25, "large clot" = 15, "small angry scar" = 5, \
	               "small straight scar" = 0)

/datum/wound/big_gaping_wound
	stages = list("big gaping wound" = 60, "gauze wrapped wound" = 50, "blood soaked bandage" = 25,\
				  "large angry scar" = 10, "large straight scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

/datum/wound/massive_wound
	stages = list("massive wound" = 70, "massive blood soaked bandage" = 40, "huge bloody mess" = 20,\
				  "massive angry scar" = 10,  "massive jagged scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

/** BRUISES **/
/datum/wound/bruise
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,\
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)

	needs_treatment = 1 // this only heals when bandaged
	damage_type = BRUISE

/datum/wound/bruise/monumental_bruise

// implement sub-paths by starting at a later stage
/datum/wound/bruise/huge_bruise
	current_stage = 1

/datum/wound/bruise/large_bruise
	current_stage = 2

/datum/wound/bruise/moderate_bruise
	current_stage = 3
	needs_treatment = 0

/datum/wound/bruise/small_bruise
	current_stage = 4
	needs_treatment = 0

/datum/wound/bruise/tiny_bruise
	current_stage = 5
	needs_treatment = 0

/** BURNS **/
/datum/wound/moderate_burn
	stages = list("moderate burn" = 5, "moderate salved burn" = 2, "fresh skin" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/large_burn
	stages = list("large burn" = 15, "large salved burn" = 5, "fresh skin" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/severe_burn
	stages = list("severe burn" = 30, "severe salved burn" = 10, "burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/deep_burn
	stages = list("deep burn" = 40, "deep salved burn" = 15,  "large burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/carbonised_area
	stages = list("carbonised area" = 50, "treated carbonised area" = 20, "massive burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN


/****************************************************
				EXTERNAL ORGANS
****************************************************/
/datum/organ/external
	name = "external"
	var/icon_name = null
	var/body_part = null

	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/max_size = 0
	var/tmp/list/obj/item/weapon/implant/implant

	var/display_name
	var/list/wounds = list()
	var/number_wounds = 0 // cache the number of wounds, which is NOT wounds.len!

	var/tmp/perma_injury = 0
	var/tmp/perma_dmg = 0
	var/tmp/destspawn = 0 //Has it spawned the broken limb?
	var/tmp/amputated = 0 // Whether this has been cleanly amputated, thus causing no pain
	var/min_broken_damage = 30

	var/datum/organ/external/parent
	var/list/datum/organ/external/children

	var/damage_msg = "\red You feel an intense pain"

	var/status = 0
	var/broken_description
	var/open = 0
	var/stage = 0

	New(mob/living/carbon/H)
		..(H)
		if(!display_name)
			display_name = name
		if(istype(H))
			owner = H
			H.organs[name] = src

	proc/take_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list())
		// TODO: this proc needs to be rewritten to not update damages directly
		if((brute <= 0) && (burn <= 0))
			return 0
		if(status & ORGAN_DESTROYED)
			return 0
		if(status & ORGAN_ROBOT)
			brute *= 0.66 //~2/3 damage for ROBOLIMBS
			burn *= 0.66 //~2/3 damage for ROBOLIMBS

		if(owner && !(status & ORGAN_ROBOT))
			owner.pain(display_name, (brute+burn)*3, 1, burn > brute)

		if(sharp)
			var/nux = brute * rand(10,15)
			if(brute_dam >= max_damage)
				if(prob(5 * brute))
					status |= ORGAN_DESTROYED
					droplimb()
					return

			else if(prob(nux))
				createwound( CUT, brute )
				if(!(status & ORGAN_ROBOT))
					owner << "You feel something wet on your [display_name]"

		if((brute_dam + burn_dam + brute + burn) < max_damage)
			if(brute)
				brute_dam += brute
				if( (prob(brute*2) && !sharp) || sharp )
					createwound( CUT, brute )
				else if(!sharp)
					createwound( BRUISE, brute )
			if(burn)
				burn_dam += burn
				createwound( BURN, burn )
		else
			var/can_inflict = max_damage - (brute_dam + burn_dam) //How much damage can we actually cause?
			if(can_inflict)
				if (brute > 0 && burn > 0)
					brute = can_inflict/2
					burn = can_inflict/2
					var/ratio = brute / (brute + burn)
					brute_dam += ratio * can_inflict
					burn_dam += (1 - ratio) * can_inflict
				else
					if (brute > 0)
						brute = can_inflict
						brute_dam += brute
						if(!sharp && !prob(brute*3)) createwound(max(1,min(6,round(brute/10) + rand(0,1))),1,brute)
						else createwound(max(1,min(6,round(brute/10) + rand(1,2))),1,brute)
					else
						burn = can_inflict
						burn_dam += burn
						createwound(max(1,min(6,round(burn/10) + rand(0,1))),2,burn)
			else if(!(status & ORGAN_ROBOT))
				var/passed_dam = (brute + burn) - can_inflict //Getting how much overdamage we have.
				var/list/datum/organ/external/possible_points = list()
				if(parent)
					possible_points += parent
				if(children)
					possible_points += children
				if(forbidden_limbs.len)
					possible_points -= forbidden_limbs
				if(!possible_points.len)
					message_admins("Oh god WHAT!  [owner]'s [src] was unable to find an organ to pass overdamage too!")
				else
					var/datum/organ/external/target = pick(possible_points)
					if(brute)
						target.take_damage(passed_dam, 0, sharp, used_weapon, forbidden_limbs + src)
					else
						target.take_damage(0, passed_dam, sharp, used_weapon, forbidden_limbs + src)
			else
				droplimb(1) //Robot limbs just kinda fail at full damage.


			if(status & ORGAN_BROKEN)
				owner.emote("scream")

		if(used_weapon) add_wound(used_weapon, brute + burn)

		owner.updatehealth()

		// sync the organ's damage with its wounds
		src.update_damages()

		var/result = update_icon()
		return result



	proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
		if(status & ORGAN_ROBOT && !robo_repair)
			return

		// heal damage on the individual wounds
		for(var/datum/wound/W in wounds)
			if(brute == 0 && burn == 0)
				break

			// heal brute damage
			if(W.damage_type == CUT || W.damage_type == BRUISE)
				brute = W.heal_damage(brute)
			else if(W.damage_type == BURN)
				burn = W.heal_damage(burn)

		// sync organ damage with wound damages
		update_damages()

		if(internal)
			status &= ~ORGAN_BROKEN
			perma_injury = 0

		// if all damage is healed, replace the wounds with scars
		if(brute_dam + burn_dam == 0)
			for(var/V in autopsy_data)
				var/datum/autopsy_data/W = autopsy_data[V]
				del W
			autopsy_data = list()

		// sync the organ's damage with its wounds
		src.update_damages()

		owner.updatehealth()
		var/result = update_icon()
		return result

	proc/update_damages()
		number_wounds = 0
		brute_dam = 0
		burn_dam = 0
		status &= ~ORGAN_BLEEDING
		for(var/datum/wound/W in wounds)
			if(W.damage_type == CUT || W.damage_type == BRUISE)
				brute_dam += W.damage
			else if(W.damage_type == BURN)
				burn_dam += W.damage

			if(!W.bandaged && W.damage > 4)
				status |= ORGAN_BLEEDING

			number_wounds += W.amount

	proc/update_wounds()
		for(var/datum/wound/W in wounds)
			// wounds can disappear after 10 minutes at the earliest
			if(W.damage == 0 && W.created + 10 * 10 * 60 <= world.time)
				wounds -= W
				// let the GC handle the deletion of the wound
			if(W.is_treated())
				// slow healing
				var/amount = 0.2
				if(W.bandaged) amount++
				if(W.salved) amount++
				if(W.disinfected) amount++
				// amount of healing is spread over all the wounds
				W.heal_damage((amount * W.amount) / (5*owner.number_wounds+1))

		// sync the organ's damage with its wounds
		src.update_damages()

	proc/add_wound(var/used_weapon, var/damage)
		var/datum/autopsy_data/W = autopsy_data[used_weapon]
		if(!W)
			W = new()
			W.weapon = used_weapon
			autopsy_data[used_weapon] = W

		W.hits += 1
		W.damage += damage
		W.time_inflicted = world.time

		owner.update_body_appearance()


	proc/get_damage()	//returns total damage
		return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use health?

	proc/get_damage_brute()
		return max(brute_dam+perma_injury, perma_injury)

	proc/get_damage_fire()
		return burn_dam

	process()
		// process wounds, doing healing etc., only do this every 4 ticks to save processing power
		if(owner.life_tick % 4 == 0)
			update_wounds()
		if(status & ORGAN_DESTROYED)
			if(!destspawn)
				droplimb()
			return
		if(!(status & ORGAN_BROKEN))
			perma_dmg = 0
		if(parent)
			if(parent.status & ORGAN_DESTROYED)
				status |= ORGAN_DESTROYED
				owner:update_body()
				return
		if(brute_dam > min_broken_damage && !(status & ORGAN_ROBOT))
			if(!(status & ORGAN_BROKEN))
				owner.visible_message("\red You hear a loud cracking sound coming from \the [owner].","\red <b>Something feels like it shattered in your [display_name]!</b>","You hear a sickening crack.")
				owner.emote("scream")
				status |= ORGAN_BROKEN
				broken_description = pick("broken","fracture","hairline fracture")
				perma_injury = brute_dam
		return

// new damage icon system
// returns just the brute/burn damage code
	proc/damage_state_text()
		var/tburn = 0
		var/tbrute = 0

		if(burn_dam ==0)
			tburn =0
		else if (burn_dam < (max_damage * 0.25 / 2))
			tburn = 1
		else if (burn_dam < (max_damage * 0.75 / 2))
			tburn = 2
		else
			tburn = 3

		if (brute_dam == 0)
			tbrute = 0
		else if (brute_dam < (max_damage * 0.25 / 2))
			tbrute = 1
		else if (brute_dam < (max_damage * 0.75 / 2))
			tbrute = 2
		else
			tbrute = 3
		return "[tbrute][tburn]"


// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
	proc/update_icon()
		var/n_is = damage_state_text()
		if (n_is != damage_state)
			damage_state = n_is
			owner.update_body_appearance() // I'm not sure about this, Sky probably knows better where to put it
			return 1
		return 0

	proc/droplimb(var/override = 0,var/no_explode = 0)
		if(override)
			status |= ORGAN_DESTROYED
		if(status & ORGAN_DESTROYED)
			if(status & ORGAN_SPLINTED)
				status &= ~ORGAN_SPLINTED
			if(implant)
				for(var/implants in implant)
					del(implants)
			//owner.unlock_medal("Lost something?", 0, "Lose a limb.", "easy")

			for(var/datum/organ/external/I in children)
				if(I && !(I.status & ORGAN_DESTROYED))
					I.droplimb(1,1)
			var/obj/item/weapon/organ/H
			switch(body_part)
				if(UPPER_TORSO)
					owner.gib()
				if(LOWER_TORSO)
					owner << "\red You are now sterile."
				if(HEAD)
					H = new /obj/item/weapon/organ/head(owner.loc, owner)
					if(ishuman(owner))
						if(owner.gender == FEMALE)
							H.icon_state = "head_f_l"
						H.overlays += owner.face_lying
					if(ismonkey(owner))
						H.icon_state = "head_l"
						//H.overlays += owner.face_lying
					H:transfer_identity(owner)
					H.pixel_x = -10
					H.pixel_y = 6
					if(!owner.original_name)
						owner.original_name = owner.real_name
					H.name = "[owner.original_name]'s head"

					if(ishuman(owner))
						owner.update_face()
					owner.update_body()
					owner.death()
				if(ARM_RIGHT)
					H = new /obj/item/weapon/organ/r_arm(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "r_arm_l"
				if(ARM_LEFT)
					H = new /obj/item/weapon/organ/l_arm(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "l_arm_l"
				if(LEG_RIGHT)
					H = new /obj/item/weapon/organ/r_leg(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "r_leg_l"
				if(LEG_LEFT)
					H = new /obj/item/weapon/organ/l_leg(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "l_leg_l"
				if(HAND_RIGHT)
					H = new /obj/item/weapon/organ/r_hand(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "r_hand_l"
				if(HAND_LEFT)
					H = new /obj/item/weapon/organ/l_hand(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "l_hand_l"
				if(FOOT_RIGHT)
					H = new /obj/item/weapon/organ/r_foot/(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "r_foot_l"
				if(FOOT_LEFT)
					H = new /obj/item/weapon/organ/l_foot(owner.loc, owner)
					if(ismonkey(owner))
						H.icon_state = "l_foot_l"
			var/lol = pick(cardinal)
			step(H,lol)
			destspawn = 1
			if(status & ORGAN_ROBOT)
				owner.visible_message("\red \The [owner]'s [display_name] explodes violently!",\
				"\red <b>Your [display_name] explodes!</b>",\
				"You hear an explosion followed by a scream!")
				if(!no_explode)
					explosion(get_turf(owner),-1,-1,2,3)
					var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
					spark_system.set_up(5, 0, src)
					spark_system.attach(src)
					spark_system.start()
					spawn(10)
						del(spark_system)
			else
				owner.visible_message("\red [owner.name]'s [display_name] flies off in an arc.",\
				"<span class='moderate'><b>Your [display_name] goes flying off!</b></span>",\
				"You hear a terrible sound of ripping tendons and flesh.")
			owner.update_body_appearance()
			owner.update_clothing()

	proc/createwound(var/type = CUT, var/damage)
		if(hasorgans(owner))
			var/wound_type
			var/size = min( max( 1, damage/10 ) , 6)

			// first check whether we can widen an existing wound
			if(wounds.len > 0 && prob(25))
				if((type == CUT || type == BRUISE) && damage >= 5)
					var/datum/wound/W = pick(wounds)
					if(W.amount == 1 && W.started_healing())
						W.open_wound()
						owner.visible_message("\red The wound on [owner.name]'s [display_name] widens with a nasty ripping voice.",\
						"\red The wound on your [display_name] widens with a nasty ripping voice.",\
						"You hear a nasty ripping noise, as if flesh is being torn apart.")

						return

			if(damage == 0) return

			// the wound we will create
			var/datum/wound/W

			switch(type)
				if(CUT)
					src.status |= ORGAN_BLEEDING
					var/list/size_names = list(/datum/wound/cut, /datum/wound/deep_cut, /datum/wound/flesh_wound, /datum/wound/gaping_wound, /datum/wound/big_gaping_wound, /datum/wound/massive_wound)
					wound_type = size_names[size]
					W = new wound_type(damage)
					//message_admins("DEBUG: Wound type CUT: [type]")
				if(BRUISE)
					var/list/size_names = list(/datum/wound/bruise/tiny_bruise, /datum/wound/bruise/small_bruise, /datum/wound/bruise/moderate_bruise, /datum/wound/bruise/large_bruise, /datum/wound/bruise/huge_bruise, /datum/wound/bruise/monumental_bruise)
					wound_type = size_names[size]
					W = new wound_type(damage)
					//message_admins("DEBUG: Wound type BRUISE: [type]")
				if(BURN)
					var/list/size_names = list(/datum/wound/moderate_burn, /datum/wound/large_burn, /datum/wound/severe_burn, /datum/wound/deep_burn, /datum/wound/carbonised_area)
					wound_type = size_names[size]
					W = new wound_type(damage)
					//message_admins("DEBUG: Wound type BURN: [type]")
				else
					message_admins("DEBUG: Unknown wound type: [type] with damage [damage] size [size]")
					log_admin("DEBUG: Unknown wound type: [type] with damage [damage] size [size]")
					var/list/size_names = list(/datum/wound/moderate_burn, /datum/wound/large_burn, /datum/wound/severe_burn, /datum/wound/deep_burn, /datum/wound/carbonised_area)
					wound_type = size_names[size]
					W = new wound_type(damage)


			// check whether we can add the wound to an existing wound
			for(var/datum/wound/other in wounds)
				//if(!(other && W))
				//	return
				if(other.desc == W.desc)
					// okay, add it!
					other.damage += W.damage
					other.amount += 1
					W = null // to signify that the wound was added
					break

			// if we couldn't add the wound to another wound, ignore
			if(W)
				wounds += W

	proc/emp_act(severity)
		if(!(status & ORGAN_ROBOT))
			return
		if(prob(30*severity))
			take_damage(4(4-severity), 0, 1, used_weapon = "EMP")
		else
			droplimb(1)

	proc/getDisplayName()
		switch(name)
			if("l_leg")
				return "left leg"
			if("r_leg")
				return "right leg"
			if("l_arm")
				return "left arm"
			if("r_arm")
				return "right arm"
			if("l_foot")
				return "left foot"
			if("r_foot")
				return "right foot"
			if("l_hand")
				return "left hand"
			if("r_hand")
				return "right hand"
			else
				return name



/****************************************************
				INTERNAL ORGANS
****************************************************/
/datum/organ/internal
	name = "internal"










/****************************************************
				//////////////
				ORGAN EXTERNAL
				/////////////
****************************************************/



/datum/organ/external/chest
	name = "chest"
	icon_name = "chest"
	max_damage = 150
	min_broken_damage = 75
	body_part = UPPER_TORSO

/datum/organ/external/groin
	name = "groin"
	icon_name = "diaper"
	max_damage = 115
	min_broken_damage = 70
	body_part = LOWER_TORSO

/datum/organ/external/head
	name = "head"
	icon_name = "head"
	max_damage = 75
	min_broken_damage = 40
	body_part = HEAD
	var/disfigured = 0

/datum/organ/external/l_arm
	name = "l_arm"
	display_name = "left arm"
	icon_name = "l_arm"
	max_damage = 75
	min_broken_damage = 30
	body_part = ARM_LEFT

/datum/organ/external/l_leg
	name = "l_leg"
	display_name = "left leg"
	icon_name = "l_leg"
	max_damage = 75
	min_broken_damage = 30
	body_part = LEG_LEFT

/datum/organ/external/r_arm
	name = "r_arm"
	display_name = "right arm"
	icon_name = "r_arm"
	max_damage = 75
	min_broken_damage = 30
	body_part = ARM_RIGHT

/datum/organ/external/r_leg
	name = "r_leg"
	display_name = "right leg"
	icon_name = "r_leg"
	max_damage = 75
	min_broken_damage = 30
	body_part = LEG_RIGHT

/datum/organ/external/l_foot
	name = "l_foot"
	display_name = "left foot"
	icon_name = "l_foot"
	max_damage = 40
	min_broken_damage = 15
	body_part = FOOT_LEFT

/datum/organ/external/r_foot
	name = "r_foot"
	display_name = "right foot"
	icon_name = "r_foot"
	max_damage = 40
	min_broken_damage = 15
	body_part = FOOT_RIGHT

/datum/organ/external/r_hand
	name = "r_hand"
	display_name = "right hand"
	icon_name = "r_hand"
	max_damage = 40
	min_broken_damage = 15
	body_part = HAND_RIGHT

/datum/organ/external/l_hand
	name = "l_hand"
	display_name = "left hand"
	icon_name = "l_hand"
	max_damage = 40
	min_broken_damage = 15
	body_part = HAND_LEFT

/*/datum/organ/Del()
	CRASH("Some dawg tried to delete this sexy datum. Here's the data.")

/obj/item/weapon/organ/Del()
	CRASH("Some dawg tried to delete this sexy organ. Here's the data.")*/


obj/item/weapon/organ
	icon = 'human.dmi'

obj/item/weapon/organ/New(loc, mob/living/carbon/human/H)
	..(loc)
	if(!istype(H))
		return

	var/icon/I = new /icon(icon, icon_state)

	if (H.s_tone >= 0)
		I.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
	else
		I.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)
	icon = I

obj/item/weapon/organ/head
	name = "head"
	icon_state = "head_m_l"
	var/mob/living/carbon/brain/brainmob
	var/brain_op_stage = 0

obj/item/weapon/organ/head/New()
	..()
	spawn(5)
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

obj/item/weapon/organ/head/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->head
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob.container = src

obj/item/weapon/organ/head/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/scalpel))
		switch(brain_op_stage)
			if(0)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is beginning to have \his head cut open with [src] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [src]!"
				user << "\red You cut [brainmob]'s head open with [src]!"

				brain_op_stage = 1

			if(2)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is having \his connections to the brain delicately severed with [src] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [src]!"
				user << "\red You cut [brainmob]'s head open with [src]!"

				brain_op_stage = 3.0
			else
				..()
	else if(istype(W,/obj/item/weapon/circular_saw))
		switch(brain_op_stage)
			if(1)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his skull sawed open with [src] by [user].", 1)
				brainmob << "\red [user] begins to saw open your head with [src]!"
				user << "\red You saw [brainmob]'s head open with [src]!"

				brain_op_stage = 2
			if(3)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his spine's connection to the brain severed with [src] by [user].", 1)
				brainmob << "\red [user] severs your brain's connection to the spine with [src]!"
				user << "\red You sever [brainmob]'s brain's connection to the spine with [src]!"

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [brainmob.name] ([brainmob.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
				brainmob.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
				log_admin("ATTACK: [brainmob] ([brainmob.ckey]) debrained [user] ([user.ckey]).")
				message_admins("ATTACK: [brainmob] ([brainmob.ckey]) debrained [user] ([user.ckey]).")

				var/obj/item/brain/B = new(loc)
				B.transfer_identity(brainmob)

				brain_op_stage = 4.0
			else
				..()
	else
		..()

obj/item/weapon/organ/l_arm
	name = "left arm"
	icon_state = "l_arm_l"
obj/item/weapon/organ/l_foot
	name = "left foot"
	icon_state = "l_foot_l"
obj/item/weapon/organ/l_hand
	name = "left hand"
	icon_state = "l_hand_l"
obj/item/weapon/organ/l_leg
	name = "left leg"
	icon_state = "l_leg_l"
obj/item/weapon/organ/r_arm
	name = "right arm"
	icon_state = "r_arm_l"
obj/item/weapon/organ/r_foot
	name = "right foot"
	icon_state = "r_foot_l"
obj/item/weapon/organ/r_hand
	name = "right hand"
	icon_state = "r_hand_l"
obj/item/weapon/organ/r_leg
	name = "right leg"
	icon_state = "r_leg_l"




/****************************************************
				//////////////
				ORGAN INTERNAL
				/////////////
****************************************************/


/datum/organ/internal/blood_vessels
	name = "blood vessels"
	var/heart = null
	var/lungs = null
	var/kidneys = null

/datum/organ/internal/brain
	name = "brain"
	var/head = null

/datum/organ/internal/excretory
	name = "excretory"
	var/excretory = 7.0
	var/blood_vessels = null

/datum/organ/internal/heart
	name = "heart"

/datum/organ/internal/immune_system
	name = "immune system"
	var/blood_vessels = null
	var/isys = null

/datum/organ/internal/intestines
	name = "intestines"
	var/intestines = 3.0
	var/blood_vessels = null

/datum/organ/internal/liver
	name = "liver"
	var/intestines = null
	var/blood_vessels = null

/datum/organ/internal/lungs
	name = "lungs"
	var/lungs = 3.0
	var/throat = null
	var/blood_vessels = null

/datum/organ/internal/stomach
	name = "stomach"
	var/intestines = null

/datum/organ/internal/throat
	name = "throat"
	var/lungs = null
	var/stomach = null







/****************************************************
				//////////////
					PAIN
				/////////////
****************************************************/


mob/proc/flash_pain()
	flick("pain",pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100
mob/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(stat >= 2) return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "\red <b>Your [partname] burns.</b>"
			if(11 to 90)
				flash_weak_pain()
				msg = "\red <b><font size=2>Your [partname] burns badly!</font></b>"
			if(91 to 10000)
				flash_pain()
				msg = "\red <b><font size=3>OH GOD! Your [partname] is on fire!</font></b>"
	else
		switch(amount)
			if(1 to 10)
				msg = "<b>Your [partname] hurts.</b>"
			if(11 to 90)
				flash_weak_pain()
				msg = "<b><font size=2>Your [partname] hurts badly.</font></b>"
			if(91 to 10000)
				flash_pain()
				msg = "<b><font size=3>OH GOD! Your [partname] is hurting terribly!</font></b>"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		src << msg
	next_pain_time = world.time + (100 - amount)

mob/living/carbon/human/proc/handle_pain()
	// not when sleeping
	if(stat >= 2) return
	if(reagents.has_reagent("tramadol"))
		return
	if(reagents.has_reagent("oxycodone"))
		return
	if(analgesic)
		return
	var/maxdam = 0
	var/datum/organ/external/damaged_organ = null
	for(var/name in organs)
		var/datum/organ/external/E = organs[name]
		// amputated limbs don't cause pain
		if(E.amputated) continue

		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.display_name, maxdam, 0)




////////////////////////////////////SURGERY
///////////////////////////////////////////////////////SURGERY
////////////////////////////////////SURGERY