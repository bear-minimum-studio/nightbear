extends Control

class_name  PlayMenu

@onready var exits_dict = {
		$MarginContainer/VBoxContainer/LANButton.pressed: MenuNavigator.MENU.NETWORK,
		$MarginContainer/VBoxContainer/WANButton.pressed: MenuNavigator.MENU.NETWORK,
	}

@onready var default_focus = $MarginContainer/VBoxContainer/LocalButton


func _on_local_button_pressed():
	Events.localing.emit()


func _on_lan_button_pressed():
	pass # Replace with function body.


func _on_wan_button_pressed():
	pass # Replace with function body.


func _on_back_button_pressed():
	pass # Replace with function body.
