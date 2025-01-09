class_name Choice


var description: String

enum ConsumptionType {L, KGCO2E}
var choicesConsumptionType

var consumptionType2Value: Dictionary
var consumptionType2GoodActionBeneath: Dictionary
var consumptionType2Unit := {
	ConsumptionType.KGCO2E: "kgCo2e",
	ConsumptionType.L: "litres"
}

func _init(_description:String, _choicesConsumptionType:Array[ConsumptionType]):
	description = _description
	choicesConsumptionType = _choicesConsumptionType
	
	
func getDescription() -> String:
	return description

func setConsumption(quantity:float, consumptionType:ConsumptionType) -> void:
	consumptionType2Value[consumptionType] = quantity
	
func getConsumption(consumptionType:ConsumptionType) -> float:
	assert(consumptionType2Value.has(consumptionType))
	return consumptionType2Value[consumptionType]
	
func setGoodActionBeneath(quantity:float, consumptionType:ConsumptionType) -> void:
	consumptionType2GoodActionBeneath[consumptionType] = quantity
	
func isGood() -> bool:
	_verifications()
	for choiceConsumptionType in choicesConsumptionType:
		if(consumptionType2Value[choiceConsumptionType] < consumptionType2GoodActionBeneath[choiceConsumptionType]):
			return true
	return false

func _verifications() -> void:
	assert(!choicesConsumptionType.is_empty())
	for choiceConsumptionType in choicesConsumptionType:
		assert(consumptionType2Value.has(choiceConsumptionType), "choice : " + description)
		assert(consumptionType2GoodActionBeneath.has(choiceConsumptionType), "choice : " + description)
