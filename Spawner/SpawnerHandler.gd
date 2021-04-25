extends Node2D

signal allied_projectile_spawned

export (PackedScene) var spawned_entity
export (float) var spawn_delay = 0.5

const DEFAULT_SPAWNED_ENTITY = preload("res://Projectiles/EnemyProjectile.tscn")

onready var spawn_timer = $SpawnTimer
onready var spawners = $SpawnerContainer.get_children()
onready var nb_spawners = spawners.size()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.set_wait_time(spawn_delay)
	randomize()
	if !spawned_entity:
		spawned_entity = DEFAULT_SPAWNED_ENTITY
	for spawner in spawners:
		spawner.initialize(spawned_entity)

func _on_SpawnTimer_timeout():
	var spawner_index = randi() % nb_spawners
	var spawned_instance = spawners[spawner_index].spawn()
	if spawned_instance is AllyProjectile:
		emit_signal("allied_projectile_spawned", spawned_instance)
