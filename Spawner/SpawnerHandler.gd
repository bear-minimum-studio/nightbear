extends Node2D

class_name SpawnHandler

signal allied_projectile_spawned

enum SpawnType {Ally, Enemy}
enum Sides {Left, Top, Right, Bottom}

export (SpawnType) var spawn_type = SpawnType.Enemy

var spawned_entities = {
	SpawnType.Ally: preload("res://Projectiles/AllyProjectile.tscn"),
	SpawnType.Enemy: preload("res://Projectiles/EnemyProjectile.tscn")
}

var sides = []
var spawn_delay = 1
var duration = 0
var nb_sides = sides.size()

onready var burst_timer = $BurstTimer
onready var spawn_timer = $SpawnTimer
onready var spawners = {
	Sides.Left: $SpawnerContainer/LinearSpawnerLeft,
	Sides.Top: $SpawnerContainer/LinearSpawnerTop,
	Sides.Right: $SpawnerContainer/LinearSpawnerRight,
	Sides.Bottom: $SpawnerContainer/LinearSpawnerBottom
}
onready var spawned_entity = spawned_entities[spawn_type]

func stop_spawn_burst():
	spawn_timer.stop()
	burst_timer.stop()

func start_spawn_burst(burst_spawn_delay: float, burst_duration: float, burst_sides: Array):
	spawn_delay = burst_spawn_delay
	duration = burst_duration
	sides = burst_sides
	nb_sides = sides.size()
	
	burst_timer.start(duration)
	spawn_timer.start(spawn_delay)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_timer.set_wait_time(spawn_delay)
	for side in [Sides.Left, Sides.Top, Sides.Right, Sides.Bottom]:
		spawners[side].initialize(spawned_entity)

func _spawn():
	var spawn_side = sides[randi() % nb_sides]
	var spawner = spawners[spawn_side]
	var spawned_instance = spawner.spawn()
	if spawned_instance is AllyProjectile:
		emit_signal("allied_projectile_spawned", spawned_instance)

func _on_SpawnTimer_timeout():
	if !burst_timer.is_stopped():
		_spawn()

func _on_BurstTimer_timeout():
	stop_spawn_burst()
