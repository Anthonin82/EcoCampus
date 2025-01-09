extends MultiDestinationTeleporter
class_name TransporterMissionTeleporter

@export var missionName: String ## Name of the mission to complete and set choice. ("getMission(missionName)")
@export var missionChoiceName: String ## Name of the choice of the current mission. Let this label empty if the mission hasn't any choices. ("setChoice(missionChoiceName)")
@export var destinationMapName: String ## Name of the map which will allow to complete the mission. (Case sensitive)

func _ready() -> void:
	super._ready()
	assert(missionName != "",name+" missionName isn't defined")
	assert(destinationMapName != "",name+" destinationMapName isn't defined")

func interact():
	updateDestinations()
	await awaitShowDialogs()
	if int(Dialogic.VAR.destinations.choice) != -1: # for some reasons Dialogic won't let me use an int
		teleporter.destTpInfos = destinations[int(Dialogic.VAR.destinations.choice)]
		# Missions handling
		var destMap = teleporter.destTpInfos.getSceneName()
		if !game.getLevel().getMission(missionName).isCompleted():
			if missionChoiceName:
				game.getLevel().getMission(missionName).setChoice(missionChoiceName)
			if destMap == destinationMapName:
				game.getLevel().getMission(missionName).complete()
		teleporter.teleport()
		InteractionManager.unregisterArea(self) # with tp the prop wasn't removed properly
	resetDestinations()


func save() -> Dictionary:
	if missionChoiceName: # Allows to save infos whether it need a choice or not
		var transportationName = game.getLevel().getMission(missionName).getPlayerChoiceId()
		if transportationName == missionChoiceName && game.getLevel().getMission(missionName).isCompleted():
			return {"TransportationTo"+destinationMapName:transportationName}
	else:
		return {"wentTo"+destinationMapName:game.getLevel().getMission(missionName).isCompleted()}
	return {}


func load(propList: Dictionary) -> void:
	if missionChoiceName: # Allows to load infos whether it need a choice or not
		if propList.has("TransportationTo"+destinationMapName) and propList["TransportationTo"+destinationMapName] != null:
			if !game.getLevel().getMission(missionName).isCompleted(): # So it's only done once
				game.getLevel().getMission(missionName).setChoice(propList["TransportationTo"+destinationMapName])
				if game.getLevel().getMission(missionName).getPlayerChoiceId() == missionChoiceName:
					game.getLevel().getMission(missionName).complete()
	else:
		if propList.has("wentTo"+destinationMapName) and propList["wentTo"+destinationMapName] != null:
			if !game.getLevel().getMission(missionName).isCompleted(): # So it's only done once
				if propList["wentTo"+destinationMapName]:
					game.getLevel().getMission(missionName).complete()
	
