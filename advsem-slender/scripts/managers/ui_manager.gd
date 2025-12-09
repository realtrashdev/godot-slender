class_name UIManager extends CanvasLayer

enum TextLevel { TOP, MIDDLE, BOTTOM }

@export var tutorial: bool = false

const PG_CHARACTER_TIME: float = 0.5
const PG_DISPLAY_TIME: float = 2.5
const TL_CHARACTER_TIME: float = 1
const TL_DISPLAY_TIME: float = 4

var game_state: GameState
var tip_manager: TipManager
var scenario: ClassicModeScenario

@onready var pages_text: RichTextLabel = $PagesText
@onready var too_long_text: RichTextLabel = $TooLongText
@onready var mode_text: RichTextLabel = $ModeText
@onready var scenario_text: RichTextLabel = $ModeText/ScenarioText
@onready var timer_text: RichTextLabel = $TimerText

func initialize(state: GameState):
	game_state = state
	tip_manager = TipManager.new()
	
	# connect to signals and handle internally
	Signals.page_collected.connect(on_page_collected)
	
	# enable/disable run timer depending on settings
	timer_text.visible = Settings.get_run_timer()
	
	show_game_start()

func _exit_tree():
	if Signals.page_collected.is_connected(on_page_collected):
		Signals.page_collected.disconnect(on_page_collected)

func on_page_collected():
	update_pages()

# public interface
func show_game_start():
	if tutorial:
		return
	await get_tree().create_timer(1).timeout
	show_tip()
	show_mode()
	TextTools.change_visible_characters(timer_text, 7, 0.5, 0)
	await get_tree().create_timer(5).timeout

func show_tip():
	var tip = tip_manager.get_random_tip()
	display_text("[wave]Tip:\n" + tip, 1, 5, 0)

func show_mode():
	match game_state.game_mode:
		GameConfig.GameMode.CLASSIC:
			display_text("[wave]CLASSIC MODE", 1, 5, 0, mode_text)
		GameConfig.GameMode.ENDLESS:
			display_text("[wave]ENDLESS MODE", 1, 5, 0, mode_text)
	
	if scenario:
		show_scenario(scenario)

func show_scenario(sc: ClassicModeScenario):
	display_text(sc.name, 1, 5, 0, scenario_text)

func show_objective():
	display_text("[wave]Collect %d pages" % game_state.current_pages_required, 1, 3, 1)
	
	if scenario:
		scenario_specific_events()

func update_speedrun_timer(time: float):
	timer_text.text = "%d:%02d.%02d" % [floor(time / 60), int(time) % 60, int((time - floor(time)) * 100)]

func taking_too_long():
	display_text(too_long_text.text, TL_CHARACTER_TIME, TL_DISPLAY_TIME, TL_CHARACTER_TIME, too_long_text)

func show_game_end():
	# results screen
	pass

# internal methods
func update_pages():
	display_text(get_pages_text(), PG_CHARACTER_TIME, PG_DISPLAY_TIME, PG_CHARACTER_TIME, pages_text)
	
	if scenario:
		scenario_specific_events()

func get_pages_text() -> String:
	var shake_rate = str(get_shake_rate(game_state.current_pages_collected))
	return "[shake rate=%s]Pages %s/%s" % [shake_rate, game_state.current_pages_collected, game_state.current_pages_required]

func get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 2
	if rate < 1:
		return 0
	else:
		return rate * 3

func get_text_from_level(level: TextLevel):
	match level:
		TextLevel.TOP:
			return scenario_text
		TextLevel.MIDDLE:
			return pages_text
		TextLevel.BOTTOM:
			return too_long_text

func display_text(new_text: String, open_time: float, display_time: float, close_time: float, text_object: RichTextLabel = pages_text):
	text_object.text = new_text
	TextTools.change_visible_characters_timed(text_object, text_object.get_total_character_count(), open_time, display_time, close_time)

func scenario_specific_events():
	if scenario.resource_name == "basics1" and game_state.current_pages_collected == 1:
		await get_tree().create_timer(3).timeout
		display_text("[wave][LSHIFT] Sprint", 1, 4, 1, pages_text)
	
	if scenario.resource_name == "basics2" and game_state.current_pages_collected == 4:
		await get_tree().create_timer(3).timeout
		display_text("[wave][F] Toggle Flashlight", 1, 5, 1, pages_text)
	
	if scenario.resource_name == "basics1" and game_state.current_pages_collected == 0:
		await get_tree().create_timer(5).timeout
		display_text("[wave][RIGHT CLICK] Toggle Radar", 1, 5, 1, pages_text)
	
	if scenario.resource_name == "basics3" and game_state.current_pages_collected == 1:
		await get_tree().create_timer(3).timeout
		display_text("[wave][RIGHT CLICK] Toggle Radar", 1, 5, 1, pages_text)
