extends Control

class_name MainMenu

@onready var exits_dict = {
		$MarginContainer/VBoxContainer/PlayButton.pressed: MenuNavigator.MENU.PLAY,
		$MarginContainer/VBoxContainer/SettingsButton.pressed: MenuNavigator.MENU.SETTINGS,
	}



func _on_tutorial_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	pass # Replace with function body.
