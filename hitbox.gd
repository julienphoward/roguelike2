extends Area2D
class_name Hitbox

@export var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_force: int = 300

@onready var collision_shape: CollisionShape2D = get_child(0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node2D) -> void:
	print("BODY: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage, knockback_direction, knockback_force)

func _on_area_entered(_area: Node2D) -> void:
	pass

func _process(_delta: float) -> void:
	pass
