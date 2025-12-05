extends Node

@export var ringtones: Array[AudioStream]

var volume_modifier: float = 0

@onready var notification_audio: AudioStreamPlayer = $NotificationAudio
@onready var ringtone_audio: AudioStreamPlayer = $RingtoneAudio

func _ready() -> void:
	pass

func play_notification():
	notification_audio.volume_db = 0 + volume_modifier
	notification_audio.pitch_scale = randf_range(0.95, 1.05)
	notification_audio.play()

func play_ringtone():
	#TODO Re enable if u want i guess? I like ringtone 0 more
	#ringtones.shuffle()
	ringtone_audio.volume_db = 0 + volume_modifier
	ringtone_audio.pitch_scale = randf_range(0.95, 1.05)
	ringtone_audio.stream = ringtones[0]
	ringtone_audio.play()

func play_provided_ringtone(ringtone: AudioStream):
	ringtone_audio.volume_db = 0 + volume_modifier
	ringtone_audio.pitch_scale = randf_range(0.95, 1.05)
	ringtone_audio.stream = ringtone
	ringtone_audio.play()

func stop_ringtone():
	ringtone_audio.stop()
