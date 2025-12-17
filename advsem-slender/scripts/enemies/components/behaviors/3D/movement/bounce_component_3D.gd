## Makes enemies bounce!
## [br][color=red]Required Component(s):[/color]
## [br]- [GravityComponent3D]
##
## Has adjustable:
## [br]- Minimum/Maximum bounce power
## [br]- Minimum/Maximum cooldown between bounces
## [br]
## [br]Recommended on enemies with very low gravity multiplier (0.1).
## [br]This creates a sort of space jumping effect.
class_name BounceComponent3D extends EnemyBehavior3D

@export_subgroup("Bounce Settings", "bounce_")
@export var bounce_power_min: float = 5.0
@export var bounce_power_max: float = 10.0
@export var bounce_cooldown_min: float = 0.0
@export var bounce_cooldown_max: float = 0.0

var character_body: CharacterBody3D
var cooldown: float = 0.0

func _setup() -> void:
	character_body = enemy.get_character_body_3d()

func _physics_process(delta: float) -> void:
	if character_body.is_on_floor():
		character_body.velocity.y += randf_range(bounce_power_min, bounce_power_max)
