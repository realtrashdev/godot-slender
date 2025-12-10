extends Node

const DEFAULT_INTERVAL: float = 3.0
const STOMPING_DEFAULT_VOLUME: float = -15.0
const DISTOMPING_DEFAULT_VOLUME: float = -5.0

var game_state: GameState
var interval: float
var play_interval: bool = false
var too_long: bool = false

var active_interval_sounds: Array[AudioStreamPlayer]

func initialize(state: GameState):
	game_state = state
	Signals.page_collected.connect(on_page_collected)

func _exit_tree():
	if Signals.page_collected.is_connected(on_page_collected):
		Signals.page_collected.disconnect(on_page_collected)

func on_page_collected():
	match game_state.current_pages_collected:
		1:
			if too_long:
				return
			play_interval = true
			
			active_interval_sounds.append($StompingNormal)
			await get_tree().create_timer(1).timeout
			sound_interval_loop()
		2:
			create_tween().tween_property($StompingNormal, "volume_db", -12, 1)
		3:
			#play_interval = false
			#await get_tree().create_timer(3).timeout
			#play_interval = true
			#$GameMusic1.play()
			#sound_interval_loop()
			pass
		4:
			create_tween().tween_property($StompingNormal, "volume_db", -10, 1)
		5:
			active_interval_sounds.erase($StompingNormal)
			await get_tree().create_timer(1).timeout
			active_interval_sounds.append($StompingDistorted)
		6:
			interval -= 0.25
		7:
			interval -= 0.75
		8:
			pass

func sound_interval_loop():
	while play_interval:
		for sound in active_interval_sounds:
			sound.play()
		await get_tree().create_timer(interval).timeout

func taking_too_long():
	too_long = true
	play_interval = true
	await get_tree().create_timer(1).timeout
	sound_interval_loop()

func on_game_started():
	interval = DEFAULT_INTERVAL
	$StompingNormal.volume_db = STOMPING_DEFAULT_VOLUME
	$StompingDistorted.volume_db = DISTOMPING_DEFAULT_VOLUME

func on_game_finished():
	for sound in active_interval_sounds:
		sound.stop()
	active_interval_sounds.clear()
	$GameMusic1.stop()
	play_interval = false
	too_long = false
