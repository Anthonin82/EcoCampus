extends Node2D

@onready var game = find_parent("Game")

func _ready() -> void:
	var skip := false
	if SaveManager.getElement("Campus","introDone") == null:
		SaveManager.setElement("Campus",{"introDone":false})
	skip = SaveManager.getElement("Campus","introDone")
	if !skip:
		waitForIntroduction()
	game.addMissionFromJson("campus")

	if !find_parent("Game").find_child("Options",true,true):
		find_parent("Game").loadUI(preload("res://ui/menu/optionMenu/Options.tscn").instantiate())
		find_parent("Game").addUI(preload("res://inventory/InventoryUI.tscn").instantiate())


func waitForIntroduction() -> void:
	await get_tree().create_timer(3.0).timeout
	Dialogic.start_timeline("CampusIntroduction")
	SaveManager.setElement("Campus",{"introDone":true})
