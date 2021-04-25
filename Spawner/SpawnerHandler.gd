extends Node2D

class_name SpawnHandler

signal allied_projectile_spawned
signal burst_ended

enum Sides {Left, Top, Right, Bottom}

onready var spawners = {
	Sides.Left: $SpawnerContainer/LinearSpawnerLeft,
	Sides.Top: $SpawnerContainer/LinearSpawnerTop,
	Sides.Right: $SpawnerContainer/LinearSpawnerRight,
	Sides.Bottom: $SpawnerContainer/LinearSpawnerBottom
}

var spawned_entities = {
	Burst.SpawnType.Ally: preload("res://Projectiles/AllyProjectile.tscn"),
	Burst.SpawnType.Enemy: preload("res://Projectiles/EnemyProjectile.tscn")
}

onready var burst_entity = preload("res://Spawner/Burst.tscn")

func stop_burst(burst):
	if burst.start_delay_timer.is_stopped():
		burst.queue_free()
	emit_signal("burst_ended")

func start_burst(burst_spawn_type, burst_spawn_delay: float, burst_duration: float, burst_start_delay : float, burst_sides: Array):
	var burst = burst_entity.instance()
	add_child(burst)
	burst.initialize(burst_spawn_type, burst_spawn_delay, burst_duration, burst_start_delay, burst_sides)
	
	burst.connect("BurstTimer_timeout", self, "_on_BurstTimer_timeout")
	burst.connect("SpawnTimer_timeout", self, "_on_SpawnTimer_timeout")
	burst.connect("StartDelayTimer_timeout", self, "_on_StartDelayTimer_timeout")
	
	return burst

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _spawn(burst):
	var spawn_side = burst.sides[randi() % burst.nb_sides]
	var spawner = spawners[spawn_side]
	var spawn_entity = spawned_entities[burst.spawn_type]
	var spawned_instance = spawner.spawn(spawn_entity)
	if spawned_instance is AllyProjectile:
		emit_signal("allied_projectile_spawned", spawned_instance)

func _on_SpawnTimer_timeout(burst):
	if burst.nb_sides > 0 && !burst.burst_timer.is_stopped():
		_spawn(burst)

func _on_BurstTimer_timeout(burst):
	stop_burst(burst)

func _on_StartDelayTimer_timeout(burst):
	if burst.spawn_timer.is_stopped():
		burst.queue_free()
