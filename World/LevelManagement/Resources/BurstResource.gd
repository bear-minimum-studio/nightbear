extends AbstractSequenceResource

class_name BurstResource

@export var spawn_type: Projectile.ProjectyleType = Projectile.ProjectyleType.Ally
@export var spawn_speed := 10.0
@export var world_1 := false
@export var world_2 := false
@export var spawn_delay := 1.0
@export var next_delay := 1.0
@export var duration := 1.0
@export var left := false
@export var right := false
@export var top := false
@export var bottom := false

var world_indexes = [] :
	get:
		var adapted_world_indexes = []
		if world_1:
			adapted_world_indexes.append(0)
		if world_2:
			adapted_world_indexes.append(1)
		return adapted_world_indexes

var sides = [] :
	get:
		var adapted_sides_array = []
		if left:
			adapted_sides_array.append(SpawnHandler.Sides.Left)
		if right:
			adapted_sides_array.append(SpawnHandler.Sides.Right)
		if top:
			adapted_sides_array.append(SpawnHandler.Sides.Top)
		if bottom:
			adapted_sides_array.append(SpawnHandler.Sides.Bottom)
		return adapted_sides_array
