extends "res://World/LevelManagement/SequenceElement.gd"

export (Resource) var level

func init(father_worlds: Array) -> void:
	initialize("0", level, null, father_worlds)

func _queue_free():
	pass
