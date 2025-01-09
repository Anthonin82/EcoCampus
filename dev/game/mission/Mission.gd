extends Control
class_name Mission

var title :String
var description: String
var advancedDescription :String
var compulsory: Compulsory

var completed := false
var choices :Dictionary
var playerChoice :Choice
var playerChoiceId :String

var _init := false

@onready var game = find_parent("Game")
@onready var label:Label = find_child("Label")

enum Compulsory {COMPULSORY, OPTIONAL}

func init(_title :String, _description :String, _advancedDescription :String, _compulsory :Compulsory):
	_init = true
	title = _title
	description = _description
	advancedDescription = _advancedDescription
	compulsory = _compulsory
	return self
	
func _ready():
	assert(game != null)
	assert(label != null)
	assert(_init)
	label.text = title
	
func addChoice(id :String, choice :Choice):
	choices[id] = choice

func setChoice(id :String):
	assert(!completed, "Your are trying to change a choice for an already completed mission")
	assert(choices.has(id))
	playerChoice = choices[id]
	playerChoiceId = id
	
func isCompulsory() -> bool:
	return compulsory == Compulsory.COMPULSORY
	
func isCompleted() -> bool:
	return completed
	
func getTitle() -> String:
	return title
	
func getDescription() -> String:
	return description
	
func getAdvancedDescription() -> String:
	return advancedDescription

func complete() -> void:
	completed = true
	if compulsory == Compulsory.COMPULSORY:
		label.set("theme_override_colors/font_color", Color.GREEN)
	else:
		label.set("theme_override_colors/font_color", Color.GOLD)
		show()

func getPlayerChoice() -> Choice:
	return playerChoice

func getPlayerChoiceId() -> String:
	return playerChoiceId


func getBestChoice() -> Choice:
	var bestChoice = choices.values()[0]
	var consumptionType = choices.values()[0].choicesConsumptionType[0]
	for choice in choices.values():
		if choice.getConsumption(consumptionType) < bestChoice.getConsumption(consumptionType):
			bestChoice = choice
	return bestChoice
		
