extends Enemy

## Chaser Monster
## Chases after player in a straight line. Disappears after about 15 seconds.

## Gets faster for each page collected.
## Speed starts at 2.75 (Slightly higher than player default walk speed)
## Increases by .25 for each page collected.
## Shining the light on it will slow it down by 1.

const NAME: String = "Chaser"
# speed it chases at
const SPEED: float = 2.75
const SPEED_INCREMENT: float = 0.25
# how long it chases
const CHASE_TIME: float = 15.0
const CHASE_TIME_INCREMENT: float = 1
# speed when leaving
const RUN_SPEED: float = 15

var run_away: bool = false
var lit: bool = false

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_parent().player
@onready var ambient_music: AudioStreamPlayer3D = $"Ambient Music"
@onready var sprite: AnimatedSprite3D = $Sprite3D

func _ready() -> void:
	player.player_dead.connect(die)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(4, 4, 1), 0.25).set_trans(Tween.TRANS_CUBIC)
	print("Spawned " + NAME + " with " + str(get_speed()) + " speed and " + str(get_chase_time()) + " chase time")
	life_cycle()

func _process(delta: float) -> void:
	# check if touching player, if so quit the game for now
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider().is_in_group("Player"):
			coll.get_collider().die(NAME)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !player:
		return
	
	# go to player position
	nav_agent.target_position = player.global_position
	
	if run_away:
		nav_agent.target_position = player.global_position
		var direction = (global_position - nav_agent.target_position).normalized()
		velocity = direction * (get_speed() * RUN_SPEED)
	
	elif not nav_agent.is_navigation_finished():
		var next_path_position = nav_agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * (get_speed())
	
	move_and_slide()

func life_cycle():
	await get_tree().create_timer(get_chase_time()).timeout
	run_away = true
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.01, 0.01, 1), 3)
	await get_tree().create_timer(3).timeout
	queue_free()

func get_speed():
	return (SPEED + SPEED_INCREMENT * get_parent().pages_collected) - int(lit)

func get_chase_time():
	return CHASE_TIME + CHASE_TIME_INCREMENT * get_parent().pages_collected

func set_targeted(active: bool):
	lit = active

func die(e_name: String):
	queue_free()
