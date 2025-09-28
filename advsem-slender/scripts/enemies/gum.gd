extends CanvasLayer

var profile: EnemyProfile

var base_move_speed: float = 1200
var speed_variability: float = 600

var border_pos: Vector2

var move_speed: Vector2
var direction: Vector2 = Vector2(1, 1)

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var control: Control = $BounceArea/Control
@onready var gum: AnimatedSprite2D = $BounceArea/Control/Button/gum
@onready var running_sound: AudioStreamPlayer = $RunningSound
@onready var death_sound: AudioStreamPlayer = $DeathSound

func _ready() -> void:
	border_pos = Vector2(1920 - control.size.x, 1080 - control.size.y)
	player.player_dead.connect(instant_deactivate)

func _physics_process(delta: float) -> void:
	check_bounds()
	control.position.x += (move_speed.x * delta) * direction.x
	control.position.y += (move_speed.y * delta) * direction.y
	
	if Input.is_action_just_pressed("shader_toggle"):
		activate()

func activate():
	visible = true
	running_sound.play()
	
	randomize_bounce()
	
	if player:
		player.add_restriction(PlayerRestriction.RestrictionType.CAMERA, "gum")

func deactivate():
	visible = false
	running_sound.stop()
	death_sound.play()

func instant_deactivate(na = 0):
	visible = false
	running_sound.stop()
	
	if player:
		player.remove_restrictions_from_source("gum")

func randomize_bounce():
	# speed
	move_speed.x = base_move_speed + randi_range(-speed_variability, speed_variability)
	move_speed.y = base_move_speed * 2 - move_speed.x
	
	# position
	control.position.x = randi_range(0, border_pos.x)
	control.position.y = randi_range(0, border_pos.y)
	
	# direction
	direction.x = random_direction()
	direction.y = random_direction()
	
	sprite_flip_update()

func check_bounds():
	if control.position.x >= border_pos.x:
		direction.x = -1
		sprite_flip_update()
	elif control.position.x <= 0:
		direction.x = 1
		sprite_flip_update()
	
	if control.position.y >= border_pos.y:
		direction.y = -1
		sprite_flip_update()
	elif control.position.y <= 0:
		direction.y = 1
		sprite_flip_update()

func random_direction() -> int:
	var num = randi_range(0, 1)
	if num == 0:
		return -1
	return 1

func sprite_flip_update():
	if direction.x == -1:
		gum.flip_h = true
	else:
		gum.flip_h = false

func _on_button_down() -> void:
	deactivate()
