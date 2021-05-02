extends Path2D

signal entity_spawned

onready var _spawn_location = $SpawnLocation
var world_id := 0

func _ready() -> void:
	randomize()

func _get_spawn_location(offset: float) -> Vector2:
	_spawn_location.unit_offset = offset
	return _spawn_location.global_position

func initialize(father_world_id: int) -> void:
	world_id = father_world_id
	
func spawn(spawned_entity: PackedScene, spawn_parameters: Dictionary) -> Node2D:
	
	spawn_parameters.position = _get_spawn_location(randf())
	
	var spawned_instance = spawned_entity.instance()
	spawned_instance.initialize(spawn_parameters, world_id)
	emit_signal("entity_spawned", spawned_instance)

	return spawned_instance
