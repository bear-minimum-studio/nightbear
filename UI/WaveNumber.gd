extends Label


func next_wave(level_number: int, wave_number: int):
	self.text = "Level %d: Wave %d" % [level_number, wave_number]
