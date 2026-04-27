extends Menu

const TITLE_TEXT_EFFECT: String = "[wave freq=3]"

var tween: Tween

@onready var title: RichTextLabel = $StrongMouseParallax/Title
@onready var settings: PanelContainer = $StrongMouseParallax/Settings


func _ready() -> void:
	call_deferred("defer")
	settings.category_changed.connect(_on_category_updated)
	
	title.visible_characters = 0
	await get_tree().create_timer(0.2).timeout
	_refresh_title()


func defer():
	var secret = get_parent().get_node("Secrets")
	secret.reset_typed.connect(_on_reset_typed)


func _refresh_title():
	if tween:
		tween.kill()
	tween = TextTools.change_visible_characters(title, title.get_total_character_count(), 0.5, 0)


func _on_category_updated(new_category: String):
	title.text = TITLE_TEXT_EFFECT + "%s Settings" % new_category.capitalize()
	_refresh_title()


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()


func _on_reset_typed():
	$StrongMouseParallax/ProgressResetButton.visible = true


## Resets progress other than inital setting changes and tutorial completion
func _on_progress_reset_button_pressed() -> void:
	SaveManager.reset_progression()
	Progression.complete_tutorial()
	Progression.complete_scenario("tutorial")
	Settings.set_selected_color_palette(ResourceDatabase.get_color_set("grayscale"))
	Settings.set_selected_scenario(ResourceDatabase.get_scenario("basics1"))
	Settings.set_selected_map("forest")
	ScreenColorCanvas.change_game_color(ResourceDatabase.get_color_set("grayscale"))
	
	get_tree().change_scene_to_file("res://scenes/ui/menus/menu_base.tscn")
