# GdUnit generated TestSuite
class_name GameTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://game/Game.gd'

var gameRunner :GdUnitSceneRunner
var rootNode :Node2D
var testLevel :Level
var testUI :Control

func before_test() -> void:
	SaveManager.deleteSave()
	gameRunner = scene_runner("res://game/Game.tscn")
	rootNode = gameRunner.find_child("*").get_parent()
	testLevel = preload("res://game/Level.tscn").instantiate().init(preload("res://maps/Bedroom.tscn"))
	testUI = preload("res://ui/menu/optionMenu/Options.tscn").instantiate()
	
func after_test() -> void:
	if is_instance_valid(testLevel):
		testLevel.queue_free()
	if is_instance_valid(testUI):
		testUI.queue_free()
	SaveManager.deleteSave()	

func test_loadLevel_oneTime_oneLevel() -> void:
	rootNode.loadLevel(testLevel)
	assert_int(rootNode.find_child("Level").get_child_count()).is_equal(1)

func test_loadLevel_twoTime_oneLevel() -> void:
	rootNode.loadLevel(testLevel)
	rootNode.loadLevel(testLevel)
	assert_int(rootNode.find_child("Level").get_child_count()).is_equal(1)
	
func test_loadUI_oneTime_oneUI() -> void:
	rootNode.loadUI(testUI)
	assert_int(rootNode.find_child("UI").get_child_count()).is_equal(1)

func test_loadUI_twoTime_oneUI() -> void:
	rootNode.loadUI(testUI)
	rootNode.loadUI(testUI)	
	assert_int(rootNode.find_child("UI").get_child_count()).is_equal(1)

func test_afterGameLaunchNoDuplicateLevel() -> void:
	await launchGame()
	assert_int(rootNode.find_children("*", "Level", true, false).size()).is_equal(1)
	
func test_afterGameLaunchNoDuplicatePlayer() -> void:
	await launchGame()
	assert_int(rootNode.find_children("*", "Player").size()).is_equal(1)	
	
func launchGame() -> void:
	rootNode.loadUI(preload("res://maps/DressingRoom.tscn").instantiate())
	var playBtn = rootNode.find_child("playBtn", true, false)
	gameRunner.set_mouse_pos(playBtn.position)
	SaveManager.setElement("Player",{"startPosX":88,"startPosY":40})
	gameRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	await await_idle_frame()
	
	
func test_canLaunchGameAndGoToLevelCity():
	SaveManager.setElement("Tutorial",{"done":true})
	await launchGame()
	gameRunner.simulate_action_press("move_left")
	await await_millis(500)
	gameRunner.simulate_action_release("move_left")
	gameRunner.simulate_action_press("move_up")
	await await_millis(900)
	gameRunner.simulate_action_release("move_up")
	gameRunner.simulate_action_press("move_left")
	await await_millis(1100)
	gameRunner.simulate_action_release("move_left")
	await await_idle_frame()
	gameRunner.simulate_action_pressed("interact")
	await await_millis(700)
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(3500)
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(1000)
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(4000)
	gameRunner.simulate_action_press("move_right")
	await await_millis(500)
	gameRunner.simulate_action_release("move_right")
	gameRunner.simulate_action_press("move_down")
	await await_millis(1000)
	gameRunner.simulate_action_release("move_down")
	gameRunner.simulate_action_press("move_left")
	await await_millis(200)
	gameRunner.simulate_action_release("move_left")
	gameRunner.simulate_action_press("move_down")
	await await_millis(2000)
	gameRunner.simulate_action_release("move_down")
	gameRunner.simulate_action_press("move_right")
	await await_millis(500)
	gameRunner.simulate_action_release("move_right")
	await await_millis(500)
	gameRunner.simulate_action_pressed("interact")
	await await_millis(5000)
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(20)
	gameRunner.simulate_action_pressed("interact")
	gameRunner.simulate_action_press("move_left")
	await await_millis(500)
	gameRunner.simulate_action_release("move_left")
	gameRunner.simulate_action_press("move_up")
	await await_millis(2000)
	gameRunner.simulate_action_release("move_up")
	gameRunner.simulate_action_press("move_right")
	await await_millis(500)
	gameRunner.simulate_action_release("move_right")
	gameRunner.simulate_action_press("move_up")
	await await_millis(500)
	gameRunner.simulate_action_release("move_up")
	gameRunner.simulate_action_press("move_left")
	await await_millis(500)
	gameRunner.simulate_action_release("move_left")
	gameRunner.simulate_action_press("move_up")
	await await_millis(500)
	gameRunner.simulate_action_release("move_up")
	gameRunner.simulate_action_pressed("interact")
	await await_millis(2000)
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(8000)
	gameRunner.set_mouse_pos(gameRunner.find_child("LoadButton").get_global_position())
	await await_idle_frame()
	gameRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	assert_bool(gameRunner.find_child("City") != null).is_true()
