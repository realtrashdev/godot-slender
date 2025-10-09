extends Camera3D

const BASE_FOV: float = 80.0
const RADAR_FOV: float = 55.0

var player: CharacterBody3D
var restriction_component: PlayerRestrictionComponent

var tween: Tween

func _ready() -> void:
	player = get_parent().get_parent()
	restriction_component = player.get_node("RestrictionComponent")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_radar"):
		if not restriction_component.check_for_restriction(PlayerRestriction.RestrictionType.RADAR):
			set_fov_smooth(RADAR_FOV, 0.3)
			$RayCast3D.enabled = false
		else:
			set_fov_smooth(BASE_FOV, 0.3)
			$RayCast3D.enabled = true

func set_fov_smooth(new_fov: float = BASE_FOV, time: float = 1):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "fov", new_fov, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween.kill()
