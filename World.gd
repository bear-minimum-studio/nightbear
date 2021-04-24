extends Node2D

export (int) var id = 1

onready var player = $Player

func initialize(father_id: int):
	id = father_id
	player.initialize(id)

func _ready():
	pass
