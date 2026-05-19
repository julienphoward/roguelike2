extends Character
class_name Enemy

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

func _ready() -> void:
	acceleration = 20
	max_speed = 50
	add_collision_exception_with(get_tree().current_scene.get_node("Player"))
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position

func chase() -> void:
	print("chasing, player pos: ", player.global_position)
	print("target pos: ", nav_agent.target_position)
	print("next path pos: ", nav_agent.get_next_path_position())
	print("my pos: ", global_position)
	if nav_agent.is_navigation_finished():
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var vector_to_next_point: Vector2 = (next_pos - global_position).normalized()
	
	mov_direction = vector_to_next_point
	
	if vector_to_next_point.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

func _on_path_timer_timeout() -> void:
	nav_agent.target_position = player.global_position
