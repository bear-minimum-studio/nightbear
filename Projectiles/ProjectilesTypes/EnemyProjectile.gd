extends "res://Projectiles/Projectile.gd"

class_name EnemyProjectile

func _on_collision(body: Node2D)  -> void:
	if (body is Wall):
		body.hit()
		_die_with_particles()
	elif (body is Player):
		body.hit()
		_end()
	elif(body is DreamCatcher):
		body.hit()
