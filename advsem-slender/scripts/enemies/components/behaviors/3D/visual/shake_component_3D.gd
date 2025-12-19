## Component that applies positional shaking to a target [Node3D].
class_name ShakeComponent3D extends EnemyBehavior3D

@export var target: Node3D
@export var shake_intensity: float = 0.1

var original_position: Vector3
var shake_timer: Timer
var is_shaking: bool = false


func _setup():
	if not target:
		target = get_parent()
	
	original_position = target.position
	
	shake_timer = Timer.new()
	shake_timer.wait_time = 0.05
	shake_timer.timeout.connect(_shake_update)
	add_child(shake_timer)
	
	enemy.state_changed.connect(_on_state_changed)


func _update(delta: float) -> void:
	start_shake()


func start_shake(intensity: float = 0.1):
	if not is_shaking:
		shake_intensity = intensity
		is_shaking = true
		shake_timer.start()


func _shake_update():
	if is_shaking:
		var random_offset = Vector3(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity),
			0
		)
		target.position = original_position + random_offset


func stop_shake():
	if is_shaking:
		is_shaking = false
		shake_timer.stop()
		target.position = original_position


func _on_state_changed(new_state: Enemy3D.State):
	if not is_active():
		stop_shake()
