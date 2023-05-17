extends Control

class_name  SettingsMenu

@onready var exits_dict = {
		$MarginContainer/VBoxContainer/BackButton.pressed: MenuNavigator.MENU.MAIN,
	}
