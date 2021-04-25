extends Timer

signal SpawnTimer_timeout

export (int) var burst_id = 0

func initialize(father_burst_id):
	burst_id = father_burst_id

func _on_SpawnTimer_timeout():
	emit_signal("SpawnTimer_timeout", burst_id)
