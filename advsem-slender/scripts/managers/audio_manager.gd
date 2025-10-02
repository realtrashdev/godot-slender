class_name AudioManager extends Node

var game_state: GameState

@onready var ambience: CustomAudioPlayer = $Ambient
@onready var collection_ambience: Node = $CollectionAmbient

func initialize(state: GameState):
	game_state = state
	collection_ambience.initialize(game_state)
	await get_tree().create_timer(1).timeout
	$FenceClimbAudio.play()

func start_game_audio():
	play_ambience()
	collection_ambience.on_game_started()

func stop_game_audio():
	ambience.stop()
	collection_ambience.on_game_finished()

func play_ambience():
	if not ambience.playing:
		ambience.play()
		ambience.set_volume_smooth(ambience.default_volume, 1, -30)

func on_page_collected():
	# Trigger audio cues based on page count
	pass

func taking_too_long():
	collection_ambience.taking_too_long()
