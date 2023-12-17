@tool
extends Node2D

@export var projectile_scene: PackedScene :
	set(value):
		projectile_scene = value
		if !Engine.is_editor_hint(): return
		free_children()
		spawn()

@export var nb_lines := 10 :
	set(value):
		nb_lines = value
		if !Engine.is_editor_hint(): return
		free_children()
		spawn()

@export var nb_columns := 3 :
	set(value):
		nb_columns = value
		if !Engine.is_editor_hint(): return
		free_children()
		spawn()

@export_range(0.0,100.0,2.5,"or_greater") var line_spacing := 25.0 :
	set(value):
		line_spacing = value
		_update_positions()

@export_range(0.0,100.0,2.5,"or_greater") var column_spacing := 25.0 :
	set(value):
		column_spacing = value
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


func index(row: int, column: int) -> int:
	return column + row * nb_columns


func spawn():
	items.resize(nb_lines * nb_columns)
	for line_idx in range(nb_lines):
		for column_idx in range(nb_columns):
			var spawned = _spawn_at_position(spawn_position(line_idx, column_idx))
			items[index(line_idx, column_idx)] = spawned


func spawn_position(row: int, column: int) -> Vector2:
	var row_offset = (nb_lines - 1) / 2.0
	var column_offset = (nb_columns - 1) / 2.0
	var row_jitter = randf_range(-jitter, jitter)
	var column_jitter = randf_range(-jitter, jitter)

	return Vector2(
				(column - column_offset) * column_spacing + column_jitter,
				(row - row_offset) * line_spacing + row_jitter
			)


func _get_item_at_coordinates(row: int, column: int):
	var idx = index(row, column)
	if idx < items.size():
		return items[idx]
	else:
		return null


func _spawn_at_position(spawn_position: Vector2):
	var spawned_instance = projectile_scene.instantiate()
	spawned_instance.transform.origin = spawn_position
	add_child(spawned_instance)
	return spawned_instance


func _update_positions():
	for row in range(nb_lines):
		for column in range(nb_columns):
			var child = _get_item_at_coordinates(row, column)
			# a child may have been destroyed
			if child != null:
				child.transform.origin = spawn_position(row, column)


func free_children():
	for child in get_children():
		child.queue_free()
