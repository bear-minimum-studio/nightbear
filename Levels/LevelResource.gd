#@tool
extends Resource
class_name LevelResource

#@export var click_to_save: bool = false :
#	set(value):
#		if not click_to_save: # on first click/set create the resource
#			create()
#			click_to_save = true
#		else: # on later clicks/sets save the resource
#			save()

@export_category("Do not edit")
@export_dir var save_dir: String :
	set(value):
		world_scene_path = value + 'world.tscn'
		save_dir = value

@export var default_world = 'res://World/AbstractWorld.tscn'


@export var world_scene : PackedScene

@export var world_scene_path : String :
	get: return save_dir + 'world.tscn'


func create():
#	TODO: 
#		- check if save_dir is correct
#		- warning if the folder / resource exists ?
	DirAccess.make_dir_absolute(save_dir)
	
	var world = load(default_world)
	
	world_scene = PackedScene.new()
	world_scene.pack(world.instantiate())
	world_scene.resource_path = world_scene_path
	ResourceSaver.save(world_scene, world_scene_path)
	
	save()


func save():
	ResourceSaver.save(self, resource_path)


func _recursive_set_owner(node : Node, new_owner : Node, root : Node):
#	if node.owner != root:
#		return

	node.set_owner(new_owner)
	for child in node.get_children():
		_recursive_set_owner(child, new_owner, root)


func save_world(world: Node2D):
	for child in world.get_children():
		_recursive_set_owner(child, world, world)

	world_scene = PackedScene.new()
	world_scene.pack(world)
	ResourceSaver.save(world_scene, world_scene_path)


#func _ready():
#	var world = load(default_world)
#	world_scene = world.instantiate()
#	var world = PackedScene.new()
#	world.pack(world.instantiate())
