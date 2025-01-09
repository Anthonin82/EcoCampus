extends AI

class_name Pedestrian

var numberOfCarIAmColidingWith := 0
@export var skins : Array[SpriteFrames]

func _init() -> void:
	_movementSpeed = 30
	runAnimationPrefix = "walk"
	targetPrefix = "TargetPedestrian"


func _ready() -> void:
	super._ready()
	sprite_frames = skins.pick_random()


func _on_area_2d_body_entered(_body):
	numberOfCarIAmColidingWith += 1
	_stop = true


func _on_area_2d_body_exited(_body):
	numberOfCarIAmColidingWith -= 1
	if numberOfCarIAmColidingWith == 0:
		_stop = false
