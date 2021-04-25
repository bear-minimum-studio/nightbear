extends Node

var worlds

onready var burst_start_timer = $BurstStartTimer

var empty_wave = [
	{
		"world_indexes": [],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": -1,
		"burst_duration": -1,
		"burst_start_delay": 30,
		"burst_sides": []
	}
]

var wave1 = [
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.05,
		"burst_duration": 2,
		"burst_start_delay": 4,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0.5,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0.5,
		"burst_sides": [SpawnHandler.Sides.Right]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": 0,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 4,
		"burst_sides": [SpawnHandler.Sides.Top]
	},
	{
		"world_indexes": [0, 1],
		"spawn_type": Burst.SpawnType.Ally,
		"spawn_delay": 0,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	},
	{
		"world_indexes": [0],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Left]
	},
	{
		"world_indexes": [1],
		"spawn_type": Burst.SpawnType.Enemy,
		"spawn_delay": 0.03,
		"burst_duration": 1,
		"burst_start_delay": 0,
		"burst_sides": [SpawnHandler.Sides.Right]
	}
]

#var full_level = [empty_wave]
var full_level = [wave1, empty_wave, wave1]

var current_level
var wave_index
var current_wave
var burst_index

func initialize(father_worlds):
	worlds = father_worlds
	for world in worlds:
		world.spawner_handler.connect("burst_ended", self, "_on_burst_ended")

func start():
	play_level(full_level)

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
	for world_index in burst_description.world_indexes:
		var spawner_handler = worlds[world_index].spawner_handler
		var _burst = spawner_handler.start_burst(
			burst_index,
			burst_description.spawn_type,
			burst_description.spawn_delay,
			burst_description.burst_duration,
			burst_description.burst_sides)
	print("Burst start timer started for : %f" % burst_description.burst_start_delay)
	burst_start_timer.start(burst_description.burst_start_delay)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_burst_ended(_burst):
	pass

func _on_BurstStartTimer_timeout():
	next_burst()
