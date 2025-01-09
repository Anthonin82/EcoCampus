extends CollisionShape2D

func _on_car_turn_down():
	position.x = 0
	position.y = 90
	
	scale.x = 3.5
	scale.y = 1


func _on_car_turn_left():
	position.x = -90
	position.y = 10
	
	scale.x = 1
	scale.y = 3.5


func _on_car_turn_right():
	position.x = 90
	position.y = 10
	
	scale.x = 1
	scale.y = 3.5


func _on_car_turn_up():
	position.x = 0
	position.y = -90
	
	scale.x = 3.5
	scale.y = 1
