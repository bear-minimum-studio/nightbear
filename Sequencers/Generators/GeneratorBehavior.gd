@tool
extends Node2D
class_name GeneratorBehavior



var index : int
var shoot_angle : float = 0.0
var shoot_interval : float = 0.0
var progress : float = 0.0


signal behavior_changed



func _ready():
	if Engine.is_editor_hint():
		child_order_changed.connect(_on_child_changed)
		update_configuration_warnings()



func _on_child_changed() -> void:
	behavior_changed.emit()
	update_configuration_warnings()



func _get_configuration_warnings():
	var warning = []
	if get_child_count() == 0:
		warning.append('Add a node2D as a child that will be used as ammo by the generator')
	return warning



func is_shooted() -> bool:
	return progress > 0



func set_progress(value : float) -> void:
	progress = value
	_update_properties()
	
	if is_shooted() and not visible:
		show()
	elif not is_shooted() and visible:
		hide()



func _update_properties() -> void:
	position = progress * Vector2.from_angle(shoot_angle)
	rotation = shoot_angle
