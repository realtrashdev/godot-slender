class_name ScaleTweenSettings extends Resource

@export var final_value: Vector3 = Vector3.ONE
@export var duration: float = 1.0
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition: Tween.TransitionType = Tween.TRANS_CUBIC

@export_group("Starting Scale")
@export var do_starting_scale: bool = false
@export var starting_scale: Vector3 = Vector3.ONE
