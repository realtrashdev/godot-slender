class_name RadarDisplayComponent extends Node

@export var sub_viewport: SubViewport
@export var screen_sprite: Sprite3D
@export var viewport_size: Vector2i = Vector2i(160, 144)

func _ready() -> void:
	setup_viewport()
	setup_collision()

func setup_viewport() -> void:
	if not sub_viewport:
		push_error("RadarDisplayComponent: SubViewport not assigned")
		return
	
	sub_viewport.size = viewport_size
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.transparent_bg = false

func setup_collision() -> void:
	if not screen_sprite:
		push_error("RadarDisplayComponent: Sprite3D not assigned!")
		return
	
	if not sub_viewport:
		push_error("RadarDisplayComponent: SubViewport not assigned!")
		return
	
	# Check if collision already exists
	if screen_sprite.get_node_or_null("StaticBody3D"):
		print("Collision already exists, skipping setup")
		return
	
	# Create collision for raycasting
	var static_body = StaticBody3D.new()
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	
	# Use SubViewport size instead of texture size (ViewportTexture size is 0 until rendered)
	shape.size = Vector3(
		sub_viewport.size.x * screen_sprite.pixel_size,
		sub_viewport.size.y * screen_sprite.pixel_size,
		0.01
	)
	
	print("Collision shape size: ", shape.size)
	print("Viewport size: ", sub_viewport.size)
	print("Pixel size: ", screen_sprite.pixel_size)
	
	collision.shape = shape
	static_body.add_child(collision)
	screen_sprite.add_child(static_body)
	static_body.name = "StaticBody3D"
	
	# Use layer 20 for radar screen
	static_body.collision_layer = 1 << 19  # Only exists on layer 20
	static_body.collision_mask = 0         # Doesn't collide with anything
	
	print("=== Radar Collision Setup ===")
	print("Sprite global pos: ", screen_sprite.global_position)
	print("StaticBody global pos: ", static_body.global_position)
	print("Collision layer: ", static_body.collision_layer)

func load_content(scene_path: String) -> void:
	# load 2D scene into the viewport
	if not sub_viewport:
		return
	
	# clear existing content
	for child in sub_viewport.get_children():
		child.queue_free()
	
	# load & add new scene
	var content_scene = load(scene_path).instantiate()
	sub_viewport.add_child(content_scene)

func load_content_instance(content: Node) -> void:
	# load an already-instanced node into the viewport
	if not sub_viewport:
		return
	
	# clear existing
	for child in sub_viewport.get_children():
		child.queue_free()
	
	sub_viewport.add_child(content)

func clear_content() -> void:
	# removes all content from the viewport
	if not sub_viewport:
		return
	
	for child in sub_viewport.get_children():
		child.queue_free()

func get_current_content() -> Node:
	# get the currently loaded content node
	if not sub_viewport or sub_viewport.get_child_count() == 0:
		return null
	return sub_viewport.get_child(0)
