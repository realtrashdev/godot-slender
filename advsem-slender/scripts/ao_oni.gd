extends CharacterBody3D


const SPEED = 2.5

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var ambient_music: AudioStreamPlayer3D = $"Ambient Music"

var chasing: bool = false

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	ambient_music.play()
	chasing = true

func _process(delta: float) -> void:
	if !ambient_music.playing and chasing:
		queue_free()

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
		velocity = direction * SPEED
	
	move_and_slide()
