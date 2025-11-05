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
	#menu_manager.fade_in_music(-12, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			menu.scale = Vector2.ZERO
		MenuConfig.TransitionDirection.BACKWARD:
			menu.scale = Vector2(10, 10)
	
	var tween = menu.create_tween()
	tween.tween_property(menu, "scale", Vector2.ONE, TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(menu_manager.transition_fade, "color", Color(0, 0, 0, 0), TRANSITION_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	#if play_sound:
		#AudioTools.play_one_shot(menu.get_tree(), sfx_finish, 1.0, TRANSITION_VOLUME)
	
	await tween.finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# close current menu
func close(menu: Menu, direction: MenuConfig.TransitionDirection, play_sound: bool = true):
	#menu_manager.fade_out_music(-24, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	var tween = menu.create_tween()
	
	match direction:
		MenuConfig.TransitionDirection.FORWARD:
			tween.tween_property(menu, "scale", Vector2(10, 10), TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		MenuConfig.TransitionDirection.BACKWARD:
			tween.tween_property(menu, "scale", Vector2.ZERO, TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.parallel().tween_property(menu_manager.transition_fade, "color", Color.BLACK, TRANSITION_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	#if play_sound:
		#AudioTools.play_one_shot(menu.get_tree(), sfx_start, 1.0, TRANSITION_VOLUME)
	
	await tween.finished
