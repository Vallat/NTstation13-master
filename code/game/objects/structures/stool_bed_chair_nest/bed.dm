/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/stool/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon_state = "bed"
	var/mob/living/buckled_mob

/obj/structure/stool/bed/qbed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon_state = "qbed"

/obj/structure/stool/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon_state = "abed"

/obj/structure/stool/bed/Destroy()
	unbuckle()
	..()

/obj/structure/stool/bed/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/stool/bed/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/stool/bed/attack_animal(var/mob/living/simple_animal/M)//No more buckling hostile mobs to chairs to render them immobile forever
	if(M.environment_smash)
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)

/obj/structure/stool/bed/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

/obj/structure/stool/bed/proc/afterbuckle(mob/M as mob) // Called after somebody buckled / unbuckled
	return

/obj/structure/stool/bed/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()

			var/M = buckled_mob
			buckled_mob = null

			afterbuckle(M)
	return

/obj/structure/stool/bed/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				if(!(user.buckled))
					unbuckle_other(user)
				else
					user << "<span class='notice'>You can't reach [src]!</span>"
			else
				unbuckle_myself(user)
			src.add_fingerprint(user)
	return

/obj/structure/stool/bed/proc/unbuckle_other(mob/user as mob)
	buckled_mob.visible_message(\
		"<span class='notice'>[buckled_mob.name] was unbuckled by [user.name]!</span>",\
		"You were unbuckled from [src] by [user.name].",\
		"You hear metal clanking.")
	unbuckle()


/obj/structure/stool/bed/proc/unbuckle_myself(mob/user as mob)
	buckled_mob.visible_message(\
		"<span class='notice'>[buckled_mob.name] unbuckled \himself!</span>",\
		"You unbuckle yourself from [src].",\
		"You hear metal clanking.")
	unbuckle()

/obj/structure/stool/bed/proc/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) || M.anchored)
		return

	if (istype(M, /mob/living/carbon/slime))
		user << "The [M] is too squishy to buckle in."
		return

	unbuckle()

	if (M == usr)
		M.visible_message(\
			"\blue [M.name] buckles in!",\
			"You buckle yourself to [src].",\
			"You hear metal clanking")
	else
		M.visible_message(\
			"\blue [M.name] is buckled in to [src] by [user.name]!",\
			"You are buckled in to [src] by [user.name].",\
			"You hear metal clanking")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)

	afterbuckle(M)
	return

/*
 * Roller beds
 */
/obj/structure/stool/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	var/const/buckled_pixel_y_offset = 6 //Mobs buckled will have their pixel_y offset by this much

/obj/structure/stool/bed/roller/afterbuckle(mob/M as mob)
	if(buckled_mob)
		density = 1
		icon_state = "up"
		M.pixel_y += buckled_pixel_y_offset
	else
		density = 0
		icon_state = "down"
		M.pixel_y -= buckled_pixel_y_offset

/obj/structure/stool/bed/roller/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
