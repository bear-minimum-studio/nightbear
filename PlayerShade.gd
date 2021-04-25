extends Sprite

var id = 1

const body_sprites = {
	1: preload("res://Player/paw2.png"),
	2: preload("res://Player/paw1.png"),
}

func initialize(player_id: int):
	id = player_id
	self.texture = body_sprites[player_id]

func move_shade(position: Vector2):
	transform.origin = position
