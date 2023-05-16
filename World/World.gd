extends Node2D

var world_id : int

var player_scene = preload("res://Player/Player.tscn")
var player : Player

var player_shade_scene = preload("res://Player/PlayerShade.tscn")
var player_shade
#@onready var player = $Player
#@onready var player_shade = $PlayerShade
@onready var spawner_handler = $SpawnerHandler
@onready var multiplayer_spawner = $MultiplayerSpawner

var dream_caught = 0

func _ready():
	for side in [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]:
		var spawner = spawner_handler.spawners[side]
		var _unused = spawner.entity_spawned.connect(_on_entity_spawned)

func initialize(father_id: int):
	world_id = father_id
	spawner_handler.initialize(world_id)

## /!\ set player.name because it is automatically synchronized by MultiplayerSpawner 
## /!\ /!\ player.name is used to pass multiple variables (dirty) /!\ /!\
func spawn_player(peer_id: int):
	player = player_scene.instantiate()
	player.name = str(peer_id) + '_' + str(world_id)
	add_child(player)

## /!\ /!\ player.name is used to pass world_id (dirty) /!\ /!\
func spawn_player_shade():
	player_shade = player_shade_scene.instantiate()
	player_shade.name = str(world_id)
	add_child(player_shade)

func spawn_wall(pos: Transform2D):
	var new_wall = Parameters.GAME_WALL.instantiate()
	new_wall.transform.origin = pos.origin
	add_child(new_wall)

func spawn_dream_catcher(pos: Transform2D):
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instantiate()
	new_dream_catcher.transform.origin = pos.origin
	add_child(new_dream_catcher)

func _on_entity_spawned(instance):
	add_child(instance)
