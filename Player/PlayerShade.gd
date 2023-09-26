extends Sprite2D
class_name PlayerShade

const body_sprites = [preload("res://Player/paw1.png"), preload("res://Player/paw2.png")]

var player : Player
var position_offset : Vector2

func _ready():
	self.texture = body_sprites[1 - player.region_id]

func move_shade():
	transform.origin = player.transform.origin + position_offset
