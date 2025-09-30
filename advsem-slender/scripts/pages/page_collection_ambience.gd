extends Node

const DEFAULT_INTERVAL: float = 3.0

var interval: float = DEFAULT_INTERVAL
var play_interval: bool = false
var too_long = false

func _ready():
	Signals.page_collected.connect(on_page_collected)

func on_page_collected():
	match CurrentGameData.current_pages_collected:
		1:
			if too_long:
				return
			play_interval = true
			await get_tree().create_timer(1).timeout
			sound_interval_loop()
		2:
			var tween = create_tween()
			tween.tween_property($Stomping, "volume_db", -10, 1)
		3:
			pass
		4:
			var tween = create_tween()
			tween.tween_property($Stomping, "volume_db", -5, 1)
		5:
			$Stomping.stop()
			$Stomping.stream = preload("uid://g1st3eumjgax")
			await get_tree().create_timer(1).timeout
		6:
			interval -= 0.25
		7:
			interval -= 0.75
		8:
			$Stomping.stop()
			interval = 1000000
			play_interval = false

func sound_interval_loop():
	while play_interval:
		$Stomping.play()
		await get_tree().create_timer(interval).timeout
	
	print("Page sound interval interrupted.")

func taking_too_long():
	too_long = true
	play_interval = true
	await get_tree().create_timer(1).timeout
	sound_interval_loop()

func on_game_finished():
	$Stomping.stop()
	play_interval = false
	too_long = false
