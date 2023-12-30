@icon("res://icons/SplitScreen.svg")
extends Control
class_name SplitScreen


@onready var viewport0 = $HBoxContainer/SubViewportContainer/SubViewport
@onready var viewport1 = $HBoxContainer/SubViewportContainer2/SubViewport

@onready var camera0 = $HBoxContainer/SubViewportContainer/SubViewport/Camera2D
@onready var camera1 = $HBoxContainer/SubViewportContainer2/SubViewport/Camera2D


var world : AbstractWorld:
	set(value):
		world = value
		if world != null:
			
			viewport0.add_child(world)
			
			### WE NEED TO SET THE RENDERED WORLD FOR THE SECOND VIEWPORT AS THE WORLD CAN ONLY EXIST IN ONE VIEWPORT
			### /!\ SETTING THIS TO world DOESN'T WORK WE NEED TO USE THE EXACT OBJECT USED IN THE FIRST VIEWPORT
			viewport1.world_2d = viewport0.world_2d
			
			camera0.proxy = world.proxy_camera0
			camera1.proxy = world.proxy_camera1
