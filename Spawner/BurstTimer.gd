extends Timer

signal BurstTimer_timeout

var burst

func initialize(father_burst):
	burst = father_burst

func _on_BurstTimer_timeout():
	emit_signal("BurstTimer_timeout", burst)
