extends Prop
class_name MultiDestinationTeleporter

@onready var teleporter = find_child("Teleporter")
@export var destinations: Array[tpInfos] = []

func _ready() -> void:
	super._ready()
	# Only way to be sure the array hasn't too many destinations for the current dialogue options (4 directions)
	destinations = destinations.slice(0,4) 


func interact():
	updateDestinations()
	await awaitShowDialogs()
	if int(Dialogic.VAR.destinations.choice) != -1: # for some reasons Dialogic won't let me use an int
		teleporter.destTpInfos = destinations[int(Dialogic.VAR.destinations.choice)]
		teleporter.teleport()
		InteractionManager.unregisterArea(self) # with tp the prop wasn't removed properly
	resetDestinations()


func updateDestinations():
	# check for each 4 possible destination if it's not null
	# Dialogic will handle the hiding of destination if equal to ''
	if destinations[0]:
		Dialogic.VAR.destinations.destinationA = destinations[0].destinationName
	if destinations[1]:
		Dialogic.VAR.destinations.destinationB = destinations[1].destinationName
	if destinations[2]:
		Dialogic.VAR.destinations.destinationC = destinations[2].destinationName
	if destinations[3]:
		Dialogic.VAR.destinations.destinationD = destinations[3].destinationName


func resetDestinations():
	Dialogic.VAR.destinations.destinationA = ''
	Dialogic.VAR.destinations.destinationB = ''
	Dialogic.VAR.destinations.destinationC = ''
	Dialogic.VAR.destinations.destinationD = ''
	Dialogic.VAR.destinations.choice = -1.0
