extends Resource

class_name BurstResource

export (Projectile.ProjectyleType) var spawn_type = Projectile.ProjectyleType.Ally
export (float) var spawn_speed = 10.0
export (Array, int) var world_indexes = [0]
export (float) var spawn_delay = 1.0
export (float) var next_delay = 1.0
export (float) var duration = 1.0
export (Array, SpawnHandler.Sides) var sides = [SpawnHandler.Sides.Left]
