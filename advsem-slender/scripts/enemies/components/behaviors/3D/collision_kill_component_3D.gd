class_name CollisionKillComponent3D extends EnemyBehavior3D

@export var delete_on_player_killed: bool = true

func _physics_update(delta: float) -> void:
	var body = enemy.get_character_body_3d()
	
	# Check what we collided with during movement
	for i in body.get_slide_collision_count():
		var collision = body.get_slide_collision(i)
		
		if body == null:
			continue
		
		if collision.get_collider().is_in_group("Player"):
			Signals.killed_player.emit(null)
			if delete_on_player_killed: enemy.queue_free()
			return
