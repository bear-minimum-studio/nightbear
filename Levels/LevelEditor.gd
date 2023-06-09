@tool
extends Node2D
class_name LevelEditor

var world : Node2D

@export var level_resource : LevelResource :
	set(value):
		level_resource = value
		if value == null : return
		if value.level_name == '': return
		clean()
		load_level()

@export var load : bool = false :
	set(value):
		if not value: return
		if level_resource == null: return
		clean()
		load_level()

@export var save : bool = false :
	set(value):
		if not value: return
		if level_resource == null: return
		level_resource.save_worlds(world)

@export var reset : bool = false :
	set(value):
		if not value: return
		clean()


var levels : Dictionary # list of name: LevelRessource


func _ready():
	pass


func clean():
	for child in get_children():
		remove_child(child)


func load_level():
#	load_property(level_resource.animation_player)
#	load_property(level_resource.animation_tree)

	world = load(level_resource.world_scene_path).instantiate(0)
	world.name = "World 0"
	world.position = Vector2(-400,0)
	load_property(world, level_resource.world_scene_path)


func load_property(property: Node, path: String):
	add_child(property)
	set_editable_instance(property,true)
	property.scene_file_path = ''
	property.set_owner(self)

