# GdUnit generated TestSuite
class_name RadiatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://assets/props/bedroom/Radiator.gd'

var gameRunner :GdUnitSceneRunner
var testLevel :Level
var game :Node2D

func before_test() -> void:
	SaveManager.deleteSave()
	Dialogic.VAR.reset() # Otherwise Dialogic variables values are kept from one test to another
	gameRunner = scene_runner("res://game/Game.tscn")
	testLevel = preload("res://game/Level.tscn").instantiate().init(preload("res://tests/assets/props/bedroom/RadiatorTestLevel.tscn"))
	game = gameRunner.find_child("*").get_parent() as Game
	game.deleteCurrentUI()
	game.loadLevel(testLevel)
	
func after_test() -> void:
	SaveManager.deleteSave()
	Dialogic.VAR.reset() # Otherwise Dialogic variables values are kept from one test to another
	if is_instance_valid(testLevel):
		testLevel.queue_free()

func test_onSecondInteractionGameDontCrash() -> void:
	await await_millis(20)
	gameRunner.simulate_action_pressed("interact")
	await await_millis(3000) # wait for text to be displayed
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(20) # wait for dialogue to close
	gameRunner.simulate_action_pressed("interact")
	await await_millis(3000) # wait for dialogue to be displayed
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(20) # wait for dialogue to closed
	# game should not crash
	
func test_afterDialoguesMissionCompleted() -> void:
	await await_millis(20)
	assert_bool(testLevel.getMission("radiator").isCompleted()).is_false()
	await await_idle_frame()
	gameRunner.simulate_action_pressed("interact")
	await await_millis(3000) # wait for text to be displayed
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(20) # wait for dialogue to close
	assert_bool(testLevel.getMission("radiator").isCompleted()).is_true()
	
func test_completeMissionAddOptionalMissionToDisplay() -> void:
	await await_millis(20)
	assert_int(testLevel.find_child("OptionalMissions").get_child_count()).is_equal(1)
	assert_bool(testLevel.find_child("OptionalMissions").get_child(0).visible).is_false()
	await await_idle_frame()
	gameRunner.simulate_action_pressed("interact")
	await await_millis(3000) # wait for text to be displayed
	gameRunner.simulate_key_pressed(KEY_ENTER)
	await await_millis(20) # wait for dialogue to close
	assert_int(testLevel.find_child("OptionalMissions").get_child_count()).is_equal(1)
	assert_bool(testLevel.find_child("OptionalMissions").get_child(0).visible).is_true()
