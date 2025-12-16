class_name GravityComponent3D extends EnemyBehavior3D

## Allows for heavier/lighter enemies
@export var gravity_multiplier: float = 1.0

var character_body: CharacterBody3D

func _setup() -> void:
	character_body = enemy.get_character_body_3d()
	if character_body == null:
		push_warning("%s: Enemy3D has no CharacterBody3D child. Deleting GravityComponent!" % name)
		queue_free()

func _physics_update(delta: float) -> void:
	if not character_body.is_on_floor():
		character_body.velocity += character_body.get_gravity() * gravity_multiplier
