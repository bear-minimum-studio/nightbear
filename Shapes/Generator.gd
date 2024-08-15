@tool
extends Node2D
class_name Generator



@export var projectile : PackedScene :
	set(value):
		projectile = value
		if Engine.is_editor_hint():
			recreate_pool()

@export var pool_size : int = 100 :
	set(value):
		pool_size = value
		if Engine.is_editor_hint():
			recreate_pool()

#TODO: fix behavior when animating interval 
@export_range(0.0, 1000.0, 5.0, "suffix:px") var interval : float = 100.0
@export_range(0.0, 10000.0, 5.0, "suffix:px") var progress : float = 0.0
@export_range(0.0, 360.0, 5.0,  "suffix:°") var shoot_angle : float = 0.0

var items : Array = []
var previous_frame_progress := progress

class Item:
	var index : int
	var shoot_angle : float = 0.0
	var shoot_interval : float = 0.0
	var projectile : Node2D
	
	func _init(_index: int, _projectile: PackedScene) -> void:
		index = _index
		projectile = _projectile.instantiate()
	
	func is_shooted() -> bool:
		return projectile.position != Vector2.ZERO
	
	func update_position(progress) -> void:
		var distance = max(0, progress - shoot_interval * index)
		projectile.position = distance * Vector2.from_angle(shoot_angle)
		projectile.rotation = shoot_angle
		
	func queue_free() -> void:
		if projectile != null:
			projectile.queue_free()



func _ready():
	recreate_pool()



func recreate_pool() -> void:
	for item in items:
		#item == null
		if item != null:
			item.queue_free()
		
	items.resize(pool_size)
	for i in range(items.size()):
		items[i] = Item.new(i, projectile)
		add_child(items[i].projectile)



func _process(delta):
	#if Engine.is_editor_hint(): return
	if previous_frame_progress == progress: return
	
	previous_frame_progress = progress
	if items[0] == null: return
	for item in items:
		# hold the parameters when the item was shooted 
		if not item.is_shooted():
			item.shoot_angle = deg_to_rad(shoot_angle)
			item.shoot_interval = interval
		item.update_position(progress)
		
