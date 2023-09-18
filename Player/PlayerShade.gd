extends Sprite2D

const body_sprites = [preload("res://Player/paw1.png"), preload("res://Player/paw2.png")]

var region_id : int

## /!\ /!\ player.name is used to pass region_id (dirty) /!\ /!\
func _enter_tree():
	self.region_id = self.name.to_int()


func _ready():
	self.texture = body_sprites[1-region_id]

func move_shade(new_position: Vector2):
	transform.origin = new_position

@rpc("call_local", "any_peer")
func reset_position():
	move_shade(Vector2.ZERO)
