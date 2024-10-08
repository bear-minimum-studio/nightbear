extends Camera2D

var shake_strength = 0
var reset_speed = 0.01
var doing_shake = false

var flash_strength = 0
var flash_speed = 0.01

@onready var shake_length_timer = $Shake/ShakeLengthTimer
@onready var shaking_timer = $Shake/ShakingTimer

@onready var flash_sprite = $Flash/FlashSprite
@onready var flash_timer = $Flash/FlashTimer

## Don't edit in Editor
@export var proxy : ProxyCamera
@export var debug_zoom := Vector2(0.25,0.25)


func _ready():
	if Parameters.DEBUG_CAMERA:
		zoom = debug_zoom


func _process(_delta):
	if proxy != null:
		position = proxy.position
		rotation = proxy.rotation
		offset = proxy.offset
		zoom = proxy.zoom


func _on_ShakeLengthTimer_timeout():
	doing_shake = false
	_reset_camera()
	shaking_timer.stop()
	shake_length_timer.stop()

func _on_ShakingTimer_timeout():
	if doing_shake:
		var shaking_tween = get_tree().create_tween()
		shaking_tween.tween_property(
			self,
			"offset",
			Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength)),
			reset_speed
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _reset_camera():
	var shaking_tween = get_tree().create_tween()
	shaking_tween.tween_property(
		self,
		"offset",
		Vector2.ZERO,
		reset_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

## Shakes the camera.
## [param time_of_shake] Total shaking duration
## [param speed_of_shake] Duration of 1 shake moove
## [param strength_of_shake] Max shake moove length
func start_shake(time_of_shake, speed_of_shake, strength_of_shake):
	doing_shake = true
	shake_strength = strength_of_shake
	reset_speed = speed_of_shake
	shake_length_timer.start(time_of_shake)
	shaking_timer.start(speed_of_shake)

## Flashes the camera.
## [param speed] Total flashing duration
## [param strength_of_flash] Max flash intensity
func start_flash(speed, strength_of_flash):
	flash_strength = strength_of_flash
	flash_speed = speed
	var shaking_tween = get_tree().create_tween()
	shaking_tween.tween_property(
		flash_sprite,
		"modulate:a",
		flash_strength,
		flash_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flash_timer.start(speed)
	
func _end_flash():
	var shaking_tween = get_tree().create_tween()
	shaking_tween.tween_property(
		flash_sprite,
		"modulate:a",
		0,
		flash_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flash_timer.stop()

func _on_FlashTimer_timeout():
	_end_flash()
