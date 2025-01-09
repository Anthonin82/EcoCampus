extends Node2D

@onready var tutorial = $Tutorial
@onready var game = find_parent("Game")
@onready var interactables = $Interactables # Parent node of all props

var canMoveChecked := false
var props: Array = []



func _ready():
	var level = game.getLevel()
	props = getAllProps()
	toggleAllProps(false)

	game.addMissionFromJson("bedroom")
	level.getMission("radiator").setChoice("radiatorNormal")
	level.getMission("wash").hide()
	level.getMission("breakfast").hide()

	game.loadUI(preload("res://ui/menu/optionMenu/Options.tscn").instantiate())
	game.addUI(preload("res://inventory/InventoryUI.tscn").instantiate())


func _process(_delta):
	# A bit dirty but it was the only way i found to block the player since the tutorial is ready before the player
	if game.getPlayer() != null and !canMoveChecked:
		game.player.setCanMove(tutorial.skip) # if tuto need to be skipped player can move
		if tutorial.skip:
			game.getLevel().getMission("tuto").complete()
			game.getLevel().getMission("wash").show()
			game.getLevel().getMission("breakfast").show()
			toggleAllProps(true) # Enable all props
		canMoveChecked = true


func getAllProps() -> Array:
	var propArray = []
	for child in interactables.get_children():
		if child is Prop:
			propArray.append(child)
	return propArray

# Allows to disable or enable all Bedroom's props
func toggleAllProps(value: bool) -> void:
	for prop in props:
		prop.enable() if value else prop.disable()


func togglePropByName(givenName: String, value: bool) -> void:
	for prop in props:
		if prop.name == givenName:
			prop.enable() if value else prop.disable()
			return
	push_error("Couldn't find prop with name '",givenName,"'")
