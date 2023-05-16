extends Node

var game_scene = preload("res://World/Game.tscn")
var game : Control

var enet_peer = ENetMultiplayerPeer.new()

@onready var intro : Control = $Intro
@onready var network_menu : Control = $NetworkMenu
@onready var lobby = $Lobby

var currently_focused_scene : Control

var host_peer_id : int
var client_peer_id : int

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.intro_ended.connect(focus_scene.bind(network_menu))
	network_menu.hosting.connect(host_game)
	network_menu.joining.connect(join_game)
	network_menu.localing.connect(local_game)
	Events.replay_game.connect(replay_game)
	intro.show()


func focus_scene(scene: Control):
	if currently_focused_scene != null:
		currently_focused_scene.hide()
	scene.show()
	currently_focused_scene = scene

func start_game():
	game = game_scene.instantiate()
	add_child(game)
	focus_scene(game)
	lobby.show()

@rpc("call_local")
func lobby_ready():
	lobby.hide()
	game.start_level()

func replay_game():
	game.start_level()

func local_game():
	NetworkTools.local_multiplayer = true
	host_peer_id = multiplayer.get_unique_id()
	start_game()
	_spawn_player(0, host_peer_id)
	_spawn_player(1, host_peer_id)
	lobby_ready()

func host_game():
	NetworkTools.local_multiplayer = false
	enet_peer.create_server(NetworkTools.server_port, 1)
	multiplayer.multiplayer_peer = enet_peer
	host_peer_id = multiplayer.get_unique_id()
	multiplayer.peer_connected.connect(peer_connected)
	start_game()
	_spawn_player(0, host_peer_id)

func join_game(host_address_and_port: String):
	NetworkTools.local_multiplayer = false
	var address = NetworkTools.get_address(host_address_and_port)
	var port = NetworkTools.get_port(host_address_and_port)
	enet_peer.create_client(address, port)
	multiplayer.multiplayer_peer = enet_peer
	start_game()

func peer_connected(peer_id):
	client_peer_id = peer_id
	_spawn_player(1, client_peer_id)
	lobby_ready.rpc()

func _spawn_player(world_id: int, peer_id: int):
	game.worlds[world_id].spawn_player(peer_id)
	game.worlds[1 - world_id].spawn_player_shade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
