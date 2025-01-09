# GdUnit generated TestSuite
class_name MissionTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://game/mission/Mission.gd'

var gameRunner :GdUnitSceneRunner
var rootNode :Node2D
var testLevel :Level

func before_test() -> void:
	gameRunner = scene_runner("res://game/Game.tscn")
	rootNode = gameRunner.find_child("*").get_parent()
	testLevel = preload("res://game/Level.tscn").instantiate().init(preload("res://tests/assets/props/bedroom/RadiatorTestLevel.tscn"))
	rootNode.deleteCurrentUI()
	
func after_test() -> void:
	if is_instance_valid(testLevel):
		testLevel.queue_free()

# Can't be tested if tests are runned in debug mode see https://github.com/MikeSchulze/gdUnit4/issues/304
#func test_MissionWithoutInitCrash() -> void:
	#var testMission = preload("res://game/mission/Mission.tscn").instantiate()
	#testLevel.addMission("test", testMission)
	#rootNode.loadLevel(testLevel)
	#await assert_error(func(): rootNode.loadLevel(testLevel)).is_runtime_error("Assertion failed.")

func test_addOneCompulsoryMissionOneChild():
	var testMission = preload("res://game/mission/Mission.tscn").instantiate().init("test", "test description", "test advanced description", Mission.Compulsory.COMPULSORY)
	testLevel.addMission("test", testMission)
	rootNode.loadLevel(testLevel)
	var compulsoryMissionsHbox = rootNode.find_child("CompulsoryMissions")
	assert_int(compulsoryMissionsHbox.get_child_count()).is_equal(1)
	assert_bool(compulsoryMissionsHbox.get_child(0).visible).is_true()
	
func test_addTwoCompulsoryMissionTwoChild():
	var testMission = preload("res://game/mission/Mission.tscn").instantiate().init("test", "test description", "test advanced description", Mission.Compulsory.COMPULSORY)
	var testMission2 = preload("res://game/mission/Mission.tscn").instantiate().init("test", "test description", "test advanced description", Mission.Compulsory.COMPULSORY)
	testLevel.addMission("test", testMission)
	testLevel.addMission("test2", testMission2)
	rootNode.loadLevel(testLevel)
	var compulsoryMissionsHbox = rootNode.find_child("CompulsoryMissions")
	assert_int(compulsoryMissionsHbox.get_child_count()).is_equal(2)
	assert_bool(compulsoryMissionsHbox.get_child(0).visible).is_true()
	assert_bool(compulsoryMissionsHbox.get_child(1).visible).is_true()
	


func test_validateMissionValuesWithMissionValuesScheme() -> void:
	var validator := JsonSchemaLoader.new("res://json/MissionValuesScheme.json").load_validator()
	var json = JSON.new()
	var error = json.parse(FileAccess.open("res://json/MissionValues.json", FileAccess.READ).get_as_text())
	assert_bool(error == OK).is_true()
	assert_bool(validator.is_valid(json.data)).is_true()

# this test should pass, proving that this case is detected by local json validator
# but anyOf verification doesn't seems to be implemented in the library yet
#"anyOf": [
	#{"required": ["co2"]},
	#{"required": ["L"]}
#],
func _test_anyOfPropertiesIsVerifiedByTheSchema() -> void:
	var validator := JsonSchemaLoader.new("res://json/MissionValuesScheme.json").load_validator()
	var json = JSON.new()
	var error = json.parse(FileAccess.open("res://json/MissionValues.json", FileAccess.READ).get_as_text())
	assert_bool(validator.is_valid({
		"genericValues": {},
		"missions": [
		{
			"missionName": "ABCDEFGHIJKLMNOPQRSTUVWXYZAB",
			"missionDescription": "ABCDEFGHIJKLMNOPQRSTUVWXYZA",
			"choices": [
				{
					"id": "ABCDEFGHIJ",
					"POPUFJKESLJFMSJF": 0.0 #<----- this should be L or co2
				}
			],
			"timePerWeek": 0,
			"goodActionBeneath": {
				"jkfdljqfmdklfm": 0.0,
				"L": 0.0
			}
		}]
	})).is_false() #<- this sould be false but it is true
	
