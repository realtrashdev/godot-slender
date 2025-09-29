extends Enemy2D

## Gum
## 2D bouncing enemy that appears as screen overlay
## Player must click on it to kill
## Restricts camera movement while active

@export var death_sound: AudioStream

# Movement constants (enemy-specific behavior)
const BASE_MOVE_SPEED: float = 1200.0
const SPEED_VARIABILITY: float = 600.0

# State
enum State { INACTIVE, ACTIVE, DYING }
var current_state: State = State.INACTIVE

var border_pos: Vector2
var move_speed: Vector2
var direction: Vector2 = Vector2(1, 1)

# Cached references
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var control: Control = $BounceArea/Control
@onready var gum: AnimatedSprite2D = $BounceArea/Control/Button/gum
@onready var running_sound: AudioStreamPlayer = $RunningSound

func _ready() -> void:
	_setup_screen_bounds()
	_setup_player_connection()

func _physics_process(delta: float) -> void:
	if current_state != State.ACTIVE:
		return
	
	_update_position(delta)
	_check_bounds()


# Initialization
func _setup_screen_bounds() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	border_pos = Vector2(screen_size.x - control.size.x, screen_size.y - control.size.y)

func _setup_player_connection() -> void:
	if player and player.has_signal("player_dead"):
		player.player_dead.connect(_on_player_died)


# State Management
func activate() -> void:
	if current_state != State.INACTIVE:
		return
	
	current_state = State.ACTIVE
	visible = true
	
	_randomize_bounce()
	_play_running_sound()
	_apply_player_restriction()

func deactivate() -> void:
	if current_state == State.DYING:
		return
	
	current_state = State.DYING
	visible = false
	
	_stop_running_sound()
	_play_death_sound()
	_remove_player_restriction()
	
	died.emit()  # Notify spawner
	queue_free()  # Clean up instance

func _on_player_died(_killer_name: String = "") -> void:
	# Player died, immediately clean up without death animation/sound
	if current_state == State.INACTIVE:
		return
	
	current_state = State.DYING
	visible = false
	
	_stop_running_sound()
	_remove_player_restriction()
	
	# No died.emit() here since player is dead anyway
	queue_free()


# Movement Logic

func _update_position(delta: float) -> void:
	control.position.x += move_speed.x * delta * direction.x
	control.position.y += move_speed.y * delta * direction.y

func _check_bounds() -> void:
	var bounced = false
	
	# Horizontal bounds
	if control.position.x >= border_pos.x:
		direction.x = -1
		bounced = true
	elif control.position.x <= 0:
		direction.x = 1
		bounced = true
	
	# Vertical bounds
	if control.position.y >= border_pos.y:
		direction.y = -1
		bounced = true
	elif control.position.y <= 0:
		direction.y = 1
		bounced = true
	
	if bounced:
		_update_sprite_flip()

func _randomize_bounce() -> void:
	# Randomize speed (ensure total speed stays relatively constant)
	move_speed.x = BASE_MOVE_SPEED + randf_range(-SPEED_VARIABILITY, SPEED_VARIABILITY)
	move_speed.y = BASE_MOVE_SPEED * 2 - move_speed.x
	
	# Random starting position
	control.position.x = randf_range(0, border_pos.x)
	control.position.y = randf_range(0, border_pos.y)
	
	# Random direction
	direction.x = _random_direction()
	direction.y = _random_direction()
	
	_update_sprite_flip()

func _random_direction() -> float:
	return 1.0 if randf() > 0.5 else -1.0

func _update_sprite_flip() -> void:
	gum.flip_h = direction.x < 0


# Audio

func _play_running_sound() -> void:
	if not running_sound.playing:
		running_sound.play()

func _stop_running_sound() -> void:
	running_sound.stop()

func _play_death_sound() -> void:
	AudioTools.play_one_shot(get_tree(), death_sound, 1.0, -5.0)


# Player Interaction

func _apply_player_restriction() -> void:
	if player and player.has_method("add_restriction"):
		var enemy_name = profile.name if profile else "Gum"
		player.add_restriction(PlayerRestriction.RestrictionType.CAMERA, enemy_name)

func _remove_player_restriction() -> void:
	if player and player.has_method("remove_restrictions_from_source"):
		var enemy_name = profile.name if profile else "Gum"
		player.remove_restrictions_from_source(enemy_name)


# UI Callbacks

func _on_button_down() -> void:
	if current_state == State.ACTIVE:
		deactivate()
