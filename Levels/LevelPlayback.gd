@tool
extends Node2D
class_name LevelPlayback


signal playback_ended

#----------------------------
#region Required children

## Add anything you want to animate in the level as a child of this node
var shapes : Node2D :
	set(node):
		shapes = node
		if Engine.is_editor_hint():
			update_configuration_warnings()


## Define the sequence of animations to play in the level
var animation_tree : AnimationTree :
	set(node):
		animation_tree = node
		animation_tree.active = false # by default the animation_tree should not play
		animation_tree.animation_started.connect(_on_animation_tree_animation_started)
		animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)
		state_machine = animation_tree.get("parameters/playback")
		if Engine.is_editor_hint():
			update_configuration_warnings()


## Animate the level
var animation_player : AnimationPlayer :
	set(node):
		animation_player = node
		animation_player.animation_list_changed.connect(_on_animation_player_animation_list_changed)
		animation_player.current_animation_changed.connect(_on_animation_player_current_animation_changed)
		if Engine.is_editor_hint():
			update_configuration_warnings()

#endregion
#----------------------------

@export_category('Link Animations to Shapes ')
@export var link := true
@export var exclude : Array[String] = ['RESET']


# set when animation_tree is set
var state_machine : AnimationNodeStateMachinePlayback



## Start level playback
func start():
	animation_tree.active = true


## Stop level playback
func stop():
	animation_tree.active = false


func _enter_tree():
	if not child_entered_tree.is_connected(_on_child_entered_tree):
		child_entered_tree.connect(_on_child_entered_tree)
	
	if Engine.is_editor_hint():
		if not child_exiting_tree.is_connected(update_configuration_warnings):
			child_exiting_tree.connect(update_configuration_warnings.unbind(1)) # remove parameter passed by child_exiting_tree
			
		if not child_exiting_tree.is_connected(update_configuration_warnings):
			child_order_changed.connect(update_configuration_warnings)


func _get_configuration_warnings():
	var warning = []
	if animation_tree == null:
		warning.append('This node has no animation tree, consider adding an AnimationTree as a child')
	if animation_player == null:
		warning.append('This node has no animation player, consider adding an AnimationPlayer as a child')
	if shapes == null:
		warning.append('This node has no Shapes to animate, consider adding a Node2D child named Shapes')
	return warning


func _on_animation_player_animation_list_changed():
	if not Engine.is_editor_hint() or shapes == null:
		return
	
	if not link:
		return
	
	var animations = animation_player.get_animation_list()
	for name in animations:
		if name in exclude:
			continue
		
		if not sub_shape_exists(name):
			add_shapes_child_in_editor(name)


func add_shapes_child_in_editor(name: String) -> Node2D:
	var new_node := Node2D.new()
	new_node.name = name
	shapes.add_child(new_node)
	new_node.owner = get_tree().edited_scene_root
	return new_node


func sub_shape_exists(node_name: String) -> bool:
	if shapes == null:
		return false
	
	for c in shapes.get_children():
		if c.name == node_name:
			return true
	return false


func get_sub_shape(node_name: String) -> Node2D:
	if shapes == null:
		return null
	
	for c in shapes.get_children():
		if c.name == node_name:
			return c
	
	return null


func _on_animation_player_current_animation_changed(anim_name):
	only_enable_sub_shape(anim_name)


func _on_animation_tree_animation_started(anim_name):
	only_enable_sub_shape(anim_name)


func only_enable_sub_shape(node_name: String):
	if not link:
		return
	
	if shapes == null:
		return
	
	if node_name in exclude:
		return
	
	for c in shapes.get_children():
		c.visible = false
		if c.name == node_name:
			c.visible = true
			c.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			c.process_mode = Node.PROCESS_MODE_DISABLED


func _on_animation_tree_animation_finished(anim_name):
	if state_machine.get_current_node() == 'End':
		playback_ended.emit()


func _on_child_entered_tree(node):
	if shapes == null and node.name == 'Shapes': # Should create a class Shapes and not use name
		shapes = node
	
	if animation_player == null and node is AnimationPlayer:
		animation_player = node
	
	if animation_tree == null and node is AnimationTree:
		animation_tree = node
