extends Node2D

class_name SpawnHandler

enum Sides {Left, Top, Right, Bottom}

var world_id := 0

onready var spawners := {
	Sides.Left: $SpawnerContainer/LinearSpawnerLeft,
	Sides.Top: $SpawnerContainer/LinearSpawnerTop,
	Sides.Right: $SpawnerContainer/LinearSpawnerRight,
	Sides.Bottom: $SpawnerContainer/LinearSpawnerBottom
}

func initialize(father_world_id: int) -> void:
	world_id = father_world_id
	for side in [Sides.Left, Sides.Top, Sides.Right, Sides.Bottom]:
		spawners[side].initialize(side, world_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func spawn(spawned_entity: PackedScene, spawn_parameters: Dictionary, sides: Array) -> Node2D:
	var spawn_side = sides[randi() % sides.size()]
	var spawner = spawners[spawn_side]
	var spawned_instance = spawner.spawn(spawned_entity, spawn_parameters)
	return spawned_instance
