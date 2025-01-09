extends CollisionShape2D


func _on_car_turn_down():
	position.x = 0
	position.y = 0
	
	scale.x = 3.5
	scale.y = 5


func _on_car_turn_left():
	position.x = 5
	position.y = 10
	
	scale.x = 5.5
	scale.y = 3.5


func _on_car_turn_right():
	position.x = -5
	position.y = 10
	
	scale.x = 5.5
	scale.y = 3.5


func _on_car_turn_up():
	position.x = 0
	position.y = 0
	
	scale.x = 3.5
	scale.y = 5
