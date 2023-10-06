@tool
extends Sprite2D
class_name PlayerShade

const body_sprites = [preload("res://Player/paw0.png"), preload("res://Player/paw1.png")]

var player_id: int = 0:
	set(value):
		player_id = value
		texture = body_sprites[value]
