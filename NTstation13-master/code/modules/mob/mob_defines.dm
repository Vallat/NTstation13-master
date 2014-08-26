/mob
	density = 1
	layer = 4
	animate_movement = 2
	flags = 0
	var/datum/mind/mind

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak

	var/tmp/obj/screen/flash = null
	var/tmp/obj/screen/blind = null
	var/tmp/obj/screen/hands = null
	var/tmp/obj/screen/pullin = null
	var/tmp/obj/screen/internals = null
	var/tmp/obj/screen/oxygen = null
	var/tmp/obj/screen/i_select = null
	var/tmp/obj/screen/m_select = null
	var/tmp/obj/screen/toxin = null
	var/tmp/obj/screen/fire = null
	var/tmp/obj/screen/bodytemp = null
	var/tmp/obj/screen/healths = null
	var/tmp/obj/screen/throw_icon = null
	var/tmp/obj/screen/nutrition_icon = null
	var/tmp/obj/screen/pressure = null
	var/tmp/obj/screen/damageoverlay = null
	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/tmp/obj/screen/zone_sel/zone_sel = null

	var/damageoverlaytemp = 0
	var/tmp/computer_id = null
	var/lastattacker = null
	var/lastattacked = null
	var/attack_log = list( )
	var/tmp/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon
	var/tmp/atom/movable/pulling = null
	var/tmp/next_move = null
	var/notransform = null	//Carbon
	var/hand = null
	var/eye_blind = null	//Carbon
	var/eye_blurry = null	//Carbon
	var/ear_deaf = null		//Carbon
	var/ear_damage = null	//Carbon
	var/stuttering = null	//Carbon
	var/real_name = null
	var/blinded = null
	var/bhunger = 0			//Carbon
	var/ajourn = 0
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/canmove = 1
	var/eye_stat = null//Living, potentially Carbon
	var/lastpuke = 0
	var/unacidable = 0

	var/name_archive //For admin things like possession

	var/timeofdeath = 0//Living
	var/cpr_time = 1//Carbon


	var/bodytemperature = 310.055	//98.7 F
	var/drowsyness = 0//Carbon
	var/dizziness = 0//Carbon
	var/jitteriness = 0//Carbon
	var/nutrition = 400//Carbon

	var/overeatduration = 0		// How long this guy is overeating //Carbon
	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/losebreath = 0//Carbon
	var/shakecamera = 0
	var/a_intent = "help"//Living
	var/m_intent = "run"//Living
	var/tmp/lastKnownIP = null
	var/obj/structure/stool/bed/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/tmp/obj/item/weapon/storage/s_active = null//Carbon

	var/seer = 0 //for cult//Carbon, probably Human
	var/see_override = 0 //0 for no override, sets see_invisible = see_override in mob life process

	var/tmp/datum/hud/hud_used = null

	var/tmp/list/grabbed_by = list(  )
	var/list/requests = list(  )

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/coughedtime = null

	var/footstep = 1

	var/inertia_dir = 0

	var/music_lastplayed = "null"

	var/job = null//Living

	var/const/blindness = 1//Carbon
	var/const/deafness = 2//Carbon
	var/const/muteness = 4//Carbon

	var/radiation = 0//Carbon

	var/list/organic_effects = list() //Carbon -- Remie
	//see /code/datums/organic_effects for a list of organic_effects

	var/voice_name = "unidentifiable voice"
	var/voice_message = null // When you are not understood by others (replaced with just screeches, hisses, chimpers etc.)
	var/say_message = null // When you are understood by others. Currently only used by aliens and monkeys in their say_quote procs

	var/list/factions = list("neutral") //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/move_on_shuttle = 1 // Can move on the shuttle.

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/tmp/mob/living/carbon/LAssailant = null


	var/list/mob_spell_list = list() //construct spells and mime spells. Spells that do not transfer from one mob to another and can not be lost in mindswap.

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

//List of active diseases

	var/list/viruses = list() // replaces var/datum/disease/virus

//Monkey/infected mode
	var/list/resistances = list()
	var/datum/disease/virus = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/tmp/update_icon = 1 //Set to 1 to trigger update_icons() at the next life() call

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/tmp/area/lastarea = null

	var/digitalcamo = 0 // Can they be tracked by the AI?

	var/list/radar_blips = list() // list of screen objects, radar blips
	var/radar_open = 0 	// nonzero is radar is open


	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone
	var/robot_talk_understand = 0
	var/alien_talk_understand = 0

	var/tmp/turf/listed_turf = null	//the current turf being examined in the stat panel
