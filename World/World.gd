extends Node2D

export (int) var id = 1

onready var player = $Player
onready var player_shade = $PlayerShade
onready var spawner_handler = $SpawnerHandler

var dream_caught = 0

func initialize(father_id: int):
	id = father_id
	player.initialize(id)
	player_shade.initialize(id)

func _ready():
	pass
