extends Node3D

var current_menu: Menu
var menu_transition: MenuTransition

@onready var music: AudioStreamPlayer = $Music
@onready var quit_audio: AudioStreamPlayer = $QuitAudio

func _ready() -> void:
	menu_transition = MenuTransition.new()
	fade_in_music()
	open_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.FORWARD, false)

func open_menu(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool = true):
	var scene_path = MenuConfig.MENU_SCENES.get(type)
	if not scene_path:
		push_error("Menu type not found: " + str(type))
		return
	
	if current_menu:
		await menu_transition.close(current_menu, direction)
		current_menu.queue_free()
	
	current_menu = load(scene_path).instantiate()
	current_menu.menu_changed.connect(on_menu_changed)
	add_child(current_menu)
	menu_transition.open(current_menu, direction, play_sound)

func on_menu_changed(new_menu: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection):
	match new_menu:
		MenuConfig.MenuType.QUIT:
			await quit_game()
		MenuConfig.MenuType.START_GAME:
			await start_game()
		_:
			open_menu(new_menu, direction)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await menu_transition.close(current_menu, MenuConfig.TransitionDirection.FORWARD)
	get_tree().change_scene_to_file(MenuConfig.DEFAULT_GAME_SCENE)

func quit_game():
	quit_audio.play()
	create_tween().tween_property(quit_audio, "volume_db", -40, 0.6).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	fade_out_music()
	await menu_transition.close(current_menu, MenuConfig.TransitionDirection.BACKWARD)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func fade_in_music():
	create_tween().tween_property(music, "volume_db", -12.0, 1)

func fade_out_music():
	create_tween().tween_property(music, "volume_db", -60.0, 0.6)
