extends FiniteStateMachine

func _init() -> void:
	_add_state("chase")
	_add_state("hurt")


func _ready() -> void:
	set_state(states.chase)

func _state_logic(_delta: float) -> void:
	if state == states.chase:
		get_parent().chase()
		get_parent().move()

func _get_transition() -> int:
	match state:
		states.hurt:
			if not get_parent().get_node("AnimationPlayer").is_playing():
				return states.chase
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.chase:
			get_parent().get_node("AnimationPlayer").play("fly")
		states.hurt:
			get_parent().get_node("AnimationPlayer").play("hurt")
