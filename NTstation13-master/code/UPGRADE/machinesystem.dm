obj/machine/weel
	icon = 'machine.dmi'
	name = "weel"
	var/broken = 0

obj/machine/body
	icon = 'machine.dmi'
	name = "body"

obj/machine/motor
	icon = 'machine.dmi'
	name = "motor"
	var/check_weel_right = 0
	var/check_weel_left = 0
	var/broken = 0
	var/can_work = 0

obj/machine/control
	icon = 'machine.dmi'
	name = "control"
	var/check_body_right = 0
	var/check_body_left = 0
	var/way = 0
	var/can_go = 0
	var/body_check = 0

obj/machine/trunk
	icon = 'machine.dmi'
	name = "trunk"
	var/check_weel_right = 0
	var/check_weel_left = 0
	var/can_work = 0

obj/machine/control/can_go()
	check()

obj/machine/control/proc/check()

	var/obj/machine/body/X
	var/obj/machine/motor/Y
	var/obj/machine/weel/W
	var/obj/machine/trunk/Z

	if(src.x + 1 == X.x)
		check_body_right = 1
	if(src.x - 1 == X.x)
		check_body_left = 1
	if(src.check_body_right == 1 & src.check_body_left == 1)
		body_check = 1
	if(Y.can_work == 1 & W.broken == 0 & Z.can_work == 1 & body_check ==1)
		can_go = 1

obj/machine/proc/can_go()
	return
