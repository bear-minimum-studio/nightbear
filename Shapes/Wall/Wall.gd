@tool
extends Shape

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



func get_nb_items():
	return nb_columns * nb_lines


func row(index: int) -> int:
	return index / nb_columns


func column(index: int) -> int:
	return index % nb_columns



func item_position(index: int) -> Vector2:
	var row_offset = (nb_lines - 1) / 2.0
	var column_offset = (nb_columns - 1) / 2.0
	var row_jitter = randf_range(-jitter, jitter)
	var column_jitter = randf_range(-jitter, jitter)

	return Vector2(
				(column(index) - column_offset) * column_spacing + column_jitter,
				(row(index) - row_offset) * line_spacing + row_jitter
			)
