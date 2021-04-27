extends "res://Projectiles/Projectile.gd"

class_name AllyProjectile

signal missed_ally_projectile
signal dream_caught

var _is_dead = false

func _on_exit_game_area():
	if !_is_dead:
		emit_signal("missed_ally_projectile", world_id)
	_end()

func _on_collision(body):
	if body is DreamCatcher:
		body.caught()
		_dream_caught()

func _dream_caught():
	emit_signal("dream_caught", self.global_position)
	_is_dead = true
	_end()
