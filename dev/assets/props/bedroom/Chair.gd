extends Prop


func interact() -> void:
	if game.getPlayer().isSitting:
		game.getPlayer().unsit()
	else:
		game.getPlayer().sit(interactionArea.global_position, animatedSprite.flip_h)
		# is called only once
		if !Dialogic.VAR.tutorial.stepTwoDone :
			Dialogic.VAR.tutorial.stepTwoDone = true
