extends Menu

@export var timed_credits_tabs: Dictionary[Control, float]

var manager: MenuManager
var credits_music: AudioStream = preload("uid://cjg6hknm6qj2d")
var index = 0


func _ready() -> void:
	manager = get_parent() as MenuManager
	_do_credits_loop()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_on_back_pressed()


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	manager.fade_out_music_and_swap(-60, 0.5, manager.music_dict["menu"], manager.base_music_pitch)


func _do_credits_loop():
	var key: Control = timed_credits_tabs.keys()[index]
	key.visible = true
	if timed_credits_tabs[key] < 0:
		return
	await get_tree().create_timer(timed_credits_tabs[key]).timeout
	index += 1
	key.visible = false
	if timed_credits_tabs.is_empty():
		return
	_do_credits_loop()
