extends Node3D

var current_menu: Menu
var menu_transition: MenuTransition

@onready var music: AudioStreamPlayer = $Music
@onready var secrets: Node = $Secrets
@onready var quit_audio: AudioStreamPlayer = $QuitAudio
@onready var transition_fade: ColorRect = $TransitionLayer/TransitionFade

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_transition = MenuTransition.new()
	menu_transition.initialize(self)
	fade_in_music(-12, 1.0)
	open_menu_instant(MenuConfig.MenuType.INTRO, MenuConfig.TransitionDirection.FORWARD, false)

func open_menu(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool = true):
	var scene_path = MenuConfig.MENU_SCENES.get(type)
	if not scene_path:
		push_error("Menu type not found: " + str(type))
		return
	
	if current_menu:
		await menu_transition.close(current_menu, direction, play_sound)
		current_menu.queue_free()
	
	if type == MenuConfig.MenuType.MAIN and not secrets.enabled:
		music.play()
		secrets.enabled = true
	
	current_menu = load(scene_path).instantiate()
	current_menu.menu_changed.connect(on_menu_changed)
	add_child(current_menu)
	menu_transition.open(current_menu, direction, play_sound)
	
func open_menu_instant(type: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool = true):
	var scene_path = MenuConfig.MENU_SCENES.get(type)
	if not scene_path:
		push_error("Menu type not found: " + str(type))
		return
	
	if current_menu:
		await menu_transition.close(current_menu, direction, play_sound)
		current_menu.queue_free()
	
	current_menu = load(scene_path).instantiate()
	current_menu.menu_changed.connect(on_menu_changed)
	add_child(current_menu)

func on_menu_changed(new_menu: MenuConfig.MenuType, direction: MenuConfig.TransitionDirection, play_sound: bool):
	match new_menu:
		MenuConfig.MenuType.QUIT:
			await quit_game()
		MenuConfig.MenuType.START_GAME:
			await start_game()
		_:
			open_menu(new_menu, direction, play_sound)

func start_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fade_out_music(-60, 0.2)
	await menu_transition.close(current_menu, MenuConfig.TransitionDirection.FORWARD)
	get_tree().change_scene_to_packed(Settings.get_selected_map().scene)

func quit_game():
	quit_audio.play()
	create_tween().tween_property(quit_audio, "volume_db", -40, 0.6).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	fade_out_music(-60, 0.6)
	await menu_transition.close(current_menu, MenuConfig.TransitionDirection.BACKWARD)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func fade_in_music(vol: float, time: float, transition: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT):
	create_tween().tween_property(music, "volume_db", vol, time).set_trans(transition).set_ease(easing)

func fade_out_music(vol: float, time: float, transition: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT):
	create_tween().tween_property(music, "volume_db", vol, time).set_trans(transition).set_ease(easing)
