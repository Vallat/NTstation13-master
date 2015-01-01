
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
var/const/HERMIT			=(1<<14)
var/const/ACTOR				=(1<<15)
var/const/BARBER			=(1<<16)
var/const/TESLAB			=(1<<17)
var/const/TESLAO			=(1<<18)
var/const/TESLAS			=(1<<19)
var/const/TESLAC			=(1<<20)


var/list/assistant_occupations = list(
	"Assistant",
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
	"Alchemist"
)


var/list/science_positions = list(
	"Scientist",
	"Roboticist"
)


var/list/civilian_positions = list(
	"Gouverner",
	"Bartender",
	"Botanist",
	"Chef",
	"Janitor",
	"Librarian",
	"Trader",
	"Trade Worker",
	"Shaft miner",
	"Lawyer",
	"Chaplain",
	"Hermit",
	"Bandit",
	"Actor",
	"Worker",
	"Barber"
)


var/list/security_positions = list(
	"Sheriff",
	"Warden",
	"Detective",
	"Officer"
)


var/list/nonhuman_positions = list(
	"Cyborg"
)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))
