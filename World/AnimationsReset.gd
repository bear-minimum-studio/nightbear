@tool
extends AnimationTree


@export_category('Link Animations to Shapes ')
@export var link_animations_to_subshapes := true
@export var excluded_animations : Array[String] = ['RESET']

@onready var shapes = $"../Shapes"



func _on_animation_player_animation_list_changed():
	if not Engine.is_editor_hint() or shapes == null:
		return
	
	if not link_animations_to_subshapes:
		return
	
	var animations = get_animation_list() 
	for name in animations:
		if name in excluded_animations:
			continue
		
		if not sub_shape_exists(name):
			var sub_shape := Node2D.new()
			sub_shape.name = name
			shapes.add_child(sub_shape)
			sub_shape.owner = get_tree().edited_scene_root



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


func _on_animation_started(anim_name):
	only_enable_sub_shape(anim_name)


func only_enable_sub_shape(node_name: String):
	if not link_animations_to_subshapes:
		return
	
	if shapes == null:
		return
	
	if node_name in excluded_animations:
		return
	
	for c in shapes.get_children():
		c.visible = false
		if c.name == node_name:
			c.visible = true
			c.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			c.process_mode = Node.PROCESS_MODE_DISABLED
