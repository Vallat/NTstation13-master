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
				msg = "\red <b><font size=2>Your [partname] burns badly!</font></b>"
			if(91 to 10000)
				msg = "\red <b><font size=3>OH GOD! Your [partname] is on fire!</font></b>"
	else
		switch(amount)
			if(1 to 10)
				msg = "<b>Your [partname] hurts.</b>"
			if(11 to 90)
				msg = "<b><font size=2>Your [partname] hurts badly.</font></b>"
			if(91 to 10000)
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


/*
			for(var/obj/item/organ/limb/org in H.organs)
				var/status = ""
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				if(hallucination)
					if(prob(30))
						brutedamage += rand(30,40)
					if(prob(30))
						burndamage += rand(30,40)

				if(brutedamage > 0)
					status = " - легкие повреждения"
				if(brutedamage > 20)
					status = "- кровопотеря"
				if(brutedamage > 40)
					status = "- сильные повреждения"
				if(brutedamage > 0 && burndamage > 0)
					status += " и "
				if(burndamage > 40)
					status += "- сильный ожог"

				else if(burndamage > 10)
					status += "- средний ожог"
				else if(burndamage > 0)
					status += " слабый ожог"
				if(status == "")
					status = "OK"
				src << "\t § [status == "OK" ? "\blue" : "\red"] [org.getDisplayName()] [status]."

				*/






///NEEDED TO COMPILE, BABY


/*
/mob/living/carbon
	var/analgesic = 0

/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn)
	var/list/datum/organ/external/parts = list()
	for(var/name in organs)
		var/datum/organ/external/organ = organs[name]
		if((brute && organ.brute_dam) || (burn && organ.burn_dam))
			parts += organ
	return parts

*/