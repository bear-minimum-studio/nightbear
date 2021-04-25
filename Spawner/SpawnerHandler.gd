extends Node2D

signal allied_projectile_spawned

enum SpawnType {Ally, Enemy}

export (SpawnType) var spawn_type = SpawnType.Enemy

const spawning_parameters = {
	SpawnType.Ally: {
		"spawned_entity": preload("res://Projectiles/AllyProjectile.tscn"),
		"spawn_delay": Parameters.ALLY_PROJECTILE_SPAWN_DELAY
	},
	SpawnType.Enemy: {
		"spawned_entity": preload("res://Projectiles/EnemyProjectile.tscn"),
		"spawn_delay": Parameters.ENEMY_PROJECTILE_SPAWN_DELAY
	}
}

onready var spawn_timer = $SpawnTimer
onready var spawners = $SpawnerContainer.get_children()
onready var nb_spawners = spawners.size()

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawned_entity = spawning_parameters[spawn_type].spawned_entity
	var spawn_delay = spawning_parameters[spawn_type].spawn_delay
	
	spawn_timer.set_wait_time(spawn_delay)
	randomize()
	for spawner in spawners:
		spawner.initialize(spawned_entity)

func _on_SpawnTimer_timeout():
	var spawner_index = randi() % nb_spawners
	var spawned_instance = spawners[spawner_index].spawn()
	if spawned_instance is AllyProjectile:
		emit_signal("allied_projectile_spawned", spawned_instance)
