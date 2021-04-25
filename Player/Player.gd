extends KinematicBody2D

class_name Player

signal build

onready var build_timer = $BuildTimer

export (bool) var isMortal = false

const PLAYER_WALK_ACCELERATION = 5000
const PLAYER_WALK_SPEED = 500
const FRICTION = 1000000
const BUILD_RELOAD_TIME = 1

var velocity := Vector2.ZERO
var id := 1
var ready_to_build := true

func initialize(father_id: int):
	id = father_id
	$Sprite.initialize(father_id)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("P%d_walk_right" % id) - Input.get_action_strength("P%d_walk_left" % id)
	input_vector.y = Input.get_action_strength("P%d_walk_down" % id) - Input.get_action_strength("P%d_walk_up" % id)
 
	if input_vector.length() > 1:
	   input_vector = input_vector.normalized()
 
	if input_vector != Vector2.ZERO:
	   velocity = velocity.move_toward(input_vector * PLAYER_WALK_SPEED, PLAYER_WALK_ACCELERATION * delta)
	else:
	   velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
 
	velocity = move_and_slide(velocity, Vector2.ZERO)

func _input(event):
	if event.is_action_pressed("P%d_build" % id) && ready_to_build:
		_build()

func _build():
	ready_to_build = false
	reset_build_timer()
	emit_signal("build", id, self.transform)

func _on_BuildTimer_timeout():
	ready_to_build = true

func reset_build_timer():
	build_timer.set_wait_time(BUILD_RELOAD_TIME)
	build_timer.start()

func hit():
	_player_death()

func _player_death():
	if (isMortal):
		queue_free()
