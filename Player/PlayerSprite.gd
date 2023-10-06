@tool
extends Sprite2D

const body_sprites = [preload("res://Player/bear0.png"), preload("res://Player/bear1.png")]

var player_id : int = 0:
	set(value):
		player_id = value
		texture = body_sprites[value]

func set_orientation(horizontal_speed: float):
	var orientation = -sign(horizontal_speed) * abs(scale.x)
	scale.x = orientation
