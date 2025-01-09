extends Prop

@export var deltaHead:Vector2

@onready var blurSprite = $Blur
var showerUsed = false

func interact():
	if !Dialogic.VAR.bedroom.showerOn:
		await awaitShowDialogs()
		if !Dialogic.VAR.bedroom.alreadyWashed && Dialogic.VAR.bedroom.showerOn:
			game.getLevel().getMission("wash").setChoice("shower")
			game.getLevel().getMission("wash").complete()
			game.getPlayer().sleep(global_position + deltaHead)
			animatedSprite.play("showerOn")
			blurSprite.visible = true
			showerUsed = true
			Dialogic.VAR.bedroom.alreadyWashed = true
	else:
		game.getPlayer().unsleep()
		blurSprite.visible = false
		animatedSprite.play("default")


func save() -> Dictionary:
	return {"Shower":{"ShowerUsed":showerUsed,"Washed":Dialogic.VAR.bedroom.alreadyWashed}}


func load(propList:Dictionary) -> void:
	showerUsed = propList["Shower"]["ShowerUsed"]
	Dialogic.VAR.bedroom.alreadyWashed = propList["Shower"]["Washed"]
	
	if propList["WashedMission"]:
		if showerUsed:
			game.getLevel().getMission("wash").setChoice("shower")
			game.getLevel().getMission("wash").complete()
