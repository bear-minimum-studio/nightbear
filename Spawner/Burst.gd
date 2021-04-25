extends Node

class_name Burst

signal BurstTimer_timeout
signal SpawnTimer_timeout

enum SpawnType {Ally, Enemy}

var id
var spawn_type = SpawnType.Enemy

var spawn_delay = 1.0
var duration = 1.5
var start_delay = 1.5

var sides = []
var nb_sides = sides.size()

onready var burst_timer = $BurstTimer
onready var spawn_timer = $SpawnTimer

func initialize(burst_index, burst_spawn_type, burst_spawn_delay: float, burst_duration: float, burst_sides: Array):
	id = burst_index
	
	spawn_type = burst_spawn_type
	
	spawn_delay = burst_spawn_delay
	duration = burst_duration
	
	sides = burst_sides
	nb_sides = burst_sides.size()
	
	if spawn_delay == 0:
		spawn_timer.one_shot = true
	
	if spawn_delay >= 0:
		spawn_timer.start(spawn_delay)
	
	if duration == 0:
		burst_timer.one_shot = true
		
	if duration >= 0:
		burst_timer.start(duration)

func _on_BurstTimer_timeout():
	emit_signal("BurstTimer_timeout", self)

func _on_SpawnTimer_timeout():
	emit_signal("SpawnTimer_timeout", self)
