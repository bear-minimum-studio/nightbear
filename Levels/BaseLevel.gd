@icon("res://icons/BaseLevel.svg")
@tool
extends Control
class_name BaseLevel


## Has to be a BaseWorld
@export var world_scene : PackedScene :
	set(value):
		world_scene = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

## instantiated SplitScreen scene to render the world 
@export var split_screen : SplitScreen :
	set(value):
		split_screen = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

var world : BaseWorld


func _ready():
	anchors_preset = PRESET_FULL_RECT
	if not Engine.is_editor_hint():
		world = world_scene.instantiate()
		split_screen.world = world # world is added as a child of splitscreen's viewport0
		world.player_dead.connect(_on_player_dead)


func _get_configuration_warnings():
	var warning = []
	if not world_scene:
		warning.append('Missing world scene')
	if not split_screen:
		warning.append('Missing split screen node')
	return warning


@rpc("authority", "call_local", "reliable")
func start():
	world.start()


@rpc("authority", "call_local", "reliable")
func reload():
	print('reload level')
	world.queue_free()
	_ready()
	world.start()


func _on_player_dead(player_id):
	reload()


func set_player_authority(peer_id: int, player_id: int):
	world.set_player_authority(peer_id, player_id)
