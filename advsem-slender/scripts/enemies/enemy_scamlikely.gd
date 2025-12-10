extends ComponentEnemy

const BatteryComponent = preload("uid://bl7j83h5ylc5h")

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
	if base.get_battery_state() == BatteryComponent.BatteryState.DEAD:
		return
	if not incoming_call_screen.call_active and timer <= 0:
		start_call()
	elif timer > 0:
		timer -= delta
	else:
		restart_timer()

func start_call():
	print("Start call")
	timer = 0
	incoming_call_screen.start_call()
	base.call_started()

func stop_call():
	base.call_ended()
	restart_timer()

func restart_timer():
	timer = randf_range(profile.min_spawn_time, profile.max_spawn_time)
