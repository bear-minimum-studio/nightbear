@tool
extends Shape


@export var nb_items := 10 :
	set(value):
		nb_items = value
		if !Engine.is_editor_hint(): return
		free_items()
		spawn()


@export_range(0.0,1000.0,2.5,"or_greater") var radius := 75.0 :
	set(value):
		radius = value
		_update_positions()

@export_range(0.0,360.0,5.0) var spread := 90.0 :
	set(value):
		spread = value
		_update_positions()



func get_nb_items():
	return nb_items


func item_position(index: int) -> Vector2:
	 # make sure the arc is centered around 0°
	var angle_separation = spread / (nb_items - 1)
	var angle_offset = (index - (items.size() - 1) / 2.0) * angle_separation
	
	var x_jitter = randf_range(-jitter, jitter)
	var y_jitter = randf_range(-jitter, jitter)

	return Vector2(
				radius * cos(deg_to_rad(angle_offset)) + x_jitter,
				radius * sin(deg_to_rad(angle_offset)) + y_jitter
			)

