/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings ANGRILY!"
				m_type = 2

		if ("choke")
			if (miming)
				message = "<B>[src]</B> ��������� �� �����!"
			else
				..(act)

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B> ��������."
			else
				..(act)

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> �����������."
				m_type = 2

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> ������ ��� ���!"
			m_type = 2

		if ("cough")
			if (miming)
				message = "<B>[src]</B> �������!"
			else
				if (!muzzled)
					message = "<B>[src]</B> �������!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ���������� �����."
					m_type = 2

		if ("cry")
			if (miming)
				message = "<B>[src]</B> ������."
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> �������."
					m_type = 2

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "says")
				src << "\red Invalid emote."
				return
			else if(copytext(input,1,9) == "exclaims")
				src << "\red Invalid emote."
				return
			else if(copytext(input,1,5) == "asks")
				src << "\red Invalid emote."
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

		if ("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings."
				m_type = 2

		if ("gasp")
			if (miming)
				message = "<B>[src]</B> ����������!"

		if ("giggle")
			if (miming)
				message = "<B>[src]</B> giggles silently!"

		if ("groan")
			if (miming)
				message = "<B>[src]</B> appears to groan!"
			else
				if (!muzzled)
					message = "<B>[src]</B> groans!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("grumble")
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if ("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "<B>[src]</B> takes a drag from a cigarette and blows \"[M]\" out in smoke."
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows \his name out in smoke."
					m_type = 2

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "says")
				src << "\red Invalid emote."
				return
			else if(copytext(message,1,9) == "exclaims")
				src << "\red Invalid emote."
				return
			else if(copytext(message,1,5) == "asks")
				src << "\red Invalid emote."
				return
			else
				message = "<B>[src]</B> [message]"

		if ("moan")
			if(miming)
				message = "<B>[src]</B> ������!"
			else
				message = "<B>[src]</B> ������!"
				m_type = 2

		if ("mumble")
			message = "<B>[src]</B> mumbles!"
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> ������������ [param]."
				else
					message = "<B>[src]</b> ������������."
			m_type = 1

		if ("scream")
			if (miming)
				message = "<B>[src]</B> ������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������!"
					m_type = 2
					call_sound_emote("scream")
				else
					message = "<B>[src]</B> ������ ������� �����."
					m_type = 2

		if ("shiver")
			message = "<B>[src]</B> ������."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> �������� �������."
			m_type = 1

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> ��������."
			else
				..(act)

		if ("laugh")
			if(miming)
				message = "<B>[src]</B> �������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> �������."
					m_type = 2
					call_sound_emote("laugh")
				else
					message = "<B>[src]</B> ������� ���."
					m_type = 2

		if("elaugh")
			if(miming)
				message = "<B>[src]</B> ������ �������."
				m_type = 1
			else if (mind.special_role)
				if (!ready_to_elaugh())
					if (world.time % 3)
						usr << "<span class='warning'>�� �� ������ ������� ��� ������!"
				else
					message = "<B>[src]</B> ����� ������ �������! Mu-ha-ha!"
					m_type = 2
					call_sound_emote("elaugh")
			else
				if (!muzzled)
					if (!ready_to_emote())
						if (world.time % 3)
							usr << "<span class='warning'>�� �� ������ ������� ��� ������!"
					else
						message = "<B>[src]</B> ������ �������."
						m_type = 2
						call_sound_emote("laugh")
				else
					message = "<B>[src]</B> ������� ���."
					m_type = 2

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> ������."
			else
				..(act)

		if ("sniff")
			message = "<B>[src]</B> ������� �����."
			m_type = 2

		if ("snore")
			if (miming)
				message = "<B>[src]</B> ������."
			else
				..(act)

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> ������."
			else
				..(act)

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> ������."
				m_type = 2

		if ("Hello")
			if (!muzzled)
				message = "<B>[src]</B> ��������� ���� � ����� � ����� ������ ��������� ����� � ������ *��� �����*."
				m_type = 2

		if ("Fuck")
			if (!muzzled)
				message = "<B>[src]</B> ������������� ����� � ��������� ������������� ������ �� ������� �������."
				m_type = 2

		if ("Dance")
			if (!muzzled)
				message = "<B>[src]</B> ������� �������."
				m_type = 2

		if ("Dog")
			if (!muzzled)
				message = "<B>[src]</B> ����."
				m_type = 2

		if ("Wolf")
			if (!muzzled)
				message = "<B>[src]</B> ����."
				m_type = 2

		if ("Danger")
			if (!muzzled)
				message = "<B>[src]</B> �����."
				m_type = 2

		if ("Cat")
			if (!muzzled)
				message = "<B>[src]</B> ���������."
				m_type = 2

		if ("Ear")
			if (!muzzled)
				message = "<B>[src]</B> ���������� � ���."
				m_type = 2


		if ("help") //This can stay at the bottom.
			src << "Help for human emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, dance, dap, deathgasp, drool, eyebrow, faint, frown, flap, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, johnny, jump, laugh, look-(none)/mob, me, moan, mumble, nod, pale, point-(atom), raise, salute, scream, shake, shiver, shrug, sigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, wave, whimper, wink, yawn"

		else
			..(act)

	if(miming)
		m_type = 1


	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				O.show_message(message, m_type)

/mob/living/carbon/human/proc/call_sound_emote(var/E)
	switch(E)
		if("scream")
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'), 100, 1)
			else
				playsound(src.loc, pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'), 100, 1)

		if("laugh")
			playsound(src.loc, pick('sound/voice/laugh1.ogg', 'sound/voice/laugh2.ogg', 'sound/voice/laugh3.ogg'), 100, 1)

		if("elaugh")
			playsound(src.loc, 'sound/voice/elaugh.ogg', 100, 1)

/mob/living/carbon/human/var/emote_delay = 30
/mob/living/carbon/human/var/elaugh_delay = 600
/mob/living/carbon/human/var/last_emoted = 0


/mob/living/carbon/human/proc/ready_to_emote()
	if(world.time >= last_emoted + emote_delay)
		last_emoted = world.time
		return 1
	else
		return 0

/mob/living/carbon/human/proc/ready_to_elaugh()
	if(world.time >= last_emoted + elaugh_delay)
		last_emoted = world.time
		return 1
	else
		return 0
