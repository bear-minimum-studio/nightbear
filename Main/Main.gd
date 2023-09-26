extends Node

var enet_peer = ENetMultiplayerPeer.new()

@onready var game = $Game
@onready var lobby = $Lobby
@onready var intro = $Intro
@onready var menu_navigator = $MenuNavigator


var host_peer_id : int
var client_peer_id : int

var pause:
	get:
		return get_tree().paused
	set(value):
		get_tree().paused = value

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.quit_game.connect(quit_game)
	Events.play_intro.connect(play_intro)
	Events.resume_game.connect(exit_pause_menu)
	
	menu_navigator.exit_menu.connect(_on_exit_menu)
	
	Events.hosting.connect(host_game)
	Events.joining.connect(join_game)
	Events.localing.connect(local_game)
	
	Events.replay_game.connect(replay_game)
	
	Settings.load_settings()
	if Settings.first_execution:
		play_intro()
	else:
		menu_navigator.open(MenuNavigator.MENU.MAIN)

func quit_game():
	get_tree().quit()

func open_lobby():
	menu_navigator.close()
	game.show()
	lobby.show()

@rpc("call_local")
func lobby_ready():
	lobby.hide()
	game.start_level(0)

func replay_game():
	pause = false
	game.start_level(0)

func local_game():
	push_warning("LOCAL_GAME")
	NetworkTools.local_multiplayer = true
	host_peer_id = multiplayer.get_unique_id()
	open_lobby()
	game.add_player(host_peer_id, 0)
	game.add_player(host_peer_id, 1)
	lobby_ready()

func host_game(wan: bool):
	push_warning("SERVER")
	NetworkTools.local_multiplayer = false
	var server_port = NetworkTools.server_port if wan else NetworkTools.LOCAL_PORT
	enet_peer.create_server(server_port, 1)
	multiplayer.multiplayer_peer = enet_peer
	host_peer_id = multiplayer.get_unique_id()
	multiplayer.peer_connected.connect(peer_connected)
	open_lobby()
	game.add_player(host_peer_id, 0)

func join_game(host_address_and_port: String):
	push_warning("CLIENT")
	NetworkTools.local_multiplayer = false
	var address = NetworkTools.get_address(host_address_and_port)
	var port = NetworkTools.get_port(host_address_and_port)
	enet_peer.create_client(address, port)
	multiplayer.multiplayer_peer = enet_peer
	open_lobby()

func peer_connected(peer_id):
	client_peer_id = peer_id
	game.add_player(client_peer_id, 1)
	lobby_ready.rpc()

func play_intro():
	menu_navigator.close()
	Events.intro_ended.connect(end_intro)
	intro.init()
	intro.show()

func end_intro():
	Events.intro_ended.disconnect(end_intro)
	intro.hide()
	menu_navigator.open(MenuNavigator.MENU.MAIN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if false:
		print('blip')
	pass


# if a menu is opened by MenuNavigator, 'ui_cancel' (escape key) is set as handled before calling go_back()
# -> the escape key event only propagates in unhandled_input if no menu is open
#    in other words, 'pause' doesn't happen here if a menu is open
func _unhandled_input(event):
	if event.is_action_pressed('pause'):
		toggle_pause_menu()


func toggle_pause_menu():
	if pause:
		exit_pause_menu.rpc()
	else:
		open_pause_menu.rpc()

@rpc("call_local", "any_peer")
func open_pause_menu():
	if not game.is_running:
		return
	menu_navigator.open(MenuNavigator.MENU.PAUSE)
	pause = true

@rpc("call_local", "any_peer")
func exit_pause_menu():
	if not game.is_running:
		return
	menu_navigator.close()
	pause = false

func _on_exit_menu(menu):
	if menu == MenuNavigator.MENU.PAUSE:
		exit_pause_menu.rpc()
