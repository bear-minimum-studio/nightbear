@tool
extends Path2D
class_name PathSequencer



#@export_range(0.0, 10000.0, 5.0, "suffix:px") var progress : float = 0.0
@export_range(0.0, 1.0, 0.001, "or_greater") var progress_ratio : float = 0.0 :
	set(value):
		progress_ratio = value
		broadcast()

@export var interval_ratio : float = 0.0 :
	set(value):
		interval_ratio = value
		broadcast()

@export var h_offset : float = 0 :
	set(value):
		h_offset = value
		broadcast()

@export var v_offset : float = 0 :
	set(value):
		v_offset = value
		broadcast()

@export var rotates := true :
	set(value):
		rotates = value
		broadcast()

@export var cubic_interp := true :
	set(value):
		cubic_interp = value
		broadcast()

@export var loop := true :
	set(value):
		loop = value
		broadcast()



var sequence : Sequence :
	set(value):
		update_configuration_warnings()
		if sequence != null:
			sequence.sequence_changed.disconnect(_on_sequence_changed)
		if value != null:
			value.sequence_changed.connect(_on_sequence_changed)
		sequence = value

var items : Array[Item]



class Item:
	var index: int
	var node: Node2D
	var parent: Node2D
	var path_follow : PathFollow2D
	
	func _init(_index: int, _node: Node2D, _parent: Node2D):
		index = _index
		node = _node
		parent = _parent
		path_follow = PathFollow2D.new()
		parent.add_child.call_deferred(path_follow) # wait for parent to be ready
	
	func queue_free():
		path_follow.queue_free()
	
	func update():
		node.position = path_follow.position - node.get_parent().position
		node.rotation = path_follow.rotation - node.get_parent().rotation



func _ready() -> void:
	sequence = get_sequence()
	init_items()
	child_entered_tree.connect(_on_child_entered_tree)
	child_order_changed.connect(_on_child_order_changed)
	draw.connect(broadcast) # move sequence with path canvas



func _on_child_order_changed() -> void:
	if not sequence: return
	# if the sequence node is moved elsewhere in tree
	if sequence.get_parent() != self:
		sequence = null
		clear_items()



func clear_items() -> void:
	for item in items:
		item.queue_free()
	items = []



func _on_child_entered_tree(node: Node) -> void:
	if not is_node_ready(): return
	
	if node is Sequence:
		if sequence and sequence != node:
			push_error("A sequence already exists for PathSequencer ", self)
		sequence = node
		init_items()



func init_items() -> void:
	clear_items()
	
	if not sequence: return
	
	var i = 0
	for child in sequence.get_children():
		items.append(Item.new(i,child,self))
		i += 1
	broadcast.call_deferred()



func _on_sequence_changed():
	init_items()



func broadcast():
	for item in items:
		var path = item.path_follow
		
		path.progress_ratio = max(0, progress_ratio - interval_ratio * item.index)
		
		path.h_offset = h_offset
		path.v_offset = v_offset
		path.cubic_interp = cubic_interp
		path.rotates = rotates
		path.loop = loop
		
		item.update()



func get_sequence() -> Sequence:
	var sequences =  get_children().filter(func(x): return x is Sequence)
	if sequences.size() > 0:
		return sequences[0]
	else:
		return null



func _get_configuration_warnings() -> PackedStringArray:
	var warning = []
	if not sequence:
		warning.append('Requires a Sequence')
	return warning
