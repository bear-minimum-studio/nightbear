extends Control

class_name  SettingsMenu

@onready var check_button = $MarginContainer/VBoxContainer/CheckButton

@onready var exits_dict = {}


func _ready():
	check_button.button_pressed = Settings.fullscreen


func _on_check_button_toggled(button_pressed):
	Settings.fullscreen = button_pressed

