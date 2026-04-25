class_name EnemyActionDrainBattery extends EnemyAction

@export var permanent: bool = true
@export var chunks_to_drain: int = 1


func perform_action():
	Signals.radar_battery_drained.emit(chunks_to_drain, permanent)
