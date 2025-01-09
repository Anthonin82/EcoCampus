extends Control

@onready var goodChoicesVBox:VBoxContainer = find_child("GoodChoices")
@onready var badChoicesVBox:VBoxContainer = find_child("BadChoices")
@onready var loadButton:Button = find_child("LoadButton")
@onready var progressBar:ProgressBar = find_child("ProgressBar")
var _init := false
var level:Level

var loading_status : int
var progress : Array[float]

var nextLevelPath:String

func init(_level:Level, _nextLevelPath:String):
	_init = true
	nextLevelPath = _nextLevelPath
	level = _level
	return self

func _ready():
	assert(_init)
	assert(goodChoicesVBox != null)
	assert(badChoicesVBox != null)
	assert(loadButton != null)
	assert(progressBar != null)
	loadButton.disabled = true
	loadNextLevel()
	for mission in level.getMissions():
		if mission.getPlayerChoice() != null:
			var endLevelCard := preload("res://game/mission/EndLevelCard.tscn").instantiate()
			if mission.getPlayerChoice().isGood():
				goodChoicesVBox.add_child(endLevelCard.init(mission.getPlayerChoice().getDescription(), mission.getDescription(), true, mission.getAdvancedDescription()))
			else:
				endLevelCard.init(mission.getPlayerChoice().getDescription(), mission.getDescription(), false, mission.getAdvancedDescription())
				endLevelCard.setOtherSide(mission.getBestChoice().getDescription(), mission.getDescription())
				badChoicesVBox.add_child(endLevelCard)
	return self

func loadNextLevel() -> void:
	ResourceLoader.load_threaded_request(nextLevelPath)
	#find_parent("Game").loadLevel(nextLevel)
	
func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(nextLevelPath, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progressBar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			progressBar.value = 100		
			loadButton.disabled = false
		ResourceLoader.THREAD_LOAD_FAILED:
			printerr("Error. Could not load Level")


func _on_load_button_pressed():
	find_parent("Game").loadLevel(preload("res://game/Level.tscn").instantiate().init(ResourceLoader.load_threaded_get(nextLevelPath)))
	# loading next level call next level _ready function where loadUI is called, replacing the current UI and closing EndLevel window
