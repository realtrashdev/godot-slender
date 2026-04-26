class_name CollisionActionComponent3D extends EnemyBehavior3D

@export var delete_on_action: bool = true
@export var actions_to_perform: Array[EnemyAction]

func _physics_update(delta: float) -> void:
	var body = enemy.get_character_body_3d()
	
	# Check what we collided with during movement
	for i in body.get_slide_collision_count():
		var collision = body.get_slide_collision(i)
		
		if body == null:
			continue
		
		if collision.get_collider().is_in_group("Player"):
			_action()
			if delete_on_action: enemy.die()
			return


func _action():
	for action in actions_to_perform:
		if action is EnemyActionKill:
			action.perform_action(enemy.profile)
			return
		action.perform_action()
