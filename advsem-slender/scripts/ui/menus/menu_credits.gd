extends Menu

@export var tab_order: Array[Control]
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
	go_to_menu(MenuConfig.MenuType.EXTRAS, MenuConfig.TransitionDirection.BACKWARD, true)
	manager.fade_out_music_and_swap(-60, 0.5, manager.music_dict["menu"], manager.base_music_pitch)


func _do_credits_loop():
	if index > tab_order.size():
		return
		
	var tab: Control = tab_order[index]
	tab.visible = true
	
	var has_key: bool = timed_credits_tabs.keys().has(tab)
	if not has_key:
		return
	
	var time: float = timed_credits_tabs[tab]
	if time <= 0:
		return
	
	await get_tree().create_timer(time).timeout
	
	index += 1
	tab.visible = false
	if timed_credits_tabs.is_empty():
		return
	_do_credits_loop()
