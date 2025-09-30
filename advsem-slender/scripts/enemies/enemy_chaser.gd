extends Enemy3D

## Chaser
## Chases after player in a straight line. Disappears after the light shines on it for a period of time.
## Gets faster for each page collected.

# movement constants
const BASE_SPEED: float = 2.8
const SPEED_INCREMENT: float = 0.2
const LIGHT_SPEED_PENALTY: float = 1.0
const RUN_SPEED_MULTIPLIER: float = 15.0

# chase timing constants
const BASE_CHASE_TIME: float = 3.0
const CHASE_TIME_INCREMENT: float = 0.15

# state management
enum State { CHASING, FLEEING, DISABLED }
var current_state: State = State.CHASING
var is_lit: bool = false
var remaining_chase_time: float = 0.0

# onready references
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var ambient_music: AudioStreamPlayer3D = $"Ambient Music"
@onready var sprite: AnimatedSprite3D = $Sprite3D
@onready var pathfinding_component: PathfindingComponent = $PathfindingComponent

func _ready() -> void:
	setup_signals()
	play_spawn_animation()
	initialize_chase_time()
	debug_print_stats()

func _process(delta: float) -> void:
	update_light_state(delta)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	if not player or current_state == State.DISABLED:
		return
	
	move_and_slide()
	check_player_collision()


## initialization
func setup_signals() -> void:
	Signals.player_died.connect(die)

func play_spawn_animation() -> void:
	var original_scale = sprite.scale
	sprite.scale = Vector3.ZERO
	var tween = create_tween()
	tween.tween_property(sprite, "scale", original_scale, 0.25).set_trans(Tween.TRANS_CUBIC)

func initialize_chase_time() -> void:
	remaining_chase_time = calculate_chase_time()

func debug_print_stats() -> void:
	var enemy_name = profile.enemy_name if profile else "Chaser"
	print("Spawned %s - Speed: %.2f, Chase Time: %.2f" % [enemy_name, calculate_speed(), calculate_chase_time()])


## main update logic

# called every 6 ticks by PathfindingComponent
func pathfind() -> void:
	update_navigation()
	update_movement()

func check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("Player"):
			var enemy_name = profile.name if profile else "Chaser"
			Signals.killed_player.emit(enemy_name)
			collider.die()
			return

func update_light_state(delta: float) -> void:
	if is_lit and current_state == State.CHASING:
		remaining_chase_time -= delta
		sprite.start_shake(0.1)
		
		if remaining_chase_time <= 0:
			begin_fleeing()
	else:
		sprite.stop_shake()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func update_navigation() -> void:
	nav_agent.target_position = player.global_position

func update_movement() -> void:
	match current_state:
		State.CHASING:
			move_toward_player()
		State.FLEEING:
			move_away_from_player()

func move_toward_player() -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * calculate_speed()

func move_away_from_player() -> void:
	var direction = (global_position - player.global_position).normalized()
	velocity = direction * (calculate_speed() * RUN_SPEED_MULTIPLIER)


## state changes
func begin_fleeing() -> void:
	current_state = State.FLEEING
	play_flee_audio()
	play_shrink_animation()

func play_flee_audio() -> void:
	ambient_music.stream = preload("uid://b3sk41yuadbx2")
	ambient_music.play(0.05)
	ambient_music.max_distance = 60

func play_shrink_animation() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.01, 0.01, 1), 3.0)
	tween.finished.connect(on_flee_complete)

func on_flee_complete() -> void:
	died.emit()
	queue_free()


## calculations
func calculate_speed() -> float:
	var base = BASE_SPEED + (SPEED_INCREMENT * CurrentGameData.current_pages_collected)
	var penalty = LIGHT_SPEED_PENALTY if is_lit else 0.0
	return base - penalty

func calculate_chase_time() -> float:
	return BASE_CHASE_TIME + (CHASE_TIME_INCREMENT * CurrentGameData.current_pages_collected)


## public
func set_targeted(active: bool) -> void:
	is_lit = active

func die(_killer_name: String = "") -> void:
	died.emit()
	queue_free()
