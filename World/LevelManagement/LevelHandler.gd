extends Node

var worlds

signal next_wave

onready var burst_start_timer = $BurstStartTimer

var wave1 = [
#	{
#		"world_indexes": [0, 1],
#		"spawn_type": Burst.SpawnType.Enemy,
#		"spawn_speed": 12,
#		"spawn_delay": 0.03,
#		"burst_duration": 2,
#		"next_burst_start_delay": 15,
#		"burst_sides": [SpawnHandler.Sides.Top]
#	},
#	{
#		"world_indexes": [0],
#		"spawn_type": Burst.SpawnType.Enemy,
#		"spawn_speed": 12,
#		"spawn_delay": 0.02,
#		"burst_duration": 1,
#		"next_burst_start_delay": 5,
#		"burst_sides": [SpawnHandler.Sides.Left]
#	},
#	{
#		"world_indexes": [1],
#		"spawn_type": Burst.SpawnType.Enemy,
#		"spawn_speed": 12,
#		"spawn_delay": 0.02,
#		"burst_duration": 1,
#		"next_burst_start_delay": 0,
#		"burst_sides": [SpawnHandler.Sides.Right]
#	},
#	_create_empty_burst_description(10),
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": 14,
		"spawn_delay": 0.75,
		"burst_duration": 35,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Top, SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": 14,
		"spawn_delay": 0.75,
		"burst_duration": 35,
		"next_burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Bottom, SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": 12,
		"spawn_delay": 0.01,
		"burst_duration": 1,
		"next_burst_start_delay": 20,
		"burst_sides": [SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": 12,
		"spawn_delay": 0.01,
		"burst_duration": 2,
		"next_burst_start_delay": 6,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_speed": 12,
		"spawn_delay": 0.01,
		"burst_duration": 2,
		"next_burst_start_delay": 6,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
]

var full_level

var current_level
var wave_index
var current_wave
var burst_index

func initialize(father_worlds):
	worlds = father_worlds
	for world in worlds:
		world.spawner_handler.connect("burst_ended", self, "_on_burst_ended")
		
	full_level = [wave1, _create_empty_wave(45), wave1]

func start():
	_play_level(full_level)

func _input(input):
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

func _next_wave():
	wave_index += 1
	if wave_index < current_level.size():
		var wave = current_level[wave_index]
		_play_wave(wave)
		emit_signal("next_wave")
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
		var spawner_handler = worlds[world_index].spawner_handler
		var _burst = spawner_handler.start_burst(
			burst_index,
			burst_description.spawn_type,
			burst_description.spawn_speed,
			burst_description.spawn_delay,
			burst_description.burst_duration,
			burst_description.burst_sides)
	var next_burst_start_delay = max(burst_description.next_burst_start_delay, 0.0001)
	burst_start_timer.set_wait_time(next_burst_start_delay)
	burst_start_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_burst_ended(_burst):
	pass

func _on_BurstStartTimer_timeout():
	_next_burst()
