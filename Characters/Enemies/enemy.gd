extends Character
class_name Enemy

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var path_timer: Timer = get_node("PathTimer")

var player_dead: bool = false

func _ready() -> void:
	acceleration = 20
	max_speed = 50
	add_collision_exception_with(get_tree().current_scene.get_node("Player"))
	await get_tree().physics_frame
	var p = get_tree().current_scene.get_node("Player")
	if is_instance_valid(p):
		add_collision_exception_with(p)
	nav_agent.target_position = player.global_position

func chase() -> void:
	if player_dead or not is_instance_valid(player):
		mov_direction = Vector2.ZERO
		return
		
	var dist = global_position.distance_to(player.global_position)
	if dist < 10:
		mov_direction = Vector2.ZERO
		return
	
	if nav_agent.is_navigation_finished():
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var vector_to_next_point: Vector2 = (next_pos - global_position).normalized()
	
	mov_direction = vector_to_next_point
	
	if vector_to_next_point.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

func stop_chasing() -> void:
	player_dead = true
	mov_direction = Vector2.ZERO
	path_timer.stop()

func _on_path_timer_timeout() -> void:
	if is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)
		if dist > 5:
			nav_agent.target_position = player.global_position
	else:
		path_timer.stop()
		mov_direction = Vector2.ZERO
