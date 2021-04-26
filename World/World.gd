extends Node2D

export (int) var id = 1

const hit_wall_particle = preload("res://Projectiles/HitWallParticles.tscn")

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

func _connect_enemy_projectile(enemy_projectile: EnemyProjectile) -> void:
	enemy_projectile.connect("hit_wall", self, "_spawn_hit_wall_particle")

func _spawn_hit_wall_particle(wall_global_position: Vector2) -> void:
	var new_particles = hit_wall_particle.instance()
	new_particles.global_position = wall_global_position
	add_child(new_particles)
	new_particles.emitting = true
