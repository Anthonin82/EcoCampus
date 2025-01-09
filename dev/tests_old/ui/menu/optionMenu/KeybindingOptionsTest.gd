# GdUnit generated TestSuite
class_name OptionsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://ui/menu/optionMenu/KeybindOptions.gd'

var optionWindowRunner :GdUnitSceneRunner
var inputList: VBoxContainer

func before_test() -> void:
	optionWindowRunner = scene_runner("res://ui/menu/optionMenu/KeybindingOptions.tscn")	
	inputList = optionWindowRunner.find_child("InputList")


func after_test() -> void: 
	# to avoid saving change to ui_up add dependencies to other tests
	optionWindowRunner.simulate_key_pressed(KEY_UP)


func test_addBinding_whenYouAddOneBindingToInputList_SizePlusOne() -> void:
	var size := inputList.get_child_count()
	inputList.addBinding("UI up", "ui_up")
	assert_int(inputList.get_child_count()).is_equal(size + 1)


func test_addBinding_whenYouAddTwoBindingsToInputList_SizePlusTwo() -> void:
	var size := inputList.get_child_count()
	inputList.addBinding("UI up", "ui_up")
	inputList.addBinding("UI down", "ui_down")
	assert_int(inputList.get_child_count()).is_equal(size + 2)


func test_addBinding_whenYouAddBindingMoveUp_LabelIsMoveUp() -> void:
	inputList.addBinding("UI up", "ui_up")
	var labelArray = inputList.get_child(-1).find_children("*", "Label", true, false)
	assert_array(labelArray).has_size(1)
	assert_str(labelArray[0].text).is_equal_ignoring_case("ui up")


func test_addBinding_whenYouAddBindingForInexistantInputAction_ThrowError() -> void:
	await assert_error(func(): inputList.addBinding("UI up", "kleubeuskeufeu")).is_push_error("Your trying to add an input for kleubeuskeufeu but no corresponding input action was found")


func test_addBinding_whenYouAddBindingForExistantInputAction_DontThrowError() -> void:
	await assert_error(func(): inputList.addBinding("UI up", "ui_up")).is_success()


func test_typeFutureKeyForActionDontDoTheAction() -> void:
	optionWindowRunner.simulate_key_pressed(KEY_0)
	assert_bool(Input.is_action_just_pressed("ui_up")).is_false()


func test_buttonTextIsCurrentKeyForAction() -> void:
	inputList.addBinding("UI up", "ui_up")
	var button = inputList.get_child(-1).find_children("*", "Button", true, false)[0]
	assert_str(button.text).is_equal_ignoring_case("Up")


func test_clicButtonChangeTextToWaitingInput() -> void:
	var button = await clicOnBindingButton()
	assert_str(button.text).contains_ignoring_case("appuyez sur une touche")


func test_clicButtonChangeTextToNewInput() -> void:
	var button = await clicOnBindingButton()
	optionWindowRunner.simulate_key_pressed(KEY_0)
	await await_idle_frame()
	assert_str(button.text).contains_ignoring_case("0")


func test_clicButtonChangeKeybindToNewAction() -> void:
	await clicOnBindingButton()
	optionWindowRunner.simulate_key_pressed(KEY_0)
	await await_idle_frame()
	optionWindowRunner.simulate_key_pressed(KEY_0)
	assert_bool(Input.is_action_just_pressed("move_up")).is_true()


func test_clickRestoreDefaultSettingsButtonChangeButtonText() -> void:
	# set first input to 0 key
	var button = inputList.get_child(0).find_children("*", "Button", true, false)[0]
	await await_idle_frame() # to load the UI, without this line button.get_global_position() returns 0,0
	optionWindowRunner.set_mouse_pos(button.get_global_position())
	optionWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	optionWindowRunner.simulate_key_pressed(KEY_0)
	await await_idle_frame()
	assert_str(button.text).contains_ignoring_case("0")
	
	var restoreDefaultButton = optionWindowRunner.find_child("restoreToDefaultButton")
	await await_idle_frame()
	optionWindowRunner.set_mouse_pos(restoreDefaultButton.get_global_position())
	optionWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	button = inputList.get_child(0).find_children("*", "Button", true, false)[0]
	assert_str(button.text).contains_ignoring_case("q")


func test_clickRestoreDefaultSettingsButtonRestoreDefaultSettings() -> void:
	# set first input to 0 key
	var button = inputList.get_child(0).find_children("*", "Button", true, false)[0]
	await await_idle_frame() # to load the UI, without this line button.get_global_position() returns 0,0
	optionWindowRunner.set_mouse_pos(button.get_global_position())
	optionWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	optionWindowRunner.simulate_key_pressed(KEY_0)
	optionWindowRunner.simulate_key_pressed(KEY_0)
	assert_bool(Input.is_action_just_pressed("move_left")).is_true()
	
	
	var restoreDefaultButton = optionWindowRunner.find_child("restoreToDefaultButton")
	await await_idle_frame()
	optionWindowRunner.set_mouse_pos(restoreDefaultButton.get_global_position())
	optionWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	optionWindowRunner.simulate_key_pressed(KEY_Q)
	assert_bool(Input.is_action_just_pressed("move_left")).is_true()


func clicOnBindingButton():
	inputList.addBinding("TEST UP", "move_up")
	var button = inputList.get_child(-1).find_children("*", "Button", true, false)[0]
	await await_idle_frame() # to load the UI, without this line button.get_global_position() returns 0,0
	optionWindowRunner.set_mouse_pos(button.get_global_position())
	optionWindowRunner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	return button
	
