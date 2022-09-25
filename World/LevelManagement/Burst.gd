extends "res://World/LevelManagement/SequenceElement.gd"

class_name Burst

var spawn_type: int
var spawn_parameters: Dictionary

var spawner_handlers: Array
var spawn_delay: float
var next_delay: float
var duration: float

var sides: Array
var nb_sides: int

onready var spawn_timer := $SpawnTimer
onready var next_timer := $NextTimer
onready var burst_timer := $BurstTimer

func initialize(squence_id: String, element_description: Resource, father_node: SequenceElement, father_worlds: Array) -> void:
	.initialize(squence_id, element_description, father_node, father_worlds)

	spawn_type = element_description.spawn_type
	spawn_parameters = {
		"speed": element_description.spawn_speed
	}

	spawner_handlers = []
	for world_index in element_description.world_indexes:
		spawner_handlers.push_back(worlds[world_index].spawner_handler)
	spawn_delay = element_description.spawn_delay
	next_delay = element_description.next_delay
	duration = element_description.duration
	
	sides = element_description.sides
	nb_sides = sides.size()

func _spawn() -> void:
	for spawner_handler in spawner_handlers:
		spawner_handler.spawn(spawn_type, spawn_parameters, sides)

func play(_element_index: int) -> void:
	_set_spawn_timer()
	_set_burst_timer()
	_set_next_timer()

func next() -> void:
	_father_next()
	end()

func stop() -> void:
	next_timer.stop()

func element_ended() -> bool:
	return spawn_timer.is_stopped() and next_timer.is_stopped()

func _set_spawn_timer() -> void:
	if spawn_delay == 0:
		_spawn()
	elif spawn_delay > 0:
		spawn_timer.set_wait_time(spawn_delay)
		spawn_timer.start()

func _end_spawn() -> void:
	spawn_timer.stop()
	end()

func _set_next_timer() -> void:
	if next_delay == 0:
		next()
	elif next_delay > 0:
		next_timer.set_wait_time(next_delay)
		next_timer.start()

func _set_burst_timer() -> void:
	if duration == 0:
		_end_spawn()
	elif duration > 0:
		burst_timer.set_wait_time(duration)
		burst_timer.start()

func _on_SpawnTimer_timeout() -> void:
	_spawn()

func _on_NextTimer_timeout() -> void:
	next()

func _on_BurstTimer_timeout() -> void:
	_end_spawn()
