extends StaticBody2D

class_name Wall

onready var animated_sprite = $AnimatedSprite
onready var lifebar = $ProgressBar
onready var timer = $Timer

func _ready():
	timer.start(Parameters.WALL_MAX_LIFETIME)
	randomize()
	animated_sprite.frame = randi() % Parameters.WALL_NUMBER_OF_SPRITES

func _on_Timer_timeout():
	self.queue_free()

func _physics_process(_delta):
	_process_color()

func hit():
	_set_timer()

func _process_color():
	var life_left = timer.time_left / Parameters.WALL_MAX_LIFETIME
	lifebar.value = life_left * 100
	self.modulate.g = life_left
	self.modulate.b = life_left

func _set_timer():
	var timeleft = timer.time_left
	timer.stop()
	timer.start(max(timeleft-3.0, 0.0001))
