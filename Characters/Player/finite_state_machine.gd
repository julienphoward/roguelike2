extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	call_deferred("set_state", states.idle)

func _state_logic(_delta: float) -> void:
	if state == states.idle or state == states.move:
		parent.get_input()
		parent.move()

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
		states.hurt:
			if not parent.get_node("AnimationPlayer").is_playing():
				return states.idle
		states.dead:
			if not parent.get_node("AnimationPlayer").is_playing():
				get_tree().reload_current_scene()
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			parent.animated_sprite.play("idle")
		states.move:
			parent.animated_sprite.play("move")
		states.hurt:
			parent.get_node("AnimationPlayer").play("hurt")
		states.dead:
			parent.get_node("AnimationPlayer").play("dead")
			parent.get_node("Sword").visible = false
			for enemy in get_tree().get_nodes_in_group("enemies"):
				enemy.stop_chasing()
