extends Node

const wall = preload("res://Obstacles/Wall.tscn")
const dream_catcher = preload("res://Obstacles/DreamCatcher.tscn")

export (NodePath) var viewport_container1_path
export (NodePath) var viewport_container2_path

onready var viewport_container1 = get_node(viewport_container1_path)
onready var viewport_container2 = get_node(viewport_container2_path)

onready var world1 = viewport_container1.world
onready var world2 = viewport_container2.world

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("build", self, "_build")

func _build(id: int, t:Transform2D):
	var new_wall = wall.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = dream_catcher.instance()
	new_dream_catcher.transform.origin = t.origin

	if (id  == 1):
		world2.add_child(new_wall)
		world1.add_child(new_dream_catcher)
	elif (id  == 2):
		world1.add_child(new_wall)
		world2.add_child(new_dream_catcher)
