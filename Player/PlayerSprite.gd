extends Sprite

export(NodePath) var player_path

onready var player = get_node(player_path)

# TODO refactor into int
const body_sprites = {
	"1": preload("res://Player/bear_1.png"),
	"2": preload("res://Player/bear_2.png"),
}

var id = 1

func _ready():
	self.texture = body_sprites[player.id]
