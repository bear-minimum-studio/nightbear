extends Node

export (NodePath) var viewport_container1_path
export (NodePath) var viewport_container2_path

onready var viewport_container1 = get_node(viewport_container1_path)
onready var viewport_container2 = get_node(viewport_container2_path)

onready var world1 = viewport_container1.world
onready var world2 = viewport_container2.world

onready var spawner_handlers = [world1.spawner_handler, world2.spawner_handler]

onready var dream_caught_text = $DreamCaughtText
onready var game_over = $GameOver

onready var burst_start_timer = $BurstStartTimer

var dreams_caught = 0

onready var empty_wave = [
	{
		"worlds": [world1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": -1,
		"burst_duration": 30,
		"burst_start_delay": 30,
		"burst_sides": []
	}
]

onready var wave1 = [
	{
		"worlds": [world1, world2],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.05,
		"burst_duration": 2,
		"burst_start_delay": 4,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"worlds": [world1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0.5,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"worlds": [world2],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0.5,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"worlds": [world1, world2],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": 0,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	{
		"worlds": [world1, world2],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 4,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"worlds": [world1, world2],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": 0,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	{
		"worlds": [world1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"worlds": [world2],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Right]
	}
]

onready var test_level = [wave1, empty_wave, wave1]

var current_level
var wave_index
var current_wave
var burst_index

func play_level(level):
	print("Level started")
	current_level = level
	wave_index = 0
	var wave = level[wave_index]
	play_wave(wave)

func level_ended():
	print("Level ended")
	burst_start_timer.stop()

func next_wave():
	wave_index += 1
	if wave_index < current_level.size():
		var wave = current_level[wave_index]
		play_wave(wave)
	else:
		level_ended()

func play_wave(wave):
	print("Wave %d started" % wave_index)
	current_wave = wave
	burst_index = 0
	var burst_description = wave[burst_index]
	play_burst(burst_description)

func next_burst():
	burst_index += 1
	if burst_index < current_wave.size():
		var burst_description = current_wave[burst_index]
		play_burst(burst_description)
	else:
		next_wave()

func play_burst(burst_description):
	print("Burst %d started" % burst_index)
	print(burst_description.spawn_type)
	for world in burst_description.worlds:
		var spawner_handler = world.spawner_handler
		var _burst = spawner_handler.start_burst(
			burst_index,
			burst_description.spawn_type,
			burst_description.spawn_delay,
			burst_description.burst_duration,
			burst_description.burst_sides)
	print("Burst start timer started for : %f" % burst_description.burst_start_delay)
	burst_start_timer.start(burst_description.burst_start_delay)

func _ready():
	game_over.connect("replay", self, "_replay_game")
	
	for spawner_handler in spawner_handlers:
		spawner_handler.connect("allied_projectile_spawned", self, "_connect_allied_projectile")
		spawner_handler.connect("burst_ended", self, "_on_burst_ended")
		
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("build", self, "_build")
		player.connect("player_dead", self, "_player_dead")
		player.connect("player_moved", self, "_move_player_shade")
	
	play_level(test_level)

func _build(id: int, t:Transform2D):
	var new_wall = Parameters.GAME_WALL.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instance()
	new_dream_catcher.transform.origin = t.origin

	if (id  == 1):
		world2.add_child(new_wall)
		world1.add_child(new_dream_catcher)
	elif (id  == 2):
		world1.add_child(new_wall)
		world2.add_child(new_dream_catcher)

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
	game_over.show()

func _move_player_shade(player_id: int, position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.id != player_id:
			player_shade.move_shade(position)

func _on_burst_ended(_burst):
	pass

func _on_BurstStartTimer_timeout():
	next_burst()

func _replay_game():
	var _unused = get_tree().reload_current_scene()
