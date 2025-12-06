extends Node

@export var ringtones: Array[AudioStream]
@export var default_volume = -6

var volume_modifier: float = 0

@onready var notification_audio: AudioStreamPlayer = $NotificationAudio
@onready var ringtone_audio: AudioStreamPlayer = $RingtoneAudio

func _ready() -> void:
	AudioServer.set_bus_volume_linear(1, 1)
	Signals.game_finished.connect(mute_all)

func play_notification():
	notification_audio.volume_db = default_volume + volume_modifier
	notification_audio.play()

func play_ringtone():
	#TODO Re enable if u want i guess? I like ringtone 0 more
	#ringtones.shuffle()
	ringtone_audio.volume_db = default_volume + volume_modifier
	ringtone_audio.stream = ringtones[0]
	ringtone_audio.play()

func play_provided_ringtone(ringtone: AudioStream):
	ringtone_audio.volume_db = default_volume + volume_modifier
	ringtone_audio.stream = ringtone
	ringtone_audio.play()

func stop_ringtone():
	ringtone_audio.stop()

func mute_all():
	AudioServer.set_bus_volume_linear(1, 0)
