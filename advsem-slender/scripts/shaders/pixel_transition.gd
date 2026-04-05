class_name PixelTransition extends TextureRect


func transition(end_value: float, time: float = 0.5, start_delay: float = 0.0):
	await get_tree().create_timer(start_delay).timeout
	create_tween().tween_property(material, "shader_parameter/transition_amount", end_value, time)


func new_seed():
	texture.noise.seed = randi()
