extends KinematicBody2D

signal build

const PLAYER_WALK_ACCELERATION = 5000
const PLAYER_WALK_SPEED = 500
const FRICTION = 1000000

var velocity = Vector2.ZERO
var id := 1

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
	if event.is_action_pressed("P%d_build" % id):
		_build()

func _build():
	emit_signal("build", id , self.transform)
