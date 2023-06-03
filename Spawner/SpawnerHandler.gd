extends Node2D

class_name SpawnHandler

signal entity_spawned

enum Sides {Left, Top, Right, Bottom}

var world_id := 0

@onready var spawners := {
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
	seed(Parameters.SEED)

func _choose_spwan_location(sides: Array):
	var spawn_side = sides[randi() % sides.size()]
	var spawn_offset = randf()
	return {
		"side": spawn_side,
		"offset": spawn_offset
	}

@rpc("call_local", "any_peer")
func _spawn_at_location(spawn_type: int, spawn_parameters: Dictionary, side: Sides, spawn_offset: float) -> void:
	var spawner = spawners[side]
	var spawned_instance = spawner.spawn(spawn_type, spawn_parameters, spawn_offset)
	emit_signal("entity_spawned", spawned_instance)

func spawn(spawn_type: int, spawn_parameters: Dictionary, sides: Array):
	if multiplayer.is_server():
		var location = _choose_spwan_location(sides)
		_spawn_at_location.rpc(spawn_type, spawn_parameters, location.side, location.offset)
