extends Resource
class_name LevelResource


@export var name : String

@export var level_scene: PackedScene

@export_enum('unrated', 'tuto', 'easy', 'medium', 'hard', 'expert') var difficulty := 'unrated'

@export_multiline var description := ''
