extends Path2D

export (PackedScene) var spawned_entity
export (Vector2) var spawn_direction

func _ready():
	randomize()

func initialize(father_spawn_entity: PackedScene):
	spawned_entity = father_spawn_entity
	
func spawn():
	var entity = spawned_entity.instance()
	
	var spawn_location = $SpawnLocation
	spawn_location.unit_offset = randf()
	
	add_child(entity)
	entity.initialize(spawn_location.transform.origin, spawn_direction)
