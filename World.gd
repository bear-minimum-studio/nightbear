extends Node2D


export (int) var id = 1

onready var player = $Player

func _ready():
	player.id = id

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
