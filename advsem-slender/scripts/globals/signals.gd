extends Node

# Game state
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
signal killed_player(name: String)
