extends Node2D


func _ready():
	var level = find_parent("Game").getLevel()
	
	var radiatorMission = preload("res://game/mission/Mission.tscn").instantiate().init("Baisser le chauffage d'un degré", "description", "advanced description", Mission.Compulsory.OPTIONAL)
	radiatorMission.addChoice("radiatorNormal", Choice.new("Radiateur chaud", [Choice.ConsumptionType.KGCO2E]))
	radiatorMission.addChoice("radiatorLessOneDegree", Choice.new("Radiateur éteint", [Choice.ConsumptionType.KGCO2E]))
	level.addMission("radiator", radiatorMission)
