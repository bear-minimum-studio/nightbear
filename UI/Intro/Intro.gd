extends Control

@onready var dialog_iterator = $DialogIterator

func _ready():
	var _connect_error = dialog_iterator.end.connect(intro_ended)


func init():
	dialog_iterator.start()

func intro_ended():
	Events.intro_ended.emit()
