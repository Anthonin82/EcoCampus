extends MultiDestinationTeleporter
class_name PlayerCar


func _ready() -> void:
	super._ready()
	call_deferred("hideCarOnStart") # the car was ready before the city


func interact():
	updateDestinations()
	await awaitShowDialogs()
	if int(Dialogic.VAR.destinations.choice) != -1: # for some reasons Dialogic won't let me use an int
		teleporter.destTpInfos = destinations[int(Dialogic.VAR.destinations.choice)]
		var destId = teleporter.destTpInfos.destinationId
		var destMap = teleporter.destTpInfos.getSceneName()
		SaveManager.setElement("Player",{"lastCarInfos" : {"id": destId, "map": destMap}})
		# Missions handling
		if game.getLevel().mapName == "City" and !game.getLevel().getMission("goToCampus").isCompleted(): # Choice can be set only for city's cars
			game.getLevel().getMission("goToCampus").setChoice("car")
			if destMap == "Campus":
				game.getLevel().getMission("goToCampus").complete()
		# Teleport player to chosen destination
		teleporter.teleport()
		InteractionManager.unregisterArea(self) # with tp the prop wasn't properly removed
		# Activate car of teleportation destination
		if self.get_parent():
			var cars = self.get_parent().find_children("", "PlayerCar", true)
			for car in cars:
				if car.teleporter.id == destId:
					car.showAndEnable()
					break
		else:
			push_error("PlayerCar '",self.name,"' isn't a child of Interactables node.")
		hideAndDisable()
	resetDestinations()


func hideAndDisable():
	hide()
	super.disable()
	find_child("StaticBody2D").get_child(0).set_deferred("disabled", true)


func showAndEnable():
	show()
	super.enable()
	find_child("StaticBody2D").get_child(0).set_deferred("disabled", false)


func hideCarOnStart():
	if SaveManager.saveDict["Player"]["lastCarInfos"]["id"] != teleporter.id or SaveManager.saveDict["Player"]["lastCarInfos"]["map"] != SaveManager.getElement("Player","currentMap"):
		hideAndDisable()


func save() -> Dictionary:
	if game.getLevel().mapName == "City": # only apply for city's cars
		var transportationName = game.getLevel().getMission("goToCampus").getPlayerChoiceId()
		if transportationName == "car" && game.getLevel().getMission("goToCampus").isCompleted():
			return {"TransportationToCampus":transportationName}
	return {}


func load(propList: Dictionary) -> void:
	if game.getLevel().mapName == "City":  # Only apply for the city's cars
		if propList.has("TransportationToCampus") and propList["TransportationToCampus"] != null:
			if !game.getLevel().getMission("goToCampus").isCompleted(): # So it's only done once
				game.getLevel().getMission("goToCampus").setChoice(propList["TransportationToCampus"])
				if game.getLevel().getMission("goToCampus").getPlayerChoiceId() == "car":
					game.getLevel().getMission("goToCampus").complete()
