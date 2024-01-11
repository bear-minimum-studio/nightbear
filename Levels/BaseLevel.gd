@icon("res://icons/BaseLevel.svg")
@tool
extends Control
class_name BaseLevel


signal client_world_reloaded
signal world_reloaded

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

var is_client_world_reloaded := false

## copy of the player_ids and their matching peer_ids as last set by Game 
var player_authorities := {}


func _ready():
	anchors_preset = PRESET_FULL_RECT
	if not Engine.is_editor_hint():
		load_world()


func _get_configuration_warnings():
	var warning = []
	if not world_scene:
		warning.append('Missing world scene')
	if not split_screen:
		warning.append('Missing split screen node')
	return warning


func load_world():
	world = world_scene.instantiate()
	split_screen.world = world # world is added as a child of splitscreen's viewport0
	world.player_dead.connect(_on_player_dead)


@rpc("authority", "call_local", "reliable")
func start():
	world.start()


@rpc("authority", "call_local", "reliable")
func reload():
	print('Reloading world')
	world.queue_free()
	await world.tree_exited
	load_world()
	
	if not is_multiplayer_authority():
		notify_client_world_reloaded.rpc()
		
	if not NetworkTools.local_multiplayer and is_multiplayer_authority():
		if not is_client_world_reloaded:
			await client_world_reloaded
		is_client_world_reloaded = false
		
		for player_id in player_authorities.keys():
			set_player_authority.rpc(player_authorities[player_id], player_id)
	
	if is_multiplayer_authority():
		world_reloaded.emit()


@rpc("any_peer", "call_remote", "reliable")
func notify_client_world_reloaded():
	is_client_world_reloaded = true
	client_world_reloaded.emit()


func _on_player_dead(player_id: int):
	if is_multiplayer_authority():
		reload.rpc()
		await world_reloaded
		start.rpc()


@rpc("authority", "call_local", "reliable")
func set_player_authority(peer_id: int, player_id: int):
	player_authorities[player_id] = peer_id
	world.set_player_authority(peer_id, player_id)
