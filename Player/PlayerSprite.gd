extends Sprite

export(NodePath) var player_path

onready var player = get_node(player_path)

const body_sprites = {
	1: preload("res://Player/bear_1_R.png"),
	2: preload("res://Player/bear_2_R.png"),
}

var id = 1

func initialize(father_id: int):
	self.texture = body_sprites[father_id]

func set_orientation(horizontal_speed: float):
	var orientation = sign(horizontal_speed) * abs(self.scale.x)
	self.scale.x = orientation
