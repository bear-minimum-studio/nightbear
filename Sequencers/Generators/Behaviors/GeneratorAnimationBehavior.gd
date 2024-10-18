@tool
extends GeneratorBehavior
class_name GeneratorAnimationBehavior



## How many pixels of progress for 1 second of animation
## (non animatable)
@export var progress_per_second : float = 400


@export var animation_name : String


var animation_player : AnimationPlayer:
	set(value):
		animation_player = value
		# we force the manual mode
		if animation_player:
			animation_player.set_process_callback(AnimationPlayer.ANIMATION_PROCESS_MANUAL)
			animation_player.animation_finished.connect(_on_animation_finished)


var previous_progress : float = 0.0

var animation_finished = false


func _ready():
	if Engine.is_editor_hint():
		child_entered_tree.connect(_on_child_entered_tree)
		child_exiting_tree.connect(_on_child_exiting_tree)
		update_configuration_warnings()
	
	if not Engine.is_editor_hint():
		for child in get_children():
			if child is AnimationPlayer:
				animation_player = child
				break
	
	super._ready()



func _update_properties() -> void:
	if progress == previous_progress or animation_finished: return
	var delta = progress - previous_progress
	
	if delta != 0 and animation_player:
		animation_player.play(animation_name)
	
	if animation_player:
		animation_player.advance( delta / progress_per_second )
	
	previous_progress = progress



func _on_animation_finished(_anim_name) -> void:
	animation_finished = true




func _get_configuration_warnings():
	var warning = []
	var has_node2d := false
	var has_animation_player := false
	for child in get_children():
		if child is Node2D:
			has_node2d = true
		if child is AnimationPlayer:
			has_animation_player = true
		
	if not has_node2d:
		warning.append('Add projectiles to animate')
	if not has_animation_player:
		warning.append('Add animation player to animate projectiles')
	if has_animation_player and not animation_name:
		warning.append('Set the animation name in inspector')
	return warning



func _on_child_exiting_tree(child: Node) -> void:
	if child == animation_player:
		animation_player = null
		#behavior_changed.emit() # maybe don't do anything as node is not valid
		update_configuration_warnings()



func _on_child_entered_tree(child: Node) -> void:
	if child is AnimationPlayer:
		animation_player = child
		#behavior_changed.emit() # node is valid again, time to update generator?
		update_configuration_warnings()
