@tool
extends Node2D

@export var projectile_scene: PackedScene :
	set(value):
		projectile_scene = value
		free_children()
		spawn()

@export var nb_lines := 10 :
	set(value):
		nb_lines = value
		free_children()
		spawn()

@export var nb_columns := 3 :
	set(value):
		nb_columns = value
		free_children()
		spawn()

@export_range(0.0,100.0,2.5,"or_greater") var line_spacing := 25.0 :
	set(value):
		line_spacing = value
		free_children()
		spawn()

@export_range(0.0,100.0,2.5,"or_greater") var column_spacing := 25.0 :
	set(value):
		column_spacing = value
		free_children()
		spawn()

@export_range(0.0,20.0,0.5,"or_greater") var jitter := 0.0 :
	set(value):
		jitter = value
		free_children()
		spawn()


func _ready():
	seed(Parameters.SEED)
	spawn()

func spawn():
	var line_offset = (nb_lines - 1) / 2.0
	var column_offset = (nb_columns - 1) / 2.0
	for line_idx in range(nb_lines):
		for column_idx in range(nb_columns):
			var line_jitter = randf_range(-jitter, jitter)
			var column_jitter = randf_range(-jitter, jitter)
			
			var spawn_position = Vector2(
				(column_idx - column_offset) * column_spacing + column_jitter,
				(line_idx - line_offset) * line_spacing + line_jitter
			)
			var spawned_instance = projectile_scene.instantiate()
			spawned_instance.transform.origin = spawn_position
			add_child(spawned_instance)

func free_children():
	for child in get_children():
		child.queue_free()
