extends Menu

@onready var palette_list: PaletteList = $PaletteList
@onready var back_button: CustomButton = $BackButton

func _ready() -> void:
	palette_list.palette_selected.connect(_on_palette_selected)

func _on_palette_selected(color: ColorSet):
	ScreenColorCanvas.change_game_color(color, 1)

func _on_back_pressed():
	go_to_menu(MenuConfig.MenuType.MAIN, MenuConfig.TransitionDirection.BACKWARD, true)
	SaveManager.save_game()
