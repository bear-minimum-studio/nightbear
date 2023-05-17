extends Control

class_name PauseMenu

@onready var exits_dict = {
#		$MarginContainer/VBoxContainer/ResumeButton.pressed: MenuNavigator.MENU.PLAY,
		$MarginContainer/VBoxContainer/SettingsButton.pressed: MenuNavigator.MENU.SETTINGS,
		$MarginContainer/VBoxContainer/ResumeButton.pressed: MenuNavigator.MENU.NONE,
	}



func _on_quit_button_pressed():
	Events.quit_game.emit()


func _on_resume_button_pressed():
	Events.resume_game.emit()
