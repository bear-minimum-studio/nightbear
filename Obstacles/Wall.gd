extends StaticBody2D

class_name Wall

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

func _ready():
	randomize()
	animated_sprite.frame = randi() % Parameters.WALL_NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()

func _physics_process(delta):
	_process_color()

func hit():
	_set_timer()

func _process_color():
	var color_modulation = timer.time_left / Parameters.WALL_MAX_LIFETIME
	self.modulate.g = color_modulation
	self.modulate.b = color_modulation

func _set_timer():
	var timeleft = timer.time_left
	timer.stop()
	timer.start(max(timeleft-3.0, 0.0001))
