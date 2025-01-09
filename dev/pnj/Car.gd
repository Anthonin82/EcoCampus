extends AI
class_name Car

signal turnRight
signal turnLeft
signal turnUp
signal turnDown

var positionBeforeTurning: String
var virage: bool = false
var numberOfThingsIAmColidingWith := 0

var _ancientMovementSpeed : float
@export var skins : Array[SpriteFrames]

func _init():
	_movementSpeed = 70
	_ancientMovementSpeed = _movementSpeed
	positionBeforeTurning = "Up"
	runAnimationPrefix = "drive"
	targetPrefix = "TargetCar"

func _ready() -> void:
	super._ready()
	sprite_frames = skins.pick_random()

func _on_animation_changed():
	if virage == true:
		_movementSpeed = 10


func _on_animation_finished():
	if virage == true:
		virage = false
		_movementSpeed = _ancientMovementSpeed


func _on_front_area_area_entered(_area):
	numberOfThingsIAmColidingWith += 1
	_stop = true


func _on_front_area_area_exited(_area):
	numberOfThingsIAmColidingWith -= 1
	if numberOfThingsIAmColidingWith == 0:
		_stop = false
		
		
func _on_front_area_body_entered(_body):
	numberOfThingsIAmColidingWith += 1
	_stop = true


func _on_front_area_body_exited(_body):
	numberOfThingsIAmColidingWith -= 1
	if numberOfThingsIAmColidingWith == 0:
		_stop = false

func _animateMovement() -> void:
		if vx < 0.0 && abs(vy) < abs(vx):
			turnLeft.emit()
			if positionBeforeTurning == "Up":
				virage = true                           
				positionBeforeTurning = "Left"                                
				play("turn_up_left")                     
			elif positionBeforeTurning == "Down":
				virage = true
				positionBeforeTurning = "Left"
				play("turn_down_left")
			if virage == false:
				play("drive_left")
				
		if vx > 0.0 && abs(vy) < abs(vx):
			turnRight.emit()
			if positionBeforeTurning == "Up":
				virage = true
				positionBeforeTurning = "Right"
				play("turn_up_right")
			elif positionBeforeTurning == "Down":
				virage = true
				positionBeforeTurning = "Right"
				play("turn_down_right")
			if virage == false:
				play("drive_right")
				
		if vy < 0.0 && abs(vx) < abs(vy):
			turnUp.emit()
			if positionBeforeTurning == "Right":
				virage = true
				positionBeforeTurning = "Up"
				play("turn_right_up")
			elif positionBeforeTurning == "Left":
				virage = true
				positionBeforeTurning = "Up"
				play("turn_left_up")
			if virage == false:
				play("drive_up")
				
		if vy > 0.0 && abs(vx) < abs(vy):
			turnDown.emit()
			if positionBeforeTurning == "Right":
				virage = true
				positionBeforeTurning = "Down"
				play("turn_right_down")
			elif positionBeforeTurning == "Left":
				virage = true
				positionBeforeTurning = "Down"
				play("turn_left_down")
			if virage == false:
				play("drive_down")
