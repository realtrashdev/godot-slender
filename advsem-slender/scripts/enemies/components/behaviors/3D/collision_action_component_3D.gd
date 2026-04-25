class_name CollisionActionComponent3D extends EnemyBehavior3D

@export var delete_on_action: bool = true
@export var action_to_perform: EnemyAction

func _physics_update(delta: float) -> void:
	var body = enemy.get_character_body_3d()
	
	# Check what we collided with during movement
	for i in body.get_slide_collision_count():
		var collision = body.get_slide_collision(i)
		
		if body == null:
			continue
		
		if collision.get_collider().is_in_group("Player"):
			_action()
			if delete_on_action: enemy.queue_free()
			return


func _action():
	if action_to_perform is EnemyActionKill:
		action_to_perform.perform_action(enemy.profile)
		return
	action_to_perform.perform_action()
