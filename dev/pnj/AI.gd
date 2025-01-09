extends AnimatedSprite2D

class_name AI

var _movementSpeed : float
var _targets : Array[Node]
var _stop := false
var _currentTargetIndex: int = -1

var runAnimationPrefix :String
var targetPrefix :String

var vx :float
var vy :float

var despawnTimer : Timer
var aiDespawnTimeSeconds := 120


@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	assert(_movementSpeed != null)
	_targets = get_parent().find_children(targetPrefix + "*")

	call_deferred("actor_setup")
	
	despawnTimer = Timer.new()
	despawnTimer.wait_time = aiDespawnTimeSeconds
	despawnTimer.autostart = true
	despawnTimer.connect("timeout", _on_timer_timeout_despawn)
	add_child(despawnTimer)
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	position = pickRandomTarget().position
	set_movement_target(pickRandomTarget().position)
	
func pickRandomTarget() -> Node2D:
	var tmp = randi() % _targets.size()
	while tmp == _currentTargetIndex :
		tmp =  randi() % _targets.size()
	_currentTargetIndex = tmp
	return _targets[_currentTargetIndex]

#On défini une position cible vers laquelle le PNJ va se déplacer (faire en sorte que cette position soit sur la NavRegion)
func set_movement_target(movement_target: Vector2):
	navigationAgent.target_position = movement_target

func _physics_process(delta):
	#Si la position est atteinte est qu'il n'y a pas d'autre positions à atteindre. Alors, le PNJ s'arrète.
	if navigationAgent.is_navigation_finished():
		queue_free()
		
	#Variables pour le pathfinding
	var currentAgentPostion: Vector2 = global_position
	var nextPathPosition: Vector2 = navigationAgent.get_next_path_position()
	#Traque le vecteur de déplacement du PNJ, pour jouer les bonnes animations
	vx = currentAgentPostion.direction_to(nextPathPosition).x
	vy = currentAgentPostion.direction_to(nextPathPosition).y
	if _stop:
		if vy > 0.0 && abs(vx) < abs(vy):
			play("idle_down")
			
		if vy < 0.0 && abs(vx) < abs(vy):
			play("idle_up")
			
		if vx < 0.0 && abs(vy) < abs(vx):
			play("idle_left")
			
		if vx > 0.0 && abs(vy) < abs(vx):
			play("idle_right")
	else :
		position += currentAgentPostion.direction_to(nextPathPosition) * _movementSpeed * delta
		_animateMovement()
		
		
func _animateMovement() -> void:
	if vx < 0.0 && abs(vy) < abs(vx):
			play(runAnimationPrefix + "_left")
		
	if vx > 0.0 && abs(vy) < abs(vx):
		play(runAnimationPrefix+"_right")
	
	if vy < 0.0 && abs(vx) < abs(vy):
		play(runAnimationPrefix+"_up")
	
	if vy > 0.0 && abs(vx) < abs(vy):
		play(runAnimationPrefix+"_down")


func _on_timer_timeout_despawn() -> void:
	queue_free()
