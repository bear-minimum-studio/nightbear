extends KinematicBody2D

signal build

export (String) var id = "1"

const PLAYER_WALK_ACCELERATION = 500
const PLAYER_WALK_SPEED = 500
const FRICTION = 10

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("P"+id+"_walk_right") - Input.get_action_strength("P"+id+"_walk_left")
	input_vector.y = Input.get_action_strength("P"+id+"_walk_down") - Input.get_action_strength("P"+id+"_walk_up")
 
	if input_vector.length() > 1:
	   input_vector = input_vector.normalized()
 
	if input_vector != Vector2.ZERO:
	   velocity = velocity.move_toward(input_vector * PLAYER_WALK_SPEED, PLAYER_WALK_ACCELERATION * delta)
	else:
	   velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
 
	velocity = move_and_slide(velocity, Vector2.ZERO)



func _input(event):
	if event.is_action_pressed("P"+id+"_build"):
		_build()

func _build():
	emit_signal("build", id , self.transform)