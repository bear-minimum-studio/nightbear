extends Node2D

export (int) var id = 1

const hit_wall_particle = preload("res://Projectiles/HitWallParticles.tscn")
const catch_dream_particle = preload("res://Projectiles/CatchDreamParticles.tscn")

onready var player = $Player
onready var player_shade = $PlayerShade
onready var spawner_handler = $SpawnerHandler

var dream_caught = 0

func initialize(father_id: int):
	id = father_id
	player.initialize(id)
	player_shade.initialize(id)

func _ready():
	spawner_handler.connect("enemy_projectile_spawned", self, "_connect_enemy_projectile")
	spawner_handler.connect("doom_projectile_spawned", self, "_connect_doom_projectile")
	spawner_handler.connect("allied_projectile_spawned", self, "_connect_ally_projectile")

	for side in [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]:
		var spawner = spawner_handler.spawners[side]
		spawner.connect("entity_spawned", self, "_on_entity_spawned")

func _connect_enemy_projectile(enemy_projectile: EnemyProjectile) -> void:
	var _unsed = enemy_projectile.connect("hit_wall", self, "_spawn_hit_wall_particle")

func _connect_doom_projectile(enemy_projectile: DoomProjectile) -> void:
	enemy_projectile.connect("hit_wall", self, "_spawn_hit_wall_particle")

func _connect_ally_projectile(ally_projectile: AllyProjectile) -> void:
	var _unsed = ally_projectile.connect("dream_caught", self, "_spawn_dream_caught_particle")

func _spawn_hit_wall_particle(wall_global_position: Vector2) -> void:
	var new_particles = hit_wall_particle.instance()
	new_particles.global_position = wall_global_position
	add_child(new_particles)
	new_particles.emitting = true

func _on_entity_spawned(instance):
	add_child(instance)

func _spawn_dream_caught_particle(dream_global_position: Vector2) -> void:
	var new_particles = catch_dream_particle.instance()
	new_particles.global_position = dream_global_position
	add_child(new_particles)
	new_particles.emitting = true
