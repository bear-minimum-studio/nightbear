extends Path2D

signal entity_spawned

export (Vector2) var spawn_direction

func _ready():
	randomize()
	
func spawn(spawned_entity, spawn_speed: float, target):
	var instance = spawned_entity.instance()
	
	var spawn_location = $SpawnLocation
	spawn_location.unit_offset = randf()
	
	emit_signal("entity_spawned", instance)
	
	instance.initialize(spawn_location.get_global_position(), spawn_direction, spawn_speed, target)

	return instance
