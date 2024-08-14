@tool
extends Window
class_name LevelSetupDialog



@export var level_name_edit : LineEdit
@export var template_option_button : OptionButton
@export var create_button : Button
@export var background : ColorRect

var templates = preload("res://Levels/Templates.tres").levels
var levels_folder = "res://Levels/"

var selected_template

# TODO:
# 	- check if level name is taken



func _ready():
	populate_template_menu()
	level_name_edit.grab_focus()



func populate_template_menu():
	template_option_button.clear()
	for template in templates:
		template_option_button.add_item(template.name)
	if templates.size() != 0:
		template_option_button.select(0)
		template_option_button.item_selected.emit(0)



func _on_create_button_pressed():
	if not level_name_edit.text:
		return
	
	create_level_from_template(level_name_edit.text, selected_template)
	close_requested.emit()



func create_level_from_template(level_name: String, template: LevelResource):
	# create folder
	var pascal_name = level_name.capitalize().replace(' ','')
	var new_folder = levels_folder + pascal_name
	DirAccess.make_dir_absolute(new_folder)
	
	# get template scenes
	var template_level : PackedScene = template.level_scene
	var template_world : PackedScene = load(template_level.resource_path).instantiate().world_scene
	
	# compute new paths
	var new_level_path = new_folder + '/' + pascal_name + 'Level.tscn'
	var new_world_path = new_folder + '/' + pascal_name + 'World.tscn'
	
	# change root node name of World and save it
	var new_world : BaseWorld = template_world.instantiate()
	new_world.name = pascal_name + 'World'
	save_scene_to_file(new_world, new_world_path)
	
	# change root name of level, add new world in export and save
	var new_level : BaseLevel = template_level.instantiate()
	new_level.name =  pascal_name + 'Level'
	new_level.world_scene = load(new_world_path)
	save_scene_to_file(new_level, new_level_path)
	
	# Create new level resource
	var new_resource := LevelResource.new()
	new_resource.name = level_name
	new_resource.level_scene = load(new_level_path)
	new_resource.difficulty = template.difficulty
	new_resource.description = template.description
	
	var new_resource_path = new_folder + '/' + pascal_name +'.tres'
	ResourceSaver.save(new_resource, new_resource_path)



func save_scene_to_file(scene, path):
	var packed = PackedScene.new()
	packed.pack(scene)
	ResourceSaver.save(packed, path)



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_requested.emit()


func _on_template_option_button_item_selected(index):
	selected_template = templates[index]



func _on_level_name_edit_text_submitted(new_text):
	create_button.grab_focus()
