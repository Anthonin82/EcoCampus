extends Prop

@onready var teleporter = find_child("Teleporter")

func interact():
	Dialogic.VAR.city.completed = game.getLevel().isCompleted()
	await awaitShowDialogs()
	if Dialogic.VAR.city.flatTeleport:
		teleporter.teleport()
		Dialogic.VAR.city.flatTeleport = false
