extends Node2D


@onready var tileMap :Node2D = find_parent("TileMap")
@export var pedestrianInMap : int = 30
@export var carInMap : int = 5
var timer : Timer
var timer2 : Timer

func _ready():
	assert(tileMap != null)
	
	timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	
	timer2 = Timer.new()
	timer2.wait_time = 1.5
	timer2.one_shot = false
	timer2.autostart = true
	timer2.connect("timeout", _on_timer2_timeout)
	add_child(timer2)


func _on_timer_timeout():
	if find_children("*", "Car", true, false).size() < carInMap:
		var car = preload("res://pnj/Car.tscn").instantiate()
		add_child(car)


func _on_timer2_timeout():
	if find_children("*", "Pedestrian", true, false).size() < pedestrianInMap:
		var pedestrian = preload("res://pnj/Pedestrian.tscn").instantiate()
		add_child(pedestrian)
