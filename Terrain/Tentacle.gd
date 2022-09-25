extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var size = 0

func grow():
	size = min(size+1, 3)
	animation_player.play("Wave0"+str(size))
