extends Node2D

var player_scene = preload("res://Player/Player.tscn")
var players : Array[Player] = [null, null]

var player_shade_scene = preload("res://Player/PlayerShade.tscn")
var player_shades = [null, null]

@onready var spawner_handlers = [$SpawnerHandler0, $SpawnerHandler1]
@onready var spawn_positions : Array[Node] = [$SpawnPosition0, $SpawnPosition1]
@onready var multiplayer_spawner = $MultiplayerSpawner

@onready var region_0_to_1 : Vector2 :
	get: return spawn_positions[1].position - spawn_positions[0].position

@onready var region_1_to_0 : Vector2 :
	get: return - region_0_to_1


var dream_caught = 0

func _ready():
	Events.player_moved.connect(_move_player_shade)
	
	for spawner_handler in spawner_handlers:
		for side in [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]:
			var spawner = spawner_handler.spawners[side]
			var _unused = spawner.entity_spawned.connect(_on_entity_spawned)

func set_player_spawns():
	players[0].spawn_position = spawn_positions[0].position
	players[1].spawn_position = spawn_positions[1].position

## /!\ set player.name because it is automatically synchronized by MultiplayerSpawner 
## /!\ /!\ player.name is used to pass multiple variables (dirty) /!\ /!\
func spawn_player(peer_id: int, region_id: int):
	var new_player = player_scene.instantiate()
	new_player.name = str(peer_id) + '_' + str(region_id)
	new_player.transform.origin = spawn_positions[region_id].position
	players[region_id] = new_player
	add_child(new_player)

## /!\ /!\ player.name is used to pass world_id (dirty) /!\ /!\
func spawn_player_shade(region_id: int):
	var new_player_shade = player_shade_scene.instantiate()
	new_player_shade.name = str(region_id)
	new_player_shade.transform.origin = spawn_positions[1 - region_id].position
	player_shades[region_id] = new_player_shade
	add_child(new_player_shade)

func spawn_wall(region_id: int, pos: Transform2D):
	var new_wall = Parameters.GAME_WALL.instantiate()
	new_wall.transform.origin = pos.origin + translate_to_other_region(region_id)
	add_child(new_wall)

func spawn_dream_catcher(pos: Transform2D):
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instantiate()
	new_dream_catcher.transform.origin = pos.origin
	add_child(new_dream_catcher)

func _move_player_shade(region_id: int, new_position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.world_id != region_id:
			player_shade.move_shade(new_position + translate_to_other_region(region_id))

func translate_to_other_region(current_region: int):
	if current_region == 0:
		return region_0_to_1
	elif current_region == 1:
		return region_1_to_0

func _on_entity_spawned(instance):
	add_child(instance)
