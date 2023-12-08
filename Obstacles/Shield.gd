extends StaticBody2D

class_name Shield

@onready var lifebar = $ProgressBar
@onready var timer = $Timer
@onready var cast_fx = $CastFX
@onready var hit_fx = $HitFX
@onready var destroyed_fx = $DestroyedFX

func _ready():
	timer.start(Parameters.SHIELD_MAX_LIFETIME)
	cast_fx.play()
	
func _on_Timer_timeout():
	destroyed_fx.play()
	self.queue_free()

func _physics_process(_delta):
	_process_color()

func hit():
	hit_fx.play()
	_set_timer()

func _process_color():
	var life_left = timer.time_left / Parameters.SHIELD_MAX_LIFETIME
	lifebar.value = life_left * 100
	self.modulate.g = life_left
	self.modulate.b = life_left

func _set_timer():
	var timeleft = timer.time_left
	timer.stop()
	timer.start(max(timeleft - Parameters.SHIELD_HIT_DAMAGE, 0.0001))
