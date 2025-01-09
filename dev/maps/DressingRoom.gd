extends Control

@onready var player = %Player
@export var bedroomScene: PackedScene

var skinIndex := 0
var skinsNb : int

func _ready():
	player.setCanMove(false)
	skinsNb = player.skinScenes.size()
	# disables the camera so we can use the one in the scene and decenter the camera
	player.camera.enabled = false
	if SaveManager.getElement("Player","skin") != null:
		skinIndex = SaveManager.getElement("Player","skin")
		_on_play_btn_pressed()

func _on_left_arrow_btn_pressed():
	skinIndex -=1
	if skinIndex < 0:
		skinIndex = skinsNb-1  
	player.changeSkin(skinIndex)


func _on_right_arrow_btn_pressed():
	skinIndex = (skinIndex+1) % skinsNb
	player.changeSkin(skinIndex)


func _on_play_btn_pressed():
	var level
	if SaveManager.getElement("Player","currentMap") != null:
		var mapName =  SaveManager.getElement("Player","currentMap")
		#First letter to UpperCase
		mapName = mapName[0].to_upper() + mapName.substr(1,-1)
		var mapPath = "res://maps/"+mapName+".tscn"
		level = preload("res://game/Level.tscn").instantiate().init(load(mapPath))
	else:
		save()
		level = preload("res://game/Level.tscn").instantiate().init(preload("res://maps/Bedroom.tscn"))
	find_parent("Game").loadLevel(level)


func save():
	SaveManager.setElement("Player",{"skin":skinIndex,"startPosX":88,"startPosY":40, "currentMap":"Bedroom"})
