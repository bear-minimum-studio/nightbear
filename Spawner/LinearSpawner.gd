extends Path2D

signal entity_spawned

@export var ally_projectile: PackedScene
@export var ennemy_projectile: PackedScene
@export var doom_projectile: PackedScene

var spawn_direction: Vector2
var world_id: int
@onready var spawned_entities = {
	Projectile.ProjectyleType.Ally: ally_projectile,
	Projectile.ProjectyleType.Ennemy: ennemy_projectile,
	Projectile.ProjectyleType.Doom: doom_projectile,
}

@onready var _spawn_location := $SpawnLocation

func _ready() -> void:
	randomize()

func _get_spawn_location(offset: float) -> Vector2:
	_spawn_location.progress_ratio = offset
	return _spawn_location.global_position

func _get_spawn_direction(side) -> Vector2:
	match side:
		SpawnHandler.Sides.Left:
			return Vector2.RIGHT
		SpawnHandler.Sides.Top:
			return Vector2.DOWN
		SpawnHandler.Sides.Right:
			return Vector2.LEFT
		SpawnHandler.Sides.Bottom:
			return Vector2.UP
		_:
			return Vector2.ZERO

func initialize(side, father_world_id: int) -> void:
	world_id = father_world_id
	spawn_direction = _get_spawn_direction(side)
	
func spawn(spawn_type: int, spawn_parameters: Dictionary) -> Node2D:
	
	spawn_parameters.position = _get_spawn_location(randf())
	spawn_parameters.direction = spawn_direction
	
	var spawned_instance = spawned_entities[spawn_type].instantiate()
	spawned_instance.initialize(spawn_parameters, world_id)
	emit_signal("entity_spawned", spawned_instance)

	return spawned_instance
