class_name MenuTransition extends RefCounted

const TRANSITION_TIME = 0.5
const TRANSITION_VOLUME = -10

var sfx_start = load("res://audio/menu/ui/transition_start.mp3")
var sfx_finish = load("res://audio/menu/ui/transition_finish.mp3")

# open next menu
func open(menu: Menu, direction: MenuConfig.TransitionDirection,  play_sound: bool = true):
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			menu.scale = Vector2.ZERO
		MenuConfig.TransitionDirection.BACKWARD:
			menu.scale = Vector2(10, 10)
	
	var tween = menu.create_tween()
	tween.tween_property(menu, "scale", Vector2.ONE, TRANSITION_TIME).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	if play_sound:
		AudioTools.play_one_shot(menu.get_tree(), sfx_finish, 1.0, TRANSITION_VOLUME)
	
	await tween.finished
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

# close current menu
func close(menu: Menu, direction: MenuConfig.TransitionDirection):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var tween = menu.create_tween()
	
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			tween.tween_property(menu, "scale", Vector2(10, 10), TRANSITION_TIME).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
		MenuConfig.TransitionDirection.BACKWARD:
			tween.tween_property(menu, "scale", Vector2.ZERO, TRANSITION_TIME).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	
	AudioTools.play_one_shot(menu.get_tree(), sfx_start, 1.0, TRANSITION_VOLUME)
	
	await tween.finished
