
var/const/ENGSEC			=(1<<0)

var/const/HOS				=(1<<0)
var/const/WARDEN			=(1<<1)
var/const/DETECTIVE			=(1<<2)
var/const/OFFICER			=(1<<3)
var/const/CHIEF				=(1<<4)
var/const/ENGINEER			=(1<<5)
var/const/ATMOSTECH			=(1<<6)
var/const/ROBOTICIST		=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)


var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)


var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/ASSISTANT			=(1<<13)


var/list/assistant_occupations = list(
	"Assistant",
	"Atmospheric Technician",
	"Cargo Technician",
	"Chaplain",
	"Lawyer",
	"Librarian"
)


var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"
)


var/list/engineering_positions = list(
	"CE",
	"Steam Engineer",
	"Steam and energy master",
)


var/list/medical_positions = list(
	"CMO",
	"Doctor",
	"Geneticist",	//Part of both medical and science
	"Virologist",
	"Alchemist"
)


var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Geneticist",	//Part of both medical and science
	"Roboticist"
)


var/list/civilian_positions = list(
	"Gouverner",
	"bartender",
	"botanist",
	"chef",
	"Janitor",
	"Librarian",
	"Trader",
	"Trade Worker",
	"Shaft miner",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
	"Worker"
)


var/list/security_positions = list(
	"Head of Police",
	"Warden",
	"Detective",
	"Officer"
)


var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))
