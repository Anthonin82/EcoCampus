extends Node2D

@onready var game = find_parent("Game")

func _ready() -> void:
	
	if !find_parent("Game").find_child("Options",true,true):
		find_parent("Game").loadUI(preload("res://ui/menu/optionMenu/Options.tscn").instantiate())
		find_parent("Game").addUI(preload("res://inventory/InventoryUI.tscn").instantiate())
	game.addMissionFromJson("amphitheater")
