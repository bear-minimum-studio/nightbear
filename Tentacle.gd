extends Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

var size = 1

func _ready():
	pass

func _input(event):
	if (event.is_action_pressed("P1_walk_left")):
		grow()

func grow():
	size = min(size+1, 3)
	animation_player.play("Wave0"+String(size))
	
