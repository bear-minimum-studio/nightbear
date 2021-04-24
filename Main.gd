extends Node

onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera1
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2
onready var world1 = $Viewports/ViewportContainer1/Viewport1/World1
onready var world2 = $Viewports/ViewportContainer2/Viewport2/World2

func _ready():
	camera1.target = world1
	camera2.target = world2
