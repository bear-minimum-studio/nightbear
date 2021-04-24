extends Node

export (NodePath) var camera1_path
export (NodePath) var camera2_path
export (NodePath) var world1_path
export (NodePath) var world2_path

onready var camera1 = get_node(camera1_path)
onready var camera2 = get_node(camera2_path)
onready var world1 = get_node(world1_path)
onready var world2 = get_node(world2_path)

func _ready():
	camera1.target = world1
	camera2.target = world2
