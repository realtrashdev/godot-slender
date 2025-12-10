extends Node

@export var ringtones: Array[AudioStream]
@export var default_volume = -10

var volume_modifier: float = 0

@onready var notification_audio: AudioStreamPlayer = $NotificationAudio
@onready var ringtone_audio: AudioStreamPlayer = $RingtoneAudio

# Setup methods
func activate():
	_unmute()

func deactivate():
	_mute()
	stop_all_sounds()

func update(battery_remaining: float):
	_battery_pitch_shifting(battery_remaining)

# Public methods
func play_notification():
	notification_audio.pitch_scale = randf_range(0.95, 1.05)
	notification_audio.volume_db = _get_volume()
	notification_audio.play()

func play_ringtone():
	ringtone_audio.volume_db = _get_volume()
	ringtone_audio.stream = ringtones[0]
	ringtone_audio.play()

func play_provided_ringtone(ringtone: AudioStream):
	ringtone_audio.volume_db = _get_volume()
	ringtone_audio.stream = ringtone
	ringtone_audio.play()

func stop_ringtone():
	ringtone_audio.stop()

func stop_all_sounds():
	ringtone_audio.stop()
	notification_audio.stop()

# Getters
func is_ringtone_playing() -> bool:
	return ringtone_audio.playing

# Private methods
func _get_all_audio_sources() -> Array[AudioStreamPlayer]:
	var arr: Array[AudioStreamPlayer] = []
	for child in get_children():
		if child is AudioStreamPlayer:
			arr.append(child)
	return arr

func _get_volume():
	return default_volume + volume_modifier

func _mute():
	AudioServer.set_bus_volume_linear(1, 0.0)

func _unmute():
	AudioServer.set_bus_volume_linear(1, 1.0)

func _battery_pitch_shifting(battery_remaining: float):
	if battery_remaining <= 20:
		for source in _get_all_audio_sources():
			source.pitch_scale = clamp(battery_remaining / 20, 0.01, 1.0)
