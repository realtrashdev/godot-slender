extends Menu

@onready var palette_list: PaletteList = $StrongParallax/PaletteList
@onready var back_button: CustomButton = $StrongParallax/BackButton


func _ready() -> void:
	palette_list.palette_selected.connect(_on_palette_selected)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_on_back_pressed()


func _on_palette_selected(color: ColorSet):
	ScreenColorCanvas.change_game_color(color, 1)


func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()
