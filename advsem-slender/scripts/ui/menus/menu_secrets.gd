extends Node

## disables the options button (typing it again re enables it)
signal brody_typed

## enables the reset progress button (only in settings menu)
signal reset_typed

## displays the credits (only in main menu)
signal credits_typed

## randomizes the background image seed (~4.3 billion different combinations)
signal bg_typed

@export var secret_string: RichTextLabel

var enabled = false
var just_hit = false

var recent_keys: Array[String] = []
var visible_keys: Array[String] = []

var fade_out_tween: Tween

var manager: Node3D
var music_tween: Tween
var string_tween: Tween
var scale_tween: Tween

var music: AudioStream = preload("uid://bw13p4ixmh3mk")
var meowsic: AudioStream = preload("uid://cqaagyghacaij")

func _ready() -> void:
	manager = get_parent()
	if (Progression.is_scenario_completed("basics1")):
		check_gum()
	Signals.change_menu_music_pitch.connect(toggle_bgm_pitch)

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event is not InputEventKey:
		return
	
	if event.is_released() or event.is_echo():
		return
	
	if (not is_letter(event.unicode)):
		return
	
	if (just_hit):
		recent_keys.clear()
		visible_keys.clear()
		just_hit = false
	
	recent_keys.append(event.as_text())
	
	if recent_keys.size() > 10:
		recent_keys.remove_at(0)
	
	update_secret_text(event.as_text())
	check_key_array()

func is_letter(unicode_val: int) -> bool:
	return (unicode_val >= 97 and unicode_val <= 122) or (unicode_val >= 65 and unicode_val <= 90)

func update_secret_text(string: String):
	visible_keys.append(string)
	
	if (visible_keys.size() > 10):
		visible_keys.remove_at(0)
	
	secret_string.text = "[wave]"
	for key in visible_keys:
		secret_string.text += key
	
	secret_string.modulate = Color.WHITE
	tween_secret_text()

func tween_secret_text():
	if (string_tween):
		string_tween.kill()
	string_tween = create_tween()
	string_tween.tween_property(secret_string, "modulate", Color.TRANSPARENT, 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await string_tween.finished
	recent_keys.clear()
	visible_keys.clear()
	secret_string.text = ""

func hit(word: String):
	just_hit = true
	secret_string.text = "[wave]" + word.to_upper()
	secret_string.scale = Vector2(1.33, 1.33)
	if (scale_tween):
		scale_tween.kill()
	scale_tween = create_tween()
	scale_tween.tween_property(secret_string, "scale", Vector2.ONE, 0.5)

func check_key_array():
	var last_idx = recent_keys.size() - 1
	if last_idx >= 1:
		if recent_keys[last_idx - 1] == "B" and \
		   recent_keys[last_idx] == "G":
			bg_typed.emit()
			hit("bg")
			return
	
	if last_idx >= 2:
		if recent_keys[last_idx - 2] == "G" and \
		   recent_keys[last_idx - 1] == "U" and \
		   recent_keys[last_idx] == "M":
			spawn_gum()
			hit("gum")
			return
	
	if last_idx >= 3:
		if recent_keys[last_idx - 3] == "M" and \
		   recent_keys[last_idx - 2] == "E" and \
		   recent_keys[last_idx - 1] == "O" and \
		   recent_keys[last_idx] == "W":
			meow_music()
			hit("meow")
			return
		if recent_keys[last_idx - 3] == "T" and \
		   recent_keys[last_idx - 2] == "O" and \
		   recent_keys[last_idx - 1] == "B" and \
		   recent_keys[last_idx] == "Y":
			meow_music()
			hit("toby")
			return
	
	if last_idx >= 4:
		if recent_keys[last_idx - 4] == "M" and \
		   recent_keys[last_idx - 3] == "U" and \
		   recent_keys[last_idx - 2] == "S" and \
		   recent_keys[last_idx - 1] == "I" and \
		   recent_keys[last_idx] == "C":
			toggle_bgm_pitch()
			hit("music")
			return
		if recent_keys[last_idx - 4] == "B" and \
		   recent_keys[last_idx - 3] == "R" and \
		   recent_keys[last_idx - 2] == "O" and \
		   recent_keys[last_idx - 1] == "D" and \
		   recent_keys[last_idx] == "Y":
			brody_typed.emit()
			hit("brody")
			return
		if recent_keys[last_idx - 4] == "R" and \
		   recent_keys[last_idx - 3] == "E" and \
		   recent_keys[last_idx - 2] == "S" and \
		   recent_keys[last_idx - 1] == "E" and \
		   recent_keys[last_idx] == "T":
			reset_typed.emit()
			hit("reset")
			return
	
	if last_idx >= 6:
		if recent_keys[last_idx - 6] == "C" and \
		   recent_keys[last_idx - 5] == "R" and \
		   recent_keys[last_idx - 4] == "E" and \
		   recent_keys[last_idx - 3] == "D" and \
		   recent_keys[last_idx - 2] == "I" and \
		   recent_keys[last_idx - 1] == "T" and \
		   recent_keys[last_idx] == "S":
			credits_typed.emit()
			hit("credits")
	
	if last_idx >= 7:
		if recent_keys[last_idx - 7] == "O" and \
		   recent_keys[last_idx - 6] == "I" and \
		   recent_keys[last_idx - 5] == "R" and \
		   recent_keys[last_idx - 4] == "A" and \
		   recent_keys[last_idx - 3] == "N" and \
		   recent_keys[last_idx - 2] == "E" and \
		   recent_keys[last_idx - 1] == "C" and \
		   recent_keys[last_idx] == "S":
			for scenario in ResourceDatabase.get_all_scenarios():
				Progression.unlock_scenario(scenario.resource_name)
			print("Unlocked all scenarios.")
			hit("oiranecs")

## 1 in 2000 chance every second to spawn gum enemy on title screen
func check_gum():
	await get_tree().create_timer(1).timeout
	var num = randi_range(1, 5000)
	if num == 5000:
		if enabled:
			spawn_gum()
	check_gum()

func spawn_gum():
	var scene = preload("res://scenes/enemies/OLD/gum_old.tscn").instantiate()
	add_child(scene)
	scene.activate()

## Toggles BGM pitch to a somewhat normal sounding pitch.
func toggle_bgm_pitch():
	var bgm: AudioStreamPlayer = manager.get_node("Music")
	if bgm.stream == meowsic:
		return
	
	var new_scale: float
	if bgm.pitch_scale < 0.8:
		new_scale = 0.9
	else:
		new_scale = 0.4
	
	if music_tween:
		music_tween.kill()
	
	music_tween = create_tween()
	music_tween.tween_property(bgm, "pitch_scale", 0.01, 0.5)
	await music_tween.finished
	music_tween = create_tween()
	music_tween.tween_property(bgm, "pitch_scale", new_scale, 0.5)

## Switches BGM to a version with a cat piano, and switches the music to be normal pitched
func meow_music():
	var bgm: AudioStreamPlayer = manager.get_node("Music")
	var pitch_scale: float
	
	if music_tween:
		music_tween.kill()
	
	music_tween = create_tween()
	music_tween.tween_property(bgm, "pitch_scale", 0.01, 0.5)
	await music_tween.finished
	
	# replace stream
	var pos = bgm.get_playback_position()
	bgm.stop()
	match bgm.stream:
		music:
			bgm.stream = meowsic
			pitch_scale = 0.9
		meowsic:
			bgm.stream = music
			pitch_scale = 0.4
	bgm.play(pos)
	
	music_tween = create_tween()
	music_tween.tween_property(bgm, "pitch_scale", pitch_scale, 0.5)
