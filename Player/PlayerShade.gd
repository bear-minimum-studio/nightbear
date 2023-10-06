@tool
extends Sprite2D
class_name PlayerShade

const body_sprites = [preload("res://Player/paw1.png"), preload("res://Player/paw0.png")]

var position_offset : Vector2
@export var player : Player:
	set(value):
		player = value
		texture = body_sprites[1 - player.region_id]
		position_offset = transform.origin - player.transform.origin

func _ready():
	if Engine.is_editor_hint(): return
	Events.player_moved.connect(_move_shade)
	
func _move_shade():
	transform.origin = player.transform.origin + position_offset
