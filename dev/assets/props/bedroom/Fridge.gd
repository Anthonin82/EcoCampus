extends Prop

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


func interact():
	Dialogic.VAR.bedroom.breakfastMissionCompleted = game.getLevel().getMission("breakfast").isCompleted()
	await awaitShowDialogs()
	if Dialogic.VAR.bedroom.breakfastChoosen != "" && !game.getLevel().getMission("breakfast").isCompleted():
		game.getLevel().getMission("breakfast").setChoice(Dialogic.VAR.bedroom.breakfastChoosen)
		game.getLevel().getMission("breakfast").complete()
		await game.getPlayer().awaitEat()
		
func save() -> Dictionary:
	return {"Breakfast":{"breakfastMissionCompleted":Dialogic.VAR.bedroom.breakfastMissionCompleted,"breakfastChoosen":Dialogic.VAR.bedroom.breakfastChoosen}}
	
func load(propList:Dictionary) -> void:
	Dialogic.VAR.bedroom.breakfastMissionCompleted = propList["Breakfast"]["breakfastMissionCompleted"]
	Dialogic.VAR.bedroom.breakfastChoosen = propList["Breakfast"]["breakfastChoosen"]
	if Dialogic.VAR.bedroom.breakfastChoosen != "":
		game.getLevel().getMission("breakfast").setChoice(Dialogic.VAR.bedroom.breakfastChoosen)
		game.getLevel().getMission("breakfast").complete()


func _on_dialogic_signal(argument:String):
	if argument == "open_fridge":
		animatedSprite.play("opening")
	elif argument == "close_fridge":
		animatedSprite.play_backwards("opening")
