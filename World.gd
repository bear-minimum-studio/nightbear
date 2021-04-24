extends Node2D

export (String) var id = "1"

onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.id = id


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
