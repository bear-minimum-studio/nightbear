@tool
extends Node2D

@export var projectile_scene: PackedScene :
	set(value):
		projectile_scene = value
		if !Engine.is_editor_hint(): return
		free_children()
		spawn()

@export var nb_items := 10 :
	set(value):
		nb_items = value
		if !Engine.is_editor_hint(): return
		free_children()
		spawn()

@export_category("Animatable")

@export_range(0.0,300.0,2.5,"or_greater") var radius := 75.0 :
	set(value):
		radius = value
		_update_positions()

@export_range(0.0,360.0,5.0) var length := 360.0 :
	set(value):
		length = value
		_update_positions()

@export_range(0.0,20.0,0.5,"or_greater") var jitter := 0.0 :
	set(value):
		jitter = value
		_update_positions()

@export var collisions := true :
	set(value):
		var has_child_with_collisions := false
		for child in get_children():
			if child.has_node('CollisionShape2D'):
				child.get_node('CollisionShape2D').disabled = not value
				has_child_with_collisions = true
		if not has_child_with_collisions:
			print('No child with collision in ', self)
		collisions = value

var items: Array # stores all projectiles in spawn order (a freed projectile is null)


func _ready():
	seed(Parameters.SEED)
	if !Engine.is_editor_hint(): # wall already spawn by exported vars in editor
		spawn()


func spawn():
	items.resize(nb_items)
	for i in range(nb_items):
		items[i] = _spawn_item(i)


func spawn_position(index: int) -> Vector2:
	var angle_offset = index * length / nb_items
	var x_jitter = randf_range(-jitter, jitter)
	var y_jitter = randf_range(-jitter, jitter)

	return Vector2(
				radius * cos(deg_to_rad(angle_offset)) + x_jitter,
				radius * sin(deg_to_rad(angle_offset)) + y_jitter
			)


func _spawn_item(index: int):
	var spawned_instance = projectile_scene.instantiate()
	spawned_instance.transform.origin = spawn_position(index)
	add_child(spawned_instance)
	return spawned_instance


func _update_positions():
	if items.size() < nb_items: return
	
	for i in range(nb_items):
		var child = items[i]
		# a child may have been destroyed
		if child != null:
			child.transform.origin = spawn_position(i)


func free_children():
	for child in get_children():
		child.queue_free()
