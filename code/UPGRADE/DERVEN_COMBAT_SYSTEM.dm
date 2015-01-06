mob/living/carbon/human
	var/kick_in_the_groin = 0
	var/blow_to_the_eyes = 0
	var/punch_in_the_stomach = 0

mob/living/carbon/human/verb/eye_attack()
	set name = "eye_attack"
	set category = "Foul blow"
	blow_to_the_eyes = 1
	sleep(10)
	blow_to_the_eyes = 0

mob/living/carbon/human/verb/stomach_attack()
	set name = "stomach_attack"
	set category = "Foul blow"
	punch_in_the_stomach = 1
	sleep(10)
	punch_in_the_stomach = 0

mob/living/carbon/human/verb/groin_attack()
	set name = "groin_attack"
	set category = "Foul blow"
	kick_in_the_groin = 1
	sleep(10)
	kick_in_the_groin = 0