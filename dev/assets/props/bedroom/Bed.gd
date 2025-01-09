extends Prop

@export var deltaHead:Vector2

func interact():
	if !Dialogic.VAR.bedroom.isSleeping:
		await awaitShowDialogs()
		if !Dialogic.VAR.bedroom.alreadySlept && Dialogic.VAR.bedroom.isSleeping: 
			game.getPlayer().sleep(global_position+deltaHead)
			Dialogic.VAR.bedroom.alreadySlept = true
	else:
		game.getPlayer().unsleep()
		Dialogic.VAR.bedroom.isSleeping = false

func save():
	return {"Bed":{"Slept":Dialogic.VAR.bedroom.alreadySlept}}
	
func load(propList):
	Dialogic.VAR.bedroom.alreadySlept = propList["Bed"]["Slept"]
