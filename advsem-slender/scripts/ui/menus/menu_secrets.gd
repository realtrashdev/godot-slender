extends Node

## disables the options button (typing it again re enables it)
signal brody_typed

var enabled = false

var recent_keys: Array[String] = []

var manager: Node3D
var tween: Tween

var music: AudioStream = preload("uid://bw13p4ixmh3mk")
var meowsic: AudioStream = preload("uid://cqaagyghacaij")

func _ready() -> void:
	manager = get_parent()
	check_gum()

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event is not InputEventKey:
		return
	
	if event.is_released() or event.is_echo():
		return
	
	recent_keys.append(event.as_text())
	
	if recent_keys.size() > 10:
		recent_keys.remove_at(0)
	
	check_key_array()

func check_key_array():
	if recent_keys.size() < 3:
		return
	
	var last_idx = recent_keys.size() - 1
	if last_idx >= 2:
		if recent_keys[last_idx - 2] == "G" and \
		   recent_keys[last_idx - 1] == "U" and \
		   recent_keys[last_idx] == "M":
			spawn_gum()
			return
	
	if last_idx >= 3:
		if recent_keys[last_idx - 3] == "M" and \
		   recent_keys[last_idx - 2] == "E" and \
		   recent_keys[last_idx - 1] == "O" and \
		   recent_keys[last_idx] == "W":
			meow_music()
			return
	
	if last_idx >= 4:
		if recent_keys[last_idx - 4] == "M" and \
		   recent_keys[last_idx - 3] == "U" and \
		   recent_keys[last_idx - 2] == "S" and \
		   recent_keys[last_idx - 1] == "I" and \
		   recent_keys[last_idx] == "C":
			toggle_bgm_pitch()
			return
		if recent_keys[last_idx - 4] == "B" and \
		   recent_keys[last_idx - 3] == "R" and \
		   recent_keys[last_idx - 2] == "O" and \
		   recent_keys[last_idx - 1] == "D" and \
		   recent_keys[last_idx] == "Y":
			brody_typed.emit()
			return

## 1 in 2000 chance every second to spawn gum enemy on title screen
func check_gum():
	await get_tree().create_timer(1).timeout
	var num = randi_range(1, 5000)
	if num == 5000:
		if enabled:
			spawn_gum()
	check_gum()

func spawn_gum():
	var scene = preload("res://scenes/enemies/gum.tscn").instantiate()
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
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", 0.01, 0.5)
	await tween.finished
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", new_scale, 0.5)

## Switches BGM to a version with a cat piano, and switches the music to be normal pitched
func meow_music():
	var bgm: AudioStreamPlayer = manager.get_node("Music")
	var pitch_scale: float
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", 0.01, 0.5)
	await tween.finished
	
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
	
	tween = create_tween()
	tween.tween_property(bgm, "pitch_scale", pitch_scale, 0.5)
