@tool
extends GeneratorBehavior
class_name GeneratorArcBehavior


@export var spread : float = 30.0;


func _update_properties() -> void:
	var N = get_child_count()
	for i in range(N):
		 # make sure the arc is centered around 0°
		 # 360° shouldn't overlap first and last childs
		var angle_separation = spread / N
		var angle_offset = (i - (N - 1) / 2.0) * angle_separation
		var angle_with_spread = shoot_angle + deg_to_rad(angle_offset)
		get_child(i).position = progress * Vector2.from_angle(angle_with_spread)
		get_child(i).rotation = angle_with_spread


func _get_configuration_warnings():
	var warning = []
	if get_child_count() == 0:
		warning.append('Add a multiple projectiles that will spread along an arc')
	return warning
