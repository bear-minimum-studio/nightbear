extends Node

var config = ConfigFile.new()
var configPath = "user://settings.cfg"

var _initialized = false

@onready var fullscreen : bool : 
	get: 
		return (window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	set(value): 
		if value:
			window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		else:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED

@onready var window_mode : DisplayServer.WindowMode:
	get:
		return DisplayServer.window_get_mode()
	set(value):
		DisplayServer.window_set_mode(value)
		config.set_value("Settings", "window_mode", value)
		_save_settings()

@onready var first_execution : bool:
	set(value):
		first_execution = value
		config.set_value("Settings", "first_execution", value)
		_save_settings()
		

# default values are stored in Audio/bus_layout.tres
var buses_dict = {
	AudioBuses.MASTER_BUS: {
		"label": "master",
		"properties": {
			"gain": AudioServer.get_bus_volume_db(AudioBuses.MASTER_BUS),
			"muted": AudioServer.is_bus_mute(AudioBuses.MASTER_BUS)
		}
	},
	AudioBuses.MUSIC_BUS: {
		"label": "music",
		"properties": {
			"gain": AudioServer.get_bus_volume_db(AudioBuses.MUSIC_BUS),
			"muted": AudioServer.is_bus_mute(AudioBuses.MUSIC_BUS)
		}
	},
	AudioBuses.SFX_BUS: {
		"label": "sfx",
		"properties": {
			"gain": AudioServer.get_bus_volume_db(AudioBuses.SFX_BUS),
			"muted": AudioServer.is_bus_mute(AudioBuses.SFX_BUS)
		}
	},	
}



func _toggle_fullscreen() -> void:
	fullscreen = not fullscreen

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fullscreen"):
		_toggle_fullscreen()


func _save_settings() -> void:
	config.save(configPath)

func load_settings() -> void:
	var err = config.load(configPath)
	if err != OK:
		first_execution = true
	else:
		first_execution = false
		window_mode = config.get_value("Settings", "window_mode", window_mode)
		_load_buses_settings()
	
	_set_buses_settings()
	if not _initialized:
		_initialized = true
		Events.settings_initialized.emit()

func _load_buses_settings() -> void:
	for bus_idx in buses_dict.keys():
		var bus = buses_dict[bus_idx]
		for property in bus.properties.keys():
			var property_label = _get_bus_property_label(bus_idx, property)
			var value = config.get_value("Audio settings", property_label)
			if value != null:
				bus.properties[property] = value

func _get_bus_property_label(bus_idx: int, property: String) -> String:
	return buses_dict[bus_idx].label + "_" + property

func _set_buses_settings() -> void:
	for bus_idx in buses_dict.keys():
		set_bus_gain(bus_idx, buses_dict[bus_idx].properties.gain)
		mute_bus(bus_idx, buses_dict[bus_idx].properties.muted)

func set_bus_gain(bus_idx: int, gain: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx,gain)
	var property_label = _get_bus_property_label(bus_idx, "gain")
	config.set_value("Audio settings", property_label, get_bus_gain(bus_idx))
	_save_settings()

func get_bus_gain(bus_idx: int) -> float:
	return AudioServer.get_bus_volume_db(bus_idx)

func mute_bus(bus_idx: int, enable: bool) -> void:
	AudioServer.set_bus_mute(bus_idx, enable)
	var property_label = _get_bus_property_label(bus_idx, "muted")
	config.set_value("Audio settings", property_label, enable)
	_save_settings()

