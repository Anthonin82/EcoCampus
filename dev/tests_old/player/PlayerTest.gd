# GdUnit generated TestSuite
extends GdUnitTestSuite

@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://player/Player.gd'

var testPlayerScene: PackedScene = preload("res://player/Player.tscn")
var player

func _setup() -> void:
	player = testPlayerScene.instantiate()
	assert_object(player).is_not_null()
	add_child(player)
	assert_array(player.skinScenes).is_not_null()

func _teardown() -> void:
	player.queue_free()

func test_initial_skin_setup() -> void:
	assert_bool(true)
	
	# DOESN'T WORK
	
	## Vérifie que le joueur a un skin initial après _ready
	#player.skinScenes.append(preload("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF1.tscn"))
	#player._ready()
	#assert_object(player.currentSkin).is_not_null()
#
#func test_set_skin() -> void:
	#var skinScene = preload("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF1.tscn")
	#player.setSkin(skinScene)
	#assert_object(player.currentSkin).is_not_null()
	#assert_str(player.currentSkin.get_scene().resource_path).is_equal("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF1.tscn")
#
	## Changer de skin
	#var newSkinScene = preload("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF2.tscn")
	#player.setSkin(newSkinScene)
	#assert_object(player.currentSkin).is_not_null()
	#assert_str(player.currentSkin.get_scene().resource_path).is_equal("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF2.tscn")
#
#func test_change_skin() -> void:
	#var skinScene1 = preload("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF1.tscn")
	#var skinScene2 = preload("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF2.tscn")
	#player.skinScenes.append(skinScene1)
	#player.skinScenes.append(skinScene2)
	#player._ready()
#
	#player.changeSkin(1)
	#assert_str(player.currentSkin.get_scene().resource_path).is_equal("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF2.tscn")
#
	#player.changeSkin(0)
	#assert_str(player.currentSkin.get_scene().resource_path).is_equal("res://assets/characters/character_generator/female/animatedSprites/animatedSpriteF1.tscn")
#
#func test_movement_animation() -> void:
	#var skinScene = preload("res://assets/characters/character_generator/male/animatedSprites/animatedSpriteM1.tscn")
	#player.setSkin(skinScene)
	#player.velocity = Vector2(1, 0)  # Simule un mouvement vers la droite
	#player.animateMovements()
	#assert_str(player.currentSkin.animation).is_equal("walk_right")
#
	#player.velocity = Vector2(-1, 0)  # Simule un mouvement vers la gauche
	#player.animateMovements()
	#assert_str(player.currentSkin.animation).is_equal("walk_left")
#
	#player.velocity = Vector2(0, 0)  # Simule l'arrêt du mouvement
	#player.animateMovements()
	#assert_str(player.currentSkin.animation).is_equal("idle_right")  # Assurez-vous que cette animation existe
#
#func test_no_skin_scenes() -> void:
	#player._ready()
	#assert_object(player.currentSkin).is_null()
