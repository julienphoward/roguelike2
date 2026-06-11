extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Characters/Enemies/spawn_explosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Characters/Enemies/FlyingCreature/flying_creature.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = get_node("TileMap2")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("Enemy Positions")
@onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.global_position), 1, Vector2i.ZERO)
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.global_position) + Vector2i.UP, 2, Vector2i.ZERO)

func _spawn_enemies() -> void:
	print("spawning enemies, count: ", enemy_positions_container.get_child_count())
	for enemy_position in enemy_positions_container.get_children():
		print("spawning at: ", enemy_position.global_position)
		var enemy: CharacterBody2D = ENEMY_SCENES["FLYING_CREATURE"].instantiate()
		enemy.tree_exited.connect(_on_enemy_killed)
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)

		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_explosion)
func _on_player_detector_body_entered(body: CharacterBody2D) -> void:
	print("Player entered: ", body.name)
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()
