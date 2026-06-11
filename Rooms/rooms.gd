extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/spawn_room.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/room_1.tscn"), preload("res://Rooms/room_2.tscn"), preload("res://Rooms/room_3.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/room_4.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: Vector2i = Vector2i(3,1)
const RIGHT_WALL_TILE_INDEX: Vector2i = Vector2i(3,5)
const LEFT_WALL_TILE_INDEX: Vector2i = Vector2i(4,5)

@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	_spawn_rooms()
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D = null
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
			
			add_child(room)
			previous_room = room
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
				
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2
			
			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				var target_y: float = -y + 2
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-3, -y + 2), 0, LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y + 2), 0, FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y + 2), 0, FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y + 2), 0, RIGHT_WALL_TILE_INDEX)
				
			var room_tilemap: TileMap = room.get_node("TileMap")
			var entrance: Marker2D = room.get_node("Entrance/Marker2D2")
			
			var doors = previous_room.get_node("Doors")

			var target_position = previous_room_door.global_position + Vector2.UP * corridor_height * TILE_SIZE
			add_child(room)
			var entrance_offset = entrance.global_position - room.global_position
			room.global_position = target_position - entrance_offset + Vector2.DOWN * TILE_SIZE
			var tilemap = room.get_node("TileMap")
			previous_room = room
