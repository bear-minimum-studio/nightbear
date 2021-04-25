extends Node

class_name Burst

signal BurstTimer_timeout
signal SpawnTimer_timeout
signal StartDelayTimer_timeout

enum SpawnType {Ally, Enemy}

var spawn_type = SpawnType.Enemy

var spawn_delay = 1.0
var duration = 1.5
var start_delay = 1.5

var sides = []
var nb_sides = sides.size()

onready var burst_timer = $BurstTimer
onready var spawn_timer = $SpawnTimer
onready var start_delay_timer = $StartDelayTimer

func initialize(burst_spawn_type, burst_spawn_delay: float, burst_duration: float, burst_start_delay : float, burst_sides: Array):
	spawn_type = burst_spawn_type
	
	spawn_delay = burst_spawn_delay
	duration = burst_duration
	start_delay = burst_start_delay
	
	sides = burst_sides
	nb_sides = burst_sides.size()
	
	burst_timer.start(duration)
	spawn_timer.start(spawn_delay)
	start_delay_timer.start(burst_start_delay)

func _on_BurstTimer_timeout():
	emit_signal("BurstTimer_timeout", self)

func _on_SpawnTimer_timeout():
	emit_signal("SpawnTimer_timeout", self)

func _on_StartDelayTimer_timeout():
	emit_signal("StartDelayTimer_timeout")
