extends Resource

class_name BurstEmptyResource

# Be careful, this is a copy paste from BurstResource
# but we can't easily define a common interface
# so one has to be vigilant to maintain both classes
# when touching one
var spawn_type = Projectile.ProjectyleType.Ally
var spawn_speed = -1
var spawn_delay = -1

export (float) var next_delay = 1.0
var duration = -1

var world_indexes = []
var sides = []
