extends "res://Projectiles/Projectile.gd"

class_name AllyProjectile


var _is_dead := false

func _on_exit_game_area() -> void:
	if !_is_dead:
		Events.missed_ally_projectile.emit(region_id)
	_end()

func _on_collision(body: Node2D) -> void:
	if body is DreamCatcher:
		body.caught()
		_dream_caught()

func _dream_caught() -> void:
	Events.dream_caught.emit(self.global_position)
	_is_dead = true
	_die_with_particles()
