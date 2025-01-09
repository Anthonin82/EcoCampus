extends Prop

@onready var teleporter = find_child("Teleporter")

func interact():
	Dialogic.VAR.amphi.completed = game.getLevel().isCompleted()
	await awaitShowDialogs()
	if Dialogic.VAR.amphi.exit:
		teleporter.teleport()
		Dialogic.VAR.amphi.exit = false
