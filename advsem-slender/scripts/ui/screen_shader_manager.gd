extends CanvasLayer

@export var shader_material: ShaderMaterial
@export var default_color: ColorSet

func _ready() -> void:
	change_game_color(default_color)

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shader_toggle"):
	#	visible = !visible
	
	#if Input.is_action_just_pressed("ui_up"):
	#	change_game_color("GREEN", 1)
	
	#if Input.is_action_just_pressed("ui_down"):
	#	change_game_color("MONO", 1)
	
	#if Input.is_action_just_pressed("ui_left"):
	#	change_game_color("PURPLE", 1)
	
	#if Input.is_action_just_pressed("ui_right"):
	#	change_game_color("BLUE", 1)
	pass

# if speed is 0 or not entered, instant change
func change_game_color(color_set: ColorSet, speed: float = 0):
	if speed == 0:
		for i in range(4):
			shader_material.set_shader_parameter("shade_" + str(i), color_set.colors[i])
	else:
		var tween = create_tween()
		for i in range(4):
			tween.parallel().tween_property(shader_material, "shader_parameter/shade_" + str(i), color_set.colors[i], speed)
