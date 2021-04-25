extends StaticBody2D

class_name Wall

var health_points = 5

onready var animated_sprite = $AnimatedSprite

func _ready():
	randomize()
	animated_sprite.frame = randi() % Parameters.WALL_NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()

func hit():
	health_points -= 1
	var color_modulation = float(health_points) / float(Parameters.WALL_MAX_HEALTH_POINTS)
	self.modulate.g = color_modulation
	self.modulate.b = color_modulation
	if (health_points <= 0):
		self.queue_free()
