extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var size : int:
	set(value):
		size = min(value, 3)
		animation_player.play("Wave0"+str(size))

func grow():
	size = size + 1

func init():
	size = 0
