extends Control

class_name MainMenu

@onready var exits_dict = {
		$MarginContainer/VBoxContainer/PlayButton.pressed: MenuNavigator.MENU.PLAY,
		$MarginContainer/VBoxContainer/SettingsButton.pressed: MenuNavigator.MENU.SETTINGS,
	}

@onready var default_focus = $MarginContainer/VBoxContainer/PlayButton


func _on_tutorial_button_pressed():
	Events.play_intro.emit()

func _on_quit_button_pressed():
	Events.quit_game.emit()
