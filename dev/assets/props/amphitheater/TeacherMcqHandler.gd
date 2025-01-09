extends Prop

var mcqMark: int = 0

func _ready():
	super._ready()
	Dialogic.signal_event.connect(_on_dialogic_signal)


func interact():
	Dialogic.VAR.amphi.mcqCompleted = game.getLevel().getMission("doMCQ").isCompleted()
	await awaitShowDialogs()
	if !game.getLevel().getMission("doMCQ").isCompleted():
		game.getLevel().getMission("doMCQ").complete()


func save() -> Dictionary:
	return {"mcqCompleted": Dialogic.VAR.amphi.mcqCompleted}


func load(propList:Dictionary) -> void:
	Dialogic.VAR.amphi.mcqCompleted = propList["mcqCompleted"]
	if Dialogic.VAR.amphi.mcqCompleted:
		game.getLevel().getMission("doMCQ").complete()


func _on_dialogic_signal(argument:String):
	if argument == "qcm_finished":
		for i in range(1, 11):  # q1 to q10
			var key = "q" + str(i)  # Create the property name as a string
			if Dialogic.VAR.amphi.has(key) and Dialogic.VAR.amphi[key]:
				mcqMark += 1
		Dialogic.VAR.amphi.mcqMark = mcqMark
