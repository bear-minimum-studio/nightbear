extends StaticBody2D

const NUMBER_OF_SPRITES = 3

onready var animated_sprite = $AnimatedSprite

func _ready():
	randomize()
	animated_sprite.frame = randi() % NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()
