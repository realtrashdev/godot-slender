extends Menu

var _spam_time: float = 5.0
var _spam_timer: float = 0.0

@onready var back_button: CustomButton = $StrongParallax/BackButton

@onready var manager: MenuManager


func _ready() -> void:
	manager = get_parent() as MenuManager


func _process(delta: float) -> void:
	if _spam_timer > 0.0:
		_spam_timer -= delta


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_on_back_pressed()


func _on_discord_button_pressed() -> void:
	if _spam_timer > 0.0:
		return
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.open('https://discord.gg/s5dcfYhnT8', '_blank').focus();")
	else:
		OS.shell_open("https://discord.gg/s5dcfYhnT8")
	_spam_timer = _spam_time


func _on_credits_button_pressed() -> void:
	go_to_menu(MenuConfig.MenuType.CREDITS, MenuConfig.TransitionDirection.FORWARD, true)
	manager.fade_out_music_and_swap(-60, 0.5, manager.music_dict["credits"])


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()
