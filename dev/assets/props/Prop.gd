extends Node2D

class_name Prop

@export var dialogicTimeline :DialogicTimeline
var mission :Mission

var _outlineActivated := true
@onready var interactionArea = find_child("InteractionArea")
@onready var animatedSprite = find_child("AnimatedSprite2D")
@onready var game = find_parent("Game")

var interacting := false

func _ready():
	assert(interactionArea != null)
	assert(animatedSprite != null)
	assert(game != null)
	if dialogicTimeline == null:
		push_warning("Prop "+name+" doesn't have a dialogue timeline (this can be normal).")
	interactionArea.interact = Callable(self, "onInteract")


func onInteract():
	if not interacting:
		interacting = true
		await interact()
		interacting = false


func disable():
	interactionArea.canBeInteracted = false


func enable():
	interactionArea.canBeInteracted = true


func interact():
	await awaitShowDialogs()


func awaitShowDialogs():
	if dialogicTimeline != null:
		Dialogic.start(dialogicTimeline)
		await Dialogic.timeline_ended


func displayOutline() -> void:
	if _outlineActivated:
		animatedSprite.material.set_shader_parameter("width",1.0)


func hideOutline() -> void:
	animatedSprite.material.set_shader_parameter("width",0.0)


func save():
	pass


func load(propList:Dictionary) -> void:
	pass
