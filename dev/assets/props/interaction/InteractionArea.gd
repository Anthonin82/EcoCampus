extends Area2D
class_name InteractionArea

var canBeInteracted: bool = true # Allows to block interaction with self
@onready var prop:Prop = get_parent()

var interact: Callable = func():
	pass


func _on_body_entered(body):
	if body is Player and canBeInteracted:
			InteractionManager.registerArea(prop)


func _on_body_exited(body):
	if body is Player and canBeInteracted:
			InteractionManager.unregisterArea(prop)
