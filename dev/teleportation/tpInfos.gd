extends Resource
class_name tpInfos

@export_enum("Undefined","Bedroom","City","Campus","Amphitheater") var map = 0
@export var destinationId: String = "" ## Used to find the teleporter in the next scene. (Name of his parent node)
@export var destinationName: String = "" ## Name shown to player in case of multiple choice destination.
var scenePaths : Array = ["","res://maps/Bedroom.tscn","res://maps/City.tscn","res://maps/Campus.tscn","res://maps/Amphitheater.tscn"]

func getScenePath():
	return scenePaths[map]

func getSceneName():
	return scenePaths[map].get_file().get_basename()
