extends Control

var _init := false

@onready var titleLabel: RichTextLabel = find_child("Title")
@onready var descriptionLabel: RichTextLabel = find_child("Description")
@onready var gobeletButton: Button = find_child("GobeletButton")


var title:String
var description:String
var otherSideTitle:String
var otherSideDescription:String
var showingOtherSide := false

var goodChoice :bool
var advancedDescription:String

func init(_title:String, _description:String, _goodChoice:bool, _advancedDescription:String) -> Control:
	_init = true
	goodChoice = _goodChoice
	advancedDescription = _advancedDescription
	title = _title
	description = _description
	return self


func _ready():
	assert(_init)
	assert(titleLabel != null)
	assert(descriptionLabel != null)
	assert(gobeletButton != null)
	titleLabel.text = title
	descriptionLabel.text = description
	if goodChoice:
		gobeletButton.hide()
		self_modulate = Color.DARK_GREEN
	else:
		self_modulate = Color.DARK_RED


func setOtherSide(_title:String, _description:String) -> void:
	otherSideTitle = _title
	otherSideDescription = _description


func _on_turnarround_button_pressed():
	assert(otherSideTitle != null)
	assert(otherSideDescription != null)
	showingOtherSide=!showingOtherSide
	var tempTitle = titleLabel.text
	titleLabel.text = otherSideTitle
	otherSideTitle = tempTitle
	
	var tempDescription = descriptionLabel.text
	descriptionLabel.text = otherSideDescription
	otherSideDescription = tempDescription
	
	if showingOtherSide:
		self_modulate = Color.DARK_GREEN
	else:
		self_modulate = Color.DARK_RED
		


func _on_question_button_pressed():
	add_child(preload("res://game/mission/AdvancedDescription.tscn").instantiate().init(advancedDescription))
