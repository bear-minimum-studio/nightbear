extends KinematicBody2D



func _ready():
	pass

func _physics_process(delta):
	get_input()

func get_input():
    direction = 0
    if Input.is_action_pressed("walk_right"):
 		direction = 1
    elif Input.is_action_pressed("walk_left"):
    	direction = -1
 
	if Input.is_action_just_pressed("walk_left"):
		orientation = -1
	if Input.is_action_just_pressed("walk_right"):
		orientation = 1
	if Input.is_action_just_released("walk_left") && Input.is_action_pressed("walk_right"):
		orientation = 1
	elif Input.is_action_just_released("walk_right") && Input.is_action_pressed("walk_left"):
		orientation = -1
