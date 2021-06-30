extends Node

export (Array, NodePath) var viewport_container_paths

var viewport_containers = []
var worlds = []

onready var wave_number_text = $WaveNumber
onready var dream_caught_text = $DreamCaughtText
onready var game_over = $GameOver
onready var game_end = $GameEnd
onready var sequence = $SequencePlayer
onready var death_fx = $DeathFX
onready var lightning_fx = $LightningFX
onready var sequence_player = $SequencePlayer

var dreams_caught = 0

func _ready():
	for viewport_container_path in viewport_container_paths:
		var viewport_container = get_node(viewport_container_path)
		var world = viewport_container.world
		
		viewport_containers.push_back(viewport_container)
		worlds.push_back(world)
		world.spawner_handler.connect("entity_spawned", self, "_connect_projectile")
	
	sequence.init(worlds)
	sequence_player.connect("new_subsequence", self, "_new_subsequence")
	sequence_player.connect("sequence_ended", self, "_sequence_ended")
	
	game_over.connect("replay", self, "_replay_game")
	game_end.connect("replay", self, "_replay_game")
		
	var players = get_tree().get_nodes_in_group("player")
	
	for player in players:
		player.connect("build", self, "_build")
		player.connect("player_dead", self, "_player_dead")
		player.connect("player_moved", self, "_move_player_shade")
	
	MusicPlayer.next()
	sequence.start()

func _build(world_id: int, t:Transform2D):
	var new_wall = Parameters.GAME_WALL.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instance()
	new_dream_catcher.transform.origin = t.origin

	worlds[1 - world_id].add_child(new_wall)
	worlds[world_id].add_child(new_dream_catcher)

func _connect_projectile(spawned_instance: Projectile):
	if spawned_instance is AllyProjectile:
		var _unused1 = spawned_instance.connect("missed_ally_projectile", self, "_on_missed_ally_projectile")
		var _unused2 = spawned_instance.connect("dream_caught", self, "_dream_caught")

func _dream_caught(_position: Vector2):
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = String(dreams_caught) + wording

func _player_dead(world_id):
	print("Player %d is dead !" % world_id)
	death_fx.play()
	var wave_index = sequence.current_index
	game_over.show_game_over(wave_index + 1)
	get_tree().paused = true

func _move_player_shade(world_id: int, position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.world_id != world_id:
			player_shade.move_shade(position)

func _sequence_ended():
	game_end.show_scene()
	get_tree().paused = true

func _replay_game():
	get_tree().paused = false
	var _unused = get_tree().reload_current_scene()

func _new_subsequence(wave_index: int):
	wave_number_text.next_wave(wave_index + 1)
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()

func _on_missed_ally_projectile(world_id):
	var other_world_id = 1 - world_id
	var world = worlds[other_world_id]
	var spawner_handler = world.spawner_handler
	viewport_containers[other_world_id].camera.start_flash(0.25, 0.3)
	lightning_fx.play()
	var sides = [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	spawner_handler.spawn(Projectile.ProjectyleType.Doom, {"speed": 30.0, "target": world.player}, sides)
