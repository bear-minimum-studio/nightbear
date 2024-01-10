extends Node2D
class_name BaseWorld



signal player_dead(player_id: int)


## Add player by instantiating child scene -> player.tscn
## You probably want to set different IDs for each player
@export var player_0: Player :
	set(node):
		player_0 = node
		player_0.dead.connect(_on_player_dead)

## Add player by instantiating child scene -> player.tscn
## You probably want to set different IDs for each player
@export var player_1: Player :
	set(node):
		player_1 = node
		player_1.dead.connect(_on_player_dead)

## Add Child Node -> ProxyCamera
## Proxy camera transform and zoom will be replicated on the left actual camera in SpliScreen
@export var proxy_camera_0: ProxyCamera

## Add Child Node -> ProxyCamera
## Proxy camera transform and zoom will be replicated on the right actual cameras in SpliScreen
@export var proxy_camera_1: ProxyCamera

## Add Child Node -> LevelPlayback
## Handles the animation of the level (waves, enemies, display inside the individual viewports...)
@export var level_playback: LevelPlayback :
	set(node):
		level_playback = node
		level_playback.playback_ended.connect(_on_playback_ended)


var players : Array[Player] :
	get: return [player_0, player_1]

var dream_caught = 0
var wave_index := 0



func _ready():
	Events.build.connect(_build)


# TODO: move to state machine
#func _physics_process(_delta):
	#if Input.is_action_just_pressed("next_wave"):
		#_on_wave_ended.rpc("")


func set_player_authority(peer_id: int, player_id: int):
	players[player_id].peer_id = peer_id


func spawn_shield(player: Player):
	var new_shield = Parameters.GAME_SHIELD.instantiate()
	new_shield.transform.origin = player.player_shade.global_position
	add_child(new_shield)


func spawn_dream_catcher(player: Player):
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instantiate()
	new_dream_catcher.transform.origin = player.global_position
	add_child(new_dream_catcher)


func _build(player: Player):
	spawn_shield(player)
	spawn_dream_catcher(player)


@rpc("authority", "call_local", "reliable")
func start():
	level_playback.start()


@rpc("authority", "call_local", "reliable")
func stop():
	level_playback.stop()


# TODO: clean up everything that listens to Events.wave_started
#@rpc("authority", "call_local", "reliable")
#func _start_wave(index: int):
	#wave_index = index
	#var wave_name = "wave%d" % index
	#if animation_player.get_animation_list().has(wave_name):
		#animation_player.play(wave_name)
		#Events.wave_started.emit(index, max_wave_index)


func _on_playback_ended():
	Events.level_ended.emit()


func _on_player_dead(player_id):
	player_dead.emit(player_id)

