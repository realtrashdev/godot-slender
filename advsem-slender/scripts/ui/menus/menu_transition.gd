class_name MenuTransition extends RefCounted

const TRANSITION_TIME = 0.5
const TRANSITION_VOLUME = -10

var menu_manager: Node3D

var sfx_start = load("res://audio/menu/ui/transition_start.mp3")
var sfx_finish = load("res://audio/menu/ui/transition_finish.mp3")

func initialize(manager: Node3D):
	menu_manager = manager

# open next menu
func open(menu: Menu, direction: MenuConfig.TransitionDirection,  play_sound: bool = true):
	var tween = menu.create_tween()
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			menu.scale = Vector2.ZERO
			tween.tween_property(menu, "scale", Vector2.ONE, TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		MenuConfig.TransitionDirection.BACKWARD:
			menu.scale = Vector2(20, 20)
			tween.tween_property(menu, "scale", Vector2.ONE, TRANSITION_TIME).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	menu_manager.transition_pixels.texture.noise.seed = randi()
	menu_manager.pixel_transition(0, 0.25, 0.05)
	
	await tween.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# close current menu
func close(menu: Menu, direction: MenuConfig.TransitionDirection, play_sound: bool = true):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var tween = menu.create_tween()
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			tween.tween_property(menu, "scale", Vector2(20, 20), TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		MenuConfig.TransitionDirection.BACKWARD:
			tween.tween_property(menu, "scale", Vector2.ZERO, TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	menu_manager.transition_pixels.texture.noise.seed = randi()
	menu_manager.pixel_transition(1, 0.25, 0.15)
	
	await tween.finished
