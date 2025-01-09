extends Prop

@onready var teleporter = find_child("Teleporter")

func interact():
	await awaitShowDialogs()
	if Dialogic.VAR.campus.amphiTeleport:
		teleporter.teleport()
		Dialogic.VAR.campus.amphiTeleport = false
