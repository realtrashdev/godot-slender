extends CharacterBody3D

## Chaser Monster
## Chases after player in a straight line. Disappears after about 15 seconds.

## Gets faster for each page collected.
## Speed starts at 2.25 (Slightly higher than player default walk speed)
## Increases by .25 for each page collected.

## TODO
## Implement spawning
## Rework death to not close the game

const SPEED: float = 2.25
const SPEED_INCREMENT: float = 0.25

var extra_speed: float = 0

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var ambient_music: AudioStreamPlayer3D = $"Ambient Music"

var chasing: bool = false

func _ready() -> void:
	Signals.page_collected.connect(page_collect)
	await get_tree().create_timer(3).timeout
	ambient_music.play()
	chasing = true

func _process(delta: float) -> void:
	if !ambient_music.playing and chasing:
		queue_free()
	
	# check if touching player, if so quit the game for nows
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider().is_in_group("Player"):
			get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !player:
		return
	
	nav_agent.target_position = player.global_position
	
	if not nav_agent.is_navigation_finished():
		var next_path_position = nav_agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * (SPEED + extra_speed)
	
	move_and_slide()

func page_collect():
	extra_speed += SPEED_INCREMENT
