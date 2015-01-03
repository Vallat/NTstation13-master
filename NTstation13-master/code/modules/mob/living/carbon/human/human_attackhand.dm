/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(!istype(M))
		return

	if(..())	//to allow surgery to return properly.
		return

	if((M != src) && check_shields(0, M.name))
		add_logs(M, src, "attempted to touch")
		visible_message("<span class='warning'>[M] attempted to touch [src]!</span>")
		return 0

	switch(M.a_intent)
		if("help")
			if(health >= 0)
				help_shake_act(M)
				if(src != M)
					add_logs(M, src, "shaked")
				return 1

			//CPR
			if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>������� �����!</span>"
				return 0
			if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>������� �����!</span>"
				return 0

			if(cpr_time < world.time + 30)
				add_logs(src, M, "CPRed")
				visible_message("<span class='notice'>[M] �������� ���������� [src]!</span>")
				if(!do_mob(M, src))
					return 0
				if((health >= -99 && health <= 0))
					cpr_time = world.time
					var/suff = min(getOxyLoss(), 7)
					adjustOxyLoss(-suff)
					updatehealth()
					M.visible_message("[M] �������� ���������� [src]!")
					src << "<span class='unconscious'>�� ���������� ���-�� �������. ���� ������� �����.</span>"

		if("grab")
			if(M == src || anchored)
				return 0

			add_logs(M, src, "grabbed", addition="passively")

			if(w_uniform)
				w_uniform.add_fingerprint(M)

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)
			if(buckled)
				M << "<span class='notice'>�� �� ������ �������� [src], ��/��� ����������/�!</span>"
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] ������ [src] ����� �����!</span>")
			return 1

		if("harm")
			add_logs(M, src, "punched")

			var/attack_verb = "����"

			if(M.kick_in_the_groin == 1)
				src.stunned = 2
				attack_verb = "������ ���� ��&#255;��, ��-��-�� ��� ����� �� ��������� �"
			if(M.blow_to_the_eyes == 1)
				attack_verb = "������� ���� �� ������, ��-��-�� ��� ����� �� ��������� �"
				src.eye_blurry += rand(3,4)
				src.eye_stat += rand(2,4)
				if (src.eye_stat >= 10)
					src.eye_blurry += 15+(0.1*M.eye_blurry)
					src.disabilities |= NEARSIGHTED
					if(src.stat != 2)
						src.drop_item()
					src.eye_blurry += 10
					src.Paralyse(1)
					src.Weaken(4)
				if (prob(src.eye_stat - 10 + 1))
					if(src.stat != 2)
						src.sdisabilities |= BLIND

			if(M.PO_TORMOZAM == 1)
				src.stunned = 2
				Weaken(3)
				attack_verb = "������� ���� PO_TORMOZAM, ��-��-�� ��� ����� �� ��������� �"

			if(M.punch_in_the_stomach == 1)
				src.adjustOxyLoss(20)
				attack_verb = "������� ���� �� ������, ��-��-�� ��� ����� �� ��������� �"


			if(lying)
				attack_verb = "������"
			else if(M.dna)
				switch(M.dna.mutantrace)
					if("lizard")
						attack_verb = "scratch"
					if("plant")
						attack_verb = "slash"

			var/damage = rand(0, 9)
			if(!damage)
				switch(attack_verb)
					if("slash")
						playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
					else
						playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

				visible_message("<span class='warning'>[M] has attempted to [attack_verb] [src]!</span>")
				return 0


			var/obj/item/organ/limb/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(M.has_organic_effect(/datum/organic_effect/hulk))
				damage += 5

			switch(attack_verb)
				if("slash")
					playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				else
					playsound(loc, "punch", 25, 1, -1)

			visible_message("<span class='danger'>[M] [attack_verb] [src]!</span>", \
							"<span class='userdanger'>[M] [attack_verb] [src]!</span>")

			apply_damage(damage, BRUTE, affecting, armor_block)
			if((stat != DEAD) && damage >= 9)
				visible_message("<span class='danger'>[M] ������� ������� ���� [src]!</span>", \
								"<span class='userdanger'>[M] ������� ������� ���� [src]!</span>")
				apply_effect(4, WEAKEN, armor_block)
				forcesay(hit_appends)
			else if(lying)
				forcesay(hit_appends)

		if("disarm")
			add_logs(M, src, "disarmed")

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/organ/limb/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/randn = rand(1, 100)
			if(randn <= 25)
				apply_effect(2, WEAKEN, run_armor_check(affecting, "melee"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M] ������ [src]!</span>",
								"<span class='userdanger'>[M] ������ [src]!</span>")
				forcesay(hit_appends)
				return

			var/talked = 0	// BubbleWrap

			if(randn <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message("<span class='warning'>[M] has broken [src]'s grip on [pulling]!</span>")
					talked = 1
					stop_pulling()

				//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
				if(istype(l_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/lgrab = l_hand
					if(lgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [lgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						qdel(lgrab)
				if(istype(r_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/rgrab = r_hand
					if(rgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [rgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						qdel(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					if(drop_item())
						visible_message("<span class='danger'>[M] �������� ������� [src]!</span>", \
										"<span class='userdanger'>[M] �������� ������� [src]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return


			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("<span class='danger'>[M] �������� ������� [src]!</span>", \
							"<span class='userdanger'>[M] �������� ������� [src]!</span>")
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return