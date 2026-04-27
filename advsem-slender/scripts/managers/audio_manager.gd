class_name AudioManager extends Node

@export var do_collection_ambience: bool = true

var game_state: GameState

@onready var ambience: CustomAudioPlayer = $Ambient
@onready var collection_music = $DynamicCollectionMusic


func initialize(state: GameState):
	Signals.page_collected.connect(_on_page_collected)
	game_state = state
	if collection_music:
		collection_music.initialize(game_state)
	await get_tree().create_timer(1, false).timeout
	$IntroAudio.play()


func start_game_audio():
	_play_ambience()


func stop_game_audio():
	ambience.stop()


func _play_ambience():
	if not ambience.playing:
		ambience.play()
		ambience.set_volume_smooth(ambience.default_volume, 1, -30)


func _on_page_collected():
	ambience.set_volume_smooth(ambience.default_volume - abs(ambience.default_volume), 1.5, ambience.volume_db, Tween.EASE_IN, Tween.TRANS_SINE)
