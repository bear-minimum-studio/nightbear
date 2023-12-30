@icon("res://icons/BaseLevel.svg")
@tool
extends Control
class_name BaseLevel


## Has to be an AbstractWorld
@export var world_scene : PackedScene :
	set(value):
		world_scene = value
		update_configuration_warnings()

## instantiated SplitScreen scene to render the world 
@export var split_screen : SplitScreen :
	set(value):
		split_screen = value
		update_configuration_warnings()

var world : AbstractWorld


func _ready():
	anchors_preset = PRESET_FULL_RECT
	if not Engine.is_editor_hint():
		world = world_scene.instantiate()
		split_screen.world = world # world is added as a child of splitscreen's viewport0


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


func set_player_authority(peer_id: int, player_id: int):
	world.set_player_authority(peer_id, player_id)
