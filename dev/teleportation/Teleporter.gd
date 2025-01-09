extends Node2D
class_name Teleporter
# Documentation : https://gitlab.com/dpuzenat/ecogame/-/wikis/Documentation/Teleporter

@onready var game = find_parent("Game")
@onready var id: String = self.get_parent().name

@export_category("Scene Teleportation")
@export var destTpInfos: tpInfos

func teleport():
	if destTpInfos.getScenePath() != '':
		if getCurrentLevelPath() != destTpInfos.getScenePath():
			if destTpInfos.destinationId != '': 
				game.nextSceneTeleporter = destTpInfos.destinationId
			game.getLevel()._removeMissionDisplay()
			game.loadUI(preload("res://game/mission/EndLevel.tscn").instantiate().init(find_parent("Game").getLevel(), destTpInfos.getScenePath()))
		else:
			game.getPlayer().teleport(game.findTeleporterById(destTpInfos.destinationId).global_position)
	else:
		push_error("Scene path is Undefined in Teleporter")


func getCurrentLevelPath():
	return find_parent("Game").find_child("Level").get_children()[0].map.resource_path
