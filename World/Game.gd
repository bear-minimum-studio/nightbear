extends Node

export (Array, NodePath) var viewport_container_paths

var viewport_containers = []
var worlds = []

onready var dream_caught_text = $DreamCaughtText
onready var game_over = $GameOver
onready var level_handler = $LevelHandler
onready var death_fx = $DeathFX

var dreams_caught = 0

func _ready():
	for viewport_container_path in viewport_container_paths:
		var viewport_container = get_node(viewport_container_path)
		var world = viewport_container.world
		
		viewport_containers.push_back(viewport_container)
		worlds.push_back(world)
		
		world.spawner_handler.connect("allied_projectile_spawned", self, "_connect_allied_projectile")
	
	level_handler.initialize(worlds)
	
	game_over.connect("replay", self, "_replay_game")
		
	var players = get_tree().get_nodes_in_group("player")
	
	for player in players:
		player.connect("build", self, "_build")
		player.connect("player_dead", self, "_player_dead")
		player.connect("player_moved", self, "_move_player_shade")
	
	level_handler.connect("next_wave", self, "_new_wave")
	
	MusicPlayer.next()
	level_handler.start()

func _build(id: int, t:Transform2D):
	var new_wall = Parameters.GAME_WALL.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instance()
	new_dream_catcher.transform.origin = t.origin

	if (id == 1):
		worlds[1].add_child(new_wall)
		worlds[0].add_child(new_dream_catcher)
	elif (id == 2):
		worlds[0].add_child(new_wall)
		worlds[1].add_child(new_dream_catcher)

func _connect_allied_projectile(spawned_instance: AllyProjectile):
	var _unused1 = spawned_instance.connect("missed_ally_projectile", self, "_on_missed_ally_projectile")
	var _unused2 = spawned_instance.connect("dream_caught", self, "_dream_caught")

func _on_missed_ally_projectile():
	pass

func _dream_caught():
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = String(dreams_caught) + wording

func _player_dead(id):
	print("Player %d is dead !" % id)
	death_fx.play()
	var wave_index = level_handler.wave_index
	game_over.show_game_over(wave_index + 1)
	get_tree().paused = true

func _move_player_shade(player_id: int, position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.id != player_id:
			player_shade.move_shade(position)

func _replay_game():
	get_tree().paused = false
	var _unused = get_tree().reload_current_scene()

func _new_wave():
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()
