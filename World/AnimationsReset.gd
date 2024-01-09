@tool
extends AnimationTree


@export var shapes : Node2D
@export var animation_player : AnimationPlayer

@export_category('Link Animations to Shapes ')
@export var link := true
@export var exclude : Array[String] = ['RESET']



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
			add_child_in_editor(name)


func add_child_in_editor(name: String) -> Node2D:
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


func _on_animation_started(anim_name):
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
