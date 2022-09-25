extends Camera2D

var shake_strength = 0
var reset_speed = 0.01
var doing_shake = false

var flash_strength = 0
var flash_speed = 0.01

@onready var shake_length_timer = $Shake/ShakeLengthTimer
@onready var shaking_timer = $Shake/ShakingTimer
@onready var shaking_tween = $Shake/ShakingTween

@onready var flash_sprite = $Flash/FlashSprite
@onready var flash_timer = $Flash/FlashTimer

func _ready():
	pass
	
func _on_ShakeLengthTimer_timeout():
	doing_shake = false
	_reset_camera()
	shaking_timer.stop()
	shake_length_timer.stop()

func _on_ShakingTimer_timeout():
	if doing_shake:
		shaking_tween.interpolate_property(self, "offset", offset, Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength)), reset_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
		shaking_tween.start()

func _reset_camera():
	shaking_tween.interpolate_property(self, "offset", offset, Vector2.ZERO, reset_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()

func start_shake(time_of_shake, speed_of_shake, strength_of_shake):
	doing_shake = true
	shake_strength = strength_of_shake
	reset_speed = speed_of_shake
	shake_length_timer.start(time_of_shake)
	shaking_timer.start(speed_of_shake)

func start_flash(speed, strength_of_flash):
	flash_strength = strength_of_flash
	flash_speed = speed
	shaking_tween.interpolate_property(flash_sprite, "modulate:a", 0, flash_strength, flash_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()
	flash_timer.start(speed)
	
func _end_flash():
	shaking_tween.interpolate_property(flash_sprite, "modulate:a", flash_strength, 0, flash_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()
	flash_timer.stop()

func _on_FlashTimer_timeout():
	_end_flash()
