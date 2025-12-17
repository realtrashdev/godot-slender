extends Node

enum BatteryState { ALIVE, DEAD, OVERCHARGED }

signal charged
signal out_of_battery

const STARTING_CHUNKS: int = 4

const BATTERY_PER_CHUNK: float = 20.0
const PAGE_CHARGE_AMOUNT: float = 20.0

const IDLE_BATTERY_LOSS: float = 0.2
const ACTIVE_BATTERY_LOSS: float = 0.8
const RINGING_BATTERY_LOSS: float = 2.0

var battery_container: HBoxContainer

var state: BatteryState = BatteryState.ALIVE
var battery_remaining: float = 45.0
var dead: bool = false

func initialize(container):
	battery_container = container
	Signals.page_collected.connect(_on_page_collected)

func activate():
	battery_remaining = _get_starting_battery()

func deactivate():
	pass

func update(delta: float, screen_state: RadarScreen.ScreenState):
	if battery_remaining > 0.0:
		_add_charge(_get_battery_loss(screen_state) * -delta)
		_check_if_dead()
	_update_visible_chunks()

# Public methods
func get_battery_state() -> BatteryState:
	return state

func get_battery_remaining() -> float:
	return battery_remaining

# Private methods
func _get_chunks() -> Array[Node]:
	if not battery_container: return []
	return battery_container.get_children()

func _get_visible_chunks() -> int:
	return ceili(battery_remaining / BATTERY_PER_CHUNK)

func _update_visible_chunks() -> void:
	var remaining = _get_visible_chunks()
	for child in _get_chunks():
		if remaining == 0:
			child.modulate = Color.TRANSPARENT
			continue
		child.modulate = Color.WHITE
		remaining -= 1

func _get_maximum_battery() -> float:
	return BATTERY_PER_CHUNK * float(_get_chunks().size())

func _get_starting_battery() -> float:
	return BATTERY_PER_CHUNK * float(_get_chunks().size() - 1)

func _get_battery_loss(screen_state: RadarScreen.ScreenState):
	match screen_state:
		RadarScreen.ScreenState.OFF:
			return 0.0
		RadarScreen.ScreenState.IDLE:
			return IDLE_BATTERY_LOSS
		RadarScreen.ScreenState.ACTIVE:
			return ACTIVE_BATTERY_LOSS
		RadarScreen.ScreenState.RINGING:
			return RINGING_BATTERY_LOSS

func _add_charge(charge: float):
	battery_remaining += charge
	if battery_remaining > _get_maximum_battery():
		battery_remaining = _get_maximum_battery()
	if battery_remaining > 0 and state == BatteryState.DEAD:
		state = BatteryState.ALIVE
		print("Radar alive")
	charged.emit()

func _check_if_dead() -> bool:
	if dead: return true
	if battery_remaining <= 0 and not state == BatteryState.DEAD:
		state = BatteryState.DEAD
		out_of_battery.emit()
		print("Radar died")
		return true
	return false

func _on_page_collected():
	_add_charge(PAGE_CHARGE_AMOUNT)
