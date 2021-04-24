extends Node

export (NodePath) var camera1_path
export (NodePath) var camera2_path
export (NodePath) var world1_path
export (NodePath) var world2_path

onready var camera1 = get_node(camera1_path)
onready var camera2 = get_node(camera2_path)
onready var world1 = get_node(world1_path)
onready var world2 = get_node(world2_path)

const wall = preload("res://Obstacles/Wall.tscn")

func _ready():
	camera1.target = world1
	camera2.target = world2

	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("build", self, "_build")

func _build(id: int, t:Transform2D):
	var new_wall = wall.instance()
	new_wall.transform = t

	if (id  == 1):
		world2.add_child(new_wall)
	elif (id  == 2):
		world1.add_child(new_wall)
