extends Node

# Game State
@warning_ignore("unused_signal")
signal game_started
@warning_ignore("unused_signal")
signal game_finished

# Player
@warning_ignore("unused_signal")
signal player_died

# Pages
@warning_ignore("unused_signal")
signal page_collected

# Enemies
@warning_ignore("unused_signal")
signal enemy_spawned(type: EnemyProfile.Type)
@warning_ignore("unused_signal")
signal killed_player(jumpscare: Jumpscare)

# Tutorial-specific
@warning_ignore("unused_signal")
signal tutorial_distance_reached

# Menu
@warning_ignore("unused_signal")
signal change_menu_music_pitch
