extends "res://Projectiles/Projectile.gd"

class_name DoomProjectile

signal hit_wall

var target := Node2D.new()

func set_target(new_target: Node2D):
	target = new_target

func _update_direction(default_direction: Vector2):
	if target:
		var self_position = self.get_transform().origin
		var target_position = target.get_transform().origin
		direction = self_position.direction_to(target_position)
	else:
		direction = default_direction
		
	return direction

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
