extends Label

var level_number: int = 0:
	set(value):
		level_number = value
		update_text()

var wave_number: int = 0:
	set(value):
		wave_number = value
		update_text()

func _ready():
	Events.level_started.connect(_on_level_started)
	Events.wave_started.connect(_on_wave_started)

func update_text():
	self.text = "Level %d: Wave %d" % [level_number, wave_number]

func _on_level_started(level_index: int, _max_level_index: int):
	level_number = level_index + 1

func _on_wave_started(wave_index: int, _max_wave_index: int):
	wave_number = wave_index + 1
