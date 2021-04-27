extends Sprite

const body_sprites = [preload("res://Player/paw1.png"), preload("res://Player/paw2.png")]

var world_id = 0

func initialize(father_world_id: int):
	world_id = father_world_id
	self.texture = body_sprites[1-world_id]

func move_shade(position: Vector2):
	transform.origin = position
