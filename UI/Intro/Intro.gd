extends Control

var Game = load("res://World/Game.tscn")

@onready var dialog_iterator = $DialogIterator

func _ready():
	var _connect_error = dialog_iterator.end.connect(start_game)
	dialog_iterator.start()

func start_game():
	var _change_scene_error = get_tree().change_scene_to_packed(Game)
