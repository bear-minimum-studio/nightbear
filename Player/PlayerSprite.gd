extends Sprite2D

@export var player_path: NodePath

@onready var player = get_node(player_path)

const body_sprites = [preload("res://Player/bear1.png"), preload("res://Player/bear2.png")]

var region_id = 0

func initialize(father_region_id: int):
	region_id = father_region_id
	self.texture = body_sprites[region_id]

func set_orientation(horizontal_speed: float):
	var orientation = -sign(horizontal_speed) * abs(self.scale.x)
	self.scale.x = orientation
