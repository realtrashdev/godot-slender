extends OldEnemy3D

enum State { HOVERING, ATTACK }

const ACTIVE_TIME: float = 10.0
const LIGHT_TIME: float = 8.0

var alive: bool = true
var state = State.HOVERING
var initial_offset: Vector3
var last_player_position: Vector3 = Vector3.ZERO

var tween: Tween
var timer: Timer = Timer.new()
var light_on: bool = false
var light_amount: float = 0.0

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var attack_audio: AudioStreamPlayer3D = $AttackAudio

func _ready() -> void:
	mesh.mesh = mesh.mesh.duplicate()
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
	if not player or not player.active:
		return
	
	if event.is_action_pressed("toggle_light"):
		if not light_on:
			var new_time = timer.time_left - 2
			if new_time <= 0:
				timer.timeout.emit()
				return
			timer.stop()
			timer.start(new_time)
			timer.paused = false
		else:
			timer.paused = true

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
		pass
	elif state == State.ATTACK:
		var speed = 30.0
		global_position = global_position.move_toward(player.global_position, speed * delta)
		move_and_slide()

func life_cycle():
	add_child(timer)
	timer.start(ACTIVE_TIME)
	await timer.timeout
	attack_audio.play()
	state = State.ATTACK

func spawn():
	mesh.mesh.size = Vector2(5, 0)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(mesh.mesh, "size", Vector2(5, 5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func die():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(mesh.mesh, "size", Vector2(5, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	died.emit()
	queue_free()
