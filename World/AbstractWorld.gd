extends Node2D

class_name AbstractWorld

var dream_caught = 0
var wave_index := 0
var number_of_waves : int :
	get: 
		var animations = animation_player.get_animation_list()
		var waves_animations = 0
		for i in range(animations.size()):
			if animations.has('wave%d' % i): # not counting RESET
				waves_animations += 1
		return waves_animations
var is_level_ended : bool :
	get: return wave_index >= number_of_waves


@onready var players : Array[Player] = [$Player0, $Player1]
@onready var camera_positions : Array[Vector2] = [$CameraPosition0.position, $CameraPosition1.position]

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	Events.build.connect(_build)

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

func next_wave():
	if is_level_ended:
		wave_index = -1
	
	var wave_name = "wave%d" % wave_index
	if animation_player.get_animation_list().has(wave_name):
		animation_player.play(wave_name)


func _on_wave_ended(_anim_name: StringName):
	wave_index += 1
	
	if is_level_ended:
		Events.level_ended.emit()
	else:
		Events.wave_ended.emit(wave_index)
