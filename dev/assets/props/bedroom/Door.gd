extends Prop

@onready var teleporter = find_child("Teleporter")

func interact():
	Dialogic.VAR.bedroom.completed = game.getLevel().isCompleted()
	await awaitShowDialogs()
	if Dialogic.VAR.bedroom.teleport:
		teleporter.teleport()
		Dialogic.VAR.bedroom.teleport = false

func save() -> Dictionary:
	return {"completed":Dialogic.VAR.bedroom.completed,"RadiatorMission":game.getLevel().getMission("radiator").isCompleted(),"WashedMission":game.getLevel().getMission("wash").isCompleted()}
	
func load(propList:Dictionary)  -> void:
	Dialogic.VAR.bedroom.completed = propList["completed"]
