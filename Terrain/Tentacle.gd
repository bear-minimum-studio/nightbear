extends Node2D
class_name Tentacle

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var size : int = 1:
	set(value):
		size = min(value, 3)
		animation_player.play("Wave0"+str(size))

func _ready():
	Events.level_started.connect(_on_level_started)
	Events.wave_started.connect(_on_wave_started)


func reset():
	size = 1

func grow():
	size = size + 1


func _on_level_started(_level_index, _max_level_index):
	reset()

func _on_wave_started(_wave_index, _max_wave_index):
	grow()
