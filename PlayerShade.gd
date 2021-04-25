extends Sprite

var id = 1

func initialize(player_id: int):
	id = player_id # Replace with function body.

func move_shade(position: Vector2):
	transform.origin = position
