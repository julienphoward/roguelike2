extends Character

@onready var sword: Node2D = get_node("Sword")
@onready var sword_animation_player: AnimationPlayer = sword.get_node("SwordAnimationPlayer")
@onready var sword_hitbox: Area2D = get_node("Sword/Node2D/Sprite2D/Hitbox")

@onready var gun: Node2D = get_node("Gun")

#Vars for Gun/Bullet
var gun_equipped = false
var gun_cooldown = true
var sword_equipped = true
var bullet = preload("res://Scenes/Bullet.tscn")
var mouse_location_from_player = null

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
	if gun_equipped:
		gun.rotation = mouse_direction.angle()
	
	if mouse_direction.x < 0:
		gun.scale.y = -1
	else: 
		gun.scale.y = 1
	
func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP
	if Input.is_action_just_pressed("ui_attack") and sword_equipped and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")
	
	#Finds position of mouse relative to player (for aiming gun later)
	mouse_location_from_player = get_global_mouse_position() - self.position
	
	#Gun equipping logic
	if Input.is_action_just_pressed("input_e"):
		if gun_equipped:
			gun_equipped = false
			sword_equipped = true
		else:
			gun_equipped = true	
			sword_equipped = false
			
		update_weapons()
		
	#Bullet direction logic
	var mouse_position = get_global_mouse_position()
	$BulletSpawn.look_at(mouse_position)
	
	#Bullet firing logic
	if Input.is_action_just_pressed("ui_attack") and gun_equipped and gun_cooldown: 	
		gun_cooldown = false
		var bullet_instance = bullet.instantiate()
		bullet_instance.rotation = $BulletSpawn.rotation
		bullet_instance.global_position = $BulletSpawn.global_position
		add_child(bullet_instance)
		
		#Gun cooldown logic
		await get_tree().create_timer(0.8).timeout
		gun_cooldown = true
		
#Disables sword hitbox and sprite when not equipped
func update_weapons():
	sword.visible = sword_equipped
	sword_hitbox.monitoring = sword_equipped
	
	gun.visible = gun_equipped
	
func _ready() -> void:
	update_weapons()
