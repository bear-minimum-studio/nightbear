@tool
extends Node2D
class_name Sequence



signal sequence_changed



func _ready() -> void:
	child_order_changed.connect(_on_child_order_changed)



func _on_child_order_changed() -> void:
	sequence_changed.emit()



func _get_configuration_warnings() -> PackedStringArray:
	var warning = []
	if get_parent() is not PathSequencer:
		warning.append('Add this node as the child of a PathSequencer')
	elif get_child_count() == 0:
		warning.append('Add Node2D children in the order you wish them to follow the path')
	return warning
