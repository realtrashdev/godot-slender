extends Enemy3D

enum State { HOVERING, ATTACK }

const ACTIVE_TIME: float = 10.0
const LIGHT_TIME: float = 8.0

var alive: bool = true
var state = State.HOVERING
var initial_offset: Vector3
var last_player_position: Vector3

var timer: Timer = Timer.new()
var light_on: bool = false
var light_amount: float = 0.0

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	# wait for spawner to set position
	await get_tree().process_frame
	spawn()
	
	if player:
		initial_offset = global_position
		last_player_position = player.global_position
	else:
		print("Eyes says: No player found :[")
		queue_free()
	
	light_on = player.flashlight_component.get_light_status()
	timer.paused = !light_on
	life_cycle()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_light") and player.active:
		if not light_on: # this occurs first, so reversing is necessary
			var new_time = timer.time_left - 2
			timer.stop()
			timer.start(new_time)
			timer.paused = false
			print("Light on, subtracted 2 from time left and resumed")
		else:
			timer.paused = true
			print("Light off, timer paused")

func _process(delta: float) -> void:
	light_on = player.flashlight_component.get_light_status()
	check_player_collision()
	
	if not light_on:
		light_amount += delta
		if light_amount >= LIGHT_TIME and alive:
			alive = false
			die()

func _physics_process(delta: float) -> void:
	if state == State.HOVERING:
		var player_movement = player.global_position - last_player_position
		global_position += player_movement
		last_player_position = player.global_position
	elif state == State.ATTACK:
		var speed = 30.0
		global_position = global_position.move_toward(player.global_position, speed * delta)
		move_and_slide()

func life_cycle():
	add_child(timer)
	timer.start(ACTIVE_TIME)
	await timer.timeout
	$AttackAudio.play()
	state = State.ATTACK

func spawn():
	$MeshInstance3D.mesh.size = Vector2(5, 0)
	create_tween().tween_property($MeshInstance3D.mesh, "size", Vector2(5, 5), 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func die():
	var tween = create_tween()
	tween.tween_property($MeshInstance3D.mesh, "size", Vector2(5, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	died.emit()
	queue_free()
