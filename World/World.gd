extends Node2D

var world_id = 0

onready var player = $Player
onready var player_shade = $PlayerShade
onready var spawner_handler = $SpawnerHandler

var dream_caught = 0

func initialize(father_id: int):
	world_id = father_id
	player.initialize(world_id)
	player_shade.initialize(world_id)
	spawner_handler.initialize(world_id)

func _ready():
	for side in [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]:
		var spawner = spawner_handler.spawners[side]
		var _unused = spawner.connect("entity_spawned", self, "_on_entity_spawned")

func _on_entity_spawned(instance):
	add_child(instance)
