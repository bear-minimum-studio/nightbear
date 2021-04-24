extends StaticBody2D

class_name CWall

const NUMBER_OF_SPRITES = 3
var health_points = 3

onready var animated_sprite = $AnimatedSprite

func _ready():
	randomize()
	animated_sprite.frame = randi() % NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()

func hit():
	health_points -= 1
	if (health_points <= 0):
		self.queue_free()
