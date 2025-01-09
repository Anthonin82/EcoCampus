# GdUnit generated TestSuite
class_name OptionsRootTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://ui/menu/optionMenu/Options.gd'

var gameWindowRunner :GdUnitSceneRunner
var gameScript :Node
var optionsRoot :Node

func before_test() -> void:
	gameWindowRunner = scene_runner("res://game/Game.tscn")
	gameScript = gameWindowRunner.scene()
	gameScript.loadLevel(preload("res://game/Level.tscn").instantiate().init(preload("res://maps/Bedroom.tscn")))
	gameScript.loadUI(preload("res://ui/menu/optionMenu/Options.tscn").instantiate())
	optionsRoot = gameWindowRunner.find_child("UI").get_child(0)
	
func test_onEscapeButtonPressed_menuAppear() -> void:
	await await_idle_frame()
	gameWindowRunner.simulate_action_pressed("show_menu")
	assert_bool(optionsRoot.visible).is_true()
	
func test__on_close_button_pressed() -> void:
	gameWindowRunner.simulate_action_pressed("show_menu")
	var closeButton = gameWindowRunner.find_child("closeButton")
	await await_idle_frame()
	gameWindowRunner.set_mouse_pos(closeButton.get_global_position())
	await await_idle_frame()
	gameWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	assert_bool(optionsRoot.visible).is_false()
	
func test_onGameStart_optionsAreHidden() -> void:
	assert_bool(optionsRoot.visible).is_false()	
	
