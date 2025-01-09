class_name Scorm

#attribute refers to a scorm data model wich can be found at 
#https://scorm.com/scorm-explained/technical-scorm/run-time/run-time-reference/#section-5  (scorm v1.2)

func _init():
	var objectives = ["Appartement","Ville","BatimentVille?","Foret","CampusExterieur","SalleInfo","Amphitheatre"]
	for n in objectives.size():
		if(_getScormValue("cmi.objectives."+str(n)+".id") == ""):
			_setScormValue("cmi.objectives."+str(n)+".id",objectives[n])


func isGameOnMoodle()->bool:
	return getName() != "<null>"


func setGrade(value:int)->void:
	_setScormValue("cmi.core.score.raw", str(value))


func getGrade()->String:
	return _getScormValue("cmi.core.score.raw")


func getName()->String:
	return _getScormValue("cmi.core.student_name")


func setSave(data:String)->void:
	_setScormValue('cmi.suspend_data',data)


func getSave()->String:
	return _getScormValue("cmi.suspend_data")


func _setScormValue(attribute:String,value:String)->void:
	JavaScriptBridge.eval("ScormProcessSetValue(\""+attribute+"\", \""+value+"\");")
	JavaScriptBridge.eval("ScormProcessCommit();")


func _getScormValue(attribute:String)->String:
	return str(JavaScriptBridge.eval("ScormProcessGetValue(\""+attribute+"\");"))
