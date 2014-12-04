/atom
	layer = 2
	var/level = 2
	var/flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/tmp/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0

	///Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

/atom/proc/throw_impact(atom/hit_atom)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src)
		on_throw_impact(hit_atom)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src)
		on_throw_impact(hit_atom)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.dir, 180))
			if(istype(src,/mob/living))
				var/mob/living/M = src
				M.take_organ_damage(20)

//what this atom does when it hits something, for special effects/special actions, hitby() handles damage.
/atom/proc/on_throw_impact(atom/hit_atom)
	return

/atom/proc/CheckParts()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	del(giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 1
	return

/atom/proc/on_reagent_change()
	return

/atom/proc/on_mob_move()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/


/atom/proc/allow_drop()
	return 1

/atom/proc/CheckExit()
	return 1

/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *       list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found




/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=50, maxdistance=10)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src,BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		dir=get_dir(src,BeamTarget)	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				qdel(O)							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src,BeamTarget))
		var/icon/I=new(icon,icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N,N<length,N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x,a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x,a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y,a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y,a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
	for(var/obj/effect/overlay/beam/O in orange(10,src)) if(O.BeamSource==src) qdel(O)


//All atoms
/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << "\icon[src]That's \a [src]." //changed to "That's" from "This is" because "This is some metal sheets" sounds dumb compared to "That's some metal sheets" ~Carn
	if(desc)
		usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

/atom/proc/relaymove()
	return

/atom/proc/ex_act()
	return

/atom/proc/blob_act()
	return

/atom/proc/fire_act()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	return


var/list/blood_splatter_icons = list()

/atom/proc/blood_splatter_index()
	return "\ref[initial(icon)]-[initial(icon_state)]"

/atom/proc/add_blood_list(mob/living/carbon/M)
	// Returns 1 if we had blood already
	if(!istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()
	//if this blood isn't already in the list, add it
	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
	return 1

//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/M)
	if(rejects_blood())
		return 0
	if(!istype(M))
		return 0
	if(!check_dna_integrity(M))		//check dna is valid and create/setup if necessary
		return 0					//no dna!
	return

/obj/add_blood(mob/living/carbon/M)
	if(..() == 0)   return 0
	return add_blood_list(M)

/obj/item/add_blood(mob/living/carbon/M)
	var/blood_count = blood_DNA == null ? 0 : blood_DNA.len
	if(..() == 0)	return 0
	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_count && initial(icon) && initial(icon_state))
		//try to find a pre-processed blood-splatter. otherwise, make a new one
		var/index = blood_splatter_index()
		var/icon/blood_splatter_icon = blood_splatter_icons[index]
		if(!blood_splatter_icon )
			blood_splatter_icon = icon(initial(icon), initial(icon_state), , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
			blood_splatter_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
			blood_splatter_icon.Blend(icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
			blood_splatter_icon = fcopy_rsc(blood_splatter_icon)
			blood_splatter_icons[index] = blood_splatter_icon
		overlays += blood_splatter_icon
	return 1 //we applied blood to the item

/obj/item/clothing/gloves/add_blood(mob/living/carbon/M)
	if(..() == 0) return 0
	transfer_blood = rand(2, 4)
	bloody_hands_mob = M
	return 1

/turf/simulated/add_blood(mob/living/carbon/M)
	if(..() == 0)	return 0

	var/obj/effect/decal/cleanable/blood/B = locate() in contents	//check for existing blood splatter
	if(!B)	B = new /obj/effect/decal/cleanable/blood(src)			//make a bloood splatter if we couldn't find one
	B.add_blood_list(M)
	return 1 //we bloodied the floor

/mob/living/carbon/human/add_blood(mob/living/carbon/human/H)
	if(..() == 0)	return 0
	if(!istype(H))
		return 0
	if(!H.has_active_hand())
		return 0
	add_blood_list(H)
	bloody_hands = rand(2, 4)
	bloody_hands_mob = H
	update_inv_gloves()	//handles bloody hands overlays and updating
	return 1 //we applied blood to the item

/atom/proc/rejects_blood()
	return 0

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

		/*for(var/datum/disease/D in M.viruses)
			var/datum/disease/newDisease = D.Copy(1)
			this.viruses += newDisease
			newDisease.holder = this*/

// Only adds blood on the floor -- Skie
/atom/proc/add_blood_floor(mob/living/carbon/M as mob)
	if(istype(src, /turf/simulated))
		if(check_dna_integrity(M))	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/B = locate() in contents
			if(!B)	B = new(src)
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
		else if(istype(M, /mob/living/carbon/alien))
			var/obj/effect/decal/cleanable/xenoblood/B = locate() in contents
			if(!B)	B = new(src)
			B.blood_DNA["UNKNOWN BLOOD"] = "X*"
		else if(istype(M, /mob/living/silicon/robot))
			var/obj/effect/decal/cleanable/oil/B = locate() in contents
			if(!B)	B = new(src)

/atom/proc/clean_blood()
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1


/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	world << "X = [cur_x]; Y = [cur_y]"
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space/k))
		return 1
	else
		return 0

/atom/proc/handle_fall()
	return

/atom/proc/handle_slip()
	return



//ÑÈÌÓËßÖÈß ÆÈÄÊÎÑÒÈ
//ÐÅÍÄÈ ÑÎÑÅÒ ÕÓÈ
//Àíèìóñó ïèçäà


#define LIQUID_TRANSFER_THRESHOLD 0.05

var/liquid_delay = 4

var/list/datum/puddle/puddles = list()

datum/puddle
	var/list/obj/effect/liquid/liquid_objects = list()

datum/puddle/proc/process()
	//world << "DEBUG: Puddle process!"
	for(var/obj/effect/liquid/L in liquid_objects)
		L.spread()

	for(var/obj/effect/liquid/L in liquid_objects)
		L.apply_calculated_effect()

	if(liquid_objects.len == 0)
		del(src)

datum/puddle/New()
	..()
	puddles += src

datum/puddle/Del()
	puddles -= src
	for(var/obj/O in liquid_objects)
		del(O)
	..()

client/splash()
	var/volume = input("Volume?","Volume?", 0 ) as num
	if(!isnum(volume)) return
	if(volume <= LIQUID_TRANSFER_THRESHOLD) return
	var/turf/T = get_turf(src.mob)
	if(!isturf(T)) return
	trigger_splash(T, volume)

proc/trigger_splash(turf/epicenter as turf, volume as num)
	if(!epicenter)
		return
	if(volume <= 0)
		return

	var/obj/effect/liquid/L = new/obj/effect/liquid(epicenter)
	L.volume = volume
	L.update_icon2()
	var/datum/puddle/P = new/datum/puddle()
	P.liquid_objects.Add(L)
	L.controller = P




obj/effect/liquid
	icon = 'icons/effects/liquid.dmi'
	icon_state = "0"
	name = "liquid"
	var/volume = 0
	var/new_volume = 0
	var/datum/puddle/controller

obj/effect/liquid/New()
	..()
	if( !isturf(loc) )
		del(src)

	for( var/obj/effect/liquid/L in loc )
		if(L != src)
			del(L)

obj/effect/liquid/proc/spread()

	//world << "DEBUG: liquid spread!"
	var/surrounding_volume = 0
	var/list/spread_directions = list(1,2,4,8)
	var/turf/loc_turf = loc
	for(var/direction in spread_directions)
		var/turf/T = get_step(src,direction)
		if(!T)
			spread_directions.Remove(direction)
			//world << "ERROR: Map edge!"
			continue //Map edge
		if(!loc_turf.can_leave_liquid(direction)) //Check if this liquid can leave the tile in the direction
			spread_directions.Remove(direction)
			continue
		if(!T.can_accept_liquid(turn(direction,180))) //Check if this liquid can enter the tile
			spread_directions.Remove(direction)
			continue
		var/obj/effect/liquid/L = locate(/obj/effect/liquid) in T
		if(L)
			if(L.volume >= src.volume)
				spread_directions.Remove(direction)
				continue
			surrounding_volume += L.volume //If liquid already exists, add it's volume to our sum
		else
			var/obj/effect/liquid/NL = new(T) //Otherwise create a new object which we'll spread to.
			NL.controller = src.controller
			controller.liquid_objects.Add(NL)

	if(!spread_directions.len)
		//world << "ERROR: No candidate to spread to."
		return //No suitable candidate to spread to

	var/average_volume = (src.volume + surrounding_volume) / (spread_directions.len + 1) //Average amount of volume on this and the surrounding tiles.
	var/volume_difference = src.volume - average_volume //How much more/less volume this tile has than the surrounding tiles.
	if(volume_difference <= (spread_directions.len*LIQUID_TRANSFER_THRESHOLD)) //If we have less than the threshold excess liquid - then there is nothing to do as other tiles will be giving us volume.or the liquid is just still.
		//world << "ERROR: transfer volume lower than THRESHOLD!"
		return

	var/volume_per_tile = volume_difference / spread_directions.len

	for(var/direction in spread_directions)
		var/turf/T = get_step(src,direction)
		if(!T)
			//world << "ERROR: Map edge 2!"
			continue //Map edge
		var/obj/effect/liquid/L = locate(/obj/effect/liquid) in T
		if(L)
			src.volume -= volume_per_tile //Remove the volume from this tile
			L.new_volume = L.new_volume + volume_per_tile //Add it to the volume to the other tile

obj/effect/liquid/proc/apply_calculated_effect()
	volume += new_volume

	if(volume < LIQUID_TRANSFER_THRESHOLD)
		del(src)
	new_volume = 0
	update_icon2()

obj/effect/liquid/Move()
	return 0

obj/effect/liquid/Del()
	src.controller.liquid_objects.Remove(src)
	..()

obj/effect/liquid/proc/update_icon2()
	//icon_state = num2text( max(1,min(7,(floor(volume),10)/10)) )

	switch(volume)
		if(0 to 0.1)
			del(src)
		if(0.1 to 5)
			icon_state = "1"
		if(5 to 10)
			icon_state = "2"
		if(10 to 20)
			icon_state = "3"
		if(20 to 30)
			icon_state = "4"
		if(30 to 40)
			icon_state = "5"
		if(40 to 50)
			icon_state = "6"
		if(50 to INFINITY)
			icon_state = "7"

turf/proc/can_accept_liquid(from_direction)
	return 0
turf/proc/can_leave_liquid(from_direction)
	return 0

turf/space/can_accept_liquid(from_direction)
	return 1
turf/space/can_leave_liquid(from_direction)
	return 1

turf/simulated/floor/can_accept_liquid(from_direction)
	for(var/obj/structure/window/W in src)
		if(W.dir in list(5,6,9,10))
			return 0
		if(W.dir & from_direction)
			return 0
	for(var/obj/O in src)
		if(!O.liquid_pass())
			return 0
	return 1

turf/simulated/floor/can_leave_liquid(to_direction)
	for(var/obj/structure/window/W in src)
		if(W.dir in list(5,6,9,10))
			return 0
		if(W.dir & to_direction)
			return 0
	for(var/obj/O in src)
		if(!O.liquid_pass())
			return 0
	return 1

turf/simulated/wall/can_accept_liquid(from_direction)
	return 0
turf/simulated/wall/can_leave_liquid(from_direction)
	return 0

obj/proc/liquid_pass()
	return 1

obj/machinery/door/liquid_pass()
	return !density

#undef LIQUID_TRANSFER_THRESHOLD