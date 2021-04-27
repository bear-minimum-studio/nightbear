extends ViewportContainer

export (int) var world_id = 0

export (NodePath) var camera_path
export (NodePath) var world_path

onready var camera = get_node(camera_path)
onready var world = get_node(world_path)

func _ready():
	world.initialize(world_id)
	camera.position = world.position
