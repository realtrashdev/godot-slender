extends Node

@export var shader_material: ShaderMaterial


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		for i in range(4):
			var color: Color = Color(randf(), randf(), randf(), 1)
			shader_material.set_shader_parameter("shade_" + str(i), color)
	
	if Input.is_action_just_pressed("delete me"):
		for i in range(4):
			print("Color " + str(i) + ": " + str(shader_material.get_shader_parameter("shade_" + str(i)) * 255))
