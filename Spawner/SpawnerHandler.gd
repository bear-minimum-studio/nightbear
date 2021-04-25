extends Node2D

class_name SpawnHandler

export (int) var id = 11

signal allied_projectile_spawned
signal burst_ended

enum SpawnType {Ally, Enemy}
enum Sides {Left, Top, Right, Bottom}

export (SpawnType) var spawn_type = SpawnType.Enemy

var last_burst_id = -1

onready var spawners = {
	Sides.Left: $SpawnerContainer/LinearSpawnerLeft,
	Sides.Top: $SpawnerContainer/LinearSpawnerTop,
	Sides.Right: $SpawnerContainer/LinearSpawnerRight,
	Sides.Bottom: $SpawnerContainer/LinearSpawnerBottom
}

var spawned_entities = {
	SpawnType.Ally: preload("res://Projectiles/AllyProjectile.tscn"),
	SpawnType.Enemy: preload("res://Projectiles/EnemyProjectile.tscn")
}

onready var spawned_entity = spawned_entities[spawn_type]

onready var burst_timer_entity = preload("res://Spawner/BurstTimer.tscn")
onready var spawn_timer_entity = preload("res://Spawner/SpawnTimer.tscn")

func initialize(father_id):
	id = father_id

func stop_burst(burst):
	burst.spawn_timer.stop()
	burst.burst_timer.stop()
	emit_signal("burst_ended", burst.id)

func start_burst(burst_spawn_delay: float, burst_duration: float, burst_sides: Array):
	last_burst_id += 1
	
	var burst = {}
	burst.id = int("%d%d" % [id, last_burst_id])
	
	burst.spawn_delay = burst_spawn_delay
	burst.duration = burst_duration
	
	burst.sides = burst_sides
	burst.nb_sides = burst_sides.size()
	
	burst.burst_timer = burst_timer_entity.instance()
	burst.spawn_timer = spawn_timer_entity.instance()
	
	add_child(burst.burst_timer)
	add_child(burst.spawn_timer)
	
	burst.burst_timer.initialize(burst)
	burst.spawn_timer.initialize(burst)
	
	burst.burst_timer.connect("BurstTimer_timeout", self, "_on_BurstTimer_timeout")
	burst.spawn_timer.connect("SpawnTimer_timeout", self, "_on_SpawnTimer_timeout")
	
	burst.burst_timer.start(burst.duration)
	burst.spawn_timer.start(burst.spawn_delay)
	
	return burst

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for side in [Sides.Left, Sides.Top, Sides.Right, Sides.Bottom]:
		spawners[side].initialize(spawned_entity)

func _spawn(burst):
	var spawn_side = burst.sides[randi() % burst.nb_sides]
	var spawner = spawners[spawn_side]
	var spawned_instance = spawner.spawn()
	if spawned_instance is AllyProjectile:
		emit_signal("allied_projectile_spawned", spawned_instance)

func _on_SpawnTimer_timeout(burst):
	if burst.nb_sides > 0 && !burst.burst_timer.is_stopped():
		_spawn(burst)

func _on_BurstTimer_timeout(burst):
	stop_burst(burst)
