extends Node

var game_scene = preload("res://World/Game.tscn")
var game : Control

var enet_peer = ENetMultiplayerPeer.new()

@onready var menu_navigator = $MenuNavigator
@onready var lobby = $Lobby


var host_peer_id : int
var client_peer_id : int

# Called when the node enters the scene tree for the first time.
func _ready():
#	Events.intro_ended.connect(focus_scene.bind(network_menu))
#	intro.show()
	Events.quit_game.connect(quit_game)
	Events.hosting.connect(host_game)
	Events.joining.connect(join_game)
	Events.localing.connect(local_game)
	Events.replay_game.connect(replay_game)
	menu_navigator.open(MenuNavigator.MENU.MAIN)

func quit_game():
	get_tree().quit()

func start_game():
	game = game_scene.instantiate()
	add_child(game)
	menu_navigator.close()
	game.show()
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

func host_game(wan: bool):
	NetworkTools.local_multiplayer = false
	var server_port = NetworkTools.server_port if wan else NetworkTools.LOCAL_PORT
	enet_peer.create_server(server_port, 1)
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
