extends Enemy3D

## Chaser
## Chases after player in a straight line. Disappears after the light shines on it for a period of time.
## Gets faster for each page collected.

# Movement constants (enemy-specific behavior)
const BASE_SPEED: float = 2.8
const SPEED_INCREMENT: float = 0.2
const LIGHT_SPEED_PENALTY: float = 1.0
const RUN_SPEED_MULTIPLIER: float = 15.0

# Chase timing constants (enemy-specific behavior)
const BASE_CHASE_TIME: float = 3.0
const CHASE_TIME_INCREMENT: float = 0.15

# State
enum State { CHASING, FLEEING, DISABLED }
var current_state: State = State.CHASING
var is_lit: bool = false
var remaining_chase_time: float = 0.0
var collision_check_timer: float = 0.0

# Performance constants
const COLLISION_CHECK_RATE: float = 0.1  # Check every 0.1 seconds

# Cached references
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var ambient_music: AudioStreamPlayer3D = $"Ambient Music"
@onready var sprite: AnimatedSprite3D = $Sprite3D

func _ready() -> void:
	_setup_player_connection()
	_play_spawn_animation()
	_initialize_chase_time()
	_debug_print_stats()

func _process(delta: float) -> void:
	collision_check_timer += delta
	if collision_check_timer >= COLLISION_CHECK_RATE:
		_check_player_collision()
		collision_check_timer = 0.0
	
	_update_light_state(delta)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	if not player or current_state == State.DISABLED:
		return
	
	_update_navigation()
	_update_movement()
	move_and_slide()

# ==============================================================================
# Initialization
# ==============================================================================

func _setup_player_connection() -> void:
	if player and player.has_signal("player_dead"):
		player.player_dead.connect(die)

func _play_spawn_animation() -> void:
	var original_scale = sprite.scale
	sprite.scale = Vector3.ZERO
	var tween = create_tween()
	tween.tween_property(sprite, "scale", original_scale, 0.25).set_trans(Tween.TRANS_CUBIC)

func _initialize_chase_time() -> void:
	remaining_chase_time = _calculate_chase_time()

func _debug_print_stats() -> void:
	var enemy_name = profile.enemy_name if profile else "Chaser"
	print("Spawned %s - Speed: %.2f, Chase Time: %.2f" % [enemy_name, _calculate_speed(), _calculate_chase_time()])

# ==============================================================================
# Main Update Logic
# ==============================================================================

func _check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("Player"):
			var enemy_name = profile.name if profile else "Chaser"
			collider.die(enemy_name)
			return

func _update_light_state(delta: float) -> void:
	if is_lit and current_state == State.CHASING:
		remaining_chase_time -= delta
		sprite.start_shake(0.1)
		
		if remaining_chase_time <= 0:
			_begin_fleeing()
	else:
		sprite.stop_shake()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func _update_navigation() -> void:
	nav_agent.target_position = player.global_position

func _update_movement() -> void:
	match current_state:
		State.CHASING:
			_move_toward_player()
		State.FLEEING:
			_move_away_from_player()

func _move_toward_player() -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * _calculate_speed()

func _move_away_from_player() -> void:
	var direction = (global_position - player.global_position).normalized()
	velocity = direction * (_calculate_speed() * RUN_SPEED_MULTIPLIER)

# ==============================================================================
# State Changes
# ==============================================================================

func _begin_fleeing() -> void:
	current_state = State.FLEEING
	_play_flee_audio()
	_play_shrink_animation()

func _play_flee_audio() -> void:
	ambient_music.stream = preload("uid://b3sk41yuadbx2")
	ambient_music.play(0.05)
	ambient_music.max_distance = 60

func _play_shrink_animation() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.01, 0.01, 1), 3.0)
	tween.finished.connect(_on_flee_complete)

func _on_flee_complete() -> void:
	died.emit()
	queue_free()

# ==============================================================================
# Calculations
# ==============================================================================

func _calculate_speed() -> float:
	var base = BASE_SPEED + (SPEED_INCREMENT * CurrentGameData.current_pages_collected)
	var penalty = LIGHT_SPEED_PENALTY if is_lit else 0.0
	return base - penalty

func _calculate_chase_time() -> float:
	return BASE_CHASE_TIME + (CHASE_TIME_INCREMENT * CurrentGameData.current_pages_collected)

# ==============================================================================
# Public API
# ==============================================================================

func set_targeted(active: bool) -> void:
	is_lit = active

func die(_killer_name: String = "") -> void:
	died.emit()
	queue_free()

# ==============================================================================
# Legacy compatibility (if needed)
# ==============================================================================

func stop_chase() -> void:
	_begin_fleeing()

func get_speed() -> float:
	return _calculate_speed()

func get_chase_time() -> float:
	return _calculate_chase_time()
