extends Node2D

const wall = preload("res://Obstacles/Wall.tscn")

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("build", self, "_build")

func _build(id:String, t:Transform2D):
	var new_wall = wall.instance()
	new_wall.transform = t

	if (id  == "1"):
		$World2.add_child(new_wall)
	elif (id  == "2"):
		$World1.add_child(new_wall)
