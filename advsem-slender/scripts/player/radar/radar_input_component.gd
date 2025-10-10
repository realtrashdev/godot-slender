class_name RadarInputComponent extends Node

signal screen_clicked(position: Vector2)
signal screen_pressed(position: Vector2)
signal screen_released(position: Vector2)
signal screen_hover_started(position: Vector2)
signal screen_hover_ended()

@export var screen_sprite: Sprite3D
@export var sub_viewport: SubViewport
@export var enabled: bool = true

var camera: Camera3D
var is_hovering: bool = false
var last_viewport_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_process_unhandled_input(enabled)

func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		handle_mouse_event(event)

func handle_mouse_event(event: InputEvent) -> bool:
	"""Returns true if the event was handled (hit the screen)"""
	if not camera:
		camera = get_viewport().get_camera_3d()
		if not camera:
			return false
	
	if not screen_sprite or not is_instance_valid(screen_sprite):
		return false
	
	# Don't process if the sprite is currently being moved by a tween
	# (Check if parent radar has an active tween)
	var radar = screen_sprite.get_parent()
	if radar and radar.has_method("get") and radar.get("pos_tween"):
		var tween = radar.get("pos_tween")
		if tween and tween.is_running():
			return false
	
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	
	# Get World3D from the screen_sprite (which is a Node3D)
	var space_state = screen_sprite.get_world_3d().direct_space_state
	if not space_state:
		return false
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	# Only detect layer 20 (radar screens)
	query.collision_mask = 1 << 19  # Layer 20
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var uv = get_sprite_uv(result.position)
		if uv.x >= 0:  # Valid UV
			handle_screen_hit(event, uv)
			
			if not is_hovering:
				is_hovering = true
				screen_hover_started.emit(last_viewport_pos)
			
			return true
	else:
		if is_hovering:
			is_hovering = false
			screen_hover_ended.emit()
	
	return false

func is_screen_hit(raycast_result: Dictionary) -> bool:
	# check if the raycast hit our screen sprite
	if not raycast_result.has("collider"):
		return false
	
	var collider = raycast_result.collider
	
	# check if it's the StaticBody3D child of the sprite
	return collider.get_parent() == screen_sprite

func get_sprite_uv(hit_position: Vector3) -> Vector2:
	"""Convert 3D hit position to UV coordinates (0..1)"""
	if not screen_sprite or not is_instance_valid(screen_sprite):
		return Vector2(-1, -1)
	
	if not screen_sprite.texture:
		return Vector2(-1, -1)
	
	# Convert world position to local sprite space
	var local_pos = screen_sprite.global_transform.affine_inverse() * hit_position
	
	# Sprite3D is centered, so convert from -0.5..0.5 to 0..1
	var texture_width = screen_sprite.texture.get_width()
	var texture_height = screen_sprite.texture.get_height()
	
	# Safety check for texture size
	if texture_width == 0 or texture_height == 0:
		return Vector2(-1, -1)
	
	var uv = Vector2(
		local_pos.x / (texture_width * screen_sprite.pixel_size) + 0.5,
		0.5 - local_pos.y / (texture_height * screen_sprite.pixel_size)
	)
	
	# Check if outside bounds
	if uv.x < 0 or uv.x > 1 or uv.y < 0 or uv.y > 1:
		return Vector2(-1, -1)
	
	return uv

func handle_screen_hit(event: InputEvent, uv: Vector2) -> void:
	# forward input to the SubViewport
	if not sub_viewport or not is_instance_valid(sub_viewport):
		return
	
	# Check if SubViewport is ready to receive input
	if sub_viewport.get_child_count() == 0:
		return
	
	var viewport_pos = uv * Vector2(sub_viewport.size)
	last_viewport_pos = viewport_pos
	
	if event is InputEventMouseButton:
		var new_event = InputEventMouseButton.new()
		new_event.button_index = event.button_index
		new_event.pressed = event.pressed
		new_event.position = viewport_pos
		new_event.global_position = viewport_pos
		
		# Safely push input
		if is_instance_valid(sub_viewport) and sub_viewport.is_inside_tree():
			sub_viewport.push_input(new_event)
		else:
			push_warning("SubViewport not ready for input")
			return
		
		# Emit signals for easier handling
		if event.pressed:
			screen_pressed.emit(viewport_pos)
		else:
			screen_released.emit(viewport_pos)
			
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			screen_clicked.emit(viewport_pos)
		
	elif event is InputEventMouseMotion:
		var new_event = InputEventMouseMotion.new()
		new_event.position = viewport_pos
		new_event.global_position = viewport_pos
		new_event.relative = event.relative
		
		# Safely push input
		if is_instance_valid(sub_viewport) and sub_viewport.is_inside_tree():
			sub_viewport.push_input(new_event)

func set_enabled(value: bool) -> void:
	# enable or disable input processing
	enabled = value
	set_process_unhandled_input(enabled)
	
	if not enabled and is_hovering:
		is_hovering = false
		screen_hover_ended.emit()
