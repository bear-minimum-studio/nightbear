extends Node

class_name Burst

signal BurstTimer_timeout
signal SpawnTimer_timeout

enum SpawnType {Ally, Enemy}

var id = 0
var spawn_type = SpawnType.Enemy
var spawn_speed = 10.0

var spawn_delay = 1.0
var duration = 1.5
var start_delay = 1.5

var sides = []
var nb_sides = sides.size()

onready var burst_timer = $BurstTimer
onready var spawn_timer = $SpawnTimer

func initialize(burst_index: int, burst_spawn_type, burst_spawn_speed: float, burst_spawn_delay: float, burst_duration: float, burst_sides: Array):
	id = burst_index
	
	spawn_type = burst_spawn_type
	spawn_speed = burst_spawn_speed
	
	spawn_delay = burst_spawn_delay
	duration = burst_duration
	
	sides = burst_sides
	nb_sides = burst_sides.size()
	
	if spawn_delay == 0:
		spawn_timer.one_shot = true
	
	if spawn_delay >= 0:
		spawn_delay = max(spawn_delay, 0.0001)
		spawn_timer.set_wait_time(spawn_delay)
		spawn_timer.start()
	
	if duration == 0:
		burst_timer.one_shot = true
		
	if duration >= 0:
		duration = max(duration, 0.0001)
		burst_timer.set_wait_time(duration)
		burst_timer.start()

func _on_BurstTimer_timeout():
	emit_signal("BurstTimer_timeout", self)

func _on_SpawnTimer_timeout():
	emit_signal("SpawnTimer_timeout", self)
