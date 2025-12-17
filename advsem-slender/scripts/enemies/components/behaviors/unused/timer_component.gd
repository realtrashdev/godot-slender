class_name TimerComponent extends Node

## Other components can add timers here by name
var timers: Dictionary[String, Timer]

# Public methods

func add_timer(timer_name: String, timer_duration: float) -> Timer:
	var timer: Timer = Timer.new()
	timer.start(timer_duration)
	return timer
