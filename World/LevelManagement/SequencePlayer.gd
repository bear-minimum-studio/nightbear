extends "res://World/LevelManagement/SequenceElement.gd"

signal new_subsequence
signal sequence_ended

export (Resource) var level

func init(father_worlds: Array) -> void:
	initialize("0", level, null, father_worlds)

func _queue_free():
	pass

func _input(event) -> void:
	if event.is_action_pressed("next_burst") and OS.is_debug_build():
		if current_element != null:
			current_element.next()

func end() -> void:
	emit_signal("sequence_ended")
	.end()

func play(element_index: int) -> void:
	if element_index > -1 and element_index < nb_elements:
		emit_signal("new_subsequence", element_index)
	.play(element_index)
