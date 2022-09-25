extends StaticBody2D

class_name DreamCatcher

var health_points = 1

@onready var timer = $Timer
@onready var cast_fx = $CastFX
@onready var catch_fx = $CatchFX

func _ready():
	timer.start(Parameters.DREAM_CATCHER_MAX_LIFETIME)
	cast_fx.play()

func _on_Timer_timeout():
	self.queue_free()

func hit():
	health_points -= 1
	if (health_points < 1):
		self.queue_free()

func caught():
	catch_fx.play()
