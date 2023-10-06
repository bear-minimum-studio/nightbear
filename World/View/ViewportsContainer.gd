extends HBoxContainer
class_name ViewportsContainer

@onready var sub_viewports : Array[SubViewportContainer] = [$SubViewport0, $SubViewport1]

var world: AbstractWorld:
	set(value):
		world = value
		sub_viewports[0].world = value
		
		### WE NEED TO SET THE RENDERED WORLD FOR THE SECOND VIEWPORT AS THE WORLD CAN ONLY EXIST IN ONE VIEWPORT
		### /!\ SETTING THIS TO world DOESN'T WORK WE NEED TO USE THE EXACT OBJECT USED IN THE FIRST VIEWPORT
		sub_viewports[1].sub_viewport.world_2d = sub_viewports[0].sub_viewport.world_2d
		
		for region_id in [0,1]:
			sub_viewports[region_id].camera_2d.position = value.camera_positions[region_id]

