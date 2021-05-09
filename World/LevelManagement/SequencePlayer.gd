extends "res://World/LevelManagement/SequenceElement.gd"

var level_description = preload("res://World/LevelManagement/Resources/level.tres")

func init(father_worlds: Array) -> void:
	initialize("0", level_description, null, father_worlds)

func _queue_free():
	pass
