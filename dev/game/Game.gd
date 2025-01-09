extends Node2D

class_name Game

@export var firstScene: PackedScene

@onready var rootLevel: Node2D = find_child("Level")
@onready var rootUI: Control = find_child("UI")
@onready var player: Player

var gameName: String = "ECO C.A.M.P.U.S" 

var outsideMaps: Array[String] = ["City","Campus"] # Need to add every outside maps for zoom handling.
var outsideZoom: float = 3.0 # Zoom of the camera for outside maps
var insideZoom: float = 4.0 # Zoom of the camera for inside maps

var optionsOpened := false
var inventoryOpened := false
var nextSceneTeleporter: String = ''

func _init() -> void:
	# Set fullscreen in code because setting it in project.godot breaks tests
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _ready():
	loadUI(firstScene.instantiate())
	Dialogic.VAR.tutorial.gameName = gameName


func loadLevel(level :Level) -> void:
	save()
	deleteCurrentLevel()
	rootLevel.add_child(level)
	level.set_owner(rootLevel)
	player = preload("res://player/Player.tscn").instantiate()
	level.add_child(player)
	player.set_owner(level)
	if SaveManager.hasSave(): 
		loadLevelProps(level)
		if SaveManager.getElement("Player","currentMap") == level.mapName: # Prevent from teleporting to previous map coordinates
			if SaveManager.getElement("Player","globalPosX") != null:
				player.teleport(Vector2(SaveManager.getElement("Player","globalPosX"),SaveManager.getElement("Player","globalPosY")))
	if nextSceneTeleporter != '':
		player.teleport(findTeleporterById(nextSceneTeleporter).global_position)
		nextSceneTeleporter = ''
	getPlayer().save() # to update the current map
	handleZoom(level.mapName)


func loadUI(ui :Control) -> void:
	deleteCurrentUI()
	rootUI.add_child(ui)
	#ui.set_owner(rootUI)


func addUI(ui :Control) -> void:
	rootUI.add_child(ui)
	ui.set_owner(rootUI)


func deleteCurrentLevel() -> void:
	Game.deleteChildren(rootLevel)


func deleteCurrentUI() -> void:
	Game.deleteChildren(rootUI)


func pause() -> void:
	get_tree().paused = true


func unpause() -> void:
	get_tree().paused = false


static func deleteChildren(node :CanvasItem):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func getPlayer() -> Player:
	# TODO resolve player value not defined at game start
	player = find_child("Player")
	return player


func getLevel() -> Level:
	return rootLevel.get_child(0)


func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func get_propList(node: Variant)-> Dictionary:
	var propList = {}
	if node is Prop:
		var propData = node.save()
		if propData != null:
			propList.merge(propData,true)
	for child in node.get_children():
		var childPropList = get_propList(child)
		if childPropList != null:
			propList.merge(childPropList,true)
	return propList
	
func set_propList(propList:Dictionary, node:Variant) -> void:
	if node is Prop:
		node.load(propList)
	for child in node.get_children():
		set_propList(propList,child)


func saveLevelProps(node:Node2D) -> void:
	if node.find_child("Bedroom") != null:
		SaveManager.setElement(node.find_child("Bedroom").name,get_propList(rootLevel))
	if node.find_child("City") != null:
		SaveManager.setElement(node.find_child("City").name,get_propList(rootLevel))
	if node.find_child("Campus") != null:
		SaveManager.setElement(node.find_child("Campus").name,get_propList(rootLevel))
	if node.find_child("Amphitheater") != null: #Ajouter les autres maps
		SaveManager.setElement(node.find_child("Amphitheater").name,get_propList(rootLevel))
	if node.find_child("Autre") != null: #Ajouter les autres maps
		pass
	SaveManager.save()


func loadLevelProps(node:Node2D) -> void:
	if node.find_child("Bedroom") && SaveManager.hasCategory("Bedroom"):
		set_propList(SaveManager.getElement("Bedroom","",true), node)
	if node.find_child("City") && SaveManager.hasCategory("City"):
		set_propList(SaveManager.getElement("City","",true), node)
	if node.find_child("Campus") && SaveManager.hasCategory("Campus"):
		set_propList(SaveManager.getElement("Campus","",true), node)
	if node.find_child("Amphitheater") && SaveManager.hasCategory("Amphitheater"):
		set_propList(SaveManager.getElement("Amphitheater","",true), node)
	#Ajouter les autres maps


func save()->void:
	saveLevelProps(rootLevel)
	getPlayer()
	if player != null: player.save()


func _notification(event):
	if event == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
		SaveManager.save()


func addMissionFromJson(levelId :String):
	var json = JSON.new()
	var error = json.parse(FileAccess.open("res://json/MissionValues.json", FileAccess.READ).get_as_text())
	assert(error == OK, "JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
	assert(typeof(json.get_data()) == TYPE_DICTIONARY)
	for missionId in json.get_data()["missions"][levelId]:
		var missionJson = json.get_data()["missions"][levelId][missionId]
		var level = getLevel()
		var mission = preload("res://game/mission/Mission.tscn").instantiate().init(missionJson["missionName"], missionJson["missionDescription"], missionJson["missionAdvancedDescription"], Mission.Compulsory[missionJson["compulsory"]])
		for choiceId in missionJson["choices"]:
			var consumptionTypeTab = missionJson["consumptionType"]
			var convertedConsumptionTypeTab : Array[Choice.ConsumptionType]
			for i in range (consumptionTypeTab.size()):
				assert(Choice.ConsumptionType.has(consumptionTypeTab[i]), "Cant convert: " + consumptionTypeTab[i] + " to a Choice.ConsumptionType")
				convertedConsumptionTypeTab.append(Choice.ConsumptionType[consumptionTypeTab[i]]) 
			var choice = Choice.new(missionJson["choices"][choiceId]["choiceName"], convertedConsumptionTypeTab)
			for consumptionType in convertedConsumptionTypeTab:
				choice.setConsumption(missionJson["choices"][choiceId][Choice.ConsumptionType.keys()[consumptionType]], consumptionType)
				choice.setGoodActionBeneath(missionJson["goodActionBeneath"][Choice.ConsumptionType.keys()[consumptionType]], consumptionType)
			mission.addChoice(choiceId, choice)
		level.addMission(missionId, mission)


func findTeleporterById(id: String) -> Teleporter:
	var interactablesNode = find_child("Interactables")
	if interactablesNode:
		var teleporters = interactablesNode.find_children("", "Teleporter", true)
		for teleporter in teleporters:
			if teleporter.id == id:
				return teleporter
	return null


func handleZoom(currentMapName: String):
	var targetZoomVec = Vector2(insideZoom,insideZoom)
	for mapName in outsideMaps:
		if currentMapName == mapName:
			targetZoomVec = Vector2(outsideZoom,outsideZoom)
			break
	# change zoom smoothly during 2 seconds
	var tween = get_tree().create_tween()
	tween.tween_property(player.camera, "zoom", targetZoomVec, 2.0)
