extends Camera2D

var strength = 0
var reset_speed = 0
var doing_shake = false

onready var shake_length_timer = $Shake/ShakeLengthTimer
onready var shaking_timer = $Shake/ShakingTimer
onready var shaking_tween = $Shake/ShakingTween
onready var flash_sprite = $Flash/FlashSprite

func _ready():
	pass
	
func _on_ShakeLengthTimer_timeout():
	doing_shake = false
	reset_camera()
	shaking_timer.stop()

func _on_ShakingTimer_timeout():
	if doing_shake:
		shaking_tween.interpolate_property(self, "offset", offset, Vector2(rand_range(-strength, strength), rand_range(-strength, strength)), reset_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
		shaking_tween.start()

func reset_camera():
	shaking_tween.interpolate_property(self, "offset", offset, Vector2.ZERO, reset_speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()

func start_shake(time_of_shake, speed_of_shake, strength_of_shake):
	doing_shake = true
	strength = strength_of_shake
	reset_speed = speed_of_shake
	shake_length_timer.start(time_of_shake)
	shaking_timer.start(speed_of_shake)

func start_flash(speed, strength_of_flash):
	shaking_tween.interpolate_property(flash_sprite, "modulate:a", 0, strength_of_flash, speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()
	
	yield(get_tree().create_timer(speed), "timeout")
	shaking_tween.interpolate_property(flash_sprite, "modulate:a", strength_of_flash, 0, speed, Tween.TRANS_SINE, Tween.EASE_OUT)
	shaking_tween.start()
