extends Node2D

class_name Level

var id2Mission: Dictionary
var map: PackedScene
var mapName: String
var compulsoryMissionsHbox: VBoxContainer
var optionalMissionsHbox: VBoxContainer
@onready var rootTileMap = find_child("TileMap")

var _init := false

func init(_map: PackedScene):
	_init = true
	map = _map
	mapName = map.resource_path.get_file().get_basename()
	compulsoryMissionsHbox = find_child("CompulsoryMissions")
	optionalMissionsHbox = find_child("OptionalMissions")
	return self
	
func _ready():
	assert(_init)
	var mapInst = map.instantiate()
	rootTileMap.add_child(mapInst)
	mapInst.set_owner(rootTileMap)
	_addMissionDisplay()
	
func addMission(id :String, mission: Mission):
	id2Mission[id] = mission
	
func getMission(id :String) -> Mission:
	assert(id2Mission.has(id), "The mission "+id+" doesn't exist")
	return id2Mission.get(id)
	
func _addMissionDisplay():
	for mission in id2Mission.values():
		if not mission.isCompleted():
			if mission.isCompulsory():
				compulsoryMissionsHbox.add_child(mission)
			else:
				optionalMissionsHbox.add_child(mission)
				mission.hide()
				
func _removeMissionDisplay():
	compulsoryMissionsHbox.hide()
	optionalMissionsHbox.hide()
			
func isCompleted() -> bool:
	for mission in id2Mission.values():
		if mission.isCompulsory() && !mission.isCompleted():
			return false
	return true

func getMissions() -> Array:
	#assert(isCompleted(), "You should wait for level to be completed before accessing choices")
	#var missionChoices : Array[Choice]
	#for mission in id2Mission.values():
		#assert(mission.getPlayerChoice() != null, "getPlayerChoice is null for mission : " + mission.getText())
		#missionChoices.append(mission.getPlayerChoice())
	#return missionChoices
	return id2Mission.values()
	
