extends Node

@export var ringtones: Array[AudioStream]

@onready var ringtone_audio: AudioStreamPlayer = $RingtoneAudio

func _ready() -> void:
	pass

func play_ringtone():
	ringtones.shuffle()
	ringtone_audio.stream = ringtones[0]
	ringtone_audio.play()

func play_provided_ringtone(ringtone: AudioStream):
	ringtone_audio.stream = ringtone
	ringtone_audio.play()

func stop_ringtone():
	ringtone_audio.stop()
