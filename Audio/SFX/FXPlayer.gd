extends Node


onready var sound_fxs = self.get_children()
onready var nb_fxs = len(sound_fxs)

func play():
	randomize()
	sound_fxs[randi() % nb_fxs].play()


func _ready():
	if self.get_child_count() == 0:
		push_error ( "No Stream Child" )

