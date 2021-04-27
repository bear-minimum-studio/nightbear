extends Sprite

export(NodePath) var player_path

onready var player = get_node(player_path)

const body_sprites = [preload("res://Player/bear1.png"), preload("res://Player/bear2.png")]

var world_id = 0

func initialize(father_world_id: int):
	world_id = father_world_id
	self.texture = body_sprites[world_id]

func set_orientation(horizontal_speed: float):
	var orientation = -sign(horizontal_speed) * abs(self.scale.x)
	self.scale.x = orientation
