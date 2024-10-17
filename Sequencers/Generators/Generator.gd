@tool
extends Node2D
class_name Generator


# TODO:
#	- crashes when using a Shape as template in game (works in editor)
var ammo : GeneratorAmmo = null

var generated : Node2D

var items : Array[GeneratorAmmo] = []
var previous_frame_progress := progress


var is_pool_ready = false:
	set(value):
		is_pool_ready = value
		set_process(value)
		if debug_mode: print('pool ready:', value)


@export var pool_size : int = 100 :
	set(value):
		if pool_size != value:
			pool_size = value
			if Engine.is_editor_hint() and is_node_ready():
				await recreate_pool()


#TODO: fix behavior when animating interval 
@export_range(0.0, 1000.0, 5.0, "suffix:px") var interval : float = 100.0
@export_range(0.0, 10000.0, 5.0, "suffix:px") var progress : float = 0.0
@export_range(0.0, 360.0, 5.0,  "suffix:°") var shoot_angle : float = 0.0


## Editor only: Reallocate the whole pool, useful after a modification of the generator's ammo
@export var refresh_pool := false:
	set(value):
		if value:
			if Engine.is_editor_hint() and is_node_ready():
				await recreate_pool()
		refresh_pool = false


## Print function trace to debug in editor @tool
@export var debug_mode := false



func _ready() -> void:
	if Engine.is_editor_hint():
		child_entered_tree.connect(_on_child_entered_tree)
		child_exiting_tree.connect(_on_child_exiting_tree)
		update_configuration_warnings()
		print('ready')
	
	if not Engine.is_editor_hint():
		add_generated()
		ammo = find_ammo()
		create_pool()



# undefined behavior with more than one generation item
func find_ammo() -> GeneratorAmmo:
	for child in get_children():
		if child != generated and child is GeneratorAmmo:
			return child
	return null



func add_generated() -> void:
	if not generated:
		generated = Node2D.new()
		add_child(generated)



func is_ammo_set() -> bool:
	if debug_mode: print('is ammo set: ', (ammo != null) and ammo)
	return (ammo != null) and ammo



func create_pool() -> void:
	if debug_mode: print('creating pool')
	if not is_ammo_set(): return
	
	items.resize(pool_size)
	for i in range(items.size()):
		items[i] = ammo.duplicate()
		items[i].index = i
		generated.add_child(items[i])
	is_pool_ready = true
	update_items_progress() # initialize positions



func update_items_progress():
	var intervals_cumsum : float = 0
	for item in items:
		# hold the parameters when the item was shooted
		if not item.is_shooted():
			item.shoot_angle = deg_to_rad(shoot_angle)
			item.shoot_interval = interval
		
		var item_progress = max(0, progress - intervals_cumsum)
		item.set_progress(item_progress)
		intervals_cumsum += item.shoot_interval



func _process(_delta):
	if Engine.is_editor_hint():
		if not is_pool_ready: return
	
	if previous_frame_progress == progress: return
	
	previous_frame_progress = progress
	update_items_progress()



#region EDITOR @tool


func free_pool() -> void:
	if debug_mode: print('freeing pool')
	is_pool_ready = false
	if generated != null and generated:
		generated.queue_free()
		await generated.tree_exited
		generated = null
	print('freed generated: ', generated)
	items = []



func recreate_pool() -> void:
	if debug_mode: print('recreating pool?')
	await free_pool()
	if is_ammo_set():
		add_generated()
		create_pool()
	else:
		push_warning("Generator: Cannot recreate pool, ammo is not set")



func _on_child_exiting_tree(child: Node) -> void:
	if child == ammo:
		if debug_mode: print('GeneratorAmmo exiting tree')
		ammo = null
		free_pool.call_deferred() # wait for child to have exited the tree
		update_configuration_warnings()



func _on_child_entered_tree(child: Node) -> void:
	if child is GeneratorAmmo:
		if debug_mode: print('GeneratorAmmo entered tree')
		ammo = child
		ammo.ammo_changed.connect(_on_ammo_template_changed)
		recreate_pool.call_deferred()
		update_configuration_warnings()



func _on_ammo_template_changed() -> void:
	if debug_mode: print('on_ammo_template_changed')
	recreate_pool()



func _get_configuration_warnings():
	if debug_mode: print('updating configuration warning')
	var warning = []
	if not is_ammo_set():
		warning.append('Generator requires a GeneratorAmmo child')
	return warning


#endregion
