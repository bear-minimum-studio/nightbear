extends CharacterBody2D

class_name Player


@onready var build_timer = $BuildTimer
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree_controller = $AnimationTree.get("parameters/playback")
@onready var spell_fx = $SpellFX

@export var is_immortal := false

var player_velocity := Vector2.ZERO
var world_id := 0
var ready_to_build := false

func initialize(father_world_id: int):
	world_id = father_world_id
	sprite.initialize(world_id)

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("P%d_walk_right" % world_id) - Input.get_action_strength("P%d_walk_left" % world_id)
	input_vector.y = Input.get_action_strength("P%d_walk_down" % world_id) - Input.get_action_strength("P%d_walk_up" % world_id)
 
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()
	
	player_velocity = Parameters.PLAYER_WALK_SPEED * input_vector
	set_velocity(player_velocity)
	move_and_slide()
	player_velocity = player_velocity
	
	if abs(player_velocity.x) > 5:
		sprite.set_orientation(player_velocity.x)
	
	# Might have a performance impact
	# Make this a direct function call the day it becomes a problem
	Events.player_moved.emit(world_id, transform.origin)
	
	if Input.is_action_pressed("P%d_build" % world_id):
		_build()

func _build():
	if !ready_to_build:
		return

	spell_fx.play()
	animation_tree_controller.travel("Cast")
	ready_to_build = false
	reset_build_timer()
	Events.build.emit(world_id, self.transform)

func _on_BuildTimer_timeout():
	ready_to_build = true

func reset_build_timer():
	build_timer.set_wait_time(Parameters.BUILD_RELOAD_TIME)
	build_timer.start()

func hit():
	_player_death()

func _player_death():
	if (!is_immortal):
		Events.player_dead.emit(world_id)
