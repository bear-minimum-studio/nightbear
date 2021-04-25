extends Path2D

export (Vector2) var spawn_direction

func _ready():
	randomize()
	
func spawn(spawned_entity):
	var instance = spawned_entity.instance()
	
	var spawn_location = $SpawnLocation
	spawn_location.unit_offset = randf()
	
	add_child(instance)
	instance.initialize(spawn_location.transform.origin, spawn_direction)

	return instance
