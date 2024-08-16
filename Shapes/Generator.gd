@tool
extends Node2D
class_name Generator


var projectile : Node2D = null :
	set(value):
		if value != projectile:
			set_process(false)
			projectile = value
			if value == null:
				if debug_mode: print('no projectile')
				free_pool()
			else:
				projectile.visible = false
				if debug_mode: print('new projectile')
				recreate_pool()
				set_process(true)
		else:
			if debug_mode: print('projectile unchanged: ', value)



var generated : Node2D
var generated_changed := false

var items : Array = []
var previous_frame_progress := progress


@export var pool_size : int = 100 :
	set(value):
		if pool_size != value:
			set_process(false)
			pool_size = value
			recreate_pool()
			set_process(true)

#TODO: fix behavior when animating interval 
@export_range(0.0, 1000.0, 5.0, "suffix:px") var interval : float = 100.0
@export_range(0.0, 10000.0, 5.0, "suffix:px") var progress : float = 0.0
@export_range(0.0, 360.0, 5.0,  "suffix:°") var shoot_angle : float = 0.0

## Reallocate the whole pool, useful after a modification of the generator's projectile
@export var refresh_pool := false:
	set(value):
		set_process(false)
		recreate_pool()
		set_process(true)
		refresh_pool = false

@export var debug_mode := false


class Item:
	var index : int
	var shoot_angle : float = 0.0
	var shoot_interval : float = 0.0
	var projectile : Node2D
	
	func _init(_index: int, _projectile: Node2D) -> void:
		index = _index
		projectile = _projectile.duplicate()
	
	func is_shooted() -> bool:
		return projectile.position != Vector2.ZERO
	
	func set_distance(distance : float) -> void:
		projectile.position = distance * Vector2.from_angle(shoot_angle)
		projectile.rotation = shoot_angle
		if is_shooted() and not projectile.visible:
			projectile.show()
		elif not is_shooted() and projectile.visible:
			projectile.hide()



func _ready():
	add_generated()
	child_order_changed.connect(_on_child_changed)
	update_projectile()



func _on_child_changed() -> void:
	if debug_mode: print('child changed')
	update_projectile()
	update_configuration_warnings()



func find_projectile() -> Node2D:
	for child in get_children():
		if child != generated:
			return child
	return null



func update_projectile() -> void:
	# set projectile as first child that's not generated or null
	if debug_mode: print('updating projectile')
	projectile = find_projectile()



func _get_configuration_warnings():
	if debug_mode: print('updating configuration warning')
	var warning = []
	if not is_projectile_set():
		warning.append('Generator requires a child node or scene (Node2D) as template projectile')
	return warning



func remove_generated_projectiles() -> void:
	for child in generated.get_children():
		child.queue_free()



func add_generated() -> void:
	if not generated:
		generated = Node2D.new()
		generated_changed = true
		add_child(generated)



func free_pool() -> void:
	if debug_mode: print('freeing pool')
	set_process(false)
	if generated:
		remove_generated_projectiles()
	items = []



func is_projectile_set() -> bool:
	if debug_mode: print('is projectile set: ', (projectile != null) and projectile)
	return (projectile != null) and projectile



func recreate_pool() -> void:
	if debug_mode: print('recreating pool?')
	free_pool()
	if is_projectile_set():
		create_pool()
	else:
		push_warning("Generator: Cannot recreate pool, projectile is not set")



func create_pool() -> void:
	if debug_mode: print('creating pool')
	items.resize(pool_size)
	for i in range(items.size()):
		items[i] = Item.new(i, projectile)
		generated.add_child(items[i].projectile)
	update_positions() # initialize positions



func update_positions():
	var intervals_cumsum : float = 0
	for item in items:
		# hold the parameters when the item was shooted 
		if not item.is_shooted():
			item.shoot_angle = deg_to_rad(shoot_angle)
			item.shoot_interval = interval
		
		var distance = max(0, progress - intervals_cumsum)
		item.set_distance(distance)
		intervals_cumsum += item.shoot_interval



func _process(_delta):
	#if Engine.is_editor_hint(): return
	if previous_frame_progress == progress: return
	
	previous_frame_progress = progress
	update_positions()
