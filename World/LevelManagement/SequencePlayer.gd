extends "res://World/LevelManagement/SequenceElement.gd"


@export var level: Resource

func init(father_worlds: Array) -> void:
	initialize("0", level, null, father_worlds)

func _queue_free():
	pass

func _input(event) -> void:
	if event.is_action_pressed("next_burst") and OS.is_debug_build():
		if current_element != null:
			current_element.next()

func end() -> void:
	if(element_ended()):
		Events.sequence_ended.emit()
		super.end()

func play(element_index: int) -> void:
	if element_index > -1 and element_index < nb_elements:
		Events.new_subsequence.emit(element_index)
	super.play(element_index)
