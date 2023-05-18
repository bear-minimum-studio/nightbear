extends Control

class_name  SettingsMenu

@onready var check_button = $MarginContainer/VBoxContainer/HBoxContainer4/CheckButton
@onready var master_slider = $MarginContainer/VBoxContainer/HBoxContainer/MasterSlider
@onready var music_slider = $MarginContainer/VBoxContainer/HBoxContainer2/MusicSlider
@onready var fx_slider = $MarginContainer/VBoxContainer/HBoxContainer3/FXSlider

@onready var exits_dict = {}

@onready var default_focus = $MarginContainer/VBoxContainer/HBoxContainer4/CheckButton


func initialize_buttons():
	check_button.button_pressed = Settings.fullscreen
	master_slider.value = Settings.get_bus_gain(AudioBuses.MASTER_BUS)
	music_slider.value = Settings.get_bus_gain(AudioBuses.MUSIC_BUS)
	fx_slider.value = Settings.get_bus_gain(AudioBuses.SFX_BUS)


func _on_check_button_toggled(button_pressed):
	Settings.fullscreen = button_pressed


func _on_master_slider_value_changed(value):
	if value == master_slider.min_value:
		Settings.mute_bus(AudioBuses.MASTER_BUS,true)
	else:
		Settings.mute_bus(AudioBuses.MASTER_BUS,false)
	Settings.set_bus_gain(AudioBuses.MASTER_BUS,value)


func _on_music_slider_value_changed(value):
	if value == music_slider.min_value:
		Settings.mute_bus(AudioBuses.MUSIC_BUS,true)
	else:
		Settings.mute_bus(AudioBuses.MUSIC_BUS,false)
	Settings.set_bus_gain(AudioBuses.MUSIC_BUS,value)


func _on_fx_slider_value_changed(value):
	if value == fx_slider.min_value:
		Settings.mute_bus(AudioBuses.SFX_BUS,true)
	else:
		Settings.mute_bus(AudioBuses.SFX_BUS,false)
	Settings.set_bus_gain(AudioBuses.SFX_BUS,value)


func _on_visibility_changed():
	if visible:
		initialize_buttons()
