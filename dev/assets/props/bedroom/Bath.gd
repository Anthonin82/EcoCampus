extends Prop

@export var deltaHead:Vector2
var bathUsed = false

func interact():
	if !Dialogic.VAR.bedroom.bathOn:
		await awaitShowDialogs()
		if !Dialogic.VAR.bedroom.alreadyWashed && Dialogic.VAR.bedroom.bathOn:
			game.getLevel().getMission("wash").setChoice("bath")
			game.getLevel().getMission("wash").complete()
			game.getPlayer().sleep(global_position + deltaHead)
			Dialogic.VAR.bedroom.alreadyWashed = true
			animatedSprite.play("filling")
			bathUsed = true
			await animatedSprite.animation_finished
			animatedSprite.play("full")
	else:
		Dialogic.VAR.bedroom.bathOn = false
		animatedSprite.play("empty")
		game.getPlayer().unsleep()


func save() -> Dictionary:
	return {"Bath":{"BathUsed":bathUsed,"Washed":Dialogic.VAR.bedroom.alreadyWashed}}
	
func load(propList:Dictionary) -> void:
	bathUsed = propList["Bath"]["BathUsed"]
	Dialogic.VAR.bedroom.alreadyWashed = propList["Bath"]["Washed"]
	if propList["WashedMission"]:
		if bathUsed:
			game.getLevel().getMission("wash").setChoice("bath")
			game.getLevel().getMission("wash").complete()
