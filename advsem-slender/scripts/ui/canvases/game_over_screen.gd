class_name GameOverScreen extends CanvasLayer

@export var text_fade_delay: float = 1.0

@export_group("Death Screen", "ds_")
@export var ds_rotation_bounds: float = 10.0
@export var ds_start_scale: Vector2 = Vector2(1.25, 1.25)
@export var ds_end_scale: Vector2 = Vector2(1.05, 1.05)
@export var tween_settings: TweenSettings

const TIP_TEXT_START: String = "[wave]TIP:[/wave]\n\n"

var tween: Tween

@onready var death_screen: TextureRect = $WeakMouseOffset/DeathScreen
@onready var tip_text: RichTextLabel = $StrongMouseOffset/TipText
@onready var black_bg: ColorRect = $BlackBG


func initialize(profile: EnemyProfile):
	visible = false
	await self.ready
	
	if profile == null:
		push_error("GameOverScreen given no EnemyProfile.")
		return
	
	if not profile.death_tips.is_empty():
		tip_text.text = TIP_TEXT_START + profile.death_tips.pick_random()
	else:
		push_warning("GameOverScreen not provided with a tip to show. EnemyProfile name: " + profile.name)
		tip_text.text = ""
	
	if profile.death_screen != null:
		death_screen.texture = profile.death_screen
	else:
		push_warning("GameOverScreen not provided with a death screen to show. EnemyProfile name: " + profile.name)


func show_game_over_screen():
	visible = true
	_show_deathscreen()
	await get_tree().create_timer(text_fade_delay).timeout
	var bg_tween = create_tween().tween_property(black_bg, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	await bg_tween.finished
	black_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _show_deathscreen():
	# Set randomized rotation
	death_screen.rotation_degrees = randf_range(-ds_rotation_bounds, ds_rotation_bounds)
	# At least a little variance
	if abs(death_screen.rotation_degrees) < 3.0:
		death_screen.rotation_degrees = 3 if randf() < 0.5 else -3
	
	# Set scale
	death_screen.scale = ds_start_scale
	
	if (tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(death_screen, "rotation", 0.0, tween_settings.duration)\
		.set_ease(tween_settings.easing).set_trans(tween_settings.transition)
	tween.tween_property(death_screen, "scale", ds_end_scale, tween_settings.duration)\
		.set_ease(tween_settings.easing).set_trans(tween_settings.transition)
	
	$BoomSound.play()
