@tool
extends Node2D
class_name Shape



@export var projectile_scene: PackedScene :
	set(value):
		projectile_scene = value
		if Engine.is_editor_hint() and is_node_ready():
			respawn()

# TODO: get child and use warnings instead?
## Holds animation for "appearance"
@export var animation_player: AnimationPlayer



# TODO: do nothing if already appeared / disappeared ?
@export var appear: bool = false :
	set(value):
		if not spawned: return
		animate_appearance(appearance_time)
		appear = false

@export_range(0.0, 5.0) var appearance_time : float = 1.0



# TODO: do nothing if already appeared / disappeared ?
@export var disappear: bool = false :
	set(value):
		if not spawned: return
		animate_disappearance(disappearance_time)
		disappear = false

@export_range(0.0, 1.0) var disappearance_time : float = 0.2



@export var collisions := true :
	set(value):
		if not spawned or not generated:
			collisions = value
			return
		
		var has_child_with_collisions := false
		for child in generated.get_children():
			if child.has_node('CollisionShape2D'):
				child.get_node('CollisionShape2D').disabled = not value
				has_child_with_collisions = true
		if not has_child_with_collisions:
			print('No child with collision in ', self)
		collisions = value



@export_range(0.0,20.0,0.5,"or_greater") var jitter := 0.0 :
	set(value):
		jitter = value
		_update_positions()



var items: Array # stores all projectiles in spawn order (a freed projectile is null)
var generated: GeneratedContainer
var spawned = false



func _ready():
	remove_duplicate_children()
	seed(Parameters.SEED)
	visibility_changed.connect(_on_visibility_changed)
	spawn()
	print(get_children(true))



## workaround a bug that doesn't free generated nodes when duplicating a Shape
func remove_duplicate_children():
	for child in get_children():
		if child is GeneratedContainer and child != generated:
			child.free()



func _on_visibility_changed():
	if not spawned: return
	if is_visible_in_tree():
		animate_appearance(appearance_time)
	else:
		animate_disappearance(disappearance_time)



# TODO: make animation selectable through export
func animate_appearance(time: float) -> void :
	if time == 0:
		animation_player.play("appearance")
		animation_player.advance(animation_player.current_animation_length)
	else:
		animation_player.speed_scale = 1 / time
		animation_player.play("appearance")



# TODO: make animation selectable through export
func animate_disappearance(time: float) -> void :
	if time == 0:
		animation_player.play_backwards("appearance")
		animation_player.advance(animation_player.current_animation_length)
	else:
		animation_player.speed_scale = 1 / time
		animation_player.play_backwards("appearance")



func appear_instant() -> void:
	collisions = true



func free_items():
	spawned = false
	for item in items:
		item.queue_free()
	items = []



func spawn():
	if not generated:
		generated = GeneratedContainer.new()
		add_child(generated, false, InternalMode.INTERNAL_MODE_FRONT)
	
	items.resize(get_nb_items())
	for i in range(items.size()):
		items[i] = _spawn_item(i)
	spawned = true



func respawn() -> void:
	free_items()
	spawn()


func _spawn_item(index: int):
	var spawned_instance = projectile_scene.instantiate()
	spawned_instance.transform.origin = item_position(index)
	generated.add_child(spawned_instance)
	return spawned_instance



func get_nb_items():
	pass



func item_position(index: int):
	pass



func _spawn_at_position(spawn_position: Vector2):
	var spawned_instance = projectile_scene.instantiate()
	spawned_instance.transform.origin = spawn_position
	generated.add_child(spawned_instance)
	return spawned_instance



func _update_positions():
	if items.size() < get_nb_items(): return
	
	for i in range(items.size()):
		var child = items[i]
		# a child may have been destroyed
		if child != null:
			child.transform.origin = item_position(i)
