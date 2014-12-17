/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/area

	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	var/eject = null

	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1

	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()
proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(teleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (teleportlocs.len - 1), i++)
			if(sorttext(teleportlocs[i], teleportlocs[i+1]) == -1)
				teleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)

var/list/ghostteleportlocs = list()

proc/process_ghost_teleport_locs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		var/turf/picked = safepick(get_area_turfs(AR.type))
		if (picked && (picked.z == 1 || picked.z == 5 || picked.z == 3))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(ghostteleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (ghostteleportlocs.len - 1), i++)
			if(sorttext(ghostteleportlocs[i], ghostteleportlocs[i+1]) == -1)
				ghostteleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)


/*-----------------------------------------------------------------------------*/

/area/engine/

/area/arrival/start
	name = "\improper Arrival Area"
	icon_state = "start"

/area/space
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambientsounds = list('sound/ambience/ambispace.ogg','sound/ambience/title2.ogg',)



//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	var/push_dir = SOUTH
	var/destination

/area/shuttle/arrival
	name = "\improper Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"
	destination = /area/shuttle/arrival/station

/area/shuttle/arrival/station
	icon_state = "shuttle"
	destination = /area/shuttle/arrival/pre_game

/area/shuttle/escape
	name = "\improper Emergency Shuttle"

/area/shuttle/escape/station
	name = "\improper Emergency Shuttle Station"
	icon_state = "shuttle2"
	destination = /area/shuttle/escape/transit

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"
	destination = /area/shuttle/escape/station

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "\improper Emergency Shuttle Transit"
	icon_state = "shuttle"
	destination = /area/shuttle/escape/centcom

/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"
	destination = /area/shuttle/escape_pod1/transit

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod1/station

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod1/centcom


	mob_activate(var/mob/living/L)
		push_mob_back(L, push_dir)

/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"
	destination = /area/shuttle/escape_pod2/transit

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod2/station

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod2/centcom

	mob_activate(var/mob/living/L)
		push_mob_back(L, push_dir)

/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	push_dir = WEST

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"
	destination = /area/shuttle/escape_pod3/transit

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod3/station

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod3/centcom

	mob_activate(var/mob/living/L)
		push_mob_back(L, push_dir)

/area/shuttle/escape_pod4 //Renaming areas 2hard
	name = "\improper Escape Pod Four"
	push_dir = WEST

/area/shuttle/escape_pod4/station
	icon_state = "shuttle2"
	destination = /area/shuttle/escape_pod4/transit

/area/shuttle/escape_pod4/centcom
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod4/station

/area/shuttle/escape_pod4/transit
	icon_state = "shuttle"
	destination = /area/shuttle/escape_pod4/centcom

	mob_activate(var/mob/living/L)
		push_mob_back(L, push_dir)

/area/shuttle/mining
	name = "\improper Mining Shuttle"

/area/shuttle/mining/station
	icon_state = "shuttle2"
	destination = /area/shuttle/mining/outpost

/area/shuttle/mining/outpost
	icon_state = "shuttle"
	destination = /area/shuttle/mining/station

/area/shuttle/laborcamp
	name = "\improper Labor Camp Shuttle"

/area/shuttle/laborcamp/station
	icon_state = "shuttle"
	destination = /area/shuttle/laborcamp/outpost

/area/shuttle/laborcamp/outpost
	icon_state = "shuttle"
	destination = /area/shuttle/laborcamp/station

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"
	destination = /area/shuttle/transport1/station

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"
	destination = /area/shuttle/transport1/centcom

/area/shuttle/prison/
	name = "\improper Prison Shuttle"

/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered"
	destination = /area/shuttle/specops/station

/area/shuttle/specops/station
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered2"
	destination = /area/shuttle/specops/centcom

/area/shuttle/thunderdome
	name = "honk"

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

// === end remove

/area/spacecontent
	name = "space"

/area/spacecontent/a1
	icon_state = "spacecontent1"

/area/spacecontent/a2
	icon_state = "spacecontent2"

/area/spacecontent/a3
	icon_state = "spacecontent3"

/area/spacecontent/a4
	icon_state = "spacecontent4"

/area/spacecontent/a5
	icon_state = "spacecontent5"

/area/spacecontent/a6
	icon_state = "spacecontent6"

/area/spacecontent/a7
	icon_state = "spacecontent7"

/area/spacecontent/a8
	icon_state = "spacecontent8"

/area/spacecontent/a9
	icon_state = "spacecontent9"

/area/spacecontent/a10
	icon_state = "spacecontent10"

/area/spacecontent/a11
	icon_state = "spacecontent11"

/area/spacecontent/a11
	icon_state = "spacecontent12"

/area/spacecontent/a12
	icon_state = "spacecontent13"

/area/spacecontent/a13
	icon_state = "spacecontent14"

/area/spacecontent/a14
	icon_state = "spacecontent14"

/area/spacecontent/a15
	icon_state = "spacecontent15"

/area/spacecontent/a16
	icon_state = "spacecontent16"

/area/spacecontent/a17
	icon_state = "spacecontent17"

/area/spacecontent/a18
	icon_state = "spacecontent18"

/area/spacecontent/a19
	icon_state = "spacecontent19"

/area/spacecontent/a20
	icon_state = "spacecontent20"

/area/spacecontent/a21
	icon_state = "spacecontent21"

/area/spacecontent/a22
	icon_state = "spacecontent22"

/area/spacecontent/a23
	icon_state = "spacecontent23"

/area/spacecontent/a24
	icon_state = "spacecontent24"

/area/spacecontent/a25
	icon_state = "spacecontent25"

/area/spacecontent/a26
	icon_state = "spacecontent26"

/area/spacecontent/a27
	icon_state = "spacecontent27"

/area/spacecontent/a28
	icon_state = "spacecontent28"

/area/spacecontent/a29
	icon_state = "spacecontent29"

/area/spacecontent/a30
	icon_state = "spacecontent30"

/area/awaycontent
	name = "space"

/area/awaycontent/a1
	icon_state = "awaycontent1"

/area/awaycontent/a2
	icon_state = "awaycontent2"

/area/awaycontent/a3
	icon_state = "awaycontent3"

/area/awaycontent/a4
	icon_state = "awaycontent4"

/area/awaycontent/a5
	icon_state = "awaycontent5"

/area/awaycontent/a6
	icon_state = "awaycontent6"

/area/awaycontent/a7
	icon_state = "awaycontent7"

/area/awaycontent/a8
	icon_state = "awaycontent8"

/area/awaycontent/a9
	icon_state = "awaycontent9"

/area/awaycontent/a10
	icon_state = "awaycontent10"

/area/awaycontent/a11
	icon_state = "awaycontent11"

/area/awaycontent/a11
	icon_state = "awaycontent12"

/area/awaycontent/a12
	icon_state = "awaycontent13"

/area/awaycontent/a13
	icon_state = "awaycontent14"

/area/awaycontent/a14
	icon_state = "awaycontent14"

/area/awaycontent/a15
	icon_state = "awaycontent15"

/area/awaycontent/a16
	icon_state = "awaycontent16"

/area/awaycontent/a17
	icon_state = "awaycontent17"

/area/awaycontent/a18
	icon_state = "awaycontent18"

/area/awaycontent/a19
	icon_state = "awaycontent19"

/area/awaycontent/a20
	icon_state = "awaycontent20"

/area/awaycontent/a21
	icon_state = "awaycontent21"

/area/awaycontent/a22
	icon_state = "awaycontent22"

/area/awaycontent/a23
	icon_state = "awaycontent23"

/area/awaycontent/a24
	icon_state = "awaycontent24"

/area/awaycontent/a25
	icon_state = "awaycontent25"

/area/awaycontent/a26
	icon_state = "awaycontent26"

/area/awaycontent/a27
	icon_state = "awaycontent27"

/area/awaycontent/a28
	icon_state = "awaycontent28"

/area/awaycontent/a29
	icon_state = "awaycontent29"

/area/awaycontent/a30
	icon_state = "awaycontent30"

// CENTCOM

/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = 0
	has_gravity = 1

/area/centcom/control
	name = "\improper Centcom Docks"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"

/area/centcom/prison
	name = "\improper Admin Prison"

/area/centcom/holding
	name = "\improper Holding Facility"

/area/centcom/bar
	name = "\improper Centcom Bar"

/area/centcom/center
	name = "\improper Centcom Central"

/area/centcom/specops
	name = "\improper Special Operations Sector"

/area/centcom/civilian
	name = "\improper Civilian Sector"

/area/centcom/medsci
	name = "\improper Medsci Sector"

/area/centcom/misc/prefab_dungeon //for badmins to fill
	name = "\improper Centcom Depths"

/area/centcom/misc/plane
	name = "\improper Blank Plane"

/area/centcom/misc/fleet
	name = "\improper Centcom Fleet"


//SYNDICATES

/area/syndicate_mothership
	name = "\improper Syndicate Mothership"
	icon_state = "syndie-ship"
	requires_power = 0
	has_gravity = 1

/area/syndicate_mothership/control
	name = "\improper Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Syndicate Elite Squad"
	icon_state = "syndie-elite"


//names are used
/area/syndicate_station
	name = "\improper Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/syndicate_station/start
	name = "\improper Syndicate Forward Operating Base"
	icon_state = "yellow"
	has_gravity = 1

/area/syndicate_station/southwest
	name = "\improper south-west of SS13"
	icon_state = "southwest"

/area/syndicate_station/northwest
	name = "\improper north-west of SS13"
	icon_state = "northwest"

/area/syndicate_station/northeast
	name = "\improper north-east of SS13"
	icon_state = "northeast"

/area/syndicate_station/southeast
	name = "\improper south-east of SS13"
	icon_state = "southeast"

/area/syndicate_station/north
	name = "\improper north of SS13"
	icon_state = "north"

/area/syndicate_station/south
	name = "\improper south of SS13"
	icon_state = "south"

/area/syndicate_station/commssat
	name = "\improper south of the communication satellite"
	icon_state = "south"

/area/syndicate_station/mining
	name = "\improper north east of the mining asteroid"
	icon_state = "north"

/area/syndicate_station/transit
	name = "\improper hyperspace"
	icon_state = "shuttle"

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1






//PRISON
/area/prison
	name = "\improper Prison Station"
	icon_state = "brig"

/area/prison/arrival_airlock
	name = "\improper Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "\improper Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "\improper Prison Security Quarters"
	icon_state = "security"

/area/prison/rec_room
	name = "\improper Prison Rec Room"
	icon_state = "green"

/area/prison/closet
	name = "\improper Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "\improper Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "\improper Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "\improper Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "\improper Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "\improper Prison Morgue"
	icon_state = "morgue"
	ambientsounds = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/prison/medical_research
	name = "\improper Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "\improper Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "\improper Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "\improper Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "\improper Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//STATION13

//Hallway

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/secondary/exit
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "\improper Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry
	name = "\improper Arrival Shuttle Hallway"
	icon_state = "entry"

//Command




//Engineering

/area/engine
	ambientsounds = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')

/area/engine/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	requires_power = 0//This area only covers the batteries and they deal with their own power

/area/engine/engineering
	name = "Engineering"
	icon_state = "engine_smes"

/area/engine/break_room
	name = "\improper Engineering Foyer"
	icon_state = "engine"

/area/engine/chiefs_office
	name = "\improper Chief Engineer's office"
	icon_state = "engine_control"

/area/engine/secure_construction
	name = "\improper Secure Construction Area"
	icon_state = "engine"

/area/engine/gravity_generator
	name = "Gravity Generator Room"
	icon_state = "blue"


//Solars

/area/solar
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

	auxport
		name = "\improper Fore Port Solar Array"
		icon_state = "panelsA"

	auxstarboard
		name = "\improper Fore Starboard Solar Array"
		icon_state = "panelsA"

	fore
		name = "\improper Fore Solar Array"
		icon_state = "yellow"

	aft
		name = "\improper Aft Solar Array"
		icon_state = "aft"

	starboard
		name = "\improper Aft Starboard Solar Array"
		icon_state = "panelsS"

	port
		name = "\improper Aft Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Fore Port Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/starboardsolar
	name = "Aft Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Aft Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Fore Starboard Solar Maintenance"
	icon_state = "SolarcontrolA"

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod4/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/specops/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod4/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
//	/area/shuttle/transport2/station,	//not present on map
	/area/shuttle/specops/station,
	/area/maintenance,
	/area/hallway,
//	/area/mint,		//not present on map
	/area/engine,
	/area/solar
)
