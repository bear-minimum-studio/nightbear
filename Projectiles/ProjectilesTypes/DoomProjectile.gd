extends "res://Projectiles/Projectile.gd"

class_name DoomProjectile

signal hit_wall

func _on_collision(body):
	if (body is Wall):
		body.hit()
		emit_signal("hit_wall", self.global_position)
		_end()
	elif (body is Player):
		body.hit()
		_end()
	elif(body is DreamCatcher):
		body.hit()
