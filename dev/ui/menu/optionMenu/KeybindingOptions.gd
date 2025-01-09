extends VBoxContainer

var config = ConfigFile.new()
const CONFIG_FILE_PATH = "user://settings.ini"
const DEFAULT_CONFIG_FILE_PATH = "res://ui/menu/optionMenu/default.ini"

var isWaitingForInput := false
var remapedAction :String
var remapedButton
var inputAction2Text = {
	"move_left": "Gauche",
	"move_right": "Droite",
	"move_up": "Haut",
	"move_down": "Bas",
	"interact": "Intéragir",
	"show_menu": "Menu options",
	"inventory": "Inventaire"
}

func _ready():
	if FileAccess.file_exists(CONFIG_FILE_PATH):
		config.load(CONFIG_FILE_PATH)
	else: # cannot be tested because we cannot delete the config file before the test
		config.load(DEFAULT_CONFIG_FILE_PATH)
	updateKeybindFromConfig()
	updateLabels()


func updateLabels():
	emptyBindings()
	for inputAction in config.get_section_keys("keybinding"):
		var text = inputAction2Text.get(inputAction)
		if text == null:
			push_warning("no text equivalent to inputAction %s was found in inpuAction2Text" % inputAction)
			text = inputAction
		addBinding(text, inputAction)


func updateKeybindFromConfig():
	for inputAction in config.get_section_keys("keybinding"):
		InputMap.action_erase_events(inputAction)
		var event := InputEventKey.new()
		event.keycode = config.get_value("keybinding", inputAction)
		InputMap.action_add_event(inputAction, event)


func addBinding(actionString: String, inputAction: String) -> void:	
	if !InputMap.has_action(inputAction):
		push_error("Your trying to add an input for %s but no corresponding input action was found" % inputAction)
		return;
	var inputLine := HBoxContainer.new()
	var label := Label.new()
	var button := Button.new()
	button.text = InputMap.action_get_events(inputAction)[0].as_text()
	button.pressed.connect(onInputButtonPressed.bind(button, inputAction))
	label.text = actionString
	inputLine.add_child(label)
	inputLine.add_child(button)
	add_child(inputLine)


func onInputButtonPressed(button, inputAction):
	if !isWaitingForInput:
		remapedAction = inputAction
		remapedButton = button
		button.text = "Appuyez sur une touche"
		isWaitingForInput = true


func _input(event):
	if isWaitingForInput && event is InputEventKey:
		InputMap.action_erase_event(remapedAction, InputMap.action_get_events(remapedAction)[0])
		InputMap.action_add_event(remapedAction, event)
		remapedButton.text = event.as_text()
		isWaitingForInput = false
		config.set_value("keybinding", remapedAction, event.keycode)
		config.save(CONFIG_FILE_PATH)


func _on_restore_to_default_button_pressed():
	assert(FileAccess.file_exists(DEFAULT_CONFIG_FILE_PATH))
	config.clear()
	config.load(DEFAULT_CONFIG_FILE_PATH)
	config.save(CONFIG_FILE_PATH)
	updateKeybindFromConfig()
	updateLabels()


func emptyBindings() -> void:
	for inputListLine in get_children():
		inputListLine.queue_free()
