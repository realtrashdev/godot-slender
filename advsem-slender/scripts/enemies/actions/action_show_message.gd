class_name EnemyActionShowMessage extends EnemyAction

@export var message: String = "N/A"


func perform_action() -> void:
	Signals.show_message.emit(message)
