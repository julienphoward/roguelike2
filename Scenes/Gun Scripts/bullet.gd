extends Area2D

var speed = 300
@export var damage: int = 2
@export var knockback_force: int = 300
var knockback_direction = Vector2.RIGHT.rotated(rotation)

func _on_body_entered(body: Node2D) -> void:
	var direction = (body.global_position - global_position).normalized()
	
	if body.has_method("take_damage"):
		body.take_damage(damage, direction, knockback_force)
		
	print("HIT ENEMY! DAMAGE:", damage)
		
	queue_free()

func _ready():
	set_as_top_level(true)

	body_entered.connect(_on_body_entered)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _physics_process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
