extends SubViewportContainer

@export var world_id := 0

@export var camera_path: NodePath
@export var world_path: NodePath

@onready var camera = get_node(camera_path)
@onready var world = get_node(world_path)

func _ready():
	world.initialize(world_id)
	camera.position = world.position
