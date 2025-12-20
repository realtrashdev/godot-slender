class_name UIManager extends CanvasLayer

enum TextLevel {
	TOP,
	TOP_BIG,
	CENTER,
	BOTTOM,
	}

@export var tutorial: bool = false

signal initialized

const TL_CHARACTER_TIME: float = 1
const TL_DISPLAY_TIME: float = 4

var game_state: GameState
var tip_manager: TipManager
var scenario: ClassicModeScenario

# General Text References
@onready var top_text_big: RichTextLabel = $TopTextBig
@onready var top_text: RichTextLabel = $TopText
@onready var center_text: RichTextLabel = $CenterText
@onready var bottom_text: RichTextLabel = $BottomText
@onready var in_game_timer_text: RichTextLabel = $InGameTimerText

func initialize(state: GameState):
	game_state = state
	tip_manager = TipManager.new()
	
	# connect to signals and handle internally
	Signals.page_collected.connect(_on_page_collected)
	
	# enable/disable run timer depending on settings
	in_game_timer_text.visible = Settings.get_run_timer()
	
	show_game_start()
	initialized.emit()

func _exit_tree():
	if Signals.page_collected.is_connected(_on_page_collected):
		Signals.page_collected.disconnect(_on_page_collected)

func _on_page_collected():
	if scenario:
		_scenario_specific_events()

# public interface
func show_game_start():
	if tutorial:
		return
	await get_tree().create_timer(1).timeout
	show_tip()
	show_mode()
	TextTools.change_visible_characters(in_game_timer_text, 7, 0.5, 0)
	await get_tree().create_timer(5).timeout

func show_tip():
	var tip = tip_manager.get_random_tip()
	_display_text("[wave]Tip:\n" + tip, 1, 5, 0)

func show_mode():
	match game_state.game_mode:
		GameConfig.GameMode.CLASSIC:
			_display_text("[wave]CLASSIC MODE", 1, 5, 0, TextLevel.TOP_BIG)
		GameConfig.GameMode.ENDLESS:
			_display_text("[wave]ENDLESS MODE", 1, 5, 0, TextLevel.TOP_BIG)
	
	if scenario:
		show_scenario(scenario)

func show_scenario(sc: ClassicModeScenario):
	_display_text(sc.name, 1, 5, 0, TextLevel.TOP)

func show_objective():
	_display_text("[wave]Collect %d pages" % game_state.current_pages_required, 1, 3, 1)
	
	if scenario:
		_scenario_specific_events()

func update_speedrun_timer(time: float):
	in_game_timer_text.text = "%d:%02d.%02d" % [floor(time / 60), int(time) % 60, int((time - floor(time)) * 100)]

func taking_too_long():
	_display_text(bottom_text.text, TL_CHARACTER_TIME, TL_DISPLAY_TIME, TL_CHARACTER_TIME, TextLevel.BOTTOM)

func show_game_end():
	# results screen
	pass

func _get_shake_rate(page_amount: int) -> int:
	var rate = page_amount - 2
	if rate < 1:
		return 0
	else:
		return rate * 3

func _get_text_from_level(level: TextLevel):
	match level:
		TextLevel.TOP:
			return top_text
		TextLevel.TOP_BIG:
			return top_text_big
		TextLevel.CENTER:
			return center_text
		TextLevel.BOTTOM:
			return bottom_text

func _display_text(new_text: String, open_time: float, display_time: float, close_time: float, text_level: TextLevel = TextLevel.CENTER):
	var text_node = _get_text_from_level(text_level)
	text_node.text = new_text
	TextTools.change_visible_characters_timed(text_node, text_node.get_total_character_count(), open_time, display_time, close_time)

func _scenario_specific_events():
	if scenario.resource_name == "basics1" and game_state.current_pages_collected == 1:
		await get_tree().create_timer(3).timeout
		_display_text("[wave][LSHIFT] Sprint", 1, 4, 1, TextLevel.CENTER)
	
	if scenario.resource_name == "basics2" and game_state.current_pages_collected == 4:
		await get_tree().create_timer(3).timeout
		_display_text("[wave][F] Toggle Flashlight", 1, 5, 1, TextLevel.CENTER)
	
	if scenario.resource_name == "basics1" and game_state.current_pages_collected == 0:
		await get_tree().create_timer(5).timeout
		_display_text("[wave][RIGHT CLICK] Toggle Radar", 1, 5, 1, TextLevel.CENTER)
	
	if scenario.resource_name == "basics3" and game_state.current_pages_collected == 1:
		await get_tree().create_timer(3).timeout
		_display_text("[wave][RIGHT CLICK] Toggle Radar", 1, 5, 1, TextLevel.CENTER)

# Helpers
func get_game_state() -> GameState:
	if game_state:
		return game_state
	push_warning("%s: Game state not found." % name)
	return null
