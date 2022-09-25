extends Resource

class_name BurstResource

export (Projectile.ProjectyleType) var spawn_type = Projectile.ProjectyleType.Ally
export (float) var spawn_speed = 10.0
export (bool) var world_1 = false
export (bool) var world_2 = false
export (float) var spawn_delay = 1.0
export (float) var next_delay = 1.0
export (float) var duration = 1.0
export (bool) var left = false
export (bool) var right = false
export (bool) var top = false
export (bool) var bottom = false

var world_indexes = [] setget , _get_world_indexes
var sides = [] setget , _get_sides_array

func _get_world_indexes() -> Array:
	var adapted_world_indexes = []
	if world_1:
		adapted_world_indexes.append(0)
	if world_2:
		adapted_world_indexes.append(1)
	return adapted_world_indexes

func _get_sides_array() -> Array:
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
