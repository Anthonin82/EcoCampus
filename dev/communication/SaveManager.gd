extends Node

const SAVE_FILE_PATH = "user://EcoCampus.sav"
var saveDict := {}
var scorm := Scorm.new()

var dontSave := false

func _ready():	
	if hasSave():
		self.load()

func hasSave() -> bool:
	return ((scorm.getSave() != "<null>" && scorm.getSave() != "") || FileAccess.file_exists(SAVE_FILE_PATH))

func setElement(element:String,data:Dictionary)->void:
	if element in saveDict:
		saveDict[element].merge(data, true)
	else:
		saveDict[element] = data


func getElement(category:String,element:String,onlyCategory:bool=false)->Variant:
	if onlyCategory == true && category in saveDict:
		return saveDict[category]
	if category in saveDict && element in saveDict[category]:
		return saveDict[category][element]
	else:
		return null


func save()->void:
	if dontSave:
		return
	var timeDict = Time.get_datetime_dict_from_system()
	timeDict.erase("dst")
	timeDict.erase("weekday")
	setElement("Datetime",timeDict)
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	file.store_string(var_to_str(saveDict))
	if scorm.isGameOnMoodle():
		scorm.setSave(_swap_quotes(var_to_str(saveDict),false))


func load()->void:
	var onlineSave = null
	if scorm.isGameOnMoodle():
		onlineSave = str_to_var(_swap_quotes(scorm.getSave(),true))
	
	var json = JSON.new()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	
	var offlineSave = json.data
	if onlineSave == null && offlineSave == null:
		return
	if (onlineSave!=null && offlineSave == null):
		saveDict = onlineSave
	elif onlineSave == null:
		saveDict = offlineSave
	elif _is_later(onlineSave["Datetime"],offlineSave["Datetime"]):
		saveDict = onlineSave
	else:
		saveDict = offlineSave


func hasCategory(categoryName:String)-> bool:
	var cat = getElement(categoryName,"",true)
	if cat == null:
		return false
	else:
		return true


func _is_later(time:Dictionary,timeToCompareTo:Dictionary)->bool:
	for key in time.keys():
		if time[key] >= timeToCompareTo[key]:
			return true
		else:
			return false
	return false


func _swap_quotes(data:String,swapToDoubleQuotes:bool)->String:
	var temp
	if swapToDoubleQuotes == true:
		temp = data.replace("'", '"')
		temp = temp.replace("{","{\n")
		temp = temp.replace(",",",\n")
		return temp.replace("}","\n}")
	else:
		temp = data.replace('"',"'")
		return temp.replace("\n","")


func deleteSave():
	# empty file
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.close()
	
	saveDict = {}
	if scorm.isGameOnMoodle():
		scorm._setScormValue('cmi.suspend_data', "")
	dontSave = true
