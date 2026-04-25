class_name MoveWithPlayerComponent3D extends EnemyBehavior3D
## Makes the enemy's position update in tandem with the player.
##
## Useful for enemies that hover around the player's head.


var _last_player_pos: Vector3
var _current_player_pos: Vector3


func _setup() -> void:
	_last_player_pos = enemy.player.global_position


func _update(delta: float) -> void:
	_current_player_pos = enemy.player.global_position
	enemy.global_position += get_offset_pos()
	_last_player_pos = _current_player_pos


func get_offset_pos() -> Vector3:
	return _current_player_pos - _last_player_pos
