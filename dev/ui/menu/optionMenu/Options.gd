extends Control

@onready var game = find_parent("Game")

func _ready():
	hide()
	if SaveManager.scorm.isGameOnMoodle():
		$"MarginContainer/PanelContainer/VBoxContainer/CenterContainer/HBoxContainer/quitButton".hide()


func _on_close_button_pressed():
	hide()
	game.unpause()


func _unhandled_input(event):
	if event.is_action_released("show_menu") and Dialogic.current_timeline == null:
		if is_visible_in_tree():
			hide()
			if !game.inventoryOpened:
				game.unpause()
			game.optionsOpened = false
		else:
			show()
			game.pause()
			game.optionsOpened = true


func _on_quit_button_pressed():
	game.quit()


func _on_delete_save_button_pressed() -> void:
	SaveManager.deleteSave()
	if SaveManager.scorm.isGameOnMoodle():
		JavaScriptBridge.eval("window.location.reload();")
	else:
		find_parent("Game").quit()
	
