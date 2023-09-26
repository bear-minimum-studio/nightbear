extends CharacterBody2D

class_name Player

@onready var build_timer = $BuildTimer
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree_controller = $AnimationTree.get("parameters/playback")
@onready var spell_fx = $SpellFX

@export var is_immortal := false

var player_velocity := Vector2.ZERO
var spawn_position := Vector2.ZERO

var peer_id : int
var region_id : int
var input_id : int
var ready_to_build := false


## /!\ /!\ player.name is used to pass multiple variables (dirty) /!\ /!\
func _enter_tree():
	# DEBUG
#	var name = self.name
	self.peer_id = str(self.name).split('_')[0].to_int()
	set_multiplayer_authority(self.peer_id)

func _ready():
	sprite.initialize(region_id)
	input_id = region_id if NetworkTools.local_multiplayer else 0

@rpc("call_local", "authority")
func _on_player_moved():
	Events.player_moved.emit()

func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("P%d_walk_right" % input_id) - Input.get_action_strength("P%d_walk_left" % input_id)
	input_vector.y = Input.get_action_strength("P%d_walk_down" % input_id) - Input.get_action_strength("P%d_walk_up" % input_id)
 
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
	if player_velocity.length_squared() > 0:
		_on_player_moved.rpc()
	
	if Input.is_action_just_pressed("P%d_build" % input_id):
		_build.rpc()

@rpc("call_local", "any_peer")
func reset_position():
	position = spawn_position


@rpc("call_local", "authority")
func _build():
	if !ready_to_build:
		return

	spell_fx.play()
	animation_tree_controller.travel("Cast")
	ready_to_build = false
	reset_build_timer()
	Events.build.emit(region_id, self.transform)

func _on_BuildTimer_timeout():
	ready_to_build = true

func reset_build_timer():
	build_timer.set_wait_time(Parameters.BUILD_RELOAD_TIME)
	build_timer.start()

func hit():
	_player_death()

func _player_death():
	if (!is_immortal):
		# vibrate controller of hit player
		if is_multiplayer_authority():
			_vibrate_controller()
		Events.player_dead.emit(region_id)

func _vibrate_controller():
	Input.start_joy_vibration(input_id,0.5,0.5,0.1)
	Input.vibrate_handheld(100)
