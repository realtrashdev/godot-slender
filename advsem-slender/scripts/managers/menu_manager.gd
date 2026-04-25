class_name MenuManager extends Node3D

var current_menu: Menu
var menu_transition: MenuTransition

var base_music_volume: float
var base_music_pitch: float
var can_switch_music: bool = true
var music_dict: Dictionary[String, AudioStream] = {
	"menu": preload("uid://bw13p4ixmh3mk"),
	"credits": preload("uid://cjg6hknm6qj2d"),
}

@onready var music: AudioStreamPlayer = $Music
@onready var secrets: Node = $Secrets
@onready var quit_audio: AudioStreamPlayer = $QuitAudio
@onready var background: TextureRect = $Background
@onready var pixel_transition: PixelTransition = $PixelTransition


func _ready() -> void:
	base_music_volume = music.volume_db
	base_music_pitch = music.pitch_scale
	secrets.bg_typed.connect(_on_bg_typed)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_transition = MenuTransition.new()
	menu_transition.initialize(self)
	fade_in_music(-8, 1.0)
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
	
	_update_background_noise_seed(type)


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
	
	_update_background_noise_seed(type)


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
	#quit_audio.play()
	#create_tween().tween_property(quit_audio, "volume_db", -40, 0.6).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	fade_out_music(-60, 0.6)
	await menu_transition.close(current_menu, MenuConfig.TransitionDirection.BACKWARD)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func fade_in_music(vol: float, time: float, transition: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT):
	create_tween().tween_property(music, "volume_db", vol, time).set_trans(transition).set_ease(easing)


func fade_out_music(vol: float, time: float, transition: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT):
	create_tween().tween_property(music, "volume_db", vol, time).set_trans(transition).set_ease(easing)


func fade_out_music_and_swap(vol: float, time: float, new_stream: AudioStream, new_pitch: float = 1.0, transition: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT):
	var tween = create_tween().tween_property(music, "volume_db", vol, time).set_trans(transition).set_ease(easing)
	await tween.finished
	music.stop()
	music.stream = new_stream
	music.volume_db = base_music_volume
	music.pitch_scale = new_pitch
	music.play()

## 2^32 different bg possibilities
func _update_background_noise_seed(menu: MenuConfig.MenuType):
	background.texture.noise.seed = randi()


func _on_bg_typed():
	background.texture.noise.seed = randi()
