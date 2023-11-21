extends Node2D

class_name AbstractWorld

var dream_caught = 0
var wave_index := 0
var max_wave_index : int :
	get: 
		var animations = animation_player.get_animation_list()
		var waves_animations = 0
		for i in range(animations.size()):
			if animations.has('wave%d' % i): # not counting RESET
				waves_animations += 1
		return max(waves_animations - 1, 0)


@onready var players : Array[Player] = [$Player0, $Player1]
@onready var camera_positions : Array[Vector2] = [$CameraPosition0.position, $CameraPosition1.position]

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	Events.build.connect(_build)

func _physics_process(_delta):
	if Input.is_action_just_pressed("next_wave"):
		_on_wave_ended.rpc("")

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

func _on_entity_spawned(instance):
	add_child(instance)

@rpc("authority", "call_local", "reliable")
func start():
	_start_wave(0)

@rpc("authority", "call_local", "reliable")
func _start_wave(index: int):
	wave_index = index
	var wave_name = "wave%d" % index
	if animation_player.get_animation_list().has(wave_name):
		animation_player.play(wave_name)
		Events.wave_started.emit(index, max_wave_index)

@rpc("any_peer", "call_local", "reliable")
func _on_wave_ended(_anim_name: StringName):
	Events.wave_ended.emit(wave_index, max_wave_index)
	var next_wave_index = wave_index + 1
	if next_wave_index <= max_wave_index:
		_start_wave(next_wave_index)
