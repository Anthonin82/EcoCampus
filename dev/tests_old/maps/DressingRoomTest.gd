# GdUnit generated TestSuite
class_name DressingRoomTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://maps/scripts/DressingRoom.gd'

var gameRunner :GdUnitSceneRunner

func before_test() -> void:
	gameRunner = scene_runner("res://game/Game.tscn")
	SaveManager.deleteSave()
	

func test__on_play_btn_pressed() -> void:
	var playBtn = gameRunner.find_child("playBtn")
	gameRunner.set_mouse_pos(playBtn.get_global_position() + playBtn.size/2)
	gameRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	assert_str(gameRunner.find_child("Bedroom").name).is_equal_ignoring_case("Bedroom")
