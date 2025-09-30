extends AnimatedSprite3D

var original_position: Vector3
var shake_intensity: float = 0.1
var shake_timer: Timer
var is_shaking: bool = false

func _ready():
	original_position = position
	
	shake_timer = Timer.new()
	shake_timer.wait_time = 0.05 # Update every 0.05 seconds
	shake_timer.timeout.connect(_shake_update)
	add_child(shake_timer)

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
		position = original_position + random_offset

func stop_shake():
	if is_shaking:
		is_shaking = false
		shake_timer.stop()
		position = original_position
