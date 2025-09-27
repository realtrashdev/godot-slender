extends CanvasLayer

@export var shader_material: ShaderMaterial
@export var color_sets: Dictionary[String, ColorSet]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shader_toggle"):
		visible = !visible
	
	if Input.is_action_just_pressed("ui_up"):
		change_game_color("GREEN", 1)
	
	if Input.is_action_just_pressed("ui_down"):
		change_game_color("MONO", 1)
	
	if Input.is_action_just_pressed("ui_left"):
		change_game_color("PURPLE", 1)
	
	if Input.is_action_just_pressed("ui_right"):
		change_game_color("BLUE", 1)

# if speed is 0 or not entered, instant change
func change_game_color(color_name: String = "MONO", speed: float = 0):
	var color_set = color_sets[color_name.to_upper()]
	
	if speed == 0:
		for i in range(4):
			shader_material.set_shader_parameter("shade_" + str(i), color_set.colors[i])
	else:
		var tween = create_tween()
		for i in range(4):
			tween.parallel().tween_property(shader_material, "shader_parameter/shade_" + str(i), color_set.colors[i], speed)
