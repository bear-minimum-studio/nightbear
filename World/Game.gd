extends Node

export (Array, NodePath) var viewport_container_paths

var viewport_containers = []
var worlds = []
var doom_projectile = preload("res://Projectiles/ProjectilesTypes/DoomProjectile.tscn")

onready var wave_number_text = $WaveNumber
onready var dream_caught_text = $DreamCaughtText
onready var game_over = $GameOver
onready var game_end = $GameEnd
onready var level_handler = $LevelHandler
onready var death_fx = $DeathFX

var dreams_caught = 0

func _ready():
	for viewport_container_path in viewport_container_paths:
		var viewport_container = get_node(viewport_container_path)
		var world = viewport_container.world
		
		viewport_containers.push_back(viewport_container)
		worlds.push_back(world)
	
	level_handler.initialize(worlds, viewport_containers)
	
	game_over.connect("replay", self, "_replay_game")
	game_end.connect("replay", self, "_replay_game")
		
	var players = get_tree().get_nodes_in_group("player")
	
	for player in players:
		player.connect("build", self, "_build")
		player.connect("player_dead", self, "_player_dead")
		player.connect("player_moved", self, "_move_player_shade")
	
	level_handler.connect("next_wave", self, "_new_wave")
	level_handler.connect("level_end", self, "_end_game")
	
	MusicPlayer.next()
	level_handler.start()

func _build(world_id: int, t:Transform2D):
	var new_wall = Parameters.GAME_WALL.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instance()
	new_dream_catcher.transform.origin = t.origin

	worlds[1 - world_id].add_child(new_wall)
	worlds[world_id].add_child(new_dream_catcher)

func _connect_allied_projectile(spawned_instance: AllyProjectile):
	var _unused1 = spawned_instance.connect("missed_ally_projectile", self, "_on_missed_ally_projectile")
	var _unused2 = spawned_instance.connect("dream_caught", self, "_dream_caught")

func _dream_caught(_position: Vector2):
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = String(dreams_caught) + wording

func _player_dead(world_id):
	print("Player %d is dead !" % world_id)
	death_fx.play()
	var wave_index = level_handler.wave_index
	game_over.show_game_over(wave_index + 1)
	get_tree().paused = true

func _move_player_shade(world_id: int, position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.world_id != world_id:
			player_shade.move_shade(position)

func _end_game():
	game_end.show_scene()
	get_tree().paused = true

func _replay_game():
	get_tree().paused = false
	var _unused = get_tree().reload_current_scene()

func _new_wave(wave_index: int):
	wave_number_text.next_wave(wave_index + 1)
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()
