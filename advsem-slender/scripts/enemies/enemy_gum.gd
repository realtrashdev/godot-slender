extends Enemy2D

## Gum
## 2D bouncing enemy that appears as screen overlay
## Player must click on it to kill
## Restricts player camera movement while active

@export var death_sound: AudioStream

# movement constants
const BASE_MOVE_SPEED: float = 1200.0
const SPEED_VARIABILITY: float = 600.0

var border_pos: Vector2
var move_speed: Vector2
var direction: Vector2 = Vector2(1, 1)

# onready references
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var control: Control = $BounceArea/Control
@onready var gum: AnimatedSprite2D = $BounceArea/Control/Button/gum
@onready var running_sound: AudioStreamPlayer = $RunningSound

func _ready() -> void:
	setup_screen_bounds()
	
	if not player:
		$RichTextLabel.visible = false

func _physics_process(delta: float) -> void:
	update_position(delta)
	check_bounds()


## initialization
func setup_screen_bounds() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	border_pos = Vector2(screen_size.x - control.size.x, screen_size.y - control.size.y)


## state management
func activate() -> void:
	visible = true
	
	randomize_bounce()
	play_running_sound()
	apply_player_restriction()

func deactivate() -> void:
	stop_running_sound()
	play_death_sound()
	remove_player_restriction()
	
	died.emit()  # notify spawner
	queue_free()

func instant_deactivate():
	remove_player_restriction()
	
	queue_free()

## movement logic
func update_position(delta: float) -> void:
	control.position.x += move_speed.x * delta * direction.x
	control.position.y += move_speed.y * delta * direction.y

func check_bounds() -> void:
	var bounced = false
	
	# horizontal bounds
	if control.position.x >= border_pos.x:
		direction.x = -1
		bounced = true
	elif control.position.x <= 0:
		direction.x = 1
		bounced = true
	
	# vertical bounds
	if control.position.y >= border_pos.y:
		direction.y = -1
		bounced = true
	elif control.position.y <= 0:
		direction.y = 1
		bounced = true
	
	if bounced:
		update_sprite_flip()

func randomize_bounce() -> void:
	# randomize speed & ensure total speed stays relatively constant
	move_speed.x = BASE_MOVE_SPEED + randf_range(-SPEED_VARIABILITY, SPEED_VARIABILITY)
	move_speed.y = BASE_MOVE_SPEED * 2 - move_speed.x
	
	# random starting position
	control.position.x = randf_range(0, border_pos.x)
	control.position.y = randf_range(0, border_pos.y)
	
	# random direction
	direction.x = random_direction()
	direction.y = random_direction()
	
	update_sprite_flip()

func random_direction() -> float:
	return 1.0 if randf() > 0.5 else -1.0

func update_sprite_flip() -> void:
	gum.flip_h = direction.x < 0


## audio
func play_running_sound() -> void:
	if not running_sound.playing:
		running_sound.play()

func stop_running_sound() -> void:
	running_sound.stop()

func play_death_sound() -> void:
	AudioTools.play_one_shot(get_tree(), death_sound, 1.0, -5.0)


## player interaction
func apply_player_restriction() -> void:
	if player and player.has_method("add_restriction"):
		var enemy_name = profile.name if profile else "Gum"
		player.add_restriction(PlayerRestriction.RestrictionType.CAMERA, enemy_name)

func remove_player_restriction() -> void:
	if player and player.has_method("remove_restrictions_from_source"):
		var enemy_name = profile.name if profile else "Gum"
		player.remove_restrictions_from_source(enemy_name)


## UI
func on_button_down() -> void:
	deactivate()
