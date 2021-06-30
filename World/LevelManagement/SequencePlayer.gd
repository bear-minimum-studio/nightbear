extends "res://World/LevelManagement/SequenceElement.gd"

export (Resource) var level

func init(father_worlds: Array) -> void:
	initialize("0", level, null, father_worlds)

func _queue_free():
	pass

func _input(event) -> void:
	if event.is_action_pressed("next_burst") and OS.is_debug_build():
		current_element.next()
