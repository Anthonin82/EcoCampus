extends Node

@onready var player = get_tree().get_first_node_in_group("player")

var activeAreas : Array[Prop]
var canInteract := true

func _process(_delta):
	activeAreas = activeAreas.filter(isAreaValid)
	if activeAreas.size() > 0:
		activeAreas.sort_custom(sortByDistanceToPlayer)
		for activeArea in activeAreas:
			activeArea.hideOutline()
		activeAreas[0].displayOutline()

func _input(event):
	if event.is_action_released("interact") and canInteract:
		activeAreas = activeAreas.filter(isAreaValid)
		if activeAreas.size() > 0:
			activeAreas.sort_custom(sortByDistanceToPlayer)
			canInteract = false
			activeAreas[0].hideOutline()
			await activeAreas[0].interact.call()
			if activeAreas.size() > 0:
				activeAreas[0].displayOutline()
			canInteract = true


func registerArea(area:Prop):
	activeAreas.push_back(area)


func unregisterArea(area:Prop):
	area.hideOutline()
	activeAreas.erase(area)


func sortByDistanceToPlayer(area1:Prop, area2:Prop):
	# Ensure the player reference is valid (because on every scene change player is freed)
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	# Safeguard to prevent sorting of invalid areas
	if not isAreaValid(area1) or not isAreaValid(area2):
		return false  
	var distArea1 = player.global_position.distance_to(area1.global_position)
	var distArea2 = player.global_position.distance_to(area2.global_position)
	return distArea1 < distArea2


func isAreaValid(area):
	return is_instance_valid(area)
	
