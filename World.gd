extends Node2D

export (int) var id = 1

onready var player = $Player
onready var player_shade = $PlayerShade
onready var spawner_handlers = $SpawnHandlersContainer.get_children()

var dream_caught = 0

func initialize(father_id: int):
	id = father_id
	player.initialize(id)
	player_shade.initialize(id)
	
	var spawner_handler_id = 0
	for spawner_handler in spawner_handlers:
		spawner_handler.initialize(int("%d%d" % [id, spawner_handler_id]))

func _ready():
	pass
