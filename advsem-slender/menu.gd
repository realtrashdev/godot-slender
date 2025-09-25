@abstract class_name Menu extends CanvasLayer

@warning_ignore("unused_signal")
signal menu_selected(String)

enum MenuDirection { FORWARD, BACKWARD }

func menu_zoom_effect(zoom_amount: Vector2, time: float, trans_mode: Tween.TransitionType, ease_mode: Tween.EaseType):
	create_tween().tween_property($Menu, "scale", zoom_amount, time).set_trans(trans_mode).set_ease(ease_mode)

func change_scale(new_scale: Vector2):
	$Menu.scale = new_scale
