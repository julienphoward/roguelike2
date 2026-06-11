extends Area2D

@export var destination_scene: String = "res://Rooms/end_screen.tscn"

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("_teleport")
		
func _teleport():		
	get_tree().change_scene_to_file(destination_scene)
