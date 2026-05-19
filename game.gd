extends Node2D

func _init() -> void:
	var screen_size: Vector2 = DisplayServer.screen_get_size()
	var window_size: Vector2 = DisplayServer.window_get_size()
	
	DisplayServer.window_set_position(screen_size * 0.5 - window_size * 0.5)
