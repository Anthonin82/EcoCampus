extends PanelContainer

@onready var vsyncCheckButton : CheckButton = find_child("VSync")
@onready var fullScreenCheckButton : CheckButton = find_child("FullScreen")
var previousWindowMode : DisplayServer.WindowMode

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullScreenCheckButton.button_pressed = true
		previousWindowMode = DisplayServer.WINDOW_MODE_MAXIMIZED
	else:
		previousWindowMode = DisplayServer.window_get_mode()
		fullScreenCheckButton.button_pressed = false
		
	vsyncCheckButton.button_pressed = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
		
	
		
		

func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		previousWindowMode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(previousWindowMode)
		
		


func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
