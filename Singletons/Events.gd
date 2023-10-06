extends Node

signal settings_initialized

signal hosting(wan: bool)
signal joining(host_address_and_port: String)
signal localing
signal server_port_updated(server_port: int)

signal quit_game
signal resume_game
signal play_intro
signal intro_ended
signal replay_game

signal level_started(level_index: int, max_level_index: int)
signal level_ended(level_index: int, max_level_index: int)
signal wave_started(wave_index: int, max_wave_index: int)
signal wave_ended(wave_index: int, max_wave_index: int)

signal missed_ally_projectile
signal dream_caught
signal player_dead
signal build(player: Player)
