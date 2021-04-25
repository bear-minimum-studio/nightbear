extends Control

var Game = preload("res://Game.tscn")

onready var dialog_iterator = $DialogIterator

func _ready():
	var _connect_error = dialog_iterator.connect("end", self, "start_game")
	dialog_iterator.start()

func start_game():
	var _change_scene_error = get_tree().change_scene_to(Game)
