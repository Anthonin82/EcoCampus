extends Node

@onready var player = get_tree().get_first_node_in_group("player")

# This script was used in the early stages of the game. The best would be to completely remove it from the game.
# The closet choice selection can be reworked the way the fridge work. The last 2 functions are used for introductions dialogues to make the player face down.  
var bedroomInfos = {  
	"completed" : false,
	"closet" : {
		"backpack": false,
		"pullover": false,
		"helmet": false
	}
}

func getPlayer():
	player = get_tree().get_first_node_in_group("player")


func changeAnyBedroomChoice(categorie: String, choice: String, value: bool = true ):
	if bedroomInfos.has(categorie):
		if bedroomInfos[categorie].has(choice):
			bedroomInfos[categorie][choice] = value


func getBedroomInfo(categorie: String, choice: String):
	if bedroomInfos.has(categorie):
		if bedroomInfos[categorie].has(choice):
			return bedroomInfos[categorie][choice]
	return null


func addBreakfastChoice(choice: String):
	if bedroomInfos["breakfast"].has(choice):
		bedroomInfos["breakfast"][choice] = true
		if player == null:
			getPlayer()
		player.inventory.insert(choice)


func addClosetChoice(choice: String):
	if bedroomInfos["closet"].has(choice):
		bedroomInfos["closet"][choice] = true
	if player == null:
			getPlayer()
	player.inventory.insert(choice)


func removeClosetChoice(choice: String):
	if bedroomInfos["closet"].has(choice):
		bedroomInfos["closet"][choice] = false
	if player == null:
			getPlayer()
	player.inventory.remove(choice)

func setPlayerCanMove(boolean: bool):
	getPlayer()
	player.setCanMove(boolean)

func setPlayerAnimation(animName: String):
	getPlayer()
	player.currentSkin.play(animName)
# Read top comment
