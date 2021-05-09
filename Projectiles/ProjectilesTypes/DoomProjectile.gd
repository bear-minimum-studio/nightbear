extends "res://Projectiles/Projectile.gd"

class_name DoomProjectile

var target: Node2D

func initialize(spawn_parameters: Dictionary, father_world_id: int) -> void:
	.initialize(spawn_parameters, father_world_id)
	target = spawn_parameters.target
	_update_direction(spawn_parameters.direction)

func _update_direction(default_direction: Vector2) -> void:
	if target:
		var self_position = self.get_transform().origin
		var target_position = target.get_transform().origin
		direction = self_position.direction_to(target_position)
	else:
		direction = default_direction

func _on_collision(body: Node2D) -> void:
	if (body is Wall):
		body.hit()
		_die_with_particles()
	elif (body is Player):
		body.hit()
		_end()
	elif(body is DreamCatcher):
		body.hit()
