# GdUnit generated TestSuite
class_name ChoiceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://mission/Choice.gd'

var choice1 :Choice
var choice2 :Choice

func before_test() -> void:
	choice1 = Choice.new("Radiateur allumé", [Choice.ConsumptionType.KGCO2E])
	choice2 = Choice.new("Radiateur éteint", [Choice.ConsumptionType.KGCO2E])

func test_getDescription() -> void:
	assert_str(choice1.getDescription()).contains("Radiateur allumé")
	assert_str(choice2.getDescription()).contains("Radiateur éteint")
	
