extends CharacterBody2D
class_name Player

@onready var camera = %Camera2D # zoom values will be overwritten by Game.gd

var speed = 70  # in pixels per second
var currentSkin: AnimatedSprite2D
var posBeforeAction : Vector2

var _canMove := true
var isSitting := false
var isSleeping := false
var isEating := false
var isInDialogue := false

@export var skinScenes: Array[PackedScene] = []
@export var inventory: Inventory

var currentAnimationName = "idle_down"

func _ready():
	loadPlayer()
	# connect to Dialogic signals for start and end of dialogues
	Dialogic.timeline_ended.connect(onTimelineEnded)
	Dialogic.timeline_started.connect(onTimelineStarted)


func _physics_process(_delta):
	getInput()
	if canMove():
		move_and_slide()


func canMove() -> bool:
	return !isSitting && !isSleeping && !isInDialogue && !isEating && _canMove


func onTimelineStarted():
	isInDialogue = true # prevent player from moving while in dialogue
	# prevent from infinite pause if inventory is opened while dialogue start
	inventory.close.emit() 


func onTimelineEnded():
	isInDialogue = false


func setCanMove(__canMove:bool) -> void:
	_canMove = __canMove


func getInput():
	velocity = Vector2()
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	# Normalize the velocity to avoid moving faster diagonally
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if canMove():
		animateMovements()


func animateMovements():
	assert(currentSkin != null)
	if velocity.normalized().x > 0:
		currentAnimationName = "walk_right"
	elif velocity.normalized().x < 0:
		currentAnimationName = "walk_left"
	elif velocity.normalized().y > 0:
		currentAnimationName = "walk_down"
	elif velocity.normalized().y < 0:
		currentAnimationName = "walk_up"
	else:
		if currentSkin.animation.begins_with("walk"):
			currentAnimationName = currentSkin.animation.replace("walk", "idle")
		
	if currentSkin.animation != currentAnimationName:
		currentSkin.play(currentAnimationName)


func setSkin(spriteScene: PackedScene):
	assert(spriteScene != null)
	if currentSkin != null:
		currentSkin.queue_free()
	currentSkin = spriteScene.instantiate()
	add_child(currentSkin)


func changeSkin(index: int):
	index = clampi(index, 0,skinScenes.size()-1)
	setSkin(skinScenes[index])


func sit(chairPosition: Vector2, isRightOriented: bool):
	isSitting = true
	posBeforeAction = self.global_position
	self.global_position = chairPosition
	if isRightOriented:
		currentSkin.play("seated_right")
	else:
		currentSkin.play("seated_left")


func unsit() -> void:
	isSitting = false
	self.global_position = posBeforeAction
	currentSkin.play("idle_down")


func sleep(sleepPosition: Vector2):
	isSleeping = true
	posBeforeAction = self.global_position
	self.global_position = sleepPosition
	currentSkin.play("sleeping_head")


func unsleep() -> void:
	isSleeping = false
	self.global_position = posBeforeAction
	currentSkin.play("idle_down")


func awaitEat() -> void:
	isEating = true
	currentSkin.play("grab_object_down")
	var animationDuration = currentSkin.sprite_frames.get_frame_duration("grab_object_down",0) * (1/currentSkin.sprite_frames.get_animation_speed("grab_object_down")/abs(currentSkin.get_playing_speed())) * currentSkin.sprite_frames.get_frame_count("grab_object_down")
	await get_tree().create_timer(animationDuration).timeout
	isEating = false


func teleport(tpPosition: Vector2):
	self.global_position = tpPosition


func setSpawnPosition():
	if SaveManager.getElement("Player","startPosX") == null:
		SaveManager.setElement("Player",{"startPosX":0,"startPosY":0})
	else:
		var startPosInScene = Vector2(float(SaveManager.getElement("Player","startPosX")),float(SaveManager.getElement("Player","startPosY")))
		if startPosInScene != Vector2.ZERO: 
			self.global_position = startPosInScene
			SaveManager.setElement("Player",{"startPosX":0,"startPosY":0})


func setCameraZoom(zoom: float) -> void:
	camera.zoom = Vector2(zoom,zoom)


func save(): 
	var currentMap = self.owner.get_child(0).get_child(0).name.get_slice('"',1)
	if isSitting or isSleeping: # Prevent from being stuck if game is closed while in a prop
		SaveManager.setElement("Player",{"globalPosX":posBeforeAction.x,"globalPosY":posBeforeAction.y,"currentMap":currentMap})
	else:
		SaveManager.setElement("Player",{"globalPosX":self.global_position.x,"globalPosY":self.global_position.y,"currentMap":currentMap})
	inventory.save()


func loadPlayer():
	# Load the first AnimatedSprite2D by default
	if skinScenes.size() > 0:
		if SaveManager.getElement("Player","skin") == null:
			setSkin(skinScenes[0])
		else:
			setSkin(skinScenes[SaveManager.getElement("Player","skin")])
	setSpawnPosition() # Teleport player if needed
	inventory.loadInv()
