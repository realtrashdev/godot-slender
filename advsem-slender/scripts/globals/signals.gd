extends Node

# Game State
@warning_ignore("unused_signal")
signal game_started
@warning_ignore("unused_signal")
signal game_finished
@warning_ignore("unused_signal")
signal game_paused
@warning_ignore("unused_signal")
signal game_unpaused
@warning_ignore("unused_signal")
signal show_message(text: String)

# Player
@warning_ignore("unused_signal")
signal player_died

# Radar
@warning_ignore("unused_signal")
signal radar_charged
@warning_ignore("unused_signal")
signal radar_died
@warning_ignore("unused_signal")
signal radar_battery_drained(chunks: int, perma: bool)
@warning_ignore("unused_signal")
signal radar_battery_low

# Pages
@warning_ignore("unused_signal")
signal page_collected

# Enemies
@warning_ignore("unused_signal")
signal enemy_spawned(type: EnemyProfile.Type)
@warning_ignore("unused_signal")
signal killed_player(profile: EnemyProfile)

# Tutorial-specific
@warning_ignore("unused_signal")
signal tutorial_distance_reached
