/*
	Modified DynamicAreaLighting for TGstation - Coded by Carnwennan

	This is TG's 'new' lighting system. It's basically a heavily modified combination of Forum_Account's and
	ShadowDarke's respective lighting libraries. Credits, where due, to them.

	Like sd_DAL (what we used to use), it changes the shading overlays of areas by splitting each type of area into sub-areas
	by using the var/tag variable and moving turfs into the contents list of the correct sub-area. This method is
	much less costly than using overlays or objects.

	Unlike sd_DAL however it uses a queueing system. Everytime we call a change to opacity or luminosity
	(through SetOpacity() or SetLuminosity()) we are  simply updating variables and scheduling certain lights/turfs for an
	update. Actual updates are handled periodically by the lighting_controller. This carries additional overheads, however it
	means that each thing is changed only once per lighting_controller.processing_interval ticks. Allowing for greater control
	over how much priority we'd like lighting updates to have. It also makes it possible for us to simply delay updates by
	setting lighting_controller.processing = 0 at say, the start of a large explosion, waiting for it to finish, and then
	turning it back on with lighting_controller.processing = 1.

	Unlike our old system there are hardcoded maximum luminositys (different for certain atoms).
	This is to cap the cost of creating lighting effects.
	(without this, an atom with luminosity of 20 would have to update 41^2 turfs!) :s

	Also, in order for the queueing system to work, each light remembers the effect it casts on each turf. This is going to
	have larger memory requirements than our previous system but it's easily worth the hassle for the greater control we
	gain. It also reduces cost of removing lighting effects by a lot!

	Known Issues/TODO:
		Shuttles still do not have support for dynamic lighting (I hope to fix this at some point)
		No directional lighting support. (prototype looked ugly)
*/

#define LIGHTING_CIRCULAR 1									//comment this out to use old square lighting effects.
#define LIGHTING_LAYER 10									//Drawing layer for lighting overlays
#define LIGHTING_ICON 'icons/effects/ss13_dark_alpha6.dmi'	//Icon used for lighting shading effects

datum/light_source
	var/atom/owner
	var/changed = 1
	var/list/effect = list()
	var/__x = 0		//x coordinate at last update
	var/__y = 0		//y coordinate at last update


	New(atom/A)
		if(!istype(A))
			CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[A]' instead.")
		..()
		owner = A
		__x = owner.x
		__y = owner.y
		// the lighting object maintains a list of all light sources
		lighting_controller.lights += src


	//Check a light to see if its effect needs reprocessing. If it does, remove any old effect and create a new one
	proc/check()
		if(!owner)
			remove_effect()
			return 1	//causes it to be removed from our list of lights. The garbage collector will then destroy it.

		// check to see if we've moved since last update
		if(owner.x != __x || owner.y != __y)
			__x = owner.x
			__y = owner.y
			changed = 1

		if(changed)
			changed = 0
			remove_effect()
			return add_effect()
		return 0


	proc/remove_effect()
		// before we apply the effect we remove the light's current effect.
		for(var/turf/T in effect)	// negate the effect of this light source
			T.update_lumcount(-effect[T])
		effect.Cut()					// clear the effect list

	proc/add_effect()
		// only do this if the light is turned on and is on the map
		if(owner.loc && owner.luminosity > 0)
			effect = list()
			for(var/turf/T in view(owner.get_light_range(),owner))
				var/delta_lumen = lum(T)
				if(delta_lumen > 0)
					effect[T] = delta_lumen
					T.update_lumcount(delta_lumen)

			return 0
		else
			owner.light = null
			return 1	//cause the light to be removed from the lights list and garbage collected once it's no
						//longer referenced by the queue

	proc/lum(turf/A)
		if (owner.trueLuminosity < 1)
			return 0
		var/dist
		if(!A)
			dist = 0
		else
#ifdef LIGHTING_CIRCULAR
			dist = cheap_hypotenuse(A.x, A.y, __x, __y)
#else
			dist = max(abs(A.x - __x), abs(A.y - __y))
#endif
		if (owner.trueLuminosity > 100) // This will never happen... right?
			return sqrt(owner.trueLuminosity) - dist
		else
			return sqrtTable[owner.trueLuminosity] - dist

atom
	var/tmp/datum/light_source/light
	var/trueLuminosity = 0  // Typically 'luminosity' squared.  The builtin luminosity must remain linear.
	                        // We may read it, but NEVER set it directly.


//Turfs with opacity when they are constructed will trigger nearby lights to update
//Turfs and atoms with luminosity when they are constructed will create a light_source automatically
turf/New()
	..()
	if(luminosity)
		if(light)	WARNING("[type] - Don't set lights up manually during New(), We do it automatically.")
		trueLuminosity = luminosity * luminosity
		light = new(src)

//Movable atoms with opacity when they are constructed will trigger nearby lights to update
//Movable atoms with luminosity when they are constructed will create a light_source automatically
atom/movable/New()
	..()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	if(luminosity)
		if(light)	WARNING("[type] - Don't set lights up manually during New(), We do it automatically.")
		trueLuminosity = luminosity * luminosity
		light = new(src)

//Objects with opacity will trigger nearby lights to update at next lighting process.
atom/movable/Destroy()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	return ..()

//Sets our luminosity.
//If we have no light it will create one.
//If we are setting luminosity to 0 the light will be cleaned up by the controller and garbage collected once all its
//queues are complete.
//if we have a light already it is merely updated, rather than making a new one.
atom/proc/SetLuminosity(new_luminosity, trueLum = FALSE)
	if(new_luminosity < 0)
		new_luminosity = 0
	if(!trueLum)
		new_luminosity *= new_luminosity
	if(light)
		if(trueLuminosity != new_luminosity)	//non-luminous lights are removed from the lights list in add_effect()
			light.changed = 1
	else
		if(new_luminosity)
			light = new(src)
	trueLuminosity = new_luminosity
	if (trueLuminosity < 1)
		luminosity = 0
	else if (trueLuminosity <= 100)
		luminosity = sqrtTable[trueLuminosity]
	else
		luminosity = sqrt(trueLuminosity)

atom/proc/AddLuminosity(delta_luminosity)
	if(delta_luminosity > 0)
		SetLuminosity(trueLuminosity + delta_luminosity*delta_luminosity, TRUE)
	else if(delta_luminosity < 0)
		SetLuminosity(trueLuminosity - delta_luminosity*delta_luminosity, TRUE)

area/SetLuminosity(new_luminosity)			//we don't want dynamic lighting for areas
	luminosity = !!new_luminosity
	trueLuminosity = luminosity


//change our opacity (defaults to toggle), and then update all lights that affect us.
atom/proc/SetOpacity(new_opacity)
	if(new_opacity == null)
		new_opacity = !opacity			//default = toggle opacity
	else if(opacity == new_opacity)
		return 0						//opacity hasn't changed! don't bother doing anything
	opacity = new_opacity				//update opacity, the below procs now call light updates.
	return 1

turf/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(lighting_lumcount)			//only bother with an update if our turf is currently affected by a light
			UpdateAffectingLights()

/atom/movable/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(isturf(loc))					//only bother with an update if we're on a turf
			var/turf/T = loc
			if(T.lighting_lumcount)		//only bother with an update if our turf is currently affected by a light
				UpdateAffectingLights()


turf
	var/lighting_lumcount = 0
	var/lighting_changed = 0

turf/space
	lighting_lumcount = 4		//starlight

turf/proc/update_lumcount(amount)
	lighting_lumcount += amount
	if(!lighting_changed)
		lighting_controller.changed_turfs += src
		lighting_changed = 1

turf/proc/lighting_tag(var/level)
	var/area/A = loc
	return A.tagbase + "sd_L[level]"

turf/proc/build_lighting_area(var/tag, var/level)
	var/area/Area = loc
	var/area/A = new Area.type()    // create area if it wasn't found
	// replicate vars
	for(var/V in Area.vars)
		switch(V)
			if("contents","lighting_overlay","overlays")	continue
			else
				if(issaved(Area.vars[V])) A.vars[V] = Area.vars[V]

	A.tag = tag
	A.lighting_subarea = 1
	A.lighting_space = 0 // in case it was copied from a space subarea
	A.SetLightLevel(level)

	Area.related += A
	return A

turf/proc/shift_to_subarea()
	lighting_changed = 0
	var/area/Area = loc

	if(!istype(Area) || !Area.lighting_use_dynamic) return

	var/level = min(max(round(lighting_lumcount,1),0),lighting_controller.lighting_states)
	var/new_tag = lighting_tag(level)
	if(Area.tag!=new_tag)	//skip if already in this area
		var/area/A = locate(new_tag)	// find an appropriate area

		if(!A)
			A = build_lighting_area(new_tag,level)

		A.contents += src	// move the turf into the area

// Dedicated lighting sublevel for space turfs
// helps us depower things in space, remove space fire alarms,
// and evens out space lighting
turf/space/lighting_tag(var/level)
	var/area/A = loc
	return A.tagbase + "sd_L_space"
turf/space/build_lighting_area(var/tag,var/level)
	var/area/A = ..(tag,4)
	A.lighting_space = 1
	A.SetLightLevel(4)
	A.icon_state = null
	return A

area
	var/lighting_use_dynamic = 1	//Turn this flag off to prevent sd_DynamicAreaLighting from affecting this area
	var/image/lighting_overlay		//tracks the darkness image of the area for easy removal
	var/lighting_subarea = 0		//tracks whether we're a lighting sub-area
	var/lighting_space = 0			// true for space-only lighting subareas
	var/tagbase

	proc/SetLightLevel(light)
		if(!src) return
		if(light <= 0)
			light = 0
			luminosity = 0
		else
			if(light > lighting_controller.lighting_states)
				light = lighting_controller.lighting_states
			luminosity = 1

		if(lighting_overlay)
			overlays -= lighting_overlay
			lighting_overlay.icon_state = "[light]"
		else
			lighting_overlay = image(LIGHTING_ICON,,num2text(light),LIGHTING_LAYER)

		overlays += lighting_overlay

	proc/SetDynamicLighting()

		src.lighting_use_dynamic = 1
		for(var/turf/T in src.contents)
			T.update_lumcount(0)

	proc/InitializeLighting()	//TODO: could probably improve this bit ~Carn
		tagbase = "[type]"
		if(!tag) tag = tagbase
		if(!lighting_use_dynamic)
			if(!lighting_subarea)	// see if this is a lighting subarea already
			//show the dark overlay so areas, not yet in a lighting subarea, won't be bright as day and look silly.
				SetLightLevel(4)

#undef LIGHTING_LAYER
#undef LIGHTING_CIRCULAR
//#undef LIGHTING_ICON
#define LIGHTING_MAX_LUMINOSITY_STATIC	8	//Maximum luminosity to reduce lag.
#define LIGHTING_MAX_LUMINOSITY_MOBILE	5	//Moving objects have a lower max luminosity since these update more often. (lag reduction)
#define LIGHTING_MAX_LUMINOSITY_TURF	1	//turfs have a severely shortened range to protect from inevitable floor-lighttile spam.

//set the changed status of all lights which could have possibly lit this atom.
//We don't need to worry about lights which lit us but moved away, since they will have change status set already
//This proc can cause lots of lights to be updated. :(
atom/proc/UpdateAffectingLights()
	for(var/atom/A in oview(LIGHTING_MAX_LUMINOSITY_STATIC-1,src))
		if(A.light)
			A.light.changed = 1			//force it to update at next process()

//caps luminosity effects max-range based on what type the light's owner is.
atom/proc/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

atom/movable/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_MOBILE)

obj/machinery/light/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

turf/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_TURF)

#undef LIGHTING_MAX_LUMINOSITY_STATIC
#undef LIGHTING_MAX_LUMINOSITY_MOBILE
#undef LIGHTING_MAX_LUMINOSITY_TURF



///////
/////
///
//UltraLight system, by Sukasa


#define UL_I_FALLOFF_SQUARE 0
#define UL_I_FALLOFF_ROUND 1

#define UL_I_LIT 0
#define UL_I_EXTINGUISHED 1
#define UL_I_ONZERO 2
#define UL_I_CHANGING 3

#define ul_LightingEnabled 1
//#define ul_LightingResolution 2
//Uncomment if you want maybe slightly smoother lighting
#define ul_Steps 7
#define ul_FalloffStyle UL_I_FALLOFF_ROUND // Sets the lighting falloff to be either squared or circular.
#define ul_Layer 10
#define ul_TopLuminosity 12 //Maximum brightness an object can have.

//#define ul_LightLevelChangedUpdates
//Uncomment if you have code that you want triggered when the light level on an atom changes.


#define ul_Clamp(Value) min(max(Value, 0), ul_Steps)
#define ul_IsLuminous(A) (A.ul_Red || A.ul_Green || A.ul_Blue)
#define ul_Luminosity(A) max(A.ul_Red, A.ul_Green, A.ul_Blue)


#ifdef ul_LightingResolution
var/ul_LightingResolutionSqrt = sqrt(ul_LightingResolution)
#endif
var/ul_SuppressLightLevelChanges = 0


var/list/ul_FastRoot = list(0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,
							5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
							7, 7)

var/list/ul_IconCache = list()


proc/ul_UnblankLocal(var/list/ReApply = view(ul_TopLuminosity, src))
	for(var/atom/Light in ReApply)
		if(ul_IsLuminous(Light))
			Light.ul_Illuminate()
	return

atom/var/ul_Red = 0
atom/var/ul_Green = 0
atom/var/ul_Blue = 0
atom/var/turf/ul_LastIlluminated

atom/var/ul_Extinguished = UL_I_ONZERO

atom/proc/ul_SetLuminosity(var/Red = 0, var/Green = Red, var/Blue = Red)

	if(ul_Extinguished == UL_I_CHANGING) //Changing state, just supress any changes, to prevent glitches.
		return

	if(ul_Red == min(Red, ul_TopLuminosity) && ul_Green == min(Green, ul_TopLuminosity) && ul_Blue == min(Blue, ul_TopLuminosity))
		return //No point doing all that work if it won't have any effect anyways...

	if (ul_Extinguished == UL_I_EXTINGUISHED)
		ul_Red = min(Red,ul_TopLuminosity)
		ul_Green = min(Green,ul_TopLuminosity)
		ul_Blue = min(Blue,ul_TopLuminosity)

		return

	if (ul_IsLuminous(src))
		ul_Extinguish()

	ul_Red = min(Red,ul_TopLuminosity)
	ul_Green = min(Green,ul_TopLuminosity)
	ul_Blue = min(Blue,ul_TopLuminosity)

	ul_Extinguished = UL_I_ONZERO

	if (ul_IsLuminous(src))
		ul_Illuminate()

	return

atom/proc/ul_Illuminate()
	if (ul_Extinguished == UL_I_LIT)
		return

	ul_Extinguished = UL_I_CHANGING

	luminosity = ul_Luminosity(src)

	for(var/turf/Affected in view(luminosity, src))
		var/Falloff = ul_FalloffAmount(Affected)

		var/DeltaRed = ul_Red - Falloff
		var/DeltaGreen = ul_Green - Falloff
		var/DeltaBlue = ul_Blue - Falloff

		if(DeltaRed > 0 || DeltaGreen > 0 || DeltaBlue > 0)

			if(DeltaRed > 0)
				if(!Affected.MaxRed)
					Affected.MaxRed = list()
				Affected.MaxRed += DeltaRed

			if(DeltaGreen > 0)
				if(!Affected.MaxGreen)
					Affected.MaxGreen = list()
				Affected.MaxGreen += DeltaGreen

			if(DeltaBlue > 0)
				if(!Affected.MaxBlue)
					Affected.MaxBlue = list()
				Affected.MaxBlue += DeltaBlue

			Affected.ul_UpdateLight()

			#ifdef ul_LightLevelChangedUpdates
			if (ul_SuppressLightLevelChanges == 0)
				Affected.ul_LightLevelChanged()

				for(var/atom/AffectedAtom in Affected)
					AffectedAtom.ul_LightLevelChanged()
			#endif

	ul_LastIlluminated = get_turf(src)
	ul_Extinguished = UL_I_LIT

	return

atom/proc/ul_Extinguish()

	if (ul_Extinguished != UL_I_LIT)
		return

	ul_Extinguished = UL_I_CHANGING

	for(var/turf/Affected in view(ul_Luminosity(src), ul_LastIlluminated))

		var/Falloff = ul_LastIlluminated.ul_FalloffAmount(Affected)

		var/DeltaRed = ul_Red - Falloff
		var/DeltaGreen = ul_Green - Falloff
		var/DeltaBlue = ul_Blue - Falloff

		if(DeltaRed > 0 || DeltaGreen > 0 || DeltaBlue > 0)

			if(DeltaRed > 0)
				if(Affected.MaxRed)
					var/removed_light_source = Affected.MaxRed.Find(DeltaRed)
					if(removed_light_source)
						Affected.MaxRed.Cut(removed_light_source, removed_light_source+1)
					if(!Affected.MaxRed.len)
						del Affected.MaxRed

			if(DeltaGreen > 0)
				if(Affected.MaxGreen)
					var/removed_light_source = Affected.MaxGreen.Find(DeltaGreen)
					if(removed_light_source)
						Affected.MaxGreen.Cut(removed_light_source, removed_light_source+1)
					if(!Affected.MaxGreen.len)
						del Affected.MaxGreen

			if(DeltaBlue > 0)
				if(Affected.MaxBlue)
					var/removed_light_source = Affected.MaxBlue.Find(DeltaBlue)
					if(removed_light_source)
						Affected.MaxBlue.Cut(removed_light_source, removed_light_source+1)
					if(!Affected.MaxBlue.len)
						del Affected.MaxBlue

			Affected.ul_UpdateLight()

			#ifdef ul_LightLevelChangedUpdates
			if (ul_SuppressLightLevelChanges == 0)
				Affected.ul_LightLevelChanged()

				for(var/atom/AffectedAtom in Affected)
					AffectedAtom.ul_LightLevelChanged()
			#endif

	ul_Extinguished = UL_I_EXTINGUISHED
	luminosity = 0
	ul_LastIlluminated = null

	return


/*
 Calculates the correct lighting falloff value (used to calculate what brightness to set the turf to) to use,
  when called on a luminous atom and passed an atom in the turf to be lit.

 Supports multiple configurations, BS12 uses the circular falloff setting. This setting uses an array lookup
  to avoid the cost of the square root function.
*/
atom/proc/ul_FalloffAmount(var/atom/ref)
	if (ul_FalloffStyle == UL_I_FALLOFF_ROUND)
		var/delta_x = (ref.x - src.x)
		var/delta_y = (ref.y - src.y)

		#ifdef ul_LightingResolution
		if (round((delta_x*delta_x + delta_y*delta_y)*ul_LightingResolutionSqrt,1) > ul_FastRoot.len)
			for(var/i = ul_FastRoot.len, i <= round(delta_x*delta_x+delta_y*delta_y*ul_LightingResolutionSqrt,1), i++)
				ul_FastRoot += round(sqrt(i))
		return ul_FastRoot[round((delta_x*delta_x + delta_y*delta_y)*ul_LightingResolutionSqrt, 1) + 1]/ul_LightingResolution

		#else
		if ((delta_x*delta_x + delta_y*delta_y) > ul_FastRoot.len)
			for(var/i = ul_FastRoot.len, i <= delta_x*delta_x+delta_y*delta_y, i++)
				ul_FastRoot += round(sqrt(i))
		return ul_FastRoot[delta_x*delta_x + delta_y*delta_y + 1]

		#endif

	else if (ul_FalloffStyle == UL_I_FALLOFF_SQUARE)
		return get_dist(src, ref)

	return 0

atom/proc/ul_SetOpacity(var/NewOpacity)
	if(opacity != NewOpacity)

		var/list/Blanked = ul_BlankLocal()

		opacity = NewOpacity

		ul_UnblankLocal(Blanked)

	return

atom/proc/ul_BlankLocal()
	var/list/Blanked = list( )
	var/TurfAdjust = isturf(src) ? 1 : 0

	for(var/atom/Affected in view(ul_TopLuminosity, src))
		if(ul_IsLuminous(Affected) && Affected.ul_Extinguished == UL_I_LIT && (ul_FalloffAmount(Affected) <= ul_Luminosity(Affected) + TurfAdjust))
			Affected.ul_Extinguish()
			Blanked += Affected

	return Blanked

atom/proc/ul_LightLevelChanged()
	//Designed for client projects to use.  Called on items when the turf they are in has its light level changed
	return

atom/New()
	. = ..()
	if(ul_IsLuminous(src))
		spawn(5)
			ul_Illuminate()

atom/Del()
	if(ul_IsLuminous(src))
		ul_Extinguish()
	. = ..()

atom/movable/Move()
	if(ul_IsLuminous(src))
		ul_Extinguish()
		. = ..()
		ul_Illuminate()
	else
		return ..()


turf/var/list/MaxRed
turf/var/list/MaxGreen
turf/var/list/MaxBlue

turf/proc/ul_GetRed()
	if(MaxRed)
		return ul_Clamp(max(MaxRed))
	return 0
turf/proc/ul_GetGreen()
	if(MaxGreen)
		return ul_Clamp(max(MaxGreen))
	return 0
turf/proc/ul_GetBlue()
	if(MaxBlue)
		return ul_Clamp(max(MaxBlue))
	return 0

turf/proc/ul_UpdateLight()
	var/area/CurrentArea = loc

	if(!isarea(CurrentArea) || !CurrentArea.ul_Lighting)
		return

	var/LightingTag = copytext(CurrentArea.tag, 1, findtext(CurrentArea.tag, ":UL")) + ":UL[ul_GetRed()]_[ul_GetGreen()]_[ul_GetBlue()]"

	if(CurrentArea.tag != LightingTag)
		var/area/NewArea = locate(LightingTag)

		if(!NewArea)
			NewArea = new CurrentArea.type()
			NewArea.tag = LightingTag

			for(var/V in CurrentArea.vars - "contents")
				if(issaved(CurrentArea.vars[V]))
					NewArea.vars[V] = CurrentArea.vars[V]

			NewArea.tag = LightingTag

			NewArea.ul_Light(ul_GetRed(), ul_GetGreen(), ul_GetBlue())


		NewArea.contents += src

	return

turf/proc/ul_Recalculate()

	ul_SuppressLightLevelChanges++

	var/list/Lights = ul_BlankLocal()

	ul_UnblankLocal(Lights)

	ul_SuppressLightLevelChanges--

	return

area/var/ul_Overlay = null
area/var/ul_Lighting = 1

area/var/LightLevelRed = 0
area/var/LightLevelGreen = 0
area/var/LightLevelBlue = 0
area/var/list/LightLevels

area/proc/ul_Light(var/Red = LightLevelRed, var/Green = LightLevelGreen, var/Blue = LightLevelBlue)

	if(!src || !src.ul_Lighting)
		return

	overlays -= ul_Overlay
	if(LightLevels)
		if(Red < LightLevels["Red"])
			Red = LightLevels["Red"]
		if(Green < LightLevels["Green"])
			Green = LightLevels["Green"]
		if(Blue < LightLevels["Blue"])
			Blue = LightLevels["Blue"]

	LightLevelRed = Red
	LightLevelGreen = Green
	LightLevelBlue = Blue

	luminosity = LightLevelRed || LightLevelGreen || LightLevelBlue

	var/ul_CachedOverlay = ul_IconCache["[LightLevelRed]-[LightLevelGreen]-[LightLevelBlue]"]
	if(ul_CachedOverlay)
		ul_Overlay = ul_CachedOverlay
	else
		ul_IconCache["[LightLevelRed]-[LightLevelGreen]-[LightLevelBlue]"] = image('ULIcons.dmi', , "[LightLevelRed]-[LightLevelGreen]-[LightLevelBlue]", ul_Layer)
		ul_Overlay = ul_IconCache["[LightLevelRed]-[LightLevelGreen]-[LightLevelBlue]"]

	overlays += ul_Overlay

	return

area/proc/ul_Prep()

	if(!tag)
		tag = "[type]"
	if(ul_Lighting)
		if(!findtext(tag,":UL"))
			ul_Light()
	//world.log << tag

	return

#undef UL_I_FALLOFF_SQUARE
#undef UL_I_FALLOFF_ROUND
#undef UL_I_LIT
#undef UL_I_EXTINGUISHED
#undef UL_I_ONZERO
#undef ul_LightingEnabled
#undef ul_LightingResolution
#undef ul_Steps
#undef ul_FalloffStyle
#undef ul_Layer
#undef ul_TopLuminosity
#undef ul_Clamp
#undef ul_LightLevelChangedUpdates

