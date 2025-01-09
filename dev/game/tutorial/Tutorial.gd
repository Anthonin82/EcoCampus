extends Node

var wentUp := false
var wentDown := false
var wentLeft := false
var wentRight := false
var invPressed := 0
var optionsPressed := 0
var stepTwoAlreadyDone := false
var skip := false

@onready var game = find_parent("Game")

func _ready():
	# Handle save of the tutorial
	if SaveManager.getElement("Tutorial","done") == null:
		SaveManager.setElement("Tutorial",{"done":false})
	skip = SaveManager.getElement("Tutorial","done")
	if !skip:
		$Timer.start() # wait for 2 seconds


func _process(_delta):
	if Dialogic.VAR.tutorial.introductionDone:
		# STEP ONE
		if Input.is_action_pressed("move_up"):
			wentUp = true
		if Input.is_action_pressed("move_down"):
			wentDown = true
		if Input.is_action_pressed("move_left"):
			wentLeft = true
		if Input.is_action_pressed("move_right"):
			wentRight = true
		if !Dialogic.VAR.tutorial.stepOneDone:
			if wentUp && wentDown && wentLeft && wentRight:
				Dialogic.VAR.tutorial.stepOneDone = true
				$Timer.start()
				self.get_parent().togglePropByName("Chair",true) # Enable the Chair prop
		# STEP TWO is updated in the chair
		if Dialogic.VAR.tutorial.stepOneDone && Dialogic.VAR.tutorial.stepTwoDone:
			if !stepTwoAlreadyDone: # To be called only once
				Dialogic.start_timeline("Tutorial")
				stepTwoAlreadyDone = true
			# STEP THREE
			if !Dialogic.VAR.tutorial.stepThreeDone:
				if Input.is_action_pressed("inventory"):
					invPressed += 1
				if invPressed >= 2:
					Dialogic.VAR.tutorial.stepThreeDone = true
					$Timer.start()
			else:
				# STEP FOUR
				if !Dialogic.VAR.tutorial.stepFourDone:
					if Input.is_action_pressed("show_menu"):
						optionsPressed += 1
					if optionsPressed != 0 and !game.optionsOpened: # Options can be closed via button
						Dialogic.VAR.tutorial.stepFourDone = true
						$Timer.start()
						# End mission and start next one
						game.getLevel().getMission("tuto").complete()
						SaveManager.setElement("Tutorial",{"done":true})
						game.getLevel().getMission("wash").show()
						game.getLevel().getMission("breakfast").show()
						self.get_parent().toggleAllProps(true) # Enable all props


func _on_timer_timeout():
	Dialogic.start_timeline("Tutorial")
