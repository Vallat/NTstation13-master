/*
Assistant
*/
/datum/job/assistant
	title = "Worker"
	flag = ASSISTANT
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	default_id = /obj/item/weapon/card/id/assistant

/datum/job/assistant/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/that(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/labcoat(H), slot_wear_suit)


/datum/job/assistant/get_access()
	if(config.jobs_have_maint_access & ASSISTANTS_HAVE_MAINT_ACCESS) //Config has assistant maint access set
		. = ..()
		. |= list(access_maint_tunnels)
	else
		return ..()