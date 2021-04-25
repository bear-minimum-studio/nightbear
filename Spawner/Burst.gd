extends Node

class_name Burst

signal BurstTimer_timeout
signal SpawnTimer_timeout

var spawn_delay = 1.0
var duration = 1.5

var sides = []
var nb_sides = sides.size()

onready var burst_timer = $BurstTimer
onready var spawn_timer = $SpawnTimer

func initialize(burst_spawn_delay: float, burst_duration: float, burst_sides: Array):
	
	spawn_delay = burst_spawn_delay
	duration = burst_duration
	
	sides = burst_sides
	nb_sides = burst_sides.size()
	
	burst_timer.start(duration)
	spawn_timer.start(spawn_delay)

func _on_BurstTimer_timeout():
	emit_signal("BurstTimer_timeout", self)

func _on_SpawnTimer_timeout():
	emit_signal("SpawnTimer_timeout", self)
