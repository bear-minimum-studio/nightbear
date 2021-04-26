extends StaticBody2D

class_name DreamCatcher

var health_points = 1

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

const DREAM_CATCHER_NUMBER_OF_SPRITES = 1

func _ready():
	timer.start(Parameters.DREAM_CATCHER_MAX_LIFETIME)
	randomize()
	animated_sprite.frame = randi() % DREAM_CATCHER_NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()

func hit():
	health_points -= 1
	if (health_points < 1):
		self.queue_free()

func caught():
	pass
