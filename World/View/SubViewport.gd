@tool
extends SubViewportContainer

@onready var sub_viewport = $SubViewport
@onready var camera_2d = $SubViewport/Camera2D

var world: AbstractWorld:
	set(value):
		if world != null:
			sub_viewport.remove_child(world)
		
		world = value
		
		sub_viewport.add_child(value)
