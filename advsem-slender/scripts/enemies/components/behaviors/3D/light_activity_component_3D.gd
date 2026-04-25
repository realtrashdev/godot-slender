class_name LightActivityComponent3D extends EnemyBehavior3D
## Changes state based on if player flashlight is on/off.


@export var state_dict: Dictionary[String, Enemy3D.State] = {
	"light_on": Enemy3D.State.ACTIVE,
	"light_off": Enemy3D.State.ACTIVE_REPELLING,
}


func _update(delta: float) -> void:
	if enemy.player.is_flashlight_on() and enemy.get_current_state() == state_dict["light_off"]:
		enemy.change_state(state_dict["light_on"])
	elif not enemy.player.is_flashlight_on() and enemy.get_current_state() == state_dict["light_on"]:
		enemy.change_state(state_dict["light_off"])
