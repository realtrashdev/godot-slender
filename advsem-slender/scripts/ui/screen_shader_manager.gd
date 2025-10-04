extends CanvasLayer

@export var shader_material: ShaderMaterial
@export var color_palettes: Dictionary[String, ColorSet] = {}

func _ready() -> void:
	change_game_color(color_palettes["red"])
	#change_game_color(color_palettes[SaveManager.get_selected_color_palette()])

# if speed is 0 or not entered, instant change
func change_game_color(color_set: ColorSet, speed: float = 0):
	if speed == 0:
		for i in range(4):
			shader_material.set_shader_parameter("shade_" + str(i), color_set.colors[i])
	else:
		var tween = create_tween()
		for i in range(4):
			tween.parallel().tween_property(shader_material, "shader_parameter/shade_" + str(i), color_set.colors[i], speed)
