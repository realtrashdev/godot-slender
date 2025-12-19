## Component that updates an [AnimatedSprite3D]'s animation based on [enum Enemy3D.State].
class_name SpriteAnimationComponent3D extends EnemyBehavior3D

@export var animation_name_dict: Dictionary[Enemy3D.State, String]

var sprite: AnimatedSprite3D


func _setup() -> void:
	sprite = enemy.get_animated_sprite_3d()
	assert(sprite != null, "%s: Enemy must have AnimatedSprite3D child!" % name)
	enemy.state_changed.connect(_on_state_changed)


func _on_state_changed(new_state: Enemy3D.State):
	if new_state in animation_name_dict:
		sprite.animation = animation_name_dict[new_state]
