extends ComponentEnemy

var base: RadarScreen

var timer: float = 1000

var incoming_call_screen: Node2D

func _ready() -> void:
	base = get_parent().get_node("Radar/SubViewport/RadarScreen")
	reparent(base)
	incoming_call_screen = base.incoming_call_screen
	incoming_call_screen.call_ended.connect(stop_call)
	restart_timer()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not incoming_call_screen.call_active:
		start_call()
	
	if not incoming_call_screen.call_active and timer <= 0:
		start_call()
	elif timer >= 0:
		timer -= delta
	else:
		restart_timer()

func start_call():
	print("Call started")
	timer = 0
	incoming_call_screen.start_call()
	base.call_started()

func stop_call():
	print("Call ended")
	base.call_ended()

func restart_timer():
	timer = randf_range(profile.min_spawn_time, profile.max_spawn_time)
	print("new spawn time: " + str(timer))
