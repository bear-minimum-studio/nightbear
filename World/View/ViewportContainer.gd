extends SubViewportContainer

@onready var sub_viewport = $SubViewport
@onready var camera_2d = $SubViewport/Camera2D

var world: Node2D:
	set(value):
		var player
		var player_shade
		if world != null:
			player = world.player
			world.remove_child(world.player)
			player_shade = world.player_shade
			world.remove_child(world.player_shade)
			sub_viewport.remove_child(world)
			world.queue_free()
		world = value
		if player != null:
			value.player = player
			value.add_child(player)
		if player_shade != null:
			value.player_shade = player_shade
			value.add_child(player_shade)
		value.initialize(world_id)
		value.position = Vector2.ZERO
		camera.position = value.position
		sub_viewport.add_child(value)
