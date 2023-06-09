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

signal wave_ended(world_id: int, wave_index: int)
signal level_ended(world_id: int)

signal missed_ally_projectile
signal dream_caught
signal player_dead
signal build
signal player_moved
