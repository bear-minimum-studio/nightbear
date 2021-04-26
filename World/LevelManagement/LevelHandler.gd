extends Node

var worlds
var viewport_containers

signal next_wave
signal level_end

var doom_projectile = preload("res://Projectiles/DoomProjectile.tscn")

onready var burst_start_timer = $BurstStartTimer

var wave0_ennemy_wall_speed = 10
var wave0_eparse_ennemy_speed = 9
var wave0_alone_ally_speed = 8
var wave0_eparse_ally_speed = 7

var wave0 = [
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave0_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave0_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2,
		"next_burst_start_delay": 7,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave0_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave0_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave0_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	_create_empty_burst_description(50),
]
	
	
var wave1_ennemy_wall_speed = 12
var wave1_eparse_ennemy_speed = 11
var wave1_alone_ally_speed = 10
var wave1_eparse_ally_speed = 9

var wave1 = [
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2,
		"next_burst_start_delay": 15,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 1,
		"next_burst_start_delay": 5,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave0_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave1_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 1,
		"next_burst_start_delay": 5,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave0_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave1_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 10,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave1_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_eparse_ennemy_speed,
		"spawn_delay": 0.95,
		"burst_duration": 35,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top, SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_eparse_ennemy_speed,
		"spawn_delay": 0.95,
		"burst_duration": 35,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Bottom, SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.01,
		"burst_duration": 1,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.01,
		"burst_duration": 2,
		"next_burst_start_delay": 6,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave1_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave1_ennemy_wall_speed,
		"spawn_delay": 0.01,
		"burst_duration": 2,
		"next_burst_start_delay": 6,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave1_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Right]
	},
	_create_empty_burst_description(50),
]

var wave2_ennemy_wall_speed = 14
var wave2_eparse_ennemy_speed = 13
var wave2_alone_ally_speed = 12
var wave2_eparse_ally_speed = 11

var wave2 = [
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave2_eparse_ally_speed,
		"spawn_delay": 5,
		"burst_duration": 40,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_eparse_ennemy_speed,
		"spawn_delay": 0.85,
		"burst_duration": 40,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_eparse_ennemy_speed,
		"spawn_delay": 0.85,
		"burst_duration": 40,
		"next_burst_start_delay": 3,
		"burst_sides": [SpawnHandler.Sides.Bottom, SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 1.5,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 1.5,
		"next_burst_start_delay": 10,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2.5,
		"next_burst_start_delay": 5,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.03,
		"burst_duration": 2.5,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave2_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": wave2_alone_ally_speed,
		"spawn_delay": 0,
		"burst_duration": 1,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Bottom, SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": wave2_ennemy_wall_speed,
		"spawn_delay": 0.02,
		"burst_duration": 2,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	_create_empty_burst_description(70),
]

var full_level

var current_level
var wave_index
var current_wave
var burst_index

func initialize(father_worlds, father_viewport_containers):
	worlds = father_worlds
	for world in worlds:
		world.spawner_handler.connect("burst_ended", self, "_on_burst_ended")
		world.spawner_handler.connect("allied_projectile_spawned", self, "_connect_allied_projectile")
	
	viewport_containers = father_viewport_containers
	
	full_level = [wave0, wave1, wave2]

func start():
	_play_level(full_level)

func _input(input):
	if OS.is_debug_build() && input.is_action_pressed("spawn_doom_projectile"):
		worlds[0].spawner_handler.spawn_projectile([SpawnHandler.Sides.Left], 30, Burst.SpawnType.Doom, worlds[0].player)
	if OS.is_debug_build() && input.is_action_pressed("next_burst"):
		_next_burst()

func _create_empty_burst_description(next_burst_start_delay):
	var empty_burst_description = {
		"world_indexes": [],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_speed": 0,
		"spawn_delay": -1,
		"burst_duration": -1,
		"next_burst_start_delay": next_burst_start_delay,
		"burst_sides": []
	}
	return empty_burst_description

func _create_empty_wave(next_wave_start_delay):
	var empty_wave = [_create_empty_burst_description(next_wave_start_delay)]
	return empty_wave

func _play_level(level):
	print("Level started")
	current_level = level
	wave_index = -1
	_next_wave()

func _level_ended():
	print("Level ended")
	burst_start_timer.stop()
	emit_signal("level_end")

func _next_wave():
	wave_index += 1
	if wave_index < current_level.size():
		var wave = current_level[wave_index]
		_play_wave(wave)
		emit_signal("next_wave", wave_index)
	else:
		_level_ended()

func _play_wave(wave):
	print("\tWave %d started" % wave_index)
	current_wave = wave
	burst_index = -1
	_next_burst()

func _next_burst():
	burst_index += 1
	if burst_index < current_wave.size():
		var burst_description = current_wave[burst_index]
		_play_burst(burst_description)
	else:
		_next_wave()

func _play_burst(burst_description):
	print("\t\tBurst %d started" % burst_index)
	burst_start_timer.stop()
	for world_index in burst_description.world_indexes:
		var world = worlds[world_index]
		var spawner_handler = world.spawner_handler
		var _burst = spawner_handler.start_burst(
			burst_index,
			burst_description.spawn_type,
			burst_description.spawn_speed,
			burst_description.spawn_delay,
			burst_description.burst_duration,
			burst_description.burst_sides,
			world.player)
	var next_burst_start_delay = max(burst_description.next_burst_start_delay, 0.0001)
	burst_start_timer.set_wait_time(next_burst_start_delay)
	burst_start_timer.start()

func _on_missed_ally_projectile(world_id):
	if world_id > 1:
		world_id = 0
	else:
		world_id = 1
	var world = worlds[world_id]
	var spawner_handler = world.spawner_handler
#	viewport_containers[world_id].camera.start_shake(0.5, 0.01, 3)
	viewport_containers[world_id].camera.start_flash(0.25, 0.3)
	var sides = [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	spawner_handler.spawn_projectile(sides, 30, Burst.SpawnType.Doom, world.player)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_burst_ended(_burst):
	pass

func _on_BurstStartTimer_timeout():
	_next_burst()

func _connect_allied_projectile(spawned_instance: AllyProjectile):
	var _unused1 = spawned_instance.connect("missed_ally_projectile", self, "_on_missed_ally_projectile")
