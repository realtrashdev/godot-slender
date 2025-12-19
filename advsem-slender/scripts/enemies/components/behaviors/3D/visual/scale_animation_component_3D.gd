## Component that animates scale with tweens based on [enum Enemy3D.State].
class_name ScaleAnimationComponent3D extends EnemyBehavior3D

## [State, TweenSettings]
@export var tween_setting_dict: Dictionary[Enemy3D.State, ScaleTweenSettings]

var tween: Tween


func _setup() -> void:
	enemy.state_changed.connect(_on_state_changed)
	_on_state_changed(enemy.get_current_state())


func _on_state_changed(new_state: Enemy3D.State):
	if new_state in tween_setting_dict:
		var settings = tween_setting_dict[new_state]
		
		if settings.do_starting_scale:
			enemy.scale = settings.starting_scale
		
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(enemy, "scale", settings.final_value, settings.duration).set_ease(settings.easing).set_trans(settings.transition)
