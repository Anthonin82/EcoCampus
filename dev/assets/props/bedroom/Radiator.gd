extends Prop

func interact():
	await awaitShowDialogs()
	if !Dialogic.VAR.bedroom.radiatorLessOneDegree:
		animatedSprite.play("on")
		game.getLevel().getMission("radiator").setChoice("radiatorNormal")
	else:
		if !game.getLevel().getMission("radiator").isCompleted():
			animatedSprite.play("off")
			game.getLevel().getMission("radiator").setChoice("radiatorLessOneDegree")
			game.getLevel().getMission("radiator").complete()
			Dialogic.start("HiddenMission")


func save() -> Dictionary:
	return {"Radiator":{"RadiatorLessOneDegree":Dialogic.VAR.bedroom.radiatorLessOneDegree}}


func load(propList:Dictionary) -> void:
	Dialogic.VAR.bedroom.radiatorOn = !propList["Radiator"]["RadiatorLessOneDegree"]
	Dialogic.VAR.bedroom.radiatorLessOneDegree = propList["Radiator"]["RadiatorLessOneDegree"]

	if !Dialogic.VAR.bedroom.radiatorLessOneDegree:
		animatedSprite.play("on")
	else:
		animatedSprite.play("off")
	
	if propList["RadiatorMission"] && propList["Radiator"]["RadiatorLessOneDegree"]:
		game.getLevel().getMission("radiator").setChoice("radiatorLessOneDegree")
		game.getLevel().getMission("radiator").complete()
	else:
		game.getLevel().getMission("radiator").setChoice("radiatorNormal")
