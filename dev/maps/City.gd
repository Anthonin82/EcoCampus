extends Node

@onready var game = find_parent("Game")

func _ready() -> void:
	var skip := false
	if SaveManager.getElement("City","introDone") == null:
		SaveManager.setElement("City",{"introDone":false})
	if SaveManager.getElement("Player","lastCarInfos") == null:
		SaveManager.setElement("Player",{"lastCarInfos" : {"id": "PlayerCar", "map": "City"}})
	skip = SaveManager.getElement("City","introDone")
	
	if !find_parent("Game").find_child("Options",true,true):
		find_parent("Game").loadUI(preload("res://ui/menu/optionMenu/Options.tscn").instantiate())
		find_parent("Game").addUI(preload("res://inventory/InventoryUI.tscn").instantiate())

	if !skip:
		waitForIntroduction()
	game.addMissionFromJson("city")


func waitForIntroduction() -> void:
	await get_tree().create_timer(3.0).timeout
	Dialogic.start_timeline("CityIntroduction")
	SaveManager.setElement("City",{"introDone":true})
