extends Prop


func interact():
	Dialogic.VAR.amphi.speechCompleted = game.getLevel().getMission("stageSpeech").isCompleted()
	if !Dialogic.VAR.amphi.speechCompleted:
		game.getPlayer().teleport(self.global_position)
	await awaitShowDialogs()
	if !game.getLevel().getMission("stageSpeech").isCompleted():
		game.getLevel().getMission("stageSpeech").complete()


func save() -> Dictionary:
	return {"speechCompleted": Dialogic.VAR.amphi.speechCompleted,"playerSpeech":Dialogic.VAR.amphi.playerSpeech}


func load(propList:Dictionary) -> void:
	Dialogic.VAR.amphi.speechCompleted = propList["speechCompleted"]
	Dialogic.VAR.amphi.playerSpeech = propList["playerSpeech"]
	if Dialogic.VAR.amphi.speechCompleted:
		game.getLevel().getMission("stageSpeech").complete()
