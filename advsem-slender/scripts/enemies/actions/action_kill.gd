class_name EnemyActionKill extends EnemyAction


func perform_action(profile: EnemyProfile):
	Signals.killed_player.emit(profile)
